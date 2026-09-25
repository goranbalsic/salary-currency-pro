import 'payroll_models.dart';

/// Statutory 2026 payroll parameters for every modelled system, with the
/// sources they were verified against. Every number the engine uses lives
/// here — the engine itself contains no tax constants.
///
/// Update this file every January (and whenever a mid-year change lands),
/// then update the pinned examples in test/payroll/payroll_engine_test.dart.
abstract final class PayrollRules {
  /// The date the displayed rules are effective from, per system.
  static DateTime effectiveFrom(PayrollSystem s) => switch (s) {
        PayrollSystem.northMacedonia => DateTime(2026, 7, 1),
        PayrollSystem.bulgaria => DateTime(2026, 8, 1),
        PayrollSystem.romania => DateTime(2026, 7, 1),
        PayrollSystem.slovenia => DateTime(2026, 3, 1),
        _ => DateTime(2026, 1, 1),
      };

  static List<String> sources(PayrollSystem s) => switch (s) {
        PayrollSystem.serbia => const [
            'Zakon o porezu na dohodak građana — neoporezivi iznos 34.221 RSD od 1.1.2026.',
            'Najniža / najviša mesečna osnovica doprinosa 2026: 51.297 / 732.820 RSD',
          ],
        PayrollSystem.croatia => const [
            'Naredba o iznosima osnovica za obračun doprinosa za 2026. (NN 150/2025)',
            'Zakon o porezu na dohodak — osobni odbitak 600 EUR, prag 5.000 EUR mjesečno',
          ],
        PayrollSystem.slovenia => const [
            'Lestvica za odmero dohodnine in olajšave za leto 2026 (Ur. l. RS 104/2025)',
            'Obvezni zdravstveni prispevek 39,36 EUR od 1.3.2026; prispevek za dolgotrajno oskrbo 1 %',
          ],
        PayrollSystem.fbih => const [
            'Zakon o doprinosima FBiH — stope od 1.7.2025. (31 % iz plate, 5 % na platu)',
            'Zakon o porezu na dohodak FBiH — lični odbitak 300 KM',
          ],
        PayrollSystem.republikaSrpska => const [
            'Zakon o doprinosima RS — ukupna stopa 31 %',
            'Zakon o porezu na dohodak RS — stopa 8 %, lični odbitak 1.000 KM',
          ],
        PayrollSystem.montenegro => const [
            'Zakon o porezu na dohodak fizičkih lica — 0 % do 700, 9 % do 1.000, 15 % preko 1.000 EUR bruto',
            'Prirez porezu: 13 % (Podgorica i Cetinje 15 %)',
          ],
        PayrollSystem.northMacedonia => const [
            'Закон за придонеси — стапки од 1.7.2026',
            'УЈП — лично ослободување 10.932 денари месечно за 2026',
          ],
        PayrollSystem.bulgaria => const [
            'КСО — осигурителни вноски 2026; максимален осигурителен доход 2.300 EUR от 1.8.2026',
            'ЗДДФЛ — плосък данък 10 %',
          ],
        PayrollSystem.romania => const [
            'Codul fiscal art. 77 — deducere personală; salariul minim 4.325 lei de la 1.7.2026 (HG 146/2026)',
            'OUG 89/2025 — suma netaxabilă 200 lei pentru salariul minim',
          ],
      };

