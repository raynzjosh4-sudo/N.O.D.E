import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/presentation/utils/order_status_ui_helper.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        status.label,
        style: GoogleFonts.outfit(
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}
