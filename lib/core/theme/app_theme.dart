import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData getTheme(Locale locale) {
    final isArabic = locale.languageCode == 'ar';
    
    // Auto-select font family per user rules:
    // Arabic -> Zain, English -> PlusJakartaSans
    final baseTextTheme = ThemeData.dark().textTheme;
    final textTheme = isArabic
        ? GoogleFonts.zainTextTheme(baseTextTheme)
        : GoogleFonts.plusJakartaSansTextTheme(baseTextTheme);

    final titleFont = isArabic ? GoogleFonts.zain : GoogleFonts.plusJakartaSans;
    final bodyFont = isArabic ? GoogleFonts.zain : GoogleFonts.plusJakartaSans;

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBackground,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: titleFont(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: titleFont(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: bodyFont(color: AppColors.textPrimary),
        bodyMedium: bodyFont(color: AppColors.textSecondary),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => getTheme(const Locale('ar'));
}
