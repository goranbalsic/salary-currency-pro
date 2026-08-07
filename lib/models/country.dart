/// One selectable payroll system within a [Country] that has more than one
/// (currently only Bosnia and Herzegovina, whose two entities — the
/// Federation of BiH and Republika Srpska — run legally separate tax and
/// contribution regimes).
class CountryEntity {
  final String id;
  final String name;
  final String taxConfigAsset;

  const CountryEntity({
    required this.id,
    required this.name,
    required this.taxConfigAsset,
  });
}

/// A country the app supports for payroll calculation. Adding a new
/// country is: write one assets/config/tax/<id>.json file (see
/// lib/models/tax_config.dart for the schema), then add one entry here —
/// no other code changes required unless it needs a formula-based
/// allowance (see lib/logic/allowance_strategies.dart).
class Country {
  final String id;
  final String name;
  final String currencyCode;
  final String currencySymbol;

  /// ISO-ish locale code used to pick this country's default app language.
  final String localeCode;

  final String flagEmoji;

  /// Null when [entities] is non-empty — those countries require picking
  /// an entity before a tax config can be loaded.
  final String? taxConfigAsset;
  final List<CountryEntity>? entities;

  const Country({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.currencySymbol,
    required this.localeCode,
    required this.flagEmoji,
    this.taxConfigAsset,
    this.entities,
  });

  bool get hasEntities => entities != null && entities!.isNotEmpty;
}

const kCountries = <Country>[
  Country(
    id: 'rs',
    name: 'Serbia',
    currencyCode: 'RSD',
    currencySymbol: 'RSD',
    localeCode: 'sr',
    flagEmoji: '🇷🇸',
    taxConfigAsset: 'assets/config/tax/rs.json',
  ),
  Country(
    id: 'hr',
    name: 'Croatia',
    currencyCode: 'EUR',
    currencySymbol: '€',
    localeCode: 'hr',
    flagEmoji: '🇭🇷',
    taxConfigAsset: 'assets/config/tax/hr.json',
  ),
  Country(
    id: 'ba',
    name: 'Bosnia and Herzegovina',
    currencyCode: 'BAM',
    currencySymbol: 'KM',
    localeCode: 'bs',
    flagEmoji: '🇧🇦',
    entities: [
      CountryEntity(
        id: 'fbih',
        name: 'Federation of BiH',
        taxConfigAsset: 'assets/config/tax/ba_fbih.json',
      ),
      CountryEntity(
        id: 'republika_srpska',
        name: 'Republika Srpska',
        taxConfigAsset: 'assets/config/tax/ba_rs.json',
      ),
    ],
  ),
  Country(
    id: 'me',
    name: 'Montenegro',
    currencyCode: 'EUR',
    currencySymbol: '€',
    localeCode: 'sr',
    flagEmoji: '🇲🇪',
    taxConfigAsset: 'assets/config/tax/me.json',
  ),
  Country(
    id: 'mk',
    name: 'North Macedonia',
    currencyCode: 'MKD',
    currencySymbol: 'ден',
    localeCode: 'mk',
    flagEmoji: '🇲🇰',
    taxConfigAsset: 'assets/config/tax/mk.json',
  ),
  Country(
    id: 'si',
    name: 'Slovenia',
    currencyCode: 'EUR',
    currencySymbol: '€',
    localeCode: 'sl',
    flagEmoji: '🇸🇮',
    taxConfigAsset: 'assets/config/tax/si.json',
  ),
  Country(
    id: 'bg',
    // Bulgaria adopted the euro 1 Jan 2026 at the fixed, irrevocable rate
    // 1 EUR = 1.95583 BGN. See DECISIONS.md D-020 and
    // lib/services/bg_euro_migration_service.dart, which migrates any
    // BGN-denominated data saved before this fix, exactly once.
    name: 'Bulgaria',
    currencyCode: 'EUR',
    currencySymbol: '€',
    localeCode: 'bg',
    flagEmoji: '🇧🇬',
    taxConfigAsset: 'assets/config/tax/bg.json',
  ),
  Country(
    id: 'al',
    name: 'Albania',
    currencyCode: 'ALL',
    currencySymbol: 'L',
    localeCode: 'sq',
    flagEmoji: '🇦🇱',
    taxConfigAsset: 'assets/config/tax/al.json',
  ),
  Country(
    id: 'ro',
    name: 'Romania',
    currencyCode: 'RON',
    currencySymbol: 'lei',
    localeCode: 'ro',
    flagEmoji: '🇷🇴',
    taxConfigAsset: 'assets/config/tax/ro.json',
  ),
];

Country countryById(String id) => kCountries.firstWhere((c) => c.id == id);
