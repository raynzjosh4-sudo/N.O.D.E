import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/theme/app_theme.dart';

// 🚨 Emergency flash colors — cycling like a police/alert light
const _kFlashColors = [
  Color(0xFF00BFFF), // Electric Blue
  Color(0xFFFF2222), // Siren Red
  Color(0xFFFFD700), // Amber Yellow
];

class CalendarDateCard extends StatefulWidget {
  final DateTime date;
  final bool isSelected;
  final bool hasNotification;
  final VoidCallback onTap;
  final Color? color;
  /// When true, the card flashes urgency colors like emergency lights.
  final bool isUrgent;

  const CalendarDateCard({
    super.key,
    required this.date,
    required this.isSelected,
    this.hasNotification = false,
    required this.onTap,
    this.color,
    this.isUrgent = false,
  });

  @override
  State<CalendarDateCard> createState() => _CalendarDateCardState();
}

class _CalendarDateCardState extends State<CalendarDateCard>
    with SingleTickerProviderStateMixin {
  Timer? _flashTimer;
  int _flashIndex = 0;
  bool _glowVisible = true;

  @override
  void initState() {
    super.initState();
    if (widget.isUrgent) _startFlashing();
  }

  @override
  void didUpdateWidget(CalendarDateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUrgent && !oldWidget.isUrgent) {
      _startFlashing();
    } else if (!widget.isUrgent && oldWidget.isUrgent) {
      _stopFlashing();
    }
  }

  void _startFlashing() {
    _flashTimer?.cancel();
    // Alternate color every 250ms — gives the rapid police-light effect
    _flashTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (mounted) {
        setState(() {
          _flashIndex = (_flashIndex + 1) % _kFlashColors.length;
          _glowVisible = !_glowVisible;
        });
      }
    });
  }

  void _stopFlashing() {
    _flashTimer?.cancel();
    _flashTimer = null;
  }

  @override
  void dispose() {
    _stopFlashing();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthName = DateFormat('MMM').format(widget.date).toUpperCase();
    final dayNumber = DateFormat('d').format(widget.date);

    // Urgent mode overrides the card color with the current flash color
    final activeColor = widget.isUrgent
        ? _kFlashColors[_flashIndex]
        : (widget.color ?? theme.colorScheme.primary);

    final bool showActive = widget.isSelected || widget.isUrgent;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: widget.isUrgent
            ? const Duration(milliseconds: 200)
            : const Duration(milliseconds: 300),
        width: 58.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: showActive ? activeColor : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            if (showActive)
              BoxShadow(
                color: activeColor.withOpacity(widget.isUrgent ? 0.7 : 0.3),
                blurRadius: widget.isUrgent ? 24 : 15,
                spreadRadius: widget.isUrgent ? 4 : 0,
                offset: const Offset(0, 6),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border.all(
            color: widget.isUrgent
                ? activeColor.withOpacity(0.9)
                : showActive
                    ? Colors.transparent
                    : theme.colorScheme.onSurface.withOpacity(0.05),
            width: widget.isUrgent ? 2.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isUrgent)
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: AnimatedOpacity(
                  opacity: _glowVisible ? 1.0 : 0.2,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '⚠',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ),
              ),
            Text(
              monthName,
              style: GoogleFonts.outfit(
                fontSize: 10.sp,
                fontWeight: showActive ? FontWeight.w800 : FontWeight.w600,
                color: showActive
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
            SizedBox(height: widget.isUrgent ? 4.h : 8.h),
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: showActive ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    dayNumber,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                      color: showActive ? Colors.black : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (widget.hasNotification)
                    Positioned(
                      bottom: 4.h,
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: showActive
                              ? Colors.black
                              : (widget.color ?? theme.colorScheme.primary),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
