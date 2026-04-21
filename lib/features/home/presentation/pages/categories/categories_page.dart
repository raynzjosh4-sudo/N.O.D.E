import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/inventory/presentation/providers/category_notifier.dart';
import 'package:node_app/features/home/presentation/pages/categories/models/category_model.dart';
import '../product_detail_screen.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_shimmer.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  final CategoryItem? initialCategory;
  const CategoriesPage({super.key, this.initialCategory});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _ProviderNotifier {
  final WidgetRef ref;
  _ProviderNotifier(this.ref);

  Future<void> refresh() async {
    // This provides legacy support or a way to refresh the root level
    await ref.read(categoryPaginatedProvider(null).notifier).fetch(isRefresh: true);
  }
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  final List<CategoryItem> _navigationStack = [];

  String? get _currentParentId =>
      _navigationStack.isEmpty ? null : _navigationStack.last.id;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _navigationStack.add(widget.initialCategory!);
    }
  }

  void _onCategoryTap(CategoryItem category) {
    if (category.itemCount == 0 && category.id.isNotEmpty) {
      setState(() {
        _navigationStack.add(category);
      });
    } else if (category.itemCount > 0) {
      _navigateToProducts(category);
    } else {
       setState(() {
        _navigationStack.add(category);
      });
    }
  }

  void _navigateToProducts(CategoryItem category) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(category: category.id),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _goBack() {
    if (_navigationStack.isNotEmpty) {
      setState(() {
        _navigationStack.removeLast();
      });
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final categoryState = ref.watch(categoryPaginatedProvider(_currentParentId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header & Breadcrumbs ──────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _goBack,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: onSurface.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 20.w,
                            color: onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'Explore',
                        style: GoogleFonts.outfit(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                    ],
                  ),
                  if (_navigationStack.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildBreadcrumb('All', () {
                            setState(() {
                              _navigationStack.clear();
                            });
                          }),
                          for (int i = 0; i < _navigationStack.length; i++) ...[
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 16.w,
                              color: onSurface.withOpacity(0.3),
                            ),
                            _buildBreadcrumb(_navigationStack[i].name, () {
                              setState(() {
                                final count = _navigationStack.length - 1 - i;
                                for (int j = 0; j < count; j++) {
                                  _navigationStack.removeLast();
                                }
                              });
                            }),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Paginated Category List ───────────────────────────────
            Expanded(
              child: categoryState.items.isEmpty && categoryState.isLoading
                  ? _buildLoadingState()
                  : categoryState.items.isEmpty
                      ? _buildEmptyState(onSurface)
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification &&
                                notification.metrics.extentAfter < 300) {
                              ref
                                  .read(categoryPaginatedProvider(_currentParentId).notifier)
                                  .loadMore();
                            }
                            return false;
                          },
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 40.h),
                            itemCount: categoryState.items.length + (categoryState.hasMore ? 1 : 0),
                            separatorBuilder: (context, index) => Divider(
                              height: 1.h,
                              thickness: 1,
                              indent: 68,
                              color: onSurface.withOpacity(0.05),
                            ),
                            itemBuilder: (context, index) {
                              if (index >= categoryState.items.length) {
                                return const CategorySkeleton();
                              }
                              final cat = categoryState.items[index];
                              return _buildCategoryListTile(cat);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => const CategorySkeleton(),
    );
  }

  Widget _buildEmptyState(Color onSurface) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 48.w,
            color: onSurface.withOpacity(0.1),
          ),
          SizedBox(height: 16.h),
          Text(
            'No sub-categories found here',
            style: GoogleFonts.outfit(
              color: onSurface.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _navigationStack.clear();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(Icons.home_rounded, size: 16.w, color: theme.primaryColor),
                   SizedBox(width: 8.w),
                   Text(
                    'Back to Explore',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryListTile(CategoryItem category) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final isLeaf = category.itemCount > 0;

    String subtitle = isLeaf
        ? '${category.itemCount} Items available'
        : 'Tap to explore sub-categories';

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
      onTap: () => _onCategoryTap(category),
      leading: Container(
        height: 36.h,
        width: 36.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _getImageProvider(category.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        category.name,
        style: GoogleFonts.outfit(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.sp,
          color: onSurface.withOpacity(0.5),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: !isLeaf
          ? Icon(
              Icons.chevron_right_rounded,
              color: onSurface.withOpacity(0.2),
              size: 16.w,
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'NEW',
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.isEmpty) return const AssetImage('assets/images/placeholder.png');
    if (url.startsWith('assets/')) {
      return AssetImage(url);
    }
    return NetworkImage(url);
  }
}
