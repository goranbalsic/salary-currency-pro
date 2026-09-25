import '../../../core/money/money.dart';

/// A payroll system the app can compute. Bosnia and Herzegovina has two
/// legally separate systems (the Federation and Republika Srpska).
enum PayrollSystem {
  serbia(countryCode: 'RS', currency: 'RSD', decimals: 2),
  croatia(countryCode: 'HR', currency: 'EUR', decimals: 2),
  slovenia(countryCode: 'SI', currency: 'EUR', decimals: 2),
  fbih(countryCode: 'BA', currency: 'BAM', decimals: 2),
  republikaSrpska(countryCode: 'BA', currency: 'BAM', decimals: 2),
  montenegro(countryCode: 'ME', currency: 'EUR', decimals: 2),
  northMacedonia(countryCode: 'MK', currency: 'MKD', decimals: 0),
  bulgaria(countryCode: 'BG', currency: 'EUR', decimals: 2),
  romania(countryCode: 'RO', currency: 'RON', decimals: 0);

  const PayrollSystem({
    required this.countryCode,
    required this.currency,
    required this.decimals,
  });

  /// ISO 3166-1 alpha-2 code of the country this system belongs to.
  final String countryCode;

  /// ISO 4217 currency the system's amounts are expressed in.
  final String currency;

  /// Minor-unit precision payroll amounts are rounded to. North Macedonia
  /// and Romania compute payroll in whole denars / lei.
  final int decimals;

  static PayrollSystem? byName(String? name) {
    for (final s in values) {
      if (s.name == name) return s;
    }
    return null;
  }

  /// The default system for a country code, or null when the country has
  /// no modelled payroll system.
  static PayrollSystem? defaultFor(String countryCode) => switch (countryCode) {
    'RS' => PayrollSystem.serbia,
    'HR' => PayrollSystem.croatia,
    'SI' => PayrollSystem.slovenia,
    'BA' => PayrollSystem.fbih,
    'ME' => PayrollSystem.montenegro,
    'MK' => PayrollSystem.northMacedonia,
    'BG' => PayrollSystem.bulgaria,
    'RO' => PayrollSystem.romania,
    _ => null,
  };
}

/// What the person typed the amount as.
enum PayrollInputMode { gross, net, totalCost }

/// Stable identifiers for every contribution, fee and tax line. The UI maps
/// each one to a localized label; the domain never deals in display text.
enum PayrollItem {
  // Serbia, BiH, Montenegro, North Macedonia
  pension,
  health,
  unemployment,
  childProtection,
  workInjury,
  laborFund,
  chamberOfCommerce,
  // Croatia
  pensionPillar1,
  pensionPillar2,
  // Slovenia
  longTermCare,
  parentalProtection,
  compulsoryHealthContribution,
  // FBiH employer charges calculated on net pay
  waterFee,
  disasterProtectionFee,
  disabilityFund,
  // Bulgaria
  sicknessMaternity,
  supplementaryPension,
  // Romania
  cas,
  cass,
  cam,
}

/// Country-specific options. Only the fields relevant to a system are used.
class PayrollOptions {
  const PayrollOptions({
    this.croatiaLowerRate = 0.20,
    this.croatiaHigherRate = 0.30,
    this.children = 0,
    this.dependents = 0,
    this.montenegroSurtaxRate = 0.13,
    this.romaniaMinimumWageFacility = false,
    this.fbihDisabilityFund = true,
  });

  /// Croatian municipal income-tax rates (lower / higher band).
  final double croatiaLowerRate;
  final double croatiaHigherRate;

  /// Croatia: number of dependent children (personal allowance factor).
  final int children;

  /// Croatia: other dependent family members. Romania: all dependants.
  final int dependents;

  /// Montenegro: municipal surtax as a fraction of income tax.
  final double montenegroSurtaxRate;

  /// Romania: the non-taxable amount for minimum-wage employees.
  final bool romaniaMinimumWageFacility;

  /// FBiH: special contribution for employment of persons with disabilities.
  final bool fbihDisabilityFund;

  PayrollOptions copyWith({
    double? croatiaLowerRate,
    double? croatiaHigherRate,
    int? children,
    int? dependents,
    double? montenegroSurtaxRate,
    bool? romaniaMinimumWageFacility,
    bool? fbihDisabilityFund,
  }) => PayrollOptions(
    croatiaLowerRate: croatiaLowerRate ?? this.croatiaLowerRate,
    croatiaHigherRate: croatiaHigherRate ?? this.croatiaHigherRate,
    children: children ?? this.children,
    dependents: dependents ?? this.dependents,
    montenegroSurtaxRate: montenegroSurtaxRate ?? this.montenegroSurtaxRate,
    romaniaMinimumWageFacility: romaniaMinimumWageFacility ?? this.romaniaMinimumWageFacility,
    fbihDisabilityFund: fbihDisabilityFund ?? this.fbihDisabilityFund,
  );

