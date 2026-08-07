import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// PROMPT-005 Part 2: the bundled copy (`assets/config/tax_rules.json`,
/// what ships in the app) and the publishable copy
/// (`tools/rules-publish/tax_rules.json`, what gets pushed to the public
/// rules repo per `tools/rules-publish/README.md`) must never silently
/// drift apart — this is the guard for that. If this test fails, one of
/// the two files was edited without copying the change to the other; fix
/// by making them identical again, not by changing this test.
void main() {
  test('bundled and publishable tax_rules.json are byte-identical', () {
    final bundled = File('assets/config/tax_rules.json');
    final publishable = File('tools/rules-publish/tax_rules.json');

    expect(bundled.existsSync(), isTrue, reason: 'assets/config/tax_rules.json is missing');
    expect(publishable.existsSync(), isTrue, reason: 'tools/rules-publish/tax_rules.json is missing');

    final bundledBytes = bundled.readAsBytesSync();
    final publishableBytes = publishable.readAsBytesSync();

    expect(
      publishableBytes,
      equals(bundledBytes),
      reason: 'The bundled and publishable copies of tax_rules.json have '
          'drifted apart — edit one and copy it over the other (see '
          'tools/rules-publish/README.md), never edit them independently.',
    );
  });
}
