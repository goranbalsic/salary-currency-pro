import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'services/widget_refresh_worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // PROMPT-003F Stage D go-ahead, Decision 1: launch ad-free — the Mobile
  // Ads SDK is deliberately not initialized. AdsService/BannerAdSlot/
  // ConsentService are left in place, not deleted: the decision is
  // sequencing ("not permanent"), not a removal, and ConsentService's GDPR
  // consent form is still reachable from Settings for reasons unrelated to
  // ads. See DECISIONS.md.
  // Home-screen widgets (PROMPT-003 Stage B item 8) are Android-only in
  // this app (see android/app/.../widgets/) — only Android gets the
  // periodic background refresh. Best-effort: a failure here must never
  // block app startup.
  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      await Workmanager().initialize(widgetRefreshCallbackDispatcher);
      await Workmanager().registerPeriodicTask(
        widgetRefreshUniqueName,
        widgetRefreshTaskName,
        frequency: const Duration(hours: 1),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
        constraints: Constraints(networkType: NetworkType.connected),
      );
    } catch (_) {
      // Widget background refresh is best-effort — the app must still start.
    }
  }
  runApp(const SalaryCurrencyProApp());
}
