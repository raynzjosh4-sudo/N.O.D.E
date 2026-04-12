import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Removed dummy import
import '../../features/inventory/presentation/pages/inventory_screen.dart';
import '../../features/auth/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/pages/product_detail_screen.dart';
import '../../features/home/presentation/pages/productspecificationpage/product_specs_screen.dart';
// Removed dummy import
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/tabs/orderdetailpage/scan_page.dart';
import '../../features/profile/presentation/pages/pdf_viewer_page.dart';
import '../../features/profile/domain/entities/pdf_document.dart';

import 'package:flutter/material.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
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
    ],
  );
});
