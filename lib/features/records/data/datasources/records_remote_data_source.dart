import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';

/// Remote data source for the Records feature.
/// Maps the MainRecordModel to a flat Supabase row using JSON columns,
/// mirroring the Drift schema for consistency.
class RecordsRemoteDataSource {
  final SupabaseClient _client;
  static const String _table = 'records';

  RecordsRemoteDataSource(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  // ── FETCH PAGINATED ──────────────────────────────────────
  /// Fetch a page of records for the current user.
  Future<List<MainRecordModel>> fetchPaginated({
    required int limit,
    required int offset,
  }) async {
    final uid = _userId;
    if (uid == null) return [];

    try {
      final rows = await _client
          .from(_table)
          .select()
          .eq('user_id', uid)
          .order('updated_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (rows as List<dynamic>)
          .map((row) => _fromRow(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ [RecordsRemote] fetchPaginated failed: $e');
      return [];
    }
  }

  /// Fetch all record IDs for the current user (for reconciliation).
  Future<Set<String>> fetchIds() async {
    final uid = _userId;
    if (uid == null) return {};

    try {
      final rows = await _client.from(_table).select('id').eq('user_id', uid);

      return (rows as List<dynamic>).map((row) => row['id'] as String).toSet();
    } catch (e) {
      debugPrint('❌ [RecordsRemote] fetchIds failed: $e');
      return {};
    }
  }

  // ── UPSERT ───────────────────────────────────────────────
  /// Push a single record to Supabase (insert or update).
  Future<void> upsertRecord(MainRecordModel record) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _client.from(_table).upsert(_toRow(uid, record));
      debugPrint('☁️ [RecordsRemote] Upserted record ${record.id}');
    } catch (e) {
      debugPrint('❌ [RecordsRemote] upsert failed for ${record.id}: $e');
    }
  }

  // ── DELETE ───────────────────────────────────────────────
  /// Delete a record from Supabase by ID.
  Future<void> deleteRecord(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      debugPrint('🗑️ [RecordsRemote] Deleted record $id');
    } catch (e) {
      debugPrint('❌ [RecordsRemote] delete failed for $id: $e');
    }
  }

  // ── REALTIME STREAM ──────────────────────────────────────
  /// Returns a stream of the latest full records list, firing any time
  /// any record for this user changes in Supabase (INSERT, UPDATE, DELETE).
  Stream<List<MainRecordModel>> watchAll() {
    final uid = _userId;
    if (uid == null) return const Stream.empty();

    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('updated_at', ascending: false)
        .map((rows) => rows.map((row) => _fromRow(row)).toList());
  }

  // ── MAPPING ──────────────────────────────────────────────

  Map<String, dynamic> _toRow(String userId, MainRecordModel r) {
    return {
      'id': r.id,
      'user_id': userId,
      // Flat detail fields
      'contact_name': r.detail?.contactName ?? '',
      'item_name': r.detail?.itemName ?? '',
      'reference_tag': r.detail?.referenceTag,
      'unit': r.detail?.unit ?? 'Units',
      'target_value': r.detail?.targetValue ?? 0,
      'current_value': r.detail?.currentValue ?? 0,
      'type': r.detail?.type.name ?? 'standard',
      'contact_image_url': r.detail?.contactImageUrl,
      // Grand total
      'grand_total': r.data?.grandTotal ?? 0,
      // JSON blobs for complex nested data
      'breakdown_items_json': jsonEncode(
        r.data?.items.map((i) => i.toJson()).toList() ?? [],
      ),
      'timeline_json': jsonEncode(r.records.map((e) => e.toJson()).toList()),
      // Reminder
      'reminder_date': r.reminder?.date?.toIso8601String(),
      'reminder_time': r.reminder?.time,
      'reminder_is_recurring': r.reminder?.isRecurring ?? false,
      // Status
      'is_archived': r.isArchived,
      'updated_at': r.updatedAt.toUtc().toIso8601String(),
    };
  }

  MainRecordModel _fromRow(Map<String, dynamic> row) {
    return MainRecordModel.fromJson({
      'id': row['id'],
      'updated_at': row['updated_at'],
      'is_archived': row['is_archived'] ?? false,
      'detail': {
        'contact_name': row['contact_name'] ?? '',
        'item_name': row['item_name'] ?? '',
        'reference_tag': row['reference_tag'],
        'unit': row['unit'] ?? 'Units',
        'target_value': row['target_value'] ?? 0,
        'current_value': row['current_value'] ?? 0,
        'type': row['type'] ?? 'standard',
        'contact_image_url': row['contact_image_url'],
      },
      'data': {
        'grand_total': row['grand_total'] ?? 0,
        'items': row['breakdown_items_json'] != null
            ? jsonDecode(row['breakdown_items_json'] as String)
            : [],
      },
      'records': row['timeline_json'] != null
          ? jsonDecode(row['timeline_json'] as String)
          : [],
      'reminder': (row['reminder_date'] != null)
          ? {
              'date': row['reminder_date'],
              'time': row['reminder_time'],
              'is_recurring': row['reminder_is_recurring'] ?? false,
            }
          : null,
    });
  }
}
