import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

enum NodeToastStatus { success, error, info, warning }

class NodeToast extends StatelessWidget {
  final String title;
  final String? message;
  final NodeToastStatus status;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  const NodeToast({
    super.key,
    required this.title,
    this.message,
    this.status = NodeToastStatus.info,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  Color _getStatusColor() {
    switch (status) {
      case NodeToastStatus.success:
        return const Color(0xFF10B981); // Emerald
      case NodeToastStatus.error:
        return const Color(0xFFEF4444); // Red
      case NodeToastStatus.warning:
        return const Color(0xFFF59E0B); // Amber
      case NodeToastStatus.info:
        return const Color(0xFF3B82F6); // Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor();

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF18181B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Indicator (Left Bar)
            Container(
              width: 4.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (message != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      message!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444), // Red like the screenshot
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    actionLabel!,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close_rounded,
                size: 18.w,
                color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
