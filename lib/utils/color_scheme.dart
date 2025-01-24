import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50); // Main app theme color
  static const Color secondary = Color(0xFFFF9800); // Accent color
  static const Color background = Color(0xFFF9F9F9); // App background color
  static const Color card = Color(0xFFFFFFFF); // Card and container background
  static const Color textPrimary = Color(0xFF212121); // Main text color
  static const Color textSecondary = Color(0xFF757575); // Subtle text color
  static const Color danger = Color(0xFFF44336); // Error or danger color
}

final ThemeData appTheme = ThemeData(
  // Primary app colors
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.card,
    // For cards, sheets, etc.
    error: AppColors.danger,
    onPrimary: Colors.white,
    // Text/icon color on primary
    onSecondary: Colors.white,
    // Text on secondary
    onSurface: AppColors.textPrimary,
    // Text on surface
    onError: Colors.white, // Text/icon color on error
  ),

  // Scaffold background
  scaffoldBackgroundColor: AppColors.background,

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary, // AppBar background
    elevation: 2, // Subtle shadow
    iconTheme: IconThemeData(color: Colors.white), // Icons in AppBar
    titleTextStyle: TextStyle(
      color: Colors.white, // AppBar title color
      fontSize: 20, // AppBar title font size
      fontWeight: FontWeight.bold,
    ),
  ),

  // Card styling
  cardTheme: CardTheme(
    color: AppColors.card,
    elevation: 3, // Elevation for shadow effect
    margin: const EdgeInsets.all(8), // Default card margin
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
  ),

  // FloatingActionButton theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.white,
    elevation: 4,
  ),

  // Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded buttons
      ),
    ),
  ),

  // TextButton theme
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      overlayColor: WidgetStateProperty.all(
        AppColors.primary.withOpacity(0.1), // Ripple effect
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
  // Text themes
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    // Large headings
    headlineSmall: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    // Small headings
    bodyLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
    ),
    // Main text
    bodyMedium: TextStyle(
      color: AppColors.textSecondary,
      fontSize: 14,
    ),
    // Secondary text
    bodySmall: TextStyle(
      color: AppColors.textSecondary,
      fontSize: 12,
    ), // Captions or small text
  ),

  // Input field styling
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.card,
    // Background of input fields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.textSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.danger),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
    labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
  ),
);
