import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'services/ads_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AdMob's SDK is Android/iOS-only; initializing it elsewhere (desktop/web
  // dev builds) would throw on unsupported platform channels.
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await AdsService.initialize();
  }
  runApp(const SalaryCurrencyProApp());
}
