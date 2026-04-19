import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/orderdetailpage/order_details_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

class PendingOrdersTab extends ConsumerStatefulWidget {
  final ValueNotifier<Set<String>> selectedIdsNotifier;

  const PendingOrdersTab({super.key, required this.selectedIdsNotifier});

  @override
  ConsumerState<PendingOrdersTab> createState() => _PendingOrdersTabState();
}

class _PendingOrdersTabState extends ConsumerState<PendingOrdersTab> {
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

    return ordersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => NodeErrorState(
        error: err,
        onRetry: () => ref.refresh(wholesaleOrdersProvider),
      ),
      data: (rawOrders) {
        // 🛡️ UI FILTER: Only show what is truly pending, even if the state refresh is pending
        final orders = rawOrders.where((o) => o.status == OrderStatus.pending).toList();

        return RefreshIndicator(
          onRefresh: () => ref.read(wholesaleOrdersProvider.notifier).refresh(),
          child: orders.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty_rounded,
                          size: 48.w,
                          color: onSurface.withOpacity(0.2),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No pending orders',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            color: onSurface.withOpacity(0.4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ValueListenableBuilder<Set<String>>(
                  valueListenable: widget.selectedIdsNotifier,
                  builder: (context, selectedIds, _) {
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: orders.length,
                      separatorBuilder: (context, _) => Divider(
                          height: 1.h, color: onSurface.withOpacity(0.05)),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final isSelected = selectedIds.contains(order.id);

                        return _PendingOrderCard(
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
                ),
        );

      },
    );
  }
}

class _PendingOrderCard extends StatelessWidget {
  final WholesaleOrder order;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _PendingOrderCard({
    required this.order,
    this.isSelected = false,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final dateFormat = DateFormat('MMM dd, yyyy · HH:mm');

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      splashColor: primary.withOpacity(0.05),
      highlightColor: primary.withOpacity(0.02),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
                            Icons.hourglass_empty_rounded,
                            size: 10.w,
                            color: onSurface.withOpacity(0.4),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'NOT SENT',
                            style: GoogleFonts.outfit(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: onSurface.withOpacity(0.4),
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
                    color: onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'PENDING',
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: onSurface.withOpacity(0.6),
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
                    'Total Amount',
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
