import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/features/home/presentation/pages/notifications/presentation/providers/notification_providers.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleScan(String orderId) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final repository = ref.read(wholesaleOrderRepositoryProvider);
    final result = await repository.getOrderById(orderId);

    result.fold(
      (f) {
        NodeToastManager.show(
          context,
          title: 'Scan Error',
          message: f.toFriendlyMessage(),
          status: NodeToastStatus.error,
        );

        setState(() => _isProcessing = false);
      },
      (order) {
        if (order == null) {
          NodeToastManager.show(
            context,
            title: 'Not Found',
            message: 'No order found with ID: $orderId',
            status: NodeToastStatus.error,
          );
          setState(() => _isProcessing = false);
        } else {
          _showOrderResult(order);
        }
      },
    );
  }

  void _showOrderResult(WholesaleOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OrderScanResultSheet(
        order: order,
        onStatusUpdated: () {
          ref.invalidate(wholesaleOrdersProvider);
          setState(() => _isProcessing = false);
          Navigator.pop(context); // Close sheet
        },
      ),
    ).then((_) {
      if (mounted) setState(() => _isProcessing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Scanner
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleScan(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // Custom Overlay
          _ScanOverlay(),

          // Back Button
          Positioned(
            top: 60.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 24.w,
                ),
              ),
            ),
          ),

          // Processing Indicator
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.7;
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(color: Colors.black),
              Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Align QR code within the frame',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderScanResultSheet extends ConsumerWidget {
  final WholesaleOrder order;
  final VoidCallback onStatusUpdated;

  const _OrderScanResultSheet({
    required this.order,
    required this.onStatusUpdated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 40.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Order Found',
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '#${order.id}',
            style: TextStyle(
              fontSize: 12.sp,
              color: onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 32.h),
          _buildInfoRow(
            'Current Status',
            order.status.name.toUpperCase(),
            primary,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('Total Items', '${order.totalItems}', onSurface),
          SizedBox(height: 12.h),
          _buildInfoRow('Total Units', '${order.totalUnits}', onSurface),
          SizedBox(height: 40.h),

          if (order.status == OrderStatus.processing ||
              order.status == OrderStatus.submitted)
            ElevatedButton(
              onPressed: () async {
                final result = await ref
                    .read(wholesaleOrderRepositoryProvider)
                    .updateOrderStatus(order.id, OrderStatus.completed);

                result.fold(
                  (f) => NodeToastManager.show(
                    context,
                    title: 'Error',
                    message: f.toFriendlyMessage(),
                    status: NodeToastStatus.error,
                  ),

                  (_) {
                    NodeToastManager.show(
                      context,
                      title: 'Success',
                      message: 'Order marked as completed',
                      status: NodeToastStatus.success,
                    );

                    // 🚨 Security & Audit Broadcast: Alert all global administrators
                    // whenever a delivery scanning event finalizes organically.
                    ref.read(notificationRepositoryProvider).notifyAdmins(
                      title: 'Order Scanned & Delivered',
                      description: 'Order #${order.id} was successfully scanned and marked completed.',
                      category: 'security',
                    );

                    onStatusUpdated();
                  },

                );
              },
              child: const Text('MARK AS COMPLETED'),

              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            )
          else
            Text(
              'No transition available for this status.',
              style: TextStyle(
                color: onSurface.withOpacity(0.5),
                fontSize: 13.sp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: color),
        ),
      ],
    );
  }
}
