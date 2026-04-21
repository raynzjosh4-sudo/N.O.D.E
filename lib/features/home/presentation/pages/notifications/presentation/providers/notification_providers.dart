import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/notification_repository.dart';
import '../../models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(Supabase.instance.client);
});

class NotificationState {
  final List<NotificationItem> items;
  final bool isLoading;
  final bool hasMore;
  final NotificationCategory category;

  NotificationState({
    required this.items,
    this.isLoading = false,
    this.hasMore = true,
    this.category = NotificationCategory.all,
  });

  NotificationState copyWith({
    List<NotificationItem>? items,
    bool? isLoading,
    bool? hasMore,
    NotificationCategory? category,
  }) {
    return NotificationState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      category: category ?? this.category,
    );
  }
}

final notificationListProvider =
    StateNotifierProvider<NotificationListNotifier, NotificationState>((ref) {
  return NotificationListNotifier(ref.watch(notificationRepositoryProvider));
});

class NotificationListNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;
  static const int _pageSize = 10;

  NotificationListNotifier(this._repository)
    : super(NotificationState(items: [])) {
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(items: [], isLoading: true, hasMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await _repository.getNotifications(
      limit: _pageSize,
      offset: 0,
      category: state.category == NotificationCategory.all ? null : state.category.name,
    );

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, hasMore: false),
      (notifications) {
        state = state.copyWith(
          items: notifications,
          isLoading: false,
          hasMore: notifications.length >= _pageSize,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    final currentOffset = state.items.length;

    final result = await _repository.getNotifications(
      limit: _pageSize,
      offset: currentOffset,
      category: state.category == NotificationCategory.all ? null : state.category.name,
    );

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, hasMore: false),
      (notifications) {
        state = state.copyWith(
          items: [...state.items, ...notifications],
          isLoading: false,
          hasMore: notifications.length >= _pageSize,
        );
      },
    );
  }

  Future<void> changeCategory(NotificationCategory category) async {
    if (state.category == category) return;
    state = state.copyWith(category: category, items: [], hasMore: true);
    await fetchNotifications();
  }

  Future<void> markAsRead(String id) async {
    final result = await _repository.markAsRead(id);
    if (result.isRight()) {
      state = state.copyWith(
        items: state.items
            .map((n) => n.id == id ? _copyWithIsUnread(n, false) : n)
            .toList(),
      );
    }
  }

  Future<void> markAllAsRead() async {
    final result = await _repository.markAllAsRead();
    if (result.isRight()) {
      state = state.copyWith(
        items: state.items.map((n) => _copyWithIsUnread(n, false)).toList(),
      );
    }
  }

  Future<void> deleteNotification(String id) async {
    final previousItems = state.items;
    state = state.copyWith(items: state.items.where((n) => n.id != id).toList());

    final result = await _repository.deleteNotification(id);
    result.fold(
      (failure) => state = state.copyWith(items: previousItems),
      (_) => null,
    );
  }

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
