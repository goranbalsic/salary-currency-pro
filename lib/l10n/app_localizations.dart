import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('bs'),
    Locale('en'),
    Locale('hr'),
    Locale('mk'),
    Locale('ro'),
    Locale('sl'),
    Locale('sq'),
    Locale('sr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary & Currency Pro'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navConvert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get navConvert;

  /// No description provided for @navSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get navSalary;

  /// No description provided for @navTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get navTools;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @themeToggleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme ({mode})'**
  String themeToggleTooltip(String mode);

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'system'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get themeModeDark;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your country and language to get started. You can change these anytime in Settings.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get onboardingCountryLabel;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on your phone'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'No account. No cloud sync. No server. Everything you enter — salaries, expenses, invoices — stays only on this device. Currency conversion is the only feature that needs an internet connection; without one, the last known rate is used instead.'**
  String get onboardingPrivacyBody;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you here?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll set up your home screen around it — everything else stays one tap away.'**
  String get onboardingGoalSubtitle;

  /// No description provided for @onboardingGoalSalaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary & payroll math'**
  String get onboardingGoalSalaryTitle;

  /// No description provided for @onboardingGoalSalaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate gross-to-net pay across 9 countries'**
  String get onboardingGoalSalaryDesc;

  /// No description provided for @onboardingGoalExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Track income & expenses'**
  String get onboardingGoalExpensesTitle;

  /// No description provided for @onboardingGoalExpensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Log spending, set budgets, reach savings goals'**
  String get onboardingGoalExpensesDesc;

  /// No description provided for @onboardingGoalBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Freelance & business'**
  String get onboardingGoalBusinessTitle;

  /// No description provided for @onboardingGoalBusinessDesc.
  ///
  /// In en, this message translates to:
  /// **'Invoices, payouts, and business tools'**
  String get onboardingGoalBusinessDesc;

  /// No description provided for @commonCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get commonCalculate;

  /// No description provided for @commonConvert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get commonConvert;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSwapCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Swap currencies'**
  String get commonSwapCurrencies;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get commonFrom;

  /// No description provided for @commonTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get commonTo;

  /// No description provided for @commonAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get commonAmount;

  /// No description provided for @convertCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get convertCardTitle;

  /// No description provided for @convertEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount and tap Convert to see the real, live rate.'**
  String get convertEmptyState;

  /// No description provided for @convertLiveRate.
  ///
  /// In en, this message translates to:
  /// **'Live rate from {source} · {formatted}'**
  String convertLiveRate(String source, String formatted);

  /// No description provided for @convertCachedRate.
  ///
  /// In en, this message translates to:
  /// **'Cached rate from {formatted} (offline) · {source}'**
  String convertCachedRate(String formatted, String source);

  /// No description provided for @convertAmountIssueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get convertAmountIssueEmpty;

  /// No description provided for @convertAmountIssueInvalid.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like a valid number.'**
  String get convertAmountIssueInvalid;

  /// No description provided for @convertAmountIssueNegative.
  ///
  /// In en, this message translates to:
  /// **'Amount can\'t be negative.'**
  String get convertAmountIssueNegative;

  /// No description provided for @convertAmountIssueZero.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get convertAmountIssueZero;

  /// No description provided for @convertAmountIssueTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That looks unusually large for an amount — double check for a typo.'**
  String get convertAmountIssueTooLarge;

  /// No description provided for @salaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{country} Salary Calculator'**
  String salaryTitle(String country);

  /// No description provided for @salaryParamsLine.
  ///
  /// In en, this message translates to:
  /// **'{year} parameters · effective {date}'**
  String salaryParamsLine(int year, String date);

  /// No description provided for @salaryModeGrossToNet.
  ///
  /// In en, this message translates to:
  /// **'Gross → Net'**
  String get salaryModeGrossToNet;

  /// No description provided for @salaryModeNetToGross.
  ///
  /// In en, this message translates to:
  /// **'Net → Gross'**
  String get salaryModeNetToGross;

  /// No description provided for @salaryGrossLabel.
  ///
  /// In en, this message translates to:
  /// **'Gross salary (bruto), {currencyCode}'**
  String salaryGrossLabel(String currencyCode);

  /// No description provided for @salaryNetLabel.
  ///
  /// In en, this message translates to:
  /// **'Net salary (neto), {currencyCode}'**
  String salaryNetLabel(String currencyCode);

  /// No description provided for @salaryEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Enter a salary and tap Calculate for a full breakdown.'**
  String get salaryEmptyState;

  /// No description provided for @salaryNeto.
  ///
  /// In en, this message translates to:
  /// **'Neto (take-home)'**
  String get salaryNeto;

  /// No description provided for @salaryBruto.
  ///
  /// In en, this message translates to:
  /// **'Bruto (gross)'**
  String get salaryBruto;

  /// No description provided for @salaryAllowance.
  ///
  /// In en, this message translates to:
  /// **'Personal allowance'**
  String get salaryAllowance;

  /// No description provided for @salaryTaxableBase.
  ///
  /// In en, this message translates to:
  /// **'Taxable base'**
  String get salaryTaxableBase;

  /// No description provided for @salaryIncomeTax.
  ///
  /// In en, this message translates to:
  /// **'Income tax'**
  String get salaryIncomeTax;

  /// No description provided for @salaryLocalSurtax.
  ///
  /// In en, this message translates to:
  /// **'Local surtax'**
  String get salaryLocalSurtax;

  /// No description provided for @salaryEmployeeContribTotal.
  ///
  /// In en, this message translates to:
  /// **'Employee contributions (total)'**
  String get salaryEmployeeContribTotal;

  /// No description provided for @salaryEmployerContribTotal.
  ///
  /// In en, this message translates to:
  /// **'Employer contributions (total)'**
  String get salaryEmployerContribTotal;

  /// No description provided for @salaryBruto2.
  ///
  /// In en, this message translates to:
  /// **'Bruto 2 (total cost to employer)'**
  String get salaryBruto2;

  /// No description provided for @salarySurtaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Local surtax (prirez): {rate}% — set this to your municipality\'s rate'**
  String salarySurtaxLabel(String rate);

  /// No description provided for @salaryDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is an estimate for informational purposes only and does not constitute tax, legal, or financial advice. Actual obligations may vary based on your specific circumstances — consult a licensed accountant or your local tax authority before making decisions.'**
  String get salaryDisclaimer;

  /// No description provided for @salaryNegativeNetoFloored.
  ///
  /// In en, this message translates to:
  /// **'This gross amount is below the legal minimum contribution base ({base} floor). Mandatory contributions alone meet or exceed this salary, so take-home pay is zero or negative — this salary level is impractical to register formally.'**
  String salaryNegativeNetoFloored(String base);

  /// No description provided for @salaryNegativeNetoGeneric.
  ///
  /// In en, this message translates to:
  /// **'At this income level, mandatory contributions and tax combined meet or exceed the gross salary, so take-home pay is zero or negative.'**
  String get salaryNegativeNetoGeneric;

  /// No description provided for @salaryConfigError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the {country} tax configuration.'**
  String salaryConfigError(String country);

  /// No description provided for @salaryAmountIssueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a salary.'**
  String get salaryAmountIssueEmpty;

  /// No description provided for @salaryAmountIssueInvalid.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like a valid number.'**
  String get salaryAmountIssueInvalid;

  /// No description provided for @salaryAmountIssueNegative.
  ///
  /// In en, this message translates to:
  /// **'Salary can\'t be negative.'**
  String get salaryAmountIssueNegative;

  /// No description provided for @salaryAmountIssueZero.
  ///
  /// In en, this message translates to:
  /// **'Salary must be greater than zero.'**
  String get salaryAmountIssueZero;

  /// No description provided for @salaryAmountIssueTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That looks unusually large for a salary — double check for a typo.'**
  String get salaryAmountIssueTooLarge;

  /// No description provided for @toolsHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Tools'**
  String get toolsHubTitle;

  /// No description provided for @toolsLoanTitle.
  ///
  /// In en, this message translates to:
  /// **'Loans & Debt'**
  String get toolsLoanTitle;

  /// No description provided for @toolsSavingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings & Growth'**
  String get toolsSavingsTitle;

  /// No description provided for @toolsVatTitle.
  ///
  /// In en, this message translates to:
  /// **'VAT Calculator'**
  String get toolsVatTitle;

  /// No description provided for @toolsBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Planner'**
  String get toolsBudgetTitle;

  /// No description provided for @toolsFreelancerPayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Freelancer Payout'**
  String get toolsFreelancerPayoutTitle;

  /// No description provided for @toolsFreelanceTaxTitle.
  ///
  /// In en, this message translates to:
  /// **'Freelancer Self-Assessment'**
  String get toolsFreelanceTaxTitle;

  /// No description provided for @homeQuoteOfDay.
  ///
  /// In en, this message translates to:
  /// **'Quote of the day'**
  String get homeQuoteOfDay;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeQuickActions;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsSystemDefault;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @notifExpenseNudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Log your spending'**
  String get notifExpenseNudgeTitle;

  /// No description provided for @notifExpenseNudgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A daily evening reminder to log today\'s income and expenses'**
  String get notifExpenseNudgeSubtitle;

  /// No description provided for @notifExpenseNudgeNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Log today\'s spending?'**
  String get notifExpenseNudgeNotifTitle;

  /// No description provided for @notifExpenseNudgeNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Add today\'s income and expenses before you forget.'**
  String get notifExpenseNudgeNotifBody;

  /// No description provided for @notifBudgetThresholdTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget alerts'**
  String get notifBudgetThresholdTitle;

  /// No description provided for @notifBudgetThresholdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify when a category budget reaches 80% or 100%'**
  String get notifBudgetThresholdSubtitle;

  /// No description provided for @notifBudgetThresholdNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'{category}: {percent}% of budget'**
  String notifBudgetThresholdNotifTitle(String category, int percent);

  /// No description provided for @notifBudgetThresholdNotifBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve spent {percent}% of your {category} budget this month.'**
  String notifBudgetThresholdNotifBody(String category, int percent);

  /// No description provided for @notifInvoiceDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice reminders'**
  String get notifInvoiceDueTitle;

  /// No description provided for @notifInvoiceDueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify the day before an invoice is due'**
  String get notifInvoiceDueSubtitle;

  /// No description provided for @notifInvoiceDueNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice due tomorrow'**
  String get notifInvoiceDueNotifTitle;

  /// No description provided for @notifInvoiceDueNotifBody.
  ///
  /// In en, this message translates to:
  /// **'{client}: {amount} {currency} is due tomorrow.'**
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  );

  /// No description provided for @notifPausalReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Paušal reminder (Serbia)'**
  String get notifPausalReminderTitle;

  /// No description provided for @notifPausalReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly reminder on the 15th to file your paušal return'**
  String get notifPausalReminderSubtitle;

  /// No description provided for @notifPausalReminderNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Paušal filing reminder'**
  String get notifPausalReminderNotifTitle;

  /// No description provided for @notifPausalReminderNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget your monthly paušal filing and payment.'**
  String get notifPausalReminderNotifBody;

  /// No description provided for @notifPausalReminderNotifBodyWithAmount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget your monthly paušal filing and payment of {amount} RSD.'**
  String notifPausalReminderNotifBodyWithAmount(String amount);

  /// No description provided for @notifPausalLeadReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Also remind me 3 days before'**
  String get notifPausalLeadReminderTitle;

  /// No description provided for @notifPausalLeadReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'An extra reminder on the 12th, ahead of the main one on the 15th'**
  String get notifPausalLeadReminderSubtitle;

  /// No description provided for @notifPausalLeadReminderNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Paušal filing due in 3 days'**
  String get notifPausalLeadReminderNotifTitle;

  /// No description provided for @notifPausalLeadReminderNotifBody.
  ///
  /// In en, this message translates to:
  /// **'Your monthly paušal filing and payment is due in 3 days, on the 15th.'**
  String get notifPausalLeadReminderNotifBody;

  /// No description provided for @settingsWidgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Home screen widgets'**
  String get settingsWidgetsTitle;

  /// No description provided for @settingsWidgetsExplainer.
  ///
  /// In en, this message translates to:
  /// **'Add a widget from your device\'s home screen (long-press an empty area → Widgets → Salary & Currency Pro) — the app can\'t add it for you. Once added, it updates on its own.'**
  String get settingsWidgetsExplainer;

  /// No description provided for @settingsWidgetsPinnedPairTitle.
  ///
  /// In en, this message translates to:
  /// **'Pinned pair for the currency widget'**
  String get settingsWidgetsPinnedPairTitle;

  /// No description provided for @homeWidgetBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String get homeWidgetBudgetLabel;

  /// No description provided for @homeWidgetBudgetEmpty.
  ///
  /// In en, this message translates to:
  /// **'Set a budget in the app to see it here'**
  String get homeWidgetBudgetEmpty;

  /// No description provided for @homeWidgetPairUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh — showing last known rate'**
  String get homeWidgetPairUnavailable;

  /// No description provided for @settingsBusinessProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Business profile'**
  String get settingsBusinessProfileTitle;

  /// No description provided for @settingsBusinessProfileExplainer.
  ///
  /// In en, this message translates to:
  /// **'Used on generated invoice PDFs and, for eligible Serbian RSD invoices, the NBS IPS QR payment code.'**
  String get settingsBusinessProfileExplainer;

  /// No description provided for @businessProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business / issuer name'**
  String get businessProfileNameLabel;

  /// No description provided for @businessProfileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get businessProfileAddressLabel;

  /// No description provided for @businessProfileCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get businessProfileCityLabel;

  /// No description provided for @businessProfileBankAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank account number (Serbia)'**
  String get businessProfileBankAccountLabel;

  /// No description provided for @businessProfileBankAccountHelper.
  ///
  /// In en, this message translates to:
  /// **'Needed only for the NBS IPS QR code on RSD invoices'**
  String get businessProfileBankAccountHelper;

  /// No description provided for @businessProfilePaymentCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Default payment code (Serbia)'**
  String get businessProfilePaymentCodeLabel;

  /// No description provided for @businessProfilePaymentCodeHelper.
  ///
  /// In en, this message translates to:
  /// **'3-digit NBS payment code, e.g. 289 — needed only for the QR code'**
  String get businessProfilePaymentCodeHelper;

  /// No description provided for @countryRs.
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get countryRs;

  /// No description provided for @countryHr.
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get countryHr;

  /// No description provided for @countryBa.
  ///
  /// In en, this message translates to:
  /// **'Bosnia and Herzegovina'**
  String get countryBa;

  /// No description provided for @countryMe.
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get countryMe;

  /// No description provided for @countryMk.
  ///
  /// In en, this message translates to:
  /// **'North Macedonia'**
  String get countryMk;

  /// No description provided for @countrySi.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get countrySi;

  /// No description provided for @countryBg.
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get countryBg;

  /// No description provided for @countryAl.
  ///
  /// In en, this message translates to:
  /// **'Albania'**
  String get countryAl;

  /// No description provided for @countryRo.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get countryRo;

  /// No description provided for @entityFbih.
  ///
  /// In en, this message translates to:
  /// **'Federation of BiH'**
  String get entityFbih;

  /// No description provided for @entityRepublikaSrpska.
  ///
  /// In en, this message translates to:
  /// **'Republika Srpska'**
  String get entityRepublikaSrpska;

  /// No description provided for @contribPio.
  ///
  /// In en, this message translates to:
  /// **'PIO (pension & disability)'**
  String get contribPio;

  /// No description provided for @contribHealth.
  ///
  /// In en, this message translates to:
  /// **'Health insurance'**
  String get contribHealth;

  /// No description provided for @contribUnemployment.
  ///
  /// In en, this message translates to:
  /// **'Unemployment insurance'**
  String get contribUnemployment;

  /// No description provided for @contribPension.
  ///
  /// In en, this message translates to:
  /// **'Pension insurance'**
  String get contribPension;

  /// No description provided for @contribSocial.
  ///
  /// In en, this message translates to:
  /// **'Social insurance'**
  String get contribSocial;

  /// No description provided for @contribChildProtection.
  ///
  /// In en, this message translates to:
  /// **'Child protection contribution'**
  String get contribChildProtection;

  /// No description provided for @contribHealthAndEmployment.
  ///
  /// In en, this message translates to:
  /// **'Health & employment insurance'**
  String get contribHealthAndEmployment;

  /// No description provided for @contribCas.
  ///
  /// In en, this message translates to:
  /// **'CAS (pension insurance)'**
  String get contribCas;

  /// No description provided for @contribCass.
  ///
  /// In en, this message translates to:
  /// **'CASS (health insurance)'**
  String get contribCass;

  /// No description provided for @contribCam.
  ///
  /// In en, this message translates to:
  /// **'CAM (work insurance)'**
  String get contribCam;

  /// No description provided for @suffixEmployee.
  ///
  /// In en, this message translates to:
  /// **'employee'**
  String get suffixEmployee;

  /// No description provided for @suffixEmployer.
  ///
  /// In en, this message translates to:
  /// **'employer'**
  String get suffixEmployer;

  /// No description provided for @toolsLoanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment, payoff time, amortization'**
  String get toolsLoanSubtitle;

  /// No description provided for @toolsSavingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compound interest with recurring contributions'**
  String get toolsSavingsSubtitle;

  /// No description provided for @toolsVatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add or remove VAT at your country\'s rate'**
  String get toolsVatSubtitle;

  /// No description provided for @toolsBudgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Split monthly income into needs / wants / savings'**
  String get toolsBudgetSubtitle;

  /// No description provided for @toolsFreelancerPayoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Foreign invoice → fees → real local payout'**
  String get toolsFreelancerPayoutSubtitle;

  /// No description provided for @toolsFreelanceTaxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Income tax & contributions for freelancers, 9 countries'**
  String get toolsFreelanceTaxSubtitle;

  /// No description provided for @loanScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Loans & Debt'**
  String get loanScreenTitle;

  /// No description provided for @loanModePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment from term'**
  String get loanModePayment;

  /// No description provided for @loanModePayoff.
  ///
  /// In en, this message translates to:
  /// **'Payoff from payment'**
  String get loanModePayoff;

  /// No description provided for @loanPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Loan amount (principal)'**
  String get loanPrincipal;

  /// No description provided for @loanRate.
  ///
  /// In en, this message translates to:
  /// **'Annual interest rate (%)'**
  String get loanRate;

  /// No description provided for @loanTermMonths.
  ///
  /// In en, this message translates to:
  /// **'Loan term (months)'**
  String get loanTermMonths;

  /// No description provided for @loanFixedPayment.
  ///
  /// In en, this message translates to:
  /// **'Fixed monthly payment'**
  String get loanFixedPayment;

  /// No description provided for @loanErrorPrincipalRate.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid principal and interest rate.'**
  String get loanErrorPrincipalRate;

  /// No description provided for @loanErrorTerm.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid loan term in months.'**
  String get loanErrorTerm;

  /// No description provided for @loanErrorPayment.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid monthly payment.'**
  String get loanErrorPayment;

  /// No description provided for @loanErrorTooLow.
  ///
  /// In en, this message translates to:
  /// **'This payment is too low to ever pay off the balance — it does not even cover the interest that accrues each month.'**
  String get loanErrorTooLow;

  /// No description provided for @loanMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment'**
  String get loanMonthlyPayment;

  /// No description provided for @loanTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get loanTotalPaid;

  /// No description provided for @loanTotalInterest.
  ///
  /// In en, this message translates to:
  /// **'Total interest'**
  String get loanTotalInterest;

  /// No description provided for @loanNumberOfPayments.
  ///
  /// In en, this message translates to:
  /// **'Number of payments'**
  String get loanNumberOfPayments;

  /// No description provided for @loanTimeToPayOff.
  ///
  /// In en, this message translates to:
  /// **'Time to pay off'**
  String get loanTimeToPayOff;

  /// No description provided for @loanMonthsCount.
  ///
  /// In en, this message translates to:
  /// **'{months} months'**
  String loanMonthsCount(int months);

  /// No description provided for @savingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings & Growth'**
  String get savingsScreenTitle;

  /// No description provided for @savingsStartingAmount.
  ///
  /// In en, this message translates to:
  /// **'Starting amount'**
  String get savingsStartingAmount;

  /// No description provided for @savingsMonthlyContribution.
  ///
  /// In en, this message translates to:
  /// **'Monthly contribution'**
  String get savingsMonthlyContribution;

  /// No description provided for @savingsExpectedReturn.
  ///
  /// In en, this message translates to:
  /// **'Expected annual return (%)'**
  String get savingsExpectedReturn;

  /// No description provided for @savingsTimeHorizon.
  ///
  /// In en, this message translates to:
  /// **'Time horizon (years)'**
  String get savingsTimeHorizon;

  /// No description provided for @savingsErrorRateYears.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid annual rate and number of years.'**
  String get savingsErrorRateYears;

  /// No description provided for @savingsFutureValue.
  ///
  /// In en, this message translates to:
  /// **'Future value'**
  String get savingsFutureValue;

  /// No description provided for @savingsTotalContributed.
  ///
  /// In en, this message translates to:
  /// **'Total contributed'**
  String get savingsTotalContributed;

  /// No description provided for @savingsInterestEarned.
  ///
  /// In en, this message translates to:
  /// **'Interest earned'**
  String get savingsInterestEarned;

  /// No description provided for @vatScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'VAT Calculator'**
  String get vatScreenTitle;

  /// No description provided for @vatStandardRateFor.
  ///
  /// In en, this message translates to:
  /// **'Standard rate for'**
  String get vatStandardRateFor;

  /// No description provided for @vatAdd.
  ///
  /// In en, this message translates to:
  /// **'Add VAT'**
  String get vatAdd;

  /// No description provided for @vatRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove VAT'**
  String get vatRemove;

  /// No description provided for @vatNetAmount.
  ///
  /// In en, this message translates to:
  /// **'Net amount (before VAT)'**
  String get vatNetAmount;

  /// No description provided for @vatGrossAmount.
  ///
  /// In en, this message translates to:
  /// **'Gross amount (VAT-inclusive)'**
  String get vatGrossAmount;

  /// No description provided for @vatRateEditable.
  ///
  /// In en, this message translates to:
  /// **'VAT rate (%) — editable for reduced rates'**
  String get vatRateEditable;

  /// No description provided for @vatGrossWithVat.
  ///
  /// In en, this message translates to:
  /// **'Gross (with VAT)'**
  String get vatGrossWithVat;

  /// No description provided for @vatAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT amount'**
  String get vatAmountLabel;

  /// No description provided for @vatNetWithoutVat.
  ///
  /// In en, this message translates to:
  /// **'Net (without VAT)'**
  String get vatNetWithoutVat;

  /// No description provided for @vatRatesAsOf.
  ///
  /// In en, this message translates to:
  /// **'Standard rate as of {date}'**
  String vatRatesAsOf(String date);

  /// No description provided for @budgetScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Planner'**
  String get budgetScreenTitle;

  /// No description provided for @budgetMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly net income'**
  String get budgetMonthlyIncome;

  /// No description provided for @budgetSplit.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get budgetSplit;

  /// No description provided for @budgetPresetSuffix.
  ///
  /// In en, this message translates to:
  /// **'(needs/wants/savings)'**
  String get budgetPresetSuffix;

  /// No description provided for @budgetNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get budgetNeeds;

  /// No description provided for @budgetWants.
  ///
  /// In en, this message translates to:
  /// **'Wants'**
  String get budgetWants;

  /// No description provided for @budgetSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get budgetSavings;

  /// No description provided for @freelancerScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Freelancer Payout Reality Check'**
  String get freelancerScreenTitle;

  /// No description provided for @freelancerInvoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Invoice amount'**
  String get freelancerInvoiceAmount;

  /// No description provided for @freelancerCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get freelancerCurrency;

  /// No description provided for @freelancerPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get freelancerPlatform;

  /// No description provided for @freelancerPlatformCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get freelancerPlatformCustom;

  /// No description provided for @freelancerPlatformDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct client / wire (0%)'**
  String get freelancerPlatformDirect;

  /// No description provided for @freelancerPlatformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform fee (%)'**
  String get freelancerPlatformFee;

  /// No description provided for @freelancerBankFeeFlat.
  ///
  /// In en, this message translates to:
  /// **'Bank/wire fee (flat, {currency})'**
  String freelancerBankFeeFlat(String currency);

  /// No description provided for @freelancerBankFeePercent.
  ///
  /// In en, this message translates to:
  /// **'Bank fee (%)'**
  String get freelancerBankFeePercent;

  /// No description provided for @freelancerPayoutCurrency.
  ///
  /// In en, this message translates to:
  /// **'Payout currency'**
  String get freelancerPayoutCurrency;

  /// No description provided for @freelancerCalculateButton.
  ///
  /// In en, this message translates to:
  /// **'Calculate real payout'**
  String get freelancerCalculateButton;

  /// No description provided for @freelancerErrorInvoice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid invoice amount.'**
  String get freelancerErrorInvoice;

  /// No description provided for @freelancerErrorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {error}'**
  String freelancerErrorUnexpected(String error);

  /// No description provided for @freelancerRealPayout.
  ///
  /// In en, this message translates to:
  /// **'Real payout'**
  String get freelancerRealPayout;

  /// No description provided for @freelancerInvoiceAmountRow.
  ///
  /// In en, this message translates to:
  /// **'Invoice amount'**
  String get freelancerInvoiceAmountRow;

  /// No description provided for @freelancerPlatformFeeRow.
  ///
  /// In en, this message translates to:
  /// **'Platform fee'**
  String get freelancerPlatformFeeRow;

  /// No description provided for @freelancerBankFeeRow.
  ///
  /// In en, this message translates to:
  /// **'Bank/wire fee'**
  String get freelancerBankFeeRow;

  /// No description provided for @freelancerNetForeignAmount.
  ///
  /// In en, this message translates to:
  /// **'Net foreign amount'**
  String get freelancerNetForeignAmount;

  /// No description provided for @samoFixedModel.
  ///
  /// In en, this message translates to:
  /// **'Fixed expense model'**
  String get samoFixedModel;

  /// No description provided for @samoMixedModel.
  ///
  /// In en, this message translates to:
  /// **'Mixed expense model'**
  String get samoMixedModel;

  /// No description provided for @samoCheaperSame.
  ///
  /// In en, this message translates to:
  /// **'This model is the cheaper option for this amount.'**
  String get samoCheaperSame;

  /// No description provided for @samoCheaperOther.
  ///
  /// In en, this message translates to:
  /// **'The other model would produce less tax at this amount — you may freely switch models each quarter.'**
  String get samoCheaperOther;

  /// No description provided for @freelanceTaxScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Freelancer Self-Assessment'**
  String get freelanceTaxScreenTitle;

  /// No description provided for @freelanceTaxCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country / regime'**
  String get freelanceTaxCountryLabel;

  /// No description provided for @freelanceTaxIncomeLabelQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly gross income'**
  String get freelanceTaxIncomeLabelQuarterly;

  /// No description provided for @freelanceTaxIncomeLabelAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual gross income'**
  String get freelanceTaxIncomeLabelAnnual;

  /// No description provided for @freelanceTaxNetIncome.
  ///
  /// In en, this message translates to:
  /// **'Net income'**
  String get freelanceTaxNetIncome;

  /// No description provided for @freelanceTaxGrossIncomeRow.
  ///
  /// In en, this message translates to:
  /// **'Gross income'**
  String get freelanceTaxGrossIncomeRow;

  /// No description provided for @freelanceTaxDeductionRow.
  ///
  /// In en, this message translates to:
  /// **'Deduction'**
  String get freelanceTaxDeductionRow;

  /// No description provided for @freelanceTaxTaxableBaseRow.
  ///
  /// In en, this message translates to:
  /// **'Taxable base'**
  String get freelanceTaxTaxableBaseRow;

  /// No description provided for @freelanceTaxIncomeTaxRow.
  ///
  /// In en, this message translates to:
  /// **'Income tax'**
  String get freelanceTaxIncomeTaxRow;

  /// No description provided for @freelanceTaxContributionsTotalRow.
  ///
  /// In en, this message translates to:
  /// **'Total contributions'**
  String get freelanceTaxContributionsTotalRow;

  /// No description provided for @freelanceTaxRulesVersionBundle.
  ///
  /// In en, this message translates to:
  /// **'Rates bundled with the app · version {date}'**
  String freelanceTaxRulesVersionBundle(String date);

  /// No description provided for @freelanceTaxRulesVersionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rates updated over the air · version {date}'**
  String freelanceTaxRulesVersionUpdated(String date);

  /// No description provided for @freelanceTaxSourcesLabel.
  ///
  /// In en, this message translates to:
  /// **'Sources: {sources}'**
  String freelanceTaxSourcesLabel(String sources);

  /// No description provided for @freelanceTaxNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get freelanceTaxNotAvailable;

  /// No description provided for @freelanceTaxModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get freelanceTaxModelLabel;

  /// No description provided for @freelanceTaxVariantLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get freelanceTaxVariantLabel;

  /// No description provided for @freelanceTaxActivityCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity category'**
  String get freelanceTaxActivityCategoryLabel;

  /// No description provided for @freelanceFbihCategoryFreeProfessions.
  ///
  /// In en, this message translates to:
  /// **'Free professions'**
  String get freelanceFbihCategoryFreeProfessions;

  /// No description provided for @freelanceFbihCategoryObrt.
  ///
  /// In en, this message translates to:
  /// **'Craft business (obrt)'**
  String get freelanceFbihCategoryObrt;

  /// No description provided for @freelanceFbihCategoryAgriculture.
  ///
  /// In en, this message translates to:
  /// **'Agriculture / forestry'**
  String get freelanceFbihCategoryAgriculture;

  /// No description provided for @freelanceFbihCategoryLumpSumObrt.
  ///
  /// In en, this message translates to:
  /// **'Lump-sum craft business'**
  String get freelanceFbihCategoryLumpSumObrt;

  /// No description provided for @freelanceFbihCategoryTraditionalCraftsTaxi.
  ///
  /// In en, this message translates to:
  /// **'Traditional crafts / taxi'**
  String get freelanceFbihCategoryTraditionalCraftsTaxi;

  /// No description provided for @freelanceTaxCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get freelanceTaxCategoryLabel;

  /// No description provided for @freelanceBaRsCategoryStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard preduzetnik'**
  String get freelanceBaRsCategoryStandard;

  /// No description provided for @freelanceBaRsCategoryIndependentProfessions.
  ///
  /// In en, this message translates to:
  /// **'Independent professions'**
  String get freelanceBaRsCategoryIndependentProfessions;

  /// No description provided for @freelanceBaRsCategorySupplementary.
  ///
  /// In en, this message translates to:
  /// **'Supplementary activity / pensioner'**
  String get freelanceBaRsCategorySupplementary;

  /// No description provided for @freelanceTaxMunicipalityLabel.
  ///
  /// In en, this message translates to:
  /// **'Municipality'**
  String get freelanceTaxMunicipalityLabel;

  /// No description provided for @freelanceMeMunicipalityPodgoricaCetinje.
  ///
  /// In en, this message translates to:
  /// **'Podgorica / Cetinje'**
  String get freelanceMeMunicipalityPodgoricaCetinje;

  /// No description provided for @freelanceMeMunicipalityBudva.
  ///
  /// In en, this message translates to:
  /// **'Budva'**
  String get freelanceMeMunicipalityBudva;

  /// No description provided for @freelanceMeMunicipalityOther.
  ///
  /// In en, this message translates to:
  /// **'Other municipality'**
  String get freelanceMeMunicipalityOther;

  /// No description provided for @freelanceCliffVatThreshold.
  ///
  /// In en, this message translates to:
  /// **'VAT registration threshold: {amount} {currency}'**
  String freelanceCliffVatThreshold(String amount, String currency);

  /// No description provided for @freelanceCliffAlbaniaZeroTax.
  ///
  /// In en, this message translates to:
  /// **'0% income tax applies only up to {amount} {currency} turnover — above it, your entire profit is taxed progressively, not just the excess.'**
  String freelanceCliffAlbaniaZeroTax(String amount, String currency);

  /// No description provided for @freelanceCliffSloveniaNormirani.
  ///
  /// In en, this message translates to:
  /// **'The 80% deemed-expense benefit only applies up to {amount} {currency} revenue.'**
  String freelanceCliffSloveniaNormirani(String amount, String currency);

  /// No description provided for @freelanceCliffSloveniaPopoldanski.
  ///
  /// In en, this message translates to:
  /// **'Popoldanski s.p. eligibility ends at {amount} {currency} revenue.'**
  String freelanceCliffSloveniaPopoldanski(String amount, String currency);

  /// No description provided for @freelanceCliffSerbiaPausal.
  ///
  /// In en, this message translates to:
  /// **'The flat-rate \"paušalac\" alternative status is capped at {amount} {currency} — informational only, not modeled by this calculator.'**
  String freelanceCliffSerbiaPausal(String amount, String currency);

  /// No description provided for @freelanceCliffStatusApproaching.
  ///
  /// In en, this message translates to:
  /// **'Not yet reached'**
  String get freelanceCliffStatusApproaching;

  /// No description provided for @freelanceCliffStatusCrossed.
  ///
  /// In en, this message translates to:
  /// **'Crossed'**
  String get freelanceCliffStatusCrossed;

  /// No description provided for @freelanceRsInsuredElsewhereLabel.
  ///
  /// In en, this message translates to:
  /// **'Already insured elsewhere (health contribution waived)'**
  String get freelanceRsInsuredElsewhereLabel;

  /// No description provided for @freelanceRsMinPioBaseBinds.
  ///
  /// In en, this message translates to:
  /// **'Model B\'s pension contribution is floored at the minimum base ({amount}) — this is the case people most often get wrong.'**
  String freelanceRsMinPioBaseBinds(String amount);

  /// No description provided for @freelanceComparatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare Model A vs Model B'**
  String get freelanceComparatorTitle;

  /// No description provided for @freelanceComparatorQuarterLabel.
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get freelanceComparatorQuarterLabel;

  /// No description provided for @freelanceComparatorDeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'Filing deadline for this quarter: {date}'**
  String freelanceComparatorDeadlineHint(String date);

  /// No description provided for @freelanceComparatorNeedsIncome.
  ///
  /// In en, this message translates to:
  /// **'Enter an income above to compare both models.'**
  String get freelanceComparatorNeedsIncome;

  /// No description provided for @freelanceComparatorRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended: {model} — saves {amount} in net income.'**
  String freelanceComparatorRecommended(String model, String amount);

  /// No description provided for @settingsProActive.
  ///
  /// In en, this message translates to:
  /// **'Pro — active'**
  String get settingsProActive;

  /// No description provided for @settingsProInactive.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get settingsProInactive;

  /// No description provided for @settingsProSubtitleActive.
  ///
  /// In en, this message translates to:
  /// **'Ads are off across the app'**
  String get settingsProSubtitleActive;

  /// No description provided for @settingsProSubtitleInactive.
  ///
  /// In en, this message translates to:
  /// **'Remove ads with an affordable subscription'**
  String get settingsProSubtitleInactive;

  /// No description provided for @settingsTrustTitle.
  ///
  /// In en, this message translates to:
  /// **'Why trust this app?'**
  String get settingsTrustTitle;

  /// No description provided for @settingsTrustBody.
  ///
  /// In en, this message translates to:
  /// **'Payroll, VAT, and self-taxation figures come from cited government and professional tax-advisory sources, not estimates. Each calculator shows the year its numbers apply to and the date they took effect, so you can judge freshness at a glance. See \"Privacy & Data\" and \"Works fully offline\" below for how your information is handled.'**
  String get settingsTrustBody;

  /// No description provided for @settingsAdPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & ad preferences'**
  String get settingsAdPrivacyTitle;

  /// No description provided for @settingsAdPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review or change your ad consent choices'**
  String get settingsAdPrivacySubtitle;

  /// No description provided for @settingsAdPrivacyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Ad privacy options aren\'t available on this platform.'**
  String get settingsAdPrivacyUnavailable;

  /// No description provided for @settingsAdPrivacyNotRequired.
  ///
  /// In en, this message translates to:
  /// **'No ad privacy choice is required for your region.'**
  String get settingsAdPrivacyNotRequired;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Salary & Currency Pro covers payroll, currency conversion, and everyday financial calculators for Serbia, Croatia, Bosnia & Herzegovina, Montenegro, North Macedonia, Slovenia, Bulgaria, Albania, and Romania. All figures are sourced and dated — see each calculator\'s disclaimer for details. This app provides estimates only, not professional advice.'**
  String get settingsAboutBody;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Pro'**
  String get paywallTitle;

  /// No description provided for @paywallHeadline.
  ///
  /// In en, this message translates to:
  /// **'Salary & Currency Pro'**
  String get paywallHeadline;

  /// No description provided for @paywallPitch.
  ///
  /// In en, this message translates to:
  /// **'Remove all ads across every calculator, at an affordable monthly price. Every payroll country, currency conversion, and financial tool stays free either way.'**
  String get paywallPitch;

  /// No description provided for @paywallActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re on Pro — thank you! Ads are off across the app.'**
  String get paywallActiveMessage;

  /// No description provided for @paywallStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The app store isn\'t available right now (this is expected in development builds without a configured Play Console listing). Pro will be purchasable once published.'**
  String get paywallStoreUnavailable;

  /// No description provided for @paywallProductUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The Pro subscription isn\'t set up in the store yet — this is a placeholder screen until the real product is created in Play Console.'**
  String get paywallProductUnavailable;

  /// No description provided for @paywallSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get paywallSubscribe;

  /// No description provided for @paywallProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get paywallProcessing;

  /// No description provided for @paywallPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed: {error}'**
  String paywallPurchaseFailed(String error);

  /// No description provided for @paywallRestorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get paywallRestorePurchase;

  /// No description provided for @chartTakeHome.
  ///
  /// In en, this message translates to:
  /// **'Take-home'**
  String get chartTakeHome;

  /// No description provided for @chartTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get chartTax;

  /// No description provided for @chartContributions.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get chartContributions;

  /// No description provided for @homeRecentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently used'**
  String get homeRecentlyUsed;

  /// No description provided for @categoryLoansSavings.
  ///
  /// In en, this message translates to:
  /// **'Loans & Savings'**
  String get categoryLoansSavings;

  /// No description provided for @categoryBudgetTax.
  ///
  /// In en, this message translates to:
  /// **'Budgeting & Tax'**
  String get categoryBudgetTax;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @toolsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tools'**
  String get toolsSearchHint;

  /// No description provided for @toolsSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No tools found'**
  String get toolsSearchNoResults;

  /// No description provided for @homeLastSalaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Last salary calculation'**
  String get homeLastSalaryTitle;

  /// No description provided for @homeLastSalaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t calculated a salary yet.'**
  String get homeLastSalaryEmpty;

  /// No description provided for @homeLastSalaryCta.
  ///
  /// In en, this message translates to:
  /// **'Calculate now'**
  String get homeLastSalaryCta;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your calculation history is stored only on this device and is never uploaded or shared. Clearing it or uninstalling the app removes it permanently.'**
  String get settingsPrivacyNote;

  /// No description provided for @settingsClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get settingsClearHistory;

  /// No description provided for @settingsClearHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all recently used calculations from Home and Tools'**
  String get settingsClearHistorySubtitle;

  /// No description provided for @settingsClearHistoryDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear history?'**
  String get settingsClearHistoryDialogTitle;

  /// No description provided for @settingsClearHistoryDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This removes all recent activity from Home and Tools. This can\'t be undone.'**
  String get settingsClearHistoryDialogBody;

  /// No description provided for @settingsClearHistoryDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsClearHistoryDialogCancel;

  /// No description provided for @settingsClearHistoryDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsClearHistoryDialogConfirm;

  /// No description provided for @settingsClearHistoryDone.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get settingsClearHistoryDone;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get commonRename;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @scenarioSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save this calculation'**
  String get scenarioSaveTooltip;

  /// No description provided for @scenarioSaveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save calculation'**
  String get scenarioSaveDialogTitle;

  /// No description provided for @scenarioNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get scenarioNameLabel;

  /// No description provided for @scenarioSavedConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Scenario saved'**
  String get scenarioSavedConfirmation;

  /// No description provided for @scenarioLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Free limit reached'**
  String get scenarioLimitTitle;

  /// No description provided for @scenarioLimitBody.
  ///
  /// In en, this message translates to:
  /// **'Free accounts can save up to {limit} scenarios. Upgrade to Pro for unlimited saves, comparison, and export.'**
  String scenarioLimitBody(int limit);

  /// No description provided for @scenarioLimitUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get scenarioLimitUpgrade;

  /// No description provided for @myScenariosTitle.
  ///
  /// In en, this message translates to:
  /// **'My Scenarios'**
  String get myScenariosTitle;

  /// No description provided for @myScenariosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String myScenariosSubtitle(int count);

  /// No description provided for @myScenariosSubtitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved scenarios yet'**
  String get myScenariosSubtitleEmpty;

  /// No description provided for @myScenariosEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Save a calculation from any tool to see it here.'**
  String get myScenariosEmptyState;

  /// No description provided for @scenarioRenameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename scenario'**
  String get scenarioRenameDialogTitle;

  /// No description provided for @scenarioDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete scenario?'**
  String get scenarioDeleteDialogTitle;

  /// No description provided for @scenarioDeleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get scenarioDeleteDialogBody;

  /// No description provided for @categoryTracking.
  ///
  /// In en, this message translates to:
  /// **'Track & Plan'**
  String get categoryTracking;

  /// No description provided for @toolsExpenseTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Tracker'**
  String get toolsExpenseTrackerTitle;

  /// No description provided for @toolsExpenseTrackerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log income and expenses, see your monthly balance'**
  String get toolsExpenseTrackerSubtitle;

  /// No description provided for @expenseScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Tracker'**
  String get expenseScreenTitle;

  /// No description provided for @expenseIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get expenseIncome;

  /// No description provided for @expenseExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenseExpenses;

  /// No description provided for @expenseBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get expenseBalance;

  /// No description provided for @expenseEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet this month. Tap + to add your first income or expense.'**
  String get expenseEmptyState;

  /// No description provided for @expenseAddIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get expenseAddIncome;

  /// No description provided for @expenseAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expenseAddExpense;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategory;

  /// No description provided for @expenseNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get expenseNote;

  /// No description provided for @expenseDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDate;

  /// No description provided for @expenseDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get expenseDeleteConfirmTitle;

  /// No description provided for @expenseDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a brief chance to undo right after.'**
  String get expenseDeleteConfirmBody;

  /// No description provided for @expenseDeletedConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get expenseDeletedConfirmation;

  /// No description provided for @expenseEditTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get expenseEditTransaction;

  /// No description provided for @expenseSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes or categories'**
  String get expenseSearchHint;

  /// No description provided for @expenseFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get expenseFilterAll;

  /// No description provided for @expenseSortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by date'**
  String get expenseSortByDate;

  /// No description provided for @expenseSortByAmount.
  ///
  /// In en, this message translates to:
  /// **'Sort by amount'**
  String get expenseSortByAmount;

  /// No description provided for @expenseNoResults.
  ///
  /// In en, this message translates to:
  /// **'No transactions match your search.'**
  String get expenseNoResults;

  /// No description provided for @expenseResultCount.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total}'**
  String expenseResultCount(int shown, int total);

  /// No description provided for @expenseSpendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get expenseSpendingByCategory;

  /// No description provided for @toolsRecurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring Transactions'**
  String get toolsRecurringTitle;

  /// No description provided for @toolsRecurringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rent, subscriptions, and other regular payments — define once'**
  String get toolsRecurringSubtitle;

  /// No description provided for @recurringScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring Transactions'**
  String get recurringScreenTitle;

  /// No description provided for @recurringEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No recurring transactions yet. Add rent, subscriptions, or other regular payments once — they\'ll post automatically or wait for your review, your choice.'**
  String get recurringEmptyState;

  /// No description provided for @recurringAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New recurring transaction'**
  String get recurringAddTitle;

  /// No description provided for @recurringEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit recurring transaction'**
  String get recurringEditTitle;

  /// No description provided for @recurringFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get recurringFrequencyLabel;

  /// No description provided for @recurringFrequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurringFrequencyWeekly;

  /// No description provided for @recurringFrequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurringFrequencyMonthly;

  /// No description provided for @recurringStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get recurringStartDateLabel;

  /// No description provided for @recurringAutoPostLabel.
  ///
  /// In en, this message translates to:
  /// **'Post automatically'**
  String get recurringAutoPostLabel;

  /// No description provided for @recurringAutoPostSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Off: review each occurrence before it\'s added'**
  String get recurringAutoPostSubtitle;

  /// No description provided for @recurringPausedLabel.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get recurringPausedLabel;

  /// No description provided for @recurringPauseAction.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get recurringPauseAction;

  /// No description provided for @recurringResumeAction.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get recurringResumeAction;

  /// No description provided for @recurringDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this recurring transaction?'**
  String get recurringDeleteConfirmTitle;

  /// No description provided for @recurringDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This stops future occurrences. Transactions already posted are not affected.'**
  String get recurringDeleteConfirmBody;

  /// No description provided for @recurringReviewBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} recurring transactions to review'**
  String recurringReviewBannerTitle(int count);

  /// No description provided for @recurringReviewPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get recurringReviewPost;

  /// No description provided for @recurringReviewSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get recurringReviewSkip;

  /// No description provided for @toolsRadarTitle.
  ///
  /// In en, this message translates to:
  /// **'Fixed-Cost Radar'**
  String get toolsRadarTitle;

  /// No description provided for @toolsRadarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See your total recurring costs at a glance'**
  String get toolsRadarSubtitle;

  /// No description provided for @radarScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Fixed-Cost Radar'**
  String get radarScreenTitle;

  /// No description provided for @radarEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No active recurring expenses yet. Add one from Recurring Transactions to see your fixed-cost total here.'**
  String get radarEmptyState;

  /// No description provided for @radarMonthlyTotal.
  ///
  /// In en, this message translates to:
  /// **'Monthly total'**
  String get radarMonthlyTotal;

  /// No description provided for @radarWeeklyTotal.
  ///
  /// In en, this message translates to:
  /// **'Weekly total'**
  String get radarWeeklyTotal;

  /// No description provided for @radarNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}'**
  String radarNextDue(String date);

  /// No description provided for @toolsBudgetsGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets & Goals'**
  String get toolsBudgetsGoalsTitle;

  /// No description provided for @toolsBudgetsGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set monthly spending limits and track savings goals'**
  String get toolsBudgetsGoalsSubtitle;

  /// No description provided for @budgetsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets & Goals'**
  String get budgetsScreenTitle;

  /// No description provided for @budgetsSectionCategoryBudgets.
  ///
  /// In en, this message translates to:
  /// **'Category budgets'**
  String get budgetsSectionCategoryBudgets;

  /// No description provided for @budgetsSectionGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings goals'**
  String get budgetsSectionGoals;

  /// No description provided for @budgetsNoLimitSet.
  ///
  /// In en, this message translates to:
  /// **'No limit set'**
  String get budgetsNoLimitSet;

  /// No description provided for @budgetsSetLimit.
  ///
  /// In en, this message translates to:
  /// **'Set limit'**
  String get budgetsSetLimit;

  /// No description provided for @budgetsEditLimit.
  ///
  /// In en, this message translates to:
  /// **'Edit limit'**
  String get budgetsEditLimit;

  /// No description provided for @budgetsMonthlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit'**
  String get budgetsMonthlyLimit;

  /// No description provided for @budgetsOverBudget.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get budgetsOverBudget;

  /// No description provided for @budgetsNoBudgetsHint.
  ///
  /// In en, this message translates to:
  /// **'Set a monthly limit on any category below to track your spending against it.'**
  String get budgetsNoBudgetsHint;

  /// No description provided for @budgetsDeleteLimitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this limit?'**
  String get budgetsDeleteLimitConfirmTitle;

  /// No description provided for @budgetsDeleteLimitConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You can set a new one anytime.'**
  String get budgetsDeleteLimitConfirmBody;

  /// No description provided for @budgetsAddGoal.
  ///
  /// In en, this message translates to:
  /// **'Add goal'**
  String get budgetsAddGoal;

  /// No description provided for @budgetsGoalName.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get budgetsGoalName;

  /// No description provided for @budgetsTargetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get budgetsTargetAmount;

  /// No description provided for @budgetsTargetDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Target date (optional)'**
  String get budgetsTargetDateOptional;

  /// No description provided for @budgetsNoTargetDate.
  ///
  /// In en, this message translates to:
  /// **'No target date'**
  String get budgetsNoTargetDate;

  /// No description provided for @budgetsAddProgress.
  ///
  /// In en, this message translates to:
  /// **'Add progress'**
  String get budgetsAddProgress;

  /// No description provided for @budgetsProgressAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount to add'**
  String get budgetsProgressAmountLabel;

  /// No description provided for @budgetsGoalComplete.
  ///
  /// In en, this message translates to:
  /// **'Goal reached!'**
  String get budgetsGoalComplete;

  /// No description provided for @budgetsNoGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'No savings goals yet. Add one to start tracking progress toward something specific.'**
  String get budgetsNoGoalsYet;

  /// No description provided for @budgetsDeleteGoalConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this goal?'**
  String get budgetsDeleteGoalConfirmTitle;

  /// No description provided for @budgetsDeleteGoalConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get budgetsDeleteGoalConfirmBody;

  /// No description provided for @budgetsProgressExplanation.
  ///
  /// In en, this message translates to:
  /// **'Progress is only updated when you add to it here — this app has no bank connection, so nothing is tracked automatically.'**
  String get budgetsProgressExplanation;

  /// No description provided for @expenseInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get expenseInsightsTitle;

  /// No description provided for @expenseInsightHigherThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Spending is {percent}% higher than last month ({current} vs {previous}).'**
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  );

  /// No description provided for @expenseInsightLowerThanLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Spending is {percent}% lower than last month ({current} vs {previous}).'**
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  );

  /// No description provided for @expenseInsightSameAsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Spending is about the same as last month ({current}).'**
  String expenseInsightSameAsLastMonth(String current);

  /// No description provided for @expenseInsightTopCategory.
  ///
  /// In en, this message translates to:
  /// **'{category} is your largest expense category this month, at {percent}% of total spending.'**
  String expenseInsightTopCategory(String category, int percent);

  /// No description provided for @expenseInsightHowCalculated.
  ///
  /// In en, this message translates to:
  /// **'See the numbers'**
  String get expenseInsightHowCalculated;

  /// No description provided for @expenseInsightCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String expenseInsightCounter(int current, int total);

  /// No description provided for @expenseInsightMonthCalc.
  ///
  /// In en, this message translates to:
  /// **'({current} − {previous}) ÷ {previous} × 100 = {percent}%'**
  String expenseInsightMonthCalc(String current, String previous, int percent);

  /// No description provided for @expenseInsightCategoryCalc.
  ///
  /// In en, this message translates to:
  /// **'{categoryAmount} ÷ {total} total × 100 = {percent}%'**
  String expenseInsightCategoryCalc(
    String categoryAmount,
    String total,
    int percent,
  );

  /// No description provided for @expenseExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get expenseExportCsv;

  /// No description provided for @expenseExportCopied.
  ///
  /// In en, this message translates to:
  /// **'CSV copied to clipboard — paste it into a spreadsheet or notes app'**
  String get expenseExportCopied;

  /// No description provided for @expenseExportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transactions this month to export'**
  String get expenseExportEmpty;

  /// No description provided for @settingsDataManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Data management'**
  String get settingsDataManagementTitle;

  /// No description provided for @settingsExportAllData.
  ///
  /// In en, this message translates to:
  /// **'Export all data (CSV)'**
  String get settingsExportAllData;

  /// No description provided for @settingsExportAllDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copy transactions, scenarios, budgets, and goals to your clipboard'**
  String get settingsExportAllDataSubtitle;

  /// No description provided for @settingsExportAllDataEmpty.
  ///
  /// In en, this message translates to:
  /// **'There\'s no data yet to export'**
  String get settingsExportAllDataEmpty;

  /// No description provided for @settingsExportAllDataDone.
  ///
  /// In en, this message translates to:
  /// **'All data copied to clipboard'**
  String get settingsExportAllDataDone;

  /// No description provided for @settingsDeleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data'**
  String get settingsDeleteAllData;

  /// No description provided for @settingsDeleteAllDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently erase transactions, scenarios, budgets, and goals from this device'**
  String get settingsDeleteAllDataSubtitle;

  /// No description provided for @settingsDeleteAllDataDialog1Title.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data?'**
  String get settingsDeleteAllDataDialog1Title;

  /// No description provided for @settingsDeleteAllDataDialog1Body.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes every transaction, saved scenario, category budget, and savings goal stored on this device. This cannot be undone. Your calculation history will also be cleared.'**
  String get settingsDeleteAllDataDialog1Body;

  /// No description provided for @settingsDeleteAllDataDialog2Title.
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure?'**
  String get settingsDeleteAllDataDialog2Title;

  /// No description provided for @settingsDeleteAllDataDialog2Body.
  ///
  /// In en, this message translates to:
  /// **'This is your last chance to cancel. There is no way to recover this data afterward.'**
  String get settingsDeleteAllDataDialog2Body;

  /// No description provided for @settingsDeleteAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get settingsDeleteAllDataConfirm;

  /// No description provided for @settingsDeleteAllDataDone.
  ///
  /// In en, this message translates to:
  /// **'All local data deleted'**
  String get settingsDeleteAllDataDone;

  /// No description provided for @settingsOfflineStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Works fully offline'**
  String get settingsOfflineStatusTitle;

  /// No description provided for @settingsOfflineStatusBody.
  ///
  /// In en, this message translates to:
  /// **'This app has no account, no cloud sync, and no server — everything you enter stays only on this device. Currency conversion rates are the only feature that needs an internet connection; if you\'re offline, the last known rate is used instead.'**
  String get settingsOfflineStatusBody;

  /// No description provided for @toolsInvoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get toolsInvoicesTitle;

  /// No description provided for @toolsInvoicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track what clients owe you — paid, unpaid, and overdue'**
  String get toolsInvoicesSubtitle;

  /// No description provided for @invoicesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoicesScreenTitle;

  /// No description provided for @invoicesEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet. Tap + to add your first one.'**
  String get invoicesEmptyState;

  /// No description provided for @invoiceOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get invoiceOutstanding;

  /// No description provided for @invoiceOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get invoiceOverdue;

  /// No description provided for @invoiceFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get invoiceFilterAll;

  /// No description provided for @invoiceFilterUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get invoiceFilterUnpaid;

  /// No description provided for @invoiceFilterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get invoiceFilterOverdue;

  /// No description provided for @invoiceFilterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get invoiceFilterPaid;

  /// No description provided for @invoiceStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get invoiceStatusPaid;

  /// No description provided for @invoiceStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get invoiceStatusUnpaid;

  /// No description provided for @invoiceStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get invoiceStatusOverdue;

  /// No description provided for @invoiceDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get invoiceDueLabel;

  /// No description provided for @invoiceMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get invoiceMarkPaid;

  /// No description provided for @invoiceMarkUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as unpaid'**
  String get invoiceMarkUnpaid;

  /// No description provided for @invoiceDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this invoice?'**
  String get invoiceDeleteConfirmTitle;

  /// No description provided for @invoiceDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get invoiceDeleteConfirmBody;

  /// No description provided for @invoiceAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add invoice'**
  String get invoiceAddTitle;

  /// No description provided for @invoiceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit invoice'**
  String get invoiceEditTitle;

  /// No description provided for @invoiceClientName.
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get invoiceClientName;

  /// No description provided for @invoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get invoiceDescription;

  /// No description provided for @invoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get invoiceAmount;

  /// No description provided for @invoiceIssueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get invoiceIssueDate;

  /// No description provided for @invoiceDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get invoiceDueDate;

  /// No description provided for @invoiceNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice number (optional)'**
  String get invoiceNumberLabel;

  /// No description provided for @invoiceAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get invoiceAddItem;

  /// No description provided for @invoiceItemDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get invoiceItemDescription;

  /// No description provided for @invoiceItemQuantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get invoiceItemQuantity;

  /// No description provided for @invoiceItemUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get invoiceItemUnitPrice;

  /// No description provided for @invoiceItemSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get invoiceItemSubtotal;

  /// No description provided for @invoiceAmountFromItemsHelper.
  ///
  /// In en, this message translates to:
  /// **'Calculated from the items below'**
  String get invoiceAmountFromItemsHelper;

  /// No description provided for @invoiceRemoveItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get invoiceRemoveItemTooltip;

  /// No description provided for @invoiceGeneratePdf.
  ///
  /// In en, this message translates to:
  /// **'Generate PDF'**
  String get invoiceGeneratePdf;

  /// No description provided for @invoicePdfError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t generate the PDF. The invoice itself hasn\'t changed — try again.'**
  String get invoicePdfError;

  /// No description provided for @invoiceQrEligibleBody.
  ///
  /// In en, this message translates to:
  /// **'This invoice will include a scannable NBS IPS payment code.'**
  String get invoiceQrEligibleBody;

  /// No description provided for @invoiceQrIneligibleBody.
  ///
  /// In en, this message translates to:
  /// **'Add your bank account and payment code in Settings → Business profile to include a scannable payment QR code on this invoice.'**
  String get invoiceQrIneligibleBody;

  /// No description provided for @toolsPausalTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Paušal Tracker (Serbia)'**
  String get toolsPausalTrackerTitle;

  /// No description provided for @toolsPausalTrackerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your turnover against the paušal ceiling and VAT threshold'**
  String get toolsPausalTrackerSubtitle;

  /// No description provided for @pausalTrackerCeilingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Paušal ceiling (this calendar year)'**
  String get pausalTrackerCeilingCardTitle;

  /// No description provided for @pausalTrackerVatCardTitle.
  ///
  /// In en, this message translates to:
  /// **'VAT registration threshold (rolling 12 months)'**
  String get pausalTrackerVatCardTitle;

  /// No description provided for @pausalTrackerStateOk.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get pausalTrackerStateOk;

  /// No description provided for @pausalTrackerStateWarning70.
  ///
  /// In en, this message translates to:
  /// **'70% reached — worth watching'**
  String get pausalTrackerStateWarning70;

  /// No description provided for @pausalTrackerStateWarning85.
  ///
  /// In en, this message translates to:
  /// **'85% reached — get close attention'**
  String get pausalTrackerStateWarning85;

  /// No description provided for @pausalTrackerStateWarning95.
  ///
  /// In en, this message translates to:
  /// **'95% reached — action likely needed soon'**
  String get pausalTrackerStateWarning95;

  /// No description provided for @pausalTrackerStateExceeded.
  ///
  /// In en, this message translates to:
  /// **'Exceeded'**
  String get pausalTrackerStateExceeded;

  /// No description provided for @pausalTrackerProjection.
  ///
  /// In en, this message translates to:
  /// **'At the current pace, you\'d reach the paušal ceiling around {date}.'**
  String pausalTrackerProjection(String date);

  /// No description provided for @pausalTrackerExcludedBanner.
  ///
  /// In en, this message translates to:
  /// **'{count} invoice(s) excluded — exchange rate unavailable'**
  String pausalTrackerExcludedBanner(int count);

  /// No description provided for @pausalTrackerSeeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'See the numbers'**
  String get pausalTrackerSeeBreakdown;

  /// No description provided for @pausalTrackerBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'How this was calculated'**
  String get pausalTrackerBreakdownTitle;

  /// No description provided for @pausalTrackerBreakdownExcludedHeader.
  ///
  /// In en, this message translates to:
  /// **'Excluded — rate unavailable'**
  String get pausalTrackerBreakdownExcludedHeader;

  /// No description provided for @pausalTrackerBreakdownRateLabel.
  ///
  /// In en, this message translates to:
  /// **'rate: {source}'**
  String pausalTrackerBreakdownRateLabel(String source);

  /// No description provided for @pausalTrackerBreakdownExcludedReason.
  ///
  /// In en, this message translates to:
  /// **'No exchange rate could be captured for this invoice — excluded from the tracked total rather than guessed.'**
  String get pausalTrackerBreakdownExcludedReason;

  /// No description provided for @pausalTrackerAssessedAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Assessed monthly paušal amount'**
  String get pausalTrackerAssessedAmountLabel;

  /// No description provided for @pausalTrackerAssessedAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — enter the amount from your tax decision (rešenje). This app cannot calculate it for you.'**
  String get pausalTrackerAssessedAmountHint;

  /// No description provided for @pausalTrackerAssessedAmountSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get pausalTrackerAssessedAmountSaved;

  /// No description provided for @pausalTrackerAssessedAmountDecomposition.
  ///
  /// In en, this message translates to:
  /// **'= {tax} tax + {pio} pension + {health} health + {unemployment} unemployment = {total} of the deemed base set by your ruling.'**
  String pausalTrackerAssessedAmountDecomposition(
    String tax,
    String pio,
    String health,
    String unemployment,
    String total,
  );

  /// No description provided for @commonClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get commonClearSearch;

  /// No description provided for @expensePreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get expensePreviousMonth;

  /// No description provided for @expenseNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get expenseNextMonth;

  /// No description provided for @homeExpenseTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get homeExpenseTrackerTitle;

  /// No description provided for @homeExpenseTrackerCtaEmpty.
  ///
  /// In en, this message translates to:
  /// **'Track your income and expenses'**
  String get homeExpenseTrackerCtaEmpty;

  /// No description provided for @homeExpenseTrackerMoreCurrencies.
  ///
  /// In en, this message translates to:
  /// **'More currencies tracked — tap to see all'**
  String get homeExpenseTrackerMoreCurrencies;

  /// No description provided for @catHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing & Rent'**
  String get catHousing;

  /// No description provided for @catUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get catUtilities;

  /// No description provided for @catGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get catGroceries;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get catEducation;

  /// No description provided for @catEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get catEntertainment;

  /// No description provided for @catOtherExpense.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOtherExpense;

  /// No description provided for @catSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get catSalary;

  /// No description provided for @catFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance / Business'**
  String get catFreelance;

  /// No description provided for @catOtherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other income'**
  String get catOtherIncome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bg',
    'bs',
    'en',
    'hr',
    'mk',
    'ro',
    'sl',
    'sq',
    'sr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'bs':
      return AppLocalizationsBs();
    case 'en':
      return AppLocalizationsEn();
    case 'hr':
      return AppLocalizationsHr();
    case 'mk':
      return AppLocalizationsMk();
    case 'ro':
      return AppLocalizationsRo();
    case 'sl':
      return AppLocalizationsSl();
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
