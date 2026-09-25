import 'dart:convert';
import 'dart:io';

import 'package:bilans/l10n/gen/app_localizations.dart';
import 'package:bilans/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Messages per ARB file, without `@` metadata.
Map<String, String> _messages(File f) {
  final data = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final e in data.entries)
      if (!e.key.startsWith('@')) e.key: e.value as String,
  };
}

/// Top-level argument names: `{amount}` and `{count, plural, …}`.
Set<String> _arguments(String message) {
  final names = <String>{};
  var depth = 0;
  for (var i = 0; i < message.length; i++) {
    final ch = message[i];
    if (ch == '{') {
      if (depth == 0) {
        final m = RegExp(r'^\{\s*([A-Za-z_]\w*)\s*[,}]').firstMatch(message.substring(i));
        if (m != null) names.add(m.group(1)!);
      }
      depth++;
    } else if (ch == '}') {
      depth--;
    }
  }
  return names;
}

/// Plural categories of a `{x, plural, …}` message, or null.
List<String>? _pluralCases(String message) {
  final m = RegExp(r'^\{\s*\w+\s*,\s*plural\s*,(.*)\}$', dotAll: true).firstMatch(message.trim());
  if (m == null) return null;
  final body = m.group(1)!;
  final cases = <String>[];
  var i = 0;
  while (i < body.length) {
    final c = RegExp(r'^\s*(=\d+|zero|one|two|few|many|other)\s*\{').firstMatch(body.substring(i));
    if (c == null) break;
    cases.add(c.group(1)!);
    i += c.end;
    var depth = 1;
    while (i < body.length && depth > 0) {
      if (body[i] == '{') depth++;
      if (body[i] == '}') depth--;
      i++;
    }
  }
  return cases;
}

const _pluralCategories = {
  'en': {'one', 'other'},
  'sr': {'one', 'few', 'other'},
  'sr_Latn': {'one', 'few', 'other'},
  'hr': {'one', 'few', 'other'},
  'bs': {'one', 'few', 'other'},
  'sl': {'one', 'two', 'few', 'other'},
  'mk': {'one', 'other'},
  'bg': {'one', 'other'},
  'ro': {'one', 'few', 'other'},
};

void main() {
  final dir = Directory('lib/l10n');
  final arbs = {
    for (final f in dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb')))
      f.uri.pathSegments.last.replaceAll(RegExp(r'^app_|\.arb$'), ''): f,
  };
  final english = _messages(arbs['en']!);

  test('every language in the app has an ARB file, and vice versa', () {
    final expected = {
      for (final l in AppLanguage.values)
        switch (l) {
          AppLanguage.srLatn => 'sr_Latn',
          AppLanguage.srCyrl => 'sr',
          _ => l.languageCode,
        },
    };
    expect(arbs.keys.toSet(), expected);
  });

  for (final lang in arbs.keys.where((k) => k != 'en')) {
    group('$lang translation', () {
      final messages = _messages(arbs[lang]!);

      test('has exactly the English keys', () {
        expect(messages.keys.toSet().difference(english.keys.toSet()), isEmpty, reason: 'extra keys');
        expect(english.keys.toSet().difference(messages.keys.toSet()), isEmpty, reason: 'missing keys');
      });

      test('uses the same placeholders as English', () {
        for (final key in english.keys) {
          final message = messages[key];
          if (message == null) continue;
          expect(message.trim(), isNotEmpty, reason: key);
          expect(_arguments(message), _arguments(english[key]!), reason: key);
        }
      });

      test('plurals cover every category the language has', () {
        for (final key in english.keys) {
          if (_pluralCases(english[key]!) == null) continue;
          final cases = _pluralCases(messages[key]!);
          expect(cases, isNotNull, reason: '$key is not a plural');
          expect(cases!.toSet(), containsAll(_pluralCategories[lang]!), reason: key);
        }
      });

      test('matches its source fragments (run tool/l10n/merge.py after editing)', () {
        final merged = <String, String>{};
        final fragments = Directory('tool/l10n/$lang').listSync().whereType<File>().toList()..sort((a, b) => a.path.compareTo(b.path));
        for (final f in fragments) {
          merged.addAll(_messages(f));
        }
        expect(messages, merged);
      });
    });
  }

  group('locale resolution', () {
    test('Serbian: Latin when asked for, Cyrillic by default', () {
      expect(AppLanguage.fromLocale(const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn')), AppLanguage.srLatn);
      expect(AppLanguage.fromLocale(const Locale('sr', 'RS')), AppLanguage.srCyrl);
      expect(AppLanguage.fromLocale(const Locale('sr', 'ME')), AppLanguage.srLatn);
      expect(AppLanguage.fromLocale(const Locale('cnr')), AppLanguage.srLatn);
    });

    test('unsupported languages fall back to English', () {
      expect(AppLanguage.fromLocale(const Locale('de', 'DE')), AppLanguage.en);
      expect(AppLanguage.fromLocale(null), AppLanguage.en);
    });

    test('the first supported language in the device list wins', () {
      expect(AppLanguage.fromLocales(const [Locale('de'), Locale('hr', 'HR')]), AppLanguage.hr);
      expect(AppLanguage.fromLocales(const [Locale('en', 'GB'), Locale('sr')]), AppLanguage.en);
      expect(AppLanguage.fromLocales(const [Locale('fr'), Locale('it')]), AppLanguage.en);
      expect(AppLanguage.fromLocales(null), AppLanguage.en);
    });

    test('every app language loads its strings and Material localizations', () async {
      for (final lang in AppLanguage.values) {
        final l = lookupAppLocalizations(lang.locale);
        expect(l.appName, 'Bilans');
        expect(GlobalMaterialLocalizations.delegate.isSupported(lang.locale), isTrue, reason: lang.name);
        final material = await GlobalMaterialLocalizations.delegate.load(lang.locale);
        expect(material.okButtonLabel, isNotEmpty);
      }
      // Cyrillic and Latin Serbian really are different scripts.
      expect(lookupAppLocalizations(AppLanguage.srCyrl.locale).navPayroll, 'Плата');
      expect(lookupAppLocalizations(AppLanguage.srLatn.locale).navPayroll, 'Plata');
    });
  });

  test('plural messages format every count in every language', () {
    const counts = [0, 1, 2, 3, 4, 5, 7, 11, 14, 20, 21, 22, 25, 101, 102, 111, 365];
    for (final lang in AppLanguage.values) {
      final l = lookupAppLocalizations(lang.locale);
      for (final n in counts) {
        final outputs = [
          l.commonMonthsCount(n),
          l.commonYearsCount(n),
          l.bizFreeLeft(n),
          l.pausalMissingRate(n),
          l.beUnitsValue(n, '$n'),
          l.teamMembers(n),
          l.loanScheduleAll(n),
          l.proTrialNote(n),
          l.proStartTrial(n),
          l.proSummaryTrial(n, '9,99 €', 'x'),
        ];
        for (final s in outputs) {
          expect(s, contains('$n'), reason: '${lang.name} $n: $s');
          expect(s, isNot(contains('{')), reason: '${lang.name} $n: $s');
        }
      }
    }
  });
}
