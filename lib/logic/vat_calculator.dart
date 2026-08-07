/// Add/remove VAT from an amount. Pure arithmetic — the actual per-country
/// standard rate comes from [VatRateService], never hardcoded here, so the
/// same logic works for the default rate or a user-overridden one (reduced
/// rates, edge cases).
class VatCalculator {
  VatCalculator._();

  static ({double vatAmount, double gross}) addVat(
    double net,
    double ratePercent,
  ) {
    final vatAmount = net * (ratePercent / 100);
    return (vatAmount: vatAmount, gross: net + vatAmount);
  }

  static ({double vatAmount, double net}) removeVat(
    double gross,
    double ratePercent,
  ) {
    final net = gross / (1 + ratePercent / 100);
    return (vatAmount: gross - net, net: net);
  }
}
