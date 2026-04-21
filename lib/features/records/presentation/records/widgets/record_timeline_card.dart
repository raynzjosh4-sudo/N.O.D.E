import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'add_record_sheet.dart';

class RecordTimelineCard extends StatelessWidget {
  final DateTime date;
  final String timeRange;
  final String reference;
  final String eventTotal;
  final String resultBalance;
  final String badge;
  final String description;
  final String brand;
  final Color color;
  final bool isFirst;
  final bool isLast;
  final String? statusText;
  final bool showPayButton;
  final bool isClickable;
  final MainRecordModel? record;

  const RecordTimelineCard({
    super.key,
    this.record,
    required this.date,
    required this.timeRange,
    required this.reference,
    required this.eventTotal,
    required this.resultBalance,
    required this.badge,
    required this.description,
    required this.brand,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
    this.statusText,
    this.showPayButton = false,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── LEFT SIDE: DATE BUBBLE & LINE ──────────────────
          SizedBox(
            width: 60.w,
            child: Column(
              children: [
                Text(
                  DateFormat('MMM').format(date).toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: color.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3.w,
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── RIGHT SIDE: CONTENT CARD ──────────────────
          Expanded(
            child: GestureDetector(
              onTap: isClickable
                  ? () => AddRecordSheet.show(context, record: record)
                  : null,
              child: Container(
                margin: EdgeInsets.fromLTRB(12.w, 4.h, 0, 16.h),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeRange,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          reference,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total: $eventTotal',
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.outfit(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calculate_outlined,
                                size: 14.w,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.2,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  'Balance: $resultBalance',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (statusText != null) ...[
                          SizedBox(width: 12.w),
                          Text(
                            statusText!,
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                        ],
                      ],
                    ),

                    if (showPayButton) ...[
                      SizedBox(height: 16.h),
                      const Divider(height: 1),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total payment',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                              ),
                              Text(
                                '\$0.00',
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          _MiniPayBtn(onTap: () {}),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPayBtn extends StatelessWidget {
  final VoidCallback onTap;

  const _MiniPayBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'Pay',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
