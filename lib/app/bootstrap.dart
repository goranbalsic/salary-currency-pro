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
import '../features/shell/shell_controller.dart';
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
    required this.shell,
  });

  final Store store;
  final SettingsController settings;
  final RatesController rates;
  final HistoryStore history;
  final BusinessStore business;
  final TeamStore team;
  final ProController pro;

  /// Tab selection, provided above the Navigator so pushed screens can
  /// switch tabs too.
  final ShellController shell;

  static AppServices create(Store store, {RateApi? rateApi, ProController? pro}) => AppServices(
    store: store,
    settings: SettingsController(store),
    rates: RatesController(store, rateApi ?? HttpRateApi()),
    history: HistoryStore(store),
    business: BusinessStore(store),
    team: TeamStore(store),
    pro: pro ?? ProController(store),
    shell: ShellController(),
  );

  /// Re-reads every store after a backup restore or a data reset.
  void reloadAll() {
    settings.reload();
    rates.reload();
    history.reload();
    business.reload();
    team.reload();
    pro.reloadCache();
    shell.reset();
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
  // Rates published while the app sat in the background (overnight, say)
  // load when it returns; refresh() skips if it ran in the last 20 minutes.
  // Purchases are not re-checked here: coming back from Play's payment
  // sheet is also a resume, and the purchase stream reports that result.
  // The binding keeps the listener registered for the life of the app.
  AppLifecycleListener(onResume: () => unawaited(services.rates.refresh()));
}

void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    final serif = await rootBundle.loadString('assets/legal/OFL-SourceSerif4.txt');
    yield LicenseEntryWithLineBreaks(const ['Source Serif 4'], serif);
    final plex = await rootBundle.loadString('assets/legal/OFL-IBMPlex.txt');
    yield LicenseEntryWithLineBreaks(const ['IBM Plex Sans', 'IBM Plex Mono'], plex);
  });
}
