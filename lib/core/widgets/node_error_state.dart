import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import '../theme/app_theme.dart';
import '../error/failure.dart';

class NodeErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final bool compact;

  const NodeErrorState({
    super.key,
    required this.error,
    required this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    final message = Failure.fromException(error).toFriendlyMessage();

    if (compact) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: colors.errorRed.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.errorRed.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.alertCircle, color: colors.errorRed, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  color: colors.errorRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                LucideIcons.refreshCcw,
                color: colors.errorRed,
                size: 18.w,
              ),
              onPressed: onRetry,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colors.accentCyan.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.cloudOff,
                size: 48.w,
                color: colors.accentCyan,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Wholesale Hub Offline',
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(LucideIcons.rotateCw, size: 18.w),
              label: const Text('Re-optimize Connection'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
