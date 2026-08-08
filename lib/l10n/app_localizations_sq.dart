// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Albanian (`sq`).
class AppLocalizationsSq extends AppLocalizations {
  AppLocalizationsSq([String locale = 'sq']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Kryesore';

  @override
  String get navConvert => 'Konvertim';

  @override
  String get navSalary => 'Paga';

  @override
  String get navTools => 'Mjetet';

  @override
  String get navSettings => 'Cilësimet';

  @override
  String themeToggleTooltip(String mode) {
    return 'Ndrysho temën ($mode)';
  }

  @override
  String get themeModeSystem => 'e sistemit';

  @override
  String get themeModeLight => 'e çelët';

  @override
  String get themeModeDark => 'e errët';

  @override
  String get onboardingSkip => 'Kalo';

  @override
  String get onboardingContinue => 'Vazhdo';

  @override
  String get onboardingGetStarted => 'Fillo';

  @override
  String get onboardingWelcomeTitle => 'Mirë se vini';

  @override
  String get onboardingWelcomeSubtitle =>
      'Zgjidhni shtetin dhe gjuhën për të filluar. Mund t\'i ndryshoni këto në çdo kohë te Cilësimet.';

  @override
  String get onboardingCountryLabel => 'Shteti';

  @override
  String get onboardingPrivacyTitle => 'Të dhënat tuaja qëndrojnë në telefon';

  @override
  String get onboardingPrivacyBody =>
      'Pa llogari. Pa sinkronizim në renë kompjuterike. Pa server. Gjithçka që futni — pagat, shpenzimet, faturat — mbetet vetëm në këtë pajisje. Konvertimi valutor është i vetmi funksion që ka nevojë për lidhje interneti; pa të, përdoret kursi i fundit i njohur.';

  @override
  String get onboardingGoalTitle => 'Çfarë ju solli këtu?';

  @override
  String get onboardingGoalSubtitle =>
      'Do ta përshtatim ekranin kryesor sipas kësaj — gjithçka tjetër mbetet vetëm një prekje larg.';

  @override
  String get onboardingGoalSalaryTitle => 'Paga dhe llogaritja e të ardhurave';

  @override
  String get onboardingGoalSalaryDesc =>
      'Llogaritni neto nga bruto paga për 9 shtete';

  @override
  String get onboardingGoalExpensesTitle => 'Ndiqni të ardhurat dhe shpenzimet';

  @override
  String get onboardingGoalExpensesDesc =>
      'Regjistroni shpenzimet, vendosni buxhete, arrini qëllime kursimi';

  @override
  String get onboardingGoalBusinessTitle => 'Freelance dhe biznes';

  @override
  String get onboardingGoalBusinessDesc => 'Fatura, pagesa dhe mjete biznesi';

  @override
  String get commonCalculate => 'Llogarit';

  @override
  String get commonConvert => 'Konverto';

  @override
  String get commonRetry => 'Provo përsëri';

  @override
  String get commonSwapCurrencies => 'Ndërro valutat';

  @override
  String get commonSomethingWentWrong => 'Diçka shkoi keq.';

  @override
  String get commonFrom => 'Nga';

  @override
  String get commonTo => 'Në';

  @override
  String get commonAmount => 'Shuma';

  @override
  String get convertCardTitle => 'Konvertim';

  @override
  String get convertEmptyState =>
      'Vendos një shumë dhe shtyp Konverto për të parë kursin real, aktual.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Kursi aktual nga $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Kursi i ruajtur nga $formatted (jashtë linje) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Vendos një shumë.';

  @override
  String get convertAmountIssueInvalid =>
      'Kjo nuk duket si një numër i vlefshëm.';

  @override
  String get convertAmountIssueNegative => 'Shuma nuk mund të jetë negative.';

  @override
  String get convertAmountIssueZero =>
      'Shuma duhet të jetë më e madhe se zero.';

  @override
  String get convertAmountIssueTooLarge =>
      'Kjo duket jashtëzakonisht e madhe për një shumë — kontrollo nëse ka gabim shtypi.';

  @override
  String salaryTitle(String country) {
    return 'Kalkulatori i pagës — $country';
  }

  @override
  String salaryParamsLine(int year, String date) {
    return 'Parametrat për $year · në fuqi nga $date';
  }

  @override
  String get salaryModeGrossToNet => 'Bruto → Neto';

  @override
  String get salaryModeNetToGross => 'Neto → Bruto';

  @override
  String salaryGrossLabel(String currencyCode) {
    return 'Paga bruto, $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Paga neto, $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Vendos një pagë dhe shtyp Llogarit për një ndarje të plotë.';

  @override
  String get salaryNeto => 'Neto (në dorë)';

  @override
  String get salaryBruto => 'Bruto (paga)';

  @override
  String get salaryAllowance => 'Zbritja personale';

  @override
  String get salaryTaxableBase => 'Baza e tatueshme';

  @override
  String get salaryIncomeTax => 'Tatimi mbi të ardhurat';

  @override
  String get salaryLocalSurtax => 'Taksa vendore';

  @override
  String get salaryEmployeeContribTotal => 'Kontributet e punonjësit (total)';

  @override
  String get salaryEmployerContribTotal => 'Kontributet e punëdhënësit (total)';

  @override
  String get salaryBruto2 => 'Bruto 2 (kosto totale për punëdhënësin)';

  @override
  String salarySurtaxLabel(String rate) {
    return 'Taksa vendore: $rate% — vendose sipas normës së bashkisë tënde';
  }

  @override
  String get salaryDisclaimer =>
      'Kjo është një vlerësim vetëm për qëllime informative dhe nuk përbën këshillë tatimore, ligjore apo financiare. Detyrimet reale mund të ndryshojnë në varësi të rrethanave tuaja specifike — konsultohu me një kontabilist të licencuar ose autoritetin tatimor vendor përpara se të marrësh vendime.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Kjo shumë bruto është nën bazën minimale ligjore për kontribute ($base). Vetë kontributet e detyrueshme arrijnë ose kalojnë këtë pagë, kështu që shuma në dorë është zero ose negative — ky nivel page nuk është praktik për t\'u regjistruar zyrtarisht.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'Në këtë nivel të ardhurash, kontributet e detyrueshme dhe tatimi së bashku arrijnë ose kalojnë pagën bruto, kështu që shuma në dorë është zero ose negative.';

  @override
  String salaryConfigError(String country) {
    return 'Konfigurimi tatimor për $country nuk mund të ngarkohej.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Vendos një pagë.';

  @override
  String get salaryAmountIssueInvalid =>
      'Kjo nuk duket si një numër i vlefshëm.';

  @override
  String get salaryAmountIssueNegative => 'Paga nuk mund të jetë negative.';

  @override
  String get salaryAmountIssueZero => 'Paga duhet të jetë më e madhe se zero.';

  @override
  String get salaryAmountIssueTooLarge =>
      'Kjo duket jashtëzakonisht e madhe për një pagë — kontrollo nëse ka gabim shtypi.';

  @override
  String get toolsHubTitle => 'Mjete financiare';

  @override
  String get toolsLoanTitle => 'Kredi dhe borxhe';

  @override
  String get toolsSavingsTitle => 'Kursime dhe rritje';

  @override
  String get toolsVatTitle => 'Kalkulatori i TVSH-së';

  @override
  String get toolsBudgetTitle => 'Planifikuesi i buxhetit';

  @override
  String get toolsFreelancerPayoutTitle => 'Pagesa e freelancer-it';

  @override
  String get toolsFreelanceTaxTitle => 'Vetëdeklarimi i të vetëpunësuarve';

  @override
  String get homeQuoteOfDay => 'Citimi i ditës';

  @override
  String get homeQuickActions => 'Veprime të shpejta';

  @override
  String get settingsLanguage => 'Gjuha';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsAbout => 'Rreth aplikacionit';

  @override
  String get settingsSystemDefault => 'Parazgjedhja e sistemit';

  @override
  String get settingsNotificationsTitle => 'Njoftimet';

  @override
  String get notifExpenseNudgeTitle => 'Regjistro shpenzimet';

  @override
  String get notifExpenseNudgeSubtitle =>
      'Kujtesë e përditshme mbrëmjeje për të regjistruar të ardhurat dhe shpenzimet e sotme';

  @override
  String get notifExpenseNudgeNotifTitle => 'Regjistro shpenzimet e sotme?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Shto të ardhurat dhe shpenzimet e sotme para se të harrosh.';

  @override
  String get notifBudgetThresholdTitle => 'Njoftime buxheti';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Njofto kur buxheti i një kategorie arrin 80% ose 100%';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent% e buxhetit';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'Ke shpenzuar $percent% të buxhetit për $category këtë muaj.';
  }

  @override
  String get notifInvoiceDueTitle => 'Kujtesa për faturat';

  @override
  String get notifInvoiceDueSubtitle =>
      'Njofto një ditë para afatit të faturës';

  @override
  String get notifInvoiceDueNotifTitle => 'Fatura skadon nesër';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency skadon nesër.';
  }

  @override
  String get notifPausalReminderTitle => 'Kujtesë për tarifën fikse (Serbi)';

  @override
  String get notifPausalReminderSubtitle =>
      'Kujtesë mujore më 15 për deklarimin e detyrimeve me tarifë fikse';

  @override
  String get notifPausalReminderNotifTitle =>
      'Kujtesë për deklarimin e tarifës fikse';

  @override
  String get notifPausalReminderNotifBody =>
      'Mos harro deklarimin dhe pagesën mujore të tarifës fikse.';

  @override
  String notifPausalReminderNotifBodyWithAmount(String amount) {
    return 'Mos harro deklarimin dhe pagesën mujore të tarifës fikse në shumën $amount RSD.';
  }

  @override
  String get notifPausalLeadReminderTitle => 'Më kujto edhe 3 ditë më parë';

  @override
  String get notifPausalLeadReminderSubtitle =>
      'Një kujtesë shtesë më 12, para asaj kryesore më 15';

  @override
  String get notifPausalLeadReminderNotifTitle =>
      'Deklarimi i tarifës fikse pas 3 ditësh';

  @override
  String get notifPausalLeadReminderNotifBody =>
      'Deklarimi dhe pagesa mujore e tarifës fikse skadon pas 3 ditësh, më 15 të muajit.';

  @override
  String get settingsWidgetsTitle => 'Miniaplikacione në ekranin kryesor';

  @override
  String get settingsWidgetsExplainer =>
      'Shtoni një miniaplikacion nga ekrani kryesor i pajisjes (mbani gishtin gjatë në një hapësirë bosh → Miniaplikacione → Salary & Currency Pro) — aplikacioni nuk mund ta shtojë vetë. Pasi të shtohet, përditësohet automatikisht.';

  @override
  String get settingsWidgetsPinnedPairTitle =>
      'Çifti valutor i fiksuar për miniaplikacionin';

  @override
  String get homeWidgetBudgetLabel => 'Shpenzuar këtë muaj';

  @override
  String get homeWidgetBudgetEmpty =>
      'Vendosni një buxhet në aplikacion për ta parë këtu';

  @override
  String get homeWidgetPairUnavailable =>
      'Rifreskimi dështoi — po shfaqet kursi i fundit i njohur';

  @override
  String get countryRs => 'Serbia';

  @override
  String get countryHr => 'Kroacia';

  @override
  String get countryBa => 'Bosnja dhe Hercegovina';

  @override
  String get countryMe => 'Mali i Zi';

  @override
  String get countryMk => 'Maqedonia e Veriut';

  @override
  String get countrySi => 'Sllovenia';

  @override
  String get countryBg => 'Bullgaria';

  @override
  String get countryAl => 'Shqipëria';

  @override
  String get countryRo => 'Rumania';

  @override
  String get entityFbih => 'Federata e BeH';

  @override
  String get entityRepublikaSrpska => 'Republika Srpska';

  @override
  String get contribPio => 'PIO (pension dhe invaliditet)';

  @override
  String get contribHealth => 'Sigurim shëndetësor';

  @override
  String get contribUnemployment => 'Sigurim papunësie';

  @override
  String get contribPension => 'Sigurim pensioni';

  @override
  String get contribSocial => 'Sigurim shoqëror';

  @override
  String get contribChildProtection => 'Kontribut për mbrojtjen e fëmijëve';

  @override
  String get contribHealthAndEmployment => 'Sigurim shëndetësor dhe punësimi';

  @override
  String get contribCas => 'CAS (sigurim pensioni)';

  @override
  String get contribCass => 'CASS (sigurim shëndetësor)';

  @override
  String get contribCam => 'CAM (sigurim pune)';

  @override
  String get suffixEmployee => 'punonjësi';

  @override
  String get suffixEmployer => 'punëdhënësi';

  @override
  String get toolsLoanSubtitle => 'Këstet mujore, koha e shlyerjes, amortizimi';

  @override
  String get toolsSavingsSubtitle =>
      'Interesi i përbërë me kontribute periodike';

  @override
  String get toolsVatSubtitle =>
      'Shto ose hiq TVSH-në sipas normës së vendit tënd';

  @override
  String get toolsBudgetSubtitle =>
      'Ndaj të ardhurat mujore në nevoja / dëshira / kursime';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Faturë e huaj → tarifat → pagesa reale lokale';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Tatimi mbi të ardhurat dhe kontributet për të vetëpunësuarit, 9 vende';

  @override
  String get loanScreenTitle => 'Kredi dhe borxhe';

  @override
  String get loanModePayment => 'Kësti nga afati';

  @override
  String get loanModePayoff => 'Afati nga kësti';

  @override
  String get loanPrincipal => 'Shuma e kredisë (principali)';

  @override
  String get loanRate => 'Norma vjetore e interesit (%)';

  @override
  String get loanTermMonths => 'Afati i kredisë (muaj)';

  @override
  String get loanFixedPayment => 'Kësti mujor fiks';

  @override
  String get loanErrorPrincipalRate =>
      'Vendos një principal dhe normë interesi të vlefshme.';

  @override
  String get loanErrorTerm => 'Vendos një afat të vlefshëm në muaj.';

  @override
  String get loanErrorPayment => 'Vendos një këst mujor të vlefshëm.';

  @override
  String get loanErrorTooLow =>
      'Ky këst është shumë i ulët për ta shlyer ndonjëherë borxhin — nuk mbulon as interesin që grumbullohet çdo muaj.';

  @override
  String get loanMonthlyPayment => 'Kësti mujor';

  @override
  String get loanTotalPaid => 'Totali i paguar';

  @override
  String get loanTotalInterest => 'Interesi total';

  @override
  String get loanNumberOfPayments => 'Numri i kësteve';

  @override
  String get loanTimeToPayOff => 'Koha për shlyerje';

  @override
  String loanMonthsCount(int months) {
    return '$months muaj';
  }

  @override
  String get savingsScreenTitle => 'Kursime dhe rritje';

  @override
  String get savingsStartingAmount => 'Shuma fillestare';

  @override
  String get savingsMonthlyContribution => 'Kontributi mujor';

  @override
  String get savingsExpectedReturn => 'Kthimi vjetor i pritshëm (%)';

  @override
  String get savingsTimeHorizon => 'Horizonti kohor (vite)';

  @override
  String get savingsErrorRateYears =>
      'Vendos një normë vjetore dhe numër vitesh të vlefshëm.';

  @override
  String get savingsFutureValue => 'Vlera e ardhshme';

  @override
  String get savingsTotalContributed => 'Totali i kontribuar';

  @override
  String get savingsInterestEarned => 'Interesi i fituar';

  @override
  String get vatScreenTitle => 'Kalkulatori i TVSH-së';

  @override
  String get vatStandardRateFor => 'Norma standarde për';

  @override
  String get vatAdd => 'Shto TVSH';

  @override
  String get vatRemove => 'Hiq TVSH';

  @override
  String get vatNetAmount => 'Shuma neto (para TVSH-së)';

  @override
  String get vatGrossAmount => 'Shuma bruto (me TVSH)';

  @override
  String get vatRateEditable =>
      'Norma e TVSH-së (%) — e ndryshueshme për norma të reduktuara';

  @override
  String get vatGrossWithVat => 'Bruto (me TVSH)';

  @override
  String get vatAmountLabel => 'Shuma e TVSH-së';

  @override
  String get vatNetWithoutVat => 'Neto (pa TVSH)';

  @override
  String vatRatesAsOf(String date) {
    return 'Norma standarde që nga $date';
  }

  @override
  String get budgetScreenTitle => 'Planifikuesi i buxhetit';

  @override
  String get budgetMonthlyIncome => 'Të ardhurat mujore neto';

  @override
  String get budgetSplit => 'Ndarja';

  @override
  String get budgetPresetSuffix => '(nevoja/dëshira/kursime)';

  @override
  String get budgetNeeds => 'Nevoja';

  @override
  String get budgetWants => 'Dëshira';

  @override
  String get budgetSavings => 'Kursime';

  @override
  String get freelancerScreenTitle =>
      'Kontrolli i pagesës reale të freelancer-it';

  @override
  String get freelancerInvoiceAmount => 'Shuma e faturës';

  @override
  String get freelancerCurrency => 'Valuta';

  @override
  String get freelancerPlatform => 'Platforma';

  @override
  String get freelancerPlatformCustom => 'E personalizuar';

  @override
  String get freelancerPlatformDirect => 'Klient direkt / transfertë (0%)';

  @override
  String get freelancerPlatformFee => 'Tarifa e platformës (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Tarifa bankare (fikse, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Tarifa bankare (%)';

  @override
  String get freelancerPayoutCurrency => 'Valuta e pagesës';

  @override
  String get freelancerCalculateButton => 'Llogarit pagesën reale';

  @override
  String get freelancerErrorInvoice => 'Vendos një shumë fature të vlefshme.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Gabim i papritur: $error';
  }

