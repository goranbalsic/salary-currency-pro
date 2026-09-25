// Validates a tax_rules.json payload against the schema the app itself
// enforces at runtime (lib/models/freelance_tax_rules.dart). Exits
// non-zero on any failure — this is what the runbook (README.md in this
// directory) tells you to run before every publish.
//
// Usage:
//   dart run tools/rules-publish/validate.dart
//   dart run tools/rules-publish/validate.dart path/to/other_rules.json
//
// Defaults to validating tools/rules-publish/tax_rules.json (the
// publishable copy) when no path is given.

import 'dart:convert';
import 'dart:io';

import 'package:salary_currency_pro/models/freelance_tax_rules.dart';

void main(List<String> args) {
  final path = args.isNotEmpty ? args.first : 'tools/rules-publish/tax_rules.json';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('FAIL: "$path" does not exist.');
    exit(1);
  }

  final String raw;
  try {
    raw = file.readAsStringSync();
  } catch (e) {
    stderr.writeln('FAIL: could not read "$path": $e');
    exit(1);
  }

  final Map<String, dynamic> json;
  try {
    json = jsonDecode(raw) as Map<String, dynamic>;
  } catch (e) {
    stderr.writeln('FAIL: "$path" is not valid JSON: $e');
    exit(1);
  }

  final FreelanceTaxRules rules;
  try {
    rules = FreelanceTaxRules.fromJson(json);
  } on TaxRulesSchemaException catch (e) {
    stderr.writeln('FAIL: schema violation in "$path":');
    stderr.writeln('  $e');
    exit(1);
  }

  final missingRegimes = kFreelanceRegimeIds.where((id) => !rules.regimes.containsKey(id)).toList();
  if (missingRegimes.isNotEmpty) {
    stderr.writeln('FAIL: "$path" is missing required regime(s): ${missingRegimes.join(', ')}');
    exit(1);
  }

  final extraRegimes = rules.regimes.keys.where((id) => !kFreelanceRegimeIds.contains(id)).toList();
  if (extraRegimes.isNotEmpty) {
    stderr.writeln('WARN: "$path" has unexpected regime id(s) not in kFreelanceRegimeIds: ${extraRegimes.join(', ')}');
    // Not a hard failure — a deliberate future addition would show up here
    // before its regime id is registered in the app, which is fine.
  }

  if (DateTime.tryParse(rules.rulesVersion) == null) {
    stderr.writeln('FAIL: rules_version "${rules.rulesVersion}" is not a valid ISO date.');
    exit(1);
  }

  var fieldCount = 0;
  for (final regime in rules.regimes.values) {
    fieldCount += regime.values.length;
  }

  stdout.writeln('OK: "$path" is schema-valid.');
  stdout.writeln('  schema_version: ${rules.schemaVersion}');
  stdout.writeln('  rules_version:  ${rules.rulesVersion}');
  stdout.writeln('  regimes:        ${rules.regimes.length} (${rules.regimes.keys.join(', ')})');
  stdout.writeln('  total fields:   $fieldCount (every one carries effectiveFrom + source)');
}
