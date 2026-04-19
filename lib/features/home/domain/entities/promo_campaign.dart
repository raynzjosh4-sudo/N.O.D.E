class PromoCampaign {
  final String id;
  final String title;
  final String subtitle;
  final String actionText;
  final List<String> imageUrls;
  final bool isLocal;
  final int priority;
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? expiresAt;

  const PromoCampaign({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.actionText = '',
    required this.imageUrls,
    this.isLocal = false,
    this.priority = 0,
    this.isActive = true,
    this.startsAt,
    this.expiresAt,
  });

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';
}
