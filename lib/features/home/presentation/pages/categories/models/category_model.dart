class CategoryItem {
  final String id;
  final String name;
  final String imageUrl;
  final int itemCount;
  final List<CategoryItem> subCategories;

  CategoryItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.itemCount = 0,
    this.subCategories = const [],
  });
}