  Map<String, Object?> toJson() => {
    'hrLower': croatiaLowerRate,
    'hrHigher': croatiaHigherRate,
    'children': children,
    'dependents': dependents,
    'meSurtax': montenegroSurtaxRate,
    'roMinWage': romaniaMinimumWageFacility,
    'fbihDisability': fbihDisabilityFund,
  };

  factory PayrollOptions.fromJson(Map<String, Object?> json) {
    double d(String k, double fallback) {
      final v = json[k];
      return v is num && v.isFinite ? v.toDouble() : fallback;
    }

    int i(String k) {
      final v = json[k];
      return v is num ? v.toInt().clamp(0, 20) : 0;
    }

    bool b(String k, bool fallback) {
      final v = json[k];
      return v is bool ? v : fallback;
    }

    return PayrollOptions(
      croatiaLowerRate: d('hrLower', 0.20),
      croatiaHigherRate: d('hrHigher', 0.30),
      children: i('children'),
      dependents: i('dependents'),
      montenegroSurtaxRate: d('meSurtax', 0.13),
      romaniaMinimumWageFacility: b('roMinWage', false),
      fbihDisabilityFund: b('fbihDisability', true),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PayrollOptions &&
      other.croatiaLowerRate == croatiaLowerRate &&
      other.croatiaHigherRate == croatiaHigherRate &&
      other.children == children &&
      other.dependents == dependents &&
      other.montenegroSurtaxRate == montenegroSurtaxRate &&
      other.romaniaMinimumWageFacility == romaniaMinimumWageFacility &&
      other.fbihDisabilityFund == fbihDisabilityFund;

  @override
  int get hashCode => Object.hash(
    croatiaLowerRate,
    croatiaHigherRate,
    children,
    dependents,
    montenegroSurtaxRate,
    romaniaMinimumWageFacility,
    fbihDisabilityFund,
  );
}

/// One computed line: a contribution or fee with its rate and amount.
class PayrollLine {
  const PayrollLine(this.item, this.amount, {this.rate, this.base});

  final PayrollItem item;

  /// Rate as a fraction (0.14 = 14%), or null for fixed amounts.
  final double? rate;

  /// Amount the rate was applied to, when it differs from gross pay.
  final double? base;

  final double amount;
}

/// One income-tax band that actually applied.
class TaxBand {
  const TaxBand({required this.rate, required this.taxable, required this.tax});

  final double rate;
  final double taxable;
  final double tax;
}

/// Notes the UI explains next to a result.
enum PayrollNote {
  /// Contributions were computed on the statutory minimum base, which is
  /// higher than the gross pay entered.
  minimumBaseApplied,

  /// Contributions stopped growing at the statutory maximum base.
  maximumBaseApplied,

  /// Croatia: the low-wage pension contribution relief reduced the base.
  pensionReliefApplied,

  /// Net pay is zero or negative — mandatory charges exceed the pay.
  nonPositiveNet,
}

/// The full, transparent breakdown of one monthly payroll calculation.
class PayrollResult {
  const PayrollResult({
    required this.system,
    required this.options,
    required this.gross,
    required this.employeeLines,
    required this.allowance,
    required this.taxableBase,
    required this.taxBands,
    required this.incomeTax,
    required this.surtax,
    required this.net,
    required this.employerLines,
    required this.notes,
  });

  final PayrollSystem system;
  final PayrollOptions options;

  /// Gross pay (Serbian "bruto 1"), per month.
  final double gross;

  /// Employee contributions and fixed employee charges withheld from gross.
  final List<PayrollLine> employeeLines;

  /// Personal allowance / non-taxable amount subtracted for tax.
  final double allowance;

  final double taxableBase;
  final List<TaxBand> taxBands;
  final double incomeTax;

  /// Municipal surtax on income tax (Montenegro), 0 elsewhere.
  final double surtax;

  final double net;

  /// Contributions and charges the employer pays on top of gross.
  final List<PayrollLine> employerLines;

  final Set<PayrollNote> notes;

  int get _d => system.decimals;

  double get employeeTotal => Money.sum(employeeLines.map((l) => l.amount), _d);
  double get employerTotal => Money.sum(employerLines.map((l) => l.amount), _d);
  double get totalTax => Money.sum([incomeTax, surtax], _d);

  /// Total cost to the employer (Serbian "bruto 2").
  double get totalCost => Money.sum([gross, employerTotal], _d);

  /// Share of the total employer cost that is not paid out as net pay.
  double get taxWedge => totalCost <= 0 ? 0 : (totalCost - net) / totalCost;

  /// Net pay as a share of gross pay.
  double get netToGross => gross <= 0 ? 0 : net / gross;
}
