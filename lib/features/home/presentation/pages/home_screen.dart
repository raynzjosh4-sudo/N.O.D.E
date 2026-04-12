import 'package:flutter/material.dart';
import 'package:node_app/features/auth/presentation/widgets/smart_sign_in_sheet.dart';
import 'package:node_app/features/home/data/category_dummy_data.dart';
import 'package:node_app/features/home/data/repositories/search_history_repository.dart';
import 'package:node_app/features/home/presentation/widgets/quick_selections_list.dart';
import 'package:node_app/features/home/presentation/widgets/search_history_view.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/home/presentation/pages/categories/categories_page.dart';

import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/promo_banners.dart';
import '../widgets/popularsection/popular_section.dart';
import '../widgets/product_grid_section.dart';
import '../widgets/featured_category_card.dart';
import 'product_detail_screen.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_dummy_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSearching = false;
  late ScrollController _scrollController;
  final List<Product> _products = [];
  bool _isLoading = false;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Initialize with first category
    _selectedCategoryId = CategoryDummyData.topSearchedCategories.first.id;
    _loadMore(); // Initial load

    // 🪄 Trigger the Smart Sign-In sheet on Home Screen after a brief delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 1200), () {
        if (mounted) {
          _showSmartSignIn();
        }
      });
    });
  }

  void _showSmartSignIn() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => SmartSignInSheet(),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400 &&
        !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Filter by selected category for sync
    final List<Product> categoryProducts = ProductDummyData.products
        .where((p) => p.categoryId == _selectedCategoryId)
        .toList();

    final List<Product> newItems = List.from(categoryProducts);

    if (mounted) {
      setState(() {
        _products.addAll(newItems);
        _isLoading = false;
      });
    }
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;

    // Save to history
    ref.read(searchHistoryRepositoryProvider).saveSearch(query);

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
        transitionDuration: Duration(milliseconds: 400),
      ),
    );
    setState(() => _isSearching = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: SizedBox(height: 8.h),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: HomeHeader(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: SizedBox(height: 8.h),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: HomeSearchBar(
                onTap: () => setState(() => _isSearching = true),
                onSubmitted: _handleSearch,
                onFilterTap: () async {
                  final result = await Navigator.of(context).push<String?>(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CategoriesPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                      transitionDuration: Duration(milliseconds: 450),
                    ),
                  );
                  if (result != null) {
                    _handleSearch(result);
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: SizedBox(height: 8.h),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _isSearching
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: SearchHistoryView(
                          onCancel: () => setState(() => _isSearching = false),
                          onSelect: _handleSearch,
                        ),
                      )
                    : CustomScrollView(
                        controller: _scrollController,
                        key: ValueKey('home_content'),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: PromoBanners(),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: QuickSelectionsList(),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: FeaturedCategoryCard(
                                onCategoryChanged: (category) {
                                  if (category.id != _selectedCategoryId) {
                                    setState(() {
                                      _selectedCategoryId = category.id;
                                      _products.clear();
                                      _loadMore();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: PopularSection(
                                categoryId: _selectedCategoryId,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                          ProductGridSection(products: _products),
                          if (_isLoading)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(32.0.w),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
