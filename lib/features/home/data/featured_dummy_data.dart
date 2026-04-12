class FeaturedProduct {
  final String title;
  final String price;
  final String imageUrl;
  final String rating;
  final String reviews;

  FeaturedProduct({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });
}

class FeaturedDummyData {
  static List<FeaturedProduct> get featuredItems => [
        FeaturedProduct(
          title: 'Nike Air Max 270',
          price: '\$150.00',
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800&auto=format&fit=crop',
          rating: '4.9',
          reviews: '1.2k',
        ),
        FeaturedProduct(
          title: 'Puma RSVP-Z',
          price: '\$48.92',
          imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?q=80&w=800&auto=format&fit=crop',
          rating: '4.8',
          reviews: '289',
        ),
        FeaturedProduct(
          title: 'Adidas Ultraboost',
          price: '\$180.00',
          imageUrl: 'https://images.unsplash.com/photo-1587563871167-1ee9c731aefb?q=80&w=800&auto=format&fit=crop',
          rating: '4.7',
          reviews: '850',
        ),
      ];
}
