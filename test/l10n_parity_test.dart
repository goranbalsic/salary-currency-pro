import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The app requires exact l10n key parity across all 9 supported
/// languages (project rule, and explicitly re-required by
/// `_userprompts/PROMPT-003F_StageC_Item12_Invoice_PDF_NBS_IPS_QR_Enhanced.md`'s
/// completion-report format) — but until now that was only ever verified
/// manually. This closes that gap with a real automated check.
void main() {
  test('every non-template .arb file has exactly the same key set as '
      'app_en.arb (the template)', () {
    final l10nDir = Directory('lib/l10n');
    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .toList();

    Set<String> realKeys(Map<String, dynamic> json) =>
        json.keys.where((k) => !k.startsWith('@')).toSet();

    final templateFile = arbFiles.firstWhere((f) => f.path.endsWith('app_en.arb'));
    final templateKeys = realKeys(
      jsonDecode(templateFile.readAsStringSync()) as Map<String, dynamic>,
    );
    expect(templateKeys, isNotEmpty);

    for (final file in arbFiles) {
      if (file.path == templateFile.path) continue;
      final keys = realKeys(jsonDecode(file.readAsStringSync()) as Map<String, dynamic>);
      final missing = templateKeys.difference(keys);
      final extra = keys.difference(templateKeys);
      expect(
        missing,
        isEmpty,
        reason: '${file.path} is missing keys present in app_en.arb: $missing',
      );
      expect(
        extra,
        isEmpty,
        reason: '${file.path} has keys not present in app_en.arb: $extra',
      );
    }
  });

  test('exactly 9 locale .arb files exist (en + the 8 translated '
      'languages) — catches an accidentally-added or -removed locale',
      () {
    final l10nDir = Directory('lib/l10n');
    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .toList();
    expect(arbFiles, hasLength(9));
  });
}
