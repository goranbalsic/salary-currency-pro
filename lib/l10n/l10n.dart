import 'package:flutter/widgets.dart';

import '../core/format/formats.dart';
import '../features/payroll/domain/payroll_models.dart';
import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Number and date formatting for the active app language.
  Formats get fmt {
    final locale = Localizations.localeOf(this);
    return Formats(locale.languageCode, script: locale.scriptCode);
  }
}

extension L10nNames on AppLocalizations {
  String countryName(String code) => switch (code) {
        'RS' => countryRS,
        'HR' => countryHR,
        'BA' => countryBA,
        'ME' => countryME,
        'MK' => countryMK,
        'SI' => countrySI,
        'BG' => countryBG,
        'RO' => countryRO,
        _ => code,
      };

  String systemName(PayrollSystem s) => switch (s) {
        PayrollSystem.fbih => systemFbih,
        PayrollSystem.republikaSrpska => systemRepublikaSrpska,
        _ => countryName(s.countryCode),
      };

  /// Localized currency name, or null for currencies without one.
  String? currencyName(String code) => switch (code) {
        'EUR' => curEUR,
        'USD' => curUSD,
        'CHF' => curCHF,
        'GBP' => curGBP,
        'RSD' => curRSD,
        'BAM' => curBAM,
        'MKD' => curMKD,
        'RON' => curRON,
        'HUF' => curHUF,
        'CZK' => curCZK,
        'PLN' => curPLN,
        'SEK' => curSEK,
        'NOK' => curNOK,
        'DKK' => curDKK,
        'JPY' => curJPY,
        'CNY' => curCNY,
        'CAD' => curCAD,
        'AUD' => curAUD,
        'TRY' => curTRY,
        'RUB' => curRUB,
        _ => null,
      };
}
