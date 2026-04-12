import '../presentation/pages/categories/models/category_model.dart';

class CategoryDummyData {
  static final List<CategoryItem> topSearchedCategories = [
    CategoryItem(
      id: 'cat_fashion_footwear',
      name: 'Athletics',
      imageUrl:
          'assets/welcomeimages/26ABTest_Mens-Shoes_THUMBNAILS_300x300.png',
      itemCount: 15,
      subCategories: [
        CategoryItem(id: 'sub_perf', name: 'Performance', imageUrl: ''),
        CategoryItem(id: 'sub_lifestyle', name: 'Lifestyle', imageUrl: ''),
      ],
    ),
    CategoryItem(
      id: 'cat_electronics',
      name: 'Electronics',
      imageUrl:
          'assets/welcomeimages/26ABTest_Computing_THUMBNAILS_300x300.png',
      itemCount: 42,
      subCategories: [
        CategoryItem(id: 'sub_audio', name: 'Audio', imageUrl: ''),
        CategoryItem(id: 'sub_drones', name: 'Drones', imageUrl: ''),
      ],
    ),
    CategoryItem(
      id: 'cat_industrial',
      name: 'Industrial',
      imageUrl: 'assets/welcomeimages/1.jpg',
      itemCount: 28,
    ),
    CategoryItem(
      id: 'cat_home',
      name: 'Home & Living',
      imageUrl:
          'assets/welcomeimages/26ABTest_Jumia-Picks_THUMBNAILS_300x300.png',
      itemCount: 35,
    ),
    CategoryItem(
      id: 'cat_fashion',
      name: 'Fashion',
      imageUrl: 'assets/welcomeimages/26ABTest_Fashion_THUMBNAILS_300x300.png',
      itemCount: 20,
    ),
  ];
}
