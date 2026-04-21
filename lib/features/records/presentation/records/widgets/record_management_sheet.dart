import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import '../pages/set_reminder_page.dart';
import '../pages/edit_record_page.dart';
import 'package:node_app/core/theme/app_theme.dart';
import '../../../domain/types/record_types.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordManagementSheet extends ConsumerWidget {
  final MainRecordModel record;

  const RecordManagementSheet({super.key, required this.record});

  static Future<void> show(BuildContext context, MainRecordModel record) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => RecordManagementSheet(record: record),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final detail = record.detail;
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
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),

          // Header
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(Icons.settings_outlined, color: accentColor),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Record',
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      detail?.itemName ?? 'No Item Name',
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
          SizedBox(height: 32.h),

          // Action List
          _ManagementTile(
            icon: Icons.edit_outlined,
            title: 'Edit Record Details',
            subtitle: 'Change contact or item name',
            onTap: () {
              Navigator.pop(context);
              EditRecordPage.show(context, record);
            },
          ),
          _ManagementTile(
            icon: Icons.notifications_active_outlined,
            title: 'Set Reminder',
            subtitle: 'Notify about pending balance',
            onTap: () {
              Navigator.pop(context);
              SetReminderPage.show(context, record);
            },
          ),
          _ManagementTile(
            icon: Icons.archive_outlined,
            title: 'Archive Record',
            subtitle: 'Move to completed section',
            onTap: () {
              ref.read(recordsProvider.notifier).archiveRecord(record.id);
              Navigator.pop(context);
              NodeToastManager.show(
                context,
                title: 'Record Archived',
                message: 'Moved to your completed records section.',
                status: NodeToastStatus.success,
              );
            },
          ),
          Divider(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
            height: 32.h,
          ),
          _ManagementTile(
            icon: Icons.delete_outline_rounded,
            title: 'Delete Permanently',
            subtitle: 'This action cannot be undone',
            color: appColors.errorRed,
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Theme.of(ctx).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    'Delete Record?',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
                  ),
                  content: Text(
                    'This will permanently remove "${record.detail?.itemName ?? 'this record'}" and all its history. This cannot be undone.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.outfit(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(recordsProvider.notifier)
                            .deleteRecord(record.id);
                        Navigator.pop(ctx);
                        NodeToastManager.show(
                          context,
                          title: 'Record Deleted',
                          message:
                              '"${record.detail?.itemName ?? 'Record'}" has been permanently removed.',
                          status: NodeToastStatus.error,
                        );
                      },
                      child: Text(
                        'Delete',
                        style: GoogleFonts.outfit(
                          color: appColors.errorRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ManagementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _ManagementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayColor = color ?? theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Row(
          children: [
            Icon(icon, color: displayColor.withOpacity(0.7), size: 24.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: displayColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }
}
