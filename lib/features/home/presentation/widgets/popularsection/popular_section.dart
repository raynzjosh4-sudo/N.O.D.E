import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/home/presentation/providers/home_providers.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'widgets/popular_card.dart';
import 'package:node_app/core/widgets/node_shimmer.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

class PopularSection extends ConsumerWidget {
  final String? categoryId;
  PopularSection({super.key, this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final productsAsync = ref.watch(popularProductsProvider(categoryId));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const SizedBox.shrink();
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
      },
      loading: () => SizedBox(
        height: 100.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemBuilder: (context, index) => const PopularItemSkeleton(),
        ),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
