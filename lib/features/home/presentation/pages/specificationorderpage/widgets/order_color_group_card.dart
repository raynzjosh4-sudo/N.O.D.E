import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../order_models.dart';
import 'package:node_app/core/utils/responsive_size.dart';

/// Displays one confirmed ColorGroup as a card with a remove button.
class OrderColorGroupCard extends StatelessWidget {
  final ColorGroup group;
  final VoidCallback onRemove;

  OrderColorGroupCard({
    super.key,
    required this.group,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: onSurface.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color dot + name
          Row(
            children: [
              Container(
                width: 14.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: group.color.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: onSurface.withOpacity(0.1)),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                group.color.label,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: onSurface,
                ),
              ),
              SizedBox(width: 12.w),
            ],
          ),
          // Size chips
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: group.sizeQtys.entries.map((e) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${e.key} ×${e.value}',
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 8.w),
          // Remove
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 18.w,
              color: onSurface.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}
