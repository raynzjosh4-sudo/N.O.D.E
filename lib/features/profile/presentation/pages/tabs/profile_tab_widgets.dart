import 'package:flutter/material.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import '../../../../inventory/domain/entities/product.dart';
import '../../../../inventory/presentation/widgets/advanced_product_card.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/database/app_database.dart';

class ProfileActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDestructive;
  final VoidCallback? onTap;

  ProfileActionTile({
    super.key,
    required this.title,
    required this.icon,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.01),
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
              width: 1.w,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22.w,
              color: color.withOpacity(isDestructive ? 1.0 : 0.7),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.w,
              color: color.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  ProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: onSurface.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: onSurface.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: color),
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileProductGrid extends StatelessWidget {
  final List<Product> products;

  ProfileProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(20.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return AdvancedProductCard(product: products[index], onAddTap: () {});
      },
    );
  }
}

class ProfilePlaceholderView extends StatelessWidget {
  final String title;
  final String? subtitle;

  ProfilePlaceholderView({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 48.w,
              color: theme.primaryColor.withOpacity(0.1),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.35),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProfileSavedProductList extends StatelessWidget {
  final List<SavedProduct> products;
  final Set<String> selectedProductIds;
  final Function(String) onProductToggled;
  final Function(String) onProductDeleted;

  ProfileSavedProductList({
    super.key,
    required this.products,
    required this.selectedProductIds,
    required this.onProductToggled,
    required this.onProductDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final savedProduct = products[index];
        return Dismissible(
          key: Key(savedProduct.id ?? savedProduct.product.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            color: Colors.red.shade900,
            child: Icon(
              Icons.delete_sweep_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
          onDismissed: (_) {
            if (savedProduct.id != null) {
              onProductDeleted(savedProduct.id!);
            }
          },
          child: ProfileSavedProductTile(
            savedProduct: savedProduct,
            isSelected: selectedProductIds.contains(savedProduct.product.id),
            onTap: () => onProductToggled(savedProduct.product.id),
          ),
        );
      },
    );
  }
}

class ProfileSavedProductTile extends StatelessWidget {
  final SavedProduct savedProduct;
  final bool isSelected;
  final VoidCallback onTap;

  ProfileSavedProductTile({
    super.key,
    required this.savedProduct,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final product = savedProduct.product;
    final quantity = savedProduct.quantity;

    // Logic: Calculate tier price based on saved quantity
    final unitPrice = product.getPriceForQuantity(quantity);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withOpacity(0.05)
              : onSurface.withOpacity(0.02),
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? primary.withOpacity(0.2)
                  : onSurface.withOpacity(0.05),
              width: 1.w,
            ),
          ),
        ),
        child: Row(
          children: [
            // 🖼️ Product Image with Selection Indicator & Quantity Badge
            Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: isSelected
                        ? Border.all(color: primary, width: 2.w)
                        : null,
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Selection Checkmark
                if (isSelected)
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 20.w,
                        color: primary,
                      ),
                    ),
                  ),
                // Quantity Badge
                Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : onSurface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'x$quantity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),

            // 📝 Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? primary : onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          product.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isSelected
                                ? primary.withOpacity(0.6)
                                : onSurface.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 3.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary.withOpacity(0.3)
                              : onSurface.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$quantity units',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isSelected
                              ? primary
                              : theme.primaryColor.withOpacity(0.7),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  // Spec chip (Color / Size)
                  if (savedProduct.selectedColor != null ||
                      savedProduct.selectedSize != null) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primary.withOpacity(0.1)
                            : onSurface.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        [
                          if (savedProduct.selectedColor != null)
                            savedProduct.selectedColor!,
                          if (savedProduct.selectedSize != null)
                            savedProduct.selectedSize!,
                        ].join(' · '),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? primary
                              : onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'UGX ${unitPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? primary : theme.primaryColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '/ unit',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? primary.withOpacity(0.4)
                                : onSurface.withOpacity(0.3),
                          ),
                        ),
                      ],
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
}

class ProfileSavedBulkOrderList extends StatelessWidget {
  final List<BulkOrderEntry> orders;
  final Set<String> selectedOrderIds;
  final Function(String) onOrderToggled;
  final Function(String) onDelete;

  const ProfileSavedBulkOrderList({
    super.key,
    required this.orders,
    required this.selectedOrderIds,
    required this.onOrderToggled,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Dismissible(
          key: Key(order.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            color: Colors.red.shade900,
            child: Icon(
              Icons.delete_sweep_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
          onDismissed: (_) => onDelete(order.id),
          child: ProfileSavedBulkOrderTile(
            order: order,
            isSelected: selectedOrderIds.contains(order.id),
            onTap: () => onOrderToggled(order.id),
          ),
        );
      },
    );
  }
}

class ProfileSavedBulkOrderTile extends StatelessWidget {
  final BulkOrderEntry order;
  final bool isSelected;
  final VoidCallback onTap;

  const ProfileSavedBulkOrderTile({
    super.key,
    required this.order,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withOpacity(0.05)
              : onSurface.withOpacity(0.02),
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? primary.withOpacity(0.2)
                  : onSurface.withOpacity(0.05),
              width: 1.w,
            ),
          ),
        ),
        child: Row(
          children: [
            // 🖼️ Representative Image
            Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: isSelected
                        ? Border.all(color: primary, width: 2.w)
                        : null,
                    image: order.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(order.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: onSurface.withOpacity(0.05),
                  ),
                  child: order.imageUrl == null
                      ? Icon(
                          Icons.inventory_2_outlined,
                          color: onSurface.withOpacity(0.2),
                          size: 32.w,
                        )
                      : null,
                ),
                if (isSelected)
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 20.w,
                        color: primary,
                      ),
                    ),
                  ),
                // Total Units Badge
                Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : onSurface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'x${order.totalUnits}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),

            // 📝 Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.groupName ?? 'Unnamed Group',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? primary : onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${order.productName} · ${order.brand}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary.withOpacity(0.1)
                              : onSurface.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.grid_view_rounded,
                              size: 10.w,
                              color: isSelected
                                  ? primary
                                  : onSurface.withOpacity(0.4),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Template',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? primary
                                    : onSurface.withOpacity(0.5),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
