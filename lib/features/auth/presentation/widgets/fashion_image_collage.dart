import 'package:flutter/material.dart';

class FashionImageCollage extends StatelessWidget {
  FashionImageCollage({super.key});

  static List<String> fashionImages = [
    'assets/welcomeimages/1.jpg',
    'assets/welcomeimages/1 (1).jpg',
    'assets/welcomeimages/1 (2).jpg',
    'assets/welcomeimages/1 (3).jpg',
    'assets/welcomeimages/1 (4).jpg',
    'assets/welcomeimages/1 (5).jpg',
    'assets/welcomeimages/26ABTest_Computing_THUMBNAILS_300x300.png',
    'assets/welcomeimages/26ABTest_Fashion_THUMBNAILS_300x300.png',
    'assets/welcomeimages/26ABTest_Jumia-Picks_THUMBNAILS_300x300.png',
    'assets/welcomeimages/26ABTest_Mens-Shoes_THUMBNAILS_300x300.png',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Split images into 3 lists for the columns
    final col1 = <String>[];
    final col2 = <String>[];
    final col3 = <String>[];

    for (var i = 0; i < fashionImages.length * 2; i++) {
        final img = fashionImages[i % fashionImages.length];
        if (i % 3 == 0) col1.add(img);
        else if (i % 3 == 1) col2.add(img);
        else col3.add(img);
    }

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: -screenWidth * 0.15,
            right: -screenWidth * 0.15,
            top: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColumn(col1, topPadding: 0),
                _buildColumn(col2, topPadding: 60),
                _buildColumn(col3, topPadding: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(List<String> images, {required double topPadding}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, left: 8, right: 8),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: images.map((path) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AspectRatio(
                aspectRatio: 0.62,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover, // Ensures the image fills the tall box uniformly without stretching
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
      ),
    );
  }
}
