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
import 'features/home/presentation/pages/notifications/data/security_monitor_service.dart';
import 'features/home/presentation/pages/notifications/widgets/security_lockdown_dialog.dart';
import 'features/home/presentation/pages/notifications/presentation/providers/notification_providers.dart';
import 'core/services/notification_service.dart';

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
  } catch (e) {
    debugPrint('⚠️ [Main] Firebase initialization skipped: $e');
    debugPrint('   (Ensure you have run "flutterfire configure")');
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

  runApp(
    ProviderScope(
      observers: [LoggerObserver()],
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
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
      routerConfig: router,
      builder: (context, child) {
        SizeConfig.init(context);
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
