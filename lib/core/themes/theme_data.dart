import 'package:flutter/material.dart';

import '../../utils/responsive_size.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50); // Main app themes color
  static const Color secondary = Color(0xFFFF9800); // Accent color
  static const Color background = Color(0xFFF9F9F9); // App background color
  static const Color card = Color(0xFFFFFFFF); // Card and container background
  static const Color textPrimary = Color(0xFF212121); // Main text color
  static const Color textSecondary = Color(0xFF757575); // Subtle text color
  static const Color danger = Color(0xFFF44336); // Error or danger color
}

class ResponsiveTheme {
  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      // Primary app colors
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.card,
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.background,

      // AppBar themes
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: responsiveSize(context,
            mobileSize: 2, tabletSize: 4, desktopSize: 6),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: responsiveSize(context,
              mobileSize: 20, tabletSize: 22, desktopSize: 24),
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card styling
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: responsiveSize(context,
            mobileSize: 3, tabletSize: 4, desktopSize: 5),
        margin: EdgeInsets.all(responsiveSize(context,
            mobileSize: 8, tabletSize: 12, desktopSize: 16)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
        ),
      ),

      // FloatingActionButton themes
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: responsiveSize(context,
            mobileSize: 4, tabletSize: 6, desktopSize: 8),
      ),

      // Elevated button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: responsiveSize(context,
                mobileSize: 16, tabletSize: 18, desktopSize: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveSize(context,
                mobileSize: 8, tabletSize: 10, desktopSize: 12)),
          ),
        ),
      ),

      // TextButton themes
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: responsiveSize(context,
                mobileSize: 14, tabletSize: 16, desktopSize: 18),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: responsiveSize(context,
                mobileSize: 16, tabletSize: 18, desktopSize: 20),
            vertical: responsiveSize(context,
                mobileSize: 8, tabletSize: 10, desktopSize: 12),
          ),
        ),
      ),

      // Text themes with dynamic scaling
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: responsiveSize(context,
              mobileSize: 24, tabletSize: 28, desktopSize: 32),
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: responsiveSize(context,
              mobileSize: 18, tabletSize: 22, desktopSize: 26),
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: responsiveSize(context,
              mobileSize: 16, tabletSize: 18, desktopSize: 20),
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: responsiveSize(context,
              mobileSize: 16, tabletSize: 18, desktopSize: 20),
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: responsiveSize(context,
              mobileSize: 14, tabletSize: 16, desktopSize: 18),
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: responsiveSize(context,
              mobileSize: 12, tabletSize: 14, desktopSize: 16),
        ),
      ),

      // Input field styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
          borderSide: BorderSide(color: AppColors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
          borderSide: BorderSide(color: AppColors.danger),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: responsiveSize(context,
              mobileSize: 16, tabletSize: 18, desktopSize: 20),
          vertical: responsiveSize(context,
              mobileSize: 12, tabletSize: 14, desktopSize: 16),
        ),
        hintStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: responsiveSize(context,
              mobileSize: 14, tabletSize: 16, desktopSize: 18),
        ),
        labelStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: responsiveSize(context,
              mobileSize: 14, tabletSize: 16, desktopSize: 18),
        ),
      ),
    );
  }
}