  @override
  String get freelancerRealPayout => 'Pagesa reale';

  @override
  String get freelancerInvoiceAmountRow => 'Shuma e faturës';

  @override
  String get freelancerPlatformFeeRow => 'Tarifa e platformës';

  @override
  String get freelancerBankFeeRow => 'Tarifa bankare';

  @override
  String get freelancerNetForeignAmount => 'Shuma neto në valutë të huaj';

  @override
  String get samoFixedModel => 'Modeli me shpenzim fiks';

  @override
  String get samoMixedModel => 'Modeli me shpenzim të përzier';

  @override
  String get samoCheaperSame =>
      'Ky model është opsioni më i lirë për këtë shumë.';

  @override
  String get samoCheaperOther =>
      'Modeli tjetër do të prodhonte më pak taksë për këtë shumë — mund t\'i ndërrosh modelet lirisht çdo tremujor.';

  @override
  String get freelanceTaxScreenTitle => 'Vetëdeklarimi i të vetëpunësuarve';

  @override
  String get freelanceTaxCountryLabel => 'Vendi / regjimi';

  @override
  String get freelanceTaxIncomeLabelQuarterly => 'Të ardhura bruto tremujore';

  @override
  String get freelanceTaxIncomeLabelAnnual => 'Të ardhura bruto vjetore';

