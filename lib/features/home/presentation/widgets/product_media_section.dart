import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import '../pages/productspecificationpage/product_specs_screen.dart';

class ProductMediaSection extends StatefulWidget {
  final Product product;
  const ProductMediaSection({super.key, required this.product});

  @override
  State<ProductMediaSection> createState() => _ProductMediaSectionState();
}

class _ProductMediaSectionState extends State<ProductMediaSection> {
  bool _isMediaExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isMediaExpanded = !_isMediaExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaUrls = widget.product.mediaUrls.toSet().toList();

    if (mediaUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏷️ HEADER
        Padding(
          padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product Media',
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: _toggleExpansion,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _isMediaExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurface,
                      size: 20.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 🖼️ MEDIA CONTENT
        if (!_isMediaExpanded)
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              itemCount: mediaUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 12.0.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductSpecsScreen(product: widget.product),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: SizedBox(
                        width: 130.w,
                        child: CachedNetworkImage(
                          imageUrl: mediaUrls[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 4.0.h),
            child: MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: mediaUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductSpecsScreen(product: widget.product),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: CachedNetworkImage(
                      imageUrl: mediaUrls[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
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
