import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsOrderHeader extends StatelessWidget {
  final String productName;
  final int totalUnits;
  final VoidCallback onBack;

  const SpecsOrderHeader({
    super.key,
    required this.productName,
    required this.totalUnits,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: onSurface.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 18.w,
                color: onSurface,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Order',
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  productName,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    color: onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          // Total units badge
          if (totalUnits > 0)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$totalUnits units',
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
