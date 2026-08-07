import 'dart:convert';

/// Thrown when a freelance-tax-rules JSON payload doesn't match the schema
/// this app requires — missing fields, or a numeric field missing its
/// mandatory `effectiveFrom`/`source` provenance. The bundled asset must
/// never trigger this (it would be a build-time content bug); a remote
/// payload that triggers this is simply discarded by [TaxRulesService],
/// never surfaced to the user.
class TaxRulesSchemaException implements Exception {
  final String message;
  const TaxRulesSchemaException(this.message);

  @override
  String toString() => 'TaxRulesSchemaException: $message';
}

/// One sourced, dated fact inside a regime — every field in a regime's
/// `values` map is one of these, never a bare number, so no tax constant can
/// silently lose its provenance. [value] may be `null` to represent a
/// genuine `n.a.` research gap (see PROMPT-004's seed data) — callers must
/// render that as "not available", never as zero.
class RuleValue {
  final dynamic value;
  final String effectiveFrom;
  final String source;

  const RuleValue({
    required this.value,
    required this.effectiveFrom,
    required this.source,
  });

  bool get isAvailable => value != null;

  double? get asDouble => value == null ? null : (value as num).toDouble();
  int? get asInt => value == null ? null : (value as num).toInt();
  bool? get asBool => value as bool?;
  String? get asString => value as String?;

  /// For fields whose value is a small table (tax brackets, deemed-expense
  /// bands, ...) — the effectiveFrom/source on the field applies to the
  /// whole table as one sourced unit, not to each row individually.
  List<Map<String, dynamic>>? get asMapList => value == null
      ? null
      : (value as List).map((e) => (e as Map).cast<String, dynamic>()).toList();

  factory RuleValue.fromJson(String fieldPath, dynamic json) {
    if (json is! Map ||
        !json.containsKey('value') ||
        json['effectiveFrom'] is! String ||
        (json['effectiveFrom'] as String).isEmpty ||
        json['source'] is! String ||
        (json['source'] as String).isEmpty) {
      throw TaxRulesSchemaException(
        'Field "$fieldPath" must be an object with "value", "effectiveFrom", '
        'and "source" — a value that is genuinely unknown must still carry '
        '"value": null plus a real effectiveFrom/source, not be omitted.',
      );
    }
    return RuleValue(
      value: json['value'],
      effectiveFrom: json['effectiveFrom'] as String,
      source: json['source'] as String,
    );
  }
}

/// One selectable freelancer self-assessment regime (roughly one per
/// country, except Bosnia and Herzegovina which is split into `ba_fbih` and
/// `ba_rs` since the two entities run legally separate regimes).
class FreelanceRegimeRules {
  final String regimeId;
  final String countryId;
  final String currencyCode;
  final String regimeName;
  final String? filingForm;
  final List<String> sources;
  final Map<String, RuleValue> values;

  const FreelanceRegimeRules({
    required this.regimeId,
    required this.countryId,
    required this.currencyCode,
    required this.regimeName,
    required this.sources,
    required this.values,
    this.filingForm,
  });

  /// Looks up a required field; throws [TaxRulesSchemaException] if a regime
  /// is missing a field its strategy class needs — this is how "no tax
  /// constant may live in Dart code" is enforced at runtime: a strategy
  /// class can only ever read a number that came from this JSON.
  RuleValue field(String name) {
    final v = values[name];
    if (v == null) {
      throw TaxRulesSchemaException(
        'Regime "$regimeId" is missing required field "$name".',
      );
    }
    return v;
  }

  factory FreelanceRegimeRules.fromJson(
    String regimeId,
    Map<String, dynamic> json,
  ) {
    final country = json['country'];
    final currency = json['currency'];
    final regimeName = json['regimeName'];
    final sourcesJson = json['sources'];
    final valuesJson = json['values'];

    if (country is! String || country.isEmpty) {
      throw TaxRulesSchemaException('Regime "$regimeId" missing "country".');
    }
    if (currency is! String || currency.isEmpty) {
      throw TaxRulesSchemaException('Regime "$regimeId" missing "currency".');
    }
    if (regimeName is! String || regimeName.isEmpty) {
      throw TaxRulesSchemaException(
        'Regime "$regimeId" missing "regimeName".',
      );
    }
    if (sourcesJson is! List || sourcesJson.isEmpty) {
      throw TaxRulesSchemaException('Regime "$regimeId" missing "sources".');
    }
    if (valuesJson is! Map || valuesJson.isEmpty) {
      throw TaxRulesSchemaException('Regime "$regimeId" missing "values".');
    }

    final values = <String, RuleValue>{};
    for (final entry in valuesJson.entries) {
      values[entry.key as String] =
          RuleValue.fromJson('$regimeId.${entry.key}', entry.value);
    }

    return FreelanceRegimeRules(
      regimeId: regimeId,
      countryId: country,
      currencyCode: currency,
      regimeName: regimeName,
      filingForm: json['filingForm'] as String?,
      sources: sourcesJson.cast<String>(),
      values: values,
    );
  }
}

/// Root of `tax_rules.json` — see PROMPT-004 Part 2. A [rulesVersion] newer
/// than the currently-effective one (compared as an ISO date) is what makes
/// [TaxRulesService] adopt a freshly-downloaded copy.
class FreelanceTaxRules {
  final int schemaVersion;
  final String rulesVersion;
  final Map<String, FreelanceRegimeRules> regimes;

  const FreelanceTaxRules({
    required this.schemaVersion,
    required this.rulesVersion,
    required this.regimes,
  });

  FreelanceRegimeRules regime(String regimeId) {
    final r = regimes[regimeId];
    if (r == null) {
      throw TaxRulesSchemaException('Unknown freelance tax regime "$regimeId".');
    }
    return r;
  }

  static FreelanceTaxRules fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schema_version'];
    final rulesVersion = json['rules_version'];
    final regimesJson = json['regimes'];

    if (schemaVersion is! int) {
      throw const TaxRulesSchemaException(
        'Missing or invalid "schema_version".',
      );
    }
    if (rulesVersion is! String || rulesVersion.isEmpty) {
      throw const TaxRulesSchemaException(
        'Missing or invalid "rules_version".',
      );
    }
    if (regimesJson is! Map || regimesJson.isEmpty) {
      throw const TaxRulesSchemaException('Missing or empty "regimes".');
    }

    final regimes = <String, FreelanceRegimeRules>{};
    for (final entry in regimesJson.entries) {
      regimes[entry.key as String] = FreelanceRegimeRules.fromJson(
        entry.key as String,
        (entry.value as Map).cast<String, dynamic>(),
      );
    }

    return FreelanceTaxRules(
      schemaVersion: schemaVersion,
      rulesVersion: rulesVersion,
      regimes: regimes,
    );
  }

  /// Non-throwing parse for untrusted remote payloads — any schema problem
  /// (malformed JSON, wrong types, a missing effectiveFrom/source anywhere)
  /// returns null so [TaxRulesService] can silently keep the previous good
  /// copy rather than propagate a partial/broken update.
  static FreelanceTaxRules? tryParse(String raw) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }
}

/// The 10 regime ids every valid `tax_rules.json` must contain — used by the
/// schema test and by the country/regime picker UI.
const List<String> kFreelanceRegimeIds = [
  'rs',
  'bg',
  'hr',
  'ba_fbih',
  'ba_rs',
  'me',
  'mk',
  'si',
  'al',
  'ro',
];
