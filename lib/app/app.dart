import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/design/theme.dart';
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
          localeListResolutionCallback: (locales, supported) {
            final device = locales?.isNotEmpty == true ? locales!.first : null;
            return AppLanguage.fromLocale(device).locale;
          },
          builder: (context, child) {
            // Respect the person's font size, but keep layouts intact at the
            // extremes of the Android accessibility range.
            final media = MediaQuery.of(context);
            final scaler = media.textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.6);
            return MediaQuery(data: media.copyWith(textScaler: scaler), child: child!);
          },
          home: settings.onboarded ? const RootShell() : const OnboardingScreen(),
        ),
      ),
    );
  }
}
