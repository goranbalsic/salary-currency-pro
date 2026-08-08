import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/models/rate_snapshot.dart';
import 'package:salary_currency_pro/services/exchange_rate_service.dart';
import 'package:salary_currency_pro/services/invoice_service.dart';
import 'package:salary_currency_pro/services/pausal_tracker_service.dart';
import 'package:salary_currency_pro/services/rate_cache_service.dart';
import 'package:salary_currency_pro/services/rate_providers.dart';
import 'package:salary_currency_pro/services/tax_rules_service.dart';

/// Same fake-provider pattern as exchange_rate_service_test.dart — never
/// hits the network, but exercises the real fallback/exception logic.
class _FakeProvider implements RateProviderApi {
  @override
  final String id;
  RateSnapshot? Function(String base) onFetch;
  _FakeProvider(this.id, this.onFetch);

  @override
  Future<RateSnapshot> fetchLatest(String base) async {
    final snapshot = onFetch(base);
    if (snapshot == null) {
      throw const RateUnavailableException('Simulated failure.');
    }
    return snapshot;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InvoiceService invoices;
  late _FakeProvider openErApi;
  late PausalTrackerService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    invoices = InvoiceService();
    openErApi = _FakeProvider('open_er_api', (base) => null);
    final exchangeRates = ExchangeRateService(
      openErApi: openErApi,
      cache: RateCacheService(),
    );
    service = PausalTrackerService(
      invoiceService: invoices,
      exchangeRateService: exchangeRates,
      taxRulesService: TaxRulesService(),
    );
  });

  test('no invoices: both totals are zero and both states are ok', () async {
    final summary = await service.computeSummary(asOf: DateTime(2026, 6, 1));
    expect(summary.calendarYear.totalRsd, 0);
    expect(summary.rollingTwelveMonths.totalRsd, 0);
    expect(summary.excludedCount, 0);
  });

  test('RSD invoices need no conversion and are never excluded', () async {
    await invoices.add(
      clientName: 'Domestic client',
      amount: 100000,
      currencyCode: 'RSD',
      issueDate: DateTime(2026, 3, 1),
      dueDate: DateTime(2026, 3, 15),
    );

    final summary = await service.computeSummary(asOf: DateTime(2026, 6, 1));
    expect(summary.calendarYear.totalRsd, 100000);
    expect(summary.excludedCount, 0);
  });

  test('foreign-currency invoice converts via a captured rate', () async {
    openErApi.onFetch = (base) => RateSnapshot(
          base: 'EUR',
          rates: {'RSD': 117.0},
          asOf: DateTime(2026, 3, 1),
          fetchedAt: DateTime(2026, 3, 1),
          source: 'Fake Source',
        );
    await invoices.add(
      clientName: 'Foreign client',
      amount: 1000,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 3, 1),
      dueDate: DateTime(2026, 3, 15),
    );

    final summary = await service.computeSummary(asOf: DateTime(2026, 6, 1));
    expect(summary.calendarYear.totalRsd, closeTo(117000, 0.01));
    expect(summary.excludedCount, 0);
  });

  test('a captured rate is immutable — a later rate change does not retroactively alter the total', () async {
    openErApi.onFetch = (base) => RateSnapshot(
          base: 'EUR',
          rates: {'RSD': 100.0},
          asOf: DateTime(2026, 3, 1),
          fetchedAt: DateTime(2026, 3, 1),
          source: 'Fake Source',
        );
    await invoices.add(
      clientName: 'Foreign client',
      amount: 1000,
      currencyCode: 'EUR',
      issueDate: DateTime(2026, 3, 1),
      dueDate: DateTime(2026, 3, 15),
    );
    final first = await service.computeSummary(asOf: DateTime(2026, 6, 1));
    expect(first.calendarYear.totalRsd, closeTo(100000, 0.01));

    // The live rate changes, but the already-captured conversion must win.
    openErApi.onFetch = (base) => RateSnapshot(
          base: 'EUR',
          rates: {'RSD': 200.0},
          asOf: DateTime(2026, 6, 1),
          fetchedAt: DateTime(2026, 6, 1),
          source: 'Fake Source',
        );
    final second = await service.computeSummary(asOf: DateTime(2026, 6, 2));
    expect(second.calendarYear.totalRsd, closeTo(100000, 0.01));
  });

  test('an invoice whose rate can never be captured is excluded, not priced at a guess', () async {
    await invoices.add(
      clientName: 'Unreachable rate client',
      amount: 1000,
      currencyCode: 'USD',
      issueDate: DateTime(2026, 3, 1),
      dueDate: DateTime(2026, 3, 15),
    );

    final summary = await service.computeSummary(asOf: DateTime(2026, 6, 1));
    expect(summary.calendarYear.totalRsd, 0);
    expect(summary.excludedCount, 1);
    expect(summary.contributions.single.excluded, isTrue);
  });

  test('an excluded invoice is retried and included once a rate becomes available', () async {
    await invoices.add(
      clientName: 'Late rate client',
      amount: 1000,
      currencyCode: 'USD',
      issueDate: DateTime(2026, 3, 1),
      dueDate: DateTime(2026, 3, 15),
    );
    final first = await service.computeSummary(asOf: DateTime(2026, 6, 1));
    expect(first.excludedCount, 1);

    openErApi.onFetch = (base) => RateSnapshot(
          base: 'USD',
          rates: {'RSD': 105.0},
          asOf: DateTime(2026, 6, 2),
          fetchedAt: DateTime(2026, 6, 2),
          source: 'Fake Source',
        );
    final second = await service.computeSummary(asOf: DateTime(2026, 6, 2));
    expect(second.excludedCount, 0);
    expect(second.calendarYear.totalRsd, closeTo(105000, 0.01));
  });

  group('calendar-year vs rolling-12-month windows', () {
    test('an invoice from 13 months ago is in neither window', () async {
      await invoices.add(
        clientName: 'Old client',
        amount: 500000,
        currencyCode: 'RSD',
        issueDate: DateTime(2025, 4, 1),
        dueDate: DateTime(2025, 4, 15),
      );
      final summary = await service.computeSummary(asOf: DateTime(2026, 6, 1));
      expect(summary.calendarYear.totalRsd, 0);
      expect(summary.rollingTwelveMonths.totalRsd, 0);
    });

    test('an invoice from December last year counts toward the rolling window but not this calendar year', () async {
      await invoices.add(
        clientName: 'Cross-year client',
        amount: 500000,
        currencyCode: 'RSD',
        issueDate: DateTime(2025, 12, 20),
        dueDate: DateTime(2026, 1, 3),
      );
      final summary = await service.computeSummary(asOf: DateTime(2026, 2, 1));
      expect(summary.calendarYear.totalRsd, 0);
      expect(summary.rollingTwelveMonths.totalRsd, 500000);
    });

    test('an invoice from January this year counts toward both windows', () async {
      await invoices.add(
        clientName: 'New-year client',
        amount: 500000,
        currencyCode: 'RSD',
        issueDate: DateTime(2026, 1, 10),
        dueDate: DateTime(2026, 1, 24),
      );
      final summary = await service.computeSummary(asOf: DateTime(2026, 2, 1));
      expect(summary.calendarYear.totalRsd, 500000);
      expect(summary.rollingTwelveMonths.totalRsd, 500000);
    });
  });

  group('threshold states — paušal ceiling (RSD 6,000,000/year, sourced from tax_rules.json)', () {
    Future<void> seed(double amount) => invoices.add(
          clientName: 'c',
          amount: amount,
          currencyCode: 'RSD',
          issueDate: DateTime(2026, 3, 1),
          dueDate: DateTime(2026, 3, 15),
        );

    test('below 70% is ok', () async {
      await seed(4000000);
      final s = await service.computeSummary(asOf: DateTime(2026, 6, 1));
      expect(s.calendarYear.state.name, 'ok');
    });

    test('at exactly 70% is warning70', () async {
      await seed(4200000);
      final s = await service.computeSummary(asOf: DateTime(2026, 6, 1));
      expect(s.calendarYear.state.name, 'warning70');
    });

    test('at exactly 95% is warning95', () async {
      await seed(5700000);
      final s = await service.computeSummary(asOf: DateTime(2026, 6, 1));
      expect(s.calendarYear.state.name, 'warning95');
    });

    test('at or above 100% is exceeded', () async {
      await seed(6000000);
      final s = await service.computeSummary(asOf: DateTime(2026, 6, 1));
      expect(s.calendarYear.state.name, 'exceeded');
    });
  });

  group('projection', () {
    test('no projection with fewer than 14 days of data', () async {
      await invoices.add(
        clientName: 'c',
        amount: 1000000,
        currencyCode: 'RSD',
        issueDate: DateTime(2026, 1, 5),
        dueDate: DateTime(2026, 1, 19),
      );
      final s = await service.computeSummary(asOf: DateTime(2026, 1, 10));
      expect(s.projectedCeilingDate, isNull);
    });

    test('projects a future date at a steady pace with enough data', () async {
      // RSD 100,000/day for 30 days -> RSD 3,000,000 by day 30, well under
      // the 6,000,000 ceiling but on a real, computable pace toward it.
      await invoices.add(
        clientName: 'c',
        amount: 3000000,
        currencyCode: 'RSD',
        issueDate: DateTime(2026, 1, 1),
        dueDate: DateTime(2026, 1, 15),
      );
      final s = await service.computeSummary(asOf: DateTime(2026, 1, 30));
      expect(s.projectedCeilingDate, isNotNull);
      expect(s.projectedCeilingDate!.isAfter(DateTime(2026, 1, 30)), isTrue);
    });

    test('no projection once the ceiling is already exceeded', () async {
      await invoices.add(
        clientName: 'c',
        amount: 7000000,
        currencyCode: 'RSD',
        issueDate: DateTime(2026, 1, 1),
        dueDate: DateTime(2026, 1, 15),
      );
      final s = await service.computeSummary(asOf: DateTime(2026, 1, 30));
      expect(s.projectedCeilingDate, isNull);
    });
  });

  group('assessed monthly amount', () {
    test('defaults to null', () async {
      expect(await service.getAssessedMonthlyAmount(), isNull);
    });

    test('set then get round-trips, and clearing with null removes it', () async {
      await service.setAssessedMonthlyAmount(45000);
      expect(await service.getAssessedMonthlyAmount(), 45000);

      await service.setAssessedMonthlyAmount(null);
      expect(await service.getAssessedMonthlyAmount(), isNull);
    });
  });
}
