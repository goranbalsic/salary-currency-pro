import '../../../core/format/formats.dart';
import '../../../l10n/l10n.dart';
import '../domain/payroll_engine.dart';
import '../domain/payroll_models.dart';
import '../domain/payroll_rules.dart';

String payrollItemLabel(AppLocalizations l, PayrollItem item) => switch (item) {
      PayrollItem.pension => l.itemPension,
      PayrollItem.health => l.itemHealth,
      PayrollItem.unemployment => l.itemUnemployment,
      PayrollItem.childProtection => l.itemChildProtection,
      PayrollItem.workInjury => l.itemWorkInjury,
      PayrollItem.laborFund => l.itemLaborFund,
      PayrollItem.chamberOfCommerce => l.itemChamber,
      PayrollItem.pensionPillar1 => l.itemPillar1,
      PayrollItem.pensionPillar2 => l.itemPillar2,
      PayrollItem.longTermCare => l.itemLongTermCare,
      PayrollItem.parentalProtection => l.itemParental,
      PayrollItem.compulsoryHealthContribution => l.itemCompulsoryHealth,
      PayrollItem.waterFee => l.itemWaterFee,
      PayrollItem.disasterProtectionFee => l.itemDisasterFee,
      PayrollItem.disabilityFund => l.itemDisabilityFund,
      PayrollItem.sicknessMaternity => l.itemSickness,
      PayrollItem.supplementaryPension => l.itemSupplementaryPension,
      PayrollItem.cas => l.itemCas,
      PayrollItem.cass => l.itemCass,
      PayrollItem.cam => l.itemCam,
    };

/// Label for the allowance row, or null when the system has none to show.
String? payrollAllowanceLabel(AppLocalizations l, PayrollSystem s) => switch (s) {
      PayrollSystem.serbia => l.payNonTaxable,
      PayrollSystem.croatia || PayrollSystem.fbih || PayrollSystem.republikaSrpska => l.payPersonalAllowance,
      PayrollSystem.slovenia => l.payGeneralAllowance,
      PayrollSystem.northMacedonia => l.payPersonalExemption,
      PayrollSystem.romania => l.payPersonalDeduction,
      PayrollSystem.montenegro || PayrollSystem.bulgaria => null,
    };

bool payrollHasOptions(PayrollSystem s) =>
    s == PayrollSystem.croatia || s == PayrollSystem.montenegro || s == PayrollSystem.romania || s == PayrollSystem.fbih;

/// One-line summary of the options that apply to [system].
String payrollOptionsSummary(AppLocalizations l, Formats f, PayrollSystem system, PayrollOptions options) {
  int dec(double rate) {
    final p = rate * 100;
    return (p - p.roundToDouble()).abs() < 1e-9 ? 0 : 2;
  }

  return switch (system) {
    PayrollSystem.croatia => l.payOptionsHrSummary(
        f.percentValue(options.croatiaLowerRate * 100, decimals: dec(options.croatiaLowerRate)),
        f.percentValue(options.croatiaHigherRate * 100, decimals: dec(options.croatiaHigherRate)),
        options.children,
      ),
    PayrollSystem.montenegro => l.payOptionsMeSummary(f.percentValue(options.montenegroSurtaxRate * 100, decimals: dec(options.montenegroSurtaxRate))),
    PayrollSystem.romania => [
        l.payOptionsRoSummary(options.dependents),
        if (options.romaniaMinimumWageFacility) l.payOptionsRoMinWage,
      ].join(' · '),
    PayrollSystem.fbih => l.payOptionsFbihSummary(options.fbihDisabilityFund ? l.payOn : l.payOff),
    _ => '',
  };
}

/// The explanatory notes for a result, as (text, isWarning).
List<(String, bool)> payrollNoteTexts(AppLocalizations l, Formats fm, PayrollResult r) {
  String m(double v) => fm.money(v, r.system.currency, decimals: r.system.decimals);
  final out = <(String, bool)>[];
  if (r.notes.contains(PayrollNote.nonPositiveNet)) out.add((l.payNoteNonPositive, true));
  if (r.notes.contains(PayrollNote.minimumBaseApplied)) {
    final min = switch (r.system) {
      PayrollSystem.serbia => PayrollRules.rsMinBase,
      PayrollSystem.northMacedonia => PayrollRules.mkMinBase,
      _ => null,
    };
    if (min != null) out.add((l.payNoteMinBase(m(min)), false));
  }
  if (r.notes.contains(PayrollNote.maximumBaseApplied)) {
    final max = switch (r.system) {
      PayrollSystem.serbia => PayrollRules.rsMaxBase,
      PayrollSystem.northMacedonia => PayrollRules.mkMaxBase,
      PayrollSystem.bulgaria => PayrollRules.bgMaxBase,
      PayrollSystem.croatia => PayrollRules.hrMaxPensionBase,
      PayrollSystem.montenegro => PayrollRules.meMaxBase,
      _ => null,
    };
    if (max != null) out.add((l.payNoteMaxBase(m(max)), false));
  }
  if (r.notes.contains(PayrollNote.pensionReliefApplied)) {
    out.add((l.payNoteRelief(m(PayrollEngine.croatiaPensionBase(r.gross))), false));
  }
  return out;
}
