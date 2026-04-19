import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/inventory/presentation/providers/category_notifier.dart';
import 'package:node_app/features/home/presentation/pages/categories/models/category_model.dart';
import '../product_detail_screen.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  final CategoryItem? initialCategory;
  const CategoriesPage({super.key, this.initialCategory});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  late List<CategoryItem> _currentCategories;
  final List<CategoryItem> _navigationStack = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _navigationStack.add(widget.initialCategory!);
      _currentCategories = widget.initialCategory!.subCategories;
    } else {
      _currentCategories = [];
    }
  }

  void _onCategoryTap(CategoryItem category) {
    if (category.subCategories.isNotEmpty) {
      setState(() {
        _navigationStack.add(category);
        _currentCategories = category.subCategories;
      });
    } else {
      _navigateToProducts(category);
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
        if (_navigationStack.isEmpty) {
          _currentCategories = ref.read(categoryNotifierProvider).value ?? [];
        } else {
          _currentCategories = _navigationStack.last.subCategories;
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    if (_navigationStack.isEmpty && widget.initialCategory == null) {
       final asyncCategories = ref.watch(categoryNotifierProvider);
       
       return asyncCategories.when(
         data: (categories) {
           _currentCategories = categories;
           return _buildContent(theme, onSurface);
         },
         loading: () => Scaffold(
           backgroundColor: theme.scaffoldBackgroundColor,
           body: const Center(child: CircularProgressIndicator()),
         ),
         error: (err, stack) => Scaffold(
           backgroundColor: theme.scaffoldBackgroundColor,
           body: Center(child: Text('Error loading categories: $err')),
         ),
       );
    }
    
    return _buildContent(theme, onSurface);
  }

  Widget _buildContent(ThemeData theme, Color onSurface) {
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
                              _currentCategories =
                                  ref.read(categoryNotifierProvider).value ?? [];
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
                                _currentCategories =
                                    _navigationStack.last.subCategories;
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

            // ── WhatsApp Style Category List ───────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 40.h),
                itemCount: _currentCategories.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1.h,
                  thickness: 1,
                  indent: 68,
                  color: onSurface.withOpacity(0.05),
                ),
                itemBuilder: (context, index) {
                  final cat = _currentCategories[index];
                  return _buildCategoryListTile(cat);
                },
              ),
            ),
          ],
        ),
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
    final isLeaf = category.subCategories.isEmpty;

    String subPreview = '';
    if (!isLeaf) {
      subPreview = category.subCategories.map((c) => c.name).take(3).join(', ');
      if (category.subCategories.length > 3) subPreview += '...';
    } else {
      subPreview = '${category.itemCount} Items currently available';
    }

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
        subPreview,
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
    if (url.startsWith('assets/')) {
      return AssetImage(url);
    }
    return NetworkImage(url);
  }
}
