import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'services/widget_refresh_worker.dart';

/// The shared startup body every entrypoint (`main.dart`, `main_dev.dart`,
/// `main_prod.dart`) calls after setting [AppConfig.flavor] — PROMPT-003J
/// checkpoint 1 factored this out of `main.dart` so the dev/prod
/// entrypoints don't duplicate it.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // PROMPT-003F Stage D Decision 1 (no ads at launch) plus the follow-up
  // decision to remove the dormant Google Mobile Ads/UMP SDK entirely
  // rather than keep it disabled-but-compiled: AdsService, BannerAdSlot,
  // and ConsentService (Google's UMP consent wrapper, which depends on
  // the same package) are all deleted, not just unused. Re-adding ads
  // later needs a fresh, explicit product/privacy implementation — see
  // DECISIONS.md.
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
