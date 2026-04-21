import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'add_record_sheet.dart';

import 'package:node_app/features/records/data/models/main_record_model.dart';

class TimelineAddEntryButton extends StatelessWidget {
  final MainRecordModel record;
  final Color accentColor;

  const TimelineAddEntryButton({
    super.key,
    required this.record,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── LEFT SIDE: TIMELINE LINE & BUBBLE ──────────────────
          SizedBox(
            width: 60.w,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 3.w,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => AddRecordSheet.show(context, record: record),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surface,
                      border: Border.all(
                        color: accentColor.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: accentColor,
                      size: 20.w,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 3.w,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── RIGHT SIDE: ACTION PROMPT ──────────────────
          Expanded(
            child: GestureDetector(
              onTap: () => AddRecordSheet.show(context, record: record),
              child: Container(
                margin: EdgeInsets.fromLTRB(16.w, 12.h, 0, 12.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: accentColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'RECORD NEW ACTIVITY',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        color: accentColor.withOpacity(0.7),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: accentColor.withOpacity(0.3),
                      size: 20.w,
                    ),
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
