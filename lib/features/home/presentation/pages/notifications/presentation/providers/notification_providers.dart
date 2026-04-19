import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/notification_repository.dart';
import '../../models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(Supabase.instance.client);
});

final notificationListProvider =
    StateNotifierProvider<
      NotificationListNotifier,
      AsyncValue<List<NotificationItem>>
    >(
      (ref) =>
          NotificationListNotifier(ref.watch(notificationRepositoryProvider)),
    );

class NotificationListNotifier
    extends StateNotifier<AsyncValue<List<NotificationItem>>> {
  final NotificationRepository _repository;

  NotificationListNotifier(this._repository)
    : super(const AsyncValue.loading()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    state = const AsyncValue.loading();
    final result = await _repository.getNotifications();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (notifications) => state = AsyncValue.data(notifications),
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await _repository.markAsRead(id);
    if (result.isRight()) {
      // Optimistic Update
      state.whenData((notifications) {
        state = AsyncValue.data(
          notifications
              .map((n) => n.id == id ? _copyWithIsUnread(n, false) : n)
              .toList(),
        );
      });
    }
  }

  Future<void> markAllAsRead() async {
    final result = await _repository.markAllAsRead();
    if (result.isRight()) {
      // Optimistic Update
      state.whenData((notifications) {
        state = AsyncValue.data(
          notifications.map((n) => _copyWithIsUnread(n, false)).toList(),
        );
      });
    }
  }

  // Simple copyWith helper since it's not in the model
  NotificationItem _copyWithIsUnread(NotificationItem n, bool isUnread) {
    return NotificationItem(
      id: n.id,
      title: n.title,
      description: n.description,
      time: n.time,
      category: n.category,
      isUnread: isUnread,
      metadata: n.metadata,
    );
  }
}