  // ---------------------------------------------------------------- Serbia
  static const rsNonTaxable = 34221.0;
  static const rsMinBase = 51297.0;
  static const rsMaxBase = 732820.0;
  static const rsTaxRate = 0.10;
  static const rsEmployee = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.14),
    (PayrollItem.health, 0.0515),
    (PayrollItem.unemployment, 0.0075),
  ];
  static const rsEmployer = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.10),
    (PayrollItem.health, 0.0515),
  ];

  // --------------------------------------------------------------- Croatia
  static const hrBaseAllowance = 600.0;
  static const hrBracketThreshold = 5000.0;
  static const hrMaxPensionBase = 11958.0;
  static const hrPillar1Rate = 0.15;
  static const hrPillar2Rate = 0.05;
  static const hrEmployerHealthRate = 0.165;

  /// Low-wage pension relief: up to [hrReliefLowerGross] the base is gross
  /// minus [hrReliefFixed]; up to [hrReliefUpperGross] it is gross minus
  /// [hrReliefFactor] × (upper − gross).
  static const hrReliefLowerGross = 700.0;
  static const hrReliefUpperGross = 1300.0;
  static const hrReliefFixed = 300.0;
  static const hrReliefFactor = 0.5;

  /// Allowance factor per child, 1st to 9th (cumulative sum is applied).
  static const hrChildFactors = <double>[0.5, 0.7, 1.0, 1.4, 1.9, 2.5, 3.2, 4.0, 4.9];
  static const hrDependentFactor = 0.5;
  static const hrLowerRateRange = (0.15, 0.23);
  static const hrHigherRateRange = (0.25, 0.33);

  // -------------------------------------------------------------- Slovenia
  static const siEmployee = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.155),
    (PayrollItem.health, 0.0636),
    (PayrollItem.longTermCare, 0.01),
    (PayrollItem.parentalProtection, 0.001),
    (PayrollItem.unemployment, 0.0014),
  ];
  static const siEmployer = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.0885),
    (PayrollItem.health, 0.0656),
    (PayrollItem.workInjury, 0.0053),
    (PayrollItem.longTermCare, 0.01),
    (PayrollItem.parentalProtection, 0.001),
    (PayrollItem.unemployment, 0.0006),
  ];
  static const siCompulsoryHealthContribution = 39.36;
  static const siGeneralAllowance = 462.66;
  static const siAllowanceIntercept = 1736.03;
  static const siAllowanceSlope = 1.17259;

  /// Monthly withholding scale: (upper bound of band, rate).
  static const siMonthlyScale = <(double, double)>[
    (810.12, 0.16),
    (2382.70, 0.26),
    (4765.41, 0.33),
    (6862.19, 0.39),
    (double.infinity, 0.50),
  ];

  // ------------------------------------------------------------------ FBiH
  static const fbihAllowance = 300.0;
  static const fbihTaxRate = 0.10;
  static const fbihEmployee = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.17),
    (PayrollItem.health, 0.125),
    (PayrollItem.unemployment, 0.015),
  ];
  static const fbihEmployer = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.025),
    (PayrollItem.health, 0.02),
    (PayrollItem.unemployment, 0.005),
  ];
  static const fbihWaterFeeOnNet = 0.005;
  static const fbihDisasterFeeOnNet = 0.005;
  static const fbihDisabilityFundOnGross = 0.005;

  // ------------------------------------------------------ Republika Srpska
  static const rsbihAllowance = 1000.0;
  static const rsbihTaxRate = 0.08;
  static const rsbihEmployee = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.185),
    (PayrollItem.health, 0.102),
    (PayrollItem.unemployment, 0.006),
    (PayrollItem.childProtection, 0.017),
  ];

  // ------------------------------------------------------------ Montenegro
  /// Bands applied to gross pay: (upper bound, rate).
  static const meBands = <(double, double)>[
    (700.0, 0.0),
    (1000.0, 0.09),
    (double.infinity, 0.15),
  ];
  static const meMaxBase = 75453.0 / 12;
  static const meEmployee = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.10),
    (PayrollItem.unemployment, 0.005),
  ];
  static const meEmployer = <(PayrollItem, double)>[
    (PayrollItem.unemployment, 0.005),
    (PayrollItem.laborFund, 0.002),
    (PayrollItem.chamberOfCommerce, 0.0027),
  ];
  static const meDefaultSurtax = 0.13;

  // ------------------------------------------------------- North Macedonia
  static const mkPersonalExemption = 10932.0;
  static const mkMinBase = 34571.0;
  static const mkMaxBase = 1106256.0;
  static const mkTaxRate = 0.10;
  static const mkEmployee = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.199),
    (PayrollItem.health, 0.075),
    (PayrollItem.unemployment, 0.001),
    (PayrollItem.workInjury, 0.005),
  ];

  // -------------------------------------------------------------- Bulgaria
  static const bgMaxBase = 2300.0;
  static const bgTaxRate = 0.10;
  static const bgEmployee = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.0658),
    (PayrollItem.sicknessMaternity, 0.014),
    (PayrollItem.unemployment, 0.004),
    (PayrollItem.supplementaryPension, 0.022),
    (PayrollItem.health, 0.032),
  ];
  static const bgEmployer = <(PayrollItem, double)>[
    (PayrollItem.pension, 0.0822),
    (PayrollItem.sicknessMaternity, 0.021),
    (PayrollItem.unemployment, 0.006),
    (PayrollItem.workInjury, 0.004),
    (PayrollItem.supplementaryPension, 0.028),
    (PayrollItem.health, 0.048),
  ];

  // --------------------------------------------------------------- Romania
  static const roMinimumWage = 4325.0;
  static const roDeductionCeilingAboveMinimum = 2000.0;
  static const roDeductionStep = 50.0;
  static const roDeductionStepPercent = 0.5;

  /// Base personal-deduction percentage by number of dependants (index 4 = 4+).
  static const roDeductionBasePercent = <double>[20, 25, 30, 35, 45];
  static const roMinimumWageNonTaxable = 200.0;
  static const roCasRate = 0.25;
  static const roCassRate = 0.10;
  static const roTaxRate = 0.10;
  static const roCamRate = 0.0225;
}
