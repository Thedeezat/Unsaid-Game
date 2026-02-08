import 'package:flutter/material.dart';

/// Theme color and palette for Unsaid (Undercover clone).
class AppTheme {
  AppTheme._();

  static const Color primaryBlue = Color(0xFF5997FF);
  static const Color primaryBlueDark = Color(0xFF4A85E6);
  static const Color primaryBlueLight = Color(0xFF7BB0FF);
  static const Color surfaceLight = Color(0xFFF5F8FF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color gradientStart = Color(0xFFE8F0FF);
  static const Color gradientEnd = Color(0xFFD0E0FF);
  static const Color undercoverColor = Color(0xFF2D2D2D);
  static const Color citizenColor = Color(0xFF5997FF);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color accentOrange = Color(0xFFFF9800);
  /// Header text color used on win screen and all game screens for strong contrast.
  static const Color headerColor = Color(0xFF1A3A6B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: primaryBlueLight,
        surface: surfaceLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF333333)),
        titleTextStyle: TextStyle(
          color: Color(0xFF333333),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shadowColor: primaryBlue.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A1A),
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF333333)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF555555)),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
