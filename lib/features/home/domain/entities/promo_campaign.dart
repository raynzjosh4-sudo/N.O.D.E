class PromoCampaign {
  final String id;
  final String title;
  final String subtitle;
  final String actionText;
  final String imageUrl;
  final bool isLocal;

  const PromoCampaign({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.actionText = '',
    required this.imageUrl,
    this.isLocal = false,
  });

  // Dummy local data to establish the UI structure before backend integration
  static const List<PromoCampaign> dummyCampaigns = [
    PromoCampaign(
      id: 'promo_1',
      title: 'WINTER',
      subtitle: 'GET UP TO\n50% OFF',
      actionText: 'SHOP\nNOW',
      imageUrl: 'assets/welcomeimages/1 (1).jpg',
      isLocal: true,
    ),
    PromoCampaign(
      id: 'promo_2',
      title: 'PUREWHITE\nESSENTIALS',
      imageUrl: 'assets/welcomeimages/1 (4).jpg',
      isLocal: true,
    ),
    PromoCampaign(
      id: 'promo_3',
      title: '9+',
      imageUrl: 'assets/welcomeimages/26ABTest_Fashion_THUMBNAILS_300x300.png',
      isLocal: true,
    ),
  ];
}
