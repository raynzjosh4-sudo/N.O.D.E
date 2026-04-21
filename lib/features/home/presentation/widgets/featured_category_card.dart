import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/home/presentation/pages/categories/categories_page.dart';
// Removed dummy import
import 'package:node_app/features/home/presentation/pages/categories/models/category_model.dart';
import 'package:node_app/features/home/presentation/pages/product_detail_screen.dart';
import 'package:node_app/features/inventory/presentation/providers/category_notifier.dart';
import 'package:node_app/core/widgets/node_shimmer.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

class FeaturedCategoryCard extends ConsumerStatefulWidget {
  final void Function(CategoryItem)? onCategoryChanged;
  const FeaturedCategoryCard({super.key, this.onCategoryChanged});
  @override
  ConsumerState<FeaturedCategoryCard> createState() =>
      _FeaturedCategoryCardState();
}

class _FeaturedCategoryCardState extends ConsumerState<FeaturedCategoryCard> {
  late PageController _pageController;
  double _currentPage = 0.0;
  int _lastReportedPage = 0;

  List<CategoryItem> _featuredCategories = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85)
      ..addListener(() {
        if (mounted) {
          setState(() {
            _currentPage = _pageController.page!;

            // Notify parent if the centered category changed
            final int centeredIndex = _currentPage.round();
            if (centeredIndex != _lastReportedPage &&
                centeredIndex >= 0 &&
                centeredIndex < _featuredCategories.length) {
              _lastReportedPage = centeredIndex;
              widget.onCategoryChanged?.call(
                _featuredCategories[centeredIndex],
              );
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        _featuredCategories = categories;

        return SizedBox(
          height: 280.h,
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            itemCount: _featuredCategories.length,
            itemBuilder: (context, index) {
              double relativePosition = index - _currentPage;
              return _buildAnimatedCard(index, relativePosition);
            },
          ),
        );
      },
      loading: () => const FeaturedCategorySkeleton(),
      error: (e, st) => NodeErrorState(
        error: e,
        onRetry: () => ref.read(categoryPaginatedProvider(null).notifier).fetch(isRefresh: true),
        compact: true,
      ),
    );
  }

  Widget _buildAnimatedCard(int index, double position) {
    final theme = Theme.of(context);
    final category = _featuredCategories[index];

    double scale = 1.0 - (position.abs() * 0.12);
    double opacity = (1.0 - (position.abs() * 0.4)).clamp(0.0, 1.0);
    double translationX = position * -40.0;
    double rotation = position * 0.05;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..translate(translationX)
        ..scale(scale)
        ..rotateZ(rotation),
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              image: DecorationImage(
                image: _getImageProvider(category.imageUrl),
                fit: BoxFit.cover,
                colorFilter: position.abs() > 0.1
                    ? ColorFilter.mode(
                        index % 2 == 0
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.cyan.withOpacity(0.5),
                        BlendMode.softLight,
                      )
                    : null,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: -5,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (position.abs() < 0.5) ...[
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 160.h,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(28),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.w,
                    right: 20.w,
                    bottom: 20.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: GoogleFonts.outfit(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          // Show product brand or secondary info
                          'Collection',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16.h),
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                if (category.subCategories.isNotEmpty) {
                                  // Navigate to sub-categories in Explore Page
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CategoriesPage(
                                        initialCategory: category,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Direct to filtered grid
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => ProductDetailScreen(
                                            category: category.id,
                                          ),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            const begin = Offset(0.0, 1.0);
                                            const end = Offset.zero;
                                            const curve = Curves.easeOutQuint;
                                            var tween = Tween(
                                              begin: begin,
                                              end: end,
                                            ).chain(CurveTween(curve: curve));
                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                      transitionDuration: Duration(
                                        milliseconds: 450,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: 48.h,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Explore',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      width: 32.w,
                                      height: 32.h,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: theme.colorScheme.onPrimary,
                                        size: 12.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('assets/')) {
      return AssetImage(url);
    }
    return NetworkImage(url);
  }
}
