import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/shimmer/shimmer_core.dart';

export 'package:node_app/core/widgets/shimmer/shimmer_core.dart';

class FeaturedCategorySkeleton extends StatelessWidget {
  const FeaturedCategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: Container(
        height: 280.h,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NodeShimmerBlock(height: 28.h, width: 180.w, borderRadius: 4.r),
            SizedBox(height: 8.h),
            NodeShimmerBlock(height: 14.h, width: 90.w, borderRadius: 4.r),
            SizedBox(height: 24.h),
            NodeShimmerBlock(height: 48.h, borderRadius: 24.r),
          ],
        ),
      ),
    );
  }
}

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            // Circular icon
            NodeShimmerBlock(
              height: 36.h,
              width: 36.w,
              shape: BoxShape.circle,
            ),
            SizedBox(width: 16.w),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NodeShimmerBlock(height: 16.h, width: 120.w, borderRadius: 4.r),
                  SizedBox(height: 6.h),
                  NodeShimmerBlock(height: 12.h, width: 80.w, borderRadius: 4.r),
                ],
              ),
            ),
            // Right tag/chevron
            NodeShimmerBlock(height: 20.h, width: 40.w, borderRadius: 12.r),
          ],
        ),
      ),
    );
  }
}

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: SizedBox(
        height: 140.h,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: NodeShimmerBlock(height: 140.h, borderRadius: 16.r),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(child: NodeShimmerBlock(height: double.infinity, borderRadius: 12.r)),
                  SizedBox(height: 8.h),
                  Expanded(child: NodeShimmerBlock(height: double.infinity, borderRadius: 12.r)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupplierSkeleton extends StatelessWidget {
  const SupplierSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NodeShimmerBlock(height: 32.w, width: 32.w, shape: BoxShape.circle),
                SizedBox(width: 10.w),
                NodeShimmerBlock(height: 14.h, width: 60.w, borderRadius: 4.r),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PopularItemSkeleton extends StatelessWidget {
  const PopularItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: Container(
        width: 220.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            NodeShimmerBlock(width: 64.w, height: 64.h, borderRadius: 12.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NodeShimmerBlock(height: 14.h, width: 100.w, borderRadius: 4.r),
                  SizedBox(height: 4.h),
                  NodeShimmerBlock(height: 10.h, width: 60.w, borderRadius: 4.r),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NodeShimmerBlock(height: 16.h, width: 70.w, borderRadius: 4.r),
                      NodeShimmerBlock(height: 20.w, width: 20.w, shape: BoxShape.circle),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: NodeShimmerBlock(height: double.infinity, borderRadius: 0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NodeShimmerBlock(height: 14.h, width: 90.w, borderRadius: 4.r),
                        SizedBox(height: 4.h),
                        NodeShimmerBlock(height: 10.h, width: 60.w, borderRadius: 4.r),
                        SizedBox(height: 12.h),
                        NodeShimmerBlock(height: 14.h, width: 80.w, borderRadius: 4.r),
                        SizedBox(height: 4.h),
                        NodeShimmerBlock(height: 10.h, width: 70.w, borderRadius: 4.r),
                      ],
                    ),
                  ),
                  NodeShimmerBlock(height: 28.w, width: 28.w, shape: BoxShape.circle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
