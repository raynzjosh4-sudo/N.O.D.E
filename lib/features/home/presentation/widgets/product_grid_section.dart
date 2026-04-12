import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'product_grid_card.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class ProductGridSection extends StatelessWidget {
  final List<Product> products;

  ProductGridSection({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    // We use SliverMasonryGrid to keep the 'Masonry' (staggered) look 
    // it's highly efficient for large datasets.
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return ProductGridCard(
            product: item,
            aspectRatio: item.aspectRatio,
            heroTag: 'grid_${item.id}_$index',
          );
        },
      ),
    );
  }
}
