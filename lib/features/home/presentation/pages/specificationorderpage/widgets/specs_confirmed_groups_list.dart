import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import '../order_models.dart';

class SpecsConfirmedGroupsList extends StatelessWidget {
  final List<ColorGroup> confirmedGroups;
  final Function(ColorGroup) onEdit;
  final Function(ColorGroup) onDelete;

  const SpecsConfirmedGroupsList({
    super.key,
    required this.confirmedGroups,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (confirmedGroups.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
      child: Column(
        children: confirmedGroups.map((g) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                bottom: BorderSide(
                  color: onSurface.withOpacity(0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                // Add/Edit button (Left)
                GestureDetector(
                  onTap: () => onEdit(g),
                  child: Icon(
                    Icons.add_rounded,
                    size: 16.w,
                    color: primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: g.color.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    g.color.label,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: onSurface,
                    ),
                  ),
                ),
                // Delete button (Right)
                GestureDetector(
                  onTap: () => onDelete(g),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16.w,
                    color: onSurface.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
