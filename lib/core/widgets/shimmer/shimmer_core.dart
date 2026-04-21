import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:node_app/core/theme/app_theme.dart';

/// A unified Shimmer wrapper that applies a single animation to its entire child tree.
class NodeShimmerCore extends StatelessWidget {
  final Widget child;
  const NodeShimmerCore({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? colors.borderLight.withOpacity(0.1)
          : Colors.grey[300]!,
      highlightColor: isDark
          ? colors.borderLight.withOpacity(0.2)
          : Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// A simple 'ghost' block that takes the shimmer effect from its parent [NodeShimmerCore].
class NodeShimmerBlock extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const NodeShimmerBlock({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
        shape: shape,
      ),
    );
  }
}
