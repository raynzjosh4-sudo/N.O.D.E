import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/inventory/data/models/product_model.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';

class SpecsWholesalePricingTable extends StatelessWidget {
  final Product product;

  SpecsWholesalePricingTable({super.key, required this.product});

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
            'Wholesale Pricing',
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
          decoration: BoxDecoration(color: theme.cardColor),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTableHeader(context, 'UNIT RANGE'),
                    ),
                    Expanded(child: _buildTableHeader(context, 'UNIT PRICE')),
                    Expanded(child: _buildTableHeader(context, 'SAVINGS')),
                  ],
                ),
              ),
              Divider(
                height: 1.h,
                thickness: 1,
                color: theme.dividerColor.withOpacity(0.05),
              ),
              ..._generatePricingRows(product).map((row) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              row['range']!,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: onSurface.withOpacity(0.85),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['price']!,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              row['savings']!,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(
                                  0xFF4CAF50,
                                ), // Standard Success Green stays
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      thickness: 1,
                      color: theme.dividerColor.withOpacity(0.05),
                    ),
                  ],
                );
              }).toList(),
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

  List<Map<String, String>> _generatePricingRows(Product product) {
    final sortedTiers = List<PriceTier>.from(product.priceTiers)
      ..sort((a, b) => a.minQuantity.compareTo(b.minQuantity));
    final List<Map<String, String>> rows = [];

    if (sortedTiers.isNotEmpty) {
      if (sortedTiers.first.minQuantity > 1) {
        rows.add({
          'range': '1 — ${sortedTiers.first.minQuantity - 1} units',
          'price': 'UGX ${product.srp.toInt()}',
          'savings': 'Retail',
        });
      }
    }

    for (int i = 0; i < sortedTiers.length; i++) {
      final tier = sortedTiers[i];
      final nextTier = (i + 1 < sortedTiers.length) ? sortedTiers[i + 1] : null;

      final range = nextTier != null
          ? '${tier.minQuantity} — ${nextTier.minQuantity - 1} units'
          : '${tier.minQuantity}+ units';

      final savingsPercent = ((product.srp - tier.price) / product.srp * 100)
          .round();

      rows.add({
        'range': range,
        'price': 'UGX ${tier.price.toInt()}',
        'savings': 'Save $savingsPercent%',
      });
    }
    return rows;
  }
}
