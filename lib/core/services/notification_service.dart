import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

/// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
    '🌙 [NotificationService] Background message received: ${message.messageId}',
  );
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static bool _isFirebaseMessagingInitialized = false;

  /// Stream to listen for notification taps across the app
  static final StreamController<String?> _onNotificationTap =
      StreamController<String?>.broadcast();
  static Stream<String?> get onNotificationTap => _onNotificationTap.stream;

  static Future<void> init() async {
    // 🌍 [Timezone] Initialize for scheduled notifications
    try {
      tz.initializeTimeZones();
      // flutter_timezone v5 returns a TimezoneInfo object — use .identifier
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
      debugPrint(
        '🌍 [NotificationService] Timezone set to: ${timezoneInfo.identifier}',
      );
    } catch (e) {
      debugPrint(
        '⚠️ [NotificationService] Timezone init failed, falling back to UTC: $e',
      );
    }

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
          windows: WindowsInitializationSettings(
            appName: 'N.O.D.E',
            appUserModelId: 'com.raynzflamez.node_app',
            guid: 'AD8E8E8E-8E8E-8E8E-8E8E-8E8E8E8E8E8E',
          ),
        );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(
          '🔔 [NotificationService] Notification Tapped (Local): ${details.payload}',
        );
        _onNotificationTap.add(details.payload);
      },
    );
    _isInitialized = true;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await _requestPermissions();
      await _createNotificationChannels();
    }
  }

  /// 🛰️ Initialize Push Notifications (FCM)
  static Future<void> initFirebaseMessaging() async {
    if (_isFirebaseMessagingInitialized) return;

    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // 1. Request OS-level permissions
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint(
        '🛰️ [NotificationService] FCM Authorization: ${settings.authorizationStatus}',
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }

      // 2. Handle foreground messages explicitly
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          '🛰️ [NotificationService] Foreground message: ${message.notification?.title}',
        );

        // Convert push message to local heads-up notification
        if (message.notification != null) {
          showConfirmationAlert(
            title: message.notification!.title ?? 'New Update',
            body: message.notification!.body ?? '',
            payload: message.data['payload'] ?? message.data['route'],
          );
        }
      });

      // 3. Handle app opening from a push notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🎯 [NotificationService] FCM Opened App: ${message.data}');
        final payload = message.data['payload'] ?? message.data['route'];
        if (payload != null) {
          _onNotificationTap.add(payload.toString());
        }
      });

      // 4. Check for initial message (if app was terminated)
      final initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '🎯 [NotificationService] Initial FCM Message: ${initialMessage.data}',
        );
        final payload =
            initialMessage.data['payload'] ?? initialMessage.data['route'];
        if (payload != null) {
          _onNotificationTap.add(payload.toString());
        }
      }

      _isFirebaseMessagingInitialized = true;
      debugPrint('✅ [NotificationService] Firebase Messaging initialized');
    } catch (e) {
      debugPrint('❌ [NotificationService] FCM Init Failed: $e');
    }
  }

  /// Static getter for the background handler function
  static Future<void> Function(RemoteMessage) get backgroundHandler =>
      _firebaseMessagingBackgroundHandler;

  static Future<void> _requestPermissions() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final bool? granted = await androidPlugin
          .requestNotificationsPermission();
      debugPrint(
        '🛡️ [NotificationService] Notifications Permission: $granted',
      );

      final bool? exactGranted = await androidPlugin
          .requestExactAlarmsPermission();
      debugPrint(
        '🛡️ [NotificationService] Exact Alarm Permission: $exactGranted',
      );
    }
  }

  static Future<void> _createNotificationChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    const securityChannel = AndroidNotificationChannel(
      'security_alerts',
      'Security Alerts',
      description: 'Critical updates about your account security',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const reminderChannel = AndroidNotificationChannel(
      'record_reminders',
      'Record Reminders',
      description: 'Alerts for your scheduled payments and tasks',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const systemChannel = AndroidNotificationChannel(
      'system_notifications',
      'System Notifications',
      description: 'Standard alerts for account and orders',
      importance: Importance.defaultImportance,
    );

    await androidPlugin.createNotificationChannel(securityChannel);
    await androidPlugin.createNotificationChannel(reminderChannel);
    await androidPlugin.createNotificationChannel(systemChannel);
    debugPrint(
      '📺 [NotificationService] All notification channels initialized.',
    );
  }

  static Future<bool> canScheduleExactAlarms() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return await Permission.scheduleExactAlarm.isGranted;
    }
    return true;
  }

  static Future<bool> areNotificationsEnabled() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    }
    // For iOS, it's checked during init, but we can assume true if init succeeded or request it again
    return true;
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
      id: DateTime.now().millisecond % 1000000,
      title: title,
      body: body,
      notificationDetails: platformDetails,
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
        id: DateTime.now().millisecond % 1000000,
        title: title,
        body: body,
        notificationDetails: platformDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('❌ [NotificationService] Show Failed: $e');
    }
  }

  /// Schedule a notification for a specific record reminder
  static Future<void> scheduleRecordReminder({
    required String recordId,
    required String title,
    required String body,
    required DateTime date,
    required String time, // Format: HH:mm
    bool isRecurring = false,
  }) async {
    if (!_isInitialized) await init();

    // zonedSchedule is Android/iOS only — skip silently on Windows/Linux/Web
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      debugPrint(
        '⚠️ [NotificationService] Scheduled notifications not supported on this platform. Skipping.',
      );
      return;
    }

    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = tz.TZDateTime.now(tz.local);

      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );

      final delay = scheduledDate.difference(now);

      debugPrint('🕒 [NotificationService] Sync Check:');
      debugPrint('   - Now (Local): $now');
      debugPrint('   - Target:     $scheduledDate');
      debugPrint('   - Delay:      ${delay.inSeconds} seconds');

      // If already in the past handle based on type
      if (scheduledDate.isBefore(now)) {
        if (isRecurring) {
          // Advance to tomorrow for recurring reminders where today's slot passed
          scheduledDate = scheduledDate.add(const Duration(days: 1));
          debugPrint(
            '🔁 [NotificationService] Time passed today; scheduling for tomorrow: $scheduledDate (${scheduledDate.difference(now).inHours}h away)',
          );
        } else {
          debugPrint(
            '⚠️ [NotificationService] ABORT: Scheduled time is in the past ($now vs $scheduledDate).',
          );
          return;
        }
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'record_reminders',
            'Record Reminders',
            channelDescription: 'Alerts for your scheduled payments and tasks',
            importance: Importance.max,
            priority: Priority.high,
          );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final int notificationId = recordId.hashCode.abs();

      try {
        if (isRecurring) {
          await _notificationsPlugin.zonedSchedule(
            id: notificationId,
            title: title,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: platformDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: 'record_detail:$recordId',
          );
        } else {
          await _notificationsPlugin.zonedSchedule(
            id: notificationId,
            title: title,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: platformDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: 'record_detail:$recordId',
          );
        }

        debugPrint(
          '✅ [NotificationService] SUCCESS: Scheduled $notificationId for $scheduledDate',
        );
      } catch (e) {
        debugPrint('🚨 [NotificationService] NATIVE ERROR during schedule: $e');
        if (e.toString().contains('ExactAlarmPermissionException')) {
          debugPrint(
            '💡 [Hint] Exact Alarm permission is MISSING. Reminders will fail until granted.',
          );
        }
      }

      debugPrint(
        '✅ [NotificationService] Scheduled reminder for $recordId at $scheduledDate',
      );
    } catch (e) {
      debugPrint('❌ [NotificationService] Schedule Failed: $e');
    }
  }

  /// 🔁 Re-schedule ALL active reminders on app startup.
  /// Call this during init to survive device reboots (Android clears
  /// all scheduled alarms when the device restarts).
  static Future<void> rescheduleAllReminders(
    List<
      ({
        String recordId,
        String contactName,
        double targetValue,
        DateTime date,
        String time,
        bool isRecurring,
      })
    >
    reminders,
  ) async {
    if (!_isInitialized) await init();

    int rescheduled = 0;
    int skipped = 0;

    for (final r in reminders) {
      try {
        // Skip reminders that have no time set
        if (r.time.isEmpty) {
          skipped++;
          continue;
        }

        final parts = r.time.split(':');
        if (parts.length < 2) {
          skipped++;
          continue;
        }

        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final now = DateTime.now();

        // Build the next fire time
        DateTime nextFire = DateTime(
          r.date.year,
          r.date.month,
          r.date.day,
          hour,
          minute,
        );

        // For recurring reminders, if today's slot already passed, use tomorrow
        if (nextFire.isBefore(now)) {
          if (r.isRecurring) {
            nextFire = nextFire.add(const Duration(days: 1));
          } else {
            // One-time reminder already past — skip
            skipped++;
            continue;
          }
        }

        // Use the actual record type if available, otherwise fallback.
        // During startup, types would normally come from the DB/Model.
        // Here we assume r has the required info or we use a safe default.
        final targetStr = "${r.targetValue} Units";
        // Simple fallback phrasing for bulk rescheduling
        final bodyText = "Follow up with ${r.contactName} ($targetStr).";

        await scheduleRecordReminder(
          recordId: r.recordId,
          title: '${r.contactName} Reminder',
          body: bodyText,
          date: nextFire,
          time: r.time,
          isRecurring: r.isRecurring,
        );
        rescheduled++;
      } catch (e) {
        debugPrint(
          '❌ [NotificationService] Failed to reschedule ${r.recordId}: $e',
        );
      }
    }

    debugPrint(
      '🔁 [NotificationService] Rescheduled $rescheduled reminders. Skipped $skipped (past or invalid).',
    );
  }

  /// Cancel a scheduled reminder
  static Future<void> cancelRecordReminder(String recordId) async {
    await _notificationsPlugin.cancel(id: recordId.hashCode.abs());
  }
}
