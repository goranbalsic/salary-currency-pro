import 'package:bilans/core/storage/store.dart';
import 'package:bilans/features/fx/data/rate_api.dart';
import 'package:bilans/features/fx/data/rates_controller.dart';
import 'package:bilans/features/fx/domain/rates.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final nbsTable = RateTable(
  source: RateSource.nbs,
  base: 'RSD',
  date: DateTime(2026, 9, 25),
  fetchedAt: DateTime(2026, 9, 25, 9),
  quotes: const {
    'EUR': Quote(middle: 117.4831, buy: 117.1307, sell: 117.8355),
    'USD': Quote(middle: 103.2818, buy: 102.972, sell: 103.5916),
    'BAM': Quote(middle: 60.0682, buy: 59.888, sell: 60.2484),
    'MKD': Quote(middle: 1.8976, buy: 1.8919, sell: 1.9033),
    'HUF': Quote(middle: 0.321045, buy: 0.320082, sell: 0.322008),
  },
);

final ecbTable = RateTable(
  source: RateSource.ecb,
  base: 'EUR',
  date: DateTime(2026, 9, 25),
  fetchedAt: DateTime(2026, 9, 25, 16),
  quotes: const {
    'USD': Quote(middle: 1.1375),
    'CHF': Quote(middle: 0.9435),
    'GBP': Quote(middle: 0.8608),
    'RON': Quote(middle: 5.0791),
    'HUF': Quote(middle: 366.2),
  },
);

class FakeRateApi implements RateApi {
  RateTable? nbs;
  RateTable? ecb;
  int nbsCalls = 0;
  RatePoint? dated;

  @override
  Future<RateTable> fetchNbs() async {
    nbsCalls++;
    final t = nbs;
    if (t == null) throw const RateFetchException('offline');
    return t;
  }

  @override
  Future<RateTable> fetchEcb() async {
    final t = ecb;
    if (t == null) throw const RateFetchException('offline');
    return t;
  }

  @override
  Future<RatePoint> fetchNbsOn(String code, DateTime date) async {
    final d = dated;
    if (d == null) throw const RateFetchException('offline');
    return d;
  }

  @override
  Future<List<RatePoint>> history(RateSource source, String code, DateTime from, DateTime to) async => [RatePoint(from, 1), RatePoint(to, 2)];
}

void main() {
  group('RateBook routing', () {
    final book = RateBook(nbs: nbsTable, ecb: ecbTable);

    test('dinar pairs use the NBS, with buying and selling rates', () {
      expect(book.rate('EUR', 'RSD')!.rate, 117.4831);
      expect(book.rate('EUR', 'RSD')!.source, RateSource.nbs);
      expect(book.rate('EUR', 'RSD', RateKind.buy)!.rate, 117.1307);
      expect(book.rate('RSD', 'EUR', RateKind.sell)!.rate, closeTo(1 / 117.8355, 1e-12));
      expect(book.convert(100, 'EUR', 'RSD')!.result, closeTo(11748.31, 1e-9));
    });

    test('euro crosses use the ECB, with the mark peg', () {
      expect(book.rate('EUR', 'USD')!.rate, closeTo(1.1375, 1e-12));
      expect(book.rate('EUR', 'USD')!.source, RateSource.ecb);
      expect(book.rate('BAM', 'EUR')!.rate, closeTo(1 / 1.95583, 1e-12));
      expect(book.rate('USD', 'CHF')!.rate, closeTo(0.9435 / 1.1375, 1e-12));
      expect(book.convert(100, 'USD', 'CHF')!.cross, isTrue);
    });

    test('currencies the ECB lacks fall back to NBS cross rates', () {
      final r = book.rate('MKD', 'EUR')!;
      expect(r.source, RateSource.nbs);
      expect(r.rate, closeTo(1.8976 / 117.4831, 1e-12));
    });

    test('unknown currencies and same-currency conversions', () {
      expect(book.rate('XYZ', 'EUR'), isNull);
      expect(book.rate('EUR', 'EUR')!.rate, 1);
      expect(const RateBook().rate('EUR', 'RSD'), isNull);
      expect(const RateBook().isEmpty, isTrue);
    });

    test('tables survive a JSON round trip and drop bad quotes', () {
      final back = RateTable.fromJson(nbsTable.toJson())!;
      expect(back.quotes['EUR']!.sell, 117.8355);
      final json = nbsTable.toJson();
      (json['quotes']! as Map)['BAD'] = {'m': -1};
      expect(RateTable.fromJson(json)!.quotes.containsKey('BAD'), isFalse);
      expect(RateTable.fromJson({'source': 'nbs'}), isNull);
    });
  });

  group('RatesController', () {
    late Store store;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      store = await Store.open();
    });

    test('refresh stores both tables and serves them after a restart', () async {
      final api = FakeRateApi()
        ..nbs = nbsTable
        ..ecb = ecbTable;
      final rates = RatesController(store, api);
      await rates.refresh();
      expect(rates.status, RatesStatus.ok);
      expect(rates.book.rate('EUR', 'RSD')!.rate, 117.4831);
      final restarted = RatesController(store, FakeRateApi());
      expect(restarted.hasData, isTrue);
      expect(restarted.book.rate('EUR', 'USD')!.rate, closeTo(1.1375, 1e-12));
    });

    test('a failed refresh keeps the cached rates and reports offline', () async {
      final api = FakeRateApi()..nbs = nbsTable;
      final rates = RatesController(store, api);
      await rates.refresh();
      api.nbs = null;
      await rates.refresh(force: true);
      expect(rates.status, RatesStatus.offline);
      expect(rates.book.rate('EUR', 'RSD')!.rate, 117.4831);
    });

    test('refreshes are throttled unless forced, and never run twice at once', () async {
      final api = FakeRateApi()..nbs = nbsTable;
      final rates = RatesController(store, api);
      await Future.wait([rates.refresh(), rates.refresh()]);
      expect(api.nbsCalls, 1);
      await rates.refresh();
      expect(api.nbsCalls, 1);
      await rates.refresh(force: true);
      expect(api.nbsCalls, 2);
    });

    test('dated NBS rates: dinar is 1, the future is unknown', () async {
      final api = FakeRateApi()..dated = RatePoint(DateTime(2026, 9, 1), 117.2);
      final rates = RatesController(store, api);
      expect((await rates.nbsRateOn('RSD', DateTime(2026, 1, 1)))!.value, 1);
      expect(await rates.nbsRateOn('EUR', DateTime.now().add(const Duration(days: 3))), isNull);
      expect((await rates.nbsRateOn('EUR', DateTime(2026, 9, 1)))!.value, 117.2);
      api.dated = null;
      expect((await rates.nbsRateOn('EUR', DateTime(2026, 9, 1)))!.value, 117.2, reason: 'cached');
      await expectLater(rates.nbsRateOn('USD', DateTime(2026, 9, 1)), throwsA(isA<RateFetchException>()));
    });
  });
}
