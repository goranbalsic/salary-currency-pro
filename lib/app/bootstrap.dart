import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/storage/store.dart';
import '../features/business/data/business_store.dart';
import '../features/fx/data/rate_api.dart';
import '../features/fx/data/rates_controller.dart';
import '../features/history/history_store.dart';
import '../features/payroll/data/team_store.dart';
import '../features/pro/pro_controller.dart';
import '../features/settings/settings_controller.dart';
import 'app.dart';

/// Everything the widget tree needs, created once at startup.
class AppServices {
  AppServices({
    required this.store,
    required this.settings,
    required this.rates,
    required this.history,
    required this.business,
    required this.team,
    required this.pro,
  });

  final Store store;
  final SettingsController settings;
  final RatesController rates;
  final HistoryStore history;
  final BusinessStore business;
  final TeamStore team;
  final ProController pro;

  static AppServices create(Store store, {RateApi? rateApi, ProController? pro}) => AppServices(
        store: store,
        settings: SettingsController(store),
        rates: RatesController(store, rateApi ?? HttpRateApi()),
        history: HistoryStore(store),
        business: BusinessStore(store),
        team: TeamStore(store),
        pro: pro ?? ProController(store),
      );

  /// Re-reads every store after a backup restore or a data reset.
  void reloadAll() {
    settings.reload();
    rates.reload();
    history.reload();
    business.reload();
    team.reload();
    pro.reloadCache();
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) debugPrint('Flutter error: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught: $error\n$stack');
    return true;
  };
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final store = await Store.open();
  final services = AppServices.create(store);
  runApp(BilansApp(services: services));

  // Network and store work happens after the first frame, never blocking it.
  unawaited(services.rates.refresh());
  unawaited(services.pro.start());
}

void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    final serif = await rootBundle.loadString('assets/legal/OFL-SourceSerif4.txt');
    yield LicenseEntryWithLineBreaks(const ['Source Serif 4'], serif);
    final plex = await rootBundle.loadString('assets/legal/OFL-IBMPlex.txt');
    yield LicenseEntryWithLineBreaks(const ['IBM Plex Sans', 'IBM Plex Mono'], plex);
  });
}
