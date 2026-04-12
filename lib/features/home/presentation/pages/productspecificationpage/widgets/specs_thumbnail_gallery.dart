import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsThumbnailGallery extends StatelessWidget {
  final List<String> imageUrls;
  final int selectedIndex;
  final Function(int) onSelect;

  SpecsThumbnailGallery({
    super.key,
    required this.imageUrls,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themePrimary = theme.primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(imageUrls.length, (index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                width: 42.w,
                height: 42.h,
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected ? themePrimary : Colors.transparent,
                    width: 2.w,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrls[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
