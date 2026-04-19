import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/settingstab/pages/legal_terms_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import '../providers/auth_providers.dart';

class SmartSignInSheet extends ConsumerWidget {
  const SmartSignInSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C21) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ TOP ROW with N.O.D.E icon & Close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/google/google-logo.png',
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.close_rounded,
                  size: 20.w,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // 📢 TITLE
          Text(
            'Sign in to N.O.D.E.',
            style: GoogleFonts.outfit(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              height: 1.1,
            ),
          ),
          SizedBox(height: 8.h),

          // ℹ️ SUBTITLE
          Text(
            'Sign in with Google to access your wholesale dashboard, manage inventory, and track orders.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.sp,
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 28.h),

          // 🚀 PRIMARY ACTION: CONTINUE WITH GOOGLE
          ElevatedButton(
            onPressed: () async {
              try {
                // Show loading feedback
                if (context.mounted) {
                  NodeToastManager.show(
                    context,
                    title: 'Authenticating',
                    message: 'Connecting to Google Secure Login...',
                    status: NodeToastStatus.info,
                  );
                }

                final authService = ref.read(authServiceProvider);
                final response = await authService.signInWithGoogle();

                if (response != null && response.user != null) {
                  if (context.mounted) {
                    Navigator.pop(context); // Close sheet

                    NodeToastManager.show(
                      context,
                      title: 'Success',
                      message: 'Welcome back to N.O.D.E.',
                      status: NodeToastStatus.success,
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  final failure = Failure.fromException(e);
                  NodeToastManager.show(
                    context,
                    title: 'Login Failed',
                    message: failure.toFriendlyMessage(),
                    status: NodeToastStatus.error,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 54.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue with Google',
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_rounded, size: 18.w),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // ℹ️ FOOTER / ALTERNATIVE
          Center(
            child: Column(
              children: [
                Text(
                  'Secure wholesale access powered by Google Authentication.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 8.h),
                Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.sp,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => LegalTermsPage.show(
                                context,
                                termId: 'tos',
                                title: 'Terms of Service',
                              ),
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => LegalTermsPage.show(
                                context,
                                termId: 'privacy',
                                title: 'Privacy Policy',
                              ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
