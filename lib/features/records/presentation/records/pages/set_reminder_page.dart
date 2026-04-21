import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/services/notification_service.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import '../../../data/models/main_record_model.dart';
import '../../../domain/types/record_types.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/core/theme/app_theme.dart';

class SetReminderPage extends ConsumerStatefulWidget {
  final MainRecordModel record;

  const SetReminderPage({super.key, required this.record});

  static void show(BuildContext context, MainRecordModel record) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SetReminderPage(record: record)),
    );
  }

  @override
  ConsumerState<SetReminderPage> createState() => _SetReminderPageState();
}

class _SetReminderPageState extends ConsumerState<SetReminderPage> {
  DateTime? _selectedDate;
  bool _isRecurring = false;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    final reminder = widget.record.reminder;
    _selectedDate = reminder?.date;
    _isRecurring = reminder?.isRecurring ?? false;
    if (reminder?.time != null) {
      final parts = reminder!.time!.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  void _onPresetSelected(int days) {
    setState(() {
      _selectedDate = DateTime.now().add(Duration(days: days));
    });
  }

  Future<void> _pickCustomDate() async {
    final appColors = AppColors.of(context);
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: widget.record.detail?.type == RecordType.credit
                  ? appColors.marginGreen
                  : appColors.moqOrange,
              surface: const Color(0xFF1A1D21),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickCustomTime() async {
    final appColors = AppColors.of(context);
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: widget.record.detail?.type == RecordType.credit
                  ? appColors.marginGreen
                  : appColors.moqOrange,
              surface: const Color(0xFF1A1D21),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _save() async {
    // 🛡️ [Harden] Check for permissions before proceeding
    final hasPermission = await NotificationService.areNotificationsEnabled();
    final canExact = await NotificationService.canScheduleExactAlarms();

    if (!hasPermission && mounted) {
      NodeToastManager.show(
        context,
        title: 'Notifications Blocked',
        message:
            'Please enable notifications in system settings to receive reminders.',
        status: NodeToastStatus.error,
      );
      return;
    }

    if (!canExact && mounted) {
      NodeToastManager.show(
        context,
        title: 'Accuracy Limited',
        message:
            'Exact alarms are not permitted. Reminders may be delayed by the OS.',
        status: NodeToastStatus.warning,
      );
    }

    ref
        .read(recordsProvider.notifier)
        .updateReminder(
          widget.record.id,
          _selectedDate,
          isRecurring: _isRecurring,
          time:
              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
        );

    if (mounted) {
      Navigator.pop(context);

      NodeToastManager.show(
        context,
        title: 'Reminder Set',
        message: _selectedDate == null
            ? 'Notification removed.'
            : 'We will notify you${_isRecurring ? " daily" : ""} on ${DateFormat.yMMMMd().format(_selectedDate!)} at ${_formatTime(_selectedTime)}.',
        status: NodeToastStatus.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final detail = widget.record.detail;
    final accentColor = detail?.type == RecordType.credit
        ? appColors.marginGreen
        : appColors.moqOrange;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SET REMINDER',
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            // ── CONTEXT HEADER ──────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: accentColor.withOpacity(0.1),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: accentColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment from ${detail?.contactName ?? "this contact"}',
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Target: ${detail?.unit ?? "Units"} ${NumberFormat.decimalPattern().format(detail?.targetValue ?? 0)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),

            Text(
              'Frequency & Time',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 24.h),

            // ── FREQUENCY & TIME ──────────────────
            Row(
              children: [
                Expanded(
                  child: _OptionCard(
                    title: 'Daily Repeat',
                    subtitle: _isRecurring ? 'Every Day' : 'Once',
                    icon: _isRecurring
                        ? Icons.repeat_on_rounded
                        : Icons.repeat_rounded,
                    isSelected: _isRecurring,
                    onTap: () => setState(() {
                      _isRecurring = !_isRecurring;
                      if (_isRecurring) {
                        _selectedDate = DateTime.now(); // Starts today if daily
                      }
                    }),
                    accentColor: accentColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _OptionCard(
                    title: 'Set Time',
                    subtitle: _formatTime(_selectedTime),
                    icon: Icons.access_time_rounded,
                    isSelected: false,
                    onTap: _pickCustomTime,
                    accentColor: accentColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),

            if (!_isRecurring) ...[
              Text(
                'Select a date',
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 24.h),

              // ── PRESETS GRID ──────────────────
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.5,
                children: [
                  _PresetCard(
                    title: 'Tomorrow',
                    subtitle: DateFormat(
                      'MMM d',
                    ).format(DateTime.now().add(const Duration(days: 1))),
                    icon: Icons.today_rounded,
                    isSelected:
                        _selectedDate?.day ==
                        DateTime.now().add(const Duration(days: 1)).day,
                    onTap: () => _onPresetSelected(1),
                    accentColor: accentColor,
                  ),
                  _PresetCard(
                    title: 'In 3 Days',
                    subtitle: DateFormat(
                      'MMM d',
                    ).format(DateTime.now().add(const Duration(days: 3))),
                    icon: Icons.event_note_rounded,
                    isSelected:
                        _selectedDate?.day ==
                        DateTime.now().add(const Duration(days: 3)).day,
                    onTap: () => _onPresetSelected(3),
                    accentColor: accentColor,
                  ),
                  _PresetCard(
                    title: 'Next Week',
                    subtitle: DateFormat(
                      'MMM d',
                    ).format(DateTime.now().add(const Duration(days: 7))),
                    icon: Icons.next_week_rounded,
                    isSelected:
                        _selectedDate?.day ==
                        DateTime.now().add(const Duration(days: 7)).day,
                    onTap: () => _onPresetSelected(7),
                    accentColor: accentColor,
                  ),
                  _PresetCard(
                    title: 'Custom',
                    subtitle: _selectedDate == null
                        ? 'Pick a date'
                        : DateFormat('MMM d').format(_selectedDate!),
                    icon: Icons.calendar_today_rounded,
                    isSelected:
                        _selectedDate != null &&
                        ![1, 3, 7].contains(
                          _selectedDate!.difference(DateTime.now()).inDays + 1,
                        ),
                    onTap: _pickCustomDate,
                    accentColor: accentColor,
                  ),
                ],
              ),
            ] else ...[
              // Information when daily repeat is on
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: accentColor.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: accentColor,
                      size: 20.w,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        'Daily reminders will repeat every day starting from today.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 48.h),

            // ── ACTION BUTTONS ──────────────────
            if (_selectedDate != null) ...[
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _selectedDate = null),
                  child: Text(
                    'CLEAR REMINDER',
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],

            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              child: Text(
                _selectedDate == null ? 'REMOVE REMINDER' : 'CONFIRM REMINDER',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const _OptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor
              : theme.colorScheme.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? accentColor
                : theme.colorScheme.onSurface.withOpacity(0.05),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : accentColor,
              size: 24.w,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.black : theme.colorScheme.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.black.withOpacity(0.6)
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const _PresetCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor
              : theme.colorScheme.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? accentColor
                : theme.colorScheme.onSurface.withOpacity(0.05),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : accentColor,
              size: 24.w,
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.black : theme.colorScheme.onSurface,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.black.withOpacity(0.6)
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
