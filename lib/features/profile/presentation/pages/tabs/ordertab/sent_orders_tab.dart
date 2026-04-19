import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/orderdetailpage/sent_order_details_page.dart';
import 'package:node_app/features/profile/presentation/utils/order_status_ui_helper.dart';

import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

class SentOrdersTab extends ConsumerStatefulWidget {
  final ValueNotifier<Set<String>> selectedIdsNotifier;

  const SentOrdersTab({super.key, required this.selectedIdsNotifier});

  @override
  ConsumerState<SentOrdersTab> createState() => _SentOrdersTabState();
}

class _SentOrdersTabState extends ConsumerState<SentOrdersTab> {
  Set<String> get _selectedIds => widget.selectedIdsNotifier.value;

  void _toggleOrder(WholesaleOrder order) {
    if (order.status != OrderStatus.completed) return;

    setState(() {
      final newSelected = Set<String>.from(_selectedIds);
      if (newSelected.contains(order.id)) {
        newSelected.remove(order.id);
      } else {
        newSelected.add(order.id);
      }
      widget.selectedIdsNotifier.value = newSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sentOrdersAsync = ref.watch(sentOrdersProvider);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return sentOrdersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => NodeErrorState(
        error: err,
        onRetry: () => ref.refresh(sentOrdersProvider),
      ),
      data: (orders) {
        return RefreshIndicator(
          onRefresh: () => ref.read(sentOrdersProvider.notifier).refresh(),
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
                          Icons.verified_rounded,
                          size: 48.w,
                          color: onSurface.withOpacity(0.2),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No orders submitted yet',
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
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: orders.length,
                  separatorBuilder: (context, _) =>
                      Divider(height: 1.h, color: onSurface.withOpacity(0.05)),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final isSelected = _selectedIds.contains(order.id);

                    return _SentOrderCard(
                      order: order,
                      isSelected: isSelected,
                      onTap: () {
                        if (_selectedIds.isNotEmpty &&
                            order.status == OrderStatus.completed) {
                          _toggleOrder(order);
                        } else {
                          SentOrderDetailsPage.show(context, order);
                        }
                      },
                      onLongPress: () => _toggleOrder(order),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _SentOrderCard extends StatelessWidget {
  final WholesaleOrder order;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SentOrderCard({
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
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withOpacity(0.05)
              : theme.cardColor.withOpacity(0.1),
          border: isSelected ? Border.all(color: primary, width: 2.w) : null,
        ),
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
                      Text(
                        'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: onSurface,
                        ),
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
                            order.status.icon,
                            size: 10.w,
                            color: order.status.color,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            order.status.message,
                            style: GoogleFonts.outfit(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: order.status.color,
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
                    color: order.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    order.status.label,
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: order.status.color,
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
                    'Total Paid',
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
