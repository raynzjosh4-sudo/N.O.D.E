import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class AdvancedProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddTap;

  const AdvancedProductCard({super.key, required this.product, this.onAddTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);

    // --- 👑 UI MATH: Calculating the Profit Engine ---
    final sortedTiers = [...product.priceTiers]
      ..sort((a, b) => a.minQuantity.compareTo(b.minQuantity));

    // Wholesale: First tier with MOQ > 1, or fallback to retail
    final wholesaleTier = sortedTiers.firstWhere(
      (t) => t.minQuantity > 1,
      orElse: () =>
          sortedTiers.isNotEmpty ? sortedTiers.first : (null as dynamic),
    );
    final wholesalePrice = wholesaleTier?.price ?? product.srp * 0.8;

    // Retail: Price for 1 unit
    final retailTier = sortedTiers.firstWhere(
      (t) => t.minQuantity == 1,
      orElse: () => (null as dynamic),
    );
    final retailPrice = retailTier?.price ?? product.srp;

    final marginUgx = retailPrice - wholesalePrice;
    final roiPercent = ((retailPrice - wholesalePrice) / wholesalePrice) * 100;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {}, // Navigate to Detail
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 🖼️ IMAGE & PROFIT BADGE ---
            Stack(
              children: [
                Hero(
                  tag: 'product-${product.id}',
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.3),
                      ),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(product.imageUrl, fit: BoxFit.cover)
                          : Icon(
                              Icons.inventory_2_outlined,
                              size: 48.w,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                    ),
                  ),
                ),
                // 💰 PROFIT BADGE
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.marginGreen,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '+${marginUgx.toInt()} UGX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- 📝 PRODUCT INFO ---
            Padding(
              padding: EdgeInsets.all(12.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 📈 PRICING SECTION (MOVE TO TOP) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'UGX ${wholesalePrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18
                                          .sp, // Slightly larger for prominence
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '/ ${wholesaleTier?.minQuantity ?? 1}+ units',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Retail UGX ${retailPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.6,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 🏢 SUPPLIER INITIAL BADGE
                      Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color:
                              (product.brand.toLowerCase().startsWith('g') ||
                                  product.brand.toLowerCase().contains('eagle'))
                              ? const Color(0xFF0D9488)
                              : const Color(0xFFEA580C),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          product.brand.isNotEmpty
                              ? product.brand[0].toUpperCase()
                              : 'N',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.sp,
                      height: 1.2.h,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.brand.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 10.sp,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // --- 📏 MOQ PROGRESS ---
                  _buildMoqProgress(theme, appColors),

                  SizedBox(height: 12.h),

                  // --- 🛒 QUICK ADD ---
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: onAddTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 18.w),
                          SizedBox(width: 4.w),
                          Text('BULK ADD'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoqProgress(ThemeData theme, AppColors appColors) {
    // 👑 TIER LOGIC: Progress toward next discount tier
    // For this demonstration, we'll assume a threshold of 100 units
    const double progress = 0.65; // Example 65% toward next tier

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tier Progress',
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 9.sp),
            ),
            Text(
              '5 more for 21,500 UGX',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9.sp,
                color: appColors.moqOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: appColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(appColors.moqOrange),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
