import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsDescription extends StatelessWidget {
  final String description;

  SpecsDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: onSurface.withOpacity(0.45),
            height: 1.5.h,
          ),
        ),
      ],
    );
  }
}
