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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final notificationsState = ref.watch(notificationListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 200) {
            ref.read(notificationListProvider.notifier).loadMore();
          }
          return false;
        },
        child: CustomScrollView(
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
                    final isSelected = notificationsState.category == category;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () => ref
                            .read(notificationListProvider.notifier)
                            .changeCategory(category),
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
            if (notificationsState.items.isEmpty && notificationsState.isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const NotificationSkeleton(),
                  childCount: 8,
                ),
              )
            else if (notificationsState.items.isEmpty)
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index >= notificationsState.items.length) {
                      return const NotificationSkeleton();
                    }

                    final notification = notificationsState.items[index];
                    return Dismissible(
                      key: Key('notification_${notification.id}'),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        ref
                            .read(notificationListProvider.notifier)
                            .deleteNotification(notification.id);
                      },
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.8),
                        ),
                        child: Icon(
                          Icons.delete_sweep_rounded,
                          color: Colors.white,
                          size: 28.w,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => ref
                            .read(notificationListProvider.notifier)
                            .markAsRead(notification.id),
                        child: NotificationCard(notification: notification),
                      ),
                    );
                  }, childCount: notificationsState.items.length + (notificationsState.hasMore ? 1 : 0)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
