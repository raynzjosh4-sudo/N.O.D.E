import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';

final securityMonitorProvider = StreamProvider<NotificationItem>((ref) {
  final client = Supabase.instance.client;
  final userId = client.auth.currentUser?.id;

  if (userId == null) {
    return const Stream.empty();
  }

  debugPrint(
    '🛡️ [SecurityMonitor] Starting real-time security listener for user: $userId',
  );

  // Listen to insertions in the notifications_table
  return client
      .from('notifications_table')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((data) {
        if (data.isEmpty) return null;

        // We only care about the latest security notification
        final latest = data.first;
        final item = NotificationItem.fromMap(latest);

        if (item.category == NotificationCategory.security && item.isUnread) {
          debugPrint('🚨 [SecurityMonitor] URGENT SECURITY EVENT DETECTED!');
          return item;
        }
        return null;
      })
      .where((item) => item != null)
      .cast<NotificationItem>();
});