  @override
  String get freelanceTaxNetIncome => 'Të ardhura neto';

  @override
  String get freelanceTaxGrossIncomeRow => 'Të ardhura bruto';

  @override
  String get freelanceTaxDeductionRow => 'Zbritje';

  @override
  String get freelanceTaxTaxableBaseRow => 'Baza tatimore';

  @override
  String get freelanceTaxIncomeTaxRow => 'Tatimi mbi të ardhurat';

  @override
  String get freelanceTaxContributionsTotalRow => 'Kontribute gjithsej';

  @override
  String freelanceTaxRulesVersionBundle(String date) {
    return 'Normat e integruara në aplikacion · versioni $date';
  }

  @override
  String freelanceTaxRulesVersionUpdated(String date) {
    return 'Normat e përditësuara online · versioni $date';
  }

  @override
  String freelanceTaxSourcesLabel(String sources) {
    return 'Burimet: $sources';
  }

  @override
  String get freelanceTaxNotAvailable => 'Nuk ofrohet';

  @override
  String get freelanceTaxModelLabel => 'Modeli';

  @override
  String get freelanceTaxVariantLabel => 'Lloji';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Kategoria e veprimtarisë';

  @override
  String get freelanceFbihCategoryFreeProfessions => 'Profesione të lira';

  @override
  String get freelanceFbihCategoryObrt => 'Zejtari (obrt)';

