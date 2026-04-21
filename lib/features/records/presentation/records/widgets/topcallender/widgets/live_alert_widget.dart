import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/presentation/providers/alert_provider.dart';
import 'package:node_app/features/records/presentation/records/pages/record_detail_page.dart';
import 'dart:async';

class LiveAlertWidget extends ConsumerStatefulWidget {
  const LiveAlertWidget({super.key});

  @override
  ConsumerState<LiveAlertWidget> createState() => _LiveAlertWidgetState();
}

class _LiveAlertWidgetState extends ConsumerState<LiveAlertWidget> {
  late Timer _timer;
  String _timeRemaining = '20:00';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final alert = ref.read(alertProvider);
      if (alert.triggeredAt == null) return;

      final diff = DateTime.now().difference(alert.triggeredAt!);
      final remaining = const Duration(minutes: 20) - diff;

      if (remaining.isNegative) {
        ref.read(alertProvider.notifier).clearAlert();
        _timer.cancel();
      } else {
        setState(() {
          final mins = remaining.inMinutes;
          final secs = remaining.inSeconds % 60;
          _timeRemaining =
              '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alert = ref.watch(alertProvider);
    final record = alert.activeRecord;
    if (record == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    const goldColor = Color(0xFFFFB800);

    return GestureDetector(
      onTap: () => RecordDetailPage.show(context, record: record),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: goldColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: goldColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: Colors.black,
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'LIVE ALERT',
                          style: GoogleFonts.outfit(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withOpacity(0.6),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _timeRemaining,
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    record.detail?.contactName ?? 'Record',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.black.withOpacity(0.3),
              size: 28.w,
            ),
          ],
        ),
      ),
    );
  }
}
