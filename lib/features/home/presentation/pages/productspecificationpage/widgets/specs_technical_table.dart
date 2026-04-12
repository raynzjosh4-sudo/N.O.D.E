import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsTechnicalTable extends StatelessWidget {
  final Product product;

  SpecsTechnicalTable({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Text(
            'Technical Specifications',
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: onSurface.withOpacity(0.25),
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildTableHeader(context, 'ATTRIBUTE')),
                    Expanded(
                      flex: 4,
                      child: _buildTableHeader(context, 'SPECIFICATION'),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, thickness: 1, color: theme.dividerColor.withOpacity(0.05)),
              _buildTechTableRow(context, 'SKU', product.sku),
              _buildTechTableRow(context, 'HS CODE', product.hsCode),
              _buildTechTableRow(
                context,
                'MATERIAL',
                '${product.denier} ${product.material}',
              ),
              _buildTechTableRow(context, 'WEIGHT', '${product.weightKg} KG'),
              _buildTechTableRow(context, 'VOLUME', '${product.volumeCbm} CBM'),
              _buildTechTableRow(context, 'ORIGIN', product.originCountry),
              _buildTechTableRow(context, 'PACKING', '100 UNITS/CASE'),
              _buildTechTableRow(
                context,
                'WAREHOUSE',
                product.warehouseLoc,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
      ),
    );
  }

  Widget _buildTechTableRow(
    BuildContext context,
    String attribute,
    String spec, {
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  attribute,
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: onSurface.withOpacity(0.25),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  spec,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: onSurface.withOpacity(0.85),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1.h, thickness: 1, color: theme.dividerColor.withOpacity(0.05)),
      ],
    );
  }
}
