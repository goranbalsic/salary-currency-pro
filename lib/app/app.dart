import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/design/theme.dart';
import '../core/design/tokens.dart';
import '../features/business/data/business_store.dart';
import '../features/fx/data/rates_controller.dart';
import '../features/history/history_store.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/payroll/data/team_store.dart';
import '../features/pro/pro_controller.dart';
import '../features/settings/settings_controller.dart';
import '../features/shell/root_shell.dart';
import '../l10n/l10n.dart';
import 'bootstrap.dart';

class BilansApp extends StatelessWidget {
  const BilansApp({super.key, required this.services});

  final AppServices services;

  static final supportedLocales = [
    for (final l in AppLanguage.values) l.locale,
    const Locale('sr'),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppServices>.value(value: services),
        ChangeNotifierProvider<SettingsController>.value(value: services.settings),
        ChangeNotifierProvider<RatesController>.value(value: services.rates),
        ChangeNotifierProvider<HistoryStore>.value(value: services.history),
        ChangeNotifierProvider<BusinessStore>.value(value: services.business),
        ChangeNotifierProvider<TeamStore>.value(value: services.team),
        ChangeNotifierProvider<ProController>.value(value: services.pro),
        ChangeNotifierProvider<ShellController>.value(value: services.shell),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settings, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.appName,
          theme: BilansTheme.light(),
          darkTheme: BilansTheme.dark(),
          themeMode: settings.themeMode,
          locale: settings.language?.locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeListResolutionCallback: (locales, supported) => AppLanguage.fromLocales(locales).locale,
          builder: (context, child) {
            // Respect the person's font size, but keep layouts intact at the
            // extremes of the Android accessibility range.
            final media = MediaQuery.of(context);
            final scaler = media.textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.6);
            return _ReadableWidth(
              child: MediaQuery(
                data: media.copyWith(textScaler: scaler),
                child: child!,
              ),
            );
          },
          home: const _Root(),
        ),
      ),
    );
  }
}

/// Onboarding until a country is chosen, then the app. Watching here (not
/// in MaterialApp.home) swaps the screen reliably after a data reset.
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final onboarded = context.select<SettingsController, bool>((s) => s.onboarded);
    return onboarded ? const RootShell() : const OnboardingScreen();
  }
}

/// The app is designed phone-first. On tablets and unfolded foldables —
/// where Android 16 ignores orientation locks — it keeps a readable column
/// centred on the page, instead of stretching rows across the screen.
class _ReadableWidth extends StatelessWidget {
  const _ReadableWidth({required this.child});

  static const maxWidth = 720.0;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (media.size.width <= maxWidth) return child;
    final c = context.colors;
    final side = (media.size.width - maxWidth) / 2;
    // Insets move with the column: the side margins already clear any
    // display cutout or system bar on the left and right.
    final inner = media.copyWith(
      size: Size(maxWidth, media.size.height),
      padding: media.padding.copyWith(left: math.max(0, media.padding.left - side), right: math.max(0, media.padding.right - side)),
      viewPadding: media.viewPadding.copyWith(left: math.max(0, media.viewPadding.left - side), right: math.max(0, media.viewPadding.right - side)),
      viewInsets: media.viewInsets.copyWith(left: 0, right: 0),
    );
    return ColoredBox(
      color: c.sunken,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.paper,
            border: Border.symmetric(vertical: BorderSide(color: c.line)),
          ),
          child: SizedBox(
            width: maxWidth,
            child: MediaQuery(data: inner, child: child),
          ),
        ),
      ),
    );
  }
}
