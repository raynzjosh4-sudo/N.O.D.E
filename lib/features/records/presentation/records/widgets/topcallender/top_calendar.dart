import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/domain/types/record_types.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/records/presentation/providers/alert_provider.dart';
import 'package:node_app/features/records/presentation/records/pages/record_detail_page.dart';
import 'widgets/calendar_date_card.dart';
import 'widgets/live_alert_widget.dart';
import 'package:node_app/core/theme/app_theme.dart';

/// ⏱️ Ticks every second — causes TopCalendar to re-evaluate urgency in real-time.
final clockTickProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

class TopCalendar extends ConsumerWidget {
  const TopCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recordsProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final alertState = ref.watch(alertProvider);
    final appColors = AppColors.of(context);
    // ⏱️ Watch the clock — rebuilds every second so urgency detection is live
    final now = ref.watch(clockTickProvider).value ?? DateTime.now();

    // 1. Get all records that have reminders
    final reminderRecords = records.items
        .where((r) => r.reminder?.date != null)
        .toList();

    // 2. Sort: upcoming (not overdue) first by date, then overdue records at the end
    reminderRecords.sort((a, b) {
      final aDate = a.reminder!.date!;
      final bDate = b.reminder!.date!;
      final aOverdue = aDate.isBefore(now);
      final bOverdue = bDate.isBefore(now);

      // Overdue records go to the back
      if (aOverdue && !bOverdue) return 1;
      if (!aOverdue && bOverdue) return -1;

      // Both overdue or both upcoming — sort chronologically
      return aDate.compareTo(bDate);
    });

    // 3. Determine visibility/height
    final bool hasContent = reminderRecords.isNotEmpty || alertState.isVisible;
    final double headerHeight = alertState.isVisible
        ? 132.h
        : (reminderRecords.isNotEmpty ? 132.h : 0.h);

    if (!hasContent) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TopCalendarDelegate(
        height: headerHeight,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (alertState.isVisible && alertState.activeRecord != null)
                const LiveAlertWidget()
              else
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: reminderRecords.length,
                    itemBuilder: (context, index) {
                      final record = reminderRecords[index];
                      final date = record.reminder!.date!;
                      final isSelected =
                          date.day == selectedDate.day &&
                          date.month == selectedDate.month &&
                          date.year == selectedDate.year;

                      final recordColor =
                          record.detail?.type == RecordType.credit
                          ? appColors.marginGreen
                          : record.detail?.type == RecordType.debt
                          ? appColors.moqOrange
                          : appColors.accentCyan;

                      // 🚨 Flash if this is the first (soonest) upcoming card
                      // and its reminder fires within the next 60 seconds.
                      final minuteFromNow = now.add(
                        const Duration(minutes: 30),
                      );
                      final isUrgent =
                          index == 0 &&
                          !date.isBefore(now) &&
                          date.isBefore(minuteFromNow);

                      return CalendarDateCard(
                        date: date,
                        isSelected: isSelected,
                        hasNotification: true,
                        color: recordColor,
                        isUrgent: isUrgent,
                        onTap: () =>
                            RecordDetailPage.show(context, record: record),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopCalendarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _TopCalendarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_TopCalendarDelegate oldDelegate) {
    return false;
  }
}
