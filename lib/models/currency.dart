class Currency {
  final String code;
  final String name;

  const Currency(this.code, this.name);
}

/// Fixed set of currencies the converter offers. RSD is included even
/// though it's routed to a different provider under the hood. BGN is a
/// legacy/pegged entry — Bulgaria adopted the euro 1 Jan 2026 and its rate
/// provider (Frankfurter) has since removed BGN entirely, so it's always
/// computed from the fixed 1.95583 peg (see ExchangeRateService), never
/// live-fetched. Kept for users converting old Bulgarian lev cash/savings.
const List<Currency> supportedCurrencies = [
  Currency('EUR', 'Euro'),
  Currency('USD', 'US Dollar'),
  Currency('GBP', 'British Pound'),
  Currency('CHF', 'Swiss Franc'),
  Currency('RSD', 'Serbian Dinar'),
  Currency('JPY', 'Japanese Yen'),
  Currency('CAD', 'Canadian Dollar'),
  Currency('AUD', 'Australian Dollar'),
  Currency('CNY', 'Chinese Yuan'),
  Currency('TRY', 'Turkish Lira'),
  Currency('BGN', 'Bulgarian Lev (legacy, pegged)'),
];

String currencyName(String code) {
  return supportedCurrencies
      .firstWhere((c) => c.code == code, orElse: () => Currency(code, code))
      .name;
}
