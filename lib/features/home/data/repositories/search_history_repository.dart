import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../features/inventory/presentation/providers/inventory_notifier.dart'; // To reuse databaseProvider

class SearchHistoryRepository {
  final AppDatabase _db;

  SearchHistoryRepository(this._db);

  Stream<List<SearchHistoryEntry>> watchRecentSearches() {
    return (_db.select(_db.searchHistoryTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ])
          ..limit(20))
        .watch();
  }

  Future<void> saveSearch(String query) async {
    if (query.trim().isEmpty) return;

    // Check if query already exists
    final existing = await (_db.select(_db.searchHistoryTable)
          ..where((t) => t.query.equals(query.trim())))
        .getSingleOrNull();

    if (existing != null) {
      // Update its timestamp to move it to the top
      await (_db.update(_db.searchHistoryTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(SearchHistoryTableCompanion(
        createdAt: Value(DateTime.now()),
      ));
    } else {
      // Insert new entry
      await _db.into(_db.searchHistoryTable).insert(
            SearchHistoryTableCompanion.insert(
              query: query.trim(),
            ),
          );
    }
  }

  Future<void> deleteSearch(int id) async {
    await (_db.delete(_db.searchHistoryTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearAll() async {
    await _db.delete(_db.searchHistoryTable).go();
  }
}

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SearchHistoryRepository(db);
});

final recentSearchesProvider = StreamProvider<List<SearchHistoryEntry>>((ref) {
  return ref.watch(searchHistoryRepositoryProvider).watchRecentSearches();
});
