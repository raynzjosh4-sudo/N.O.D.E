enum NotificationCategory {
  all,
  orders,
  inventory,
  logistics,
  security,
  finance,
  system,
  ai,
  messages,
}

class NotificationItem {
  final String id;
  final String title;
  final String? description;
  final DateTime time;
  final NotificationCategory category;
  final bool isUnread;
  final Map<String, dynamic>? metadata;

  NotificationItem({
    required this.id,
    required this.title,
    this.description,
    required this.time,
    required this.category,
    this.isUnread = true,
    this.metadata,
  });

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      time: DateTime.parse(map['created_at'] as String),
      category: _parseCategory(map['category'] as String),
      isUnread: map['is_unread'] as bool? ?? true,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  List<PriceTierChange>? get priceTierChanges {
    if (metadata == null || metadata!['type'] != 'wholesale_price_drop') return null;
    final tiers = metadata!['tiers'] as List<dynamic>?;
    if (tiers == null) return null;
    return tiers.map((t) => PriceTierChange.fromMap(t as Map<String, dynamic>)).toList();
  }

  String? get imageUrl {
    if (metadata == null) return null;
    return metadata!['image_url'] as String?;
  }

  static NotificationCategory _parseCategory(String category) {
    return NotificationCategory.values.firstWhere(
      (c) => c.name == category.toLowerCase(),
      orElse: () => NotificationCategory.system,
    );
  }
}

class PriceTierChange {
  final int minQuantity;
  final double oldPrice;
  final double newPrice;

  PriceTierChange({
    required this.minQuantity,
    required this.oldPrice,
    required this.newPrice,
  });

  factory PriceTierChange.fromMap(Map<String, dynamic> map) {
    return PriceTierChange(
      minQuantity: map['minQuantity'] as int,
      oldPrice: (map['oldPrice'] as num).toDouble(),
      newPrice: (map['newPrice'] as num).toDouble(),
    );
  }
}
