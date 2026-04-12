import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class AdvancedProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddTap;

  const AdvancedProductCard({
    super.key,
    required this.product,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    
    // --- 👑 UI MATH: Calculating the Profit Engine ---
    final sortedTiers = [...product.priceTiers]..sort((a, b) => a.minQuantity.compareTo(b.minQuantity));
    final wholesalePrice = sortedTiers.isNotEmpty ? sortedTiers.first.price : product.srp * 0.7;
    
    final marginUgx = product.srp - wholesalePrice;
    final roiPercent = ((product.srp - wholesalePrice) / wholesalePrice) * 100;

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
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(product.imageUrl, fit: BoxFit.cover)
                          : Icon(Icons.inventory_2_outlined, 
                              size: 48.w, color: theme.colorScheme.primary.withOpacity(0.5)),
                    ),
                  ),
                ),
                // 💰 PROFIT BADGE
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2.h,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.brand.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  // --- 📈 PRICING & ROI ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wholesale from',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            '${wholesalePrice.toInt()} UGX',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      // ROI INDICATOR
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: appColors.marginGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '${roiPercent.toInt()}% ROI',
                          style: TextStyle(
                            color: appColors.marginGreen,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

