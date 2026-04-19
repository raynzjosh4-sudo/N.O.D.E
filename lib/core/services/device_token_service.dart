import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final deviceTokenServiceProvider = Provider<DeviceTokenService>((ref) {
  return DeviceTokenService(Supabase.instance.client);
});

class DeviceTokenService {
  final SupabaseClient _supabase;

  DeviceTokenService(this._supabase);

  /// Retrieves the operating system as the device_type.
  String _getDeviceType() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Syncs the actual Firebase Cloud Messaging (FCM) token to Supabase.
  /// Call this hook during login or when a session is initialized.
  Future<void> syncDeviceToken(String userId) async {
    try {
      debugPrint('📡 [DeviceTokenService] Requesting FCM permission...');
      
      // 1. Request Permission
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('❌ [DeviceTokenService] FCM Permission Denied');
        return;
      }

      // 2. Fetch the FCM token
      debugPrint('📡 [DeviceTokenService] Fetching FCM token...');
      final fcmToken = await FirebaseMessaging.instance.getToken();
      
      if (fcmToken == null) {
        debugPrint('❌ [DeviceTokenService] FCM Token is null');
        return;
      }

      final deviceType = _getDeviceType();

      debugPrint('📡 [DeviceTokenService] Syncing token to cloud for user: $userId');

      // 3. Sync token to user_tokens table.
      // We check if a row exists first, then insert or update to avoid
      // needing a UNIQUE constraint on device_token (which caused error 42P10).
      final existing = await _supabase
          .from('user_tokens')
          .select('id')
          .eq('device_token', fcmToken)
          .maybeSingle();

      if (existing != null) {
        // Row exists — update last_active_at
        await _supabase
            .from('user_tokens')
            .update({
              'user_id': userId,
              'device_type': deviceType,
              'last_active_at': DateTime.now().toUtc().toIso8601String(),
            })
            .eq('device_token', fcmToken);
      } else {
        // New token — insert fresh row
        await _supabase.from('user_tokens').insert({
          'user_id': userId,
          'device_token': fcmToken,
          'device_type': deviceType,
          'last_active_at': DateTime.now().toUtc().toIso8601String(),
        });
      }

      debugPrint('✅ [DeviceTokenService] FCM Token synced successfully: ${fcmToken.substring(0, 10)}...');
    } catch (e) {
      debugPrint('❌ [DeviceTokenService] Failed to sync device token: $e');
    }
  }

  /// Cleans up old device tokens if needed (Optional)
  Future<void> removeToken(String token) async {
    try {
      await _supabase.from('user_tokens').delete().eq('device_token', token);
    } catch (e) {
      debugPrint('❌ [DeviceTokenService] Failed to remove token: $e');
    }
  }
}
