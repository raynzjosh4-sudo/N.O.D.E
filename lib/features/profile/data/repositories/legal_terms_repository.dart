import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/app_database.dart';

class LegalTermsRepository {
  final SupabaseClient _client;

  LegalTermsRepository(this._client);

  /// Fetches legal terms from Supabase public.legal_terms
  Future<List<Map<String, dynamic>>> fetchRemoteTerms() async {
    int attempts = 0;
    const maxAttempts = 3;

    while (attempts < maxAttempts) {
      try {
        attempts++;
        print(
          '🌐 [Supabase] Fetching from "legal_terms" table (Attempt $attempts)...',
        );
        final response = await _client
            .from('legal_terms')
            .select('id, title, content, updated_at');

        final list = List<Map<String, dynamic>>.from(response);
        print('✅ [Supabase] Received ${list.length} terms.');
        return list;
      } catch (e) {
        final errorStr = e.toString().toLowerCase();
        final isTimeout =
            errorStr.contains('522') ||
            errorStr.contains('timeout') ||
            errorStr.contains('deadline');

        if (isTimeout && attempts < maxAttempts) {
          print('⚠️ [Supabase] Timeout (522) detected. Retrying in 2s...');
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }

        print('❌ [Supabase] Error fetching legal terms: $e');
        rethrow;
      }
    }
    throw Exception('Failed to fetch legal terms after $maxAttempts attempts');
  }

  /// Syncs remote terms into the local Drift database
  Future<void> syncToLocal(AppDatabase db) async {
    print('📦 [Sync] Starting cloud to local synchronization...');
    final remoteTerms = await fetchRemoteTerms();
    print('📦 [Sync] Got ${remoteTerms.length} terms to write locally.');

    for (final term in remoteTerms) {
      try {
        print('💾 [Sync] Upserting "${term['id']}" - ${term['title']}');

        // Safely parse timezone-aware timestamp from Supabase
        final rawDate = term['updated_at'] as String?;
        final updatedAt = rawDate != null
            ? DateTime.parse(rawDate).toLocal()
            : DateTime.now();

        await db
            .into(db.legalTermsTable)
            .insertOnConflictUpdate(
              LegalTermEntry(
                id: term['id']! as String,
                title: term['title']! as String,
                content: term['content']! as String,
                updatedAt: updatedAt,
              ),
            );
        print('✅ [Sync] Saved "${term['id']}" successfully.');
      } catch (rowError) {
        print('❌ [Sync] Failed on term "${term['id']}": $rowError');
      }
    }
    print('✨ [Sync] All terms processed.');
  }
}
