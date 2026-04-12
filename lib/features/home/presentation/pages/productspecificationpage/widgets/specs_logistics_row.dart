import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsLogisticsRow extends StatelessWidget {
  final int stock;
  final int leadTimeDays;

  SpecsLogisticsRow({
    super.key,
    required this.stock,
    required this.leadTimeDays,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildLogisticsPill(
          context,
          'STOCK',
          '$stock units',
          Icons.inventory_2_outlined,
        ),
        SizedBox(width: 10.w),
        _buildLogisticsPill(
          context,
          'LEAD TIME',
          '$leadTimeDays days',
          Icons.local_shipping_outlined,
        ),
      ],
    );
  }

  Widget _buildLogisticsPill(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: onSurface.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.w, color: onSurface.withOpacity(0.4)),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                  color: onSurface.withOpacity(0.25),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: onSurface.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
