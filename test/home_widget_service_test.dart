import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/l10n/app_localizations.dart';
import 'package:salary_currency_pro/models/budget.dart';
import 'package:salary_currency_pro/models/expense_entry.dart';
import 'package:salary_currency_pro/models/rate_snapshot.dart';
import 'package:salary_currency_pro/services/budget_service.dart';
import 'package:salary_currency_pro/services/exchange_rate_service.dart';
import 'package:salary_currency_pro/services/expense_service.dart';
import 'package:salary_currency_pro/services/home_widget_gateway.dart';
import 'package:salary_currency_pro/services/home_widget_service.dart';
import 'package:salary_currency_pro/services/pinned_pair_service.dart';
import 'package:salary_currency_pro/services/rate_cache_service.dart';
import 'package:salary_currency_pro/services/rate_providers.dart';

/// Records every push instead of touching a real platform channel — same
/// fake-injection pattern this app uses for NotificationScheduler.
class _FakeGateway implements HomeWidgetGateway {
  final Map<String, Object?> data = {};
  final List<String> updated = [];

  @override
  Future<void> saveWidgetData(String key, Object? value) async {
    data[key] = value;
  }

  @override
  Future<void> updateWidget({required String qualifiedAndroidName}) async {
    updated.add(qualifiedAndroidName);
  }
}

/// Simulates the real `home_widget` plugin having no platform channel (as
/// in a plain `flutter test` run) — every call throws.
class _ThrowingGateway implements HomeWidgetGateway {
  @override
  Future<void> saveWidgetData(String key, Object? value) async =>
      throw StateError('not available');

  @override
  Future<void> updateWidget({required String qualifiedAndroidName}) async =>
      throw StateError('not available');
}

class _FakeRateProvider implements RateProviderApi {
  @override
  final String id;
  final RateSnapshot? Function(String base) onFetch;
  _FakeRateProvider(this.id, this.onFetch);

  @override
  Future<RateSnapshot> fetchLatest(String base) async {
    final snapshot = onFetch(base);
    if (snapshot == null) {
      throw const RateUnavailableException('Simulated network failure.');
    }
    return snapshot;
  }
}

final _l10n = lookupAppLocalizations(const Locale('en'));

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('budget widget', () {
    test('no budgets set pushes the empty state', () async {
      final gateway = _FakeGateway();
      final service = HomeWidgetService(gateway: gateway);

      await service.refreshBudgetWidget(l10n: _l10n);

      expect(gateway.data['budget_has_data'], isFalse);
      expect(gateway.data['budget_empty_label'], isNotEmpty);
      expect(gateway.updated, [HomeWidgetService.budgetProviderName]);
    });

    test('a single-currency budget pushes spent/limit/percent/currency', () async {
      final gateway = _FakeGateway();
      final budgetService = BudgetService();
      final expenseService = ExpenseService();
      await budgetService.setCategoryBudget(
        const CategoryBudget(categoryId: 'groceries', monthlyLimit: 200, currencyCode: 'EUR'),
      );
      final now = DateTime.now();
      await expenseService.add(
        type: TransactionType.expense,
        categoryId: 'groceries',
        amount: 100,
        currencyCode: 'EUR',
        date: now,
      );
      final service = HomeWidgetService(
        gateway: gateway,
        budgetService: budgetService,
        expenseService: expenseService,
      );

      await service.refreshBudgetWidget(l10n: _l10n);

      expect(gateway.data['budget_has_data'], isTrue);
      expect(gateway.data['budget_currency'], 'EUR');
      expect(gateway.data['budget_percent_text'], '50%');
      expect(gateway.updated, [HomeWidgetService.budgetProviderName]);
    });

    test(
        'budgets split across two currencies pick the group with the higher total limit',
        () async {
      final gateway = _FakeGateway();
      final budgetService = BudgetService();
      await budgetService.setCategoryBudget(
        const CategoryBudget(categoryId: 'rent', monthlyLimit: 900, currencyCode: 'EUR'),
      );
      await budgetService.setCategoryBudget(
        const CategoryBudget(categoryId: 'phone', monthlyLimit: 10, currencyCode: 'USD'),
      );
      final service = HomeWidgetService(
        gateway: gateway,
        budgetService: budgetService,
        expenseService: ExpenseService(),
      );

      await service.refreshBudgetWidget(l10n: _l10n);

      expect(gateway.data['budget_currency'], 'EUR');
    });

    test('a gateway failure never throws (best-effort)', () async {
      final service = HomeWidgetService(gateway: _ThrowingGateway());
      await expectLater(service.refreshBudgetWidget(l10n: _l10n), completes);
    });
  });

  group('pinned pair widget', () {
    test('a live rate pushes from/to/rate and marks it available', () async {
      final gateway = _FakeGateway();
      final rateService = ExchangeRateService(
        // EUR -> RSD (the default pinned pair) is routed to the RSD
        // provider (open_er_api), not Frankfurter — see
        // ExchangeRateService._providerFor.
        openErApi: _FakeRateProvider('open_er_api', (base) => RateSnapshot(
              base: 'EUR',
              rates: const {'RSD': 117.5},
              asOf: DateTime(2026, 8, 8),
              fetchedAt: DateTime(2026, 8, 8),
              source: 'Fake Source',
            )),
        cache: RateCacheService(),
      );
      final service = HomeWidgetService(
        gateway: gateway,
        pinnedPairService: PinnedPairService(),
        rateService: rateService,
      );

      await service.refreshPinnedPairWidget(l10n: _l10n);

      expect(gateway.data['pair_from_code'], 'EUR');
      expect(gateway.data['pair_to_code'], 'RSD');
      expect(gateway.data['pair_rate_text'], '117.5000');
      expect(gateway.data['pair_available'], isTrue);
      expect(gateway.updated, [HomeWidgetService.pairProviderName]);
    });

    test(
        'no live rate and no cache leaves from/to updated but flags unavailable without fabricating a rate',
        () async {
      final gateway = _FakeGateway();
      final rateService = ExchangeRateService(
        frankfurter: _FakeRateProvider('frankfurter', (base) => null),
        openErApi: _FakeRateProvider('open_er_api', (base) => null),
        cache: RateCacheService(),
      );
      final service = HomeWidgetService(
        gateway: gateway,
        pinnedPairService: PinnedPairService(),
        rateService: rateService,
      );

      await service.refreshPinnedPairWidget(l10n: _l10n);

      expect(gateway.data['pair_from_code'], 'EUR');
      expect(gateway.data['pair_to_code'], 'RSD');
      expect(gateway.data['pair_available'], isFalse);
      expect(gateway.data.containsKey('pair_rate_text'), isFalse);
      expect(gateway.data['pair_unavailable_label'], isNotEmpty);
    });

    test('a gateway failure never throws (best-effort)', () async {
      final service = HomeWidgetService(gateway: _ThrowingGateway());
      await expectLater(service.refreshPinnedPairWidget(l10n: _l10n), completes);
    });
  });

  group('refreshAll', () {
    test('refreshes both widgets', () async {
      final gateway = _FakeGateway();
      final service = HomeWidgetService(gateway: gateway);

      await service.refreshAll(l10n: _l10n);

      expect(
        gateway.updated,
        containsAll([HomeWidgetService.budgetProviderName, HomeWidgetService.pairProviderName]),
      );
    });
  });
}
