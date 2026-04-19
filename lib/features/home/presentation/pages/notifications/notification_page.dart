import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/node_instagram_app_bar.dart';
import 'models/notification_model.dart';
import 'widgets/notification_card.dart';
import 'presentation/providers/notification_providers.dart';
import 'package:node_app/core/utils/responsive_size.dart';

import 'widgets/notification_skeleton.dart';

import 'package:node_app/core/widgets/node_error_state.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final notificationsState = ref.watch(notificationListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: notificationsState.when(
        loading: () => ListView.separated(
          padding: EdgeInsets.only(top: 80.h), // Offset for AppBar
          itemCount: 8,
          separatorBuilder: (context, index) => Divider(
            height: 1.h,
            thickness: 1,
            indent: 84,
            color: onSurface.withOpacity(0.05),
          ),
          itemBuilder: (context, index) => const NotificationSkeleton(),
        ),
        error: (error, stack) => NodeErrorState(
          error: error,
          onRetry: () =>
              ref.read(notificationListProvider.notifier).fetchNotifications(),
        ),
        data: (notifications) {
          final filteredNotifications =
              _selectedCategory == NotificationCategory.all
              ? notifications
              : notifications
                    .where((n) => n.category == _selectedCategory)
                    .toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Sticky Header ──────────────────────────────────────────────
              NodeAppBar(
                title: 'Notifications',
                onBack: () => context.pop(),
                actions: [
                  TextButton(
                    onPressed: () => ref
                        .read(notificationListProvider.notifier)
                        .markAllAsRead(),
                    child: Text(
                      'Mark all read',
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),

              // ── Category Filters ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 4.h,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: NotificationCategory.values.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.primaryColor
                                  : onSurface.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(100.r),
                              border: Border.all(
                                color: isSelected
                                    ? theme.primaryColor.withOpacity(0.2)
                                    : Colors.transparent,
                                width: 0.5.w,
                              ),
                            ),
                            child: Text(
                              category.name.substring(0, 1).toUpperCase() +
                                  category.name.substring(1),
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : onSurface.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // ── Notification List ──────────────────────────────────────────
              if (filteredNotifications.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 48.w,
                          color: onSurface.withOpacity(0.2),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No notifications in this category',
                          style: GoogleFonts.outfit(
                            color: onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final notification = filteredNotifications[index];
                      return GestureDetector(
                        onTap: () => ref
                            .read(notificationListProvider.notifier)
                            .markAsRead(notification.id),
                        child: NotificationCard(notification: notification),
                      );
                    }, childCount: filteredNotifications.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
