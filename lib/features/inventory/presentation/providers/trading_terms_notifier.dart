import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/database/database_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

final tradingTermsProvider =
    AsyncNotifierProvider<TradingTermsNotifier, List<TradingTermsEntry>>(
      TradingTermsNotifier.new,
    );

class TradingTermsNotifier extends AsyncNotifier<List<TradingTermsEntry>> {
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  FutureOr<List<TradingTermsEntry>> build() async {
    return _loadTerms();
  }

  Future<List<TradingTermsEntry>> _loadTerms() async {
    return _db.select(_db.tradingTermsTable).get();
  }

  Future<void> addTerms({
    required String moq,
    required String warranty,
    required String paymentTerms,
    required String deliveryTerms,
    required String content,
  }) async {
    final entry = TradingTermsTableCompanion.insert(
      id: const Uuid().v4(),
      moq: Value(moq),
      warranty: Value(warranty),
      paymentTerms: Value(paymentTerms),
      deliveryTerms: Value(deliveryTerms),
      content: content,
    );

    await _db.into(_db.tradingTermsTable).insert(entry);
    ref.invalidateSelf();
  }

  Future<void> updateTerms(TradingTermsEntry entry) async {
    await (_db.update(
      _db.tradingTermsTable,
    )..where((t) => t.id.equals(entry.id))).write(
      TradingTermsTableCompanion(
        moq: Value(entry.moq),
        warranty: Value(entry.warranty),
        paymentTerms: Value(entry.paymentTerms),
        deliveryTerms: Value(entry.deliveryTerms),
        content: Value(entry.content),
        updatedAt: Value(DateTime.now()),
      ),
    );
    ref.invalidateSelf();
  }

  Future<void> deleteTerms(String id) async {
    await (_db.delete(
      _db.tradingTermsTable,
    )..where((t) => t.id.equals(id))).go();
    ref.invalidateSelf();
  }
}