  @override
  String get freelanceFbihCategoryAgriculture => 'Bujqësi / pylltari';

  @override
  String get freelanceFbihCategoryLumpSumObrt => 'Zejtari me tarifë fikse';

  @override
  String get freelanceFbihCategoryTraditionalCraftsTaxi =>
      'Zanate tradicionale / taksi';

  @override
  String get freelanceTaxCategoryLabel => 'Kategoria';

  @override
  String get freelanceBaRsCategoryStandard => 'Sipërmarrës standard';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Profesione të pavarura';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Veprimtari plotësuese / pensionist';

  @override
  String get freelanceTaxMunicipalityLabel => 'Bashkia';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Podgoricë / Cetinje';

  @override
  String get freelanceMeMunicipalityBudva => 'Budva';

  @override
  String get freelanceMeMunicipalityOther => 'Bashki tjetër';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'Pragu i regjistrimit të TVSH-së: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return 'Tatimi 0% mbi të ardhurat vlen vetëm deri në xhiro $amount $currency — mbi këtë, i gjithë fitimi tatohet në mënyrë progresive, jo vetëm teprica.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Përfitimi i 80% shpenzimeve të supozuara vlen vetëm deri në të ardhura $amount $currency.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Përshtatshmëria për popoldanski s.p. përfundon në të ardhura $amount $currency.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'Statusi alternativ i sipërmarrësit me tarifë fikse është i kufizuar në $amount $currency — vetëm informues, nuk modelohet nga ky llogaritës.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Ende nuk është arritur';

  @override
  String get freelanceCliffStatusCrossed => 'Kaluar';

  @override
  String get freelanceRsInsuredElsewhereLabel =>
      'Tashmë i/e siguruar në një bazë tjetër (kontributi shëndetësor nuk aplikohet)';

  @override
  String freelanceRsMinPioBaseBinds(String amount) {
    return 'Kontributi për PIO (pensionin) te Modeli B kufizohet në bazën minimale ($amount) — kjo është rasti që njerëzit e vlerësojnë më shpesh gabimisht.';
  }

  @override
  String get freelanceComparatorTitle => 'Krahaso Modelin A me Modelin B';

  @override
  String get freelanceComparatorQuarterLabel => 'Tremujori';

  @override
  String freelanceComparatorDeadlineHint(String date) {
    return 'Afati i deklarimit për këtë tremujor: $date';
  }

