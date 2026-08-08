import 'package:home_widget/home_widget.dart';

/// Thin wrapper around the `home_widget` plugin's static API — same
/// fake-injection-for-tests shape as `NotificationScheduler`. `flutter test`
/// has no real platform channel for `home_widget` either, so production code
/// must go through this interface to stay testable, and every call site
/// must treat failures as best-effort (see `HomeWidgetService._safely`).
abstract class HomeWidgetGateway {
  Future<void> saveWidgetData(String key, Object? value);

  /// [qualifiedAndroidName] must be the widget provider's fully-dotted
  /// class name (e.g. `rs.salarycurrencypro.salary_currency_pro.widgets.
  /// BudgetWidgetProvider`) — the plugin's shorter `androidName` param only
  /// resolves classes directly in the app's root package
  /// (`context.packageName + "." + androidName`), which would silently
  /// fail to find either provider since both live in a `.widgets`
  /// subpackage.
  Future<void> updateWidget({required String qualifiedAndroidName});
}

class FlutterHomeWidgetGateway implements HomeWidgetGateway {
  @override
  Future<void> saveWidgetData(String key, Object? value) async {
    await HomeWidget.saveWidgetData(key, value);
  }

  @override
  Future<void> updateWidget({required String qualifiedAndroidName}) async {
    await HomeWidget.updateWidget(qualifiedAndroidName: qualifiedAndroidName);
  }
}
