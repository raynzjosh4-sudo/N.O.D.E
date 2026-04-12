import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsOrderActions extends StatelessWidget {
  final int totalUnits;
  final VoidCallback onSaveDirectly;
  final VoidCallback onPickFromSaved;
  final VoidCallback onConfirm;

  const SpecsOrderActions({
    super.key,
    required this.totalUnits,
    required this.onSaveDirectly,
    required this.onPickFromSaved,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    if (totalUnits == 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Save Current setup icon
            GestureDetector(
              onTap: onSaveDirectly,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: onSurface.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.bookmark_add_rounded,
                  size: 18.w,
                  color: onSurface,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Bulk Order (Picker)
            GestureDetector(
              onTap: onPickFromSaved,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: onSurface.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.layers_rounded,
                      size: 14.w,
                      color: onSurface,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Bulk Order',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Confirm Order
            GestureDetector(
              onTap: onConfirm,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Create Order · $totalUnits units',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
