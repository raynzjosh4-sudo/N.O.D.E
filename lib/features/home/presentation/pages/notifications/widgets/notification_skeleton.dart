import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_shimmer.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NodeShimmerCore(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Placeholder (Match card circle)
                NodeShimmerBlock(height: 48.w, width: 48.w, shape: BoxShape.circle),
                SizedBox(width: 16.w),
                // Content Placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title block
                          Expanded(
                            child: NodeShimmerBlock(
                              height: 15.h,
                              width: 160.w,
                              borderRadius: 4.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Time block
                          NodeShimmerBlock(
                            height: 12.h,
                            width: 50.w,
                            borderRadius: 4.r,
                          ),
                          SizedBox(width: 8.w),
                          // Unread Indicator placeholder
                          NodeShimmerBlock(
                            height: 8.w,
                            width: 8.w,
                            shape: BoxShape.circle,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Subtitle line 1
                      NodeShimmerBlock(
                        height: 12.h,
                        width: double.infinity,
                        borderRadius: 4.r,
                      ),
                      SizedBox(height: 6.h),
                      // Subtitle line 2 (shorter)
                      NodeShimmerBlock(
                        height: 12.h,
                        width: 220.w,
                        borderRadius: 4.r,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider placeholder
          Padding(
            padding: EdgeInsets.only(left: 84.w),
            child: NodeShimmerBlock(height: 1.h, width: double.infinity),
          ),
        ],
      ),
    );
  }
}
