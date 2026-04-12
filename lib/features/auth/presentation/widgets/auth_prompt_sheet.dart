import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

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
              onPressed: () {
                Navigator.pop(context);
                context.go('/home'); // Simulate successful login
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
          GestureDetector(
            onTap: () {
              // Handle terms click
            },
            child: Text.rich(
              TextSpan(
                text: 'By continuing you agree to Node\'s ',
                children: [
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
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
