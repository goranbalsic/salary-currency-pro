import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/services/tax_rules_service.dart';

/// Exercises PROMPT-004 Part 2's fetch policy: at most once per 24h, a short
/// timeout, and — critically — that every failure mode leaves the previous
/// good copy in use rather than surfacing an error or a partial update.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  String rulesJson(String version) => '''
  {
    "schema_version": 1,
    "rules_version": "$version",
    "regimes": {
      "rs": {
        "country": "rs",
        "currency": "RSD",
        "regimeName": "Test",
        "sources": ["https://example.com"],
        "values": {
          "taxRate": {"value": 0.1, "effectiveFrom": "2026-01-01", "source": "https://example.com"}
        }
      }
    }
  }
  ''';

  test('load() with no prior fetch returns the bundled copy', () async {
    final service = TaxRulesService(client: MockClient((_) async => http.Response('', 500)));
    final loaded = await service.load();
    expect(loaded.source, FreelanceTaxRulesSource.bundle);
    expect(loaded.rules.regimes.keys, contains('rs'));
  });

  test('a newer fetched rules_version is applied on the next load()', () async {
    final bundled = await TaxRulesService(client: MockClient((_) async => http.Response('', 500))).load();
    final newer = DateTime.parse(bundled.rules.rulesVersion).add(const Duration(days: 30));
    final newerIso = newer.toIso8601String().split('T').first;

    final service = TaxRulesService(
      client: MockClient((_) async => http.Response(rulesJson(newerIso), 200)),
    );
    await service.refreshInBackground();

    final loaded = await service.load();
    expect(loaded.source, FreelanceTaxRulesSource.updated);
    expect(loaded.rules.rulesVersion, newerIso);
  });

  test('an older fetched rules_version is ignored — bundled copy stays in use', () async {
    final service = TaxRulesService(
      client: MockClient((_) async => http.Response(rulesJson('2000-01-01'), 200)),
    );
    await service.refreshInBackground();

    final loaded = await service.load();
    expect(loaded.source, FreelanceTaxRulesSource.bundle);
  });

  test('malformed JSON from the server is ignored — bundled copy stays in use', () async {
    final service = TaxRulesService(
      client: MockClient((_) async => http.Response('{not valid json', 200)),
    );
    await service.refreshInBackground();

    final loaded = await service.load();
    expect(loaded.source, FreelanceTaxRulesSource.bundle);
  });

  test('a schema violation (missing source on a value) from the server is ignored', () async {
    const missingSource = '''
    {
      "schema_version": 1,
      "rules_version": "2099-01-01",
      "regimes": {
        "rs": {
          "country": "rs", "currency": "RSD", "regimeName": "Test",
          "sources": ["https://example.com"],
          "values": { "taxRate": {"value": 0.1, "effectiveFrom": "2026-01-01"} }
        }
      }
    }
    ''';
    final service = TaxRulesService(
      client: MockClient((_) async => http.Response(missingSource, 200)),
    );
    await service.refreshInBackground();

    final loaded = await service.load();
    expect(loaded.source, FreelanceTaxRulesSource.bundle);
  });

  test('a network timeout is ignored — bundled copy stays in use', () async {
    final service = TaxRulesService(
      client: MockClient((_) async {
        await Future<void>.delayed(const Duration(seconds: 6));
        return http.Response(rulesJson('2099-01-01'), 200);
      }),
    );
    await service.refreshInBackground();

    final loaded = await service.load();
    expect(loaded.source, FreelanceTaxRulesSource.bundle);
  }, timeout: const Timeout(Duration(seconds: 10)));

  test('an HTTP error status is ignored — bundled copy stays in use', () async {
    final service = TaxRulesService(
      client: MockClient((_) async => http.Response('', 404)),
    );
    await service.refreshInBackground();

    final loaded = await service.load();
    expect(loaded.source, FreelanceTaxRulesSource.bundle);
  });

  test('a second refresh within 24h of the first does not re-fetch', () async {
    var callCount = 0;
    final service = TaxRulesService(
      client: MockClient((_) async {
        callCount++;
        return http.Response('', 500);
      }),
    );
    await service.refreshInBackground();
    await service.refreshInBackground();
    expect(callCount, 1);
  });
}
