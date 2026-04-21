import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/theme/app_theme.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/domain/types/record_types.dart';
import 'package:node_app/features/records/presentation/records/pages/record_detail_page.dart';
import 'package:node_app/features/records/presentation/records/widgets/record_calendar_sheet.dart';

class RecordCard extends StatelessWidget {
  final MainRecordModel record;
  final VoidCallback onTap;
  final VoidCallback? onPaymentTap;
  final VoidCallback? onOptionsTap;

  const RecordCard({
    super.key,
    required this.record,
    required this.onTap,
    this.onPaymentTap,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final detail = record.detail;

    final isCredit = detail?.type == RecordType.credit;
    final isStandard = detail?.type == RecordType.standard;
    final accentColor = isCredit
        ? appColors.marginGreen
        : isStandard
        ? appColors.accentCyan
        : appColors.moqOrange;

    final statusColor = record.isCompleted
        ? appColors.marginGreen
        : (record.isOverdue ? appColors.errorRed : appColors.moqOrange);

    final currencyFormat = NumberFormat.compact();
    final unit = detail?.unit ?? 'Units';

    // Build the value string: "30 / 100 Eggs"
    final currentValue = detail?.currentValue ?? 0;
    final targetValue = detail?.targetValue ?? 0;

    final valueString = targetValue > 0
        ? '${currencyFormat.format(currentValue)} / ${currencyFormat.format(targetValue)} $unit'
        : '${currencyFormat.format(currentValue)} $unit';

    return GestureDetector(
      onTap: () => RecordDetailPage.show(context, record: record),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // Solid contrast against scaffold
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: -5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            // TOP ROW: Avatar, Info, and Actions
            Row(
              children: [
                // Icon instead of Image
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Icon(
                      isCredit
                          ? Icons.add_chart_rounded
                          : isStandard
                          ? Icons.analytics_rounded
                          : Icons.area_chart_rounded,
                      size: 20.w,
                      color: accentColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Name & Item
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              detail?.contactName ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              detail?.itemName ?? 'No Item',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.4,
                                ),
                              ),
                            ),
                          ),
                          if (detail?.referenceTag != null) ...[
                            SizedBox(width: 6.w),
                            Text(
                              detail!.referenceTag!,
                              style: GoogleFonts.outfit(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Button
                _CircleAction(
                  icon: Icons.add_rounded,
                  onTap: onPaymentTap ?? onTap,
                  backgroundColor: accentColor,
                  iconColor: Colors.black,
                  isPrimary: true,
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // INTERMEDIATE: PROGRESS & SUMMARY
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'UNITS TRACKED', // Simplified label
                        style: GoogleFonts.outfit(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface.withOpacity(0.2),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        valueString,
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: accentColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // DETAIL PILL
            GestureDetector(
              onTap: () => RecordCalendarSheet.show(context, record: record),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Status Dot
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      DateFormat(
                        'd MMMM yyyy  •  hh:mm a',
                      ).format(record.updatedAt).toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final bool isPrimary;

  const _CircleAction({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          gradient: isPrimary
              ? LinearGradient(
                  colors: [backgroundColor, backgroundColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: backgroundColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Icon(icon, size: 20.w, color: iconColor),
      ),
    );
  }
}
