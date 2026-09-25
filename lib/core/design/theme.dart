import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

abstract final class BilansTheme {
  static ThemeData light() => _build(Brightness.light, BilansColors.light);
  static ThemeData dark() => _build(Brightness.dark, BilansColors.dark);

  static TextTheme _text(BilansColors c) {
    TextStyle sans(double size, FontWeight w, {Color? color, double? height, double? spacing}) => TextStyle(
          fontFamily: Fonts.sans,
          fontSize: size,
          fontWeight: w,
          color: color ?? c.ink,
          height: height,
          letterSpacing: spacing,
        );
    TextStyle serif(double size, {double? spacing, double? height}) => TextStyle(
          fontFamily: Fonts.serif,
          fontSize: size,
          fontWeight: FontWeight.w600,
          color: c.ink,
          letterSpacing: spacing,
          height: height,
          fontFeatures: Fonts.tabular,
        );
    return TextTheme(
      displayLarge: serif(46, spacing: -0.7, height: 1.05),
      displayMedium: serif(36, spacing: -0.5, height: 1.1),
      displaySmall: serif(30, spacing: -0.3, height: 1.15),
      headlineLarge: serif(30, spacing: -0.3),
      headlineMedium: serif(27, spacing: -0.27, height: 1.2),
      headlineSmall: serif(22, height: 1.25),
      titleLarge: serif(21, height: 1.25),
      titleMedium: sans(16, FontWeight.w500, height: 1.3),
      titleSmall: sans(14.5, FontWeight.w600, height: 1.3),
      bodyLarge: sans(16, FontWeight.w400, height: 1.5),
      bodyMedium: sans(14.5, FontWeight.w400, height: 1.45),
      bodySmall: sans(13, FontWeight.w400, color: c.ink3, height: 1.4),
      labelLarge: sans(15, FontWeight.w600),
      labelMedium: sans(13, FontWeight.w500),
      labelSmall: sans(11, FontWeight.w600, color: c.ink3, spacing: 1.0),
    );
  }

  static ThemeData _build(Brightness b, BilansColors c) {
    final scheme = ColorScheme(
      brightness: b,
      primary: c.green,
      onPrimary: c.onGreen,
      primaryContainer: c.greenTint,
      onPrimaryContainer: c.ink,
      secondary: c.brass,
      onSecondary: c.onBrass,
      secondaryContainer: c.brassTint,
      onSecondaryContainer: c.brassText,
      tertiary: c.slate,
      onTertiary: c.surface,
      error: c.brick,
      onError: c.surface,
      errorContainer: c.warningTint,
      onErrorContainer: c.ink,
      surface: c.paper,
      onSurface: c.ink,
      onSurfaceVariant: c.ink2,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.surface,
      surfaceContainerHighest: c.sunken,
      outline: c.ink3,
      outlineVariant: c.line,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: c.ink,
      onInverseSurface: c.paper,
      inversePrimary: c.greenTint,
    );
    final text = _text(c);
    final overlay = b == Brightness.light
        ? SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
          )
        : SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
          );
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md));
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: scheme,
      fontFamily: Fonts.sans,
      textTheme: text,
      scaffoldBackgroundColor: c.paper,
      canvasColor: c.paper,
      extensions: [c],
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.paper,
        foregroundColor: c.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 4,
        systemOverlayStyle: overlay,
        titleTextStyle: text.titleLarge,
      ),
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.green,
          foregroundColor: c.onGreen,
          disabledBackgroundColor: c.sunken,
          disabledForegroundColor: c.ink3,
          minimumSize: const Size(64, 52),
          shape: buttonShape,
          textStyle: text.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.ink,
          minimumSize: const Size(64, 48),
          shape: buttonShape,
          side: BorderSide(color: c.ink),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.green,
          minimumSize: const Size(48, 44),
          textStyle: text.labelLarge,
          shape: buttonShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: c.ink, minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        labelStyle: text.bodyMedium?.copyWith(color: c.ink2),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: c.green),
        hintStyle: text.bodyMedium?.copyWith(color: c.ink3),
        helperStyle: text.bodySmall,
        errorStyle: text.bodySmall?.copyWith(color: c.brick),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide(color: c.line)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide(color: c.line)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide(color: c.green, width: 1.6)),
        errorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide(color: c.brick)),
        focusedErrorBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide(color: c.brick, width: 1.6)),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.green,
        selectionColor: c.green.withValues(alpha: 0.25),
        selectionHandleColor: c.green,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.paper,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: c.paper,
        showDragHandle: true,
        dragHandleColor: c.line,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.paper,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.xl)),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium?.copyWith(color: c.ink2),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.ink,
        contentTextStyle: text.bodyMedium?.copyWith(color: c.paper),
        actionTextColor: b == Brightness.light ? c.greenTint : c.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.onGreen : c.ink3),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.green : c.sunken),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.green : c.line),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.green : Colors.transparent),
        checkColor: WidgetStatePropertyAll(c.onGreen),
        side: BorderSide(color: c.ink2, width: 1.6),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.green : c.ink3),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.green, linearTrackColor: c.sunken),
      listTileTheme: ListTileThemeData(
        iconColor: c.ink2,
        textColor: c.ink,
        titleTextStyle: text.titleMedium,
        subtitleTextStyle: text.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: Gap.page),
        minVerticalPadding: 10,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: c.ink, borderRadius: BorderRadius.circular(Radii.sm)),
        textStyle: text.bodySmall?.copyWith(color: c.paper),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        textStyle: text.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md), side: BorderSide(color: c.line)),
      ),
      scrollbarTheme: ScrollbarThemeData(thumbColor: WidgetStatePropertyAll(c.ink3.withValues(alpha: 0.5))),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.paper,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.green,
        headerForegroundColor: c.onGreen,
        todayForegroundColor: WidgetStatePropertyAll(c.green),
        todayBorder: BorderSide(color: c.green),
      ),
    );
  }
}
