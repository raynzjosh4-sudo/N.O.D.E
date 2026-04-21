import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/core/theme/app_theme.dart';
import '../../../domain/types/record_types.dart';

import 'package:intl/intl.dart';

class ReminderSheet extends ConsumerStatefulWidget {
  final MainRecordModel record;

  const ReminderSheet({super.key, required this.record});

  static Future<void> show(BuildContext context, MainRecordModel record) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ReminderSheet(record: record),
    );
  }

  @override
  ConsumerState<ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends ConsumerState<ReminderSheet> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.record.reminder?.date;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _save() {
    ref
        .read(recordsProvider.notifier)
        .updateReminder(widget.record.id, _selectedDate);
    Navigator.pop(context);

    NodeToastManager.show(
      context,
      title: 'Reminder Set',
      message: _selectedDate == null
          ? 'Reminder removed.'
          : 'Notification set for ${DateFormat.yMMMd().format(_selectedDate!)}.',
      status: NodeToastStatus.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = widget.record.detail;

    final appColors = AppColors.of(context);
    final accentColor = detail?.type == RecordType.credit
        ? appColors.marginGreen
        : detail?.type == RecordType.debt
        ? appColors.moqOrange
        : appColors.accentCyan;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Set Payment Reminder',
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Node will send a notification to remind you about the balance from ${detail?.contactName ?? "this contact"}.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24.h),

          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: accentColor,
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    _selectedDate == null
                        ? 'Pick a reminder date'
                        : DateFormat.yMMMMd().format(_selectedDate!),
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),

          if (_selectedDate != null) ...[
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => setState(() => _selectedDate = null),
              child: Text(
                'Remove Reminder',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],

          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'Confirm Reminder',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
