import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/core/theme/app_theme.dart';
import '../../../domain/types/record_types.dart';

class RecordCalendarSheet extends ConsumerStatefulWidget {
  final MainRecordModel record;
  const RecordCalendarSheet({super.key, required this.record});

  static Future<void> show(
    BuildContext context, {
    required MainRecordModel record,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecordCalendarSheet(record: record),
    );
  }

  @override
  ConsumerState<RecordCalendarSheet> createState() =>
      _RecordCalendarSheetState();
}

class _RecordCalendarSheetState extends ConsumerState<RecordCalendarSheet> {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final records = ref.watch(recordsProvider);
    final detail = widget.record.detail;
    final accentColor = detail?.type == RecordType.credit
        ? appColors.marginGreen
        : detail?.type == RecordType.debt
        ? appColors.moqOrange
        : appColors.accentCyan;

    // Identify days with activity for THIS record only
    final activeDays = <String>{};
    for (final log in widget.record.records) {
      activeDays.add(DateFormat('yyyy-MM-dd').format(log.time));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECORD REGISTRY',
                      style: GoogleFonts.outfit(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'MMMM yyyy',
                      ).format(_focusedMonth).toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _IconButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: _previousMonth,
                    ),
                    SizedBox(width: 8.w),
                    _IconButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: _nextMonth,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Calendar Grid
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // Weekday labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                        .map((d) {
                          return SizedBox(
                            width: 40.w,
                            child: Center(
                              child: Text(
                                d,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                  SizedBox(height: 16.h),

                  // Days Grid
                  _buildCalendarGrid(activeDays, accentColor),

                  SizedBox(height: 32.h),

                  // Selected Day Activity (Mini-list)
                  if (_selectedDay != null) ...[
                    _buildDayActivity(records.items, _selectedDay!, accentColor),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(Set<String> activeDays, Color accentColor) {
    final theme = Theme.of(context);
    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday;

    // Adjust for Monday start (Dart weekday returns 1=Mon, 7=Sun)
    final paddingDays = firstDayOfMonth - 1;

    final List<Widget> dayWidgets = [];

    // Empty spaces for previous month days
    for (int i = 0; i < paddingDays; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    // Actual days
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDay = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final dayKey = DateFormat('yyyy-MM-dd').format(currentDay);

      final isToday = _isSameDay(currentDay, DateTime.now());
      final isSelected = _isSameDay(currentDay, _selectedDay);
      final hasActivity = activeDays.contains(dayKey);

      dayWidgets.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDay = currentDay),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor
                  : (hasActivity
                        ? accentColor.withOpacity(0.15)
                        : (isToday
                              ? accentColor.withOpacity(0.05)
                              : Colors.transparent)),
              borderRadius: BorderRadius.circular(14.r),
              border: (isToday && !isSelected && !hasActivity)
                  ? Border.all(color: accentColor.withOpacity(0.2), width: 1)
                  : (hasActivity && !isSelected
                        ? Border.all(
                            color: accentColor.withOpacity(0.2),
                            width: 1,
                          )
                        : null),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: isSelected || hasActivity || isToday
                      ? FontWeight.w900
                      : FontWeight.w600,
                  color: isSelected
                      ? Colors.black
                      : (hasActivity || isToday
                            ? accentColor
                            : theme.colorScheme.onSurface),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      children: dayWidgets,
    );
  }

  Widget _buildDayActivity(
      List<MainRecordModel> records, DateTime date, Color accentColor) {
    final theme = Theme.of(context);
    final detail = widget.record.detail;

    // Find all transaction logs for THIS specific record on the selected day
    final dayLogs = widget.record.records
        .where((log) => _isSameDay(log.time, date))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('d MMMM').format(date).toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            Text(
              '${dayLogs.length} EVENTS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (dayLogs.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Text(
                'No activity logged for this day.',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  fontSize: 12.sp,
                ),
              ),
            ),
          )
        else
          ...dayLogs.map<Widget>((log) {
            final isReduce = log.total < 0;
            final appColors = AppColors.of(context);
            final itemColor = isReduce
                ? appColors.moqOrange
                : appColors.accentCyan;

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: itemColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${detail?.contactName ?? "Unknown"} (${detail?.itemName ?? "No Item"})',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          log.message.isEmpty ? 'Manual Activity' : log.message,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(log.total),
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: itemColor,
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a').format(log.time),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, size: 20.w),
      ),
    );
  }
}
