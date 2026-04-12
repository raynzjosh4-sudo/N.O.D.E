import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/home/data/product_dummy_data.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'widgets/popular_card.dart';

class PopularSection extends StatelessWidget {
  final String? categoryId;
  PopularSection({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🔍 Filter products by category if provided
    final products = categoryId == null
        ? ProductDummyData.products
        : ProductDummyData.products
              .where((p) => p.categoryId == categoryId)
              .toList();

    if (products.isEmpty) {
      return const SizedBox.shrink(); // Hide section if no popular products in this category
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular',
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return PopularCard(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}
