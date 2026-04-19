import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double widthMultiplier;
  static late double heightMultiplier;

  // Baseline dimensions (e.g., standard Android/iPhone size)
  static const double _designWidth = 360.0;
  static const double _designHeight = 800.0;

  static void init(BuildContext context, {double userScaleFactor = 1.0}) {
    if (context.mounted) {
      final Size size = MediaQuery.of(context).size;
      screenWidth = size.width == 0 ? _designWidth : size.width;
      screenHeight = size.height == 0 ? _designHeight : size.height;

      double rawWidthMultiplier = (screenWidth / _designWidth) * userScaleFactor;
      // Clamp the width multiplier so fonts and paddings don't become massive on desktop monitors natively
      widthMultiplier = rawWidthMultiplier > 1.5 ? 1.5 : rawWidthMultiplier;

      // Calculate true height multiplier based on actual height
      double rawHeightMultiplier = (screenHeight / _designHeight);

      // Clamp height multiplier so it never compresses vertically much more than horizontally
      heightMultiplier =
          (rawHeightMultiplier < (widthMultiplier * 0.85)
              ? (widthMultiplier * 0.85)
              : rawHeightMultiplier) *
          userScaleFactor;
    }
  }
}

extension ResponsiveSize on num {
  /// Scales the dimension proportionally to the screen width.
  /// Use this for horizontal dimensions: width, padding right/left, margins.
  double get w {
    try {
      return this * SizeConfig.widthMultiplier;
    } catch (e) {
      // Fallback if accessed before init
      return toDouble();
    }
  }

  /// Scales the dimension proportionally to the screen height.
  double get h {
    try {
      return this * SizeConfig.heightMultiplier;
    } catch (e) {
      // Fallback if accessed before init
      return toDouble();
    }
  }

  /// Scales font sizes based on a balanced multiplier (width is usually safer for text)
  double get sp {
    try {
      return this * SizeConfig.widthMultiplier;
    } catch (e) {
      return toDouble();
    }
  }

  /// Scales the radius based on width multiplier.
  double get r {
    try {
      return this * SizeConfig.widthMultiplier;
    } catch (e) {
      return toDouble();
    }
  }
}
