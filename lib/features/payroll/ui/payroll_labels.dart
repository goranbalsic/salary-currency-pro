import '../../../l10n/l10n.dart';
import '../domain/payroll_models.dart';

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