  @override
  String get freelanceComparatorNeedsIncome =>
      'Vendos të ardhurat më sipër për të krahasuar të dy modelet.';

  @override
  String freelanceComparatorRecommended(String model, String amount) {
    return 'Rekomandim: $model — kursim prej $amount në të ardhurat neto.';
  }

  @override
  String get settingsProActive => 'Pro — aktiv';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Reklamat janë fikur në të gjithë aplikacionin';

  @override
  String get settingsProSubtitleInactive =>
      'Hiq reklamat me një abonim të përballueshëm';

  @override
  String get settingsTrustTitle => 'Pse ta besosh këtë aplikacion?';

  @override
  String get settingsTrustBody =>
      'Shifrat për pagat, TVSH-në dhe vetëtaksimin vijnë nga burime të cituara qeveritare dhe këshillimi tatimor profesional, jo nga vlerësime. Çdo kalkulator tregon vitin për të cilin vlejnë shifrat dhe datën kur hynë në fuqi, që ta vlerësosh menjëherë freskinë e tyre. Shiko „Privatësia dhe të dhënat“ dhe „Funksionon plotësisht offline“ më poshtë për mënyrën si trajtohen të dhënat e tua.';

  @override
  String get settingsAdPrivacyTitle => 'Privatësia dhe preferencat e reklamave';

  @override
  String get settingsAdPrivacySubtitle =>
      'Shiko ose ndrysho zgjedhjet e tua për pëlqimin e reklamave';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Opsionet e privatësisë së reklamave nuk janë të disponueshme në këtë platformë.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'Për rajonin tënd nuk kërkohet zgjedhje për privatësinë e reklamave.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro mbulon llogaritjen e pagave, konvertimin e valutave dhe kalkulatorë financiarë të përditshëm për Serbinë, Kroacinë, Bosnjën dhe Hercegovinën, Malin e Zi, Maqedoninë e Veriut, Sllovenínë, Bullgarinë, Shqipërinë dhe Rumaninë. Të gjitha shifrat janë të burimuara dhe të datuara — shiko shënimin e çdo kalkulatori për detaje. Ky aplikacion ofron vetëm vlerësime, jo këshillë profesionale.';

  @override
  String get paywallTitle => 'Bëhu Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Hiq të gjitha reklamat në çdo kalkulator, me një çmim mujor të përballueshëm. Të gjitha vendet për llogaritjen e pagave, konvertimi i valutave dhe mjetet financiare mbeten falas gjithsesi.';

  @override
  String get paywallActiveMessage =>
      'Je përdorues Pro — faleminderit! Reklamat janë fikur në të gjithë aplikacionin.';

  @override
  String get paywallStoreUnavailable =>
      'Dyqani nuk është i disponueshëm tani (kjo pritet në versionet zhvillimore pa një listim të konfiguruar në Play Console). Pro do të mund të blihet pas publikimit.';

  @override
  String get paywallProductUnavailable =>
      'Abonimi Pro nuk është konfiguruar ende në dyqan — ky është një ekran përkohshëm derisa produkti i vërtetë të krijohet në Play Console.';

  @override
  String get paywallSubscribe => 'Abonohu';

