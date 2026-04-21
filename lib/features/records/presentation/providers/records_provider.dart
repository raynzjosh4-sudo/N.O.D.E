import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node_app/features/records/domain/types/record_types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/features/records/data/datasources/records_remote_data_source.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/data/models/record_data_model.dart';
import 'package:node_app/features/records/data/models/record_model.dart';
import 'package:node_app/features/records/data/models/reminder_model.dart';
import 'package:node_app/core/database/database_provider.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

import 'package:node_app/core/services/notification_service.dart';
import 'dummy_records.dart';

class RecordsState {
  final List<MainRecordModel> items;
  final bool isLoading;
  final bool hasMore;

  RecordsState({
    required this.items,
    this.isLoading = false,
    this.hasMore = true,
  });

  RecordsState copyWith({
    List<MainRecordModel>? items,
    bool? isLoading,
    bool? hasMore,
  }) {
    return RecordsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

final recordsProvider = StateNotifierProvider<RecordsNotifier, RecordsState>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  final remote = RecordsRemoteDataSource(Supabase.instance.client);
  return RecordsNotifier(db, remote);
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class RecordsNotifier extends StateNotifier<RecordsState> {
  final AppDatabase _db;
  final RecordsRemoteDataSource _remote;
  StreamSubscription<List<MainRecordModel>>? _realtimeSub;
  int _retryCount = 0;
  static const int _pageSize = 10;

  RecordsNotifier(this._db, this._remote) : super(RecordsState(items: [])) {
    _initData();
  }

  // ── INIT: Load locally, then start realtime stream ────────
  Future<void> _initData() async {
    // 1. Load first page from Drift immediately
    final entries =
        await (_db.select(_db.recordsTable)
              ..orderBy([
                (t) => drift.OrderingTerm(
                  expression: t.updatedAt,
                  mode: drift.OrderingMode.desc,
                ),
              ])
              ..limit(_pageSize))
            .get();

    final items = entries.map((e) => _fromEntry(e)).toList();
    state = state.copyWith(items: items, hasMore: items.length >= _pageSize);
    debugPrint(
      '📦 [Records] Initial load: ${items.length} records from local DB',
    );

    // 2. 🔁 Re-schedule ALL active reminders
    _reregisterAllReminders();

    // 3. Start Supabase realtime stream
    _startRealtimeSync();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    final offset = state.items.length;

    try {
      final entries =
          await (_db.select(_db.recordsTable)
                ..orderBy([
                  (t) => drift.OrderingTerm(
                    expression: t.updatedAt,
                    mode: drift.OrderingMode.desc,
                  ),
                ])
                ..limit(_pageSize, offset: offset))
              .get();

      final newItems = entries.map((e) => _fromEntry(e)).toList();
      state = state.copyWith(
        items: [...state.items, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= _pageSize,
      );
    } catch (e) {
      debugPrint('❌ [Records] Load more failed: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  void _reregisterAllReminders() {
    final reminders = state.items
        .where(
          (r) =>
              r.reminder?.date != null &&
              r.reminder?.time != null &&
              !r.isArchived,
        )
        .map(
          (r) => (
            recordId: r.id,
            contactName: r.detail?.contactName ?? 'Contact',
            targetValue: r.detail?.targetValue ?? 0,
            date: r.reminder!.date!,
            time: r.reminder!.time!,
            isRecurring: r.reminder!.isRecurring,
          ),
        )
        .toList();

    if (reminders.isNotEmpty) {
      NotificationService.rescheduleAllReminders(reminders);
      debugPrint(
        '🔔 [Records] Queued ${reminders.length} reminders for re-registration',
      );
    }
  }

  // ── REALTIME SYNC ─────────────────────────────────────────
  void _startRealtimeSync() {
    _realtimeSub?.cancel();

    // 1. Trigger Cloud Reconciliation (Once on startup)
    _reconcileGhostData();

    _realtimeSub = _remote.watchAll().listen(
      (remoteRecords) async {
        if (!mounted) return;
        _retryCount = 0;
        debugPrint('🔄 [Records] Realtime update event received');

        // Upsert every remote record into local Drift DB
        for (final r in remoteRecords) {
          await _saveToDb(r);
        }

        // Refresh the current visible set from local DB (maintaining pagination)
        final currentCount = state.items.length.clamp(_pageSize, 1000);
        final entries =
            await (_db.select(_db.recordsTable)
                  ..orderBy([
                    (t) => drift.OrderingTerm(
                      expression: t.updatedAt,
                      mode: drift.OrderingMode.desc,
                    ),
                  ])
                  ..limit(currentCount))
                .get();

        final merged = entries.map((e) => _fromEntry(e)).toList();

        if (mounted) {
          state = state.copyWith(items: merged);
        }
      },
      onError: (e) {
        debugPrint('❌ [Records] Realtime stream error: $e');
        _handleSyncRetry();
      },
      onDone: () {
        debugPrint('ℹ️ [Records] Realtime stream closed. Retrying...');
        _handleSyncRetry();
      },
    );
  }

  Future<void> _reconcileGhostData() async {
    try {
      debugPrint('🧹 [Records] Starting cloud reconciliation...');
      final cloudIds = await _remote.fetchIds();

      final localRecords = await _db.select(_db.recordsTable).get();
      for (final local in localRecords) {
        if (!cloudIds.contains(local.id)) {
          // Check age to avoid deleting brand new local records that haven't synced yet
          final age = DateTime.now().difference(local.updatedAt);
          if (age.inMinutes > 5) {
            debugPrint('🧹 [Records] Pruning ghost record: ${local.id}');
            await (_db.delete(
              _db.recordsTable,
            )..where((t) => t.id.equals(local.id))).go();
          }
        }
      }
      debugPrint('✅ [Records] Reconciliation complete.');
    } catch (e) {
      debugPrint('⚠️ [Records] Reconciliation skipped: $e');
    }
  }

  void _handleSyncRetry() {
    if (!mounted) return;
    _retryCount++;
    // Exponential backoff: 2s, 4s, 8s, 16s... max 1 min
    final delaySeconds = (1 << _retryCount).clamp(2, 60);
    debugPrint(
      '⏳ [Records] Retrying sync in $delaySeconds seconds (Attempt $_retryCount)...',
    );

    Future.delayed(Duration(seconds: delaySeconds), () {
      if (mounted) _startRealtimeSync();
    });
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }

  // ── LOCAL DRIFT ───────────────────────────────────────────
  Future<void> _saveToDb(MainRecordModel r) async {
    await _db
        .into(_db.recordsTable)
        .insertOnConflictUpdate(
          RecordsTableCompanion.insert(
            id: r.id,
            detailJson: drift.Value(
              r.detail != null ? jsonEncode(r.detail!.toJson()) : null,
            ),
            dataJson: drift.Value(
              r.data != null ? jsonEncode(r.data!.toJson()) : null,
            ),
            reminderJson: drift.Value(
              r.reminder != null ? jsonEncode(r.reminder!.toJson()) : null,
            ),
            recordsHistoryJson: drift.Value(
              jsonEncode(r.records.map((e) => e.toJson()).toList()),
            ),
            updatedAt: drift.Value(r.updatedAt),
            isArchived: drift.Value(r.isArchived),
          ),
        );
  }

  MainRecordModel _fromEntry(RecordEntry e) {
    return MainRecordModel.fromJson({
      'id': e.id,
      'detail': e.detailJson != null ? jsonDecode(e.detailJson!) : null,
      'data': e.dataJson != null ? jsonDecode(e.dataJson!) : null,
      'reminder': e.reminderJson != null ? jsonDecode(e.reminderJson!) : null,
      'records': jsonDecode(e.recordsHistoryJson),
      'updated_at': e.updatedAt.toIso8601String(),
      'is_archived': e.isArchived,
    });
  }

  // ── WRITE HELPERS: write locally then sync remotely ───────

  /// Save to Drift and push to Supabase in background.
  Future<void> _saveAndSync(MainRecordModel r) async {
    await _saveToDb(r);
    // Fire-and-forget: don't block UI on network
    _remote
        .upsertRecord(r)
        .catchError(
          (e) => debugPrint('⚠️ [Records] Remote sync skipped (offline?): $e'),
        );
  }

  // ── PUBLIC API ────────────────────────────────────────────

  void addRecord(MainRecordModel record) {
    state = state.copyWith(items: [record, ...state.items]);
    _saveAndSync(record);
  }

  List<RecordModel> _recalculateBalances(
    List<RecordModel> records,
    double baseBalance,
  ) {
    if (records.isEmpty) return [];
    final oldestFirst = records.toList().reversed.toList();
    final List<RecordModel> rebalanced = [];
    double currentBal = baseBalance;

    for (final r in oldestFirst) {
      currentBal += r.total;
      rebalanced.add(r.copyWith(balanceAfter: currentBal));
    }
    return rebalanced.reversed.toList();
  }

  void addEntry(
    String recordId,
    double amount, {
    String? note,
    bool isReduce = false,
  }) {
    state = state.copyWith(
      items: [
        for (final record in state.items)
          if (record.id == recordId)
            () {
              final currentDetailVal = record.detail?.currentValue ?? 0;
              final newCurrentVal = isReduce
                  ? currentDetailVal - amount
                  : currentDetailVal + amount;

              final baseGrandTotal = record.data?.grandTotal ?? 0;

              final newRecords = [
                RecordModel(
                  time: DateTime.now(),
                  total: isReduce ? -amount : amount,
                  message: note ?? 'New entry',
                  balanceAfter: 0,
                ),
                ...record.records,
              ];

              return record.copyWith(
                updatedAt: DateTime.now(),
                detail: record.detail?.copyWith(currentValue: newCurrentVal),
                records: _recalculateBalances(newRecords, baseGrandTotal),
              );
            }()
          else
            record,
      ],
    );

    try {
      final updated = state.items.firstWhere((r) => r.id == recordId);
      _saveAndSync(updated);
    } catch (e) {
      debugPrint('❌ Error adding entry: $e');
    }
  }

  void deleteRecord(String id) {
    NotificationService.cancelRecordReminder(id);
    state = state.copyWith(
      items: state.items.where((r) => r.id != id).toList(),
    );
    (_db.delete(_db.recordsTable)..where((t) => t.id.equals(id))).go();
    _remote
        .deleteRecord(id)
        .catchError(
          (e) =>
              debugPrint('⚠️ [Records] Remote delete skipped (offline?): $e'),
        );
  }

  void archiveRecord(String id) {
    state = state.copyWith(
      items: [
        for (final record in state.items)
          if (record.id == id) record.copyWith(isArchived: true) else record,
      ],
    );
    final updated = state.items.firstWhere((r) => r.id == id);
    _saveAndSync(updated);
  }

  void unarchiveRecord(String id) {
    state = state.copyWith(
      items: [
        for (final record in state.items)
          if (record.id == id) record.copyWith(isArchived: false) else record,
      ],
    );
    final updated = state.items.firstWhere((r) => r.id == id);
    _saveAndSync(updated);
  }

  void addBreakdownItem(String recordId, RecordBreakdownItemModel item) {
    state = state.copyWith(
      items: [
        for (final record in state.items)
          if (record.id == recordId)
            () {
              final oldData = record.data;
              final updatedData = oldData != null
                  ? oldData.copyWith(
                      items: [...oldData.items, item],
                      grandTotal: oldData.grandTotal + item.amount,
                    )
                  : RecordDataModel(items: [item], grandTotal: item.amount);

              final newGrandTotal = updatedData.grandTotal;

              return record.copyWith(
                data: updatedData,
                updatedAt: DateTime.now(),
                records: _recalculateBalances(record.records, newGrandTotal),
              );
            }()
          else
            record,
      ],
    );

    try {
      final updated = state.items.firstWhere((r) => r.id == recordId);
      _saveAndSync(updated);
    } catch (e) {
      debugPrint('❌ Error adding breakdown item: $e');
    }
  }

  void updateRecord(MainRecordModel updatedRecord) {
    state = state.copyWith(
      items: [
        for (final record in state.items)
          if (record.id == updatedRecord.id) updatedRecord else record,
      ],
    );
    _saveAndSync(updatedRecord);
  }

  void updateReminder(
    String recordId,
    DateTime? date, {
    bool isRecurring = false,
    String? time,
  }) {
    state = state.copyWith(
      items: [
        for (final record in state.items)
          if (record.id == recordId)
            MainRecordModel(
              id: record.id,
              updatedAt: DateTime.now(),
              detail: record.detail,
              data: record.data,
              records: record.records,
              isArchived: record.isArchived,
              reminder: ReminderModel(
                date: date,
                isRecurring: isRecurring,
                time: time,
              ),
            )
          else
            record,
      ],
    );

    final updatedRecord = state.items.firstWhere((r) => r.id == recordId);

    // Cancel previous and schedule new notification
    NotificationService.cancelRecordReminder(recordId);
    if (date != null && time != null) {
      final itemName = updatedRecord.detail?.itemName ?? 'Record';
      final contactName = updatedRecord.detail?.contactName ?? 'this contact';
      final targetStr =
          "${updatedRecord.detail?.targetValue ?? 0} ${updatedRecord.detail?.unit ?? ''}";

      String smartPhrasing;
      switch (updatedRecord.detail?.type) {
        case RecordType.credit:
          smartPhrasing =
              "Follow up with $contactName about your $itemName ($targetStr).";
          break;
        case RecordType.debt:
          smartPhrasing =
              "Reminder: Settlement due to $contactName for $itemName ($targetStr).";
          break;
        default:
          smartPhrasing =
              "Time to update your $itemName with $contactName ($targetStr).";
      }

      NotificationService.scheduleRecordReminder(
        recordId: recordId,
        title: '$itemName Reminder',
        body: smartPhrasing,
        date: date,
        time: time,
        isRecurring: isRecurring,
      );
    }

    try {
      _saveAndSync(updatedRecord);
    } catch (e) {
      debugPrint('❌ Error updating reminder: $e');
    }
  }

  Future<void> clearAll() async {
    await _db.delete(_db.recordsTable).go();
    state = state.copyWith(items: []);
  }
}
