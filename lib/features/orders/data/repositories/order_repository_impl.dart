import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/features/orders/domain/repositories/order_repository.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/home/presentation/pages/specificationorderpage/order_models.dart';
import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failure.dart';
import 'package:node_app/core/utils/color_utils.dart';
import '../../../../features/inventory/domain/entities/product.dart';
import '../../../../features/home/domain/entities/supplier.dart';
import '../../../../core/domain/entities/location.dart';

class OrderRepositoryImpl implements OrderRepository {
  final AppDatabase database;

  OrderRepositoryImpl(this.database);

  @override
  Future<Either<Failure, void>> saveOrder(
    WholesaleOrder order,
    String userId,
  ) async {
    try {
      final entry = WholesaleOrderEntry(
        id: order.id,
        userId: userId,
        itemsJson: jsonEncode(order.entries.map((e) => e.toMap()).toList()),
        totalAmount: order.totalAmount,
        totalUnits: order.totalUnits,
        status: order.status.name.toUpperCase(),
        isDraft: false,
        pdfId: order.pdfId,
        updatedAt: DateTime.now(),
        createdAt: order.date,
      );
      await database.into(database.ordersTable).insertOnConflictUpdate(entry);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDraft(
    DraftOrder draft,
    String userId,
  ) async {
    try {
      final entry = WholesaleOrderEntry(
        id: draft.id,
        userId: userId,
        itemsJson: jsonEncode(draft.entries.map((e) => e.toMap()).toList()),
        totalAmount: draft.totalAmount,
        totalUnits: draft.totalUnits,
        status: 'DRAFT',
        isDraft: true,
        updatedAt: DateTime.now(),
        createdAt: draft.lastModified,
      );
      await database.into(database.ordersTable).insertOnConflictUpdate(entry);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WholesaleOrder>>> getOrders(String userId) async {
    try {
      final query = database.select(database.ordersTable)
        ..where((t) => t.userId.equals(userId) & t.isDraft.equals(false));
      final results = await query.get();

      final domainOrders = results.map((row) {
        return WholesaleOrder(
          id: row.id,
          date: row.createdAt,
          status: _parseStatus(row.status),
          entries: _parseItems(row.itemsJson),
          pdfId: row.pdfId,
        );
      }).toList();

      return Right(domainOrders);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DraftOrder>>> getDrafts(String userId) async {
    try {
      final query = database.select(database.ordersTable)
        ..where((t) => t.userId.equals(userId) & t.isDraft.equals(true));
      final results = await query.get();

      final domainDrafts = results.map((row) {
        return DraftOrder(
          id: row.id,
          lastModified: row.updatedAt,
          entries: _parseItems(row.itemsJson),
        );
      }).toList();

      return Right(domainDrafts);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(String id) async {
    try {
      await (database.delete(
        database.ordersTable,
      )..where((t) => t.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WholesaleOrder?>> getOrderById(String id) async {
    try {
      final query = database.select(database.ordersTable)
        ..where((t) => t.id.equals(id));
      final result = await query.getSingleOrNull();

      if (result == null) return const Right(null);

      return Right(WholesaleOrder(
        id: result.id,
        date: result.createdAt,
        status: _parseStatus(result.status),
        entries: _parseItems(result.itemsJson),
        pdfId: result.pdfId,
      ));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String id,
    OrderStatus status,
  ) async {
    try {
      await (database.update(database.ordersTable)
            ..where((t) => t.id.equals(id)))
          .write(
        OrdersTableCompanion(
          status: Value(status.name.toUpperCase()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  OrderStatus _parseStatus(String status) {
    return OrderStatus.values.firstWhere(
      (s) => s.name.toUpperCase() == status,
      orElse: () => OrderStatus.processing,
    );
  }

  List<ProductOrderEntry> _parseItems(String itemsJson) {
    final List<dynamic> decoded = jsonDecode(itemsJson);
    return decoded.map((item) {
      final map = item as Map<String, dynamic>;
      final savedProductMap = map['savedProduct'] as Map<String, dynamic>;

      // Reconstruct minimal shell Product for display
      final product = Product(
        id: savedProductMap['productId'] ?? '',
        sku: savedProductMap['sku'] ?? '',
        name: savedProductMap['productName'] ?? '',
        brand: savedProductMap['brand'] ?? '',
        imageUrl: savedProductMap['imageUrl'] ?? '',
        priceTiers:
            const [], // Detailed tiers handled by pricing logic if needed
        srp: 0,
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
            ? TradingTerms.fromJson(savedProductMap['tradingTerms'])
            : const TradingTerms(id: '', content: ''),
      );

      final savedProduct = SavedProduct(
        product: product.copyWith(
          srp: (savedProductMap['srp'] as num?)?.toDouble() ?? 0,
          currentStock: savedProductMap['currentStock'] as int?,
          leadTimeDays: savedProductMap['leadTimeDays'] as int?,
          priceTiers: (savedProductMap['priceTiers'] as List<dynamic>?)
              ?.map((t) => PriceTier.fromJson(t as Map<String, dynamic>))
              .toList(),
          seoDescription: savedProductMap['seoDescription'] as String?,
          tradingTerms: savedProductMap['tradingTerms'] != null
              ? TradingTerms.fromJson(
                  savedProductMap['tradingTerms'] as Map<String, dynamic>,
                )
              : null,
        ),
        quantity: savedProductMap['quantity'] ?? 0,
        selectedColor: savedProductMap['selectedColor'],
        selectedSize: savedProductMap['selectedSize'],
      );

      final confirmedGroupsRaw = map['confirmedGroups'] as List<dynamic>;
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
    }).toList();
  }

}
