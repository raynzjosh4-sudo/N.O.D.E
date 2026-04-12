import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/profile/presentation/providers/pdf_providers.dart';

import 'widgets/order_product_entry_card.dart';
import 'widgets/order_details_actions.dart';
import 'widgets/order_status_badge.dart';
import 'widgets/order_summary_row.dart';
import 'package:node_app/features/profile/presentation/pages/pdf_viewer_page.dart';

class OrderDetailsPage extends ConsumerWidget {
  final WholesaleOrder order;

  OrderDetailsPage({super.key, required this.order});

  static void show(BuildContext context, WholesaleOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsPage(order: order)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final dateFormat = DateFormat('MMMM dd, yyyy · HH:mm');

    // Fetch PDFs to find the linked one
    final pdfsAsync = ref.watch(userPdfsProvider);
    final linkedPdf = pdfsAsync.whenOrNull(
      data: (docs) {
        if (order.pdfId == null) return null;
        final matches = docs.where((doc) => doc.id == order.pdfId);
        return matches.isNotEmpty ? matches.first : null;
      },
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_rounded, color: onSurface, size: 28.w),
        ),
        title: Text(
          'Order Details',
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header Info ───────────────────────────────────────────────
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.id.split('-').first}...',
                              style: GoogleFonts.outfit(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900,
                                color: onSurface,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              dateFormat.format(order.date),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: onSurface.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      OrderStatusBadge(status: order.status),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // ── Product Cards ──────────────────────────────────────
                  ...order.entries.map((entry) {
                    return OrderProductEntryCard(entry: entry);
                  }).toList(),

                  // ── Linked PDF ──────────────────────────────────────────
                  if (linkedPdf != null) ...[
                    SizedBox(height: 24.h),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerPage(doc: linkedPdf),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description_rounded,
                              color: primary,
                              size: 24.w,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Linked Document',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: onSurface.withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    linkedPdf.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: onSurface.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // ── Summary Section ──────────────────────────────────────────
                  SizedBox(height: 40.h),
                  OrderSummaryRow(label: 'Items', value: '${order.totalItems}'),
                  SizedBox(height: 12.h),
                  OrderSummaryRow(
                    label: 'Total Units',
                    value: '${order.totalUnits} Units',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Total Paid',
                          style: GoogleFonts.outfit(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            color: onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'UGX ${order.totalAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          // ── Action Buttons Bottom ──────────────────────────────────────────
          OrderDetailsActions(order: order),
        ],
      ),
    );
  }
}
