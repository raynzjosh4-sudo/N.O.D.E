import 'package:flutter/material.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsActions extends StatelessWidget {
  final WholesaleOrder order;

  const OrderDetailsActions({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: _buildActionForStatus(context),
    );
  }

  Widget _buildActionForStatus(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    switch (order.status) {
      case OrderStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Share.share(
                    'Order Notification: #${order.id}\nStatus: PENDING\nTotal: UGX ${order.totalAmount}',
                  );
                },
                icon: Icon(Icons.send_rounded, size: 18.w),
                label: const Text('SEND ORDER'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  side: BorderSide(color: primary, width: 2),
                  foregroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.processing:
        return ElevatedButton.icon(
          onPressed: () => context.pushNamed('scan'),
          icon: Icon(Icons.qr_code_scanner_rounded, size: 20.w),
          label: const Text('SCAN QR CODE'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
        );

      case OrderStatus.shipped:
        return ElevatedButton(
          onPressed: () {},
          child: const Text('MARK AS COMPLETED'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );

      case OrderStatus.delivered:
        return ElevatedButton(
          onPressed: null,
          child: const Text('LIFECYCLE COMPLETED'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 56.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
