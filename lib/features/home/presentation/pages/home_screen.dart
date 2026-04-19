import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:node_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:node_app/features/inventory/presentation/providers/category_notifier.dart';
import 'package:node_app/features/inventory/presentation/providers/inventory_notifier.dart';
import 'package:node_app/features/profile/data/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/features/auth/presentation/widgets/smart_sign_in_sheet.dart';
// Removed dummy import
import 'package:node_app/features/home/data/repositories/search_history_repository.dart';
import 'package:node_app/features/home/presentation/widgets/quick_selections_list.dart';
import 'package:node_app/features/home/presentation/widgets/search_history_view.dart';
import 'package:node_app/features/home/presentation/pages/categories/categories_page.dart';
import 'package:node_app/features/home/presentation/providers/home_providers.dart';

import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/promo_banners.dart';
import '../widgets/popularsection/popular_section.dart';
import '../widgets/product_grid_section.dart';
import '../widgets/featured_category_card.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/theme/app_theme.dart';
import 'package:node_app/core/widgets/node_shimmer.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSearching = false;
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _loadMore(); // Initial load

    // 🪄 Native-First Smart Auth Strategy:
    // 1. First, try Google's Native One-Tap (Silent Detection)
    // 2. If user cancels or no account, show our N.O.D.E. custom sheet as fallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 1400), () async {
        if (!mounted) return;

        final isAuthenticated = ref.read(isAuthenticatedProvider);
        if (isAuthenticated) {
          debugPrint(
            '🪄 [Home] User matches active session. Triggering Safety Sync...',
          );
          final userId = Supabase.instance.client.auth.currentSession?.user.id;
          if (userId != null) {
            () async {
              try {
                await ref.read(profileRepositoryProvider).syncProfile(userId);
              } catch (e) {
                debugPrint('❌ [Home] Safety Sync Background Error: $e');
              }
            }();
          }
          return;
        }

        debugPrint('🪄 [Home] Starting Native-First auth check...');
        final authService = ref.read(authServiceProvider);

        try {
          // This will trigger the native Google One-Tap sheet on Android
          final account = await authService.signInSilently();

          if (account != null) {
            debugPrint('✅ [Home] Native One-Tap success. Syncing session...');
            await authService.signInWithAccount(account);
            // Redirection happens automatically via auth state listeners
          } else {
            debugPrint(
              'ℹ️ [Home] Native prompt dismissed or no account. Showing N.O.D.E fallback...',
            );
            if (mounted) _showSmartSignIn();
          }
        } catch (e) {
          debugPrint(
            '⚠️ [Home] Native check error: $e. Falling back to N.O.D.E sheet.',
          );
          if (mounted) _showSmartSignIn();
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
    // 👑 REPLACED DUMMY DATA WITH PAGINATED NOTIFIER
    await ref.read(inventoryNotifierProvider.notifier).loadMore();
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;

    // 1. Save to cloud/local history
    final userId =
        Supabase.instance.client.auth.currentSession?.user.id ?? 'guest';
    ref.read(searchHistoryRepositoryProvider).saveSearch(query, userId);

    // 2. Trigger the high-performance search engine
    ref.read(inventorySearchQueryProvider.notifier).set(query);

    // 3. Close the history view to show results
    setState(() => _isSearching = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      if (!_isSearching) setState(() => _isSearching = true);
      ref.read(inventorySearchQueryProvider.notifier).set('');
    }
  }

  Future<void> _handleRefresh() async {
    final futures = <Future>[];

    // 1. Refresh Profile Sync if authenticated
    final userId = Supabase.instance.client.auth.currentSession?.user.id;
    if (userId != null) {
      futures.add(() async {
        try {
          await ref.read(profileRepositoryProvider).syncProfile(userId);
        } catch (e) {
          debugPrint('❌ [Home] Refresh Sync Error: $e');
        }
      }());
    }

    // 2. Refresh Product Feed
    futures.add(ref.read(inventoryNotifierProvider.notifier).refresh());

    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: SizedBox(height: 8.h),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: HomeHeader(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: SizedBox(height: 8.h),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: HomeSearchBar(
                    onTap: () => setState(() => _isSearching = true),
                    onChanged: _onSearchChanged,
                    onSubmitted: _handleSearch,
                    onFilterTap: () async {
                      final result = await Navigator.of(context).push<String?>(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                    : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: theme.primaryColor,
                        backgroundColor: theme.colorScheme.surface,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final categoriesAsync = ref.watch(
                              categoryNotifierProvider,
                            );

                            // Handle initial category selection
                            final selectedCategoryId = ref.watch(
                              selectedCategoryProvider,
                            );
                            if (selectedCategoryId == null &&
                                categoriesAsync.hasValue &&
                                categoriesAsync.value!.isNotEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted &&
                                    ref.read(selectedCategoryProvider) ==
                                        null) {
                                  ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state = categoriesAsync
                                      .value!
                                      .first
                                      .id;
                                }
                              });
                            }

                            return CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              key: ValueKey('home_content'),
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 1200,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w,
                                          vertical: 8.h,
                                        ),
                                        child: PromoBanners(),
                                      ),
                                    ),
                                  ),
                                ),
                                // Removed duplicate suppliers header
                                SliverToBoxAdapter(
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 1200,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w,
                                        ),
                                        child: QuickSelectionsList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 16.h),
                                ),
                                featuredCategorySection(colors),
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 8.h),
                                ),
                                popularSection(colors),
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 8.h),
                                ),
                                _buildProductGrid(context, ref),

                                _buildLoadingIndicator(ref),
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 12.h),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget featuredCategorySection(dynamic colors) => SliverToBoxAdapter(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              featuredCategoryCard(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget featuredCategoryCard() => FeaturedCategoryCard(
    onCategoryChanged: (category) {
      final current = ref.read(selectedCategoryProvider);
      if (category.id != current) {
        ref.read(selectedCategoryProvider.notifier).state = category.id;
      }
    },
  );

  Widget popularSection(dynamic colors) => SliverToBoxAdapter(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Consumer(
            builder: (context, ref, child) {
              final selectedCategoryId = ref.watch(selectedCategoryProvider);
              return PopularSection(categoryId: selectedCategoryId);
            },
          ),
        ),
      ),
    ),
  );

  Widget _buildProductGrid(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(inventoryNotifierProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 64),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No products found.',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return ProductGridSection(products: products);
      },
      loading: () => SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const ProductCardSkeleton(),
          childCount: 4,
        ),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: NodeErrorState(
          error: e,
          onRetry: () => ref.read(inventoryNotifierProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(WidgetRef ref) {
    final productsAsync = ref.watch(inventoryNotifierProvider);
    if (productsAsync.isLoading && productsAsync.hasValue) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
