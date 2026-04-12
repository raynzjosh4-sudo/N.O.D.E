import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/notification_model.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    IconData getIcon() {
      switch (notification.category) {
        case NotificationCategory.orders:
          return Icons.shopping_bag_outlined;
        case NotificationCategory.inventory:
          return Icons.inventory_2_outlined;
        case NotificationCategory.logistics:
          return Icons.local_shipping_outlined;
        case NotificationCategory.security:
          return Icons.security_rounded;
        case NotificationCategory.finance:
          return Icons.account_balance_wallet_outlined;
        case NotificationCategory.system:
          return Icons.sync_rounded;
        default:
          return Icons.notifications_none_rounded;
      }
    }

    Color getIconColor() {
      switch (notification.category) {
        case NotificationCategory.orders:
          return Colors.blue;
        case NotificationCategory.inventory:
          return Colors.orange;
        case NotificationCategory.logistics:
          return Colors.purple;
        case NotificationCategory.security:
          return Colors.redAccent;
        case NotificationCategory.finance:
          return Colors.teal;
        case NotificationCategory.system:
          return Colors.cyan;
        default:
          return theme.primaryColor;
      }
    }

    return Container(
      color: notification.isUnread ? theme.primaryColor.withOpacity(0.05) : Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: getIconColor().withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(getIcon(), color: getIconColor(), size: 22.w),
                  ),
                ),
                SizedBox(width: 16.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            notification.time,
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: onSurface.withOpacity(0.4),
                            ),
                          ),
                          if (notification.isUnread) ...[
                            SizedBox(width: 8.w),
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.primaryColor.withOpacity(0.4),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.description,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: onSurface.withOpacity(0.6),
                          height: 1.4.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.h,
            thickness: 1,
            indent: 84, // Align with text content
            color: onSurface.withOpacity(0.05),
          ),
        ],
      ),
    );
  }
}
