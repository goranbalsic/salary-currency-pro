import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:salary_currency_pro/models/freelance_tax_rules.dart';

/// Validates the bundled `assets/config/tax_rules.json` against the schema
/// every freelancer-calculator strategy class depends on — this must fail
/// the build if any regime is missing a required field or any value lacks
/// `effectiveFrom`/`source`, since PROMPT-004 Part 2 states no tax constant
/// may live in Dart code: this file is the only place they're allowed to
/// come from.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FreelanceTaxRules rules;

  setUpAll(() async {
    final raw = await rootBundle.loadString(
      'assets/config/tax_rules.json',
      cache: false,
    );
    rules = FreelanceTaxRules.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  });

  test('parses without throwing and has a positive schema_version', () {
    expect(rules.schemaVersion, greaterThan(0));
  });

  test('rules_version is a valid ISO date', () {
    expect(DateTime.tryParse(rules.rulesVersion), isNotNull);
  });

  test('contains exactly the 10 required regime ids', () {
    expect(rules.regimes.keys.toSet(), kFreelanceRegimeIds.toSet());
  });

  for (final id in kFreelanceRegimeIds) {
    group('regime "$id"', () {
      test('has country/currency/regimeName/sources and a non-empty values map', () {
        final r = rules.regime(id);
        expect(r.countryId, isNotEmpty);
        expect(r.currencyCode, isNotEmpty);
        expect(r.regimeName, isNotEmpty);
        expect(r.sources, isNotEmpty);
        expect(r.values, isNotEmpty);
      });

      test('every value carries a non-empty effectiveFrom and source', () {
        final r = rules.regime(id);
        for (final entry in r.values.entries) {
          expect(
            entry.value.effectiveFrom,
            isNotEmpty,
            reason: '$id.${entry.key} is missing effectiveFrom',
          );
          expect(
            DateTime.tryParse(entry.value.effectiveFrom),
            isNotNull,
            reason: '$id.${entry.key}.effectiveFrom is not a valid ISO date',
          );
          expect(
            entry.value.source,
            isNotEmpty,
            reason: '$id.${entry.key} is missing source',
          );
          expect(
            Uri.tryParse(entry.value.source)?.hasScheme,
            isTrue,
            reason: '$id.${entry.key}.source is not a valid URL',
          );
        }
      });
    });
  }

  test('a malformed payload (missing source) fails to parse via tryParse', () {
    const badJson = '''
    {
      "schema_version": 1,
      "rules_version": "2026-01-01",
      "regimes": {
        "rs": {
          "country": "rs",
          "currency": "RSD",
          "regimeName": "Test",
          "sources": ["https://example.com"],
          "values": {
            "taxRate": {"value": 0.1, "effectiveFrom": "2026-01-01"}
          }
        }
      }
    }
    ''';
    expect(FreelanceTaxRules.tryParse(badJson), isNull);
  });

  test('a value that is genuinely n.a. is represented as value: null, not omitted or zero', () {
    // Albania's deemed-expense percentages for turnover <= 10M are a sourced
    // gap per PROMPT-004's seed data — must render as "not available".
    final al = rules.regime('al');
    final field = al.field('deemedExpensePercentTurnoverUpTo10M');
    expect(field.isAvailable, isFalse);
    expect(field.value, isNull);
    expect(field.effectiveFrom, isNotEmpty);
    expect(field.source, isNotEmpty);
  });
}
