import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/app_database.dart';
import '../models/category_model.dart';

abstract class ICategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories({
    String? parentId,
    int limit = 100,
    int offset = 0,
  });
  Stream<List<CategoryModel>> watchCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<void> clearCache();
  Future<List<CategoryModel>> getTopCategories();
  Future<void> incrementCategoryUsage(String id);
}

class CategoryLocalDataSourceImpl implements ICategoryLocalDataSource {
  final AppDatabase database;

  CategoryLocalDataSourceImpl(this.database);

  @override
  Future<List<CategoryModel>> getCategories({
    String? parentId,
    int limit = 100,
    int offset = 0,
  }) async {
    final query = database.select(database.categoriesTable);
    if (parentId != null) {
      query.where((t) => t.parentId.equals(parentId));
    } else {
      query.where((t) => t.parentId.isNull());
    }
    query.limit(limit, offset: offset);

    final entries = await query.get();
    return entries.map((entry) => CategoryModel.fromDrift(entry)).toList();
  }

  @override
  Stream<List<CategoryModel>> watchCategories() {
    return database.select(database.categoriesTable).watch().map((entries) {
      return entries.map((entry) => CategoryModel.fromDrift(entry)).toList();
    });
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    await database.batch((batch) {
      batch.insertAll(
        database.categoriesTable,
        categories.map((c) => c.toDrift()).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> clearCache() async {
    await database.delete(database.categoriesTable).go();
  }

  @override
  Future<List<CategoryModel>> getTopCategories() async {
    final query = database.select(database.categoriesTable)
      ..where((t) => t.parentId.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.priority)]);

    final entries = await query.get();
    return entries.map((e) => CategoryModel.fromDrift(e)).toList();
  }

  @override
  Future<void> incrementCategoryUsage(String id) async {
    final existing = await (database.select(database.categoriesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (existing != null) {
      await (database.update(database.categoriesTable)
            ..where((t) => t.id.equals(id)))
          .write(
        CategoriesTableCompanion(
          usageCount: Value(existing.usageCount + 1),
        ),
      );
    }
  }
}
