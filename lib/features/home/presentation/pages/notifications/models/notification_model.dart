enum NotificationCategory {
  all,
  orders,
  inventory,
  logistics,
  security,
  finance,
  system,
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final NotificationCategory category;
  final bool isUnread;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    this.isUnread = false,
  });
}
