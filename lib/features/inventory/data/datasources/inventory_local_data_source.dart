import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/app_database.dart';
import '../models/product_model.dart';
import '../../../../features/home/data/models/promotion_model.dart';

import 'dart:convert';
import 'package:node_app/features/home/domain/entities/supplier.dart';

abstract class IInventoryLocalDataSource {
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
  });
  Future<List<Supplier>> getSuppliers({
    int limit = 20,
    int offset = 0,
    String? categoryId,
  });
  Stream<List<ProductModel>> watchProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteProduct(String remoteId);
  Future<void> clearCache();
  Future<List<PromotionModel>> getPromotions();
  Future<void> cachePromotions(List<PromotionModel> promotions);
}

class InventoryLocalDataSourceImpl implements IInventoryLocalDataSource {
  final AppDatabase database;

  InventoryLocalDataSourceImpl(this.database);

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
  }) async {
    debugPrint(
      '💾 [Local] Querying products cache limit=$limit offset=$offset...',
    );

    String? parentCatId;
    if (categoryId != null) {
      final cat = await (database.select(
        database.categoriesTable,
      )..where((t) => t.id.equals(categoryId))).getSingleOrNull();
      parentCatId = cat?.parentId;
    }

    final query = database.select(database.productsTable);

    final catSafe = categoryId?.replaceAll("'", "''") ?? '';
    final pCatSafe = parentCatId?.replaceAll("'", "''") ?? '';
    final supSafe = supplierId?.replaceAll("'", "''") ?? '';

    final List<OrderingTerm Function(dynamic)> orderings = [];

    if (categoryId != null || supplierId != null) {
      orderings.add(
        (t) => OrderingTerm(
          expression: CustomExpression<num>('''
                CASE 
                  ${categoryId != null && supplierId != null ? "WHEN category_id = '$catSafe' AND supplier_id = '$supSafe' THEN 1" : ""}
                  ${categoryId != null && supplierId != null ? "WHEN supplier_id = '$supSafe' THEN 2" : ""}
                  ${categoryId != null && supplierId != null ? "WHEN category_id = '$catSafe' THEN 3" : ""}
                  
                  ${categoryId != null && supplierId == null ? "WHEN category_id = '$catSafe' THEN 1" : ""}
                  ${categoryId != null && supplierId == null ? "WHEN category_id IN (SELECT id FROM categories_table WHERE parent_id = '$pCatSafe') AND '$pCatSafe' != '' THEN 2" : ""}
                  
                  ${supplierId != null && categoryId == null ? "WHEN supplier_id = '$supSafe' THEN 1" : ""}
                  ${supplierId != null && categoryId == null ? "WHEN category_id IN (SELECT DISTINCT category_id FROM products_table WHERE supplier_id = '$supSafe') THEN 2" : ""}
                  
                  ELSE 4
                END
              '''),
          mode: OrderingMode.asc,
        ),
      );
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where((t) =>
          t.name.contains(searchQuery) |
          t.brand.contains(searchQuery) |
          t.searchKeywords.contains(searchQuery));
    }

    orderings.add((t) => OrderingTerm.desc(t.id));
    query.orderBy(orderings);

    query.limit(limit, offset: offset);

    final entries = await query.get();
    debugPrint('💾 [Local] Cache hit: ${entries.length} items found.');
    return entries.map((entry) => ProductModel.fromDrift(entry)).toList();
  }

  @override
  Future<List<Supplier>> getSuppliers({
    int limit = 20,
    int offset = 0,
    String? categoryId,
  }) async {
    final query = database.selectOnly(database.productsTable, distinct: true)
      ..addColumns([database.productsTable.supplierJson])
      ..limit(limit, offset: offset);

    if (categoryId != null && categoryId != 'All') {
      query.where(database.productsTable.categoryId.equals(categoryId));
    }

    final rows = await query.get();
    return rows.map((r) {
      final jsonStr = r.read(database.productsTable.supplierJson);
      return Supplier.fromJson(jsonDecode(jsonStr!));
    }).toList();
  }

  @override
  Stream<List<ProductModel>> watchProducts() {
    return database.select(database.productsTable).watch().map((entries) {
      return entries.map((entry) => ProductModel.fromDrift(entry)).toList();
    });
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    debugPrint('💾 [Local] Caching ${products.length} products to Drift...');
    await database.batch((batch) {
      batch.insertAll(
        database.productsTable,
        products.map((p) => p.toDrift()).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
    debugPrint('💾 [Local] Cache updated.');
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    debugPrint('💾 [Local] Caching single product: ${product.id}');
    await database
        .into(database.productsTable)
        .insertOnConflictUpdate(product.toDrift());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await (database.delete(
      database.productsTable,
    )..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearCache() async {
    await database.delete(database.productsTable).go();
  }

  @override
  Future<List<PromotionModel>> getPromotions() async {
    final now = DateTime.now();
    final query = database.select(database.promotionsTable)
      ..where((t) {
        return t.isActive.equals(true) &
            (t.startsAt.isNull() | t.startsAt.isSmallerOrEqualValue(now)) &
            (t.expiresAt.isNull() | t.expiresAt.isBiggerOrEqualValue(now));
      })
      ..orderBy([(t) => OrderingTerm.desc(t.priority)]);

    final entries = await query.get();
    return entries.map((e) => PromotionModel.fromDrift(e)).toList();
  }

  @override
  Future<void> cachePromotions(List<PromotionModel> promotions) async {
    debugPrint('💾 [Local] Caching ${promotions.length} promotions to Drift...');
    await database.batch((batch) {
      batch.insertAll(
        database.promotionsTable,
        promotions.map((p) => p.toDrift()).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
    debugPrint('💾 [Local] Promotions cache updated.');
  }
}
