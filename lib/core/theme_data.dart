// app_colors.dart
import 'package:flutter/material.dart';

import '../utils/responsive_size.dart';

// app_colors.dart
class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF4CAF50);       // Main primary color
  static const Color lightSecondary = Color(0xFFFF9800);     // Accent color
  static const Color lightBackground = Color(0xFFF9F9F9);    // Background color
  static const Color lightCard = Color(0xFFFFFFFF);          // Card background
  static const Color lightTextPrimary = Color(0xFF212121);   // Primary text color
  static const Color lightTextSecondary = Color(0xFF757575); // Secondary text color
  static const Color lightError = Color(0xFFF44336);         // Error color

  // Dark Theme Colors (if needed)
  static const Color darkPrimary = Color(0xFF81C784);
  static const Color darkSecondary = Color(0xFFFFB74D);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkError = Color(0xFFCF6679);

  // Additional Colors for Specific Uses
  static const Color primaryColor = lightPrimary;          // Used for buttons and general elements
  static const Color importantStar = Color(0xFFFFD700);      // Gold color for important star icon
  static const Color errorRed = lightError;                  // Error red color for error messages
}


// responsive_theme.dart

class ResponsiveTheme {
  static ThemeData getLightTheme(BuildContext context) {
    return _buildTheme(
      context,
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      background: AppColors.lightBackground,
      card: AppColors.lightCard,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      error: AppColors.lightError,
    );
  }

  static ThemeData getDarkTheme(BuildContext context) {
    return _buildTheme(
      context,
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      background: AppColors.darkBackground,
      card: AppColors.darkCard,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      error: AppColors.darkError,
    );
  }

  static ThemeData _buildTheme(
    BuildContext context, {
    required Color primary,
    required Color secondary,
    required Color background,
    required Color card,
    required Color textPrimary,
    required Color textSecondary,
    required Color error,
  }) {
    return ThemeData(
      brightness: background == AppColors.darkBackground
          ? Brightness.dark
          : Brightness.light,
      colorScheme: ColorScheme(
        primary: primary,
        secondary: secondary,
        surface: card,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
        brightness: background == AppColors.darkBackground
            ? Brightness.dark
            : Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        elevation: responsiveSize(context,
            mobileSize: 2, tabletSize: 4, desktopSize: 6),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: responsiveSize(context,
              mobileSize: 20, tabletSize: 22, desktopSize: 24),
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: card,
        elevation: responsiveSize(context,
            mobileSize: 3, tabletSize: 4, desktopSize: 5),
        margin: EdgeInsets.all(responsiveSize(context,
            mobileSize: 8, tabletSize: 12, desktopSize: 16)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: responsiveSize(context,
              mobileSize: 24, tabletSize: 28, desktopSize: 32),
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: responsiveSize(context,
              mobileSize: 16, tabletSize: 18, desktopSize: 20),
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: responsiveSize(context,
              mobileSize: 14, tabletSize: 16, desktopSize: 18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
          borderSide: BorderSide(color: textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: error),
          borderRadius: BorderRadius.circular(responsiveSize(context,
              mobileSize: 8, tabletSize: 10, desktopSize: 12)),
        ),
      ),
    );
  }
}
