import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/node_instagram_app_bar.dart';
import 'models/notification_model.dart';
import 'widgets/notification_card.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Restock Alert (AI-Driven)',
      description: 'You usually buy nets every 20 days. You are running low. Tap to restock at current prices.',
      time: '1m ago',
      category: NotificationCategory.inventory,
      isUnread: true,
    ),
    NotificationItem(
      title: 'Bulk Discount! Price Drop',
      description: 'Bulk Discount! Price for Treated Nets dropped to 21,500 UGX for orders over 200 units.',
      time: '15m ago',
      category: NotificationCategory.finance,
      isUnread: true,
    ),
    NotificationItem(
      title: 'New Container Arrived',
      description: 'Professional Chinese Travel Bags now available at the Kampala Hub.',
      time: '1h ago',
      category: NotificationCategory.logistics,
    ),
    NotificationItem(
      title: 'Security Alert',
      description: 'Your NODE account was accessed from a new device in Jinja. If this wasn\'t you, lock your wallet now.',
      time: '3h ago',
      category: NotificationCategory.security,
      isUnread: true,
    ),
    NotificationItem(
      title: 'EFRIS Receipt Ready',
      description: 'Your official URA EFRIS Tax Invoice for Order #1024 is ready for download.',
      time: '5h ago',
      category: NotificationCategory.finance,
    ),
    NotificationItem(
      title: 'Offline Sync Success',
      description: '3 orders placed while offline have been successfully synced to the National Exchange.',
      time: '8h ago',
      category: NotificationCategory.system,
    ),
    NotificationItem(
      title: 'Payment Successful',
      description: 'Payment of 5,000,000 UGX for Order #882 received. Your balance is now 0 UGX.',
      time: '12h ago',
      category: NotificationCategory.finance,
    ),
    NotificationItem(
      title: 'On the Move!',
      description: 'Order #1024 has been dispatched from the Hub and is expected in 4 hours.',
      time: '1d ago',
      category: NotificationCategory.logistics,
    ),
    NotificationItem(
      title: 'New Message',
      description: 'Node Supply Group replied to your inquiry regarding custom branding.',
      time: '1d ago',
      category: NotificationCategory.orders,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    final filteredNotifications = _selectedCategory == NotificationCategory.all
        ? _notifications
        : _notifications.where((n) => n.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // ── Sticky Header ──────────────────────────────────────────────
          NodeAppBar(
            title: 'Notifications',
            onBack: () => context.pop(),
            actions: [
              TextButton(
                onPressed: () {},
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
              physics: BouncingScrollPhysics(),
              child: Row(
                children: NotificationCategory.values.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
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
                          category.name.substring(0, 1).toUpperCase() + category.name.substring(1),
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final notification = filteredNotifications[index];
                  return NotificationCard(notification: notification);
                },
                childCount: filteredNotifications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
