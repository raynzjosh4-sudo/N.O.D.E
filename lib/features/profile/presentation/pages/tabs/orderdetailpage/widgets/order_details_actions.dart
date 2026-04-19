import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/services/notification_service.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/auth/data/models/business_model.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/core/error/failure.dart';

class OrderDetailsActions extends ConsumerStatefulWidget {
  final WholesaleOrder order;

  const OrderDetailsActions({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsActions> createState() =>
      _OrderDetailsActionsState();
}

class _OrderDetailsActionsState extends ConsumerState<OrderDetailsActions> {
  bool _isLoading = false;

  // ✅ LOCAL sent flag — flips to true the instant the send succeeds,
  //    so the button disappears WITHOUT waiting for any provider refresh.
  bool _justSent = false;
  DateTime? _sentAt;

  Future<void> _handleSendOrder() async {
    final businessEntry = ref.read(userBusinessProvider).value;

    if (businessEntry == null ||
        businessEntry.legalName.isEmpty ||
        businessEntry.city == null ||
        businessEntry.physicalAddress == null) {
      NodeToastManager.show(
        context,
        title: 'Business Profile Incomplete',
        message: 'Please complete your business identity to send orders.',
        status: NodeToastStatus.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final businessProfile = BusinessModel.fromDrift(businessEntry);

      final result = await ref
          .read(wholesaleOrdersProvider.notifier)
          .sendOrderToSupplier(widget.order, businessProfile);

      if (!mounted) return;

      result.fold(
        (failure) => NodeToastManager.show(
          context,
          title: 'Send Failed',
          message: failure.toFriendlyMessage(),
          status: NodeToastStatus.error,
        ),
        (_) {
          // ✅ Flip local flag immediately — button disappears right now
          setState(() {
            _justSent = true;
            _sentAt = DateTime.now();
          });

          NotificationService.showConfirmationAlert(
            title: 'Order Sent to Supplier',
            body:
                'Your order #${widget.order.id.substring(0, 8)} has been officially submitted.',
          );

          NodeToastManager.show(
            context,
            title: 'Order Sent',
            message: 'Your order has been submitted to the supplier.',
            status: NodeToastStatus.success,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      NodeToastManager.show(
        context,
        title: 'Unexpected Error',
        message: Failure.fromException(e).toFriendlyMessage(),
        status: NodeToastStatus.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    // Determine sent state: either we just sent it this session,
    // or the order was already submitted before opening this page.
    final alreadySubmitted = widget.order.status != OrderStatus.pending &&
        widget.order.status != OrderStatus.cancelled;

    final isSent = _justSent || alreadySubmitted;

    // Compute the display date: prefer the local timestamp if just sent,
    // otherwise fall back to the stored updatedAt timestamp.
    final displayDate = _sentAt ?? widget.order.updatedAt;
    final dateStr = DateFormat('MMM dd, yyyy • HH:mm').format(displayDate);

    if (isSent) {
      // ── Sent State: show submission timestamp, no button ──────────────────
      return Container(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 16.w,
              color: Colors.green,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                'Order submitted on $dateStr',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // ── Pending State: show Send button ──────────────────────────────────────
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleSendOrder,
              icon: _isLoading
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primary,
                      ),
                    )
                  : Icon(Icons.send_rounded, size: 18.w),
              label: Text(_isLoading ? 'SENDING...' : 'SEND ORDER'),
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
      ),
    );
  }
}
