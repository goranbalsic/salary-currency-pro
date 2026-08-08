import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/budget.dart';
import '../models/expense_entry.dart';
import '../models/rate_snapshot.dart';
import 'budget_service.dart';
import 'expense_service.dart';
import 'exchange_rate_service.dart';
import 'home_widget_gateway.dart';
import 'pinned_pair_service.dart';

/// Pushes data to the two Android home-screen widgets (PROMPT-003 Stage B
/// item 8): a spend-vs-budget summary and a pinned currency pair. Both
/// widgets are classic RemoteViews `AppWidgetProvider`s (see
/// `android/app/src/main/kotlin/.../widgets/`) that read whatever this
/// service last wrote via the `home_widget` plugin's shared storage — this
/// service never draws anything itself.
///
/// Every call is wrapped in [_safely]: `home_widget`'s platform channel
/// isn't available in a plain `flutter test` run (same situation as
/// `flutter_local_notifications` — see `NotificationService`'s own
/// [_safely]), and even on a real device a widget failing to refresh must
/// never break the screen that triggered it (adding an expense, changing
/// the pinned pair, ...).
class HomeWidgetService {
  // Fully-qualified — see HomeWidgetGateway.updateWidget's doc comment on
  // why the plugin's shorter unqualified name can't be used here.
  static const _package = 'rs.salarycurrencypro.salary_currency_pro';
  static const budgetProviderName = '$_package.widgets.BudgetWidgetProvider';
  static const pairProviderName = '$_package.widgets.PinnedPairWidgetProvider';

  final HomeWidgetGateway _gateway;
  final BudgetService _budgetService;
  final ExpenseService _expenseService;
  final PinnedPairService _pinnedPairService;
  final ExchangeRateService _rateService;

  HomeWidgetService({
    HomeWidgetGateway? gateway,
    BudgetService? budgetService,
    ExpenseService? expenseService,
    PinnedPairService? pinnedPairService,
    ExchangeRateService? rateService,
  })  : _gateway = gateway ?? FlutterHomeWidgetGateway(),
        _budgetService = budgetService ?? BudgetService(),
        _expenseService = expenseService ?? ExpenseService(),
        _pinnedPairService = pinnedPairService ?? PinnedPairService(),
        _rateService = rateService ?? ExchangeRateService();

  /// Recomputes and pushes the spend-vs-budget summary. When the user has
  /// budgets in more than one currency, the widget can only show one
  /// combined figure — it picks the currency group with the highest total
  /// monthly limit (ties broken alphabetically by code) as the user's
  /// apparent "primary" budget, rather than fabricating a cross-currency
  /// total.
  Future<void> refreshBudgetWidget({required AppLocalizations l10n}) async {
    await _safely(() async {
      final budgets = await _budgetService.loadCategoryBudgets();
      if (budgets.isEmpty) {
        await _gateway.saveWidgetData('budget_has_data', false);
        await _gateway.saveWidgetData('budget_empty_label', l10n.homeWidgetBudgetEmpty);
        await _gateway.updateWidget(qualifiedAndroidName: budgetProviderName);
        return;
      }

      final byCurrency = <String, List<CategoryBudget>>{};
      for (final b in budgets) {
        byCurrency.putIfAbsent(b.currencyCode, () => []).add(b);
      }
      final currency = byCurrency.entries
          .reduce((a, b) {
            final limitA = a.value.fold<double>(0, (s, x) => s + x.monthlyLimit);
            final limitB = b.value.fold<double>(0, (s, x) => s + x.monthlyLimit);
            if (limitA == limitB) return a.key.compareTo(b.key) <= 0 ? a : b;
            return limitA > limitB ? a : b;
          })
          .key;
      final group = byCurrency[currency]!;

      final spentByCurrency = await _expenseService.categoryTotalsForMonth(
        DateTime.now(),
        type: TransactionType.expense,
      );
      final spentForCurrency = spentByCurrency[currency] ?? const {};
      final limitTotal = group.fold<double>(0, (s, x) => s + x.monthlyLimit);
      final spentTotal = group.fold<double>(
        0,
        (s, x) => s + (spentForCurrency[x.categoryId] ?? 0),
      );
      final percent = limitTotal > 0 ? (spentTotal / limitTotal * 100).round() : 0;
      final numberFormat = NumberFormat.currency(
        symbol: '',
        decimalDigits: currency == 'JPY' ? 0 : 2,
      );

      await _gateway.saveWidgetData('budget_has_data', true);
      await _gateway.saveWidgetData('budget_label', l10n.homeWidgetBudgetLabel);
      await _gateway.saveWidgetData('budget_spent_text', numberFormat.format(spentTotal));
      await _gateway.saveWidgetData('budget_limit_text', numberFormat.format(limitTotal));
      await _gateway.saveWidgetData('budget_currency', currency);
      await _gateway.saveWidgetData('budget_percent_text', '$percent%');
      await _gateway.updateWidget(qualifiedAndroidName: budgetProviderName);
    });
  }

  /// Recomputes and pushes the pinned currency pair. Fetches a live rate
  /// (falling back to whatever [ExchangeRateService] itself falls back to —
  /// this service has no fallback logic of its own); when no rate can be
  /// produced at all, the from/to codes still update immediately but the
  /// rate line is left as whatever was last successfully written, flagged
  /// stale via `pair_available` rather than replaced with a fabricated
  /// value.
  Future<void> refreshPinnedPairWidget({required AppLocalizations l10n}) async {
    await _safely(() async {
      final (from, to) = await _pinnedPairService.loadPair();
      await _gateway.saveWidgetData('pair_from_code', from);
      await _gateway.saveWidgetData('pair_to_code', to);
      await _gateway.saveWidgetData('pair_unavailable_label', l10n.homeWidgetPairUnavailable);
      try {
        final result = await _rateService.getRate(from, to);
        await _gateway.saveWidgetData('pair_rate_text', result.rate.toStringAsFixed(4));
        await _gateway.saveWidgetData(
          'pair_asof_text',
          DateFormat.yMd().format(result.asOf),
        );
        await _gateway.saveWidgetData('pair_available', true);
      } on RateUnavailableException {
        await _gateway.saveWidgetData('pair_available', false);
      }
      await _gateway.updateWidget(qualifiedAndroidName: pairProviderName);
    });
  }

  Future<void> refreshAll({required AppLocalizations l10n}) async {
    await refreshBudgetWidget(l10n: l10n);
    await refreshPinnedPairWidget(l10n: l10n);
  }

  Future<void> _safely(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Widget plumbing is best-effort — never let it crash a core feature.
    }
  }
}
