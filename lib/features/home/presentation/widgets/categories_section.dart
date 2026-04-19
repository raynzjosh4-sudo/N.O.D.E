import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/inventory/presentation/providers/category_notifier.dart';
import '../../../../core/theme/app_theme.dart';
// Removed dummy import
import 'package:node_app/core/utils/responsive_size.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 38.h,
          child: categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) return const SizedBox.shrink();
              return ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return _buildCategoryPill(
                    context,
                    cat.name,
                    cat.subCategories.isNotEmpty
                        ? '${cat.subCategories.length}+ categories'
                        : '${cat.itemCount} items',
                    cat.imageUrl,
                    index == 0, // Active the first one by default for demo
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPill(
    BuildContext context,
    String title,
    String subtitle,
    String imgUrl,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.only(left: 4.w, right: 12.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r), // Smaller radius
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
        border: isActive ? null : Border.all(color: appColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15, // Smaller avatar
            backgroundImage: NetworkImage(
              '$imgUrl?q=80&w=100&auto=format&fit=crop',
            ),
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 10.sp, // Smaller text
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? theme.colorScheme.onPrimary.withOpacity(0.8)
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
