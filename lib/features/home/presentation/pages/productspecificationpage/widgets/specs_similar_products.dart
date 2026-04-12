import 'package:flutter/material.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/core/domain/entities/location.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
// Removed dummy import
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import '../../../widgets/product_grid_card.dart';
import '../../product_detail_screen.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsSimilarProducts extends StatelessWidget {
  SpecsSimilarProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: In production, fetch similar products from a repository based on the current product's category.
    final List<Product> similarProducts = []; // Empty for now

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Similar Products',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (c, a, b) => ProductDetailScreen(),
                      transitionsBuilder: (c, a, b, child) {
                        const begin = Offset(1.0, 0.0);
                        final tween = Tween(begin: begin, end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeOutQuint));
                        return SlideTransition(
                            position: a.drive(tween), child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'See More',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.w,
                      color: theme.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 260.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: similarProducts.length,
            itemBuilder: (context, index) {
              final product = similarProducts[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: SizedBox(
                  width: 160.w,
                  child: ProductGridCard(
                    product: product,
                    aspectRatio: 1.0, // Square for similar items
                    heroTag: 'similar_${product.id}_$index',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
