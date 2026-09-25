import 'package:flutter/material.dart';

import '../../core/storage/store.dart';
import '../payroll/domain/payroll_models.dart';

/// A country the app supports as "home": it sets the default payroll
/// system, home currency, VAT rates and which country-specific tools show.
class HomeCountry {
  const HomeCountry(this.code, this.currency);
  final String code;
  final String currency;

  static const all = <HomeCountry>[
    HomeCountry('RS', 'RSD'),
    HomeCountry('HR', 'EUR'),
    HomeCountry('BA', 'BAM'),
    HomeCountry('ME', 'EUR'),
    HomeCountry('MK', 'MKD'),
    HomeCountry('SI', 'EUR'),
    HomeCountry('BG', 'EUR'),
    HomeCountry('RO', 'RON'),
  ];

  static HomeCountry byCode(String? code) => all.firstWhere((c) => c.code == code, orElse: () => all.first);
}

/// Languages the app ships in. Serbian comes in both scripts.
enum AppLanguage {
  en('en'),
  srLatn('sr', 'Latn'),
  srCyrl('sr', 'Cyrl'),
  hr('hr'),
  bs('bs'),
  sl('sl'),
  mk('mk'),
  bg('bg'),
  ro('ro');

  const AppLanguage(this.languageCode, [this.scriptCode]);
  final String languageCode;
  final String? scriptCode;

  Locale get locale => Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode);

  /// Native name, shown the same in every UI language.
  String get nativeName => switch (this) {
        AppLanguage.en => 'English',
        AppLanguage.srLatn => 'Srpski (latinica)',
        AppLanguage.srCyrl => 'Српски (ћирилица)',
        AppLanguage.hr => 'Hrvatski',
        AppLanguage.bs => 'Bosanski',
        AppLanguage.sl => 'Slovenščina',
        AppLanguage.mk => 'Македонски',
        AppLanguage.bg => 'Български',
        AppLanguage.ro => 'Română',
      };

  static AppLanguage? byName(String? name) => AppLanguage.values.where((l) => l.name == name).firstOrNull;

  /// Best match for a device locale; Serbian without an explicit Latin
  /// script means Cyrillic, which is the Android default for "sr".
  static AppLanguage fromLocale(Locale? l) {
    if (l == null) return AppLanguage.en;
    switch (l.languageCode) {
      case 'sr':
        if (l.scriptCode == 'Latn' || l.countryCode == 'ME') return AppLanguage.srLatn;
        return AppLanguage.srCyrl;
      case 'sh' || 'cnr':
        return AppLanguage.srLatn;
      case 'hr':
        return AppLanguage.hr;
      case 'bs':
        return AppLanguage.bs;
      case 'sl':
        return AppLanguage.sl;
      case 'mk':
        return AppLanguage.mk;
      case 'bg':
        return AppLanguage.bg;
      case 'ro':
        return AppLanguage.ro;
      default:
        return AppLanguage.en;
    }
  }

  /// The first of the device's preferred languages that the app ships in,
  /// so "German, then Serbian" opens in Serbian rather than English.
  static AppLanguage fromLocales(List<Locale>? locales) {
    for (final l in locales ?? const <Locale>[]) {
      final match = fromLocale(l);
      if (match != AppLanguage.en || l.languageCode == 'en') return match;
    }
    return AppLanguage.en;
  }

  /// Default country for a language when the device region is unknown.
  String get defaultCountry => switch (this) {
        AppLanguage.hr => 'HR',
        AppLanguage.bs => 'BA',
        AppLanguage.sl => 'SI',
        AppLanguage.mk => 'MK',
        AppLanguage.bg => 'BG',
        AppLanguage.ro => 'RO',
        _ => 'RS',
      };
}

class SettingsController extends ChangeNotifier {
  SettingsController(this._store) {
    _load();
  }

  final Store _store;
  static const _key = 'settings.v1';

  String? _country;
  AppLanguage? _language;
  ThemeMode _theme = ThemeMode.system;
  bool _onboarded = false;
  PayrollSystem? _payrollSystem;
  bool _annualView = false;

  bool get onboarded => _onboarded;
  ThemeMode get themeMode => _theme;

  /// Null means "follow the device language".
  AppLanguage? get language => _language;
  HomeCountry get country => HomeCountry.byCode(_country);
  bool get hasCountry => _country != null;
  String get homeCurrency => country.currency;
  bool get annualView => _annualView;

  /// Payroll system shown by default (Bosnia has two).
  PayrollSystem get payrollSystem {
    final chosen = _payrollSystem;
    if (chosen != null && chosen.countryCode == country.code) return chosen;
    return PayrollSystem.defaultFor(country.code) ?? PayrollSystem.serbia;
  }

  void _load() {
    final raw = _store.readJson(_key);
    if (raw is! Map) return;
    final c = raw['country'];
    if (c is String && HomeCountry.all.any((h) => h.code == c)) _country = c;
    _language = AppLanguage.byName(raw['language'] as String?);
    _theme = ThemeMode.values.where((m) => m.name == raw['theme']).firstOrNull ?? ThemeMode.system;
    _onboarded = raw['onboarded'] == true && _country != null;
    _payrollSystem = PayrollSystem.byName(raw['payroll'] as String?);
    _annualView = raw['annual'] == true;
  }

  Future<void> _save() => _store.writeJson(_key, {
        'country': _country,
        'language': _language?.name,
        'theme': _theme.name,
        'onboarded': _onboarded,
        'payroll': _payrollSystem?.name,
        'annual': _annualView,
      });

  Future<void> setCountry(String code) async {
    if (!HomeCountry.all.any((h) => h.code == code)) return;
    _country = code;
    if (_payrollSystem != null && _payrollSystem!.countryCode != code) _payrollSystem = null;
    notifyListeners();
    await _save();
  }

  Future<void> setLanguage(AppLanguage? language) async {
    _language = language;
    notifyListeners();
    await _save();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _theme = mode;
    notifyListeners();
    await _save();
  }

  Future<void> setPayrollSystem(PayrollSystem system) async {
    _payrollSystem = system;
    notifyListeners();
    await _save();
  }

  Future<void> setAnnualView(bool value) async {
    _annualView = value;
    notifyListeners();
    await _save();
  }

  Future<void> completeOnboarding({required String country, required AppLanguage? language}) async {
    _country = country;
    _language = language;
    _onboarded = true;
    notifyListeners();
    await _save();
  }

  /// Called after a backup restore or data reset.
  void reload() {
    _country = null;
    _language = null;
    _theme = ThemeMode.system;
    _onboarded = false;
    _payrollSystem = null;
    _annualView = false;
    _load();
    notifyListeners();
  }
}
