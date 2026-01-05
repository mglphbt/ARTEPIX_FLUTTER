import 'package:flutter/material.dart';
import 'typography.dart';

class AppColors {
  // Primary Brand Colors (Lime Green)
  static const Color primary = Color(0xFFD4F844); // Lime Green
  static const Color primaryDark = Color(0xFFAACC00);
  
  // Secondary / Accent
  static const Color secondary = Color(0xFF13C8EC); // Cyan

  // Backgrounds
  static const Color backgroundDark = Color(0xFF101F22); // Darker Tealed/Black
  static const Color surfaceDark = Color(0xFF1C1E23);
  static const Color backgroundLight = Color(0xFFF6F8F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Glass Effects
  static const Color glassBorder = Colors.white12;
  static const Color glassSurface = Colors.white10;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        background: AppColors.backgroundLight,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
    );
  }
}
