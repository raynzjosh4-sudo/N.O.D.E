import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/core/utils/color_utils.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/core/domain/entities/location.dart';
import 'package:node_app/features/home/presentation/pages/specificationorderpage/order_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/core/services/notification_service.dart';

class DraftOrderRepositoryImpl {
  final SupabaseClient _client;

  DraftOrderRepositoryImpl(this._client);

  /// Upserts a draft order to Supabase. Uses `id` as the conflict key.
  Future<Either<Failure, Unit>> saveDraft(
    DraftOrder draft,
    String userId,
  ) async {
    try {
      final entriesJson = jsonEncode(
        draft.entries.map((e) => e.toMap()).toList(),
      );

      await _client.from('draft_orders').upsert({
        'id': draft.id,
        'user_id': userId,
        'entries_json': jsonDecode(entriesJson), // Store as JSONB
        'status': draft.status,
        'last_modified': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'id');

      // 🔔 Trigger Local Confirmation
      NotificationService.showConfirmationAlert(
        title: 'Draft Saved',
        body: 'Your order draft has been saved to the cloud.',
      );

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Fetches all drafts for a given user from Supabase.
  Future<Either<Failure, List<DraftOrder>>> getDrafts(String userId) async {
    try {
      final response = await _client
          .from('draft_orders')
          .select()
          .eq('user_id', userId)
          .order('last_modified', ascending: false);

      final List<dynamic> data = response as List;
      final drafts = data.map((row) => _rowToDomain(row)).toList();
      return Right(drafts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Deletes a draft by its id.
  Future<Either<Failure, Unit>> deleteDraft(String id) async {
    try {
      await _client.from('draft_orders').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  DraftOrder _rowToDomain(Map<String, dynamic> row) {
    final rawEntries = row['entries_json'] as List<dynamic>? ?? [];
    final entries = rawEntries.map((item) {
      final map = item as Map<String, dynamic>;
      return _parseEntry(map);
    }).toList();

    return DraftOrder(
      id: row['id'] as String,
      entries: entries,
      lastModified: DateTime.parse(row['last_modified'] as String),
      status: row['status'] as String? ?? 'DRAFT',
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
