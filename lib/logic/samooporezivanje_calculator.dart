/// Serbia's self-taxation ("samooporezivanje") regime for freelancers who
/// receive foreign income directly (not through a registered flat-rate
/// entrepreneur / "paušalac" status) — reported quarterly via form
/// PP OPO-K. Two standardized-expense models are available each quarter,
/// freely chosen independently quarter to quarter.
///
/// This models the income-tax portion only, per the sourced formula (see
/// assets — figures are the 2026 quarterly thresholds). It deliberately
/// does NOT compute social security contributions for this regime: unlike
/// the two standardized-expense models above, the exact contribution base
/// for self-taxed foreign income isn't yet sourced to the same standard as
/// the rest of this app's numbers, so it's left out rather than guessed —
/// the UI must disclose this explicitly.
enum SamooporezivanjeModel { fixedExpense, mixedExpense }

class SamooporezivanjeResult {
  final double quarterlyGrossRsd;
  final SamooporezivanjeModel model;
  final double taxableBase;
  final double incomeTax;

  const SamooporezivanjeResult({
    required this.quarterlyGrossRsd,
    required this.model,
    required this.taxableBase,
    required this.incomeTax,
  });
}

class SamooporezivanjeCalculator {
  SamooporezivanjeCalculator._();

  static const int year = 2026;
  static const double fixedExpenseDeduction = 110647.0;
  static const double mixedExpenseFixedPart = 66733.0;
  static const double mixedExpensePercentPart = 0.34;
  static const double taxRate = 0.10;

  static SamooporezivanjeResult compute(
    double quarterlyGrossRsd,
    SamooporezivanjeModel model,
  ) {
    final base = switch (model) {
      SamooporezivanjeModel.fixedExpense =>
        (quarterlyGrossRsd - fixedExpenseDeduction)
            .clamp(0, double.infinity)
            .toDouble(),
      SamooporezivanjeModel.mixedExpense => (quarterlyGrossRsd -
              mixedExpenseFixedPart -
              quarterlyGrossRsd * mixedExpensePercentPart)
          .clamp(0, double.infinity)
          .toDouble(),
    };

    return SamooporezivanjeResult(
      quarterlyGrossRsd: quarterlyGrossRsd,
      model: model,
      taxableBase: base,
      incomeTax: base * taxRate,
    );
  }

  /// Which model produces less tax for a given quarterly gross — the two
  /// models can be freely mixed quarter to quarter, so this is a genuinely
  /// useful comparison rather than academic.
  static SamooporezivanjeModel cheaperModel(double quarterlyGrossRsd) {
    final fixed =
        compute(quarterlyGrossRsd, SamooporezivanjeModel.fixedExpense);
    final mixed =
        compute(quarterlyGrossRsd, SamooporezivanjeModel.mixedExpense);
    return mixed.incomeTax <= fixed.incomeTax
        ? SamooporezivanjeModel.mixedExpense
        : SamooporezivanjeModel.fixedExpense;
  }
}
