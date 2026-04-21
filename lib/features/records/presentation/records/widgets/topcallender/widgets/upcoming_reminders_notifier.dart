import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/records/presentation/records/pages/record_detail_page.dart';
import 'package:node_app/features/records/domain/types/record_types.dart';

class UpcomingRemindersNotifier extends ConsumerWidget {
  const UpcomingRemindersNotifier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recordsProvider);
    final theme = Theme.of(context);

    // 1. Extract unique dates that have reminders
    final reminderDates = records.items
        .where((r) => r.reminder?.date != null)
        .map((r) => r.reminder!.date!)
        .toList();

    // Remove duplicates (same date) and sort
    final uniqueDates = <DateTime>[];
    for (var date in reminderDates) {
      if (!uniqueDates.any((d) => _isSameDay(d, date))) {
        uniqueDates.add(date);
      }
    }
    uniqueDates.sort((a, b) => a.compareTo(b));

    // 2. Shrink if empty
    if (uniqueDates.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 96.h,
      margin: EdgeInsets.only(bottom: 4.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        itemCount: uniqueDates.length,
        itemBuilder: (context, index) {
          final date = uniqueDates[index];
          final dayName = DateFormat('E').format(date);
          final dayNumber = DateFormat('d').format(date);
          final isToday = _isSameDay(date, DateTime.now());

          return Container(
            width: 58.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: isToday
                  ? const Color(0xFFFFB800)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                if (isToday)
                  BoxShadow(
                    color: const Color(0xFFFFB800).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
              border: Border.all(
                color: isToday
                    ? Colors.transparent
                    : theme.colorScheme.onSurface.withOpacity(0.05),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: isToday
                        ? Colors.white
                        : theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? Colors.white
                        : theme.colorScheme.onSurface.withOpacity(0.05),
                  ),
                  child: Center(
                    child: Text(
                      dayNumber,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: isToday
                            ? Colors.black
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
