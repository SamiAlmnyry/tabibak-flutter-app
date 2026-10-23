import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // 1. الثيم الفاتح الفاخر
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Tajawal',
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        bodyLarge: TextStyle(fontFamily: 'Tajawal', color: Color(0xFF0F172A)),
        bodyMedium: TextStyle(fontFamily: 'Tajawal', color: Color(0xFF64748B)),
      ),
    );
  }

  // 2. الثيم الداكن الليلي الفخم (Deep Dark Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Tajawal',
      scaffoldBackgroundColor: const Color(0xFF0B132B), // أزرق ليلي عميق
      primaryColor: AppColors.primaryLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondary,
        surface: const Color(0xFF1C2541), // سطح الكروت الداكنة
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(fontFamily: 'Tajawal', color: Colors.white),
        bodyMedium: TextStyle(fontFamily: 'Tajawal', color: Color(0xFF94A3B8)),
      ),
    );
  }
}