import 'package:flutter/material.dart';

/// Fintech color palette: navy blue (trust/primary), money green (positive/success),
/// alert red (warnings/errors/negative values).
class AppColors {
  AppColors._();

  static const navy = Color(0xFF0B2545);
  static const navyLight = Color(0xFF13315C);
  static const moneyGreen = Color(0xFF1B8A5A);
  static const moneyGreenLight = Color(0xFF34C77B);
  static const alertRed = Color(0xFFD64545);
  static const gold = Color(0xFFC9A227);

  static const lightBackground = Color(0xFFF4F6F9);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkBackground = Color(0xFF0A1628);
  static const darkSurface = Color(0xFF122036);
}

/// Shared animation timings/curves so every screen's motion feels like one
/// system instead of each widget inventing its own duration.
class Motion {
  Motion._();

  static const fast = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 250);
  static const curve = Curves.easeOutCubic;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: Brightness.light,
      primary: AppColors.navy,
      secondary: AppColors.moneyGreen,
      error: AppColors.alertRed,
      surface: AppColors.lightSurface,
    );
    return _base(colorScheme, AppColors.lightBackground);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.navyLight,
      brightness: Brightness.dark,
      primary: AppColors.moneyGreenLight,
      secondary: AppColors.moneyGreenLight,
      error: AppColors.alertRed,
      surface: AppColors.darkSurface,
    );
    return _base(colorScheme, AppColors.darkBackground);
  }

  static ThemeData _base(ColorScheme colorScheme, Color scaffoldBg) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.moneyGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.moneyGreen,
          selectedForegroundColor: Colors.white,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
