import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class OrderStepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  OrderStepBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final onSurface = theme.colorScheme.onSurface;
    final active = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: active
              ? primary.withOpacity(0.1)
              : onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: active ? primary.withOpacity(0.25) : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 15.w,
          color: active ? primary : onSurface.withOpacity(0.2),
        ),
      ),
    );
  }
}
