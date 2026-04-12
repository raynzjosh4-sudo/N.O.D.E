import 'package:flutter/material.dart';

class OrderSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? labelColor;
  final TextStyle? valueStyle;

  const OrderSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: labelColor ?? onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: valueStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