  @override
  String get paywallProcessing => 'Duke përpunuar…';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Blerja dështoi: $error';
  }

  @override
  String get paywallRestorePurchase => 'Rikthe blerjen';

  @override
  String get chartTakeHome => 'Në dorë';

  @override
  String get chartTax => 'Tatimi';

  @override
  String get chartContributions => 'Kontributet';

  @override
  String get homeRecentlyUsed => 'Përdorur së fundmi';

  @override
  String get categoryLoansSavings => 'Kredi dhe kursime';

  @override
  String get categoryBudgetTax => 'Buxhetim dhe taksa';

  @override
  String get categoryFreelance => 'Freelancing';

  @override
  String get toolsSearchHint => 'Kërko mjete';

  @override
  String get toolsSearchNoResults => 'Nuk u gjetën mjete';

  @override
  String get homeLastSalaryTitle => 'Llogaritja e fundit e pagës';

  @override
  String get homeLastSalaryEmpty => 'Ende nuk keni llogaritur pagën.';

  @override
  String get homeLastSalaryCta => 'Llogarit tani';

  @override
  String get settingsPrivacyTitle => 'Privatësia dhe të dhënat';

  @override
  String get settingsPrivacyNote =>
      'Historiku i llogaritjeve ruhet vetëm në këtë pajisje dhe nuk ngarkohet apo shpërndahet kurrë. Fshirja e tij ose çinstalimi i aplikacionit e heq atë përgjithmonë.';

  @override
  String get settingsClearHistory => 'Fshi historikun';

  @override
  String get settingsClearHistorySubtitle =>
      'Hiq të gjitha llogaritjet e fundit nga Kryefaqja dhe Mjetet';

  @override
  String get settingsClearHistoryDialogTitle => 'Të fshihet historiku?';

  @override
  String get settingsClearHistoryDialogBody =>
      'Kjo heq gjithë aktivitetin e fundit nga Kryefaqja dhe Mjetet. Ky veprim nuk mund të zhbëhet.';

  @override
  String get settingsClearHistoryDialogCancel => 'Anulo';

  @override
  String get settingsClearHistoryDialogConfirm => 'Fshi';

  @override
  String get settingsClearHistoryDone => 'Historiku u fshi';

  @override
  String get commonCancel => 'Anulo';

  @override
  String get commonSave => 'Ruaj';

  @override
  String get commonDelete => 'Fshi';

  @override
  String get commonRename => 'Riemërto';

  @override
  String get commonUndo => 'Zhbëj';

  @override
  String get scenarioSaveTooltip => 'Ruaj këtë llogaritje';

  @override
  String get scenarioSaveDialogTitle => 'Ruaj llogaritjen';

  @override
  String get scenarioNameLabel => 'Emri';

  @override
  String get scenarioSavedConfirmation => 'Skenari u ruajt';

  @override
  String get scenarioLimitTitle => 'U arrit limiti falas';

  @override
  String scenarioLimitBody(int limit) {
    return 'Llogaritë falas mund të ruajnë deri në $limit skenarë. Kalo në Pro për ruajtje, krahasim dhe eksportim të pakufizuar.';
  }

  @override
  String get scenarioLimitUpgrade => 'Kalo në Pro';

  @override
  String get myScenariosTitle => 'Skenarët e mi';

  @override
  String myScenariosSubtitle(int count) {
    return '$count të ruajtur';
  }

  @override
  String get myScenariosSubtitleEmpty => 'Nuk ka skenarë të ruajtur';

  @override
  String get myScenariosEmptyState =>
      'Ruaj një llogaritje nga çdo mjet për ta parë këtu.';

  @override
  String get scenarioRenameDialogTitle => 'Riemërto skenarin';

  @override
  String get scenarioDeleteDialogTitle => 'Të fshihet skenari?';

  @override
  String get scenarioDeleteDialogBody => 'Kjo nuk mund të zhbëhet.';

  @override
  String get categoryTracking => 'Ndjekje dhe planifikim';

  @override
  String get toolsExpenseTrackerTitle => 'Gjurmuesi i shpenzimeve';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Regjistroni të ardhurat dhe shpenzimet, shikoni bilancin mujor';

  @override
  String get expenseScreenTitle => 'Gjurmuesi i shpenzimeve';

  @override
  String get expenseIncome => 'Të ardhura';

  @override
  String get expenseExpenses => 'Shpenzime';

  @override
  String get expenseBalance => 'Bilanci';

  @override
  String get expenseEmptyState =>
      'Nuk ka ende transaksione këtë muaj. Prekni + për të shtuar të ardhurën ose shpenzimin e parë.';

  @override
  String get expenseAddIncome => 'Shto të ardhur';

  @override
  String get expenseAddExpense => 'Shto shpenzim';

  @override
  String get expenseAmount => 'Shuma';

  @override
  String get expenseCategory => 'Kategoria';

  @override
  String get expenseNote => 'Shënim (opsionale)';

  @override
  String get expenseDate => 'Data';

  @override
  String get expenseDeleteConfirmTitle => 'Të fshihet ky transaksion?';

  @override
  String get expenseDeleteConfirmBody =>
      'Menjëherë pas kësaj do të keni një mundësi të shkurtër për ta zhbërë.';

  @override
  String get expenseDeletedConfirmation => 'Transaksioni u fshi';

  @override
  String get expenseEditTransaction => 'Redakto transaksionin';

  @override
  String get expenseSearchHint => 'Kërko në shënime ose kategori';

  @override
  String get expenseFilterAll => 'Të gjitha';

  @override
  String get expenseSortByDate => 'Rendit sipas datës';

  @override
  String get expenseSortByAmount => 'Rendit sipas shumës';

  @override
  String get expenseNoResults => 'Asnjë transaksion nuk përputhet me kërkimin.';

  @override
  String expenseResultCount(int shown, int total) {
    return '$shown nga $total';
  }

  @override
  String get expenseSpendingByCategory => 'Shpenzimet sipas kategorisë';

  @override
  String get toolsRecurringTitle => 'Transaksione të përsëritura';

  @override
  String get toolsRecurringSubtitle =>
      'Qiraja, abonimet dhe pagesa të tjera të rregullta — përcaktoje një herë';

  @override
  String get recurringScreenTitle => 'Transaksione të përsëritura';

  @override
  String get recurringEmptyState =>
      'Ende nuk ka transaksione të përsëritura. Shto qiranë, abonimet ose pagesa të tjera të rregullta një herë — do të regjistrohen automatikisht ose do të presin shqyrtimin tënd, sipas zgjedhjes.';

  @override
  String get recurringAddTitle => 'Transaksion i ri i përsëritur';

  @override
  String get recurringEditTitle => 'Redakto transaksionin e përsëritur';

  @override
  String get recurringFrequencyLabel => 'Përsëritet';

  @override
  String get recurringFrequencyWeekly => 'Javore';

  @override
  String get recurringFrequencyMonthly => 'Mujore';

  @override
  String get recurringStartDateLabel => 'Fillon';

  @override
  String get recurringAutoPostLabel => 'Regjistrim automatik';

  @override
  String get recurringAutoPostSubtitle =>
      'Off: shqyrto çdo shfaqje para se të shtohet';

  @override
  String get recurringPausedLabel => 'Pauzuar';

  @override
  String get recurringPauseAction => 'Pauzo';

  @override
  String get recurringResumeAction => 'Vazhdo';

  @override
  String get recurringDeleteConfirmTitle =>
      'Të fshihet ky transaksion i përsëritur?';

  @override
  String get recurringDeleteConfirmBody =>
      'Kjo ndalon shfaqjet e ardhshme. Transaksionet e regjistruara tashmë nuk preken.';

  @override
  String recurringReviewBannerTitle(int count) {
    return '$count transaksione të përsëritura për shqyrtim';
  }

  @override
  String get recurringReviewPost => 'Regjistro';

  @override
  String get recurringReviewSkip => 'Kapërce';

  @override
  String get toolsRadarTitle => 'Radari i kostove fikse';

  @override
  String get toolsRadarSubtitle =>
      'Shiko koston totale të përsëritur në një vend';

  @override
  String get radarScreenTitle => 'Radari i kostove fikse';

  @override
  String get radarEmptyState =>
      'Ende nuk ka shpenzime të përsëritura aktive. Shto një nga Transaksionet e Përsëritura për ta parë koston totale fikse këtu.';

  @override
  String get radarMonthlyTotal => 'Total mujor';

  @override
  String get radarWeeklyTotal => 'Total javor';

  @override
  String radarNextDue(String date) {
    return 'Tjetra: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Buxhetet dhe objektivat';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Vendosni kufij mujorë të shpenzimeve dhe ndiqni objektivat e kursimit';

  @override
  String get budgetsScreenTitle => 'Buxhetet dhe objektivat';

  @override
  String get budgetsSectionCategoryBudgets => 'Buxhetet sipas kategorive';

  @override
  String get budgetsSectionGoals => 'Objektivat e kursimit';

  @override
  String get budgetsNoLimitSet => 'Nuk është vendosur kufi';

  @override
  String get budgetsSetLimit => 'Vendos kufirin';

  @override
  String get budgetsEditLimit => 'Redakto kufirin';

  @override
  String get budgetsMonthlyLimit => 'Kufiri mujor';

  @override
  String get budgetsOverBudget => 'Tejkalim i buxhetit';

  @override
  String get budgetsNoBudgetsHint =>
      'Vendosni një kufi mujor për çdo kategori më poshtë për të ndjekur shpenzimet tuaja kundrejt tij.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Të hiqet ky kufi?';

  @override
  String get budgetsDeleteLimitConfirmBody =>
      'Mund të vendosni një të ri në çdo kohë.';

  @override
  String get budgetsAddGoal => 'Shto objektiv';

  @override
  String get budgetsGoalName => 'Emri i objektivit';

  @override
  String get budgetsTargetAmount => 'Shuma e synuar';

  @override
  String get budgetsTargetDateOptional => 'Data e synuar (opsionale)';

  @override
  String get budgetsNoTargetDate => 'Pa datë të synuar';

  @override
  String get budgetsAddProgress => 'Shto përparim';

  @override
  String get budgetsProgressAmountLabel => 'Shuma për të shtuar';

  @override
  String get budgetsGoalComplete => 'Objektivi u arrit!';

  @override
  String get budgetsNoGoalsYet =>
      'Ende nuk ka objektiva kursimi. Shtoni një për të filluar ndjekjen e përparimit drejt diçkaje konkrete.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Të fshihet ky objektiv?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'Kjo nuk mund të zhbëhet.';

  @override
  String get budgetsProgressExplanation =>
      'Përparimi përditësohet vetëm kur e shtoni manualisht këtu — ky aplikacion nuk ka lidhje bankare, kështu që asgjë nuk ndiqet automatikisht.';

  @override
  String get expenseInsightsTitle => 'Vështrime';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Shpenzimet janë $percent% më të larta se muajin e kaluar ($current kundrejt $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Shpenzimet janë $percent% më të ulëta se muajin e kaluar ($current kundrejt $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Shpenzimet janë të ngjashme me muajin e kaluar ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category është kategoria juaj më e madhe e shpenzimeve këtë muaj, me $percent% të shpenzimeve totale.';
  }

  @override
  String get expenseInsightHowCalculated => 'Shiko llogaritjen';

  @override
  String expenseInsightCounter(int current, int total) {
    return '$current nga $total';
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
    return '$categoryAmount ÷ $total gjithsej × 100 = $percent%';
  }

  @override
  String get expenseExportCsv => 'Eksporto CSV';

  @override
  String get expenseExportCopied =>
      'CSV u kopjua në kujtesën e fragmenteve — ngjiteni në një fletëllogaritëse ose shënime';

  @override
  String get expenseExportEmpty =>
      'Nuk ka transaksione këtë muaj për t\'u eksportuar';

  @override
  String get settingsDataManagementTitle => 'Menaxhimi i të dhënave';

  @override
  String get settingsExportAllData => 'Eksporto të gjitha të dhënat (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Kopjo transaksionet, skenarët, buxhetet dhe objektivat në kujtesën e fragmenteve';

  @override
  String get settingsExportAllDataEmpty =>
      'Ende nuk ka të dhëna për t\'u eksportuar';

  @override
  String get settingsExportAllDataDone =>
      'Të gjitha të dhënat u kopjuan në kujtesën e fragmenteve';

  @override
  String get settingsDeleteAllData => 'Fshi të gjitha të dhënat lokale';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Fshi përgjithmonë transaksionet, skenarët, buxhetet dhe objektivat nga kjo pajisje';

  @override
  String get settingsDeleteAllDataDialog1Title =>
      'Të fshihen të gjitha të dhënat lokale?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'Kjo heq përgjithmonë çdo transaksion, skenar të ruajtur, buxhet sipas kategorisë dhe objektiv kursimi të ruajtur në këtë pajisje. Kjo nuk mund të zhbëhet. Edhe historiku juaj i llogaritjeve do të pastrohet.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Jeni plotësisht i sigurt?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'Kjo është shansi juaj i fundit për të anuluar. Nuk ka asnjë mënyrë për t\'i rikuperuar këto të dhëna më pas.';

  @override
  String get settingsDeleteAllDataConfirm => 'Fshi gjithçka';

  @override
  String get settingsDeleteAllDataDone => 'Të gjitha të dhënat lokale u fshinë';

  @override
  String get settingsOfflineStatusTitle => 'Funksionon plotësisht offline';

  @override
  String get settingsOfflineStatusBody =>
      'Ky aplikacion nuk ka llogari, sinkronizim në renë kompjuterike apo server — gjithçka që futni mbetet vetëm në këtë pajisje. Kursi i këmbimit valutor është i vetmi funksion që ka nevojë për lidhje interneti; nëse jeni offline, përdoret kursi i fundit i njohur.';

  @override
  String get toolsInvoicesTitle => 'Faturat';

  @override
  String get toolsInvoicesSubtitle =>
      'Ndiqni çfarë ju detyrohen klientët — paguar, papaguar dhe të vonuara';

  @override
  String get invoicesScreenTitle => 'Faturat';

  @override
  String get invoicesEmptyState =>
      'Ende nuk ka fatura. Prekni + për të shtuar të parën.';

  @override
  String get invoiceOutstanding => 'Papaguar';

  @override
  String get invoiceOverdue => 'Vonuar';

  @override
  String get invoiceFilterAll => 'Të gjitha';

  @override
  String get invoiceFilterUnpaid => 'Papaguar';

  @override
  String get invoiceFilterOverdue => 'Vonuar';

  @override
  String get invoiceFilterPaid => 'Paguar';

  @override
  String get invoiceStatusPaid => 'Paguar';

  @override
  String get invoiceStatusUnpaid => 'Papaguar';

  @override
  String get invoiceStatusOverdue => 'Vonuar';

  @override
  String get invoiceDueLabel => 'Afati';

  @override
  String get invoiceMarkPaid => 'Shëno si të paguar';

  @override
  String get invoiceMarkUnpaid => 'Shëno si të papaguar';

  @override
  String get invoiceDeleteConfirmTitle => 'Të fshihet kjo faturë?';

  @override
  String get invoiceDeleteConfirmBody => 'Kjo nuk mund të zhbëhet.';

  @override
  String get invoiceAddTitle => 'Shto faturë';

  @override
  String get invoiceEditTitle => 'Redakto faturën';

  @override
  String get invoiceClientName => 'Emri i klientit';

  @override
  String get invoiceDescription => 'Përshkrimi (opsionale)';

  @override
  String get invoiceAmount => 'Shuma';

  @override
  String get invoiceIssueDate => 'Data e lëshimit';

  @override
  String get invoiceDueDate => 'Afati i pagesës';

  @override
  String get toolsPausalTrackerTitle => 'Ndjekësi i tarifës fikse (Serbi)';

  @override
  String get toolsPausalTrackerSubtitle =>
      'Ndiq xhiron kundrejt kufirit të tarifës fikse dhe pragut të TVSH-së';

  @override
  String get pausalTrackerCeilingCardTitle =>
      'Kufiri i tarifës fikse (këtë vit kalendarik)';

  @override
  String get pausalTrackerVatCardTitle =>
      'Pragu i regjistrimit në TVSH (12 muajt e fundit)';

  @override
  String get pausalTrackerStateOk => 'Në rregull';

  @override
  String get pausalTrackerStateWarning70 => 'Arritur 70% — ia vlen të ndiqet';

  @override
  String get pausalTrackerStateWarning85 =>
      'Arritur 85% — kushtoji vëmendje të veçantë';

  @override
  String get pausalTrackerStateWarning95 =>
      'Arritur 95% — ka gjasa të nevojitet veprim së shpejti';

  @override
  String get pausalTrackerStateExceeded => 'Tejkaluar';

  @override
  String pausalTrackerProjection(String date) {
    return 'Me ritmin aktual, do ta arrije kufirin e tarifës fikse rreth $date.';
  }

  @override
  String pausalTrackerExcludedBanner(int count) {
    return '$count faturë(a) të përjashtuara — kursi i këmbimit nuk është i disponueshëm';
  }

  @override
  String get pausalTrackerSeeBreakdown => 'Shiko shifrat';

  @override
  String get pausalTrackerBreakdownTitle => 'Si u llogarit kjo';

  @override
  String get pausalTrackerBreakdownExcludedHeader =>
      'Të përjashtuara — kursi i këmbimit nuk është i disponueshëm';

  @override
  String pausalTrackerBreakdownRateLabel(String source) {
    return 'kursi: $source';
  }

  @override
  String get pausalTrackerBreakdownExcludedReason =>
      'Për këtë faturë nuk u arrit të merret një kurs këmbimi — u përjashtua nga totali në vend që të vlerësohej.';

  @override
  String get pausalTrackerAssessedAmountLabel =>
      'Shuma mujore e vlerësuar e tarifës fikse';

  @override
  String get pausalTrackerAssessedAmountHint =>
      'Opsionale — vendos shumën nga vendimi yt tatimor. Aplikacioni nuk mund ta llogarisë vetë.';

  @override
  String get pausalTrackerAssessedAmountSaved => 'U ruajt';

  @override
  String pausalTrackerAssessedAmountDecomposition(
    String tax,
    String pio,
    String health,
    String unemployment,
    String total,
  ) {
    return '= $tax taksë + $pio pension + $health shëndetësi + $unemployment papunësi = $total e bazës së përcaktuar nga vendimi.';
  }

  @override
  String get commonClearSearch => 'Pastro kërkimin';

  @override
  String get expensePreviousMonth => 'Muaji i kaluar';

  @override
  String get expenseNextMonth => 'Muaji tjetër';

  @override
  String get homeExpenseTrackerTitle => 'Këtë muaj';

  @override
  String get homeExpenseTrackerCtaEmpty =>
      'Ndiqni të ardhurat dhe shpenzimet tuaja';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'Po ndiqen më shumë valuta — prekni për t\'i parë të gjitha';

  @override
  String get catHousing => 'Banesa dhe qiraja';

  @override
  String get catUtilities => 'Shërbime komunale';

  @override
  String get catGroceries => 'Ushqime';

  @override
  String get catTransport => 'Transporti';

  @override
  String get catHealth => 'Shëndeti';

  @override
  String get catEducation => 'Arsimi';

  @override
  String get catEntertainment => 'Argëtimi';

  @override
  String get catOtherExpense => 'Tjetër';

  @override
  String get catSalary => 'Rroga';

  @override
  String get catFreelance => 'Freelance / biznes';

  @override
  String get catOtherIncome => 'Të ardhura të tjera';
}
