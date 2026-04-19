import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/app_database.dart';
import '../../../../features/inventory/presentation/providers/inventory_notifier.dart'; // To reuse databaseProvider
import '../../../../features/auth/presentation/providers/auth_state_provider.dart';

class SearchHistoryRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;

  SearchHistoryRepository(this._db, this._supabase);

  Stream<List<SearchHistoryEntry>> watchRecentSearches() {
    return (_db.select(_db.searchHistoryTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ])
          ..limit(20))
        .watch();
  }

  Future<void> saveSearch(String query, String userId) async {
    if (query.trim().isEmpty) return;
    final trimmedQuery = query.trim();

    // Check if query already exists for THIS user
    final existing = await (_db.select(_db.searchHistoryTable)
          ..where((t) => t.query.equals(trimmedQuery) & t.userId.equals(userId)))
        .getSingleOrNull();

    final id = existing?.id ?? const Uuid().v4();

    // 1. Save locally
    await _db.into(_db.searchHistoryTable).insertOnConflictUpdate(
          SearchHistoryTableCompanion.insert(
            id: id,
            userId: userId,
            query: trimmedQuery,
            createdAt: Value(DateTime.now()),
          ),
        );

    // 2. Sync to Supabase (Background)
    if (userId != 'guest') {
      _supabase.from('search_history').upsert({
        'id': id,
        'user_id': userId,
        'query': trimmedQuery,
      }).catchError((e) => debugPrint('❌ [SearchHistory] Sync Error: $e'));
    }
  }

  Future<void> syncRecentSearches(String userId) async {
    try {
      final response = await _supabase
          .from('search_history')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(20);

      final List<dynamic> data = response;
      
      await _db.batch((batch) {
        for (final item in data) {
          batch.insert(
            _db.searchHistoryTable,
            SearchHistoryTableCompanion.insert(
              id: item['id'],
              userId: item['user_id'],
              query: item['query'],
              createdAt: Value(DateTime.parse(item['created_at'])),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
      debugPrint('✅ [SearchHistory] Synced ${data.length} items from Supabase');
    } catch (e) {
      debugPrint('❌ [SearchHistory] Failed to sync: $e');
    }
  }

  Future<void> deleteSearch(String id) async {
    // 1. Delete locally
    await (_db.delete(_db.searchHistoryTable)..where((t) => t.id.equals(id))).go();
    
    // 2. Delete from Supabase
    _supabase.from('search_history').delete().eq('id', id).catchError(
      (e) => debugPrint('❌ [SearchHistory] Delete Sync Error: $e'),
    );
  }

  Future<void> clearAll(String userId) async {
    // 1. Clear locally
    await (_db.delete(_db.searchHistoryTable)..where((t) => t.userId.equals(userId))).go();
    
    // 2. Clear from Supabase
    if (userId != 'guest') {
      _supabase
          .from('search_history')
          .delete()
          .eq('user_id', userId)
          .catchError(
            (e) => debugPrint('❌ [SearchHistory] Clear Sync Error: $e'),
          );
    }
  }
}

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SearchHistoryRepository(db, Supabase.instance.client);
});

final recentSearchesProvider = StreamProvider<List<SearchHistoryEntry>>((ref) {
  final repository = ref.watch(searchHistoryRepositoryProvider);
  
  // Trigger background sync if user is logged in
  final authState = ref.watch(authStateProvider).value;
  final userId = authState?.session?.user.id;
  if (userId != null) {
    repository.syncRecentSearches(userId);
  }
  
  return repository.watchRecentSearches();
});
