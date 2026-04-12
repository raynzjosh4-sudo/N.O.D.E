import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import '../providers/inventory_notifier.dart';
import '../../domain/entities/product.dart';
import '../widgets/advanced_product_card.dart';
import '../widgets/quantity_bottom_sheet.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryNotifierProvider);
    final filteredProducts = ref.watch(filteredInventoryProvider);
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // 👑 GLASSMORPHIC APP BAR
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
            title: Text(
              'NODE EXCHANGE',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                color: theme.colorScheme.primary,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.account_circle_outlined),
                onPressed: () {},
              ),
            ],
          ),

          // 🍱 BUSINESS BENTO GRID
          SliverToBoxAdapter(
            child: _buildBentoSummary(filteredProducts, theme, appColors, ref),
          ),

          // 🏷️ CATEGORY CHIPS
          SliverToBoxAdapter(child: _buildCategoryChips(theme, appColors)),

          // 🔍 SEARCH NODE
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
            sliver: SliverToBoxAdapter(
              child: SearchBar(
                elevation: WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  theme.colorScheme.surface,
                ),
                hintText: 'Search SKU, HS Code, or Brand...',
                leading: Icon(Icons.search, color: theme.colorScheme.primary),
                side: WidgetStatePropertyAll(
                  BorderSide(color: appColors.borderLight),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onChanged: (value) {
                  ref.read(inventorySearchQueryProvider.notifier).set(value);
                },
              ),
            ),
          ),

          // 📦 PRODUCT GRID
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: inventoryAsync.when(
              data: (_) => _buildProductGrid(filteredProducts, theme, context),
              loading: () => SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoSummary(
    List<Product> products,
    ThemeData theme,
    AppColors appColors,
    WidgetRef ref,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: AspectRatio(
        aspectRatio: 2.5,
        child: Row(
          children: [
            // 💳 WALLET CARD
            Expanded(
              flex: 3,
              child: _buildBentoCard(
                theme: theme,
                appColors: appColors,
                title: 'Wallet Balance',
                value: '42.8M UGX',
                subtitle: 'Credit: 15.0M',
                icon: Icons.account_balance_wallet_rounded,
                color: theme.colorScheme.primary,
                isPrimary: true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // 🚚 ORDER STATUS
                  Expanded(
                    child: _buildBentoCard(
                      theme: theme,
                      appColors: appColors,
                      title: 'Live Order',
                      value: 'In Transit',
                      subtitle: 'ETA: 2 Hrs',
                      icon: Icons.local_shipping_rounded,
                      color: appColors.moqOrange,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // 🚨 RESTOCK ALERT
                  Expanded(
                    child: _buildBentoCard(
                      theme: theme,
                      appColors: appColors,
                      title: 'Restock',
                      value: '12 Items',
                      subtitle: 'Low Stock',
                      icon: Icons.warning_amber_rounded,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required ThemeData theme,
    required AppColors appColors,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isPrimary = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isPrimary ? color : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: isPrimary ? null : Border.all(color: appColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: isPrimary ? theme.colorScheme.onPrimary : color,
                size: 20.w,
              ),
              if (!isPrimary)
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isPrimary
                      ? theme.colorScheme.onPrimary.withOpacity(0.8)
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: isPrimary
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontSize: isPrimary ? 18 : 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: isPrimary
                      ? theme.colorScheme.onPrimary.withOpacity(0.6)
                      : color,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(ThemeData theme, AppColors appColors) {
    final categories = ['All', 'Nets', 'Blankets', 'Mattrass', 'Curtains'];
    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Chip(
            label: Text(categories[index]),
            backgroundColor: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            labelStyle: TextStyle(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : appColors.borderLight,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(
    List<Product> products,
    ThemeData theme,
    BuildContext context,
  ) {
    if (products.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('No products found')),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58, // Adjusted for AdvancedProductCard height
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = products[index];
        return AdvancedProductCard(
          product: product,
          onAddTap: () => _showQuantitySelector(context, product, theme),
        );
      }, childCount: products.length),
    );
  }

  void _showQuantitySelector(
    BuildContext context,
    Product product,
    ThemeData theme,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuantityBottomSheet(
        product: product,
        onQuantitySelected: (qty) {
          NodeToastManager.show(
            context,
            title: 'Cart Updated',
            message: 'Added $qty units of ${product.name} to bulk order.',
            status: NodeToastStatus.success,
          );
        },
      ),
    );
  }
}
