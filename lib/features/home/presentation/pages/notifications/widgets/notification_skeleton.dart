import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_shimmer.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Placeholder
            NodeShimmerBlock(height: 48.w, width: 48.w, shape: BoxShape.circle),
            SizedBox(width: 16.w),
            // Content Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NodeShimmerBlock(height: 14.h, width: 140.w, borderRadius: 4.r),
                      NodeShimmerBlock(height: 10.h, width: 50.w, borderRadius: 4.r),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  NodeShimmerBlock(height: 12.h, borderRadius: 4.r), // Full width line 1
                  SizedBox(height: 6.h),
                  NodeShimmerBlock(height: 12.h, width: 200.w, borderRadius: 4.r), // Partial width line 2
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
