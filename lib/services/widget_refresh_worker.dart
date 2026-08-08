import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../l10n/app_localizations.dart';
import 'home_widget_service.dart';

/// WorkManager task/unique-name identifiers for the periodic widget
/// refresh — PROMPT-003 Stage B item 8's "no polling from the UI" part.
/// Instead of the app polling a live rate every time a widget is visible,
/// a single periodic background task refreshes both widgets on a fixed
/// schedule (and screens that change budget/expense/pinned-pair data push
/// their own immediate refresh via [HomeWidgetService] regardless of this
/// task's schedule).
const widgetRefreshTaskName = 'salary_currency_pro.widget_refresh_task';
const widgetRefreshUniqueName = 'salary_currency_pro.widget_refresh';

/// Must be a top-level (or static) function annotated `vm:entry-point` so
/// Android can find it from a headless engine — see the `workmanager`
/// package's own quick-start example, which uses the identical shape.
@pragma('vm:entry-point')
void widgetRefreshCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != widgetRefreshTaskName) return true;
    try {
      final l10n = await _resolveLocalizations();
      await HomeWidgetService().refreshAll(l10n: l10n);
    } catch (_) {
      // Best-effort: WorkManager retries on its own periodic schedule
      // regardless, so a failed run just tries again next cycle.
    }
    return true;
  });
}

/// A background task has no [BuildContext], so it can't use
/// `AppLocalizations.of(context)`. Instead it reads the same persisted
/// locale preference the app itself uses (`app.dart`'s `_prefsLocaleKey`,
/// deliberately duplicated here as a literal since importing `app.dart`
/// from a background isolate entry point would pull in the whole widget
/// tree), falling back to the device locale and then to English.
Future<AppLocalizations> _resolveLocalizations() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('app_locale_code');
    if (saved != null && saved.isNotEmpty) {
      return lookupAppLocalizations(Locale(saved));
    }
  } catch (_) {
    // Fall through to device-locale/English resolution below.
  }
  try {
    return lookupAppLocalizations(PlatformDispatcher.instance.locale);
  } catch (_) {
    return lookupAppLocalizations(const Locale('en'));
  }
}
