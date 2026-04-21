import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/presentation/providers/alert_provider.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';

import '../widgets/record_card.dart';
import '../widgets/add_record_sheet.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/topcallender/top_calendar.dart';

class RecordsTab extends ConsumerStatefulWidget {
  const RecordsTab({super.key});

  @override
  ConsumerState<RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends ConsumerState<RecordsTab> {
  bool _isSearchActive = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 📦 DRAGGABLE RECORDS SHEET
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        final recordsState = ref.watch(recordsProvider);
        final records = recordsState.items;

        // 🔍 FILTERING LOGIC
        final filteredRecords = records.where((r) {
          if (_searchQuery.isEmpty) return true;
          final searchLower = _searchQuery.toLowerCase();
          final contactName = r.detail?.contactName?.toLowerCase() ?? '';
          final itemName = r.detail?.itemName?.toLowerCase() ?? '';
          return contactName.contains(searchLower) ||
              itemName.contains(searchLower);
        }).toList();

        final activeRecords = filteredRecords
            .where((r) => !r.isArchived)
            .toList();
        final archivedRecords = filteredRecords
            .where((r) => r.isArchived)
            .toList();

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                ref.read(recordsProvider.notifier).loadMore();
              }
              return false;
            },
            child: CustomScrollView(
              controller: scrollController,
            slivers: [
              // Handle
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),

              const TopCalendar(),

              // 🏷️ SECTION HEADER (WITH SEARCH)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isSearchActive
                        ? Row(
                            key: const ValueKey('search_active'),
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    autofocus: true,
                                    onChanged: (value) {
                                      setState(() => _searchQuery = value);
                                    },
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Search records...',
                                      hintStyle: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.3),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        size: 18.w,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.3),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSearchActive = false;
                                    _searchQuery = '';
                                    _searchController.clear();
                                  });
                                },
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey('header_normal'),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ACTIVE RECORDS',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${activeRecords.length} Items',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.sp,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => _isSearchActive = true);
                                    },
                                    child: Icon(
                                      Icons.search_rounded,
                                      size: 18.w,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              // 📦 ACTIVE RECORDS LIST
              SliverPadding(
                padding: EdgeInsets.zero,
                sliver: activeRecords.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  size: 48.w,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.05),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'No active records'
                                      : 'No matching records found',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final record = activeRecords[index];
                          return RecordCard(
                            record: record,
                            onTap: () => _showOptions(context, ref, record),
                            onPaymentTap: () =>
                                AddRecordSheet.show(context, record: record),
                          );
                        }, childCount: activeRecords.length),
                      ),
              ),

              // 🏷️ COMPLETED SECTION HEADER
              if (archivedRecords.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'COMPLETED RECORDS',
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          '${archivedRecords.length} Archived',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final record = archivedRecords[index];
                    return Opacity(
                      opacity: 0.5,
                      child: RecordCard(
                        record: record,
                        onTap: () => _showOptions(context, ref, record),
                        onPaymentTap: () {}, // No payment on archived
                      ),
                    );
                  }, childCount: archivedRecords.length),
                ),
              ],

              if (recordsState.isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ),
      );
    },
  );
}

  void _showOptions(
    BuildContext context,
    WidgetRef ref,
    MainRecordModel record,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              record.detail?.contactName ?? 'Record Options',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 24.h),
            _buildOption(
              context,
              icon: Icons.payments_outlined,
              title: 'Record a Payment',
              subtitle: 'Subtract from the balance',
              onTap: () {
                Navigator.pop(context);
                PaymentDialog.show(context, record);
              },
            ),
            _buildOption(
              context,
              icon: Icons.notification_add_outlined,
              title: record.isArchived ? 'Restore Record' : 'Archive Record',
              subtitle: record.isArchived
                  ? 'Move back to active section'
                  : 'Move to completed section',
              onTap: () {
                if (record.isArchived) {
                  ref.read(recordsProvider.notifier).unarchiveRecord(record.id);
                } else {
                  ref.read(recordsProvider.notifier).archiveRecord(record.id);
                }
                Navigator.pop(context);
              },
            ),
            _buildOption(
              context,
              icon: Icons.bolt_rounded,
              title: 'Trigger Live Alert',
              subtitle: 'Test the 20-min notification bar',
              onTap: () {
                ref.read(alertProvider.notifier).triggerAlert(record);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
