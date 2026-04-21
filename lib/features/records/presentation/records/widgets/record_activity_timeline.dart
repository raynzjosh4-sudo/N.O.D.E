import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/data/models/record_model.dart';
import '../../../domain/types/record_types.dart';
import '../widgets/record_timeline_card.dart';
import '../widgets/timeline_add_entry_button.dart';
import 'package:node_app/core/theme/app_theme.dart';

class RecordActivityTimeline extends StatelessWidget {
  final MainRecordModel record;

  const RecordActivityTimeline({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final detail = record.detail;
    final accentColor = detail?.type == RecordType.credit
        ? appColors.marginGreen
        : appColors.moqOrange;

    // Build log cards
    final List<Widget> timelineItems = [];

    // Sort records by date (oldest first for chronological order)
    final sortedLogs = List<RecordModel>.from(record.records)
      ..sort((a, b) => a.time.compareTo(b.time));

    // Determine the logical 'Start' time for the Initialized card.
    // If we have logs, the start is clearly before the first log.
    // We use either the oldest log's time or the record's update time.
    final startTime = sortedLogs.isNotEmpty 
        ? sortedLogs.first.time.subtract(const Duration(minutes: 5))
        : record.updatedAt;

    final unit = detail?.unit ?? 'Units';

    // 1. Add Initialized card at the TOP
    timelineItems.add(
      RecordTimelineCard(
        record: record,
        date: startTime,
        timeRange: DateFormat('hh:mm a').format(startTime),
        reference: detail?.referenceTag ?? '#INIT',
        eventTotal: '0',
        resultBalance: NumberFormat.decimalPattern().format(
          record.data?.grandTotal ?? 0,
        ),
        badge: 'SYSTEM',
        description:
            'Record tracking started for ${detail?.itemName ?? "New Item"}',
        brand: 'Node System',
        color: sortedLogs.isEmpty
            ? accentColor
            : appColors.enterpriseBlue.withOpacity(0.5),
        statusText: '• INITIALIZED',
        isFirst: true,
        isLast: sortedLogs.isEmpty,
        isClickable: false,
      ),
    );

    // 2. Add chronological entries
    for (int i = 0; i < sortedLogs.length; i++) {
      final log = sortedLogs[i];

      timelineItems.add(
        RecordTimelineCard(
          record: record,
          date: log.time,
          timeRange: DateFormat('hh:mm a').format(log.time),
          reference: log.reference ?? '#TRX-${i + 1}',
          eventTotal: NumberFormat.decimalPattern().format(log.total),
          resultBalance: NumberFormat.decimalPattern().format(log.balanceAfter),
          badge: i == sortedLogs.length - 1 ? 'LATEST' : 'RECORD',
          description: log.message,
          brand: 'Node Record',
          color: log.total < 0 ? appColors.moqOrange : appColors.accentCyan,
          isFirst: false,
          isLast: false, // The button is always after the logs
        ),
      );
    }

    return Column(
      children: [
        _TimelineCategoryGroup(
          title: 'Record History',
          count: sortedLogs.length + 1,
          color: accentColor,
          isExpanded: true,
          children: [
            ...timelineItems,
            TimelineAddEntryButton(record: record, accentColor: accentColor),
          ],
        ),
      ],
    );
  }
}

class _TimelineCategoryGroup extends StatefulWidget {
  final String title;
  final int count;
  final Color color;
  final bool isExpanded;
  final List<Widget> children;

  const _TimelineCategoryGroup({
    required this.title,
    required this.count,
    required this.color,
    this.isExpanded = true,
    required this.children,
  });

  @override
  State<_TimelineCategoryGroup> createState() => _TimelineCategoryGroupState();
}

class _TimelineCategoryGroupState extends State<_TimelineCategoryGroup> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '${widget.title}(${widget.count})',
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
        if (_expanded) ...[SizedBox(height: 16.h), ...widget.children],
      ],
    );
  }
}

// Widgets moved to record_timeline_card.dart
