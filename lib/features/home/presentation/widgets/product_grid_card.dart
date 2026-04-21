import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/home/presentation/pages/product_detail_screen.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:intl/intl.dart';

class ProductGridCard extends StatelessWidget {
  final Product product;
  final double? aspectRatio;
  final String? heroTag;

  ProductGridCard({
    super.key,
    required this.product,
    this.aspectRatio,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    // 🏗️ LAYOUT CALCULATION: Use passed ratio or fallback to product's own ratio
    final double activeRatio = aspectRatio ?? product.aspectRatio;

    // 🏦 PRICE CALCULATION: Pick the 'Entry Wholesale' price (first tier > 1 unit)
    final sortedTiers = [...product.priceTiers]
      ..sort((a, b) => a.minQuantity.compareTo(b.minQuantity));

    final entryWholesaleTier = sortedTiers.firstWhere(
      (t) => t.minQuantity > 1,
      orElse: () => sortedTiers.isNotEmpty
          ? sortedTiers.first
          : PriceTier(minQuantity: 1, price: product.srp),
    );

    final String formattedWholesale = NumberFormat.currency(
      symbol: 'UGX ',
      decimalDigits: 0,
    ).format(entryWholesaleTier.price);

    final String qtySuffix = entryWholesaleTier.minQuantity > 1
        ? ' / ${entryWholesaleTier.minQuantity}+ units'
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (c, a, b) => ProductDetailScreen(
              product: product,
              supplierId: product.supplierId,
              category: product.categoryId,
              heroTag: heroTag ?? 'grid_${product.id}',
            ),
            transitionsBuilder: (c, a, b, child) {
              return FadeTransition(opacity: a, child: child);
            },
            transitionDuration: const Duration(
              milliseconds: 300,
            ), // Snappier for production
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final theme = Theme.of(context);
          // ✅ Compute image height explicitly from the card's actual width.
          // This is what makes each card a unique height in the masonry grid.
          final double imageHeight = constraints.maxWidth / activeRatio;

          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent, // Minimalist look like the target
              borderRadius: BorderRadius.circular(16.r),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full bleed image — explicit AspectRatio drives masonry sizing
                Hero(
                  tag: heroTag ?? product.imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AspectRatio(
                      aspectRatio: activeRatio,
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                  ),
                ),
                // Text Details
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.0.w,
                    vertical: 8.0.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. DUAL PRICING (Primary - High Visibility)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: formattedWholesale.trim() + ' ',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                if (qtySuffix.isNotEmpty)
                                  TextSpan(
                                    text: qtySuffix,
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.7),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Retail UGX ${NumberFormat.decimalPattern().format(product.srp)}',
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),

                      // 2. PRODUCT NAME
                      SizedBox(height: 4.h),
                      Text(
                        product.name,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // 3. LOCATION & BRAND
                      SizedBox(height: 2.h),
                      Text(
                        '${product.warehouseLoc} • ${product.brand}',
                        style: GoogleFonts.outfit(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
