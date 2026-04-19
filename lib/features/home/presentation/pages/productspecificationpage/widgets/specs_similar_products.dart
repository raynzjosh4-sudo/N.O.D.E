import 'package:flutter/material.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';

import '../../../widgets/product_grid_card.dart';
import '../../product_detail_screen.dart';
import 'package:node_app/core/utils/responsive_size.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/inventory/presentation/providers/inventory_notifier.dart';

class SpecsSimilarProducts extends ConsumerWidget {
  final Product currentProduct;
  const SpecsSimilarProducts({super.key, required this.currentProduct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final similarProductsAsync = ref.watch(
      similarProductsProvider((
        categoryId: currentProduct.categoryId,
        excludedProductId: currentProduct.id,
      )),
    );

    return similarProductsAsync.when(
      data: (products) {
        if (products.isEmpty) return const SizedBox.shrink();

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
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ProductDetailScreen(
                                    category: currentProduct.categoryId,
                                  ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeOutQuint;
                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
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
              height: 280.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
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
      },
      loading: () => Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.primaryColor.withOpacity(0.5),
          ),
        ),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
