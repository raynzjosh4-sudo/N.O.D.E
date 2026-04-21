import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/main_record_model.dart';

class AlertState {
  final MainRecordModel? activeRecord;
  final DateTime? triggeredAt;
  final bool isVisible;

  AlertState({this.activeRecord, this.triggeredAt, this.isVisible = false});

  AlertState copyWith({
    MainRecordModel? activeRecord,
    DateTime? triggeredAt,
    bool? isVisible,
  }) {
    return AlertState(
      activeRecord: activeRecord ?? this.activeRecord,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class AlertNotifier extends StateNotifier<AlertState> {
  AlertNotifier() : super(AlertState());

  Timer? _expiryTimer;

  void triggerAlert(MainRecordModel record) {
    _expiryTimer?.cancel();

    state = AlertState(
      activeRecord: record,
      triggeredAt: DateTime.now(),
      isVisible: true,
    );

    // Auto-expire after 20 minutes
    _expiryTimer = Timer(const Duration(minutes: 20), () {
      clearAlert();
    });
  }

  void clearAlert() {
    _expiryTimer?.cancel();
    state = state.copyWith(isVisible: false);
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }
}

final alertProvider = StateNotifierProvider<AlertNotifier, AlertState>((ref) {
  return AlertNotifier();
});
