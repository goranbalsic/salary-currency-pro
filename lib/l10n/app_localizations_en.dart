// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Home';

  @override
  String get navConvert => 'Convert';

  @override
  String get navSalary => 'Salary';

  @override
  String get navTools => 'Tools';

  @override
  String get navSettings => 'Settings';

  @override
  String themeToggleTooltip(String mode) {
    return 'Toggle theme ($mode)';
  }

  @override
  String get themeModeSystem => 'system';

  @override
  String get themeModeLight => 'light';

  @override
  String get themeModeDark => 'dark';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingWelcomeSubtitle =>
      'Choose your country and language to get started. You can change these anytime in Settings.';

  @override
  String get onboardingCountryLabel => 'Country';

  @override
  String get onboardingPrivacyTitle => 'Your data stays on your phone';

  @override
  String get onboardingPrivacyBody =>
      'No account. No cloud sync. No server. Everything you enter — salaries, expenses, invoices — stays only on this device. Currency conversion is the only feature that needs an internet connection; without one, the last known rate is used instead.';

  @override
  String get onboardingGoalTitle => 'What brings you here?';

  @override
  String get onboardingGoalSubtitle =>
      'We\'ll set up your home screen around it — everything else stays one tap away.';

  @override
  String get onboardingGoalSalaryTitle => 'Salary & payroll math';

  @override
  String get onboardingGoalSalaryDesc =>
      'Calculate gross-to-net pay across 9 countries';

  @override
  String get onboardingGoalExpensesTitle => 'Track income & expenses';

  @override
  String get onboardingGoalExpensesDesc =>
      'Log spending, set budgets, reach savings goals';

  @override
  String get onboardingGoalBusinessTitle => 'Freelance & business';

  @override
  String get onboardingGoalBusinessDesc =>
      'Invoices, payouts, and business tools';

  @override
  String get commonCalculate => 'Calculate';

  @override
  String get commonConvert => 'Convert';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSwapCurrencies => 'Swap currencies';

  @override
  String get commonSomethingWentWrong => 'Something went wrong.';

  @override
  String get commonFrom => 'From';

  @override
  String get commonTo => 'To';

  @override
  String get commonAmount => 'Amount';

  @override
  String get convertCardTitle => 'Convert';

  @override
  String get convertEmptyState =>
      'Enter an amount and tap Convert to see the real, live rate.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Live rate from $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Cached rate from $formatted (offline) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Enter an amount.';

  @override
  String get convertAmountIssueInvalid =>
      'That doesn\'t look like a valid number.';

  @override
  String get convertAmountIssueNegative => 'Amount can\'t be negative.';

  @override
  String get convertAmountIssueZero => 'Amount must be greater than zero.';

  @override
  String get convertAmountIssueTooLarge =>
      'That looks unusually large for an amount — double check for a typo.';

  @override
  String salaryTitle(String country) {
    return '$country Salary Calculator';
  }

  @override
  String salaryParamsLine(int year, String date) {
    return '$year parameters · effective $date';
  }

  @override
  String get salaryModeGrossToNet => 'Gross → Net';

  @override
  String get salaryModeNetToGross => 'Net → Gross';

  @override
  String salaryGrossLabel(String currencyCode) {
    return 'Gross salary (bruto), $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Net salary (neto), $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Enter a salary and tap Calculate for a full breakdown.';

  @override
  String get salaryNeto => 'Neto (take-home)';

  @override
  String get salaryBruto => 'Bruto (gross)';

  @override
  String get salaryAllowance => 'Personal allowance';

  @override
  String get salaryTaxableBase => 'Taxable base';

  @override
  String get salaryIncomeTax => 'Income tax';

  @override
  String get salaryLocalSurtax => 'Local surtax';

  @override
  String get salaryEmployeeContribTotal => 'Employee contributions (total)';

  @override
  String get salaryEmployerContribTotal => 'Employer contributions (total)';

  @override
  String get salaryBruto2 => 'Bruto 2 (total cost to employer)';

  @override
  String salarySurtaxLabel(String rate) {
    return 'Local surtax (prirez): $rate% — set this to your municipality\'s rate';
  }

  @override
  String get salaryDisclaimer =>
      'This is an estimate for informational purposes only and does not constitute tax, legal, or financial advice. Actual obligations may vary based on your specific circumstances — consult a licensed accountant or your local tax authority before making decisions.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'This gross amount is below the legal minimum contribution base ($base floor). Mandatory contributions alone meet or exceed this salary, so take-home pay is zero or negative — this salary level is impractical to register formally.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'At this income level, mandatory contributions and tax combined meet or exceed the gross salary, so take-home pay is zero or negative.';

  @override
  String salaryConfigError(String country) {
    return 'Could not load the $country tax configuration.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Enter a salary.';

  @override
  String get salaryAmountIssueInvalid =>
      'That doesn\'t look like a valid number.';

  @override
  String get salaryAmountIssueNegative => 'Salary can\'t be negative.';

  @override
  String get salaryAmountIssueZero => 'Salary must be greater than zero.';

  @override
  String get salaryAmountIssueTooLarge =>
      'That looks unusually large for a salary — double check for a typo.';

  @override
  String get toolsHubTitle => 'Financial Tools';

  @override
  String get toolsLoanTitle => 'Loans & Debt';

  @override
  String get toolsSavingsTitle => 'Savings & Growth';

  @override
  String get toolsVatTitle => 'VAT Calculator';

  @override
  String get toolsBudgetTitle => 'Budget Planner';

  @override
  String get toolsFreelancerPayoutTitle => 'Freelancer Payout';

  @override
  String get toolsFreelanceTaxTitle => 'Freelancer Self-Assessment';

  @override
  String get homeQuoteOfDay => 'Quote of the day';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsSystemDefault => 'System default';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get notifExpenseNudgeTitle => 'Log your spending';

  @override
  String get notifExpenseNudgeSubtitle =>
      'A daily evening reminder to log today\'s income and expenses';

  @override
  String get notifExpenseNudgeNotifTitle => 'Log today\'s spending?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Add today\'s income and expenses before you forget.';

  @override
  String get notifBudgetThresholdTitle => 'Budget alerts';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Notify when a category budget reaches 80% or 100%';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent% of budget';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'You\'ve spent $percent% of your $category budget this month.';
  }

  @override
  String get notifInvoiceDueTitle => 'Invoice reminders';

  @override
  String get notifInvoiceDueSubtitle =>
      'Notify the day before an invoice is due';

  @override
  String get notifInvoiceDueNotifTitle => 'Invoice due tomorrow';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency is due tomorrow.';
  }

  @override
  String get notifPausalReminderTitle => 'Paušal reminder (Serbia)';

  @override
  String get notifPausalReminderSubtitle =>
      'Monthly reminder on the 15th to file your paušal return';

  @override
  String get notifPausalReminderNotifTitle => 'Paušal filing reminder';

  @override
  String get notifPausalReminderNotifBody =>
      'Don\'t forget your monthly paušal filing and payment.';

  @override
  String notifPausalReminderNotifBodyWithAmount(String amount) {
    return 'Don\'t forget your monthly paušal filing and payment of $amount RSD.';
  }

  @override
  String get notifPausalLeadReminderTitle => 'Also remind me 3 days before';

  @override
  String get notifPausalLeadReminderSubtitle =>
      'An extra reminder on the 12th, ahead of the main one on the 15th';

  @override
  String get notifPausalLeadReminderNotifTitle => 'Paušal filing due in 3 days';

  @override
  String get notifPausalLeadReminderNotifBody =>
      'Your monthly paušal filing and payment is due in 3 days, on the 15th.';

  @override
  String get settingsWidgetsTitle => 'Home screen widgets';

  @override
  String get settingsWidgetsExplainer =>
      'Add a widget from your device\'s home screen (long-press an empty area → Widgets → Salary & Currency Pro) — the app can\'t add it for you. Once added, it updates on its own.';

  @override
  String get settingsWidgetsPinnedPairTitle =>
      'Pinned pair for the currency widget';

  @override
  String get homeWidgetBudgetLabel => 'Spent this month';

  @override
  String get homeWidgetBudgetEmpty => 'Set a budget in the app to see it here';

  @override
  String get homeWidgetPairUnavailable =>
      'Couldn\'t refresh — showing last known rate';

  @override
  String get settingsBusinessProfileTitle => 'Business profile';

  @override
  String get settingsBusinessProfileExplainer =>
      'Used on generated invoice PDFs and, for eligible Serbian RSD invoices, the NBS IPS QR payment code.';

  @override
  String get businessProfileNameLabel => 'Business / issuer name';

  @override
  String get businessProfileAddressLabel => 'Address';

  @override
  String get businessProfileCityLabel => 'City';

  @override
  String get businessProfileBankAccountLabel => 'Bank account number (Serbia)';

  @override
  String get businessProfileBankAccountHelper =>
      'Needed only for the NBS IPS QR code on RSD invoices';

  @override
  String get businessProfilePaymentCodeLabel => 'Default payment code (Serbia)';

  @override
  String get businessProfilePaymentCodeHelper =>
      '3-digit NBS payment code, e.g. 289 — needed only for the QR code';

  @override
  String get countryRs => 'Serbia';

  @override
  String get countryHr => 'Croatia';

  @override
  String get countryBa => 'Bosnia and Herzegovina';

  @override
  String get countryMe => 'Montenegro';

  @override
  String get countryMk => 'North Macedonia';

  @override
  String get countrySi => 'Slovenia';

  @override
  String get countryBg => 'Bulgaria';

  @override
  String get countryAl => 'Albania';

  @override
  String get countryRo => 'Romania';

  @override
  String get entityFbih => 'Federation of BiH';

  @override
  String get entityRepublikaSrpska => 'Republika Srpska';

  @override
  String get contribPio => 'PIO (pension & disability)';

  @override
  String get contribHealth => 'Health insurance';

  @override
  String get contribUnemployment => 'Unemployment insurance';

  @override
  String get contribPension => 'Pension insurance';

  @override
  String get contribSocial => 'Social insurance';

  @override
  String get contribChildProtection => 'Child protection contribution';

  @override
  String get contribHealthAndEmployment => 'Health & employment insurance';

  @override
  String get contribCas => 'CAS (pension insurance)';

  @override
  String get contribCass => 'CASS (health insurance)';

  @override
  String get contribCam => 'CAM (work insurance)';

  @override
  String get suffixEmployee => 'employee';

  @override
  String get suffixEmployer => 'employer';

  @override
  String get toolsLoanSubtitle => 'Monthly payment, payoff time, amortization';

  @override
  String get toolsSavingsSubtitle =>
      'Compound interest with recurring contributions';

  @override
  String get toolsVatSubtitle => 'Add or remove VAT at your country\'s rate';

  @override
  String get toolsBudgetSubtitle =>
      'Split monthly income into needs / wants / savings';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Foreign invoice → fees → real local payout';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Income tax & contributions for freelancers, 9 countries';

  @override
  String get loanScreenTitle => 'Loans & Debt';

  @override
  String get loanModePayment => 'Payment from term';

  @override
  String get loanModePayoff => 'Payoff from payment';

  @override
  String get loanPrincipal => 'Loan amount (principal)';

  @override
  String get loanRate => 'Annual interest rate (%)';

  @override
  String get loanTermMonths => 'Loan term (months)';

  @override
  String get loanFixedPayment => 'Fixed monthly payment';

  @override
  String get loanErrorPrincipalRate =>
      'Enter a valid principal and interest rate.';

  @override
  String get loanErrorTerm => 'Enter a valid loan term in months.';

  @override
  String get loanErrorPayment => 'Enter a valid monthly payment.';

  @override
  String get loanErrorTooLow =>
      'This payment is too low to ever pay off the balance — it does not even cover the interest that accrues each month.';

  @override
  String get loanMonthlyPayment => 'Monthly payment';

  @override
  String get loanTotalPaid => 'Total paid';

  @override
  String get loanTotalInterest => 'Total interest';

  @override
  String get loanNumberOfPayments => 'Number of payments';

  @override
  String get loanTimeToPayOff => 'Time to pay off';

  @override
  String loanMonthsCount(int months) {
    return '$months months';
  }

  @override
  String get savingsScreenTitle => 'Savings & Growth';

  @override
  String get savingsStartingAmount => 'Starting amount';

  @override
  String get savingsMonthlyContribution => 'Monthly contribution';

  @override
  String get savingsExpectedReturn => 'Expected annual return (%)';

  @override
  String get savingsTimeHorizon => 'Time horizon (years)';

  @override
  String get savingsErrorRateYears =>
      'Enter a valid annual rate and number of years.';

  @override
  String get savingsFutureValue => 'Future value';

  @override
  String get savingsTotalContributed => 'Total contributed';

  @override
  String get savingsInterestEarned => 'Interest earned';

  @override
  String get vatScreenTitle => 'VAT Calculator';

  @override
  String get vatStandardRateFor => 'Standard rate for';

  @override
  String get vatAdd => 'Add VAT';

  @override
  String get vatRemove => 'Remove VAT';

  @override
  String get vatNetAmount => 'Net amount (before VAT)';

  @override
  String get vatGrossAmount => 'Gross amount (VAT-inclusive)';

  @override
  String get vatRateEditable => 'VAT rate (%) — editable for reduced rates';

  @override
  String get vatGrossWithVat => 'Gross (with VAT)';

  @override
  String get vatAmountLabel => 'VAT amount';

  @override
  String get vatNetWithoutVat => 'Net (without VAT)';

  @override
  String vatRatesAsOf(String date) {
    return 'Standard rate as of $date';
  }

  @override
  String get budgetScreenTitle => 'Budget Planner';

  @override
  String get budgetMonthlyIncome => 'Monthly net income';

  @override
  String get budgetSplit => 'Split';

  @override
  String get budgetPresetSuffix => '(needs/wants/savings)';

  @override
  String get budgetNeeds => 'Needs';

  @override
  String get budgetWants => 'Wants';

  @override
  String get budgetSavings => 'Savings';

  @override
  String get freelancerScreenTitle => 'Freelancer Payout Reality Check';

  @override
  String get freelancerInvoiceAmount => 'Invoice amount';

  @override
  String get freelancerCurrency => 'Currency';

  @override
  String get freelancerPlatform => 'Platform';

  @override
  String get freelancerPlatformCustom => 'Custom';

  @override
  String get freelancerPlatformDirect => 'Direct client / wire (0%)';

  @override
  String get freelancerPlatformFee => 'Platform fee (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Bank/wire fee (flat, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Bank fee (%)';

  @override
  String get freelancerPayoutCurrency => 'Payout currency';

  @override
  String get freelancerCalculateButton => 'Calculate real payout';

  @override
  String get freelancerErrorInvoice => 'Enter a valid invoice amount.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Unexpected error: $error';
  }

  @override
  String get freelancerRealPayout => 'Real payout';

  @override
  String get freelancerInvoiceAmountRow => 'Invoice amount';

  @override
  String get freelancerPlatformFeeRow => 'Platform fee';

  @override
  String get freelancerBankFeeRow => 'Bank/wire fee';

  @override
  String get freelancerNetForeignAmount => 'Net foreign amount';

  @override
  String get samoFixedModel => 'Fixed expense model';

  @override
  String get samoMixedModel => 'Mixed expense model';

  @override
  String get samoCheaperSame =>
      'This model is the cheaper option for this amount.';

  @override
  String get samoCheaperOther =>
      'The other model would produce less tax at this amount — you may freely switch models each quarter.';

  @override
  String get freelanceTaxScreenTitle => 'Freelancer Self-Assessment';

  @override
  String get freelanceTaxCountryLabel => 'Country / regime';

  @override
  String get freelanceTaxIncomeLabelQuarterly => 'Quarterly gross income';

  @override
  String get freelanceTaxIncomeLabelAnnual => 'Annual gross income';

  @override
  String get freelanceTaxNetIncome => 'Net income';

  @override
  String get freelanceTaxGrossIncomeRow => 'Gross income';

  @override
  String get freelanceTaxDeductionRow => 'Deduction';

  @override
  String get freelanceTaxTaxableBaseRow => 'Taxable base';

  @override
  String get freelanceTaxIncomeTaxRow => 'Income tax';

  @override
  String get freelanceTaxContributionsTotalRow => 'Total contributions';

  @override
  String freelanceTaxRulesVersionBundle(String date) {
    return 'Rates bundled with the app · version $date';
  }

  @override
  String freelanceTaxRulesVersionUpdated(String date) {
    return 'Rates updated over the air · version $date';
  }

  @override
  String freelanceTaxSourcesLabel(String sources) {
    return 'Sources: $sources';
  }

  @override
  String get freelanceTaxNotAvailable => 'Not available';

  @override
  String get freelanceTaxModelLabel => 'Model';

  @override
  String get freelanceTaxVariantLabel => 'Type';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Activity category';

  @override
  String get freelanceFbihCategoryFreeProfessions => 'Free professions';

  @override
  String get freelanceFbihCategoryObrt => 'Craft business (obrt)';

  @override
  String get freelanceFbihCategoryAgriculture => 'Agriculture / forestry';

  @override
  String get freelanceFbihCategoryLumpSumObrt => 'Lump-sum craft business';

  @override
  String get freelanceFbihCategoryTraditionalCraftsTaxi =>
      'Traditional crafts / taxi';

  @override
  String get freelanceTaxCategoryLabel => 'Category';

  @override
  String get freelanceBaRsCategoryStandard => 'Standard preduzetnik';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Independent professions';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Supplementary activity / pensioner';

  @override
  String get freelanceTaxMunicipalityLabel => 'Municipality';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Podgorica / Cetinje';

  @override
  String get freelanceMeMunicipalityBudva => 'Budva';

  @override
  String get freelanceMeMunicipalityOther => 'Other municipality';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'VAT registration threshold: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return '0% income tax applies only up to $amount $currency turnover — above it, your entire profit is taxed progressively, not just the excess.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'The 80% deemed-expense benefit only applies up to $amount $currency revenue.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Popoldanski s.p. eligibility ends at $amount $currency revenue.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'The flat-rate \"paušalac\" alternative status is capped at $amount $currency — informational only, not modeled by this calculator.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Not yet reached';

  @override
  String get freelanceCliffStatusCrossed => 'Crossed';

  @override
  String get freelanceRsInsuredElsewhereLabel =>
      'Already insured elsewhere (health contribution waived)';

  @override
  String freelanceRsMinPioBaseBinds(String amount) {
    return 'Model B\'s pension contribution is floored at the minimum base ($amount) — this is the case people most often get wrong.';
  }

  @override
  String get freelanceComparatorTitle => 'Compare Model A vs Model B';

  @override
  String get freelanceComparatorQuarterLabel => 'Quarter';

  @override
  String freelanceComparatorDeadlineHint(String date) {
    return 'Filing deadline for this quarter: $date';
  }

  @override
  String get freelanceComparatorNeedsIncome =>
      'Enter an income above to compare both models.';

  @override
  String freelanceComparatorRecommended(String model, String amount) {
    return 'Recommended: $model — saves $amount in net income.';
  }

  @override
  String get settingsEntitlementFreeTitle => 'Free';

  @override
  String get settingsEntitlementFreeSubtitle =>
      'Unlock all 9 countries, unlimited comparisons, invoicing, and the compliance pack';

  @override
  String get settingsEntitlementTrialingTitle => 'Pro — free trial';

  @override
  String get settingsEntitlementTrialingSubtitle =>
      'Your 7-day trial is active — manage or cancel anytime in your store account';

  @override
  String get settingsEntitlementProTitle => 'Pro — active';

  @override
  String get settingsEntitlementProSubtitle => 'Thanks for supporting the app';

  @override
  String get settingsEntitlementLifetimeTitle => 'Pro — lifetime';

  @override
  String get settingsEntitlementLifetimeSubtitle =>
      'You have permanent access — thank you';

  @override
  String get settingsEntitlementExpiredTitle => 'Pro — expired';

  @override
  String get settingsEntitlementExpiredSubtitle =>
      'Your subscription has ended — tap to renew';

  @override
  String get settingsEntitlementPreviewTitle => 'Entitlement Preview (Dev)';

  @override
  String get settingsEntitlementPreviewDescription =>
      'Simulated for testing only — no real purchase or charge occurs. Available in developer builds only.';

  @override
  String get settingsTrustTitle => 'Why trust this app?';

  @override
  String get settingsTrustBody =>
      'Payroll, VAT, and self-taxation figures come from cited government and professional tax-advisory sources, not estimates. Each calculator shows the year its numbers apply to and the date they took effect, so you can judge freshness at a glance. See \"Privacy & Data\" and \"Works fully offline\" below for how your information is handled.';

  @override
  String get settingsAdPrivacyTitle => 'Privacy & ad preferences';

  @override
  String get settingsAdPrivacySubtitle =>
      'Review or change your ad consent choices';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Ad privacy options aren\'t available on this platform.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'No ad privacy choice is required for your region.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro covers payroll, currency conversion, and everyday financial calculators for Serbia, Croatia, Bosnia & Herzegovina, Montenegro, North Macedonia, Slovenia, Bulgaria, Albania, and Romania. All figures are sourced and dated — see each calculator\'s disclaimer for details. This app provides estimates only, not professional advice.';

  @override
  String get paywallTitle => 'Go Pro';

  @override
  String get paywallHeadline => 'Unlock the full toolkit';

  @override
  String get paywallPitch =>
      'Every payroll country, currency conversion, and core financial tool stays free either way. Pro unlocks the specialized, high-effort differentiators: all 9 countries side by side, unlimited saved comparisons, professional invoicing, and the full compliance pack.';

  @override
  String get paywallStoreUnavailable =>
      'The app store isn\'t available right now (this is expected in development builds without a configured Play Console listing). Pro will be purchasable once published.';

  @override
  String get paywallFeaturesTitle => 'What Pro unlocks';

  @override
  String get paywallFeatureAllCountries =>
      'All 9 countries\' full calculators, not just your home country';

  @override
  String get paywallFeatureUnlimitedComparisons =>
      'Unlimited saved cross-border comparisons';

  @override
  String get paywallFeatureInvoicePdf =>
      'Professional invoice PDFs with payment QR codes';

  @override
  String get paywallFeatureCompliancePack =>
      'The full paušal & VAT compliance pack';

  @override
  String get paywallSectionAnnualTitle => 'Annual';

  @override
  String get paywallAnnualBadge => 'Best value';

  @override
  String paywallAnnualTrialNote(String price) {
    return '7-day free trial, then $price/month equivalent. Cancel anytime.';
  }

  @override
  String get paywallSectionMonthlyTitle => 'Monthly';

  @override
  String get paywallLifetimeTitle => 'Lifetime';

  @override
  String get paywallLifetimeSubtitle => 'Pay once, own it forever';

  @override
  String get paywallSupportTitle => 'Support the developer';

  @override
  String get paywallSupportSubtitle =>
      'A one-time thank-you — doesn\'t change your plan or unlock anything extra';

  @override
  String paywallPricePerYear(String price) {
    return '$price/year';
  }

  @override
  String paywallPricePerMonth(String price) {
    return '$price/month';
  }

  @override
  String paywallPriceOneTime(String price) {
    return '$price one-time';
  }

  @override
  String get paywallBuySubscription => 'Subscribe';

  @override
  String get paywallBuyLifetime => 'Buy lifetime';

  @override
  String get paywallBuySupport => 'Send support';

  @override
  String get paywallProductComingSoon =>
      'Not available in this build yet — coming when the app publishes to the store';

  @override
  String get paywallProcessing => 'Processing…';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Purchase failed: $error';
  }

  @override
  String get paywallRestorePurchase => 'Restore purchase';

  @override
  String get chartTakeHome => 'Take-home';

  @override
  String get chartTax => 'Tax';

  @override
  String get chartContributions => 'Contributions';

  @override
  String get homeRecentlyUsed => 'Recently used';

  @override
  String get categoryLoansSavings => 'Loans & Savings';

  @override
  String get categoryBudgetTax => 'Budgeting & Tax';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get toolsSearchHint => 'Search tools';

  @override
  String get toolsSearchNoResults => 'No tools found';

  @override
  String get homeLastSalaryTitle => 'Last salary calculation';

  @override
  String get homeLastSalaryEmpty => 'You haven\'t calculated a salary yet.';

  @override
  String get homeLastSalaryCta => 'Calculate now';

  @override
  String get settingsPrivacyTitle => 'Privacy & Data';

  @override
  String get settingsPrivacyNote =>
      'Your calculation history is stored only on this device and is never uploaded or shared. Clearing it or uninstalling the app removes it permanently.';

  @override
  String get settingsClearHistory => 'Clear history';

  @override
  String get settingsClearHistorySubtitle =>
      'Remove all recently used calculations from Home and Tools';

  @override
  String get settingsClearHistoryDialogTitle => 'Clear history?';

  @override
  String get settingsClearHistoryDialogBody =>
      'This removes all recent activity from Home and Tools. This can\'t be undone.';

  @override
  String get settingsClearHistoryDialogCancel => 'Cancel';

  @override
  String get settingsClearHistoryDialogConfirm => 'Clear';

  @override
  String get settingsClearHistoryDone => 'History cleared';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRename => 'Rename';

  @override
  String get commonUndo => 'Undo';

  @override
  String get scenarioSaveTooltip => 'Save this calculation';

  @override
  String get scenarioSaveDialogTitle => 'Save calculation';

  @override
  String get scenarioNameLabel => 'Name';

  @override
  String get scenarioSavedConfirmation => 'Scenario saved';

  @override
  String get scenarioLimitTitle => 'Free limit reached';

  @override
  String scenarioLimitBody(int limit) {
    return 'Free accounts can save up to $limit scenarios. Upgrade to Pro for unlimited saves, comparison, and export.';
  }

  @override
  String get scenarioLimitUpgrade => 'Upgrade to Pro';

  @override
  String get myScenariosTitle => 'My Scenarios';

  @override
  String myScenariosSubtitle(int count) {
    return '$count saved';
  }

  @override
  String get myScenariosSubtitleEmpty => 'No saved scenarios yet';

  @override
  String get myScenariosEmptyState =>
      'Save a calculation from any tool to see it here.';

  @override
  String get scenarioRenameDialogTitle => 'Rename scenario';

  @override
  String get scenarioDeleteDialogTitle => 'Delete scenario?';

  @override
  String get scenarioDeleteDialogBody => 'This can\'t be undone.';

  @override
  String get categoryTracking => 'Track & Plan';

  @override
  String get toolsExpenseTrackerTitle => 'Expense Tracker';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Log income and expenses, see your monthly balance';

  @override
  String get expenseScreenTitle => 'Expense Tracker';

  @override
  String get expenseIncome => 'Income';

  @override
  String get expenseExpenses => 'Expenses';

  @override
  String get expenseBalance => 'Balance';

  @override
  String get expenseEmptyState =>
      'No transactions yet this month. Tap + to add your first income or expense.';

  @override
  String get expenseAddIncome => 'Add income';

  @override
  String get expenseAddExpense => 'Add expense';

  @override
  String get expenseAmount => 'Amount';

  @override
  String get expenseCategory => 'Category';

  @override
  String get expenseNote => 'Note (optional)';

  @override
  String get expenseDate => 'Date';

  @override
  String get expenseDeleteConfirmTitle => 'Delete this transaction?';

  @override
  String get expenseDeleteConfirmBody =>
      'You\'ll get a brief chance to undo right after.';

  @override
  String get expenseDeletedConfirmation => 'Transaction deleted';

  @override
  String get expenseEditTransaction => 'Edit transaction';

  @override
  String get expenseSearchHint => 'Search notes or categories';

  @override
  String get expenseFilterAll => 'All';

  @override
  String get expenseSortByDate => 'Sort by date';

  @override
  String get expenseSortByAmount => 'Sort by amount';

  @override
  String get expenseNoResults => 'No transactions match your search.';

  @override
  String expenseResultCount(int shown, int total) {
    return '$shown of $total';
  }

  @override
  String get expenseSpendingByCategory => 'Spending by category';

  @override
  String get toolsRecurringTitle => 'Recurring Transactions';

  @override
  String get toolsRecurringSubtitle =>
      'Rent, subscriptions, and other regular payments — define once';

  @override
  String get recurringScreenTitle => 'Recurring Transactions';

  @override
  String get recurringEmptyState =>
      'No recurring transactions yet. Add rent, subscriptions, or other regular payments once — they\'ll post automatically or wait for your review, your choice.';

  @override
  String get recurringAddTitle => 'New recurring transaction';

  @override
  String get recurringEditTitle => 'Edit recurring transaction';

  @override
  String get recurringFrequencyLabel => 'Repeats';

  @override
  String get recurringFrequencyWeekly => 'Weekly';

  @override
  String get recurringFrequencyMonthly => 'Monthly';

  @override
  String get recurringStartDateLabel => 'Starts';

  @override
  String get recurringAutoPostLabel => 'Post automatically';

  @override
  String get recurringAutoPostSubtitle =>
      'Off: review each occurrence before it\'s added';

  @override
  String get recurringPausedLabel => 'Paused';

  @override
  String get recurringPauseAction => 'Pause';

  @override
  String get recurringResumeAction => 'Resume';

  @override
  String get recurringDeleteConfirmTitle =>
      'Delete this recurring transaction?';

  @override
  String get recurringDeleteConfirmBody =>
      'This stops future occurrences. Transactions already posted are not affected.';

  @override
  String recurringReviewBannerTitle(int count) {
    return '$count recurring transactions to review';
  }

  @override
  String get recurringReviewPost => 'Post';

  @override
  String get recurringReviewSkip => 'Skip';

  @override
  String get toolsRadarTitle => 'Fixed-Cost Radar';

  @override
  String get toolsRadarSubtitle => 'See your total recurring costs at a glance';

  @override
  String get radarScreenTitle => 'Fixed-Cost Radar';

  @override
  String get radarEmptyState =>
      'No active recurring expenses yet. Add one from Recurring Transactions to see your fixed-cost total here.';

  @override
  String get radarMonthlyTotal => 'Monthly total';

  @override
  String get radarWeeklyTotal => 'Weekly total';

  @override
  String radarNextDue(String date) {
    return 'Next: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Budgets & Goals';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Set monthly spending limits and track savings goals';

  @override
  String get budgetsScreenTitle => 'Budgets & Goals';

  @override
  String get budgetsSectionCategoryBudgets => 'Category budgets';

  @override
  String get budgetsSectionGoals => 'Savings goals';

  @override
  String get budgetsNoLimitSet => 'No limit set';

  @override
  String get budgetsSetLimit => 'Set limit';

  @override
  String get budgetsEditLimit => 'Edit limit';

  @override
  String get budgetsMonthlyLimit => 'Monthly limit';

  @override
  String get budgetsOverBudget => 'Over budget';

  @override
  String get budgetsNoBudgetsHint =>
      'Set a monthly limit on any category below to track your spending against it.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Remove this limit?';

  @override
  String get budgetsDeleteLimitConfirmBody => 'You can set a new one anytime.';

  @override
  String get budgetsAddGoal => 'Add goal';

  @override
  String get budgetsGoalName => 'Goal name';

  @override
  String get budgetsTargetAmount => 'Target amount';

  @override
  String get budgetsTargetDateOptional => 'Target date (optional)';

  @override
  String get budgetsNoTargetDate => 'No target date';

  @override
  String get budgetsAddProgress => 'Add progress';

  @override
  String get budgetsProgressAmountLabel => 'Amount to add';

  @override
  String get budgetsGoalComplete => 'Goal reached!';

  @override
  String get budgetsNoGoalsYet =>
      'No savings goals yet. Add one to start tracking progress toward something specific.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Delete this goal?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'This can\'t be undone.';

  @override
  String get budgetsProgressExplanation =>
      'Progress is only updated when you add to it here — this app has no bank connection, so nothing is tracked automatically.';

  @override
  String get expenseInsightsTitle => 'Insights';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Spending is $percent% higher than last month ($current vs $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Spending is $percent% lower than last month ($current vs $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Spending is about the same as last month ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category is your largest expense category this month, at $percent% of total spending.';
  }

  @override
  String get expenseInsightHowCalculated => 'See the numbers';

  @override
  String expenseInsightCounter(int current, int total) {
    return '$current of $total';
  }

  @override
  String expenseInsightMonthCalc(String current, String previous, int percent) {
    return '($current − $previous) ÷ $previous × 100 = $percent%';
  }

  @override
  String expenseInsightCategoryCalc(
    String categoryAmount,
    String total,
    int percent,
  ) {
    return '$categoryAmount ÷ $total total × 100 = $percent%';
  }

  @override
  String get expenseExportCsv => 'Export CSV';

  @override
  String get expenseExportCopied =>
      'CSV copied to clipboard — paste it into a spreadsheet or notes app';

  @override
  String get expenseExportEmpty => 'No transactions this month to export';

  @override
  String get settingsDataManagementTitle => 'Data management';

  @override
  String get settingsExportAllData => 'Export all data (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Copy transactions, scenarios, budgets, and goals to your clipboard';

  @override
  String get settingsExportAllDataEmpty => 'There\'s no data yet to export';

  @override
  String get settingsExportAllDataDone => 'All data copied to clipboard';

  @override
  String get settingsDeleteAllData => 'Delete all local data';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Permanently erase transactions, scenarios, budgets, and goals from this device';

  @override
  String get settingsDeleteAllDataDialog1Title => 'Delete all local data?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'This permanently removes every transaction, saved scenario, category budget, and savings goal stored on this device. This cannot be undone. Your calculation history will also be cleared.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Are you absolutely sure?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'This is your last chance to cancel. There is no way to recover this data afterward.';

  @override
  String get settingsDeleteAllDataConfirm => 'Delete everything';

  @override
  String get settingsDeleteAllDataDone => 'All local data deleted';

  @override
  String get settingsOfflineStatusTitle => 'Works fully offline';

  @override
  String get settingsOfflineStatusBody =>
      'This app has no account, no cloud sync, and no server — everything you enter stays only on this device. Currency conversion rates are the only feature that needs an internet connection; if you\'re offline, the last known rate is used instead.';

  @override
  String get toolsInvoicesTitle => 'Invoices';

  @override
  String get toolsInvoicesSubtitle =>
      'Track what clients owe you — paid, unpaid, and overdue';

  @override
  String get invoicesScreenTitle => 'Invoices';

  @override
  String get invoicesEmptyState =>
      'No invoices yet. Tap + to add your first one.';

  @override
  String get invoiceOutstanding => 'Outstanding';

  @override
  String get invoiceOverdue => 'Overdue';

  @override
  String get invoiceFilterAll => 'All';

  @override
  String get invoiceFilterUnpaid => 'Unpaid';

  @override
  String get invoiceFilterOverdue => 'Overdue';

  @override
  String get invoiceFilterPaid => 'Paid';

  @override
  String get invoiceStatusPaid => 'Paid';

  @override
  String get invoiceStatusUnpaid => 'Unpaid';

  @override
  String get invoiceStatusOverdue => 'Overdue';

  @override
  String get invoiceDueLabel => 'Due';

  @override
  String get invoiceMarkPaid => 'Mark as paid';

  @override
  String get invoiceMarkUnpaid => 'Mark as unpaid';

  @override
  String get invoiceDeleteConfirmTitle => 'Delete this invoice?';

  @override
  String get invoiceDeleteConfirmBody => 'This can\'t be undone.';

  @override
  String get invoiceAddTitle => 'Add invoice';

  @override
  String get invoiceEditTitle => 'Edit invoice';

  @override
  String get invoiceClientName => 'Client name';

  @override
  String get invoiceDescription => 'Description (optional)';

  @override
  String get invoiceAmount => 'Amount';

  @override
  String get invoiceIssueDate => 'Issue date';

  @override
  String get invoiceDueDate => 'Due date';

  @override
  String get invoiceNumberLabel => 'Invoice number (optional)';

  @override
  String get invoiceAddItem => 'Add item';

  @override
  String get invoiceItemDescription => 'Description';

  @override
  String get invoiceItemQuantity => 'Qty';

  @override
  String get invoiceItemUnitPrice => 'Unit price';

  @override
  String get invoiceItemSubtotal => 'Subtotal';

  @override
  String get invoiceAmountFromItemsHelper => 'Calculated from the items below';

  @override
  String get invoiceRemoveItemTooltip => 'Remove item';

  @override
  String get invoiceGeneratePdf => 'Generate PDF';

  @override
  String get invoiceGeneratingPdf => 'Generating PDF…';

  @override
  String get invoicePdfError =>
      'Couldn\'t generate the PDF. The invoice itself hasn\'t changed — try again.';

  @override
  String get invoiceQrEligibleBody =>
      'This invoice will include a scannable NBS IPS payment code.';

  @override
  String get invoiceQrIneligibleBody =>
      'Add your bank account and payment code in Settings → Business profile to include a scannable payment QR code on this invoice.';

  @override
  String get toolsPausalTrackerTitle => 'Paušal Tracker (Serbia)';

  @override
  String get toolsPausalTrackerSubtitle =>
      'Track your turnover against the paušal ceiling and VAT threshold';

  @override
  String get pausalTrackerCeilingCardTitle =>
      'Paušal ceiling (this calendar year)';

  @override
  String get pausalTrackerVatCardTitle =>
      'VAT registration threshold (rolling 12 months)';

  @override
  String get pausalTrackerStateOk => 'On track';

  @override
  String get pausalTrackerStateWarning70 => '70% reached — worth watching';

  @override
  String get pausalTrackerStateWarning85 => '85% reached — get close attention';

  @override
  String get pausalTrackerStateWarning95 =>
      '95% reached — action likely needed soon';

  @override
  String get pausalTrackerStateExceeded => 'Exceeded';

  @override
  String pausalTrackerProjection(String date) {
    return 'At the current pace, you\'d reach the paušal ceiling around $date.';
  }

  @override
  String pausalTrackerExcludedBanner(int count) {
    return '$count invoice(s) excluded — exchange rate unavailable';
  }

  @override
  String get pausalTrackerSeeBreakdown => 'See the numbers';

  @override
  String get pausalTrackerBreakdownTitle => 'How this was calculated';

  @override
  String get pausalTrackerBreakdownExcludedHeader =>
      'Excluded — rate unavailable';

  @override
  String pausalTrackerBreakdownRateLabel(String source) {
    return 'rate: $source';
  }

  @override
  String get pausalTrackerBreakdownExcludedReason =>
      'No exchange rate could be captured for this invoice — excluded from the tracked total rather than guessed.';

  @override
  String get pausalTrackerAssessedAmountLabel =>
      'Assessed monthly paušal amount';

  @override
  String get pausalTrackerAssessedAmountHint =>
      'Optional — enter the amount from your tax decision (rešenje). This app cannot calculate it for you.';

  @override
  String get pausalTrackerAssessedAmountSaved => 'Saved';

  @override
  String pausalTrackerAssessedAmountDecomposition(
    String tax,
    String pio,
    String health,
    String unemployment,
    String total,
  ) {
    return '= $tax tax + $pio pension + $health health + $unemployment unemployment = $total of the deemed base set by your ruling.';
  }

  @override
  String get commonClearSearch => 'Clear search';

  @override
  String get expensePreviousMonth => 'Previous month';

  @override
  String get expenseNextMonth => 'Next month';

  @override
  String get homeExpenseTrackerTitle => 'This month';

  @override
  String get homeExpenseTrackerCtaEmpty => 'Track your income and expenses';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'More currencies tracked — tap to see all';

  @override
  String get catHousing => 'Housing & Rent';

  @override
  String get catUtilities => 'Utilities';

  @override
  String get catGroceries => 'Groceries';

  @override
  String get catTransport => 'Transport';

  @override
  String get catHealth => 'Health';

  @override
  String get catEducation => 'Education';

  @override
  String get catEntertainment => 'Entertainment';

  @override
  String get catOtherExpense => 'Other';

  @override
  String get catSalary => 'Salary';

  @override
  String get catFreelance => 'Freelance / Business';

  @override
  String get catOtherIncome => 'Other income';

  @override
  String get toolsCrossBorderTitle => 'Cross-Border Comparison';

  @override
  String get toolsCrossBorderSubtitle =>
      'Compare the same gross salary across all 9 countries';

  @override
  String get crossBorderGrossLabel => 'Gross salary (EUR)';

  @override
  String get crossBorderPeriodMonthly => 'Monthly';

  @override
  String get crossBorderPeriodAnnual => 'Annual';

  @override
  String get crossBorderBaEntityLabel => 'Bosnia and Herzegovina entity';

  @override
  String get crossBorderColumnCountry => 'Country';

  @override
  String get crossBorderColumnGross => 'Gross';

  @override
  String get crossBorderColumnDeductions => 'Employee deductions';

  @override
  String get crossBorderColumnNet => 'Net';

  @override
  String get crossBorderColumnEmployerCost => 'Employer cost';

  @override
  String crossBorderColumnComparisonSuffix(String label, String currency) {
    return '$label ($currency)';
  }

  @override
  String crossBorderUnavailableNoRate(String currency) {
    return 'No cached rate for $currency yet — convert it once in the Currency Converter to enable this row.';
  }

  @override
  String get crossBorderUnavailableConfig =>
      'Tax data unavailable for this country.';

  @override
  String get crossBorderScopeNote =>
      'This comparison covers gross-to-net salary and employer cost only. Per-diem and mileage rates aren\'t included yet — verified official rates weren\'t available for all countries.';

  @override
  String get crossBorderDisclaimer =>
      'Enter one gross salary in EUR. Each country converts it to its own currency using the last cached exchange rate, then runs it through that country\'s real payroll rules — never a raw currency-blind comparison. Annual figures are the monthly calculation × 12. This is an estimate for comparison only, not tax advice.';

  @override
  String crossBorderRateSourceLabel(String source, String date) {
    return '$source, cached $date';
  }

  @override
  String get crossBorderSameCurrencyLabel =>
      'Already in EUR — no conversion needed';

  @override
  String get crossBorderInitialEmptyState =>
      'Enter a gross salary and tap Calculate to compare all 9 countries.';

  @override
  String get crossBorderTapForDetail => 'Tap a row for the full breakdown';

  @override
  String get toolsReceiptScannerTitle => 'Fiscal Receipt Scanner';

  @override
  String get toolsReceiptScannerSubtitle =>
      'Scan a receipt QR code and save it locally, offline';

  @override
  String get receiptScannerScreenTitle => 'Fiscal Receipt Scanner';

  @override
  String get receiptScannerStarting => 'Starting camera…';

  @override
  String get receiptScannerHint =>
      'Point your camera at a fiscal receipt QR code';

  @override
  String get receiptScannerPermissionDeniedTitle => 'Camera access needed';

  @override
  String get receiptScannerPermissionDeniedBody =>
      'Allow camera access to scan a receipt QR code, or enter it manually below. If you previously denied access, you may need to enable it in your device\'s system settings.';

  @override
  String get receiptScannerUnavailableTitle => 'Camera unavailable';

  @override
  String get receiptScannerUnavailableBody =>
      'The camera couldn\'t be started on this device. You can still enter a receipt code manually below.';

  @override
  String get receiptScannerManualEntryButton => 'Enter manually';

  @override
  String get receiptScannerManualEntryTitle => 'Enter receipt code manually';

  @override
  String get receiptScannerManualEntryHint =>
      'Paste or type the QR code content';

  @override
  String get receiptScannerManualEntryEmptyError => 'Enter some text first';

  @override
  String get receiptScannerManualEntrySubmit => 'Add to queue';

  @override
  String get receiptScanStatusAwaitingFetch => 'Scanned, awaiting fetch';

  @override
  String get receiptScannerResultRecognizedTitle =>
      'Serbian fiscal receipt recognized';

  @override
  String receiptScannerResultRecognizedBody(String status) {
    return 'This looks like a Serbian fiscal-receipt QR code by its local format (not a fiscal verification). It\'s been added to your local queue as \"$status.\"';
  }

  @override
  String get receiptScannerResultMalformedTitle =>
      'Doesn\'t look like a valid receipt code';

  @override
  String get receiptScannerResultMalformedBody =>
      'This resembles a Serbian fiscal-receipt code but doesn\'t match the expected format. It\'s been saved so you can review it.';

  @override
  String get receiptScannerResultUnknownTitle =>
      'Not a recognized fiscal receipt';

  @override
  String get receiptScannerResultUnknownBody =>
      'This QR code doesn\'t match a supported country\'s fiscal-receipt format. It\'s been saved so you can review it.';

  @override
  String get receiptScannerResultScanAnother => 'Scan another';

  @override
  String get receiptScannerResultDone => 'Done';

  @override
  String get receiptScannerViewQueueTooltip => 'View queue';

  @override
  String get toolsReceiptQueueTitle => 'Receipt Queue';

  @override
  String get toolsReceiptQueueSubtitle =>
      'Review scanned receipts and turn them into expenses';

  @override
  String get receiptQueueScreenTitle => 'Receipt Queue';

  @override
  String get receiptQueueEmptyState =>
      'No scanned receipts yet. Scan a fiscal receipt QR code to add one here.';

  @override
  String get receiptQueueStatusLinked => 'Linked to expense';

  @override
  String get receiptQueueUnrecognizedFormat => 'Unrecognized format';

  @override
  String receiptQueueScannedAt(String date) {
    return 'Scanned $date';
  }

  @override
  String get receiptQueueDeleteConfirmTitle => 'Delete this scan?';

  @override
  String get receiptQueueDeleteConfirmBody =>
      'This removes the scanned receipt from your local queue.';

  @override
  String get receiptQueueDeletedConfirmation => 'Scan deleted';

  @override
  String get receiptHandoffTitle => 'Create expense from scan';

  @override
  String receiptHandoffFromScanNote(String date) {
    return 'From a receipt scanned on $date';
  }

  @override
  String get gateCountrySwitchTitle => 'Switch countries with Pro';

  @override
  String get gateCountrySwitchBody =>
      'The free plan covers your current country\'s full calculator. Upgrade to Pro to unlock all 9 countries.';

  @override
  String get gateCrossBorderSaveTitle => 'Save more comparisons with Pro';

  @override
  String get gateCrossBorderSaveBody =>
      'The free plan keeps one saved cross-border comparison at a time. Upgrade to Pro for unlimited saved comparisons.';

  @override
  String get gateInvoicePdfTitle => 'Generate invoice PDFs with Pro';

  @override
  String get gateInvoicePdfBody =>
      'Professional invoice PDFs with payment QR codes are a Pro feature. Upgrade to generate this invoice as a PDF.';

  @override
  String get gatePausalTrackerTitle => 'Unlock the compliance pack with Pro';

  @override
  String get gatePausalTrackerBody =>
      'The paušal & VAT compliance pack — turnover tracking, monthly reminders, and the Model A/B comparator — is a Pro feature.';

  @override
  String get toolsProBadge => 'PRO';
}
