import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'product_grid_card.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/utils/responsive_layout.dart';

class ProductGridSection extends StatelessWidget {
  final List<Product> products;

  ProductGridSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    // We use SliverMasonryGrid to keep the 'Masonry' (staggered) look
    // it's highly efficient for large datasets.
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: ResponsiveLayout.isDesktop(context)
            ? 5
            : ResponsiveLayout.isTablet(context)
            ? 3
            : 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];

          // 🎨 MASONRY OVERRIDE
          // If the database has identical 1.0 ratios, we force an alternating
          // sequence based on the index to achieve the staggered waterfall look.
          double displayRatio = item.aspectRatio;
          if (displayRatio == 1.0) {
            // Adjusted for taller "Pinterest-style" verticality
            final staggeredRatios = [0.7, 0.9, 0.75, 0.85, 0.8, 0.95];
            displayRatio = staggeredRatios[index % staggeredRatios.length];
          }

          return ProductGridCard(
            product: item,
            aspectRatio: displayRatio,
            heroTag: 'grid_${item.id}_$index',
          );
        },
      ),
    );
  }
}
