// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Bilans';

  @override
  String get appTagline => 'Finance calculator';

  @override
  String get navHome => 'Home';

  @override
  String get navPayroll => 'Pay';

  @override
  String get navCredit => 'Loans';

  @override
  String get navFx => 'Rates';

  @override
  String get navBusiness => 'Business';

  @override
  String get actionSave => 'Save';

  @override
  String get actionShare => 'Share';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionClose => 'Close';

  @override
  String get actionDone => 'Done';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionOk => 'OK';

  @override
  String get actionDownloadPdf => 'Download PDF';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionClear => 'Clear';

  @override
  String get commonMonthly => 'Monthly';

  @override
  String get commonAnnual => 'Annual';

  @override
  String get commonMonthsShort => 'mo.';

  @override
  String get commonYearsShort => 'yr.';

  @override
  String commonMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '$count month',
    );
    return '$_temp0';
  }

  @override
  String commonYearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '$count year',
    );
    return '$_temp0';
  }

  @override
  String get commonPercentPa => '% p.a.';

  @override
  String get commonOptional => 'optional';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get snackSaved => 'Saved';

  @override
  String get snackDeleted => 'Deleted';

  @override
  String get snackCopied => 'Copied';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorShare => 'Couldn\'t open the share sheet.';

  @override
  String get errorOpenLink => 'Couldn\'t open the link.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature is part of Bilans Pro';
  }

  @override
  String get countryRS => 'Serbia';

  @override
  String get countryHR => 'Croatia';

  @override
  String get countryBA => 'Bosnia and Herzegovina';

  @override
  String get countryME => 'Montenegro';

  @override
  String get countryMK => 'North Macedonia';

  @override
  String get countrySI => 'Slovenia';

  @override
  String get countryBG => 'Bulgaria';

  @override
  String get countryRO => 'Romania';

  @override
  String get systemFbih => 'Federation of BiH';

  @override
  String get systemRepublikaSrpska => 'Republika Srpska';

  @override
  String get curEUR => 'Euro';

  @override
  String get curUSD => 'US dollar';

  @override
  String get curCHF => 'Swiss franc';

  @override
  String get curGBP => 'British pound';

  @override
  String get curRSD => 'Serbian dinar';

  @override
  String get curBAM => 'Convertible mark';

  @override
  String get curMKD => 'Macedonian denar';

  @override
  String get curRON => 'Romanian leu';

  @override
  String get curHUF => 'Hungarian forint';

  @override
  String get curCZK => 'Czech koruna';

  @override
  String get curPLN => 'Polish złoty';

  @override
  String get curSEK => 'Swedish krona';

  @override
  String get curNOK => 'Norwegian krone';

  @override
  String get curDKK => 'Danish krone';

  @override
  String get curJPY => 'Japanese yen';

  @override
  String get curCNY => 'Chinese yuan';

  @override
  String get curCAD => 'Canadian dollar';

  @override
  String get curAUD => 'Australian dollar';

  @override
  String get curTRY => 'Turkish lira';

  @override
  String get curRUB => 'Russian ruble';

  @override
  String get formFixErrors => 'Please fix the highlighted fields.';

  @override
  String get discardTitle => 'Discard changes?';

  @override
  String get discardBody => 'Your changes haven\'t been saved.';

  @override
  String get discardKeep => 'Keep editing';

  @override
  String get discardAction => 'Discard';

  @override
  String get commonMore => 'More options';

  @override
  String get errorPdf => 'Couldn\'t create the PDF. Please try again.';

  @override
  String get pdfLanguageTitle => 'Invoice language';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + English';
  }

  @override
  String get onbHeadline => 'Numbers you can trust.';

  @override
  String get onbBody =>
      'Pay, loans, official exchange rates and invoices — calculated to your country\'s rules. No account, no tracking.';

  @override
  String get onbCountry => 'Your country';

  @override
  String get onbBihEntities => 'Federation of BiH and Republika Srpska';

  @override
  String get onbLanguage => 'App language';

  @override
  String get onbLanguageDevice => 'Device language';

  @override
  String get onbPrivacy => 'Your data stays on this phone.';

  @override
  String get homeSearchHint => 'Search calculators';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeRatesTitle => 'Rates today';

  @override
  String homeRatesNbs(String date) {
    return 'NBS middle rate · $date';
  }

  @override
  String homeRatesEcb(String date) {
    return 'ECB reference rate · $date';
  }

  @override
  String get homeRatesEmpty =>
      'Today\'s official rates appear here once you\'re online.';

  @override
  String get homeRecent => 'Recent';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeSectionPayroll => 'Pay';

  @override
  String get homeSectionCredit => 'Loans and savings';

  @override
  String get homeSectionFx => 'Exchange rates';

  @override
  String get homeSectionBusiness => 'Business';

  @override
  String homeNoResults(String query) {
    return 'No calculator matches “$query”.';
  }

  @override
  String get toolPayroll => 'Gross and net pay';

  @override
  String get toolPayrollDesc => 'Payroll for 9 tax systems';

  @override
  String get toolTeam => 'Team cost';

  @override
  String get toolTeamDesc => 'Monthly and annual payroll cost';

  @override
  String get toolCompare => 'Compare countries';

  @override
  String get toolCompareDesc => 'The same pay in 9 systems';

  @override
  String get toolLoan => 'Loan';

  @override
  String get toolLoanDesc => 'Installment, APR and schedule';

  @override
  String get toolDeposit => 'Term deposit';

  @override
  String get toolDepositDesc => 'Interest and tax on interest';

  @override
  String get toolLoanCompare => 'Compare loans';

  @override
  String get toolLoanCompareDesc => 'Up to three offers, ranked by APR';

  @override
  String get toolPrepay => 'Early repayment';

  @override
  String get toolPrepayDesc => 'How much interest you save';

  @override
  String get toolConverter => 'Currency converter';

  @override
  String get toolConverterDesc => 'Official NBS and ECB rates';

  @override
  String get toolRateHistory => 'Rate history';

  @override
  String get toolRateHistoryDesc => '30, 90 and 365 days';

  @override
  String get toolInvoices => 'Invoices';

  @override
  String get toolInvoicesDescRs => 'PDF with NBS IPS QR code';

  @override
  String get toolInvoicesDesc => 'Professional PDF invoices';

  @override
  String get toolPausal => 'Paušal limits';

  @override
  String get toolPausalDesc => '6 and 8 million dinars, live';

  @override
  String get toolVat => 'VAT';

  @override
  String get toolVatDesc => 'Add or extract VAT';

  @override
  String get toolMargin => 'Margin and markup';

  @override
  String get toolMarginDesc => 'Cost, price and discount';

  @override
  String get toolBreakEven => 'Break-even';

  @override
  String get toolBreakEvenDesc => 'How much you need to sell';

  @override
  String get toolInvestment => 'Investment';

  @override
  String get toolInvestmentDesc => 'NPV, IRR and payback';

  @override
  String recentPayroll(String country) {
    return 'Pay · $country';
  }

  @override
  String recentFromGross(String amount) {
    return 'net from $amount gross';
  }

  @override
  String recentFromNet(String amount) {
    return 'gross for $amount net';
  }

  @override
  String recentFromCost(String amount) {
    return 'gross within $amount budget';
  }

  @override
  String recentLoan(String term) {
    return 'Loan · $term';
  }

  @override
  String recentLoanSub(String eir) {
    return 'installment · APR $eir';
  }

  @override
  String recentDeposit(String term) {
    return 'Deposit · $term';
  }

  @override
  String recentDepositSub(String rate) {
    return 'at maturity · $rate';
  }

  @override
  String recentVatAdd(String amount, String rate) {
    return '$amount + VAT $rate';
  }

  @override
  String recentVatExtract(String amount, String rate) {
    return 'net of $amount at $rate';
  }

  @override
  String recentMarginSub(String margin) {
    return 'price with VAT · margin $margin';
  }

  @override
  String recentBreakEvenSub(String amount) {
    return 'per month · revenue $amount';
  }

  @override
  String recentInvestmentSub(String irr) {
    return 'NPV · IRR $irr';
  }

  @override
  String get historyTitle => 'Saved and recent';

  @override
  String get historySaved => 'Saved';

  @override
  String get historySavedEmpty =>
      'Tap Save on any result to keep it here with a name.';

  @override
  String get historyRecentEmpty =>
      'Calculations you finish appear here automatically.';

  @override
  String get historyClearTitle => 'Clear the recent list?';

  @override
  String get payTitle => 'Pay calculator';

  @override
  String get payModeGross => 'Gross → net';

  @override
  String get payModeNet => 'Net → gross';

  @override
  String get payModeCost => 'Total cost';

  @override
  String get payModeSemantic => 'Calculation direction';

  @override
  String get payInputGross => 'Gross pay · monthly';

  @override
  String get payInputNet => 'Desired net pay · monthly';

  @override
  String get payInputCost => 'Employer budget · monthly';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Minimum contribution base: $amount';
  }

  @override
  String get payHelperNet => 'The amount the employee receives';

  @override
  String get payHelperCost => 'Gross pay plus all employer contributions';

  @override
  String get payResultNet => 'Net pay';

  @override
  String get payResultGross => 'Required gross pay';

  @override
  String get payResultGrossBudget => 'Gross pay within budget';

  @override
  String payShareOfGross(String percent) {
    return '$percent of gross';
  }

  @override
  String payNetLine(String amount) {
    return 'Net pay: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Total employer cost: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'Where the employer\'s total cost goes';

  @override
  String get segNet => 'Net pay';

  @override
  String get segTax => 'Tax';

  @override
  String get segEmployee => 'Employee contributions';

  @override
  String get segEmployer => 'Employer contributions';

  @override
  String get payBreakdown => 'Breakdown';

  @override
  String get payAnnualToggle => 'Annual ×12';

  @override
  String get payEmployee => 'Employee';

  @override
  String get payEmployer => 'Employer';

  @override
  String get payGross => 'Gross pay';

  @override
  String get payNetTotal => 'Net pay';

  @override
  String get payTotalCost => 'Total cost of pay';

  @override
  String get payNonTaxable => 'Non-taxable amount';

  @override
  String get payPersonalAllowance => 'Personal allowance';

  @override
  String get payGeneralAllowance => 'General allowance';

  @override
  String get payPersonalExemption => 'Personal exemption';

  @override
  String get payPersonalDeduction => 'Personal deduction';

  @override
  String get payTaxBase => 'Tax base';

  @override
  String get payIncomeTax => 'Income tax';

  @override
  String payTaxOn(String rate, String amount) {
    return '$rate on $amount';
  }

  @override
  String get paySurtax => 'Municipal surtax';

  @override
  String payOnBase(String amount) {
    return 'on $amount';
  }

  @override
  String get payFixedMonthly => 'fixed monthly';

  @override
  String payWedge(String percent) {
    return 'Tax wedge $percent';
  }

  @override
  String payRulesFrom(String date) {
    return 'Rules from $date';
  }

  @override
  String get paySources => 'Sources';

  @override
  String payDisclaimer(String date) {
    return 'Indicative calculation under the rules in force from $date. It does not replace an official payroll.';
  }

  @override
  String get payAnnualNote =>
      'Annual figures are 12 × the monthly amounts; year-end tax reconciliation may differ.';

  @override
  String payNoteMinBase(String amount) {
    return 'Contributions are charged on the minimum base of $amount.';
  }

  @override
  String payNoteMaxBase(String amount) {
    return 'Contributions stop at the maximum base of $amount.';
  }

  @override
  String payNoteRelief(String amount) {
    return 'Low-wage relief lowers the pension contribution base to $amount.';
  }

  @override
  String get payNoteNonPositive => 'Mandatory charges exceed this pay.';

  @override
  String get payEmpty =>
      'Enter an amount to see the full breakdown — contributions, tax and the employer\'s total cost.';

  @override
  String get payErrorTooLarge => 'That amount is too large to calculate.';

  @override
  String get paySystemTitle => 'Tax system';

  @override
  String get paySystemProHint =>
      'Your home country is free. Other countries are part of Pro.';

  @override
  String get payOptions => 'Options';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Tax $lower / $higher · children $children';
  }

  @override
  String payOptionsMeSummary(String rate) {
    return 'Surtax $rate';
  }

  @override
  String payOptionsRoSummary(int count) {
    return 'Dependants $count';
  }

  @override
  String get payOptionsRoMinWage => 'minimum-wage relief';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Disability fund $state';
  }

  @override
  String get payOn => 'on';

  @override
  String get payOff => 'off';

  @override
  String get payHrRates => 'Municipal income-tax rates';

  @override
  String get payHrLower => 'Lower rate';

  @override
  String get payHrHigher => 'Higher rate';

  @override
  String get payHrRatesHint =>
      'Set by your city or municipality: 15–23% and 25–33%. Without a decision, 20% and 30% apply.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'Lower rate $lowRange, higher rate $highRange';
  }

  @override
  String get payChildren => 'Children';

  @override
  String get payDependents => 'Other dependants';

  @override
  String get payRoDependents => 'Dependants';

  @override
  String get payRoMinWage => 'Minimum-wage relief';

  @override
  String get payRoMinWageHint =>
      '200 lei are exempt for employees paid the national minimum wage.';

  @override
  String get payMeSurtax => 'Surtax rate';

  @override
  String get payMeSurtaxHint =>
      '13% in most municipalities, 15% in Podgorica and Cetinje.';

  @override
  String get payFbihDisability => 'Disability employment fund 0.5%';

  @override
  String get payFbihDisabilityHint =>
      'Paid by companies that don\'t employ the required share of people with disabilities.';

  @override
  String get itemPension => 'Pension and disability insurance';

  @override
  String get itemHealth => 'Health insurance';

  @override
  String get itemUnemployment => 'Unemployment insurance';

  @override
  String get itemChildProtection => 'Child protection';

  @override
  String get itemWorkInjury => 'Work injury insurance';

  @override
  String get itemLaborFund => 'Labour Fund';

  @override
  String get itemChamber => 'Chamber of Commerce';

  @override
  String get itemPillar1 => 'Pension insurance, pillar I';

  @override
  String get itemPillar2 => 'Pension insurance, pillar II';

  @override
  String get itemLongTermCare => 'Long-term care';

  @override
  String get itemParental => 'Parental protection';

  @override
  String get itemCompulsoryHealth => 'Compulsory health contribution';

  @override
  String get itemWaterFee => 'General water fee';

  @override
  String get itemDisasterFee => 'Disaster protection fee';

  @override
  String get itemDisabilityFund => 'Disability employment fund';

  @override
  String get itemSickness => 'Sickness and maternity';

  @override
  String get itemSupplementaryPension => 'Supplementary pension (UPF)';

  @override
  String get itemCas => 'CAS (pension)';

  @override
  String get itemCass => 'CASS (health)';

  @override
  String get itemCam => 'CAM (work insurance)';

  @override
  String get saveTitle => 'Save calculation';

  @override
  String get saveNameLabel => 'Name';

  @override
  String get saveNameHint => 'e.g. Offer for new hire';

  @override
  String saveLimit(int count) {
    return 'The free plan keeps $count saved calculations.';
  }

  @override
  String get shareFooter => 'Calculated with Bilans';

  @override
  String get sourcesTitle => 'Sources and assumptions';

  @override
  String get teamTitle => 'Team cost';

  @override
  String get teamAdd => 'Add employee';

  @override
  String get teamEdit => 'Edit employee';

  @override
  String get teamEmptyTitle => 'Plan your payroll';

  @override
  String get teamEmpty =>
      'Add your team — each person\'s gross, net and the employer\'s total cost, summed for the month and the year. Mix countries if you employ across borders.';

  @override
  String teamMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count employees',
      one: '$count employee',
    );
    return '$_temp0';
  }

  @override
  String get teamNote =>
      'Each employee is calculated under the rules of their own tax system. Annual figures are 12 × monthly.';

  @override
  String get teamCurrenciesNote =>
      'Totals are shown separately for each currency.';

  @override
  String get teamUnnamed => 'Unnamed';

  @override
  String get teamTotal => 'Total';

  @override
  String get teamCostShort => 'total cost';

  @override
  String teamRemoveTitle(String name) {
    return 'Remove $name from the team?';
  }

  @override
  String get teamName => 'Name';

  @override
  String get teamRole => 'Role';

  @override
  String get teamRoleHint => 'e.g. Developer';

  @override
  String get teamAmountError => 'Enter the pay amount.';

  @override
  String get cmpNeedsRates =>
      'Comparing countries needs today\'s exchange rates. Connect to the internet once and they\'ll be saved for offline use.';

  @override
  String get cmpRankedByNet => 'Ranked by net pay';

  @override
  String get cmpRankedByCost => 'Ranked by employer cost';

  @override
  String cmpCostLine(String cost, String wedge) {
    return 'Employer cost $cost · tax wedge $wedge';
  }

  @override
  String cmpGrossLine(String gross, String wedge) {
    return 'Gross $gross · tax wedge $wedge';
  }

  @override
  String get cmpTaxesKey => 'Taxes and contributions';

  @override
  String cmpNote(String date) {
    return 'Amounts converted at official rates from $date. Each country uses its default settings (no children, standard local rates). The tax wedge is the share of the employer\'s total cost that goes to taxes and contributions.';
  }

  @override
  String get payWedgeLabel => 'Tax wedge';

  @override
  String get creditTitle => 'Loans';

  @override
  String get creditTabLoan => 'Loan';

  @override
  String get creditTabDeposit => 'Savings';

  @override
  String get creditTabCompare => 'Compare';

  @override
  String get loanAmount => 'Loan amount';

  @override
  String get loanRate => 'Nominal interest rate';

  @override
  String get loanTerm => 'Term';

  @override
  String get loanFee => 'Processing fee';

  @override
  String get loanMonthlyFee => 'Monthly fees';

  @override
  String get loanMonthlyFeeHint => 'Account, insurance…';

  @override
  String get loanRepayment => 'Repayment';

  @override
  String get loanAnnuity => 'Equal installments';

  @override
  String get loanLinear => 'Equal principal';

  @override
  String get loanMore => 'More options';

  @override
  String get loanLess => 'Fewer options';

  @override
  String get loanCurrency => 'Currency';

  @override
  String get loanInstallment => 'Monthly installment';

  @override
  String get loanFirstInstallment => 'First installment';

  @override
  String get loanEir => 'APR';

  @override
  String get loanTotalInterest => 'Total interest';

  @override
  String get loanTotal => 'Total to repay';

  @override
  String loanTotalIncludes(String fees) {
    return 'Includes principal, interest and fees of $fees.';
  }

  @override
  String get loanEirNote =>
      'APR is the effective annual rate including all fees, per the EU consumer-credit formula.';

  @override
  String get loanByYear => 'By year';

  @override
  String get loanPrincipal => 'Principal';

  @override
  String get loanInterest => 'Interest';

  @override
  String loanYearShort(int n) {
    return 'Yr $n';
  }

  @override
  String get loanSchedule => 'Repayment schedule';

  @override
  String loanScheduleAll(int count) {
    return 'Full schedule · $count installments';
  }

  @override
  String get loanColNo => 'No.';

  @override
  String get loanColInstallment => 'Installment';

  @override
  String get loanColInterest => 'Interest';

  @override
  String get loanColPrincipal => 'Principal';

  @override
  String get loanColBalance => 'Balance';

  @override
  String get loanPrepayTitle => 'Early repayment';

  @override
  String loanPrepayTeaser(
    String amount,
    int month,
    String months,
    String saved,
  ) {
    return 'Paying $amount extra after installment $month shortens the loan by $months and saves $saved in interest.';
  }

  @override
  String get loanPrepayCta => 'Calculate your scenario';

  @override
  String get loanErrorPrincipal => 'Enter a loan amount.';

  @override
  String get loanErrorRate => 'Enter an interest rate between 0 and 100%.';

  @override
  String get loanErrorTerm => 'The term must be between 1 and 600 months.';

  @override
  String get loanErrorFee => 'Fees must be smaller than the loan.';

  @override
  String get prepayTitle => 'Early repayment';

  @override
  String prepayIntro(String amount, String rate, String term) {
    return 'Based on your current loan: $amount at $rate for $term.';
  }

  @override
  String get prepayNoLoan => 'Set up a loan in the Loans tab first.';

  @override
  String get prepayAmount => 'Extra payment';

  @override
  String get prepayAfter => 'Paid with installment no.';

  @override
  String get prepayMode => 'After the payment';

  @override
  String get prepayShorten => 'Shorter term';

  @override
  String get prepayLower => 'Lower installment';

  @override
  String get prepayFee => 'Prepayment fee';

  @override
  String get prepaySaved => 'Interest saved';

  @override
  String get prepayNetSaving => 'Net saving after fee';

  @override
  String get prepayNewTerm => 'New term';

  @override
  String get prepayNewInstallment => 'New installment';

  @override
  String prepayMonthsSaved(String months) {
    return '$months sooner';
  }

  @override
  String get prepayPaidOff =>
      'The extra payment clears the entire remaining balance.';

  @override
  String get prepayBefore => 'Before';

  @override
  String get prepayAfterLabel => 'After';

  @override
  String get depAmount => 'Deposit';

  @override
  String get depRate => 'Interest rate';

  @override
  String get depTerm => 'Term';

  @override
  String get depPayout => 'Interest';

  @override
  String get depAtMaturity => 'At maturity';

  @override
  String get depMonthly => 'Monthly, added';

  @override
  String get depAnnually => 'Yearly, added';

  @override
  String get depTax => 'Tax on interest';

  @override
  String get depTaxHintRs =>
      'In Serbia, interest on dinar savings is tax-free; on foreign-currency savings it is taxed at 15%.';

  @override
  String get depTaxHint =>
      'Enter the withholding tax on interest that applies to you.';

  @override
  String get depContribution => 'Monthly addition';

  @override
  String get depFinal => 'At maturity';

  @override
  String get depGrossInterest => 'Interest before tax';

  @override
  String get depTaxAmount => 'Tax on interest';

  @override
  String get depNetInterest => 'Net interest';

  @override
  String get depPaidIn => 'Paid in';

  @override
  String depYield(String percent) {
    return 'Net yield $percent a year';
  }

  @override
  String get depByYear => 'By year';

  @override
  String get depColYear => 'Year';

  @override
  String get depColInterest => 'Net interest';

  @override
  String get depColBalance => 'Balance';

  @override
  String get depErrorAmount => 'Enter a deposit or a monthly addition.';

  @override
  String get depErrorRate => 'Enter an interest rate between 0 and 100%.';

  @override
  String get cmpLoanIntro =>
      'Same amount for every offer. The cheapest offer is the one with the lowest total cost.';

  @override
  String cmpLoanOffer(int n) {
    return 'Offer $n';
  }

  @override
  String get cmpLoanAdd => 'Add offer';

  @override
  String get cmpLoanRemove => 'Remove offer';

  @override
  String get cmpLoanBest => 'Lowest total cost';

  @override
  String cmpLoanSavesVs(String amount) {
    return '$amount cheaper than the most expensive offer';
  }

  @override
  String get cmpLoanResults => 'Results';

  @override
  String get depYieldLabel => 'Net annual yield';

  @override
  String get fxTitle => 'Exchange rates';

  @override
  String get fxTabConverter => 'Converter';

  @override
  String get fxTabList => 'Rate list';

  @override
  String fxAmount(String currency) {
    return 'Amount in $currency';
  }

  @override
  String get fxSwap => 'Swap currencies';

  @override
  String fxRateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get fxSourceNbsMiddle => 'NBS middle rate';

  @override
  String get fxSourceNbsBuy => 'NBS buying rate';

  @override
  String get fxSourceNbsSell => 'NBS selling rate';

  @override
  String get fxSourceEcb => 'ECB reference rate';

  @override
  String get fxSourceCross => 'cross rate';

  @override
  String get fxKindMiddle => 'Middle';

  @override
  String get fxKindBuy => 'Buying';

  @override
  String get fxKindSell => 'Selling';

  @override
  String get fxKindHint =>
      'Buying and selling rates apply to dinar conversions.';

  @override
  String fxUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String fxOffline(String date) {
    return 'Offline · rates from $date';
  }

  @override
  String get fxLoading => 'Updating rates…';

  @override
  String get fxNoRates =>
      'No rates yet. Connect to the internet once to download today\'s official rates — after that the converter also works offline.';

  @override
  String get fxUnsupported => 'There\'s no official rate for this pair.';

  @override
  String fxHistoryTitle(String from, String to, int days) {
    return '$from/$to · $days days';
  }

  @override
  String fxHistoryDays(int days) {
    return '$days d';
  }

  @override
  String get fxHistoryError => 'History isn\'t available offline.';

  @override
  String get fxHistoryPro =>
      'Rate history for 30, 90 and 365 days is part of Pro.';

  @override
  String fxHistoryMinMax(String min, String max) {
    return 'min $min · max $max';
  }

  @override
  String get fxPerUnit => 'For 1 unit of currency';

  @override
  String get fxListNbs => 'NBS exchange rate list';

  @override
  String get fxListEcb => 'ECB reference rates, per 1 EUR';

  @override
  String get fxColBuy => 'Buying';

  @override
  String get fxColMiddle => 'Middle';

  @override
  String get fxColSell => 'Selling';

  @override
  String get fxColRate => 'Rate';

  @override
  String get fxRefresh => 'Refresh rates';

  @override
  String get fxPickFrom => 'Convert from';

  @override
  String get fxPickTo => 'Convert to';

  @override
  String get fxSourcesNote =>
      'Official National Bank of Serbia rates via kurs.resenje.org; European Central Bank reference rates via Frankfurter. The mark is pegged at 1.95583 per euro.';

  @override
  String get bizTitle => 'Business';

  @override
  String get bizProfile => 'Business details';

  @override
  String get bizInvoices => 'Invoices';

  @override
  String get bizNewInvoice => 'New';

  @override
  String get bizInvoicesEmpty =>
      'No invoices yet. Create a professional invoice in under a minute.';

  @override
  String bizFreeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count free invoices left',
      one: '$count free invoice left',
    );
    return '$_temp0';
  }

  @override
  String get bizTools => 'Tools';

  @override
  String bizShowAll(int count) {
    return 'Show all $count';
  }

  @override
  String bizPausalCard(int year) {
    return 'Paušal · $year';
  }

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusIssued => 'Awaiting payment';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get invNew => 'New invoice';

  @override
  String get invEdit => 'Edit invoice';

  @override
  String get invNumber => 'Invoice number';

  @override
  String get invIssueDate => 'Issue date';

  @override
  String get invServiceDate => 'Date of supply';

  @override
  String get invDueDate => 'Due date';

  @override
  String get invPlace => 'Place of issue';

  @override
  String get invClient => 'Client';

  @override
  String get invClientName => 'Client name';

  @override
  String get invClientAddress => 'Address';

  @override
  String get invClientCity => 'Postcode and city';

  @override
  String get invClientCountry => 'Country';

  @override
  String get invClientTaxId => 'Tax ID (PIB / VAT)';

  @override
  String get invClientRegNo => 'Registration number';

  @override
  String get invClientEmail => 'Email';

  @override
  String get invRecentClients => 'Recent clients';

  @override
  String get invCurrency => 'Currency';

  @override
  String get invItems => 'Items';

  @override
  String get invItemDescription => 'Description';

  @override
  String get invItemQty => 'Quantity';

  @override
  String get invItemUnit => 'Unit';

  @override
  String get invItemUnitHint => 'pcs, h, day…';

  @override
  String get invItemPrice => 'Unit price';

  @override
  String get invItemVat => 'VAT %';

  @override
  String get invAddItem => 'Add item';

  @override
  String get invRemoveItem => 'Remove item';

  @override
  String get invNote => 'Note';

  @override
  String get invReference => 'Payment reference';

  @override
  String get invReferenceHint => 'Model and number, e.g. 97 1234';

  @override
  String get invSubtotal => 'Subtotal';

  @override
  String get invVat => 'VAT';

  @override
  String get invTotal => 'Total';

  @override
  String get invTotalDue => 'Total due';

  @override
  String get invTotalRsd => 'Counter-value in RSD';

  @override
  String invRateLine(String rate, String date) {
    return 'NBS middle rate $rate on $date';
  }

  @override
  String get invRateFetching => 'Fetching the NBS rate…';

  @override
  String get invRateUnavailable =>
      'The NBS rate for this date isn\'t available yet.';

  @override
  String get invRateRetry => 'Fetch rate';

  @override
  String get invSaveDraft => 'Save draft';

  @override
  String get invIssue => 'Issue invoice';

  @override
  String get invSave => 'Save changes';

  @override
  String get invMarkPaid => 'Mark as paid';

  @override
  String get invMarkUnpaid => 'Mark as unpaid';

  @override
  String get invCancelInvoice => 'Cancel invoice';

  @override
  String get invDelete => 'Delete invoice';

  @override
  String invDeleteConfirm(String number) {
    return 'Delete invoice $number? This can\'t be undone.';
  }

  @override
  String get invDuplicate => 'Duplicate';

  @override
  String get invProfileMissing =>
      'Add your business details first — they appear on every invoice.';

  @override
  String get invProfileSetup => 'Set up business details';

  @override
  String get invNotInVat => 'The issuer is not registered for VAT.';

  @override
  String get invValidWithoutStamp =>
      'This invoice is valid without a stamp or signature.';

  @override
  String get invQrCaption => 'Scan to pay (NBS IPS)';

  @override
  String get invQrHint =>
      'Your client scans the QR code in their bank app — amount, account and reference fill in automatically.';

  @override
  String invQrMissing(String reason) {
    return 'No payment QR: $reason';
  }

  @override
  String get invQrReasonAccount =>
      'add a valid Serbian bank account in Business details';

  @override
  String get invQrReasonOther =>
      'check the business name and payment reference';

  @override
  String get invDocTitle => 'Invoice';

  @override
  String get invSeller => 'Seller';

  @override
  String get invBuyer => 'Buyer';

  @override
  String invPaidOn(String date) {
    return 'Paid on $date';
  }

  @override
  String invDueOn(String date) {
    return 'Due $date';
  }

  @override
  String get invErrorClient => 'Enter the client\'s name.';

  @override
  String get invErrorItems =>
      'Add at least one item with a description and price.';

  @override
  String get invErrorNumber => 'Enter an invoice number.';

  @override
  String get invErrorDue => 'The due date can\'t be before the issue date.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Invoice $number already exists.';
  }

  @override
  String invLimitTitle(int count) {
    return 'You\'ve created $count free invoices';
  }

  @override
  String get invShare => 'Share PDF';

  @override
  String get invPreview => 'Preview';

  @override
  String get invAccount => 'Account';

  @override
  String get invPib => 'PIB';

  @override
  String get invMb => 'MB';

  @override
  String get invReferenceLabel => 'Reference';

  @override
  String get invPlaceLabel => 'Place';

  @override
  String get invColItem => 'Item';

  @override
  String get invColQty => 'Qty';

  @override
  String get invColPrice => 'Price';

  @override
  String get invColAmount => 'Amount';

  @override
  String get profTitle => 'Business details';

  @override
  String get profIntro =>
      'Printed on your invoices and, if you choose, on PDF reports.';

  @override
  String get profName => 'Business name';

  @override
  String get profAddress => 'Street and number';

  @override
  String get profCity => 'Postcode and city';

  @override
  String get profCountry => 'Country';

  @override
  String get profTaxId => 'Tax ID (PIB)';

  @override
  String get profRegNo => 'Registration number (MB)';

  @override
  String get profAccount => 'Bank account';

  @override
  String get profAccountHint =>
      'Serbian account (160-0000000000000-00) or IBAN';

  @override
  String get profBank => 'Bank';

  @override
  String get profEmail => 'Email';

  @override
  String get profPhone => 'Phone';

  @override
  String get profVat => 'Registered for VAT';

  @override
  String get profVatHint =>
      'Adds VAT lines to invoices. When off, invoices state that you\'re not in the VAT system.';

  @override
  String get profPaymentCode => 'Payment code for the QR (šifra plaćanja)';

  @override
  String get profPaymentCodeHint => '221 for payments for goods and services';

  @override
  String get profDueDays => 'Default payment term';

  @override
  String get profDueDaysSuffix => 'days';

  @override
  String get profCurrency => 'Default invoice currency';

  @override
  String get profNote => 'Default invoice note';

  @override
  String get profShowOnReports => 'Show business details on PDF reports';

  @override
  String get profInvalidPib =>
      'The PIB check digit doesn\'t match — please check it.';

  @override
  String get profInvalidMb =>
      'The registration number check digit doesn\'t match.';

  @override
  String get profInvalidAccount =>
      'The account number check digits don\'t match.';

  @override
  String get profSaved => 'Business details saved';

  @override
  String get pausalTitle => 'Paušal limits';

  @override
  String get pausalIntro =>
      'Flat-rate (paušal) entrepreneurs lose the regime above 6,000,000 RSD of revenue in a calendar year and must register for VAT above 8,000,000 RSD in any 12 months.';

  @override
  String get pausalAnnual => 'Paušal limit, calendar year';

  @override
  String get pausalVat => 'VAT limit, last 12 months';

  @override
  String pausalOf(String amount) {
    return 'of $amount';
  }

  @override
  String pausalLeft(String amount) {
    return '$amount left';
  }

  @override
  String pausalProjection(String amount) {
    return 'At this pace you\'ll invoice about $amount by 31 December.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'At this pace you\'ll pass the paušal limit before year-end (about $amount).';
  }

  @override
  String get pausalWarn => 'You\'ve used more than 80% of this limit.';

  @override
  String get pausalOver => 'Limit exceeded — talk to your accountant.';

  @override
  String pausalMissingRate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count foreign-currency invoices have no NBS rate and aren\'t counted.',
      one:
          '$count foreign-currency invoice has no NBS rate and isn\'t counted.',
    );
    return '$_temp0';
  }

  @override
  String get pausalSourceInvoices =>
      'Counted from issued and paid invoices (by date of supply) plus revenue you add below.';

  @override
  String get pausalManual => 'Revenue outside the app';

  @override
  String get pausalManualEmpty =>
      'Add invoices you issued elsewhere this year to keep the totals complete.';

  @override
  String get pausalManualAdd => 'Add revenue';

  @override
  String get pausalManualDate => 'Date';

  @override
  String get pausalManualAmount => 'Amount in RSD';

  @override
  String get pausalManualNote => 'Note';

  @override
  String get vatTitle => 'VAT calculator';

  @override
  String get vatAdd => 'Add VAT';

  @override
  String get vatExtract => 'Extract VAT';

  @override
  String get vatAmountNet => 'Amount without VAT';

  @override
  String get vatAmountGross => 'Amount with VAT';

  @override
  String get vatRate => 'VAT rate';

  @override
  String get vatOther => 'Other';

  @override
  String get vatNet => 'Without VAT';

  @override
  String get vatVat => 'VAT';

  @override
  String get vatGross => 'With VAT';

  @override
  String get mrgTitle => 'Margin and markup';

  @override
  String get mrgFromPrice => 'Cost & price';

  @override
  String get mrgFromMarkup => 'Markup';

  @override
  String get mrgFromMargin => 'Margin';

  @override
  String get mrgCost => 'Cost price';

  @override
  String get mrgPrice => 'Selling price (excl. VAT)';

  @override
  String get mrgMarkup => 'Markup';

  @override
  String get mrgMargin => 'Margin';

  @override
  String get mrgDiscount => 'Discount';

  @override
  String get mrgVat => 'VAT';

  @override
  String get mrgProfit => 'Gross profit';

  @override
  String get mrgPriceAfterDiscount => 'Price after discount';

  @override
  String get mrgPriceWithVat => 'Price with VAT';

  @override
  String get mrgMarginHint =>
      'Margin is profit as a share of the price; markup is profit as a share of the cost.';

  @override
  String get mrgImpossible => 'A margin of 100% or more isn\'t possible.';

  @override
  String get beTitle => 'Break-even';

  @override
  String get beFixed => 'Fixed costs per month';

  @override
  String get bePrice => 'Price per unit';

  @override
  String get beVariable => 'Variable cost per unit';

  @override
  String get beTarget => 'Target profit per month';

  @override
  String get beUnits => 'Units to sell per month';

  @override
  String beUnitsValue(int count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted units',
      one: '$formatted unit',
    );
    return '$_temp0';
  }

  @override
  String get beRevenue => 'Revenue needed';

  @override
  String get beContribution => 'Contribution margin';

  @override
  String get beImpossible =>
      'The price must be higher than the variable cost per unit.';

  @override
  String get invsTitle => 'Investment analysis';

  @override
  String get invsInitial => 'Initial investment';

  @override
  String get invsRate => 'Discount rate';

  @override
  String get invsFlows => 'Net cash flow by year';

  @override
  String invsYear(int n) {
    return 'Year $n';
  }

  @override
  String get invsAddYear => 'Add year';

  @override
  String get invsRemoveYear => 'Remove last year';

  @override
  String get invsNpv => 'Net present value (NPV)';

  @override
  String get invsIrr => 'Internal rate of return (IRR)';

  @override
  String get invsPayback => 'Payback period';

  @override
  String get invsDiscountedPayback => 'Discounted payback';

  @override
  String get invsPi => 'Profitability index';

  @override
  String invsYears(String years) {
    return '$years years';
  }

  @override
  String get invsNever => 'Not within these years';

  @override
  String get invsNoIrr => 'No IRR for these cash flows';

  @override
  String invsGood(String rate) {
    return 'Creates value at a $rate discount rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Destroys value at a $rate discount rate.';
  }

  @override
  String get profSectionBusiness => 'Business';

  @override
  String get profSectionPayment => 'Payment';

  @override
  String get profSectionContact => 'Contact';

  @override
  String get profSectionInvoices => 'Invoice defaults';

  @override
  String get profTaxIdGeneric => 'Tax ID';

  @override
  String get profRegNoGeneric => 'Registration number';

  @override
  String get profNameRequired => 'Enter the business name.';

  @override
  String get profPibLength => 'The PIB has 9 digits.';

  @override
  String get profMbLength => 'The registration number has 8 digits.';

  @override
  String get profInvalidAccountShape =>
      'Enter a Serbian account (160-0000000000000-00) or an IBAN.';

  @override
  String get profInvalidEmail => 'Check the email address.';

  @override
  String get profInvalidPaymentCode =>
      'Use a three-digit payment code, e.g. 221.';

  @override
  String get profPrivacy =>
      'Stored only on this phone. It is included in backups you export.';

  @override
  String get profIban => 'IBAN for payments from abroad';

  @override
  String get profIbanHint =>
      'Printed on foreign-currency invoices. Leave empty to use your account above in IBAN form.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban =>
      'Check the IBAN — the check digits don\'t match.';

  @override
  String get profInvalidSwift => 'A SWIFT/BIC code has 8 or 11 characters.';

  @override
  String get invIban => 'IBAN';

  @override
  String get invSwift => 'SWIFT/BIC';

  @override
  String get invBank => 'Bank';

  @override
  String get invSefNote =>
      'Invoices to the Serbian public sector — and, for VAT payers, to Serbian companies — must also go through SEF (e-Faktura). Bilans invoices suit clients abroad, individuals and your own records.';

  @override
  String get invRateOffline =>
      'Couldn\'t reach the NBS. Check your connection — you can also save now and fetch the rate later.';

  @override
  String get invMarkedPaid => 'Marked as paid';

  @override
  String get invMarkedUnpaid => 'Marked as unpaid';

  @override
  String get invIssued => 'Invoice issued';

  @override
  String get invCancelled => 'Invoice cancelled';

  @override
  String get invCompleteFirst =>
      'Add the client and at least one item before issuing.';

  @override
  String invCancelConfirm(String number) {
    return 'Cancel invoice $number?';
  }

  @override
  String get invCancelBody =>
      'It stays in your list, marked as cancelled, and no longer counts as revenue.';

  @override
  String get invRateMissingNote =>
      'No NBS rate yet — this invoice isn\'t counted toward your paušal limits until it has one.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'To stay under the limit, keep to about $amount a month until the end of the year.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Revenue by month, $year';
  }

  @override
  String get pausalFromInvoices => 'Invoices';

  @override
  String get pausalDisclaimer =>
      'Revenue is counted by the date of supply. Foreign-currency invoices use the NBS middle rate on the issue date. Check the final figures with your accountant.';

  @override
  String get pausalRemoveTitle => 'Remove this revenue entry?';

  @override
  String get pausalManualAmountError => 'Enter an amount.';

  @override
  String get invsFilterAll => 'All';

  @override
  String get invsFilterDrafts => 'Drafts';

  @override
  String get invsOutstanding => 'Awaiting payment';

  @override
  String get invsSearchHint => 'Search by client or number';

  @override
  String get invsNoMatch => 'No invoices match.';

  @override
  String get vatEmpty =>
      'Enter an amount to split it into the net amount and VAT.';

  @override
  String vatRatesNote(String country) {
    return 'Rates shown are the standard and reduced VAT rates in $country.';
  }

  @override
  String get mrgEmpty => 'Enter the cost and a price, markup or margin.';

  @override
  String get mrgLoss => 'At this price you sell below cost.';

  @override
  String get beFixedHint => 'Rent, salaries, subscriptions…';

  @override
  String get beVariableHint => 'Materials, commissions, delivery…';

  @override
  String get beEmpty =>
      'Enter your fixed costs, price and variable cost per unit.';

  @override
  String get beContributionUnit => 'Contribution per unit';

  @override
  String get beExplain =>
      'Each unit sold contributes its price minus its variable cost toward fixed costs and profit. Amounts are without VAT.';

  @override
  String get invsFlowsHint =>
      'Net cash flow at the end of each year. Type a minus sign for a year with more going out than coming in.';

  @override
  String get invsEmpty =>
      'Enter the investment, a discount rate and at least one year\'s cash flow.';

  @override
  String get invsCumulative => 'Cumulative cash flow';

  @override
  String get invCreatedWith => 'Created with Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead =>
      'Every calculator, every country, unlimited invoices and PDF reports. No ads, no account.';

  @override
  String get proFeatAllCountries => 'Payroll for all 9 tax systems';

  @override
  String get proFeatUnlimitedInvoices => 'Unlimited invoices';

  @override
  String get proFeatPdf => 'PDF reports';

  @override
  String get proFeatUnlimitedSaves => 'Unlimited saved calculations';

  @override
  String get proBenefitCountries =>
      'Payroll for all 9 tax systems, and the same pay compared across countries';

  @override
  String get proBenefitTeam =>
      'Team cost: your whole payroll by month and year';

  @override
  String get proBenefitInvoices => 'Unlimited invoices as professional PDFs';

  @override
  String get proBenefitInvoicesRs =>
      'Unlimited invoices with the NBS IPS payment QR code';

  @override
  String get proBenefitPausal =>
      'Paušal limit tracker for the 6 and 8 million dinar limits';

  @override
  String get proBenefitLoans => 'Compare loan offers and plan early repayments';

  @override
  String get proBenefitHistory =>
      'Exchange-rate history for 30, 90 and 365 days';

  @override
  String get proBenefitInvestment =>
      'Investment analysis: NPV, IRR and payback';

  @override
  String get proBenefitPdf => 'PDF reports for pay, loans, savings and teams';

  @override
  String get proYearly => 'Yearly';

  @override
  String get proMonthly => 'Monthly';

  @override
  String get proLifetime => 'Lifetime';

  @override
  String get proPerYear => 'per year';

  @override
  String get proPerMonth => 'per month';

  @override
  String get proOnce => 'one-time';

  @override
  String proSave(int percent) {
    return 'SAVE $percent%';
  }

  @override
  String proTrialNote(int days) {
    return '$days days free, then billed yearly';
  }

  @override
  String get proLifetimeNote => 'Pay once, keep Pro for good';

  @override
  String proStartTrial(int days) {
    return 'Start $days-day free trial';
  }

  @override
  String get proContinue => 'Continue';

  @override
  String get proRestore => 'Restore';

  @override
  String get proRestored => 'Bilans Pro is active on this device.';

  @override
  String get proNothingToRestore =>
      'No Bilans Pro purchase was found for this Google account.';

  @override
  String get proPending =>
      'Your payment is pending. Pro unlocks automatically as soon as Google Play confirms it.';

  @override
  String get proError =>
      'The purchase didn\'t go through. You haven\'t been charged — please try again.';

  @override
  String get proUnavailable =>
      'Purchases aren\'t available right now. Check that Google Play is installed and you\'re signed in, then try again.';

  @override
  String get proLegal =>
      'Subscriptions renew automatically at the price shown until you cancel. Cancel anytime in Google Play → Payments & subscriptions, at least 24 hours before the renewal date. A free trial turns into a paid yearly subscription unless you cancel before it ends.';

  @override
  String get proLegalLifetime =>
      'A one-time purchase: no subscription and no renewals. Pro stays active on every device signed in to the same Google account.';

  @override
  String get proDevSimulate => 'Simulate Pro (developer build)';

  @override
  String get proWelcome => 'Welcome to Bilans Pro';

  @override
  String get proWelcomeBody =>
      'Everything is unlocked. Thank you for supporting an independent app.';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsYourData => 'Your data';

  @override
  String get settingsExport => 'Export backup';

  @override
  String get settingsImport => 'Restore from backup';

  @override
  String get settingsBackupSubject => 'Bilans backup';

  @override
  String get settingsExported => 'Backup ready';

  @override
  String get settingsImportInvalid => 'That file isn\'t a Bilans backup.';

  @override
  String get settingsImportTitle => 'Restore this backup?';

  @override
  String get settingsImportBody =>
      'Everything in the app is replaced with the backup\'s contents — invoices, business details, team and saved calculations.';

  @override
  String get settingsImportAction => 'Restore';

  @override
  String get settingsImported => 'Backup restored';

  @override
  String get settingsDeleteAll => 'Delete all data';

  @override
  String get settingsDeleteTitle => 'Delete all data?';

  @override
  String get settingsDeleteBody =>
      'Invoices, business details, your team, saved calculations and settings are removed from this phone. Export a backup first if you might need them. Your Pro purchase is not affected.';

  @override
  String get settingsDeleteAction => 'Delete everything';

  @override
  String get settingsDataNote =>
      'Bilans has no account and no servers: your data lives only on this phone. Export a backup to move it to a new phone.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsRate => 'Rate Bilans on Google Play';

  @override
  String get settingsContact => 'Contact';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsLicenses => 'Open-source licences';

  @override
  String get settingsDisclaimer =>
      'Calculations are indicative and do not replace professional tax, legal or financial advice.';

  @override
  String get settingsProActive => 'Bilans Pro is active';

  @override
  String get settingsManageSubscription => 'Manage subscription';

  @override
  String get settingsProPitch =>
      'All countries, team payroll, unlimited invoices, PDF reports and more.';

  @override
  String get settingsSeePlans => 'See plans';
}
