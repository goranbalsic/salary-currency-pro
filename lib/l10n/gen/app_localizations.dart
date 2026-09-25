import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Bilans'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Finance calculator'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPayroll.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get navPayroll;

  /// No description provided for @navCredit.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get navCredit;

  /// No description provided for @navFx.
  ///
  /// In en, this message translates to:
  /// **'Rates'**
  String get navFx;

  /// No description provided for @navBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get navBusiness;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get actionDownloadPdf;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @actionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// No description provided for @commonMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get commonMonthly;

  /// No description provided for @commonAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get commonAnnual;

  /// No description provided for @commonMonthsShort.
  ///
  /// In en, this message translates to:
  /// **'mo.'**
  String get commonMonthsShort;

  /// No description provided for @commonYearsShort.
  ///
  /// In en, this message translates to:
  /// **'yr.'**
  String get commonYearsShort;

  /// No description provided for @commonMonthsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} month} other{{count} months}}'**
  String commonMonthsCount(int count);

  /// No description provided for @commonYearsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} year} other{{count} years}}'**
  String commonYearsCount(int count);

  /// No description provided for @commonPercentPa.
  ///
  /// In en, this message translates to:
  /// **'% p.a.'**
  String get commonPercentPa;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get commonOptional;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @snackSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get snackSaved;

  /// No description provided for @snackDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get snackDeleted;

  /// No description provided for @snackCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get snackCopied;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorShare.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the share sheet.'**
  String get errorShare;

  /// No description provided for @errorOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link.'**
  String get errorOpenLink;

  /// No description provided for @proFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'{feature} is part of Bilans Pro'**
  String proFeatureTitle(String feature);

  /// No description provided for @countryRS.
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get countryRS;

  /// No description provided for @countryHR.
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get countryHR;

  /// No description provided for @countryBA.
  ///
  /// In en, this message translates to:
  /// **'Bosnia and Herzegovina'**
  String get countryBA;

  /// No description provided for @countryME.
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get countryME;

  /// No description provided for @countryMK.
  ///
  /// In en, this message translates to:
  /// **'North Macedonia'**
  String get countryMK;

  /// No description provided for @countrySI.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get countrySI;

  /// No description provided for @countryBG.
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get countryBG;

  /// No description provided for @countryRO.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get countryRO;

  /// No description provided for @systemFbih.
  ///
  /// In en, this message translates to:
  /// **'Federation of BiH'**
  String get systemFbih;

  /// No description provided for @systemRepublikaSrpska.
  ///
  /// In en, this message translates to:
  /// **'Republika Srpska'**
  String get systemRepublikaSrpska;

  /// No description provided for @curEUR.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get curEUR;

  /// No description provided for @curUSD.
  ///
  /// In en, this message translates to:
  /// **'US dollar'**
  String get curUSD;

  /// No description provided for @curCHF.
  ///
  /// In en, this message translates to:
  /// **'Swiss franc'**
  String get curCHF;

  /// No description provided for @curGBP.
  ///
  /// In en, this message translates to:
  /// **'British pound'**
  String get curGBP;

  /// No description provided for @curRSD.
  ///
  /// In en, this message translates to:
  /// **'Serbian dinar'**
  String get curRSD;

  /// No description provided for @curBAM.
  ///
  /// In en, this message translates to:
  /// **'Convertible mark'**
  String get curBAM;

  /// No description provided for @curMKD.
  ///
  /// In en, this message translates to:
  /// **'Macedonian denar'**
  String get curMKD;

  /// No description provided for @curRON.
  ///
  /// In en, this message translates to:
  /// **'Romanian leu'**
  String get curRON;

  /// No description provided for @curHUF.
  ///
  /// In en, this message translates to:
  /// **'Hungarian forint'**
  String get curHUF;

  /// No description provided for @curCZK.
  ///
  /// In en, this message translates to:
  /// **'Czech koruna'**
  String get curCZK;

  /// No description provided for @curPLN.
  ///
  /// In en, this message translates to:
  /// **'Polish złoty'**
  String get curPLN;

  /// No description provided for @curSEK.
  ///
  /// In en, this message translates to:
  /// **'Swedish krona'**
  String get curSEK;

  /// No description provided for @curNOK.
  ///
  /// In en, this message translates to:
  /// **'Norwegian krone'**
  String get curNOK;

  /// No description provided for @curDKK.
  ///
  /// In en, this message translates to:
  /// **'Danish krone'**
  String get curDKK;

  /// No description provided for @curJPY.
  ///
  /// In en, this message translates to:
  /// **'Japanese yen'**
  String get curJPY;

  /// No description provided for @curCNY.
  ///
  /// In en, this message translates to:
  /// **'Chinese yuan'**
  String get curCNY;

  /// No description provided for @curCAD.
  ///
  /// In en, this message translates to:
  /// **'Canadian dollar'**
  String get curCAD;

  /// No description provided for @curAUD.
  ///
  /// In en, this message translates to:
  /// **'Australian dollar'**
  String get curAUD;

  /// No description provided for @curTRY.
  ///
  /// In en, this message translates to:
  /// **'Turkish lira'**
  String get curTRY;

  /// No description provided for @curRUB.
  ///
  /// In en, this message translates to:
  /// **'Russian ruble'**
  String get curRUB;

  /// No description provided for @formFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted fields.'**
  String get formFixErrors;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardTitle;

  /// No description provided for @discardBody.
  ///
  /// In en, this message translates to:
  /// **'Your changes haven\'t been saved.'**
  String get discardBody;

  /// No description provided for @discardKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get discardKeep;

  /// No description provided for @discardAction.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardAction;

  /// No description provided for @commonMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get commonMore;

  /// No description provided for @errorPdf.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the PDF. Please try again.'**
  String get errorPdf;

  /// No description provided for @pdfLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice language'**
  String get pdfLanguageTitle;

  /// No description provided for @pdfLanguageBoth.
  ///
  /// In en, this message translates to:
  /// **'{language} + English'**
  String pdfLanguageBoth(String language);

  /// No description provided for @onbHeadline.
  ///
  /// In en, this message translates to:
  /// **'Numbers you can trust.'**
  String get onbHeadline;

  /// No description provided for @onbBody.
  ///
  /// In en, this message translates to:
  /// **'Pay, loans, official exchange rates and invoices — calculated to your country\'s rules. No account, no tracking.'**
  String get onbBody;

  /// No description provided for @onbCountry.
  ///
  /// In en, this message translates to:
  /// **'Your country'**
  String get onbCountry;

  /// No description provided for @onbBihEntities.
  ///
  /// In en, this message translates to:
  /// **'Federation of BiH and Republika Srpska'**
  String get onbBihEntities;

  /// No description provided for @onbLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get onbLanguage;

  /// No description provided for @onbLanguageDevice.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get onbLanguageDevice;

  /// No description provided for @onbPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this phone.'**
  String get onbPrivacy;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search calculators'**
  String get homeSearchHint;

  /// No description provided for @homeSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettings;

  /// No description provided for @homeRatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rates today'**
  String get homeRatesTitle;

  /// No description provided for @homeRatesNbs.
  ///
  /// In en, this message translates to:
  /// **'NBS middle rate · {date}'**
  String homeRatesNbs(String date);

  /// No description provided for @homeRatesEcb.
  ///
  /// In en, this message translates to:
  /// **'ECB reference rate · {date}'**
  String homeRatesEcb(String date);

  /// No description provided for @homeRatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Today\'s official rates appear here once you\'re online.'**
  String get homeRatesEmpty;

  /// No description provided for @homeRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get homeRecent;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeSectionPayroll.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get homeSectionPayroll;

  /// No description provided for @homeSectionCredit.
  ///
  /// In en, this message translates to:
  /// **'Loans and savings'**
  String get homeSectionCredit;

  /// No description provided for @homeSectionFx.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get homeSectionFx;

  /// No description provided for @homeSectionBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get homeSectionBusiness;

  /// No description provided for @homeNoResults.
  ///
  /// In en, this message translates to:
  /// **'No calculator matches “{query}”.'**
  String homeNoResults(String query);

  /// No description provided for @toolPayroll.
  ///
  /// In en, this message translates to:
  /// **'Gross and net pay'**
  String get toolPayroll;

  /// No description provided for @toolPayrollDesc.
  ///
  /// In en, this message translates to:
  /// **'Payroll for 9 tax systems'**
  String get toolPayrollDesc;

  /// No description provided for @toolTeam.
  ///
  /// In en, this message translates to:
  /// **'Team cost'**
  String get toolTeam;

  /// No description provided for @toolTeamDesc.
  ///
  /// In en, this message translates to:
  /// **'Monthly and annual payroll cost'**
  String get toolTeamDesc;

  /// No description provided for @toolCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare countries'**
  String get toolCompare;

  /// No description provided for @toolCompareDesc.
  ///
  /// In en, this message translates to:
  /// **'The same pay in 9 systems'**
  String get toolCompareDesc;

  /// No description provided for @toolLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get toolLoan;

  /// No description provided for @toolLoanDesc.
  ///
  /// In en, this message translates to:
  /// **'Installment, APR and schedule'**
  String get toolLoanDesc;

  /// No description provided for @toolDeposit.
  ///
  /// In en, this message translates to:
  /// **'Term deposit'**
  String get toolDeposit;

  /// No description provided for @toolDepositDesc.
  ///
  /// In en, this message translates to:
  /// **'Interest and tax on interest'**
  String get toolDepositDesc;

  /// No description provided for @toolLoanCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare loans'**
  String get toolLoanCompare;

  /// No description provided for @toolLoanCompareDesc.
  ///
  /// In en, this message translates to:
  /// **'Up to three offers, ranked by APR'**
  String get toolLoanCompareDesc;

  /// No description provided for @toolPrepay.
  ///
  /// In en, this message translates to:
  /// **'Early repayment'**
  String get toolPrepay;

  /// No description provided for @toolPrepayDesc.
  ///
  /// In en, this message translates to:
  /// **'How much interest you save'**
  String get toolPrepayDesc;

  /// No description provided for @toolConverter.
  ///
  /// In en, this message translates to:
  /// **'Currency converter'**
  String get toolConverter;

  /// No description provided for @toolConverterDesc.
  ///
  /// In en, this message translates to:
  /// **'Official NBS and ECB rates'**
  String get toolConverterDesc;

  /// No description provided for @toolRateHistory.
  ///
  /// In en, this message translates to:
  /// **'Rate history'**
  String get toolRateHistory;

  /// No description provided for @toolRateHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'30, 90 and 365 days'**
  String get toolRateHistoryDesc;

  /// No description provided for @toolInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get toolInvoices;

  /// No description provided for @toolInvoicesDescRs.
  ///
  /// In en, this message translates to:
  /// **'PDF with NBS IPS QR code'**
  String get toolInvoicesDescRs;

  /// No description provided for @toolInvoicesDesc.
  ///
  /// In en, this message translates to:
  /// **'Professional PDF invoices'**
  String get toolInvoicesDesc;

  /// No description provided for @toolPausal.
  ///
  /// In en, this message translates to:
  /// **'Paušal limits'**
  String get toolPausal;

  /// No description provided for @toolPausalDesc.
  ///
  /// In en, this message translates to:
  /// **'6 and 8 million dinars, live'**
  String get toolPausalDesc;

  /// No description provided for @toolVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get toolVat;

  /// No description provided for @toolVatDesc.
  ///
  /// In en, this message translates to:
  /// **'Add or extract VAT'**
  String get toolVatDesc;

  /// No description provided for @toolMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin and markup'**
  String get toolMargin;

  /// No description provided for @toolMarginDesc.
  ///
  /// In en, this message translates to:
  /// **'Cost, price and discount'**
  String get toolMarginDesc;

  /// No description provided for @toolBreakEven.
  ///
  /// In en, this message translates to:
  /// **'Break-even'**
  String get toolBreakEven;

  /// No description provided for @toolBreakEvenDesc.
  ///
  /// In en, this message translates to:
  /// **'How much you need to sell'**
  String get toolBreakEvenDesc;

  /// No description provided for @toolInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get toolInvestment;

  /// No description provided for @toolInvestmentDesc.
  ///
  /// In en, this message translates to:
  /// **'NPV, IRR and payback'**
  String get toolInvestmentDesc;

  /// No description provided for @recentPayroll.
  ///
  /// In en, this message translates to:
  /// **'Pay · {country}'**
  String recentPayroll(String country);

  /// No description provided for @recentFromGross.
  ///
  /// In en, this message translates to:
  /// **'net from {amount} gross'**
  String recentFromGross(String amount);

  /// No description provided for @recentFromNet.
  ///
  /// In en, this message translates to:
  /// **'gross for {amount} net'**
  String recentFromNet(String amount);

  /// No description provided for @recentFromCost.
  ///
  /// In en, this message translates to:
  /// **'gross within {amount} budget'**
  String recentFromCost(String amount);

  /// No description provided for @recentLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan · {term}'**
  String recentLoan(String term);

  /// No description provided for @recentLoanSub.
  ///
  /// In en, this message translates to:
  /// **'installment · APR {eir}'**
  String recentLoanSub(String eir);

  /// No description provided for @recentDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit · {term}'**
  String recentDeposit(String term);

  /// No description provided for @recentDepositSub.
  ///
  /// In en, this message translates to:
  /// **'at maturity · {rate}'**
  String recentDepositSub(String rate);

  /// No description provided for @recentVatAdd.
  ///
  /// In en, this message translates to:
  /// **'{amount} + VAT {rate}'**
  String recentVatAdd(String amount, String rate);

  /// No description provided for @recentVatExtract.
  ///
  /// In en, this message translates to:
  /// **'net of {amount} at {rate}'**
  String recentVatExtract(String amount, String rate);

  /// No description provided for @recentMarginSub.
  ///
  /// In en, this message translates to:
  /// **'price with VAT · margin {margin}'**
  String recentMarginSub(String margin);

  /// No description provided for @recentBreakEvenSub.
  ///
  /// In en, this message translates to:
  /// **'per month · revenue {amount}'**
  String recentBreakEvenSub(String amount);

  /// No description provided for @recentInvestmentSub.
  ///
  /// In en, this message translates to:
  /// **'NPV · IRR {irr}'**
  String recentInvestmentSub(String irr);

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved and recent'**
  String get historyTitle;

  /// No description provided for @historySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get historySaved;

  /// No description provided for @historySavedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Tap Save on any result to keep it here with a name.'**
  String get historySavedEmpty;

  /// No description provided for @historyRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Calculations you finish appear here automatically.'**
  String get historyRecentEmpty;

  /// No description provided for @historyClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the recent list?'**
  String get historyClearTitle;

  /// No description provided for @payTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay calculator'**
  String get payTitle;

  /// No description provided for @payModeGross.
  ///
  /// In en, this message translates to:
  /// **'Gross → net'**
  String get payModeGross;

  /// No description provided for @payModeNet.
  ///
  /// In en, this message translates to:
  /// **'Net → gross'**
  String get payModeNet;

  /// No description provided for @payModeCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get payModeCost;

  /// No description provided for @payModeSemantic.
  ///
  /// In en, this message translates to:
  /// **'Calculation direction'**
  String get payModeSemantic;

  /// No description provided for @payInputGross.
  ///
  /// In en, this message translates to:
  /// **'Gross pay · monthly'**
  String get payInputGross;

  /// No description provided for @payInputNet.
  ///
  /// In en, this message translates to:
  /// **'Desired net pay · monthly'**
  String get payInputNet;

  /// No description provided for @payInputCost.
  ///
  /// In en, this message translates to:
  /// **'Employer budget · monthly'**
  String get payInputCost;

  /// No description provided for @payHelperRsMinBase.
  ///
  /// In en, this message translates to:
  /// **'Minimum contribution base: {amount}'**
  String payHelperRsMinBase(String amount);

  /// No description provided for @payHelperNet.
  ///
  /// In en, this message translates to:
  /// **'The amount the employee receives'**
  String get payHelperNet;

  /// No description provided for @payHelperCost.
  ///
  /// In en, this message translates to:
  /// **'Gross pay plus all employer contributions'**
  String get payHelperCost;

  /// No description provided for @payResultNet.
  ///
  /// In en, this message translates to:
  /// **'Net pay'**
  String get payResultNet;

  /// No description provided for @payResultGross.
  ///
  /// In en, this message translates to:
  /// **'Required gross pay'**
  String get payResultGross;

  /// No description provided for @payResultGrossBudget.
  ///
  /// In en, this message translates to:
  /// **'Gross pay within budget'**
  String get payResultGrossBudget;

  /// No description provided for @payShareOfGross.
  ///
  /// In en, this message translates to:
  /// **'{percent} of gross'**
  String payShareOfGross(String percent);

  /// No description provided for @payNetLine.
  ///
  /// In en, this message translates to:
  /// **'Net pay: {amount}'**
  String payNetLine(String amount);

  /// No description provided for @payTotalCostLine.
  ///
  /// In en, this message translates to:
  /// **'Total employer cost: {amount}'**
  String payTotalCostLine(String amount);

  /// No description provided for @payApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount}'**
  String payApprox(String amount);

  /// No description provided for @payComposition.
  ///
  /// In en, this message translates to:
  /// **'Where the employer\'s total cost goes'**
  String get payComposition;

  /// No description provided for @segNet.
  ///
  /// In en, this message translates to:
  /// **'Net pay'**
  String get segNet;

  /// No description provided for @segTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get segTax;

  /// No description provided for @segEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee contributions'**
  String get segEmployee;

  /// No description provided for @segEmployer.
  ///
  /// In en, this message translates to:
  /// **'Employer contributions'**
  String get segEmployer;

  /// No description provided for @payBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get payBreakdown;

  /// No description provided for @payAnnualToggle.
  ///
  /// In en, this message translates to:
  /// **'Annual ×12'**
  String get payAnnualToggle;

  /// No description provided for @payEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get payEmployee;

  /// No description provided for @payEmployer.
  ///
  /// In en, this message translates to:
  /// **'Employer'**
  String get payEmployer;

  /// No description provided for @payGross.
  ///
  /// In en, this message translates to:
  /// **'Gross pay'**
  String get payGross;

  /// No description provided for @payNetTotal.
  ///
  /// In en, this message translates to:
  /// **'Net pay'**
  String get payNetTotal;

  /// No description provided for @payTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total cost of pay'**
  String get payTotalCost;

  /// No description provided for @payNonTaxable.
  ///
  /// In en, this message translates to:
  /// **'Non-taxable amount'**
  String get payNonTaxable;

  /// No description provided for @payPersonalAllowance.
  ///
  /// In en, this message translates to:
  /// **'Personal allowance'**
  String get payPersonalAllowance;

  /// No description provided for @payGeneralAllowance.
  ///
  /// In en, this message translates to:
  /// **'General allowance'**
  String get payGeneralAllowance;

  /// No description provided for @payPersonalExemption.
  ///
  /// In en, this message translates to:
  /// **'Personal exemption'**
  String get payPersonalExemption;

  /// No description provided for @payPersonalDeduction.
  ///
  /// In en, this message translates to:
  /// **'Personal deduction'**
  String get payPersonalDeduction;

  /// No description provided for @payTaxBase.
  ///
  /// In en, this message translates to:
  /// **'Tax base'**
  String get payTaxBase;

  /// No description provided for @payIncomeTax.
  ///
  /// In en, this message translates to:
  /// **'Income tax'**
  String get payIncomeTax;

  /// No description provided for @payTaxOn.
  ///
  /// In en, this message translates to:
  /// **'{rate} on {amount}'**
  String payTaxOn(String rate, String amount);

  /// No description provided for @paySurtax.
  ///
  /// In en, this message translates to:
  /// **'Municipal surtax'**
  String get paySurtax;

  /// No description provided for @payOnBase.
  ///
  /// In en, this message translates to:
  /// **'on {amount}'**
  String payOnBase(String amount);

  /// No description provided for @payFixedMonthly.
  ///
  /// In en, this message translates to:
  /// **'fixed monthly'**
  String get payFixedMonthly;

  /// No description provided for @payWedge.
  ///
  /// In en, this message translates to:
  /// **'Tax wedge {percent}'**
  String payWedge(String percent);

  /// No description provided for @payRulesFrom.
  ///
  /// In en, this message translates to:
  /// **'Rules from {date}'**
  String payRulesFrom(String date);

  /// No description provided for @paySources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get paySources;

  /// No description provided for @payDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Indicative calculation under the rules in force from {date}. It does not replace an official payroll.'**
  String payDisclaimer(String date);

  /// No description provided for @payAnnualNote.
  ///
  /// In en, this message translates to:
  /// **'Annual figures are 12 × the monthly amounts; year-end tax reconciliation may differ.'**
  String get payAnnualNote;

  /// No description provided for @payNoteMinBase.
  ///
  /// In en, this message translates to:
  /// **'Contributions are charged on the minimum base of {amount}.'**
  String payNoteMinBase(String amount);

  /// No description provided for @payNoteMaxBase.
  ///
  /// In en, this message translates to:
  /// **'Contributions stop at the maximum base of {amount}.'**
  String payNoteMaxBase(String amount);

  /// No description provided for @payNoteRelief.
  ///
  /// In en, this message translates to:
  /// **'Low-wage relief lowers the pension contribution base to {amount}.'**
  String payNoteRelief(String amount);

  /// No description provided for @payNoteNonPositive.
  ///
  /// In en, this message translates to:
  /// **'Mandatory charges exceed this pay.'**
  String get payNoteNonPositive;

  /// No description provided for @payEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount to see the full breakdown — contributions, tax and the employer\'s total cost.'**
  String get payEmpty;

  /// No description provided for @payErrorTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That amount is too large to calculate.'**
  String get payErrorTooLarge;

  /// No description provided for @paySystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax system'**
  String get paySystemTitle;

  /// No description provided for @paySystemProHint.
  ///
  /// In en, this message translates to:
  /// **'Your home country is free. Other countries are part of Pro.'**
  String get paySystemProHint;

  /// No description provided for @payOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get payOptions;

  /// No description provided for @payOptionsHrSummary.
  ///
  /// In en, this message translates to:
  /// **'Tax {lower} / {higher} · children {children}'**
  String payOptionsHrSummary(String lower, String higher, int children);

  /// No description provided for @payOptionsMeSummary.
  ///
  /// In en, this message translates to:
  /// **'Surtax {rate}'**
  String payOptionsMeSummary(String rate);

  /// No description provided for @payOptionsRoSummary.
  ///
  /// In en, this message translates to:
  /// **'Dependants {count}'**
  String payOptionsRoSummary(int count);

  /// No description provided for @payOptionsRoMinWage.
  ///
  /// In en, this message translates to:
  /// **'minimum-wage relief'**
  String get payOptionsRoMinWage;

  /// No description provided for @payOptionsFbihSummary.
  ///
  /// In en, this message translates to:
  /// **'Disability fund {state}'**
  String payOptionsFbihSummary(String state);

  /// No description provided for @payOn.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get payOn;

  /// No description provided for @payOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get payOff;

  /// No description provided for @payHrRates.
  ///
  /// In en, this message translates to:
  /// **'Municipal income-tax rates'**
  String get payHrRates;

  /// No description provided for @payHrLower.
  ///
  /// In en, this message translates to:
  /// **'Lower rate'**
  String get payHrLower;

  /// No description provided for @payHrHigher.
  ///
  /// In en, this message translates to:
  /// **'Higher rate'**
  String get payHrHigher;

  /// No description provided for @payHrRatesHint.
  ///
  /// In en, this message translates to:
  /// **'Set by your city or municipality: 15–23% and 25–33%. Without a decision, 20% and 30% apply.'**
  String get payHrRatesHint;

  /// No description provided for @payHrRateError.
  ///
  /// In en, this message translates to:
  /// **'Lower rate {lowRange}, higher rate {highRange}'**
  String payHrRateError(String lowRange, String highRange);

  /// No description provided for @payChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get payChildren;

  /// No description provided for @payDependents.
  ///
  /// In en, this message translates to:
  /// **'Other dependants'**
  String get payDependents;

  /// No description provided for @payRoDependents.
  ///
  /// In en, this message translates to:
  /// **'Dependants'**
  String get payRoDependents;

  /// No description provided for @payRoMinWage.
  ///
  /// In en, this message translates to:
  /// **'Minimum-wage relief'**
  String get payRoMinWage;

  /// No description provided for @payRoMinWageHint.
  ///
  /// In en, this message translates to:
  /// **'200 lei are exempt for employees paid the national minimum wage.'**
  String get payRoMinWageHint;

  /// No description provided for @payMeSurtax.
  ///
  /// In en, this message translates to:
  /// **'Surtax rate'**
  String get payMeSurtax;

  /// No description provided for @payMeSurtaxHint.
  ///
  /// In en, this message translates to:
  /// **'13% in most municipalities, 15% in Podgorica and Cetinje.'**
  String get payMeSurtaxHint;

  /// No description provided for @payFbihDisability.
  ///
  /// In en, this message translates to:
  /// **'Disability employment fund 0.5%'**
  String get payFbihDisability;

  /// No description provided for @payFbihDisabilityHint.
  ///
  /// In en, this message translates to:
  /// **'Paid by companies that don\'t employ the required share of people with disabilities.'**
  String get payFbihDisabilityHint;

  /// No description provided for @itemPension.
  ///
  /// In en, this message translates to:
  /// **'Pension and disability insurance'**
  String get itemPension;

  /// No description provided for @itemHealth.
  ///
  /// In en, this message translates to:
  /// **'Health insurance'**
  String get itemHealth;

  /// No description provided for @itemUnemployment.
  ///
  /// In en, this message translates to:
  /// **'Unemployment insurance'**
  String get itemUnemployment;

  /// No description provided for @itemChildProtection.
  ///
  /// In en, this message translates to:
  /// **'Child protection'**
  String get itemChildProtection;

  /// No description provided for @itemWorkInjury.
  ///
  /// In en, this message translates to:
  /// **'Work injury insurance'**
  String get itemWorkInjury;

  /// No description provided for @itemLaborFund.
  ///
  /// In en, this message translates to:
  /// **'Labour Fund'**
  String get itemLaborFund;

  /// No description provided for @itemChamber.
  ///
  /// In en, this message translates to:
  /// **'Chamber of Commerce'**
  String get itemChamber;

  /// No description provided for @itemPillar1.
  ///
  /// In en, this message translates to:
  /// **'Pension insurance, pillar I'**
  String get itemPillar1;

  /// No description provided for @itemPillar2.
  ///
  /// In en, this message translates to:
  /// **'Pension insurance, pillar II'**
  String get itemPillar2;

  /// No description provided for @itemLongTermCare.
  ///
  /// In en, this message translates to:
  /// **'Long-term care'**
  String get itemLongTermCare;

  /// No description provided for @itemParental.
  ///
  /// In en, this message translates to:
  /// **'Parental protection'**
  String get itemParental;

  /// No description provided for @itemCompulsoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Compulsory health contribution'**
  String get itemCompulsoryHealth;

  /// No description provided for @itemWaterFee.
  ///
  /// In en, this message translates to:
  /// **'General water fee'**
  String get itemWaterFee;

  /// No description provided for @itemDisasterFee.
  ///
  /// In en, this message translates to:
  /// **'Disaster protection fee'**
  String get itemDisasterFee;

  /// No description provided for @itemDisabilityFund.
  ///
  /// In en, this message translates to:
  /// **'Disability employment fund'**
  String get itemDisabilityFund;

  /// No description provided for @itemSickness.
  ///
  /// In en, this message translates to:
  /// **'Sickness and maternity'**
  String get itemSickness;

  /// No description provided for @itemSupplementaryPension.
  ///
  /// In en, this message translates to:
  /// **'Supplementary pension (UPF)'**
  String get itemSupplementaryPension;

  /// No description provided for @itemCas.
  ///
  /// In en, this message translates to:
  /// **'CAS (pension)'**
  String get itemCas;

  /// No description provided for @itemCass.
  ///
  /// In en, this message translates to:
  /// **'CASS (health)'**
  String get itemCass;

  /// No description provided for @itemCam.
  ///
  /// In en, this message translates to:
  /// **'CAM (work insurance)'**
  String get itemCam;

  /// No description provided for @saveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save calculation'**
  String get saveTitle;

  /// No description provided for @saveNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get saveNameLabel;

  /// No description provided for @saveNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Offer for new hire'**
  String get saveNameHint;

  /// No description provided for @saveLimit.
  ///
  /// In en, this message translates to:
  /// **'The free plan keeps {count} saved calculations.'**
  String saveLimit(int count);

  /// No description provided for @shareFooter.
  ///
  /// In en, this message translates to:
  /// **'Calculated with Bilans'**
  String get shareFooter;

  /// No description provided for @sourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sources and assumptions'**
  String get sourcesTitle;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team cost'**
  String get teamTitle;

  /// No description provided for @teamAdd.
  ///
  /// In en, this message translates to:
  /// **'Add employee'**
  String get teamAdd;

  /// No description provided for @teamEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit employee'**
  String get teamEdit;

  /// No description provided for @teamEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your payroll'**
  String get teamEmptyTitle;

  /// No description provided for @teamEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add your team — each person\'s gross, net and the employer\'s total cost, summed for the month and the year. Mix countries if you employ across borders.'**
  String get teamEmpty;

  /// No description provided for @teamMembers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} employee} other{{count} employees}}'**
  String teamMembers(int count);

  /// No description provided for @teamNote.
  ///
  /// In en, this message translates to:
  /// **'Each employee is calculated under the rules of their own tax system. Annual figures are 12 × monthly.'**
  String get teamNote;

  /// No description provided for @teamCurrenciesNote.
  ///
  /// In en, this message translates to:
  /// **'Totals are shown separately for each currency.'**
  String get teamCurrenciesNote;

  /// No description provided for @teamUnnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get teamUnnamed;

  /// No description provided for @teamTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get teamTotal;

  /// No description provided for @teamCostShort.
  ///
  /// In en, this message translates to:
  /// **'total cost'**
  String get teamCostShort;

  /// No description provided for @teamRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the team?'**
  String teamRemoveTitle(String name);

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get teamName;

  /// No description provided for @teamRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get teamRole;

  /// No description provided for @teamRoleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Developer'**
  String get teamRoleHint;

  /// No description provided for @teamAmountError.
  ///
  /// In en, this message translates to:
  /// **'Enter the pay amount.'**
  String get teamAmountError;

  /// No description provided for @cmpNeedsRates.
  ///
  /// In en, this message translates to:
  /// **'Comparing countries needs today\'s exchange rates. Connect to the internet once and they\'ll be saved for offline use.'**
  String get cmpNeedsRates;

  /// No description provided for @cmpRankedByNet.
  ///
  /// In en, this message translates to:
  /// **'Ranked by net pay'**
  String get cmpRankedByNet;

  /// No description provided for @cmpRankedByCost.
  ///
  /// In en, this message translates to:
  /// **'Ranked by employer cost'**
  String get cmpRankedByCost;

  /// No description provided for @cmpCostLine.
  ///
  /// In en, this message translates to:
  /// **'Employer cost {cost} · tax wedge {wedge}'**
  String cmpCostLine(String cost, String wedge);

  /// No description provided for @cmpGrossLine.
  ///
  /// In en, this message translates to:
  /// **'Gross {gross} · tax wedge {wedge}'**
  String cmpGrossLine(String gross, String wedge);

  /// No description provided for @cmpTaxesKey.
  ///
  /// In en, this message translates to:
  /// **'Taxes and contributions'**
  String get cmpTaxesKey;

  /// No description provided for @cmpNote.
  ///
  /// In en, this message translates to:
  /// **'Amounts converted at official rates from {date}. Each country uses its default settings (no children, standard local rates). The tax wedge is the share of the employer\'s total cost that goes to taxes and contributions.'**
  String cmpNote(String date);

  /// No description provided for @payWedgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax wedge'**
  String get payWedgeLabel;

  /// No description provided for @creditTitle.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get creditTitle;

  /// No description provided for @creditTabLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get creditTabLoan;

  /// No description provided for @creditTabDeposit.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get creditTabDeposit;

  /// No description provided for @creditTabCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get creditTabCompare;

  /// No description provided for @loanAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan amount'**
  String get loanAmount;

  /// No description provided for @loanRate.
  ///
  /// In en, this message translates to:
  /// **'Nominal interest rate'**
  String get loanRate;

  /// No description provided for @loanTerm.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get loanTerm;

  /// No description provided for @loanFee.
  ///
  /// In en, this message translates to:
  /// **'Processing fee'**
  String get loanFee;

  /// No description provided for @loanMonthlyFee.
  ///
  /// In en, this message translates to:
  /// **'Monthly fees'**
  String get loanMonthlyFee;

  /// No description provided for @loanMonthlyFeeHint.
  ///
  /// In en, this message translates to:
  /// **'Account, insurance…'**
  String get loanMonthlyFeeHint;

  /// No description provided for @loanRepayment.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get loanRepayment;

  /// No description provided for @loanAnnuity.
  ///
  /// In en, this message translates to:
  /// **'Equal installments'**
  String get loanAnnuity;

  /// No description provided for @loanLinear.
  ///
  /// In en, this message translates to:
  /// **'Equal principal'**
  String get loanLinear;

  /// No description provided for @loanMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get loanMore;

  /// No description provided for @loanLess.
  ///
  /// In en, this message translates to:
  /// **'Fewer options'**
  String get loanLess;

  /// No description provided for @loanCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get loanCurrency;

  /// No description provided for @loanInstallment.
  ///
  /// In en, this message translates to:
  /// **'Monthly installment'**
  String get loanInstallment;

  /// No description provided for @loanFirstInstallment.
  ///
  /// In en, this message translates to:
  /// **'First installment'**
  String get loanFirstInstallment;

  /// No description provided for @loanEir.
  ///
  /// In en, this message translates to:
  /// **'APR'**
  String get loanEir;

  /// No description provided for @loanTotalInterest.
  ///
  /// In en, this message translates to:
  /// **'Total interest'**
  String get loanTotalInterest;

  /// No description provided for @loanTotal.
  ///
  /// In en, this message translates to:
  /// **'Total to repay'**
  String get loanTotal;

  /// No description provided for @loanTotalIncludes.
  ///
  /// In en, this message translates to:
  /// **'Includes principal, interest and fees of {fees}.'**
  String loanTotalIncludes(String fees);

  /// No description provided for @loanEirNote.
  ///
  /// In en, this message translates to:
  /// **'APR is the effective annual rate including all fees, per the EU consumer-credit formula.'**
  String get loanEirNote;

  /// No description provided for @loanByYear.
  ///
  /// In en, this message translates to:
  /// **'By year'**
  String get loanByYear;

  /// No description provided for @loanPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Principal'**
  String get loanPrincipal;

  /// No description provided for @loanInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get loanInterest;

  /// No description provided for @loanYearShort.
  ///
  /// In en, this message translates to:
  /// **'Yr {n}'**
  String loanYearShort(int n);

  /// No description provided for @loanSchedule.
  ///
  /// In en, this message translates to:
  /// **'Repayment schedule'**
  String get loanSchedule;

  /// No description provided for @loanScheduleAll.
  ///
  /// In en, this message translates to:
  /// **'Full schedule · {count} installments'**
  String loanScheduleAll(int count);

  /// No description provided for @loanColNo.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get loanColNo;

  /// No description provided for @loanColInstallment.
  ///
  /// In en, this message translates to:
  /// **'Installment'**
  String get loanColInstallment;

  /// No description provided for @loanColInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get loanColInterest;

  /// No description provided for @loanColPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Principal'**
  String get loanColPrincipal;

  /// No description provided for @loanColBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get loanColBalance;

  /// No description provided for @loanPrepayTitle.
  ///
  /// In en, this message translates to:
  /// **'Early repayment'**
  String get loanPrepayTitle;

  /// No description provided for @loanPrepayTeaser.
  ///
  /// In en, this message translates to:
  /// **'Paying {amount} extra after installment {month} shortens the loan by {months} and saves {saved} in interest.'**
  String loanPrepayTeaser(
    String amount,
    int month,
    String months,
    String saved,
  );

  /// No description provided for @loanPrepayCta.
  ///
  /// In en, this message translates to:
  /// **'Calculate your scenario'**
  String get loanPrepayCta;

  /// No description provided for @loanErrorPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Enter a loan amount.'**
  String get loanErrorPrincipal;

  /// No description provided for @loanErrorRate.
  ///
  /// In en, this message translates to:
  /// **'Enter an interest rate between 0 and 100%.'**
  String get loanErrorRate;

  /// No description provided for @loanErrorTerm.
  ///
  /// In en, this message translates to:
  /// **'The term must be between 1 and 600 months.'**
  String get loanErrorTerm;

  /// No description provided for @loanErrorFee.
  ///
  /// In en, this message translates to:
  /// **'Fees must be smaller than the loan.'**
  String get loanErrorFee;

  /// No description provided for @prepayTitle.
  ///
  /// In en, this message translates to:
  /// **'Early repayment'**
  String get prepayTitle;

  /// No description provided for @prepayIntro.
  ///
  /// In en, this message translates to:
  /// **'Based on your current loan: {amount} at {rate} for {term}.'**
  String prepayIntro(String amount, String rate, String term);

  /// No description provided for @prepayNoLoan.
  ///
  /// In en, this message translates to:
  /// **'Set up a loan in the Loans tab first.'**
  String get prepayNoLoan;

  /// No description provided for @prepayAmount.
  ///
  /// In en, this message translates to:
  /// **'Extra payment'**
  String get prepayAmount;

  /// No description provided for @prepayAfter.
  ///
  /// In en, this message translates to:
  /// **'Paid with installment no.'**
  String get prepayAfter;

  /// No description provided for @prepayMode.
  ///
  /// In en, this message translates to:
  /// **'After the payment'**
  String get prepayMode;

  /// No description provided for @prepayShorten.
  ///
  /// In en, this message translates to:
  /// **'Shorter term'**
  String get prepayShorten;

  /// No description provided for @prepayLower.
  ///
  /// In en, this message translates to:
  /// **'Lower installment'**
  String get prepayLower;

  /// No description provided for @prepayFee.
  ///
  /// In en, this message translates to:
  /// **'Prepayment fee'**
  String get prepayFee;

  /// No description provided for @prepaySaved.
  ///
  /// In en, this message translates to:
  /// **'Interest saved'**
  String get prepaySaved;

  /// No description provided for @prepayNetSaving.
  ///
  /// In en, this message translates to:
  /// **'Net saving after fee'**
  String get prepayNetSaving;

  /// No description provided for @prepayNewTerm.
  ///
  /// In en, this message translates to:
  /// **'New term'**
  String get prepayNewTerm;

  /// No description provided for @prepayNewInstallment.
  ///
  /// In en, this message translates to:
  /// **'New installment'**
  String get prepayNewInstallment;

  /// No description provided for @prepayMonthsSaved.
  ///
  /// In en, this message translates to:
  /// **'{months} sooner'**
  String prepayMonthsSaved(String months);

  /// No description provided for @prepayPaidOff.
  ///
  /// In en, this message translates to:
  /// **'The extra payment clears the entire remaining balance.'**
  String get prepayPaidOff;

  /// No description provided for @prepayBefore.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get prepayBefore;

  /// No description provided for @prepayAfterLabel.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get prepayAfterLabel;

  /// No description provided for @depAmount.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get depAmount;

  /// No description provided for @depRate.
  ///
  /// In en, this message translates to:
  /// **'Interest rate'**
  String get depRate;

  /// No description provided for @depTerm.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get depTerm;

  /// No description provided for @depPayout.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get depPayout;

  /// No description provided for @depAtMaturity.
  ///
  /// In en, this message translates to:
  /// **'At maturity'**
  String get depAtMaturity;

  /// No description provided for @depMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly, added'**
  String get depMonthly;

  /// No description provided for @depAnnually.
  ///
  /// In en, this message translates to:
  /// **'Yearly, added'**
  String get depAnnually;

  /// No description provided for @depTax.
  ///
  /// In en, this message translates to:
  /// **'Tax on interest'**
  String get depTax;

  /// No description provided for @depTaxHintRs.
  ///
  /// In en, this message translates to:
  /// **'In Serbia, interest on dinar savings is tax-free; on foreign-currency savings it is taxed at 15%.'**
  String get depTaxHintRs;

  /// No description provided for @depTaxHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the withholding tax on interest that applies to you.'**
  String get depTaxHint;

  /// No description provided for @depContribution.
  ///
  /// In en, this message translates to:
  /// **'Monthly addition'**
  String get depContribution;

  /// No description provided for @depFinal.
  ///
  /// In en, this message translates to:
  /// **'At maturity'**
  String get depFinal;

  /// No description provided for @depGrossInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest before tax'**
  String get depGrossInterest;

  /// No description provided for @depTaxAmount.
  ///
  /// In en, this message translates to:
  /// **'Tax on interest'**
  String get depTaxAmount;

  /// No description provided for @depNetInterest.
  ///
  /// In en, this message translates to:
  /// **'Net interest'**
  String get depNetInterest;

  /// No description provided for @depPaidIn.
  ///
  /// In en, this message translates to:
  /// **'Paid in'**
  String get depPaidIn;

  /// No description provided for @depYield.
  ///
  /// In en, this message translates to:
  /// **'Net yield {percent} a year'**
  String depYield(String percent);

  /// No description provided for @depByYear.
  ///
  /// In en, this message translates to:
  /// **'By year'**
  String get depByYear;

  /// No description provided for @depColYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get depColYear;

  /// No description provided for @depColInterest.
  ///
  /// In en, this message translates to:
  /// **'Net interest'**
  String get depColInterest;

  /// No description provided for @depColBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get depColBalance;

  /// No description provided for @depErrorAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a deposit or a monthly addition.'**
  String get depErrorAmount;

  /// No description provided for @depErrorRate.
  ///
  /// In en, this message translates to:
  /// **'Enter an interest rate between 0 and 100%.'**
  String get depErrorRate;

  /// No description provided for @cmpLoanIntro.
  ///
  /// In en, this message translates to:
  /// **'Same amount for every offer. The cheapest offer is the one with the lowest total cost.'**
  String get cmpLoanIntro;

  /// No description provided for @cmpLoanOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer {n}'**
  String cmpLoanOffer(int n);

  /// No description provided for @cmpLoanAdd.
  ///
  /// In en, this message translates to:
  /// **'Add offer'**
  String get cmpLoanAdd;

  /// No description provided for @cmpLoanRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove offer'**
  String get cmpLoanRemove;

  /// No description provided for @cmpLoanBest.
  ///
  /// In en, this message translates to:
  /// **'Lowest total cost'**
  String get cmpLoanBest;

  /// No description provided for @cmpLoanSavesVs.
  ///
  /// In en, this message translates to:
  /// **'{amount} cheaper than the most expensive offer'**
  String cmpLoanSavesVs(String amount);

  /// No description provided for @cmpLoanResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get cmpLoanResults;

  /// No description provided for @depYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Net annual yield'**
  String get depYieldLabel;

  /// No description provided for @fxTitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get fxTitle;

  /// No description provided for @fxTabConverter.
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get fxTabConverter;

  /// No description provided for @fxTabList.
  ///
  /// In en, this message translates to:
  /// **'Rate list'**
  String get fxTabList;

  /// No description provided for @fxAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount in {currency}'**
  String fxAmount(String currency);

  /// No description provided for @fxSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap currencies'**
  String get fxSwap;

  /// No description provided for @fxRateLine.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = {rate} {to}'**
  String fxRateLine(String from, String rate, String to);

  /// No description provided for @fxSourceNbsMiddle.
  ///
  /// In en, this message translates to:
  /// **'NBS middle rate'**
  String get fxSourceNbsMiddle;

  /// No description provided for @fxSourceNbsBuy.
  ///
  /// In en, this message translates to:
  /// **'NBS buying rate'**
  String get fxSourceNbsBuy;

  /// No description provided for @fxSourceNbsSell.
  ///
  /// In en, this message translates to:
  /// **'NBS selling rate'**
  String get fxSourceNbsSell;

  /// No description provided for @fxSourceEcb.
  ///
  /// In en, this message translates to:
  /// **'ECB reference rate'**
  String get fxSourceEcb;

  /// No description provided for @fxSourceCross.
  ///
  /// In en, this message translates to:
  /// **'cross rate'**
  String get fxSourceCross;

  /// No description provided for @fxKindMiddle.
  ///
  /// In en, this message translates to:
  /// **'Middle'**
  String get fxKindMiddle;

  /// No description provided for @fxKindBuy.
  ///
  /// In en, this message translates to:
  /// **'Buying'**
  String get fxKindBuy;

  /// No description provided for @fxKindSell.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get fxKindSell;

  /// No description provided for @fxKindHint.
  ///
  /// In en, this message translates to:
  /// **'Buying and selling rates apply to dinar conversions.'**
  String get fxKindHint;

  /// No description provided for @fxUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String fxUpdated(String date);

  /// No description provided for @fxOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline · rates from {date}'**
  String fxOffline(String date);

  /// No description provided for @fxLoading.
  ///
  /// In en, this message translates to:
  /// **'Updating rates…'**
  String get fxLoading;

  /// No description provided for @fxNoRates.
  ///
  /// In en, this message translates to:
  /// **'No rates yet. Connect to the internet once to download today\'s official rates — after that the converter also works offline.'**
  String get fxNoRates;

  /// No description provided for @fxUnsupported.
  ///
  /// In en, this message translates to:
  /// **'There\'s no official rate for this pair.'**
  String get fxUnsupported;

  /// No description provided for @fxHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'{from}/{to} · {days} days'**
  String fxHistoryTitle(String from, String to, int days);

  /// No description provided for @fxHistoryDays.
  ///
  /// In en, this message translates to:
  /// **'{days} d'**
  String fxHistoryDays(int days);

  /// No description provided for @fxHistoryError.
  ///
  /// In en, this message translates to:
  /// **'History isn\'t available offline.'**
  String get fxHistoryError;

  /// No description provided for @fxHistoryPro.
  ///
  /// In en, this message translates to:
  /// **'Rate history for 30, 90 and 365 days is part of Pro.'**
  String get fxHistoryPro;

  /// No description provided for @fxHistoryMinMax.
  ///
  /// In en, this message translates to:
  /// **'min {min} · max {max}'**
  String fxHistoryMinMax(String min, String max);

  /// No description provided for @fxPerUnit.
  ///
  /// In en, this message translates to:
  /// **'For 1 unit of currency'**
  String get fxPerUnit;

  /// No description provided for @fxListNbs.
  ///
  /// In en, this message translates to:
  /// **'NBS exchange rate list'**
  String get fxListNbs;

  /// No description provided for @fxListEcb.
  ///
  /// In en, this message translates to:
  /// **'ECB reference rates, per 1 EUR'**
  String get fxListEcb;

  /// No description provided for @fxColBuy.
  ///
  /// In en, this message translates to:
  /// **'Buying'**
  String get fxColBuy;

  /// No description provided for @fxColMiddle.
  ///
  /// In en, this message translates to:
  /// **'Middle'**
  String get fxColMiddle;

  /// No description provided for @fxColSell.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get fxColSell;

  /// No description provided for @fxColRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get fxColRate;

  /// No description provided for @fxRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh rates'**
  String get fxRefresh;

  /// No description provided for @fxPickFrom.
  ///
  /// In en, this message translates to:
  /// **'Convert from'**
  String get fxPickFrom;

  /// No description provided for @fxPickTo.
  ///
  /// In en, this message translates to:
  /// **'Convert to'**
  String get fxPickTo;

  /// No description provided for @fxSourcesNote.
  ///
  /// In en, this message translates to:
  /// **'Official National Bank of Serbia rates via kurs.resenje.org; European Central Bank reference rates via Frankfurter. The mark is pegged at 1.95583 per euro.'**
  String get fxSourcesNote;

  /// No description provided for @bizTitle.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get bizTitle;

  /// No description provided for @bizProfile.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get bizProfile;

  /// No description provided for @bizInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get bizInvoices;

  /// No description provided for @bizNewInvoice.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get bizNewInvoice;

  /// No description provided for @bizInvoicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet. Create a professional invoice in under a minute.'**
  String get bizInvoicesEmpty;

  /// No description provided for @bizFreeLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} free invoice left} other{{count} free invoices left}}'**
  String bizFreeLeft(int count);

  /// No description provided for @bizTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get bizTools;

  /// No description provided for @bizShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all {count}'**
  String bizShowAll(int count);

  /// No description provided for @bizPausalCard.
  ///
  /// In en, this message translates to:
  /// **'Paušal · {year}'**
  String bizPausalCard(int year);

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusIssued.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get statusIssued;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @invNew.
  ///
  /// In en, this message translates to:
  /// **'New invoice'**
  String get invNew;

  /// No description provided for @invEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit invoice'**
  String get invEdit;

  /// No description provided for @invNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice number'**
  String get invNumber;

  /// No description provided for @invIssueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get invIssueDate;

  /// No description provided for @invServiceDate.
  ///
  /// In en, this message translates to:
  /// **'Date of supply'**
  String get invServiceDate;

  /// No description provided for @invDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get invDueDate;

  /// No description provided for @invPlace.
  ///
  /// In en, this message translates to:
  /// **'Place of issue'**
  String get invPlace;

  /// No description provided for @invClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get invClient;

  /// No description provided for @invClientName.
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get invClientName;

  /// No description provided for @invClientAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get invClientAddress;

  /// No description provided for @invClientCity.
  ///
  /// In en, this message translates to:
  /// **'Postcode and city'**
  String get invClientCity;

  /// No description provided for @invClientCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get invClientCountry;

  /// No description provided for @invClientTaxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID (PIB / VAT)'**
  String get invClientTaxId;

  /// No description provided for @invClientRegNo.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get invClientRegNo;

  /// No description provided for @invClientEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get invClientEmail;

  /// No description provided for @invRecentClients.
  ///
  /// In en, this message translates to:
  /// **'Recent clients'**
  String get invRecentClients;

  /// No description provided for @invCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get invCurrency;

  /// No description provided for @invItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get invItems;

  /// No description provided for @invItemDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get invItemDescription;

  /// No description provided for @invItemQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get invItemQty;

  /// No description provided for @invItemUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get invItemUnit;

  /// No description provided for @invItemUnitHint.
  ///
  /// In en, this message translates to:
  /// **'pcs, h, day…'**
  String get invItemUnitHint;

  /// No description provided for @invItemPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get invItemPrice;

  /// No description provided for @invItemVat.
  ///
  /// In en, this message translates to:
  /// **'VAT %'**
  String get invItemVat;

  /// No description provided for @invAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get invAddItem;

  /// No description provided for @invRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get invRemoveItem;

  /// No description provided for @invNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get invNote;

  /// No description provided for @invReference.
  ///
  /// In en, this message translates to:
  /// **'Payment reference'**
  String get invReference;

  /// No description provided for @invReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'Model and number, e.g. 97 1234'**
  String get invReferenceHint;

  /// No description provided for @invSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get invSubtotal;

  /// No description provided for @invVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get invVat;

  /// No description provided for @invTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get invTotal;

  /// No description provided for @invTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Total due'**
  String get invTotalDue;

  /// No description provided for @invTotalRsd.
  ///
  /// In en, this message translates to:
  /// **'Counter-value in RSD'**
  String get invTotalRsd;

  /// No description provided for @invRateLine.
  ///
  /// In en, this message translates to:
  /// **'NBS middle rate {rate} on {date}'**
  String invRateLine(String rate, String date);

  /// No description provided for @invRateFetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching the NBS rate…'**
  String get invRateFetching;

  /// No description provided for @invRateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The NBS rate for this date isn\'t available yet.'**
  String get invRateUnavailable;

  /// No description provided for @invRateRetry.
  ///
  /// In en, this message translates to:
  /// **'Fetch rate'**
  String get invRateRetry;

  /// No description provided for @invSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get invSaveDraft;

  /// No description provided for @invIssue.
  ///
  /// In en, this message translates to:
  /// **'Issue invoice'**
  String get invIssue;

  /// No description provided for @invSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get invSave;

  /// No description provided for @invMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get invMarkPaid;

  /// No description provided for @invMarkUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as unpaid'**
  String get invMarkUnpaid;

  /// No description provided for @invCancelInvoice.
  ///
  /// In en, this message translates to:
  /// **'Cancel invoice'**
  String get invCancelInvoice;

  /// No description provided for @invDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete invoice'**
  String get invDelete;

  /// No description provided for @invDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete invoice {number}? This can\'t be undone.'**
  String invDeleteConfirm(String number);

  /// No description provided for @invDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get invDuplicate;

  /// No description provided for @invProfileMissing.
  ///
  /// In en, this message translates to:
  /// **'Add your business details first — they appear on every invoice.'**
  String get invProfileMissing;

  /// No description provided for @invProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Set up business details'**
  String get invProfileSetup;

  /// No description provided for @invNotInVat.
  ///
  /// In en, this message translates to:
  /// **'The issuer is not registered for VAT.'**
  String get invNotInVat;

  /// No description provided for @invValidWithoutStamp.
  ///
  /// In en, this message translates to:
  /// **'This invoice is valid without a stamp or signature.'**
  String get invValidWithoutStamp;

  /// No description provided for @invQrCaption.
  ///
  /// In en, this message translates to:
  /// **'Scan to pay (NBS IPS)'**
  String get invQrCaption;

  /// No description provided for @invQrHint.
  ///
  /// In en, this message translates to:
  /// **'Your client scans the QR code in their bank app — amount, account and reference fill in automatically.'**
  String get invQrHint;

  /// No description provided for @invQrMissing.
  ///
  /// In en, this message translates to:
  /// **'No payment QR: {reason}'**
  String invQrMissing(String reason);

  /// No description provided for @invQrReasonAccount.
  ///
  /// In en, this message translates to:
  /// **'add a valid Serbian bank account in Business details'**
  String get invQrReasonAccount;

  /// No description provided for @invQrReasonOther.
  ///
  /// In en, this message translates to:
  /// **'check the business name and payment reference'**
  String get invQrReasonOther;

  /// No description provided for @invDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invDocTitle;

  /// No description provided for @invSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get invSeller;

  /// No description provided for @invBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get invBuyer;

  /// No description provided for @invPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on {date}'**
  String invPaidOn(String date);

  /// No description provided for @invDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String invDueOn(String date);

  /// No description provided for @invErrorClient.
  ///
  /// In en, this message translates to:
  /// **'Enter the client\'s name.'**
  String get invErrorClient;

  /// No description provided for @invErrorItems.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item with a description and price.'**
  String get invErrorItems;

  /// No description provided for @invErrorNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter an invoice number.'**
  String get invErrorNumber;

  /// No description provided for @invErrorDue.
  ///
  /// In en, this message translates to:
  /// **'The due date can\'t be before the issue date.'**
  String get invErrorDue;

  /// No description provided for @invErrorNumberTaken.
  ///
  /// In en, this message translates to:
  /// **'Invoice {number} already exists.'**
  String invErrorNumberTaken(String number);

  /// No description provided for @invLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve created {count} free invoices'**
  String invLimitTitle(int count);

  /// No description provided for @invShare.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get invShare;

  /// No description provided for @invPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get invPreview;

  /// No description provided for @invAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get invAccount;

  /// No description provided for @invPib.
  ///
  /// In en, this message translates to:
  /// **'PIB'**
  String get invPib;

  /// No description provided for @invMb.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get invMb;

  /// No description provided for @invReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get invReferenceLabel;

  /// No description provided for @invPlaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get invPlaceLabel;

  /// No description provided for @invColItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get invColItem;

  /// No description provided for @invColQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get invColQty;

  /// No description provided for @invColPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get invColPrice;

  /// No description provided for @invColAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get invColAmount;

  /// No description provided for @profTitle.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get profTitle;

  /// No description provided for @profIntro.
  ///
  /// In en, this message translates to:
  /// **'Printed on your invoices and, if you choose, on PDF reports.'**
  String get profIntro;

  /// No description provided for @profName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get profName;

  /// No description provided for @profAddress.
  ///
  /// In en, this message translates to:
  /// **'Street and number'**
  String get profAddress;

  /// No description provided for @profCity.
  ///
  /// In en, this message translates to:
  /// **'Postcode and city'**
  String get profCity;

  /// No description provided for @profCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profCountry;

  /// No description provided for @profTaxId.
  ///
  /// In en, this message translates to:
  /// **'Tax ID (PIB)'**
  String get profTaxId;

  /// No description provided for @profRegNo.
  ///
  /// In en, this message translates to:
  /// **'Registration number (MB)'**
  String get profRegNo;

  /// No description provided for @profAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get profAccount;

  /// No description provided for @profAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Serbian account (160-0000000000000-00) or IBAN'**
  String get profAccountHint;

  /// No description provided for @profBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get profBank;

  /// No description provided for @profEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profEmail;

  /// No description provided for @profPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profPhone;

  /// No description provided for @profVat.
  ///
  /// In en, this message translates to:
  /// **'Registered for VAT'**
  String get profVat;

  /// No description provided for @profVatHint.
  ///
  /// In en, this message translates to:
  /// **'Adds VAT lines to invoices. When off, invoices state that you\'re not in the VAT system.'**
  String get profVatHint;

  /// No description provided for @profPaymentCode.
  ///
  /// In en, this message translates to:
  /// **'Payment code for the QR (šifra plaćanja)'**
  String get profPaymentCode;

  /// No description provided for @profPaymentCodeHint.
  ///
  /// In en, this message translates to:
  /// **'221 for payments for goods and services'**
  String get profPaymentCodeHint;

  /// No description provided for @profDueDays.
  ///
  /// In en, this message translates to:
  /// **'Default payment term'**
  String get profDueDays;

  /// No description provided for @profDueDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get profDueDaysSuffix;

  /// No description provided for @profCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default invoice currency'**
  String get profCurrency;

  /// No description provided for @profNote.
  ///
  /// In en, this message translates to:
  /// **'Default invoice note'**
  String get profNote;

  /// No description provided for @profShowOnReports.
  ///
  /// In en, this message translates to:
  /// **'Show business details on PDF reports'**
  String get profShowOnReports;

  /// No description provided for @profInvalidPib.
  ///
  /// In en, this message translates to:
  /// **'The PIB check digit doesn\'t match — please check it.'**
  String get profInvalidPib;

  /// No description provided for @profInvalidMb.
  ///
  /// In en, this message translates to:
  /// **'The registration number check digit doesn\'t match.'**
  String get profInvalidMb;

  /// No description provided for @profInvalidAccount.
  ///
  /// In en, this message translates to:
  /// **'The account number check digits don\'t match.'**
  String get profInvalidAccount;

  /// No description provided for @profSaved.
  ///
  /// In en, this message translates to:
  /// **'Business details saved'**
  String get profSaved;

  /// No description provided for @pausalTitle.
  ///
  /// In en, this message translates to:
  /// **'Paušal limits'**
  String get pausalTitle;

  /// No description provided for @pausalIntro.
  ///
  /// In en, this message translates to:
  /// **'Flat-rate (paušal) entrepreneurs lose the regime above 6,000,000 RSD of revenue in a calendar year and must register for VAT above 8,000,000 RSD in any 12 months.'**
  String get pausalIntro;

  /// No description provided for @pausalAnnual.
  ///
  /// In en, this message translates to:
  /// **'Paušal limit, calendar year'**
  String get pausalAnnual;

  /// No description provided for @pausalVat.
  ///
  /// In en, this message translates to:
  /// **'VAT limit, last 12 months'**
  String get pausalVat;

  /// No description provided for @pausalOf.
  ///
  /// In en, this message translates to:
  /// **'of {amount}'**
  String pausalOf(String amount);

  /// No description provided for @pausalLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String pausalLeft(String amount);

  /// No description provided for @pausalProjection.
  ///
  /// In en, this message translates to:
  /// **'At this pace you\'ll invoice about {amount} by 31 December.'**
  String pausalProjection(String amount);

  /// No description provided for @pausalProjectionOver.
  ///
  /// In en, this message translates to:
  /// **'At this pace you\'ll pass the paušal limit before year-end (about {amount}).'**
  String pausalProjectionOver(String amount);

  /// No description provided for @pausalWarn.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used more than 80% of this limit.'**
  String get pausalWarn;

  /// No description provided for @pausalOver.
  ///
  /// In en, this message translates to:
  /// **'Limit exceeded — talk to your accountant.'**
  String get pausalOver;

  /// No description provided for @pausalMissingRate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} foreign-currency invoice has no NBS rate and isn\'t counted.} other{{count} foreign-currency invoices have no NBS rate and aren\'t counted.}}'**
  String pausalMissingRate(int count);

  /// No description provided for @pausalSourceInvoices.
  ///
  /// In en, this message translates to:
  /// **'Counted from issued and paid invoices (by date of supply) plus revenue you add below.'**
  String get pausalSourceInvoices;

  /// No description provided for @pausalManual.
  ///
  /// In en, this message translates to:
  /// **'Revenue outside the app'**
  String get pausalManual;

  /// No description provided for @pausalManualEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add invoices you issued elsewhere this year to keep the totals complete.'**
  String get pausalManualEmpty;

  /// No description provided for @pausalManualAdd.
  ///
  /// In en, this message translates to:
  /// **'Add revenue'**
  String get pausalManualAdd;

  /// No description provided for @pausalManualDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pausalManualDate;

  /// No description provided for @pausalManualAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount in RSD'**
  String get pausalManualAmount;

  /// No description provided for @pausalManualNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get pausalManualNote;

  /// No description provided for @vatTitle.
  ///
  /// In en, this message translates to:
  /// **'VAT calculator'**
  String get vatTitle;

  /// No description provided for @vatAdd.
  ///
  /// In en, this message translates to:
  /// **'Add VAT'**
  String get vatAdd;

  /// No description provided for @vatExtract.
  ///
  /// In en, this message translates to:
  /// **'Extract VAT'**
  String get vatExtract;

  /// No description provided for @vatAmountNet.
  ///
  /// In en, this message translates to:
  /// **'Amount without VAT'**
  String get vatAmountNet;

  /// No description provided for @vatAmountGross.
  ///
  /// In en, this message translates to:
  /// **'Amount with VAT'**
  String get vatAmountGross;

  /// No description provided for @vatRate.
  ///
  /// In en, this message translates to:
  /// **'VAT rate'**
  String get vatRate;

  /// No description provided for @vatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vatOther;

  /// No description provided for @vatNet.
  ///
  /// In en, this message translates to:
  /// **'Without VAT'**
  String get vatNet;

  /// No description provided for @vatVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vatVat;

  /// No description provided for @vatGross.
  ///
  /// In en, this message translates to:
  /// **'With VAT'**
  String get vatGross;

  /// No description provided for @mrgTitle.
  ///
  /// In en, this message translates to:
  /// **'Margin and markup'**
  String get mrgTitle;

  /// No description provided for @mrgFromPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost & price'**
  String get mrgFromPrice;

  /// No description provided for @mrgFromMarkup.
  ///
  /// In en, this message translates to:
  /// **'Markup'**
  String get mrgFromMarkup;

  /// No description provided for @mrgFromMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get mrgFromMargin;

  /// No description provided for @mrgCost.
  ///
  /// In en, this message translates to:
  /// **'Cost price'**
  String get mrgCost;

  /// No description provided for @mrgPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price (excl. VAT)'**
  String get mrgPrice;

  /// No description provided for @mrgMarkup.
  ///
  /// In en, this message translates to:
  /// **'Markup'**
  String get mrgMarkup;

  /// No description provided for @mrgMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get mrgMargin;

  /// No description provided for @mrgDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get mrgDiscount;

  /// No description provided for @mrgVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get mrgVat;

  /// No description provided for @mrgProfit.
  ///
  /// In en, this message translates to:
  /// **'Gross profit'**
  String get mrgProfit;

  /// No description provided for @mrgPriceAfterDiscount.
  ///
  /// In en, this message translates to:
  /// **'Price after discount'**
  String get mrgPriceAfterDiscount;

  /// No description provided for @mrgPriceWithVat.
  ///
  /// In en, this message translates to:
  /// **'Price with VAT'**
  String get mrgPriceWithVat;

  /// No description provided for @mrgMarginHint.
  ///
  /// In en, this message translates to:
  /// **'Margin is profit as a share of the price; markup is profit as a share of the cost.'**
  String get mrgMarginHint;

  /// No description provided for @mrgImpossible.
  ///
  /// In en, this message translates to:
  /// **'A margin of 100% or more isn\'t possible.'**
  String get mrgImpossible;

  /// No description provided for @beTitle.
  ///
  /// In en, this message translates to:
  /// **'Break-even'**
  String get beTitle;

  /// No description provided for @beFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed costs per month'**
  String get beFixed;

  /// No description provided for @bePrice.
  ///
  /// In en, this message translates to:
  /// **'Price per unit'**
  String get bePrice;

  /// No description provided for @beVariable.
  ///
  /// In en, this message translates to:
  /// **'Variable cost per unit'**
  String get beVariable;

  /// No description provided for @beTarget.
  ///
  /// In en, this message translates to:
  /// **'Target profit per month'**
  String get beTarget;

  /// No description provided for @beUnits.
  ///
  /// In en, this message translates to:
  /// **'Units to sell per month'**
  String get beUnits;

  /// No description provided for @beUnitsValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{formatted} unit} other{{formatted} units}}'**
  String beUnitsValue(int count, String formatted);

  /// No description provided for @beRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue needed'**
  String get beRevenue;

  /// No description provided for @beContribution.
  ///
  /// In en, this message translates to:
  /// **'Contribution margin'**
  String get beContribution;

  /// No description provided for @beImpossible.
  ///
  /// In en, this message translates to:
  /// **'The price must be higher than the variable cost per unit.'**
  String get beImpossible;

  /// No description provided for @invsTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment analysis'**
  String get invsTitle;

  /// No description provided for @invsInitial.
  ///
  /// In en, this message translates to:
  /// **'Initial investment'**
  String get invsInitial;

  /// No description provided for @invsRate.
  ///
  /// In en, this message translates to:
  /// **'Discount rate'**
  String get invsRate;

  /// No description provided for @invsFlows.
  ///
  /// In en, this message translates to:
  /// **'Net cash flow by year'**
  String get invsFlows;

  /// No description provided for @invsYear.
  ///
  /// In en, this message translates to:
  /// **'Year {n}'**
  String invsYear(int n);

  /// No description provided for @invsAddYear.
  ///
  /// In en, this message translates to:
  /// **'Add year'**
  String get invsAddYear;

  /// No description provided for @invsRemoveYear.
  ///
  /// In en, this message translates to:
  /// **'Remove last year'**
  String get invsRemoveYear;

  /// No description provided for @invsNpv.
  ///
  /// In en, this message translates to:
  /// **'Net present value (NPV)'**
  String get invsNpv;

  /// No description provided for @invsIrr.
  ///
  /// In en, this message translates to:
  /// **'Internal rate of return (IRR)'**
  String get invsIrr;

  /// No description provided for @invsPayback.
  ///
  /// In en, this message translates to:
  /// **'Payback period'**
  String get invsPayback;

  /// No description provided for @invsDiscountedPayback.
  ///
  /// In en, this message translates to:
  /// **'Discounted payback'**
  String get invsDiscountedPayback;

  /// No description provided for @invsPi.
  ///
  /// In en, this message translates to:
  /// **'Profitability index'**
  String get invsPi;

  /// No description provided for @invsYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String invsYears(String years);

  /// No description provided for @invsNever.
  ///
  /// In en, this message translates to:
  /// **'Not within these years'**
  String get invsNever;

  /// No description provided for @invsNoIrr.
  ///
  /// In en, this message translates to:
  /// **'No IRR for these cash flows'**
  String get invsNoIrr;

  /// No description provided for @invsGood.
  ///
  /// In en, this message translates to:
  /// **'Creates value at a {rate} discount rate.'**
  String invsGood(String rate);

  /// No description provided for @invsBad.
  ///
  /// In en, this message translates to:
  /// **'Destroys value at a {rate} discount rate.'**
  String invsBad(String rate);

  /// No description provided for @profSectionBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get profSectionBusiness;

  /// No description provided for @profSectionPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get profSectionPayment;

  /// No description provided for @profSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get profSectionContact;

  /// No description provided for @profSectionInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoice defaults'**
  String get profSectionInvoices;

  /// No description provided for @profTaxIdGeneric.
  ///
  /// In en, this message translates to:
  /// **'Tax ID'**
  String get profTaxIdGeneric;

  /// No description provided for @profRegNoGeneric.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get profRegNoGeneric;

  /// No description provided for @profNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the business name.'**
  String get profNameRequired;

  /// No description provided for @profPibLength.
  ///
  /// In en, this message translates to:
  /// **'The PIB has 9 digits.'**
  String get profPibLength;

  /// No description provided for @profMbLength.
  ///
  /// In en, this message translates to:
  /// **'The registration number has 8 digits.'**
  String get profMbLength;

  /// No description provided for @profInvalidAccountShape.
  ///
  /// In en, this message translates to:
  /// **'Enter a Serbian account (160-0000000000000-00) or an IBAN.'**
  String get profInvalidAccountShape;

  /// No description provided for @profInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Check the email address.'**
  String get profInvalidEmail;

  /// No description provided for @profInvalidPaymentCode.
  ///
  /// In en, this message translates to:
  /// **'Use a three-digit payment code, e.g. 221.'**
  String get profInvalidPaymentCode;

  /// No description provided for @profPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Stored only on this phone. It is included in backups you export.'**
  String get profPrivacy;

  /// No description provided for @profIban.
  ///
  /// In en, this message translates to:
  /// **'IBAN for payments from abroad'**
  String get profIban;

  /// No description provided for @profIbanHint.
  ///
  /// In en, this message translates to:
  /// **'Printed on foreign-currency invoices. Leave empty to use your account above in IBAN form.'**
  String get profIbanHint;

  /// No description provided for @profSwift.
  ///
  /// In en, this message translates to:
  /// **'SWIFT / BIC'**
  String get profSwift;

  /// No description provided for @profInvalidIban.
  ///
  /// In en, this message translates to:
  /// **'Check the IBAN — the check digits don\'t match.'**
  String get profInvalidIban;

  /// No description provided for @profInvalidSwift.
  ///
  /// In en, this message translates to:
  /// **'A SWIFT/BIC code has 8 or 11 characters.'**
  String get profInvalidSwift;

  /// No description provided for @invIban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get invIban;

  /// No description provided for @invSwift.
  ///
  /// In en, this message translates to:
  /// **'SWIFT/BIC'**
  String get invSwift;

  /// No description provided for @invBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get invBank;

  /// No description provided for @invSefNote.
  ///
  /// In en, this message translates to:
  /// **'Invoices to the Serbian public sector — and, for VAT payers, to Serbian companies — must also go through SEF (e-Faktura). Bilans invoices suit clients abroad, individuals and your own records.'**
  String get invSefNote;

  /// No description provided for @invRateOffline.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the NBS. Check your connection — you can also save now and fetch the rate later.'**
  String get invRateOffline;

  /// No description provided for @invMarkedPaid.
  ///
  /// In en, this message translates to:
  /// **'Marked as paid'**
  String get invMarkedPaid;

  /// No description provided for @invMarkedUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Marked as unpaid'**
  String get invMarkedUnpaid;

  /// No description provided for @invIssued.
  ///
  /// In en, this message translates to:
  /// **'Invoice issued'**
  String get invIssued;

  /// No description provided for @invCancelled.
  ///
  /// In en, this message translates to:
  /// **'Invoice cancelled'**
  String get invCancelled;

  /// No description provided for @invCompleteFirst.
  ///
  /// In en, this message translates to:
  /// **'Add the client and at least one item before issuing.'**
  String get invCompleteFirst;

  /// No description provided for @invCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel invoice {number}?'**
  String invCancelConfirm(String number);

  /// No description provided for @invCancelBody.
  ///
  /// In en, this message translates to:
  /// **'It stays in your list, marked as cancelled, and no longer counts as revenue.'**
  String get invCancelBody;

  /// No description provided for @invRateMissingNote.
  ///
  /// In en, this message translates to:
  /// **'No NBS rate yet — this invoice isn\'t counted toward your paušal limits until it has one.'**
  String get invRateMissingNote;

  /// No description provided for @pausalMonthlyRoom.
  ///
  /// In en, this message translates to:
  /// **'To stay under the limit, keep to about {amount} a month until the end of the year.'**
  String pausalMonthlyRoom(String amount);

  /// No description provided for @pausalByMonth.
  ///
  /// In en, this message translates to:
  /// **'Revenue by month, {year}'**
  String pausalByMonth(int year);

  /// No description provided for @pausalFromInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get pausalFromInvoices;

  /// No description provided for @pausalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Revenue is counted by the date of supply. Foreign-currency invoices use the NBS middle rate on the issue date. Check the final figures with your accountant.'**
  String get pausalDisclaimer;

  /// No description provided for @pausalRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this revenue entry?'**
  String get pausalRemoveTitle;

  /// No description provided for @pausalManualAmountError.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount.'**
  String get pausalManualAmountError;

  /// No description provided for @invsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get invsFilterAll;

  /// No description provided for @invsFilterDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get invsFilterDrafts;

  /// No description provided for @invsOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get invsOutstanding;

  /// No description provided for @invsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by client or number'**
  String get invsSearchHint;

  /// No description provided for @invsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No invoices match.'**
  String get invsNoMatch;

  /// No description provided for @vatEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount to split it into the net amount and VAT.'**
  String get vatEmpty;

  /// No description provided for @vatRatesNote.
  ///
  /// In en, this message translates to:
  /// **'Rates shown are the standard and reduced VAT rates in {country}.'**
  String vatRatesNote(String country);

  /// No description provided for @mrgEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter the cost and a price, markup or margin.'**
  String get mrgEmpty;

  /// No description provided for @mrgLoss.
  ///
  /// In en, this message translates to:
  /// **'At this price you sell below cost.'**
  String get mrgLoss;

  /// No description provided for @beFixedHint.
  ///
  /// In en, this message translates to:
  /// **'Rent, salaries, subscriptions…'**
  String get beFixedHint;

  /// No description provided for @beVariableHint.
  ///
  /// In en, this message translates to:
  /// **'Materials, commissions, delivery…'**
  String get beVariableHint;

  /// No description provided for @beEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter your fixed costs, price and variable cost per unit.'**
  String get beEmpty;

  /// No description provided for @beContributionUnit.
  ///
  /// In en, this message translates to:
  /// **'Contribution per unit'**
  String get beContributionUnit;

  /// No description provided for @beExplain.
  ///
  /// In en, this message translates to:
  /// **'Each unit sold contributes its price minus its variable cost toward fixed costs and profit. Amounts are without VAT.'**
  String get beExplain;

  /// No description provided for @invsFlowsHint.
  ///
  /// In en, this message translates to:
  /// **'Net cash flow at the end of each year. Type a minus sign for a year with more going out than coming in.'**
  String get invsFlowsHint;

  /// No description provided for @invsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter the investment, a discount rate and at least one year\'s cash flow.'**
  String get invsEmpty;

  /// No description provided for @invsCumulative.
  ///
  /// In en, this message translates to:
  /// **'Cumulative cash flow'**
  String get invsCumulative;

  /// No description provided for @invCreatedWith.
  ///
  /// In en, this message translates to:
  /// **'Created with Bilans'**
  String get invCreatedWith;

  /// No description provided for @proHeadline.
  ///
  /// In en, this message translates to:
  /// **'Bilans Pro'**
  String get proHeadline;

  /// No description provided for @proSubhead.
  ///
  /// In en, this message translates to:
  /// **'Every calculator, every country, unlimited invoices and PDF reports. No ads, no account.'**
  String get proSubhead;

  /// No description provided for @proFeatAllCountries.
  ///
  /// In en, this message translates to:
  /// **'Payroll for all 9 tax systems'**
  String get proFeatAllCountries;

  /// No description provided for @proFeatUnlimitedInvoices.
  ///
  /// In en, this message translates to:
  /// **'Unlimited invoices'**
  String get proFeatUnlimitedInvoices;

  /// No description provided for @proFeatPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF reports'**
  String get proFeatPdf;

  /// No description provided for @proFeatUnlimitedSaves.
  ///
  /// In en, this message translates to:
  /// **'Unlimited saved calculations'**
  String get proFeatUnlimitedSaves;

  /// No description provided for @proBenefitCountries.
  ///
  /// In en, this message translates to:
  /// **'Payroll for all 9 tax systems, and the same pay compared across countries'**
  String get proBenefitCountries;

  /// No description provided for @proBenefitTeam.
  ///
  /// In en, this message translates to:
  /// **'Team cost: your whole payroll by month and year'**
  String get proBenefitTeam;

  /// No description provided for @proBenefitInvoices.
  ///
  /// In en, this message translates to:
  /// **'Unlimited invoices as professional PDFs'**
  String get proBenefitInvoices;

  /// No description provided for @proBenefitInvoicesRs.
  ///
  /// In en, this message translates to:
  /// **'Unlimited invoices with the NBS IPS payment QR code'**
  String get proBenefitInvoicesRs;

  /// No description provided for @proBenefitPausal.
  ///
  /// In en, this message translates to:
  /// **'Paušal limit tracker for the 6 and 8 million dinar limits'**
  String get proBenefitPausal;

  /// No description provided for @proBenefitLoans.
  ///
  /// In en, this message translates to:
  /// **'Compare loan offers and plan early repayments'**
  String get proBenefitLoans;

  /// No description provided for @proBenefitHistory.
  ///
  /// In en, this message translates to:
  /// **'Exchange-rate history for 30, 90 and 365 days'**
  String get proBenefitHistory;

  /// No description provided for @proBenefitInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment analysis: NPV, IRR and payback'**
  String get proBenefitInvestment;

  /// No description provided for @proBenefitPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF reports for pay, loans, savings and teams'**
  String get proBenefitPdf;

  /// No description provided for @proYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get proYearly;

  /// No description provided for @proMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get proMonthly;

  /// No description provided for @proLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get proLifetime;

  /// No description provided for @proPerYear.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get proPerYear;

  /// No description provided for @proPerMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get proPerMonth;

  /// No description provided for @proOnce.
  ///
  /// In en, this message translates to:
  /// **'one-time'**
  String get proOnce;

  /// No description provided for @proSave.
  ///
  /// In en, this message translates to:
  /// **'SAVE {percent}%'**
  String proSave(int percent);

  /// No description provided for @proTrialNote.
  ///
  /// In en, this message translates to:
  /// **'{days} days free, then billed yearly'**
  String proTrialNote(int days);

  /// No description provided for @proLifetimeNote.
  ///
  /// In en, this message translates to:
  /// **'Pay once, keep Pro for good'**
  String get proLifetimeNote;

  /// No description provided for @proStartTrial.
  ///
  /// In en, this message translates to:
  /// **'Start {days}-day free trial'**
  String proStartTrial(int days);

  /// No description provided for @proContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get proContinue;

  /// No description provided for @proRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get proRestore;

  /// No description provided for @proRestored.
  ///
  /// In en, this message translates to:
  /// **'Bilans Pro is active on this device.'**
  String get proRestored;

  /// No description provided for @proNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No Bilans Pro purchase was found for this Google account.'**
  String get proNothingToRestore;

  /// No description provided for @proPending.
  ///
  /// In en, this message translates to:
  /// **'Your payment is pending. Pro unlocks automatically as soon as Google Play confirms it.'**
  String get proPending;

  /// No description provided for @proError.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through. You haven\'t been charged — please try again.'**
  String get proError;

  /// No description provided for @proUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Purchases aren\'t available right now. Check that Google Play is installed and you\'re signed in, then try again.'**
  String get proUnavailable;

  /// No description provided for @proLegal.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions renew automatically at the price shown until you cancel. Cancel anytime in Google Play → Payments & subscriptions, at least 24 hours before the renewal date. A free trial turns into a paid yearly subscription unless you cancel before it ends.'**
  String get proLegal;

  /// No description provided for @proLegalLifetime.
  ///
  /// In en, this message translates to:
  /// **'A one-time purchase: no subscription and no renewals. Pro stays active on every device signed in to the same Google account.'**
  String get proLegalLifetime;

  /// No description provided for @proDevSimulate.
  ///
  /// In en, this message translates to:
  /// **'Simulate Pro (developer build)'**
  String get proDevSimulate;

  /// No description provided for @proWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Bilans Pro'**
  String get proWelcome;

  /// No description provided for @proWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Everything is unlocked. Thank you for supporting an independent app.'**
  String get proWelcomeBody;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsYourData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get settingsYourData;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get settingsExport;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get settingsImport;

  /// No description provided for @settingsBackupSubject.
  ///
  /// In en, this message translates to:
  /// **'Bilans backup'**
  String get settingsBackupSubject;

  /// No description provided for @settingsExported.
  ///
  /// In en, this message translates to:
  /// **'Backup ready'**
  String get settingsExported;

  /// No description provided for @settingsImportInvalid.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a Bilans backup.'**
  String get settingsImportInvalid;

  /// No description provided for @settingsImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get settingsImportTitle;

  /// No description provided for @settingsImportBody.
  ///
  /// In en, this message translates to:
  /// **'Everything in the app is replaced with the backup\'s contents — invoices, business details, team and saved calculations.'**
  String get settingsImportBody;

  /// No description provided for @settingsImportAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get settingsImportAction;

  /// No description provided for @settingsImported.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get settingsImported;

  /// No description provided for @settingsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsDeleteAll;

  /// No description provided for @settingsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get settingsDeleteTitle;

  /// No description provided for @settingsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Invoices, business details, your team, saved calculations and settings are removed from this phone. Export a backup first if you might need them. Your Pro purchase is not affected.'**
  String get settingsDeleteBody;

  /// No description provided for @settingsDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get settingsDeleteAction;

  /// No description provided for @settingsDataNote.
  ///
  /// In en, this message translates to:
  /// **'Bilans has no account and no servers: your data lives only on this phone. Export a backup to move it to a new phone.'**
  String get settingsDataNote;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsRate.
  ///
  /// In en, this message translates to:
  /// **'Rate Bilans on Google Play'**
  String get settingsRate;

  /// No description provided for @settingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get settingsContact;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTerms;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get settingsLicenses;

  /// No description provided for @settingsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Calculations are indicative and do not replace professional tax, legal or financial advice.'**
  String get settingsDisclaimer;

  /// No description provided for @settingsProActive.
  ///
  /// In en, this message translates to:
  /// **'Bilans Pro is active'**
  String get settingsProActive;

  /// No description provided for @settingsManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get settingsManageSubscription;

  /// No description provided for @settingsProPitch.
  ///
  /// In en, this message translates to:
  /// **'All countries, team payroll, unlimited invoices, PDF reports and more.'**
  String get settingsProPitch;

  /// No description provided for @settingsSeePlans.
  ///
  /// In en, this message translates to:
  /// **'See plans'**
  String get settingsSeePlans;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
