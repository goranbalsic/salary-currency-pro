import 'package:flutter/material.dart';

/// Fintech color palette: navy blue (trust/primary), money green (positive/success),
/// alert red (warnings/errors/negative values), gold (accent/premium).
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

  /// The app's one universal "do the positive/confirming thing" color —
  /// Calculate/Save/Convert buttons, positive deltas — kept as a single
  /// brand decision independent of which M3 role (primary/secondary/
  /// tertiary) happens to be navy or gold in a given brightness.
  static Color positiveAction(Brightness brightness) =>
      brightness == Brightness.dark ? moneyGreenLight : moneyGreen;
}

/// Spacing scale (logical pixels). Use instead of inlining raw numbers so
/// screen-level padding/gaps stay consistent as the redesign rolls out.
class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Corner-radius scale, matched to the app's existing flat/outlined M3 look
/// (cards 16, inputs/buttons 12, sheets 20, pills for chips/badges).
class AppRadius {
  AppRadius._();

  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const pill = 999.0;
}

/// Named opacities, replacing magic alpha values scattered per-widget.
class AppOpacity {
  AppOpacity._();

  static const outline = 0.12;
  static const disabled = 0.38;
  static const skeleton = 0.12;
}

/// Shared animation timings/curves so every screen's motion feels like one
/// system instead of each widget inventing its own duration. Motion stays
/// short and purposeful only: count-ups, skeleton pulses, sheet/dialog
/// entrances — never constant or decorative.
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
      secondary: AppColors.gold,
      tertiary: AppColors.moneyGreen,
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
      secondary: AppColors.gold,
      tertiary: AppColors.navyLight,
      error: AppColors.alertRed,
      surface: AppColors.darkSurface,
    );
    return _base(colorScheme, AppColors.darkBackground);
  }

  static const _fontFamily = 'Noto Sans';

  static TextTheme _textTheme(ColorScheme colorScheme) {
    final base = Typography.material2021(
      platform: TargetPlatform.android,
    ).black.apply(
          fontFamily: _fontFamily,
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        );
    return base.copyWith(
      // Result-screen headline figures (e.g. "87,542.10 RSD") need to read
      // instantly as the most important number on the screen.
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  static ThemeData _base(ColorScheme colorScheme, Color scaffoldBg) {
    final actionColor = AppColors.positiveAction(colorScheme.brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      fontFamily: _fontFamily,
      textTheme: _textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
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
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: colorScheme.outline.withValues(alpha: AppOpacity.outline),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: actionColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: actionColor,
          selectedForegroundColor: Colors.white,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: AppOpacity.outline),
        ),
        labelStyle: TextStyle(fontFamily: _fontFamily, fontSize: 13),
      ),
    );
  }
}
