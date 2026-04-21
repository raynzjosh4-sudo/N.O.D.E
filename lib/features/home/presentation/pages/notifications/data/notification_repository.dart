import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/core/error/failure.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final SupabaseClient _client;

  NotificationRepository(this._client);

  /// Fetch notifications for the current authenticated user with pagination and filtering
  Future<Either<Failure, List<NotificationItem>>> getNotifications({
    int limit = 10,
    int offset = 0,
    String? category,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null)
        return const Left(ServerFailure('User not authenticated'));

      var query = _client
          .from('notifications_table')
          .select()
          .eq('user_id', userId);

      if (category != null && category.toLowerCase() != 'all') {
        query = query.eq('category', category.toLowerCase());
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List;
      final notifications = data
          .map((row) => NotificationItem.fromMap(row))
          .toList();

      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Mark a single notification as read
  Future<Either<Failure, Unit>> markAsRead(String id) async {
    try {
      await _client
          .from('notifications_table')
          .update({'is_unread': false})
          .eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Mark all notifications as read for the current user
  Future<Either<Failure, Unit>> markAllAsRead() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null)
        return const Left(ServerFailure('User not authenticated'));

      await _client
          .from('notifications_table')
          .update({'is_unread': false})
          .eq('user_id', userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Delete a notification permanently
  Future<Either<Failure, Unit>> deleteNotification(String id) async {
    try {
      await _client.from('notifications_table').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Create a new notification record in Supabase
  Future<Either<Failure, Unit>> createNotification({
    required String userId,
    required String title,
    String? description,
    required String category,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _client.from('notifications_table').insert({
        'user_id': userId,
        'title': title,
        'description': description,
        'category': category.toLowerCase(),
        'is_unread': true,
        'metadata': metadata,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Broadcast a push notification to all administrator users
  Future<Either<Failure, Unit>> notifyAdmins({
    required String title,
    String? description,
    required String category,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // 1. Fetch all users whose role is explicitly 'admin'
      final response = await _client
          .from('users_table')
          .select('id')
          .eq('role', 'admin');

      final List<dynamic> admins = response as List;

      // 2. Dispatch a notification to each identified admin
      for (final admin in admins) {
        final adminId = admin['id'] as String;
        await createNotification(
          userId: adminId,
          title: title,
          description: description,
          category: category,
          metadata: metadata,
        );
      }

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Sign out from all devices globally
  Future<Either<Failure, Unit>> lockAccount() async {
    try {
      await _client.auth.signOut(scope: SignOutScope.global);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
