import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color nodePurple;
  final Color warmBackground;
  final Color enterpriseBlue;
  final Color marginGreen;
  final Color moqOrange;
  final Color accentCyan;
  final Color deepNavy;
  final Color borderLight;
  final Color surfaceWhite;
  final Color errorRed;

  AppColors({
    required this.nodePurple,
    required this.warmBackground,
    required this.enterpriseBlue,
    required this.marginGreen,
    required this.moqOrange,
    required this.accentCyan,
    required this.deepNavy,
    required this.borderLight,
    required this.surfaceWhite,
    required this.errorRed,
  });

  @override
  AppColors copyWith({
    Color? nodePurple,
    Color? warmBackground,
    Color? enterpriseBlue,
    Color? marginGreen,
    Color? moqOrange,
    Color? accentCyan,
    Color? deepNavy,
    Color? borderLight,
    Color? surfaceWhite,
    Color? errorRed,
  }) {
    return AppColors(
      nodePurple: nodePurple ?? this.nodePurple,
      warmBackground: warmBackground ?? this.warmBackground,
      enterpriseBlue: enterpriseBlue ?? this.enterpriseBlue,
      marginGreen: marginGreen ?? this.marginGreen,
      moqOrange: moqOrange ?? this.moqOrange,
      accentCyan: accentCyan ?? this.accentCyan,
      deepNavy: deepNavy ?? this.deepNavy,
      borderLight: borderLight ?? this.borderLight,
      surfaceWhite: surfaceWhite ?? this.surfaceWhite,
      errorRed: errorRed ?? this.errorRed,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      nodePurple: Color.lerp(nodePurple, other.nodePurple, t)!,
      warmBackground: Color.lerp(warmBackground, other.warmBackground, t)!,
      enterpriseBlue: Color.lerp(enterpriseBlue, other.enterpriseBlue, t)!,
      marginGreen: Color.lerp(marginGreen, other.marginGreen, t)!,
      moqOrange: Color.lerp(moqOrange, other.moqOrange, t)!,
      accentCyan: Color.lerp(accentCyan, other.accentCyan, t)!,
      deepNavy: Color.lerp(deepNavy, other.deepNavy, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      surfaceWhite: Color.lerp(surfaceWhite, other.surfaceWhite, t)!,
      errorRed: Color.lerp(errorRed, other.errorRed, t)!,
    );
  }

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;
}

class AppTheme {
  // Base Colors - NODE BRAND
  static const Color nodePurple = Color(0xFF9C27B0);
  static const Color warmBackground = Color(0xFFF9F6F2);

  // Enterprise Legacy Colors
  static Color primaryBlue = const Color(0xFF12BBF0); // nodeicon cyan
  static Color accentCyan = const Color(0xFF00B8D9);
  static Color marginGreen = const Color(0xFF36B37E);
  static Color moqOrange = const Color(0xFFFFAB00);
  static Color deepNavy = const Color(0xFF172B4D);
  static Color surfaceWhite = const Color(0xFFFFFFFF);
  static Color errorRed = const Color(0xFFDE350B);
  static Color borderLight = const Color(0xFFDFE1E6);

  static AppColors get lightColors => AppColors(
    nodePurple: nodePurple,
    warmBackground: warmBackground,
    enterpriseBlue: primaryBlue,
    marginGreen: marginGreen,
    moqOrange: moqOrange,
    accentCyan: accentCyan,
    deepNavy: deepNavy,
    borderLight: borderLight,
    surfaceWhite: surfaceWhite,
    errorRed: errorRed,
  );

  static AppColors get darkColors => AppColors(
    nodePurple: const Color(0xFFCE93D8),
    warmBackground: const Color(0xFF1C1C21),
    enterpriseBlue: primaryBlue, // Follow the new cyan nodeicon for dark mode as well
    marginGreen: const Color(0xFF4ade80),
    moqOrange: const Color(0xFFfbbf24),
    accentCyan: const Color(0xFF00C7E6),
    deepNavy: Colors.white,
    borderLight: const Color(0xFF2D2E33),
    surfaceWhite: const Color(0xFF1C1C21),
    errorRed: const Color(0xFFff5722),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Comic Relief',
      extensions: [lightColors],
      primaryColor: primaryBlue,
      cardColor: Colors.white,
      dividerColor: Color(0xFFDFE1E6),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentCyan,
        surface: Colors.white,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: deepNavy,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: deepNavy,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: deepNavy,
        ),
        bodyMedium: TextStyle(fontSize: 16.sp, color: Color(0xFF42526E)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Comic Relief',
          color: deepNavy,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: deepNavy),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide.none,
        ),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final lightPrimaryBlue = primaryBlue; // Use the same vibrant nodeicon color
    const darkSurface = Color(0xFF1C1C21);
    const darkScaffold = Color(0xFF0E0E12);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Comic Relief',
      extensions: [darkColors],
      primaryColor: lightPrimaryBlue,
      cardColor: darkSurface,
      dividerColor: Color(0xFF2D2E33),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: lightPrimaryBlue,
        secondary: Color(0xFF00C7E6),
        surface: darkSurface,
        onSurface: Colors.white,
        error: Color(0xFFff5722),
      ),
      scaffoldBackgroundColor: darkScaffold,
      textTheme: TextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
