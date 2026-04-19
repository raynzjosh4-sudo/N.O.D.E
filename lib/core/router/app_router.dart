import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/settingstab/pages/profile_management_page.dart';
// Removed dummy import
import '../../features/inventory/presentation/pages/inventory_screen.dart';
import '../../features/auth/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
// Removed redundant business_setup_screen import
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/pages/product_detail_screen.dart';
import '../../features/home/presentation/pages/notifications/notification_page.dart';
// Removed dummy import
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/tabs/orderdetailpage/scan_page.dart';
import '../../features/profile/presentation/pages/pdf_viewer_page.dart';
import '../../features/profile/domain/entities/pdf_document.dart';
import '../../features/profile/presentation/pages/profile/profile_page.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  debugPrint('🚀 [Router] Initializing GoRouter...');

  // 🌉 Watch our specialized RouterNotifier bridge
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/welcome',
    debugLogDiagnostics: true,
    refreshListenable:
        routerNotifier, // Re-evaluates redirect logic when auth changes
    redirect: (context, state) {
      final isAuthenticated = routerNotifier.isAuthenticated;

      // 🔐 Define protected routes that require authentication
      final protectedRoutes = [
        '/profile',
        '/profile-management',
        '/settings',
        '/pdf-viewer',
      ];

      final isProtectedRoute = protectedRoutes.any(
        (route) => state.matchedLocation.startsWith(route),
      );

      // Determine if the user is on an "Auth" page or Welcome
      final isWelcomePage = state.matchedLocation == '/welcome';
      final isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          isWelcomePage;

      // 🛡️ Guard 1: If NOT authenticated and trying to access a PROTECTED route, go to Welcome
      if (!isAuthenticated && isProtectedRoute) {
        debugPrint(
          '🛑 [Router] Unauthenticated access to ${state.matchedLocation}. Redirecting to /welcome',
        );
        return '/welcome';
      }

      // 🛡️ Guard 2: If authenticated and on Welcome or Auth pages, always go HOME
      if (isAuthenticated && isAuthPage) {
        debugPrint('🎯 [Router] User authenticated. Forced redirect to /home');
        return '/home';
      }

      return null; // All good, stay where you are
    },
    routes: [
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutQuint)),
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: SignupScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutQuint)),
              ),
              child: child,
            );
          },
        ),
      ),
      // Deleted redundant business-setup route
      GoRoute(
        path: '/inventory',
        name: 'inventory',
        builder: (context, state) => InventoryScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/product-detail',
        name: 'product-detail',
        builder: (context, state) => ProductDetailScreen(),
      ),
      GoRoute(
        path: '/product-specs',
        name: 'product-specs',
        builder: (context, state) {
          // Route should be passed a product via extra, fallback to detail
          return ProductDetailScreen();
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => SettingsPage(),
      ),
      GoRoute(
        path: '/scan',
        name: 'scan',
        builder: (context, state) => const ScanPage(),
      ),
      GoRoute(
        path: '/pdf-viewer',
        name: 'pdf-viewer',
        builder: (context, state) {
          final doc = state.extra as PdfDocument;
          return PdfViewerPage(doc: doc);
        },
      ),

      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/profile-management',
        name: 'profile-management',
        builder: (context, state) => ProfileManagementPage(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationPage(),
      ),
    ],
  );
});
