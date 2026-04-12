import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class OrderSectionLabel extends StatelessWidget {
  final String label;

  OrderSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        color: onSurface.withOpacity(0.3),
        letterSpacing: 1.4,
      ),
    );
  }
}
