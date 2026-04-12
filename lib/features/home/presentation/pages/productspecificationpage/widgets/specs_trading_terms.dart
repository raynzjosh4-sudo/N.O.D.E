import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsTradingTerms extends StatelessWidget {
  final TradingTerms tradingTerms;

  const SpecsTradingTerms({super.key, required this.tradingTerms});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trading Terms',
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: onSurface.withOpacity(0.25),
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          tradingTerms.content,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            color: onSurface.withOpacity(0.45),
            height: 1.5.h,
          ),
        ),
      ],
    );
  }
}
