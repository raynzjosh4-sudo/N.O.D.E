import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/features/home/presentation/providers/home_providers.dart';
import '../product_detail_screen.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class AllSuppliersScreen extends ConsumerStatefulWidget {
  const AllSuppliersScreen({super.key});

  @override
  ConsumerState<AllSuppliersScreen> createState() => _AllSuppliersScreenState();
}

class _AllSuppliersScreenState extends ConsumerState<AllSuppliersScreen> {
  static const _pageSize = 12;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Fashion', 'Electronics', 'Home & Living', 'Manufacturing', 'Food & Beverage'];

  late final PagingController<int, Supplier> _pagingController =
      PagingController<int, Supplier>(
        fetchPage: (pageKey) => _fetchPage(pageKey),
        getNextPageKey: (state) {
          if (state.keys == null || state.keys!.isEmpty) {
            return 0;
          }
          return state.lastPageIsEmpty ? null : (state.nextIntPageKey);
        },
      );

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _pagingController.refresh();
    });
  }

  Future<List<Supplier>> _fetchPage(int pageKey) async {
    final repository = ref.read(homeRepositoryProvider);
    final result = await repository.getSuppliers(
      page: pageKey,
      pageSize: _pageSize,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
    );

    return result.fold((failure) => throw failure, (newItems) => newItems);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: PagingListener<int, Supplier>(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              centerTitle: true,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: theme.colorScheme.onSurface,
                  size: 20.w,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'All Suppliers',
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.h),
                child: Container(
                  height: 60.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (val) => val ? _onCategoryChanged(cat) : null,
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        selectedColor: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        side: BorderSide.none,
                        showCheckmark: false,
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              sliver: PagedSliverList<int, Supplier>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<Supplier>(
                  itemBuilder: (context, supplier, index) =>
                      _buildSupplierItem(context, supplier),
                  firstPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (_) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0.w),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => const Center(
                    child: Text('No suppliers found.'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierItem(BuildContext context, Supplier supplier) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductDetailScreen(
                  supplierId: supplier.id,
                ),
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
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // 📸 CIRCULAR AVATAR
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withOpacity(0.08),
                      width: 1.5.w,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(supplier.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // 📝 SUPPLIER INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            supplier.name,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Active',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.sp,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        supplier.category,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.w,
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 88.w), // Aligns with the text start like WhatsApp
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.onSurface.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }
}
