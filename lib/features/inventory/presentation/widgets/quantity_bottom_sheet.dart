import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/product.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class QuantityBottomSheet extends StatefulWidget {
  final Product product;
  final Function(int) onQuantitySelected;

  const QuantityBottomSheet({
    super.key,
    required this.product,
    required this.onQuantitySelected,
  });

  @override
  State<QuantityBottomSheet> createState() => _QuantityBottomSheetState();
}

class _QuantityBottomSheetState extends State<QuantityBottomSheet> {
  int _selectedQuantity = 50; // Default B2B MOQ

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + mediaQuery.padding.bottom),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👑 DRAG HANDLE
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: appColors.borderLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // --- HEADER: Product Info ---
          Row(
            children: [
              Hero(
                tag: 'product-${widget.product.id}',
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                    image: widget.product.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(widget.product.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: widget.product.imageUrl.isEmpty 
                      ? Icon(Icons.inventory_2_outlined, color: theme.colorScheme.primary)
                      : null,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Wholesale Tiers: 50, 100, 200+',
                      style: theme.textTheme.bodySmall?.copyWith(color: appColors.moqOrange),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // --- SELECTOR: Bulk Levels ---
          Text(
            'Select Bulk Quantity',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildQuantitySelector(theme, appColors),

          SizedBox(height: 32.h),

          // --- SUMMARY & ADD ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Total Value',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  ),
                  Text(
                    '${(_selectedQuantity * widget.product.srp * 0.7).toInt().toString()} UGX', // Simplified pricing logic for preview
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.heavyImpact(); // 👑 HAPTIC MUSCLE
                widget.onQuantitySelected(_selectedQuantity);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
              child: Text('ADD TO BULK ORDER', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(ThemeData theme, AppColors appColors) {
    final List<int> presetQuantities = [50, 100, 200, 500];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: presetQuantities.map((qty) {
        final bool isSelected = _selectedQuantity == qty;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedQuantity = qty);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : appColors.borderLight,
                    width: 1.5.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    qty.toString(),
                    style: TextStyle(
                      color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

