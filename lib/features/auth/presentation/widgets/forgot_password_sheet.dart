import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ForgotPasswordSheet(),
    );
  }

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w,
        12.h,
        24.w,
        MediaQuery.of(context).viewInsets.bottom + 40.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C21) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ HANDLEBAR
          Center(
            child: Container(
              width: 32.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // 📢 TITLE
          Text(
            'Recover Account',
            style: GoogleFonts.outfit(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          SizedBox(height: 8.h),

          // ℹ️ SUBTITLE
          Text(
            'Enter your registered email address to receive a password recovery link.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: onSurface.withOpacity(0.5),
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),

          // 📧 EMAIL FIELD
          Text(
            'Email Address',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _emailController,
            style: TextStyle(fontSize: 14.sp),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'name@company.com',
              prefixIcon: Icon(
                Icons.email_outlined,
                size: 18.w,
                color: onSurface.withOpacity(0.3),
              ),
              hintStyle: GoogleFonts.plusJakartaSans(
                color: onSurface.withOpacity(0.2),
                fontSize: 13.sp,
              ),
              filled: true,
              fillColor: onSurface.withOpacity(0.03),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: onSurface.withOpacity(0.05)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: primary, width: 2.w),
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // 🚀 ACTION BUTTON
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () {
                // Simulate send action
                Navigator.pop(context);
                NodeToastManager.show(
                  context,
                  title: 'Email Sent',
                  message:
                      'If an account exists for ${_emailController.text}, you will receive a password reset link.',
                  status: NodeToastStatus.success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Send Reset Link',
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
