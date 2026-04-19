import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/notification_model.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    String _getTimeAgo(DateTime dateTime) {
      final difference = DateTime.now().difference(dateTime);
      if (difference.inSeconds < 60) return '${difference.inSeconds}s ago';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    IconData getIcon() {
      switch (notification.category) {
        case NotificationCategory.orders:
          return Icons.shopping_bag_rounded;
        case NotificationCategory.inventory:
          return Icons.inventory_2_rounded;
        case NotificationCategory.logistics:
          return Icons.local_shipping_rounded;
        case NotificationCategory.security:
          return Icons.security_rounded;
        case NotificationCategory.finance:
          return Icons.account_balance_wallet_rounded;
        case NotificationCategory.system:
          return Icons.sync_rounded;
        case NotificationCategory.ai:
          return Icons.auto_awesome_rounded;
        case NotificationCategory.messages:
          return Icons.shopping_bag_rounded; // Matches the bag icon in the ref
        default:
          return Icons.notifications_none_rounded;
      }
    }

    Color getIconColor() {
      switch (notification.category) {
        case NotificationCategory.orders:
          return const Color(0xFF2196F3); // Blue
        case NotificationCategory.inventory:
          return const Color(0xFFFF9800); // Orange
        case NotificationCategory.logistics:
          return const Color(0xFF9C27B0); // Purple
        case NotificationCategory.security:
          return const Color(0xFFF44336); // Red
        case NotificationCategory.finance:
          return const Color(0xFF10B981); // Emerald/Teal
        case NotificationCategory.system:
          return const Color(0xFF00BCD4); // Cyan
        case NotificationCategory.ai:
          return const Color(0xFF00E5FF); // Bright AI Cyan
        case NotificationCategory.messages:
          return const Color(0xFF2196F3); // Blue
        default:
          return theme.primaryColor;
      }
    }

    return Container(
      color: notification.isUnread
          ? theme.primaryColor.withOpacity(0.05)
          : Colors.transparent,
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
                    image: notification.imageUrl != null 
                        ? DecorationImage(
                            image: NetworkImage(notification.imageUrl!),
                            fit: BoxFit.cover,
                          ) 
                        : null,
                  ),
                  child: notification.imageUrl == null ? Center(
                    child: Icon(getIcon(), color: getIconColor(), size: 22.w),
                  ) : null,
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
                            _getTimeAgo(notification.time),
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
                      if (notification.description != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          notification.description!,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: onSurface.withOpacity(0.6),
                            height: 1.4.h,
                          ),
                        ),
                      ],
                      if (notification.priceTierChanges != null) ...[
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: getIconColor().withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: getIconColor().withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_down_rounded,
                                    size: 14.w,
                                    color: getIconColor(),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Bulk Discount Updates',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                      color: getIconColor(),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              ...notification.priceTierChanges!.map((tier) => Padding(
                                    padding: EdgeInsets.only(bottom: 6.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: getIconColor().withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Text(
                                            '${tier.minQuantity}+ units',
                                            style: GoogleFonts.outfit(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                              color: getIconColor(),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'UGX ${NumberFormat('#,###').format(tier.oldPrice)}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 11.sp,
                                            color: onSurface.withOpacity(0.4),
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 12.w,
                                          color: onSurface.withOpacity(0.2),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'UGX ${NumberFormat('#,###').format(tier.newPrice)}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w900,
                                            color: onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
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
