import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Removed dummy import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:node_app/features/auth/domain/entities/saved_account.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SmartSignInSheet extends StatelessWidget {
  SmartSignInSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1C1C21) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/google/google-logo.png',
                    width: 16.w,
                    height: 16.h,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.close_rounded,
                  size: 20.w,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // 📢 TITLE
          Text(
            'Sign in to Node with your saved password',
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              height: 1.2.h,
            ),
          ),
          SizedBox(height: 4.h),

          // ℹ️ SUBTITLE
          Text(
            'You saved your Node passwords in your Google Account.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 16.h),

          Column(
            children: [].map((account) {
              final isLast = true; // Placeholder
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 12.0),
                child: _buildAccountRow(context, account),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountRow(BuildContext context, SavedAccount account) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icon/nodeicon.svg',
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  account.email,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  account.maskedPassword,
                  style: TextStyle(
                    fontSize: 10.sp,
                    letterSpacing: 2,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w900,
                    height: 1.0.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // 🚀 SMALL IN-ROW CONTINUE BUTTON
          SizedBox(
            height: 28.h,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.outfit(
                  fontSize: 11.sp,
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
