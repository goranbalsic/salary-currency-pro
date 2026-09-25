import 'dart:io';

import 'package:bilans/app/app.dart';
import 'package:bilans/app/app_config.dart';
import 'package:bilans/app/bootstrap.dart';
import 'package:bilans/core/storage/store.dart';
import 'package:bilans/features/pro/pro_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fx/rates_test.dart' show FakeRateApi, ecbTable, nbsTable;
import '../pro/pro_controller_test.dart' show FakeGateway, purchase;

bool _fontsLoaded = false;

/// The fake store behind the most recent [makeServices] call, so tests can
/// play Google Play's part (deliver purchase updates).
late FakeGateway lastGateway;

/// Loads the app's real fonts so text widths — and therefore overflow
/// checks — match a device. Without this the test font's 1em-wide glyphs
/// make every line roughly twice as long as it really is.
Future<void> loadAppFonts() async {
  if (_fontsLoaded) return;
  _fontsLoaded = true;
  Future<void> family(String name, List<String> files) async {
    final loader = FontLoader(name);
    for (final f in files) {
      loader.addFont(rootBundle.load('assets/fonts/$f'));
    }
    await loader.load();
  }

  await family('Plex', ['IBMPlexSans-Regular.ttf', 'IBMPlexSans-Medium.ttf', 'IBMPlexSans-SemiBold.ttf']);
  await family('PlexMono', ['IBMPlexMono-Medium.ttf']);
  await family('SourceSerif', ['SourceSerif4-Regular.ttf', 'SourceSerif4-SemiBold.ttf', 'SourceSerif4-Italic.ttf']);
  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? '/opt/sdk/flutter';
  final icons = File('$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
  if (icons.existsSync()) {
    final loader = FontLoader('MaterialIcons')..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
    await loader.load();
  }
}

/// Answers the plugins' platform channels instantly. Unmocked channels
/// reply through real I/O, which never completes under a widget test's
/// fake clock — a share button would spin forever in the test.
void mockPlatformChannels() {
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(const MethodChannel('net.nfet.printing'), (call) async => call.method == 'sharePdf' ? 1 : null);
  messenger.setMockMethodCallHandler(const MethodChannel('dev.fluttercommunity.plus/share'), (call) async => 'dev.fluttercommunity.plus/share/unavailable');
  messenger.setMockMethodCallHandler(const MethodChannel('dev.fluttercommunity.plus/package_info'), (call) async => <String, Object>{
        'appName': 'Bilans',
        'packageName': 'rs.bilans.app',
        'version': '2.0.0',
        'buildNumber': '20',
      });
  messenger.setMockMethodCallHandler(const MethodChannel('dev.britannio.in_app_review'), (call) async => null);
  messenger.setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/url_launcher_android'), (call) async => true);
}

/// Services wired to fakes: no network, no Play Store.
Future<AppServices> makeServices({
  bool pro = false,
  String country = 'RS',
  bool onboarded = true,
  String? language,
  Map<String, Object> extra = const {},
}) async {
  mockPlatformChannels();
  SharedPreferences.setMockInitialValues(extra);
  final store = await Store.open();
  if (onboarded) {
    await store.writeJson('settings.v1', {'country': country, 'onboarded': true, 'language': language});
  }
  final api = FakeRateApi()
    ..nbs = nbsTable
    ..ecb = ecbTable;
  final gateway = lastGateway = FakeGateway()..owned = pro ? [purchase(AppConfig.proLifetime, PurchaseStatus.purchased)] : const [];
  final proController = ProController(store, gateway: gateway, billingSupported: true);
  final services = AppServices.create(store, rateApi: api, pro: proController);
  await services.rates.refresh();
  await proController.start();
  return services;
}

/// Sets the logical screen size and text scale for the current test.
void setScreen(WidgetTester tester, {double width = 360, double height = 800, double textScale = 1.0}) {
  tester.view.devicePixelRatio = 3;
  tester.view.physicalSize = Size(width * 3, height * 3);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

Future<void> pumpApp(WidgetTester tester, AppServices services) async {
  await tester.pumpWidget(BilansApp(services: services));
  await tester.pumpAndSettle();
}
