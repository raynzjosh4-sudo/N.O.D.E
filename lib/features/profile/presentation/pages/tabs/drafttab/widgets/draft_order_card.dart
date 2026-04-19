import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/orders/presentation/providers/bulk_order_providers.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/orders/presentation/providers/draft_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';
import 'package:node_app/features/orders/domain/repositories/order_repository.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/auth/domain/entities/business_profile.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:node_app/features/profile/presentation/providers/pdf_providers.dart';
import 'package:node_app/features/auth/data/models/business_model.dart';
import 'package:node_app/core/pdf/order_pdf_service.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:uuid/uuid.dart';

class DraftOrderCard extends ConsumerWidget {
  final DraftOrder draft;

  const DraftOrderCard({super.key, required this.draft});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final dateFormat = DateFormat('MMM dd, yyyy · HH:mm');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: theme.cardColor.withOpacity(0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Draft Order #${draft.id.length > 8 ? draft.id.substring(0, 8) : draft.id}',
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
                      'Last saved ${dateFormat.format(draft.lastModified)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'DRAFT',
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                _buildStat(context, '${draft.totalItems}', 'Items'),
                _buildDivider(context),
                _buildStat(context, '${draft.totalUnits}', 'Units'),
                _buildDivider(context),
                _buildStat(
                  context,
                  'UGX ${draft.totalAmount.toStringAsFixed(0)}',
                  'Total Value',
                  isPrice: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Spacer(),
              OutlinedButton(
                onPressed: () async {
                  final result = await ref
                      .read(draftOrdersProvider.notifier)
                      .deleteDraft(draft.id);
                  result.fold(
                    (failure) => NodeToastManager.show(
                      context,
                      title: 'Clearance Interrupted',
                      message: failure.toFriendlyMessage(),
                      status: NodeToastStatus.error,
                    ),
                    (_) {
                      NodeToastManager.show(
                        context,
                        title: 'Draft Removed',
                        message:
                            'Configuration cleared from your cloud buffer.',
                        status: NodeToastStatus.success,
                      );
                      // State is already updated optimistically by notifier
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: onSurface.withOpacity(0.1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 20.w,
                  ),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: onSurface.withOpacity(0.5),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () async {
                  final user = ref.read(userProfileProvider).value;
                  final business = ref.read(userBusinessProvider).value;

                  if (user == null || business == null) {
                    NodeToastManager.show(
                      context,
                      title: 'Identity Missing',
                      message: 'Please complete your profile to place orders.',
                      status: NodeToastStatus.warning,
                    );
                    return;
                  }

                  NodeToastManager.show(
                    context,
                    title: 'Compiling Order',
                    message: 'Synthesizing PDF and creating order registry...',
                    status: NodeToastStatus.info,
                  );

                  try {
                    // 1. Setup Business Profile
                    final businessProfile = BusinessModel.fromDrift(business);

                    final orderId = const Uuid().v4();
                    final pdfId = const Uuid().v4();

                    // 2. Generate PDF for the entire draft
                    final pdfResult = await OrderPdfService.generate(
                      orderId: orderId,
                      title: 'Order_${draft.id}',
                      user: user,
                      businessProfile: businessProfile,
                      entries: draft.entries,
                      date: DateTime.now(),
                    );

                    // 3. Save PDF Metadata
                    await ref
                        .read(pdfRepositoryProvider)
                        .savePdfMetadata(
                          id: pdfId,
                          userId: user.id,
                          title: 'Order Draft: ${draft.id}',
                          filePath: pdfResult.filePath,
                          fileSize: pdfResult.fileSize,
                        );

                    // 4. Promote to Wholesale Order
                    final wholesaleOrder = WholesaleOrder(
                      id: orderId,
                      date: DateTime.now(),
                      entries: draft.entries,
                      status: OrderStatus.pending,
                      pdfId: pdfId,
                      updatedAt: DateTime.now(),
                    );

                    final orderResult = await ref
                        .read(wholesaleOrdersProvider.notifier)
                        .saveOrder(wholesaleOrder);

                    await orderResult.fold(
                    (failure) async => throw failure.toFriendlyMessage(),
                      (_) async {
                        // 5. Delete the Draft
                        await ref
                            .read(draftOrdersProvider.notifier)
                            .deleteDraft(draft.id);

                        if (context.mounted) {
                          NodeToastManager.show(
                            context,
                            title: 'Order Manifested',
                            message:
                                'Your order has been moved to the active registry.',
                            status: NodeToastStatus.success,
                          );
                          ref.invalidate(draftOrdersProvider);
                          ref.invalidate(wholesaleOrdersProvider);
                          ref.invalidate(userPdfsProvider);
                        }
                      },
                    );
                  } catch (e) {
                    if (context.mounted) {
                      NodeToastManager.show(
                        context,
                        title: 'Flow Interrupted',
                        message: Failure.fromException(e).toFriendlyMessage(),
                        status: NodeToastStatus.error,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 32.w,
                  ),
                ),
                child: Text(
                  'Order',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
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
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: isPrice ? primary : onSurface,
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
