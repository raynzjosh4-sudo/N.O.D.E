import 'package:flutter/material.dart';

class ColorVariant {
  final String label;
  final Color color;
  const ColorVariant({required this.label, required this.color});
}

class ColorGroup {
  final ColorVariant color;
  final Map<String, int> sizeQtys; // e.g. {'Small': 5, 'Medium': 3}
  ColorGroup({required this.color, required this.sizeQtys});
}
