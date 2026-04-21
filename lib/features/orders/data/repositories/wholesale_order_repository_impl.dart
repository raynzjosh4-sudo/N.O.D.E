import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/core/utils/color_utils.dart';
import 'package:node_app/features/auth/domain/entities/business_profile.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/core/domain/entities/location.dart';
import 'package:node_app/features/home/presentation/pages/specificationorderpage/order_models.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:node_app/features/home/presentation/pages/notifications/data/notification_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WholesaleOrderRepositoryImpl {
  final SupabaseClient _client;
  final AppDatabase _db;
  final NotificationRepository _notificationRepo;

  WholesaleOrderRepositoryImpl(this._client, this._db, this._notificationRepo);

  /// Officially sends an order to the supplier via the 'supplier_orders' table.
  /// This bridges the user's order to the wholesaler's dashboard.
  Future<Either<Failure, Unit>> sendToSupplier({
    required WholesaleOrder order,
    required BusinessProfile business,
    String? pdfUrl,
    String? userId,
  }) async {
    try {
      final effectiveUserId = userId ?? _client.auth.currentSession?.user.id;
      if (effectiveUserId == null)
        return const Left(ServerFailure('User not authenticated'));

      final entriesJson = jsonEncode(
        order.entries.map((e) => e.toMap()).toList(),
      );

      print(
        '📤 [OrderRepo] Sending order ${order.id} to supplier ${order.supplierId}...',
      );

      // Build the payload — try with pdf_url first, fall back without it if column is missing
      final payload = {
        'order_id': order.id,
        'user_id': effectiveUserId,
        'supplier_id': order.supplierId ?? '',
        'business_name': business.legalName,
        'business_phone': business.phoneNumber ?? '',
        'business_city': business.city ?? '',
        'business_address': business.physicalAddress ?? '',
        'latitude': business.latitude,
        'longitude': business.longitude,
        'total_amount': order.totalAmount,
        'entries_json': jsonDecode(entriesJson),
        'pdf_id': order.pdfId,
        'pdf_url': pdfUrl, // 📄 Attached PDF link for supplier
        'status': 'new',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      };

      try {
        await _client
            .from('supplier_orders')
            .upsert(payload, onConflict: 'order_id');
      } catch (e) {
        final errorStr = e.toString();

        // 🛡️ SELF-HEALING: Detect Foreign Key Violation (23503) or Missing Column
        if (errorStr.contains('23503') ||
            errorStr.contains('violates foreign key constraint')) {
          print(
            '🛡️ [OrderRepo] FK Violation in supplier_orders (PDF sync lag). Retrying without pdf_id/pdf_url...',
          );
          final fallback = Map<String, dynamic>.from(payload)
            ..remove('pdf_id')
            ..remove('pdf_url');
          await _client
              .from('supplier_orders')
              .upsert(fallback, onConflict: 'order_id');
        } else if (errorStr.contains('pdf_url') &&
            errorStr.contains('schema cache')) {
          // Column doesn't exist yet — retry without it
          print(
            '⚠️ [OrderRepo] pdf_url column missing, retrying without it...',
          );
          final fallback = Map<String, dynamic>.from(payload)
            ..remove('pdf_url');
          await _client
              .from('supplier_orders')
              .upsert(fallback, onConflict: 'order_id');
        } else {
          rethrow;
        }
      }

      print('✅ [OrderRepo] Order sent to supplier successfully.');

      // 🧨 TRANSFER & DESTROY: Now that the order is safely at the supplier,
      // we remove it from the pending/active list JUST on the draft side.
      final deleteResult = await _deleteDraftOnly(order.id);

      return deleteResult;
    } catch (e) {
      print('❌ [OrderRepo] SEND TO SUPPLIER FAILED: $e');
      return Left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, Unit>> saveOrder(
    WholesaleOrder order,
    String userId,
  ) async {
    try {
      final entriesJson = jsonEncode(
        order.entries.map((e) => e.toMap()).toList(),
      );

      // 🛡️ WhatsApp-Style Protection: Detect if this order is already "Submitted" on the server.
      // If it is, we MUST NOT overwrite it with "pending" just because the local copy is old.
      String targetStatus = order.status.name.toLowerCase();
      try {
        final existing = await _client
            .from('orders_table')
            .select('status')
            .eq('id', order.id)
            .maybeSingle();

        if (existing != null &&
            (existing['status'] as String).toLowerCase() == 'submitted') {
          targetStatus = 'submitted';
          print(
            '🛡️ [OrderRepo] Smart Protect: Keeping "submitted" status for ${order.id}',
          );
        }
      } catch (e) {
        print(
          '⚠️ [OrderRepo] Status check failed, proceeding with local status: $e',
        );
      }

      // 💾 1. Save to local Drift database FIRST (Local Level)
      print(
        '💾 [OrderRepo] Saving order ${order.id} to local Drift database...',
      );
      await _db
          .into(_db.ordersTable)
          .insertOnConflictUpdate(
            OrdersTableCompanion.insert(
              id: order.id,
              userId: userId,
              itemsJson: entriesJson,
              totalAmount: order.totalAmount,
              totalUnits: order.totalUnits,
              status: drift.Value(order.status.name.toUpperCase()),
              pdfId: drift.Value(order.pdfId),
              productId: drift.Value(order.productId),
              supplierId: drift.Value(order.supplierId),
              createdAt: drift.Value(order.date),
              updatedAt: drift.Value(DateTime.now()),
            ),
          );
      print('✅ [OrderRepo] Order ${order.id} saved to local Drift.');

      // 🌐 2. Sync to Supabase in the background (Replication)
      try {
        final payload = {
          'id': order.id,
          'user_id': userId,
          'total_amount': order.totalAmount,
          'pdf_id': order.pdfId,
          'status': targetStatus,
          'entries_json': jsonDecode(entriesJson),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
          'created_at': order.date.toUtc().toIso8601String(),
        };

        await _client.from('orders_table').upsert(payload, onConflict: 'id');
        print('✅ [OrderRepo] Order ${order.id} synced to cloud.');
      } catch (e) {
        final errorStr = e.toString();
        // 🛡️ SELF-HEALING: Detect Foreign Key Violation (23503)
        // Usually means the PDF Manifest hasn't synced to Supabase yet.
        if (errorStr.contains('23503') ||
            errorStr.contains('violates foreign key constraint')) {
          print(
            '🛡️ [OrderRepo] FK Violation detected (PDF sync lag). Retrying sync without pdf_id...',
          );
          try {
            await _client.from('orders_table').upsert({
              'id': order.id,
              'user_id': userId,
              'total_amount': order.totalAmount,
              'status': targetStatus,
              'entries_json': jsonDecode(entriesJson),
              'updated_at': DateTime.now().toUtc().toIso8601String(),
              'created_at': order.date.toUtc().toIso8601String(),
            }, onConflict: 'id');
            print(
              '✅ [OrderRepo] Self-healing sync successful: Order saved without PDF link.',
            );
          } catch (retryError) {
            print('❌ [OrderRepo] Critical sync failure: $retryError');
          }
        } else {
          print(
            '⚠️ [OrderRepo] Cloud sync failed, but local save succeeded: $e',
          );
        }
      }

      // 3. Create In-App Notification (Remote)
      final productName =
          order.entries.firstOrNull?.savedProduct.product.name ??
          'a wholesale product';
      await _notificationRepo.createNotification(
        userId: userId,
        title: 'Wholesale Order Created',
        description: 'New spec sheet for $productName generated and archived.',
        category: 'orders',
        metadata: {
          'orderId': order.id,
          'productId': order.productId,
          'type': 'order_created',
        },
      );

      return const Right(unit);
    } catch (e) {
      print('❌ [OrderRepo] SAVE FAILED: $e');
      return Left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, List<WholesaleOrder>>> getOrders(
    String userId, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      print(
        '📥 [OrderRepo] Fetching orders for user $userId (Pagination: L$limit, O$offset)...',
      );

      // 💾 1. Get from Local Drift first
      final localRows =
          await (_db.select(_db.ordersTable)
                ..where((t) => t.userId.equals(userId))
                ..where((t) => t.status.equals('PENDING'))
                ..orderBy([
                  (t) => drift.OrderingTerm(
                    expression: t.createdAt,
                    mode: drift.OrderingMode.desc,
                  ),
                ])
                ..limit(limit, offset: offset))
              .get();

      final orders = localRows.map((row) => _driftToDomain(row)).toList();
      print('✅ [OrderRepo] Fetched ${orders.length} orders from local DB.');

      // 🌐 2. Trigger Background Sync from Supabase
      // Only do reconciliation on the first page to avoid redundant checks
      _syncPendingOrdersFromCloud(userId, reconcile: offset == 0);

      return Right(orders);
    } catch (e) {
      print('❌ [OrderRepo] GET ORDERS FAILED: $e');
      return Left(Failure.fromException(e));
    }
  }

  /// Background helper to sync cloud orders to local drift storage.
  /// If [reconcile] is true, it will delete local records that do not exist in the cloud.
  Future<void> _syncPendingOrdersFromCloud(
    String userId, {
    bool reconcile = false,
  }) async {
    try {
      // 1. Fetch cloud records for this user
      final response = await _client
          .from('orders_table')
          .select(
            'id, entries_json, total_amount, total_units, status, pdf_id, product_id, supplier_id, created_at, updated_at',
          )
          .eq('user_id', userId)
          .eq('status', 'pending');

      final List<dynamic> data = response as List;
      final Set<String> cloudIds = data
          .map((row) => row['id'] as String)
          .toSet();

      // 2. Reconciliation: Purge local ghost data
      if (reconcile) {
        final localPending =
            await (_db.select(_db.ordersTable)
                  ..where((t) => t.userId.equals(userId))
                  ..where((t) => t.status.equals('PENDING')))
                .get();

        for (final local in localPending) {
          if (!cloudIds.contains(local.id)) {
            // Check age to avoid deleting brand new local drafts that haven't synced yet
            final age = DateTime.now().difference(
              local.createdAt ?? DateTime.now(),
            );
            if (age.inMinutes > 5) {
              print(
                '🧹 [OrderRepo] Reconciliation: Deleting ghost local order ${local.id}',
              );
              await (_db.delete(
                _db.ordersTable,
              )..where((t) => t.id.equals(local.id))).go();
            }
          }
        }
      }

      // 3. Upsert/Update from cloud
      for (final row in data) {
        final order = _rowToDomain(row);
        await _db
            .into(_db.ordersTable)
            .insertOnConflictUpdate(
              OrdersTableCompanion.insert(
                id: order.id,
                userId: userId,
                itemsJson: jsonEncode(
                  order.entries.map((e) => e.toMap()).toList(),
                ),
                totalAmount: order.totalAmount,
                totalUnits: order.totalUnits,
                status: drift.Value(order.status.name.toUpperCase()),
                pdfId: drift.Value(order.pdfId),
                productId: drift.Value(order.productId),
                supplierId: drift.Value(order.supplierId),
                createdAt: drift.Value(order.date),
                updatedAt: drift.Value(DateTime.now()),
              ),
            );
      }
      print(
        '🔄 [OrderRepo] Background cloud sync & reconciliation complete for $userId.',
      );
    } catch (e) {
      print('⚠️ [OrderRepo] Background sync error: $e');
    }
  }

  Future<Either<Failure, List<WholesaleOrder>>> getSentOrders(
    String userId, {
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      print(
        '📥 [OrderRepo] Fetching SENT orders for user $userId (Range: O$offset to ${offset + limit})...',
      );
      final response = await _client
          .from('supplier_orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List;
      print('✅ [OrderRepo] Fetched ${data.length} sent orders.');
      final orders = data
          .map((row) => _rowToDomain(row, isSent: true))
          .toList();
      return Right(orders);
    } catch (e) {
      print('❌ [OrderRepo] GET SENT FAILED: $e');
      return Left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, WholesaleOrder?>> getOrderById(String id) async {
    try {
      // 1. Try orders_table (Primary Drafts)
      var response = await _client
          .from('orders_table')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        return Right(_rowToDomain(response));
      }

      // 2. Fallback to supplier_orders (For orders already sent to supplier)
      print('🔍 [OrderRepo] Id $id not in drafts, checking supplier_orders...');
      response = await _client
          .from('supplier_orders')
          .select()
          .eq('order_id', id)
          .maybeSingle();

      if (response != null) {
        print('✅ [OrderRepo] Found order $id in supplier_orders.');
        return Right(_rowToDomain(response, isSent: true));
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, Unit>> deleteOrder(String id) async {
    try {
      print('🗑️ [OrderRepo] Deleting order $id (Full Wipe)...');

      // 1. Delete the draft (Local and Cloud)
      await _deleteDraftOnly(id);

      // 2. 🥊 STRIKE 3: Attempt DELETE from supplier_orders (for sent/completed orders)
      try {
        final currentUserId = _client.auth.currentUser?.id;
        var query = _client.from('supplier_orders').delete().eq('order_id', id);
        if (currentUserId != null) {
          query = query.eq('user_id', currentUserId);
        }
        await query;
        print(
          '✅ [OrderRepo] Strike 3: Order $id deleted from supplier_orders.',
        );
      } catch (e) {
        print(
          '⚠️ [OrderRepo] Strike 3 (Delete supplier_orders) failed for $id: $e',
        );
      }

      return const Right(unit);
    } catch (e) {
      print('❌ [OrderRepo] DELETE FAILED for $id: $e');
      return Left(Failure.fromException(e));
    }
  }

  /// Internal helper to remove an order from the 'Drafts' / 'Pending' stage.
  /// Does NOT touch 'supplier_orders'.
  Future<Either<Failure, Unit>> _deleteDraftOnly(String id) async {
    try {
      print('🧹 [OrderRepo] Cleaning up draft/pending state for $id...');

      // 💾 1. Delete from Local Drift DB
      await (_db.delete(_db.ordersTable)..where((t) => t.id.equals(id))).go();

      // 🌐 2. Cloud Cleanup (Double-Strike)

      // Strike 1: Update status to 'processing' (Safe fallback)
      try {
        await _client
            .from('orders_table')
            .update({
              'status': 'processing',
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            })
            .eq('id', id);
      } catch (e) {
        print('⚠️ [OrderRepo] Draft Strike 1 failed: $e');
      }

      // Strike 2: Hard Delete from orders_table
      try {
        final currentUserId = _client.auth.currentUser?.id;
        var query = _client.from('orders_table').delete().eq('id', id);
        if (currentUserId != null) {
          query = query.eq('user_id', currentUserId);
        }
        await query;
      } catch (e) {
        print('❌ [OrderRepo] Draft Strike 2 failed: $e');
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, Unit>> updateOrderStatus(
    String id,
    OrderStatus status, {
    String? userId,
  }) async {
    try {
      final effectiveUserId = userId ?? _client.auth.currentSession?.user.id;

      // 💾 1. Update local Drift DB FIRST — this makes the UI reactive immediately
      await (_db.update(_db.ordersTable)..where((t) => t.id.equals(id))).write(
        OrdersTableCompanion(
          status: drift.Value(status.name.toUpperCase()),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );
      print('✅ [OrderRepo] Local status updated to ${status.name} for $id');

      // 🌐 2. Sync to Supabase in the background (Double Strike Strategy)

      // Strike A: Main orders table
      _client
          .from('orders_table')
          .update({
            'status': status.name.toLowerCase(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', id)
          .then(
            (_) => print(
              '✅ [OrderRepo] Cloud sync complete for orders_table: $id',
            ),
          )
          .catchError(
            (e) => print(
              '⚠️ [OrderRepo] Cloud sync failed for orders_table: $id ($e)',
            ),
          );

      // Strike B: Supplier orders table (The one the supplier actually sees)
      // 🛡️ SANITIZER: Map shipped/delivered/completed to 'completed' to satisfy DB Constraint
      final dbStatus =
          (status == OrderStatus.shipped ||
              status == OrderStatus.completed ||
              status == OrderStatus.delivered)
          ? 'completed'
          : status.name.toLowerCase();

      _client
          .from('supplier_orders')
          .update({
            'status': dbStatus,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('order_id', id)
          .then(
            (_) => print(
              '✅ [OrderRepo] Cloud sync complete for supplier_orders: $id',
            ),
          )
          .catchError(
            (e) => print(
              '⚠️ [OrderRepo] Cloud sync failed for supplier_orders: $id ($e)',
            ),
          );

      return const Right(unit);
    } catch (e) {
      print('❌ [OrderRepo] updateOrderStatus FAILED: $e');
      return Left(Failure.fromException(e));
    }
  }

  /// Cancels an order submission if it's still 'new' at the supplier.
  /// Removes the record from 'supplier_orders' and flips local status back to 'pending'.
  Future<Either<Failure, Unit>> cancelSubmission(String orderId) async {
    try {
      print(
        '📤 [OrderRepo] Attempting to cancel submission for order $orderId...',
      );

      // 1. Double check status in supplier_orders
      final checkResponse = await _client
          .from('supplier_orders')
          .select('status')
          .eq('order_id', orderId)
          .maybeSingle();

      if (checkResponse == null) {
        // Already gone or never sent
        return const Right(unit);
      }

      final status = checkResponse['status'] as String;
      if (status != 'new') {
        return const Left(
          ServerFailure(
            'Cannot cancel: Supplier has already started processing this order.',
          ),
        );
      }

      // 2. Delete from supplier_orders
      await _client.from('supplier_orders').delete().eq('order_id', orderId);

      // 3. Reset local status to pending
      await updateOrderStatus(orderId, OrderStatus.pending);

      print('✅ [OrderRepo] Order submission cancelled successfully.');
      return const Right(unit);
    } catch (e) {
      print('❌ [OrderRepo] CANCEL FAILED: $e');
      return Left(Failure.fromException(e));
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  WholesaleOrder _driftToDomain(WholesaleOrderEntry row) {
    final rawEntries = jsonDecode(row.itemsJson) as List<dynamic>? ?? [];
    final entries = rawEntries.map((item) {
      final map = item as Map<String, dynamic>;
      return _parseEntry(map);
    }).toList();

    return WholesaleOrder(
      id: row.id,
      date: row.createdAt ?? DateTime.now(),
      entries: entries,
      status: _parseStatus(row.status ?? 'PENDING'),
      pdfId: row.pdfId,
      productId: row.productId,
      supplierId: row.supplierId,
      updatedAt: row.updatedAt ?? DateTime.now(),
    );
  }

  WholesaleOrder _rowToDomain(Map<String, dynamic> row, {bool isSent = false}) {
    final rawEntries = row['entries_json'] as List<dynamic>? ?? [];
    final entries = rawEntries.map((item) {
      final map = item as Map<String, dynamic>;
      return _parseEntry(map);
    }).toList();

    // The ID might be in 'id' (orders_table) or 'order_id' (supplier_orders)
    final id = (row['order_id'] ?? row['id']) as String;

    final statusStr = row['status'] as String? ?? 'pending';
    final parsedStatus = _parseStatus(statusStr);

    return WholesaleOrder(
      id: id,
      date: DateTime.parse(row['created_at'] as String),
      entries: entries,
      status: parsedStatus,
      pdfId: row['pdf_id'] as String?,
      productId: row['product_id'] as String?,
      supplierId: row['supplier_id'] as String?,
      updatedAt: DateTime.parse(
        row['updated_at'] as String? ?? row['created_at'] as String,
      ),
    );
  }

  OrderStatus _parseStatus(String statusStr) {
    final lower = statusStr.toLowerCase().trim();
    if (lower == 'new') return OrderStatus.submitted;
    if (lower == 'completed') return OrderStatus.completed;

    return OrderStatus.values.firstWhere(
      (s) => s.name.toLowerCase() == lower,
      orElse: () => OrderStatus.pending,
    );
  }

  ProductOrderEntry _parseEntry(Map<String, dynamic> map) {
    final savedProductMap = map['savedProduct'] as Map<String, dynamic>;

    final product = Product(
      id: savedProductMap['productId'] ?? '',
      sku: savedProductMap['sku'] ?? '',
      name: savedProductMap['productName'] ?? '',
      brand: savedProductMap['brand'] ?? '',
      imageUrl: savedProductMap['imageUrl'] ?? '',
      priceTiers:
          (savedProductMap['priceTiers'] as List<dynamic>?)
              ?.map((t) => PriceTier.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      srp: (savedProductMap['srp'] as num?)?.toDouble() ?? 0,
      hsCode: '',
      weightKg: 0,
      volumeCbm: 0,
      originCountry: '',
      unbsNumber: '',
      denier: '',
      material: '',
      supplier: const Supplier(
        id: '',
        name: '',
        imageUrl: '',
        category: '',
        location: Location(latitude: 0, longitude: 0, addressName: ''),
      ),
      categoryId: savedProductMap['category'] ?? '',
      currentStock: savedProductMap['currentStock'] ?? 0,
      leadTimeDays: savedProductMap['leadTimeDays'] ?? 0,
      warehouseLoc: '',
      seoTitle: '',
      seoDescription: savedProductMap['seoDescription'] ?? '',
      searchKeywords: const [],
      slug: '',
      support: const ProductSupport(whatsapp: '', phone: '', email: ''),
      tradingTerms: savedProductMap['tradingTerms'] != null
          ? TradingTerms.fromJson(
              savedProductMap['tradingTerms'] as Map<String, dynamic>,
            )
          : const TradingTerms(id: '', content: ''),
    );

    final savedProduct = SavedProduct(
      product: product,
      quantity: savedProductMap['quantity'] ?? 0,
      selectedColor: savedProductMap['selectedColor'],
      selectedSize: savedProductMap['selectedSize'],
    );

    final confirmedGroupsRaw = map['confirmedGroups'] as List<dynamic>? ?? [];
    final confirmedGroups = confirmedGroupsRaw.map((g) {
      final grp = g as Map<String, dynamic>;
      final colorMap = grp['color'] as Map<String, dynamic>;
      return ColorGroup(
        color: ColorVariant(
          label: colorMap['label'] ?? 'Unknown',
          color: ColorUtils.fromHex(colorMap['hex'] ?? '#808080'),
        ),
        sizeQtys: Map<String, int>.from(grp['sizeQtys'] ?? {}),
      );
    }).toList();

    return ProductOrderEntry(
      savedProduct: savedProduct,
      confirmedGroups: confirmedGroups,
    );
  }
}
