import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
// Removed dummy import
import '../widgets/product_grid_card.dart';
import '../providers/home_providers.dart';

import '../widgets/product_media_section.dart';
import 'productspecificationpage/product_specs_screen.dart';
import 'package:node_app/features/home/data/category_dummy_data.dart';
import 'package:node_app/features/home/presentation/pages/categories/categories_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String? supplierId;
  final String? category;
  final Product? product;
  final String? heroTag;

  ProductDetailScreen({
    super.key,
    this.supplierId,
    this.category,
    this.product,
    this.heroTag,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late String _selectedCategoryId;
  Product? _heroProduct;
  bool _isLoadingHero = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId =
        widget.category ??
        widget.product?.categoryId ??
        CategoryDummyData.topSearchedCategories.first.id;
    _heroProduct = widget.product;

    if (_heroProduct == null) {
      _fetchHeroProduct();
    }
  }

  Future<void> _fetchHeroProduct() async {
    setState(() => _isLoadingHero = true);
    final repository = ref.read(homeRepositoryProvider);
    final result = await repository.getExploreProducts(
      page: 0,
      pageSize: 1,
      category: _selectedCategoryId,
    );

    result.fold((failure) => debugPrint('Hero fetch error: $failure'), (items) {
      if (items.isNotEmpty && mounted) {
        setState(() {
          _heroProduct = items.first;
          _isLoadingHero = false;
        });
      } else {
        setState(() => _isLoadingHero = false);
      }
    });
  }

  static const _pageSize = 10;

  late final PagingController<int, Product> _pagingController =
      PagingController<int, Product>(
        fetchPage: (pageKey) => _fetchPage(pageKey),
        getNextPageKey: (state) {
          if (state.keys == null || state.keys!.isEmpty) {
            return 0;
          }
          return state.lastPageIsEmpty ? null : (state.nextIntPageKey ?? 0);
        },
      );

  Future<List<Product>> _fetchPage(int pageKey) async {
    final repository = ref.read(homeRepositoryProvider);
    final result = await repository.getExploreProducts(
      page: pageKey,
      pageSize: _pageSize,
      supplierId: widget.supplierId,
      category: _selectedCategoryId,
    );

    return result.fold(
      (failure) => throw failure,
      (newItems) => newItems.where((p) => p.id != widget.product?.id).toList(),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // 👑 IMMERSIVE CURVED HERO HEADER
          SliverPersistentHeader(
            pinned: false,
            delegate: HeroHeaderDelegate(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              minHeight: topPadding + 64,
              imageUrl: _heroProduct?.imageUrl ?? '',
              product: _heroProduct,
              heroTag: widget.heroTag ?? _heroProduct?.id,
              isLoading: _isLoadingHero,
            ),
          ),

          // 🏷️ PRODUCT MEDIA SECTION (Restored)
          if (_heroProduct != null)
            SliverToBoxAdapter(
              child: ProductMediaSection(product: _heroProduct!),
            ),

          // 🚀 MORE TO EXPLORE HEADER
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0), // Tightened
              child: Text(
                'More to explore',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // 🧱 Paginated Masonry Grid with PagingListener (v5 API)
          PagingListener<int, Product>(
            controller: _pagingController,
            builder: (context, state, fetchNextPage) => SliverPadding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 40),
              sliver: PagedSliverMasonryGrid.count(
                state: state,
                fetchNextPage: fetchNextPage,
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                builderDelegate: PagedChildBuilderDelegate<Product>(
                  itemBuilder: (context, item, index) {
                    return ProductGridCard(
                      product: item,
                      heroTag: 'explore_${item.id}_$index',
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0.w),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (_) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0.w),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (_) =>
                      const Center(child: Text('No products found.')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final String imageUrl;
  final Product? product;
  final String? heroTag;
  final bool isLoading;

  HeroHeaderDelegate({
    required this.maxHeight,
    required this.minHeight,
    required this.imageUrl,
    this.product,
    this.heroTag,
    this.isLoading = false,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final progress = shrinkOffset / (maxHeight - minHeight);
    final percent = (1.0 - progress).clamp(0.0, 1.0);

    // Parallax logic
    final double parallaxOffset = shrinkOffset * 0.5;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 🖼️ IMAGE WITH PARALLAX & PERSISTENT RADIUS
        Padding(
          padding: EdgeInsets.lerp(
            const EdgeInsets.fromLTRB(8, 8, 8, 0),
            EdgeInsets.fromLTRB(8, 8, 8, 12),
            progress,
          )!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              32,
            ), // Always rounded as requested
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: -parallaxOffset,
                  left: 0,
                  right: 0,
                  child: Hero(
                    tag: heroTag ?? imageUrl,
                    child: SizedBox(
                      height: maxHeight,
                      child: (imageUrl.isEmpty || isLoading)
                          ? Container(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.05,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.05,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: theme.colorScheme.onSurface
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.05),
                              ),
                            ),
                    ),
                  ),
                ),
                // Subtle overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2 * percent),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // ── PRICE BADGE ──────────────────────────────────────────
                if (product != null)
                  Positioned(
                    bottom: 24.h,
                    left: 20.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: -2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        'UGX ${NumberFormat.decimalPattern().format(product!.srp)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),

                // ── VIEW SPECS BUTTON ──────────────────────────────────────────
                Positioned(
                  bottom: 24.h,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      if (product != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductSpecsScreen(product: product!),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.settings_suggest_rounded,
                            color: theme.colorScheme.onPrimary,
                            size: 16.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'View Specs',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🔙 BACK BUTTON
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 20.w,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(
                  lerpDouble(0.8, 0.4, progress)!,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.colorScheme.onSurface,
                size: 18.w,
              ),
            ),
          ),
        ),

        // ❌ CLOSE BUTTON (Back to Home)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 20.w,
          child: GestureDetector(
            onTap: () {
              // Navigate back to the very first route (Home)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(
                  lerpDouble(0.8, 0.4, progress)!,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                color: theme.colorScheme.onSurface,
                size: 20.w,
              ),
            ),
          ),
        ),

        // 🧴 TITLE TRANSITION (Optional)
        if (progress > 0.8)
          Positioned(
            bottom: 24.h,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Explore', // Default title
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  double? lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant HeroHeaderDelegate oldDelegate) {
    return oldDelegate.maxHeight != maxHeight ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.imageUrl != imageUrl;
  }
}
