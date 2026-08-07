import '../../models/freelance_tax_rules.dart';

/// How often the primary income figure a regime's calculator asks for is
/// naturally reported — Serbia's PP OPO-K form is genuinely quarterly;
/// every other regime modeled here files annually (even where contributions
/// are paid monthly, the headline "how much do I owe" figure a freelancer
/// wants is the annual one). Drives the input field's label in the screen.
enum FreelanceIncomePeriod { quarterly, annual }

/// One threshold worth surfacing to the user — VAT registration, a
/// regime-changing cliff, a paušal/normă-de-venit eligibility ceiling.
/// Always emitted when the regime defines the threshold (not only when
/// income is close to it) so the UI warns both before and after crossing,
/// per PROMPT-004 Part 3 — never silently computes past a cliff.
class FreelanceCliffFlag {
  /// Stable id the screen switches on to pick localized copy — see
  /// [FreelanceCliffId] for the fixed set of values ever produced.
  final String id;
  final double threshold;
  final bool crossed;

  const FreelanceCliffFlag({
    required this.id,
    required this.threshold,
    required this.crossed,
  });
}

/// The fixed set of cliff-flag ids strategy classes emit — a screen-side
/// switch must cover all of these to have full l10n coverage.
class FreelanceCliffId {
  FreelanceCliffId._();

  static const vatThreshold = 'vatThreshold';
  static const albaniaZeroTaxCliff = 'albaniaZeroTaxCliff';
  static const sloveniaNormiraniDeemedExpenseCliff =
      'sloveniaNormiraniDeemedExpenseCliff';
  static const sloveniaPopoldanskiDeemedExpenseCliff =
      'sloveniaPopoldanskiDeemedExpenseCliff';
  static const serbiaPausalCeiling = 'serbiaPausalCeiling';
  static const montenegroPausalCeiling = 'montenegroPausalCeiling';
  static const romaniaNormaDeVenitCeiling = 'romaniaNormaDeVenitCeiling';
}

/// The full sourced breakdown of one freelance-tax calculation — every
/// field here must be assertable in a test independently, per PROMPT-004
/// Part 4 ("assert the full breakdown ... not just net").
class FreelanceTaxResult {
  final double grossIncome;

  /// Total amount deducted from gross before the tax rate is applied
  /// (normative/deemed expenses, personal allowance, ...). Zero for
  /// regimes with no deduction step.
  final double totalDeduction;

  final double taxableBase;
  final double incomeTax;

  /// Named contribution lines (pension, health, unemployment, ...) in the
  /// regime's own terms — order matches how the regime's own paperwork
  /// presents them.
  final Map<String, double> contributions;
  final double totalContributions;

  /// Always `grossIncome - incomeTax - totalContributions`, regardless of
  /// whether contributions were deductible from the tax base — deductibility
  /// only changes how [incomeTax] itself was computed, never this formula.
  final double netIncome;

  final List<FreelanceCliffFlag> cliffFlags;

  /// Regime-specific supplementary data a screen may want (e.g. Serbia's
  /// "was this the cheaper model?" flag) that doesn't fit the common shape.
  final Map<String, dynamic> extra;

  const FreelanceTaxResult({
    required this.grossIncome,
    required this.totalDeduction,
    required this.taxableBase,
    required this.incomeTax,
    required this.contributions,
    required this.totalContributions,
    required this.netIncome,
    this.cliffFlags = const [],
    this.extra = const {},
  });
}

/// Free-form regime-specific selectors (Serbia's model, Slovenia's s.p.
/// type, FBiH's activity category, ...) — kept as a bag rather than one
/// field per possible selector across 10 different regimes.
class FreelanceTaxInput {
  final double income;
  final Map<String, dynamic> options;

  const FreelanceTaxInput({required this.income, this.options = const {}});

  /// Looks up a regime-specific option, falling back to [fallback] when
  /// absent. Coerces `int` → `double` when [T] is `double` — a caller
  /// passing a whole-number option (e.g. `{'qualifyingInvestment': 1000000}`)
  /// should not have to remember to write `1000000.0` for a numeric field.
  T option<T>(String key, T fallback) {
    final v = options[key];
    if (v == null) return fallback;
    if (fallback is double && v is num) return v.toDouble() as T;
    return v as T? ?? fallback;
  }
}

/// One country/entity's self-assessment formula. The order of operations
/// genuinely differs by regime (see each implementation's doc comment) —
/// this interface exists so the screen and tests can treat all 10
/// uniformly without a shared formula papering over real differences.
/// Every numeric constant a strategy uses MUST come from the [rules]
/// argument (see [FreelanceRegimeRules.field]) — never a literal in this
/// code, per PROMPT-004's "no tax constant may live in Dart code" rule.
abstract class FreelanceTaxStrategy {
  String get regimeId;
  FreelanceIncomePeriod get period;

  FreelanceTaxResult compute(FreelanceRegimeRules rules, FreelanceTaxInput input);
}

double clampD(double value, double? min, double? max) {
  var v = value;
  if (min != null && v < min) v = min;
  if (max != null && v > max) v = max;
  return v;
}
