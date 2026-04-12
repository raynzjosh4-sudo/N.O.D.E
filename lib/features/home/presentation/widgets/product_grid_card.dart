import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
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

    // 🏦 PRICE CALCULATION: Show the best (lowest) wholesale price
    final double displayPriceValue = product.priceTiers.isNotEmpty
        ? product.priceTiers.map((t) => t.price).reduce((a, b) => a < b ? a : b)
        : product.srp;

    final String formattedPrice = NumberFormat.currency(
      symbol: 'UGX ',
      decimalDigits: 0,
    ).format(displayPriceValue);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (c, a, b) => ProductDetailScreen(
              product: product,
              supplierId: product.supplierId,
              category: product.categoryId,
              heroTag: heroTag ?? product.imageUrl,
            ),
            transitionsBuilder: (c, a, b, child) {
              const begin = Offset(0.0, 1.0);
              final tween = Tween(
                begin: begin,
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutQuint));
              return SlideTransition(position: a.drive(tween), child: child);
            },
            transitionDuration: const Duration(milliseconds: 1000),
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
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20.r),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full bleed image — explicit AspectRatio drives masonry sizing
                Hero(
                  tag: heroTag ?? product.imageUrl,
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
                // Text Details
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0.w,
                    vertical: 10.0.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              formattedPrice,
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Supplier circle badge
                      Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 2.w,
                          ),
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: product.supplier.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const SizedBox.shrink(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.business_rounded,
                              size: 14.w,
                              color: theme.colorScheme.onSurface.withOpacity(0.2),
                            ),
                          ),
                        ),
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
