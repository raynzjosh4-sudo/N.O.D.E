import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/features/profile/presentation/utils/order_status_ui_helper.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/orderdetailpage/order_details_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

class OrdersTab extends ConsumerStatefulWidget {
  final ValueNotifier<Set<String>> selectedIdsNotifier;

  OrdersTab({super.key, required this.selectedIdsNotifier});

  @override
  ConsumerState<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<OrdersTab> {
  Set<String> get _selectedIds => widget.selectedIdsNotifier.value;

  void _toggleSelection(String id) {
    setState(() {
      final newSelected = Set<String>.from(_selectedIds);
      if (newSelected.contains(id)) {
        newSelected.remove(id);
      } else {
        newSelected.add(id);
      }
      widget.selectedIdsNotifier.value = newSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(wholesaleOrdersProvider);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    final orders = ordersAsync.items;

    if (orders.isEmpty && ordersAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48.w,
              color: onSurface.withOpacity(0.2),
            ),
            SizedBox(height: 16.h),
            Text(
              'No orders yet',
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                color: onSurface.withOpacity(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<Set<String>>(
      valueListenable: widget.selectedIdsNotifier,
      builder: (context, selectedIds, _) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: orders.length,
          separatorBuilder: (context, _) =>
              Divider(height: 1.h, color: onSurface.withOpacity(0.05)),
          itemBuilder: (context, index) {
            final order = orders[index];
            final isSelected = selectedIds.contains(order.id);

            return _OrderCard(
              order: order,
              isSelected: isSelected,
              onTap: () {
                if (selectedIds.isNotEmpty) {
                  _toggleSelection(order.id);
                } else {
                  OrderDetailsPage.show(context, order);
                }
              },
              onLongPress: () => _toggleSelection(order.id),
            );
          },
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final WholesaleOrder order;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _OrderCard({
    required this.order,
    this.isSelected = false,
    required this.onTap,
    required this.onLongPress,
  });

  Color _getStatusColor(OrderStatus status) => status.color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final dateFormat = DateFormat('MMM dd, yyyy · HH:mm');
    final statusColor = _getStatusColor(order.status);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      splashColor: primary.withOpacity(0.05),
      highlightColor: primary.withOpacity(0.02),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(20.w),
        color: isSelected
            ? primary.withOpacity(0.06)
            : theme.cardColor.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          if (isSelected)
                            Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 16.w,
                                color: primary,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w900,
                                color: onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        dateFormat.format(order.date),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: onSurface.withOpacity(0.4),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            order.status == OrderStatus.pending
                                ? Icons.hourglass_empty_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 10.w,
                            color: order.status == OrderStatus.pending
                                ? onSurface.withOpacity(0.4)
                                : Colors.green,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            order.status == OrderStatus.pending
                                ? 'NOT SENT'
                                : 'SENT TO SUPPLIER',
                            style: GoogleFonts.outfit(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: order.status == OrderStatus.pending
                                  ? onSurface.withOpacity(0.4)
                                  : Colors.green,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    order.status.name.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildStat(context, '${order.totalItems}', 'Items'),
                _buildDivider(context),
                _buildStat(context, '${order.totalUnits}', 'Units'),
                _buildDivider(context),
                Expanded(
                  child: _buildStat(
                    context,
                    'UGX ${order.totalAmount.toStringAsFixed(0)}',
                    'Paid Amount',
                    isPrice: true,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: onSurface.withOpacity(0.2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String value,
    String label, {
    bool isPrice = false,
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: isPrice ? primary : onSurface,
            ),
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: onSurface.withOpacity(0.4),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 20.h,
      width: 1.w,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
    );
  }
}
