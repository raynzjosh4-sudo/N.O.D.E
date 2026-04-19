import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
          linux: initializationSettingsLinux,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(
          '🔔 [NotificationService] Notification Tapped: ${details.payload}',
        );
      },
    );
    _isInitialized = true;

    // Create a high-priority channel for Security Alerts
    const AndroidNotificationChannel securityChannel =
        AndroidNotificationChannel(
          'security_alerts',
          'Security Alerts',
          description: 'Critical updates about your account security',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(securityChannel);
  }

  /// Show a high-priority security notification
  static Future<void> showSecurityAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'security_alerts',
          'Security Alerts',
          channelDescription: 'Critical updates about your account security',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(''),
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  /// Show a simple confirmation notification for user actions
  static Future<void> showConfirmationAlert({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      debugPrint(
        '⚠️ [NotificationService] Plugin not initialized. Attempting lazy-init...',
      );
      try {
        await init();
      } catch (e) {
        debugPrint('❌ [NotificationService] Lazy-init failed: $e');
        return;
      }
    }

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'system_notifications',
            'System Notifications',
            channelDescription: 'Standard alerts for account and orders',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await _notificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        platformDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('❌ [NotificationService] Show Failed: $e');
      // We catch this to prevent LateInitializationErrors or Windows-specific issues from crashing the app
    }
  }
}
