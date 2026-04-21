import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/home/presentation/pages/notifications/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/theme_provider.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'features/home/presentation/pages/notifications/data/security_monitor_service.dart';
import 'features/home/presentation/pages/notifications/widgets/security_lockdown_dialog.dart';
import 'features/home/presentation/pages/notifications/presentation/providers/notification_providers.dart';
import 'core/services/notification_service.dart';
import 'features/records/presentation/records/pages/record_detail_page.dart';
import 'features/records/presentation/providers/records_provider.dart';
import 'dart:async';

final class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (newValue is AsyncError) {
      debugPrint(
        '🚨 [Riverpod Error] Provider: ${context.provider.name ?? context.provider.runtimeType}',
      );
      debugPrint('   Error: ${newValue.error}');
      debugPrint('   Stack: ${newValue.stackTrace}');
    }
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint(
      '🚨 [Riverpod Failure] Provider: ${context.provider.name ?? context.provider.runtimeType}',
    );
    debugPrint('   Error: $error');
    debugPrint('   Stack: $stackTrace');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pdfrxFlutterInitialize(dismissPdfiumWasmWarnings: true);

  // 🔔 Initialize Local Notifications
  await NotificationService.init();

  try {
    // 🔥 Initialize Firebase
    await Firebase.initializeApp();
    debugPrint('🔥 [Main] Firebase initialized successfully');

    // 🛰️ Initialize FCM Listeners & Permissions
    await NotificationService.initFirebaseMessaging();

    // 🌙 Register Background Message Handler
    FirebaseMessaging.onBackgroundMessage(NotificationService.backgroundHandler);
  } catch (e) {
    debugPrint('⚠️ [Main] Firebase initialization skipped: $e');
  }

  try {
    // 🔐 Load the hidden .env file
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  } catch (e) {
    debugPrint('Initialization error: $e');
    // We proceed anyway so the app can show an 'Offline' state or its UI
  }

  final prefs = await SharedPreferences.getInstance();

  // 🛡️ [Security] Global Error Handling for Production
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('🚨 [Global Error] ${details.exception}');
  };

  runApp(
    ProviderScope(
      observers: [LoggerObserver()],
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription? _notificationSub;

  @override
  void initState() {
    super.initState();

    // 🔔 [Notification Navigation] Listen for system-wide notification taps
    _notificationSub = NotificationService.onNotificationTap.listen((payload) {
      if (payload == null) return;

      debugPrint('🎯 [App] Handling notification payload: $payload');

      if (payload.startsWith('record_detail:')) {
        final recordId = payload.split(':')[1];
        // Find the record in the current state
        final records = ref.read(recordsProvider);
        try {
          final record = records.items.firstWhere((r) => r.id == recordId);
          // We use the root navigator to show the detail page
          final navContext = rootNavigatorKey.currentContext;
          if (navContext != null) {
            RecordDetailPage.show(navContext, record: record);
          }
        } catch (e) {
          debugPrint(
            '⚠️ [App] Could not find record for navigation: $recordId',
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _notificationSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    // 🛡️ [Security Monitor] Listen for real-time security alerts globally
    ref.listen(securityMonitorProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        final notification = next.value!;
        _showSecurityAlert(context, ref, notification);
      }
    });

    return MaterialApp.router(
      title: 'NODE Wholesale',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        SizeConfig.init(context);

        // 🛡️ [Production] Custom Error Screen instead of Red Screen
        ErrorWidget.builder = (details) {
          return Material(
            child: Container(
              color: AppTheme.darkTheme.scaffoldBackgroundColor,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The application encountered an unexpected state. Please restart or contact support if this persists.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        };

        return child!;
      },
    );
  }

  void _showSecurityAlert(
    BuildContext context,
    WidgetRef ref,
    NotificationItem notification,
  ) {
    final navigatorContext = rootNavigatorKey.currentContext;
    if (navigatorContext == null) return;

    // 🔔 Trigger Local System Notification
    NotificationService.showSecurityAlert(
      title: 'SECURITY ALERT',
      body:
          notification.description ??
          'A new login was detected on your account.',
      payload: 'security_lockdown',
    );

    showDialog(
      context: navigatorContext,
      barrierDismissible: false, // Force User Action
      builder: (context) => SecurityLockdownDialog(
        notification: notification,
        onLock: () async {
          // 🛑 [ACTION] LOCK ALL SESSIONS
          final result = await ref
              .read(notificationRepositoryProvider)
              .lockAccount();
          if (result.isRight() && context.mounted) {
            Navigator.pop(context);
          }
        },
        onDismiss: () async {
          // ✅ [ACTION]   (Mark as read)
          await ref
              .read(notificationListProvider.notifier)
              .markAsRead(notification.id);
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
