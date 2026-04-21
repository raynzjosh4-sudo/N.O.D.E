import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import '../../../domain/types/record_types.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import '../widgets/record_activity_timeline.dart';
import '../widgets/record_data_breakdown.dart';
import '../widgets/record_management_sheet.dart';
import 'package:node_app/core/theme/app_theme.dart';

class RecordDetailPage extends ConsumerWidget {
  final MainRecordModel record;

  const RecordDetailPage({super.key, required this.record});

  static void show(BuildContext context, {required MainRecordModel record}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return RecordDetailPage(record: record);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.fastOutSlowIn;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final records = ref.watch(recordsProvider);
    final currentRecord = records.items.firstWhere(
      (r) => r.id == record.id,
      orElse: () => record,
    );
    final detail = currentRecord.detail;

    final accentColor = detail?.type == RecordType.credit
        ? appColors.marginGreen
        : detail?.type == RecordType.debt
        ? appColors.moqOrange
        : appColors.accentCyan;
    final currencyFormat = NumberFormat.compact();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── COMPACT HEADER ──────────────────
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              (detail?.itemName ?? 'Record').toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                color: accentColor,
                letterSpacing: 2,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () => RecordManagementSheet.show(context, currentRecord),
              ),
              SizedBox(width: 8.w),
            ],
          ),

          // ── DATA BREAKDOWN ──────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: RecordDataBreakdown(record: currentRecord, accentColor: accentColor),
            ),
          ),

          // ── HISTORY SECTION ──────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: RecordActivityTimeline(record: currentRecord),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Remove _TimelineEntry internally as it is now in its own file components

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 20.w),
            SizedBox(width: 12.w),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.h,
        height: 56.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(icon, size: 24.w),
      ),
    );
  }
}
