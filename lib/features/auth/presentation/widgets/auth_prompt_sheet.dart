import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/settingstab/pages/legal_terms_page.dart';
import 'package:flutter/gestures.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/features/auth/google/service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPromptSheet extends StatelessWidget {
  AuthPromptSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1C1C21) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🏷️ HANDLEBAR
          Container(
            width: 32.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // 📢 TITLE
          Text(
            'Log in is required',
            style: GoogleFonts.outfit(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),

          // ℹ️ SUBTITLE
          Text(
            'Keep your orders and account safe',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 20.h),

          // 🌐 CONTINUE WITH GOOGLE
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: OutlinedButton(
              onPressed: () async {
                try {
                  debugPrint('👉 [UI] Continue with Google button tapped!');
                  
                  // Show loading feedback
                  if (context.mounted) {
                    NodeToastManager.show(
                      context,
                      title: 'Authenticating',
                      message: 'Connecting to Google Secure Login...',
                      status: NodeToastStatus.info,
                    );
                  }

                  final authService = AuthService();
                  final response = await authService.signInWithGoogle();
                  
                  if (response != null && response.user != null) {
                    debugPrint('👉 [UI] Authentication complete. Checking business profile...');
                    
                    // Check if they have a business profile already
                    final existingBusiness = await Supabase.instance.client
                        .from('business_table')
                        .select()
                        .eq('user_id', response.user!.id)
                        .maybeSingle();

                    if (context.mounted) {
                      Navigator.pop(context);
                      
                      NodeToastManager.show(
                        context,
                        title: 'Success',
                        message: 'Welcome back to N.O.D.E.',
                        status: NodeToastStatus.success,
                      );

                      context.go('/home');
                    }
                  } else {
                    debugPrint('⚠️ [UI] Authentication returned null (cancelled).');
                    // No toast needed for cancellation by default, but let's clear any loading info
                  }
                } catch (error) {
                  debugPrint('❌ [UI] Button Error: $error');
                  if (context.mounted) {
                    final failure = Failure.fromException(error);
                    NodeToastManager.show(
                      context,
                      title: 'Login Failed',
                      message: failure.toFriendlyMessage(),
                      status: NodeToastStatus.error,
                    );
                  }
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/google/google-logo.png',
                    width: 18.w,
                    height: 18.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // 📜 CLICKABLE TERMS
          Text.rich(
            TextSpan(
              text: 'By continuing you agree to Node\'s ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              children: [
                TextSpan(
                  text: 'Terms of Service',
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
                  text: 'Privacy Policy',
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
          SizedBox(height: 20.h),

          // 🔗 BOTTOM ACTIONS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/signup');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Try signup',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/signup');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Signup',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
