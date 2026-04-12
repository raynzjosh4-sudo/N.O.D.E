import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' hide ProductModel;
import '../models/product_model.dart';

abstract class IInventoryLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Stream<List<ProductModel>> watchProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteProduct(String remoteId);
  Future<void> clearCache();
}

class InventoryLocalDataSourceImpl implements IInventoryLocalDataSource {
  final AppDatabase database;

  InventoryLocalDataSourceImpl(this.database);

  @override
  Future<List<ProductModel>> getProducts() async {
    final entries = await database.select(database.productsTable).get();
    return entries.map((entry) => ProductModel.fromDrift(entry)).toList();
  }

  @override
  Stream<List<ProductModel>> watchProducts() {
    return database.select(database.productsTable).watch().map((entries) {
      return entries.map((entry) => ProductModel.fromDrift(entry)).toList();
    });
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await database.batch((batch) {
      for (final product in products) {
        batch.insert(
          database.productsTable,
          product.toDrift(),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    await database.into(database.productsTable).insertOnConflictUpdate(product.toDrift());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await (database.delete(database.productsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearCache() async {
    await database.delete(database.productsTable).go();
  }
}
