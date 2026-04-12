import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'order_section_label.dart';

class SpecsOrderSummaryHeader extends StatelessWidget {
  final VoidCallback onDownloadPdf;

  const SpecsOrderSummaryHeader({super.key, required this.onDownloadPdf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OrderSectionLabel(label: 'ORDER SUMMARY'),
          GestureDetector(
            onTap: onDownloadPdf,
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf_rounded, size: 14.w, color: primary),
                SizedBox(width: 6.w),
                Text(
                  'Download PDF',
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
