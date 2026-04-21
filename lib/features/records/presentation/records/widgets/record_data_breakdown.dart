import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/presentation/records/widgets/add_breakdown_item_sheet.dart';
import 'add_breakdown_item_sheet.dart';

class RecordDataBreakdown extends StatelessWidget {
  final MainRecordModel record;
  final Color accentColor;

  const RecordDataBreakdown({
    super.key,
    required this.record,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.decimalPattern();
    final data = record.data;

    final itemsTotal = data?.itemsTotal ?? 0;
    final balance = data?.grandTotal ?? 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECORD BREAKDOWN',
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  letterSpacing: 2,
                ),
              ),
              GestureDetector(
                onTap: () => AddBreakdownItemSheet.show(
                  context,
                  recordId: record.id,
                  accentColor: accentColor,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 12.w, color: accentColor),
                      SizedBox(width: 4.w),
                      Text(
                        'ADD ITEM',
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Items List
          if (data != null && data.items.isNotEmpty)
            ...data.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${item.quantity}',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          item.name.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      currencyFormat.format(item.amount),
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: 12.h),
          Divider(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
            height: 1,
          ),
          SizedBox(height: 16.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  letterSpacing: 1,
                ),
              ),
              Text(
                currencyFormat.format(itemsTotal),
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownItem {
  final int quantity;
  final String name;
  final num value;

  _BreakdownItem({
    required this.quantity,
    required this.name,
    required this.value,
  });
}
