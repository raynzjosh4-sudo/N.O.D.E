import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsPriceActionRow extends StatelessWidget {
  final double srp;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onAddToOrder;

  SpecsPriceActionRow({
    super.key,
    required this.srp,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.onAddToOrder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final onSurface = theme.colorScheme.onSurface;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  NumberFormat.currency(
                    symbol: 'UGX ',
                    decimalDigits: 0,
                  ).format(srp),
                  style: GoogleFonts.outfit(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              _buildSimpleQtyBtn(context, Icons.remove, onRemove, false),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  '$quantity',
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildSimpleQtyBtn(context, Icons.add, onAdd, true),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: onAddToOrder,
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 18.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleQtyBtn(BuildContext context, IconData icon, VoidCallback onTap, bool isPurple) {
    final theme = Theme.of(context);
    final themePrimary = theme.primaryColor;
    final onSurface = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: isPurple ? themePrimary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: isPurple ? null : Border.all(color: onSurface.withOpacity(0.05)),
        ),
        child: Icon(
          icon,
          size: 14.w,
          color: isPurple ? Colors.white : onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
