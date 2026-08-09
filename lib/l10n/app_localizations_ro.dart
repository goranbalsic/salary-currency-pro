// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Acasă';

  @override
  String get navConvert => 'Conversie';

  @override
  String get navSalary => 'Salariu';

  @override
  String get navTools => 'Instrumente';

  @override
  String get navSettings => 'Setări';

  @override
  String themeToggleTooltip(String mode) {
    return 'Schimbă tema ($mode)';
  }

  @override
  String get themeModeSystem => 'sistem';

  @override
  String get themeModeLight => 'luminoasă';

  @override
  String get themeModeDark => 'întunecată';

  @override
  String get onboardingSkip => 'Omite';

  @override
  String get onboardingContinue => 'Continuă';

  @override
  String get onboardingGetStarted => 'Începe';

  @override
  String get onboardingWelcomeTitle => 'Bun venit';

  @override
  String get onboardingWelcomeSubtitle =>
      'Alege țara și limba pentru a începe. Le poți schimba oricând din Setări.';

  @override
  String get onboardingCountryLabel => 'Țară';

  @override
  String get onboardingPrivacyTitle => 'Datele tale rămân pe telefon';

  @override
  String get onboardingPrivacyBody =>
      'Fără cont. Fără sincronizare în cloud. Fără server. Tot ce introduci — salarii, cheltuieli, facturi — rămâne doar pe acest dispozitiv. Conversia valutară este singura funcție care are nevoie de o conexiune la internet; fără ea, se folosește ultimul curs cunoscut.';

  @override
  String get onboardingGoalTitle => 'Ce te aduce aici?';

  @override
  String get onboardingGoalSubtitle =>
      'Vom adapta ecranul principal în funcție de asta — restul rămâne la o atingere distanță.';

  @override
  String get onboardingGoalSalaryTitle => 'Salariu și calcul de venituri';

  @override
  String get onboardingGoalSalaryDesc =>
      'Calculează net din brut pentru 9 țări';

  @override
  String get onboardingGoalExpensesTitle => 'Urmărește venituri și cheltuieli';

  @override
  String get onboardingGoalExpensesDesc =>
      'Înregistrează cheltuieli, stabilește bugete, atinge obiective de economisire';

  @override
  String get onboardingGoalBusinessTitle => 'Freelancing și afaceri';

  @override
  String get onboardingGoalBusinessDesc =>
      'Facturi, plăți și instrumente de afaceri';

  @override
  String get commonCalculate => 'Calculează';

  @override
  String get commonConvert => 'Convertește';

  @override
  String get commonRetry => 'Încearcă din nou';

  @override
  String get commonSwapCurrencies => 'Schimbă valutele';

  @override
  String get commonSomethingWentWrong => 'Ceva nu a mers bine.';

  @override
  String get commonFrom => 'Din';

  @override
  String get commonTo => 'În';

  @override
  String get commonAmount => 'Sumă';

  @override
  String get convertCardTitle => 'Conversie';

  @override
  String get convertEmptyState =>
      'Introduceți o sumă și apăsați Convertește pentru cursul real, actual.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Curs actual de la $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Curs salvat din $formatted (offline) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Introduceți o sumă.';

  @override
  String get convertAmountIssueInvalid => 'Acesta nu pare un număr valid.';

  @override
  String get convertAmountIssueNegative => 'Suma nu poate fi negativă.';

  @override
  String get convertAmountIssueZero =>
      'Suma trebuie să fie mai mare decât zero.';

  @override
  String get convertAmountIssueTooLarge =>
      'Aceasta pare neobișnuit de mare pentru o sumă — verificați dacă nu este o greșeală de tastare.';

  @override
  String salaryTitle(String country) {
    return 'Calculator de salariu — $country';
  }

  @override
  String salaryParamsLine(int year, String date) {
    return 'Parametri pentru $year · valabili de la $date';
  }

  @override
  String get salaryModeGrossToNet => 'Brut → Net';

  @override
  String get salaryModeNetToGross => 'Net → Brut';

  @override
  String salaryGrossLabel(String currencyCode) {
    return 'Salariu brut, $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Salariu net, $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Introduceți un salariu și apăsați Calculează pentru o defalcare completă.';

  @override
  String get salaryNeto => 'Net (de încasat)';

  @override
  String get salaryBruto => 'Brut (salariu)';

  @override
  String get salaryAllowance => 'Deducere personală';

  @override
  String get salaryTaxableBase => 'Bază impozabilă';

  @override
  String get salaryIncomeTax => 'Impozit pe venit';

  @override
  String get salaryLocalSurtax => 'Suprataxă locală';

  @override
  String get salaryEmployeeContribTotal => 'Contribuțiile angajatului (total)';

  @override
  String get salaryEmployerContribTotal =>
      'Contribuțiile angajatorului (total)';

  @override
  String get salaryBruto2 => 'Brut 2 (costul total pentru angajator)';

  @override
  String salarySurtaxLabel(String rate) {
    return 'Suprataxă locală: $rate% — setați la rata localității dumneavoastră';
  }

  @override
  String get salaryDisclaimer =>
      'Aceasta este o estimare doar în scop informativ și nu constituie consultanță fiscală, juridică sau financiară. Obligațiile reale pot varia în funcție de circumstanțele dumneavoastră specifice — consultați un contabil autorizat sau autoritatea fiscală locală înainte de a lua decizii.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Această sumă brută este sub baza minimă legală pentru contribuții ($base). Contribuțiile obligatorii ating sau depășesc singure acest salariu, astfel încât suma de încasat este zero sau negativă — acest nivel de salariu este impracticabil de înregistrat oficial.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'La acest nivel de venit, contribuțiile obligatorii și impozitul împreună ating sau depășesc salariul brut, astfel încât suma de încasat este zero sau negativă.';

  @override
  String salaryConfigError(String country) {
    return 'Configurația fiscală pentru $country nu a putut fi încărcată.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Introduceți un salariu.';

  @override
  String get salaryAmountIssueInvalid => 'Acesta nu pare un număr valid.';

  @override
  String get salaryAmountIssueNegative => 'Salariul nu poate fi negativ.';

  @override
  String get salaryAmountIssueZero =>
      'Salariul trebuie să fie mai mare decât zero.';

  @override
  String get salaryAmountIssueTooLarge =>
      'Acesta pare neobișnuit de mare pentru un salariu — verificați dacă nu este o greșeală de tastare.';

  @override
  String get toolsHubTitle => 'Instrumente financiare';

  @override
  String get toolsLoanTitle => 'Împrumuturi și datorii';

  @override
  String get toolsSavingsTitle => 'Economii și creștere';

  @override
  String get toolsVatTitle => 'Calculator TVA';

  @override
  String get toolsBudgetTitle => 'Planificator de buget';

  @override
  String get toolsFreelancerPayoutTitle => 'Plata freelancerului';

  @override
  String get toolsFreelanceTaxTitle =>
      'Autoimpunere pentru liber-profesioniști';

  @override
  String get homeQuoteOfDay => 'Citatul zilei';

  @override
  String get homeQuickActions => 'Acțiuni rapide';

  @override
  String get settingsLanguage => 'Limbă';

  @override
  String get settingsTheme => 'Temă';

  @override
  String get settingsAbout => 'Despre';

  @override
  String get settingsSystemDefault => 'Implicit sistem';

  @override
  String get settingsNotificationsTitle => 'Notificări';

  @override
  String get notifExpenseNudgeTitle => 'Înregistrează cheltuielile';

  @override
  String get notifExpenseNudgeSubtitle =>
      'Un memento zilnic seara pentru a înregistra veniturile și cheltuielile de azi';

  @override
  String get notifExpenseNudgeNotifTitle => 'Înregistrezi cheltuielile de azi?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Adaugă veniturile și cheltuielile de azi înainte să uiți.';

  @override
  String get notifBudgetThresholdTitle => 'Alerte de buget';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Anunță când bugetul unei categorii atinge 80% sau 100%';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent% din buget';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'Ai cheltuit $percent% din bugetul pentru $category luna aceasta.';
  }

  @override
  String get notifInvoiceDueTitle => 'Mementouri pentru facturi';

  @override
  String get notifInvoiceDueSubtitle =>
      'Anunță cu o zi înainte de scadența unei facturi';

  @override
  String get notifInvoiceDueNotifTitle => 'Factură scadentă mâine';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency este scadentă mâine.';
  }

  @override
  String get notifPausalReminderTitle =>
      'Memento pentru impozit forfetar (Serbia)';

  @override
  String get notifPausalReminderSubtitle =>
      'Memento lunar pe 15 pentru declararea obligațiilor cu impozit forfetar';

  @override
  String get notifPausalReminderNotifTitle =>
      'Memento pentru declarația forfetară';

  @override
  String get notifPausalReminderNotifBody =>
      'Nu uita declarația și plata lunară a impozitului forfetar.';

  @override
  String notifPausalReminderNotifBodyWithAmount(String amount) {
    return 'Nu uita declarația și plata lunară a impozitului forfetar în sumă de $amount RSD.';
  }

  @override
  String get notifPausalLeadReminderTitle =>
      'Amintește-mi și cu 3 zile înainte';

  @override
  String get notifPausalLeadReminderSubtitle =>
      'Un memento suplimentar pe 12, înaintea celui principal de pe 15';

  @override
  String get notifPausalLeadReminderNotifTitle =>
      'Declarația impozitului forfetar în 3 zile';

  @override
  String get notifPausalLeadReminderNotifBody =>
      'Declarația și plata lunară a impozitului forfetar este scadentă în 3 zile, pe 15 ale lunii.';

  @override
  String get settingsWidgetsTitle => 'Widgeturi pe ecranul de start';

  @override
  String get settingsWidgetsExplainer =>
      'Adaugă un widget de pe ecranul de start al dispozitivului (apasă lung pe un spațiu gol → Widgeturi → Salary & Currency Pro) — aplicația nu îl poate adăuga singură. După adăugare, se actualizează automat.';

  @override
  String get settingsWidgetsPinnedPairTitle =>
      'Perechea valutară fixată pentru widget';

  @override
  String get homeWidgetBudgetLabel => 'Cheltuit luna aceasta';

  @override
  String get homeWidgetBudgetEmpty =>
      'Setează un buget în aplicație ca să-l vezi aici';

  @override
  String get homeWidgetPairUnavailable =>
      'Actualizarea a eșuat — se afișează ultimul curs cunoscut';

  @override
  String get settingsBusinessProfileTitle => 'Profil de afaceri';

  @override
  String get settingsBusinessProfileExplainer =>
      'Utilizat pe facturile PDF generate și, pentru facturile eligibile în RSD, pe codul QR NBS IPS de plată.';

  @override
  String get businessProfileNameLabel => 'Nume firmă / emitent';

  @override
  String get businessProfileAddressLabel => 'Adresă';

  @override
  String get businessProfileCityLabel => 'Oraș';

  @override
  String get businessProfileBankAccountLabel => 'Număr de cont bancar (Serbia)';

  @override
  String get businessProfileBankAccountHelper =>
      'Necesar doar pentru codul QR NBS IPS pe facturile în RSD';

  @override
  String get businessProfilePaymentCodeLabel =>
      'Cod de plată implicit (Serbia)';

  @override
  String get businessProfilePaymentCodeHelper =>
      'Cod NBS de plată din 3 cifre, ex. 289 — necesar doar pentru codul QR';

  @override
  String get countryRs => 'Serbia';

  @override
  String get countryHr => 'Croația';

  @override
  String get countryBa => 'Bosnia și Herțegovina';

  @override
  String get countryMe => 'Muntenegru';

  @override
  String get countryMk => 'Macedonia de Nord';

  @override
  String get countrySi => 'Slovenia';

  @override
  String get countryBg => 'Bulgaria';

  @override
  String get countryAl => 'Albania';

  @override
  String get countryRo => 'România';

  @override
  String get entityFbih => 'Federația Bosniei și Herțegovinei';

  @override
  String get entityRepublikaSrpska => 'Republika Srpska';

  @override
  String get contribPio => 'PIO (pensie și invaliditate)';

  @override
  String get contribHealth => 'Asigurare de sănătate';

  @override
  String get contribUnemployment => 'Asigurare de șomaj';

  @override
  String get contribPension => 'Asigurare de pensie';

  @override
  String get contribSocial => 'Asigurare socială';

  @override
  String get contribChildProtection => 'Contribuție pentru protecția copilului';

  @override
  String get contribHealthAndEmployment =>
      'Asigurare de sănătate și de angajare';

  @override
  String get contribCas => 'CAS (asigurare de pensie)';

  @override
  String get contribCass => 'CASS (asigurare de sănătate)';

  @override
  String get contribCam => 'CAM (asigurare de muncă)';

  @override
  String get suffixEmployee => 'angajat';

  @override
  String get suffixEmployer => 'angajator';

  @override
  String get toolsLoanSubtitle => 'Rată lunară, timp de rambursare, amortizare';

  @override
  String get toolsSavingsSubtitle => 'Dobândă compusă cu contribuții recurente';

  @override
  String get toolsVatSubtitle => 'Adaugă sau elimină TVA la rata țării tale';

  @override
  String get toolsBudgetSubtitle =>
      'Împarte venitul lunar în nevoi / dorințe / economii';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Factură externă → taxe → plată locală reală';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Impozit și contribuții pentru liber-profesioniști, 9 țări';

  @override
  String get loanScreenTitle => 'Împrumuturi și datorii';

  @override
  String get loanModePayment => 'Rată din termen';

  @override
  String get loanModePayoff => 'Termen din rată';

  @override
  String get loanPrincipal => 'Suma împrumutului (principal)';

  @override
  String get loanRate => 'Rata anuală a dobânzii (%)';

  @override
  String get loanTermMonths => 'Termenul împrumutului (luni)';

  @override
  String get loanFixedPayment => 'Rată lunară fixă';

  @override
  String get loanErrorPrincipalRate =>
      'Introduceți un principal și o rată a dobânzii valide.';

  @override
  String get loanErrorTerm => 'Introduceți un termen valid în luni.';

  @override
  String get loanErrorPayment => 'Introduceți o rată lunară validă.';

  @override
  String get loanErrorTooLow =>
      'Această rată este prea mică pentru a rambursa vreodată soldul — nu acoperă nici măcar dobânda care se acumulează în fiecare lună.';

  @override
  String get loanMonthlyPayment => 'Rată lunară';

  @override
  String get loanTotalPaid => 'Total plătit';

  @override
  String get loanTotalInterest => 'Dobândă totală';

  @override
  String get loanNumberOfPayments => 'Numărul de rate';

  @override
  String get loanTimeToPayOff => 'Timp până la rambursare';

  @override
  String loanMonthsCount(int months) {
    return '$months luni';
  }

  @override
  String get savingsScreenTitle => 'Economii și creștere';

  @override
  String get savingsStartingAmount => 'Suma inițială';

  @override
  String get savingsMonthlyContribution => 'Contribuție lunară';

  @override
  String get savingsExpectedReturn => 'Randament anual așteptat (%)';

  @override
  String get savingsTimeHorizon => 'Orizont de timp (ani)';

  @override
  String get savingsErrorRateYears =>
      'Introduceți o rată anuală și un număr de ani valide.';

  @override
  String get savingsFutureValue => 'Valoare viitoare';

  @override
  String get savingsTotalContributed => 'Total contribuit';

  @override
  String get savingsInterestEarned => 'Dobândă câștigată';

  @override
  String get vatScreenTitle => 'Calculator TVA';

  @override
  String get vatStandardRateFor => 'Rata standard pentru';

  @override
  String get vatAdd => 'Adaugă TVA';

  @override
  String get vatRemove => 'Elimină TVA';

  @override
  String get vatNetAmount => 'Sumă netă (fără TVA)';

  @override
  String get vatGrossAmount => 'Sumă brută (cu TVA)';

  @override
  String get vatRateEditable => 'Rata TVA (%) — editabilă pentru rate reduse';

  @override
  String get vatGrossWithVat => 'Brut (cu TVA)';

  @override
  String get vatAmountLabel => 'Suma TVA';

  @override
  String get vatNetWithoutVat => 'Net (fără TVA)';

  @override
  String vatRatesAsOf(String date) {
    return 'Cotă standard valabilă din $date';
  }

  @override
  String get budgetScreenTitle => 'Planificator de buget';

  @override
  String get budgetMonthlyIncome => 'Venit net lunar';

  @override
  String get budgetSplit => 'Împărțire';

  @override
  String get budgetPresetSuffix => '(nevoi/dorințe/economii)';

  @override
  String get budgetNeeds => 'Nevoi';

  @override
  String get budgetWants => 'Dorințe';

  @override
  String get budgetSavings => 'Economii';

  @override
  String get freelancerScreenTitle =>
      'Verificarea plății reale a freelancerului';

  @override
  String get freelancerInvoiceAmount => 'Suma facturii';

  @override
  String get freelancerCurrency => 'Valută';

  @override
  String get freelancerPlatform => 'Platformă';

  @override
  String get freelancerPlatformCustom => 'Personalizat';

  @override
  String get freelancerPlatformDirect => 'Client direct / transfer (0%)';

  @override
  String get freelancerPlatformFee => 'Comision platformă (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Comision bancar (fix, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Comision bancar (%)';

  @override
  String get freelancerPayoutCurrency => 'Valuta plății';

  @override
  String get freelancerCalculateButton => 'Calculează plata reală';

  @override
  String get freelancerErrorInvoice => 'Introduceți o sumă de factură validă.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Eroare neașteptată: $error';
  }

  @override
  String get freelancerRealPayout => 'Plată reală';

  @override
  String get freelancerInvoiceAmountRow => 'Suma facturii';

  @override
  String get freelancerPlatformFeeRow => 'Comision platformă';

  @override
  String get freelancerBankFeeRow => 'Comision bancar';

  @override
  String get freelancerNetForeignAmount => 'Sumă netă în valută străină';

  @override
  String get samoFixedModel => 'Model cu cheltuială fixă';

  @override
  String get samoMixedModel => 'Model cu cheltuială mixtă';

  @override
  String get samoCheaperSame =>
      'Acest model este opțiunea mai ieftină pentru această sumă.';

  @override
  String get samoCheaperOther =>
      'Celălalt model ar produce un impozit mai mic pentru această sumă — puteți schimba liber modelele în fiecare trimestru.';

  @override
  String get freelanceTaxScreenTitle =>
      'Autoimpunere pentru liber-profesioniști';

  @override
  String get freelanceTaxCountryLabel => 'Țară / regim';

  @override
  String get freelanceTaxIncomeLabelQuarterly => 'Venit brut trimestrial';

  @override
  String get freelanceTaxIncomeLabelAnnual => 'Venit brut anual';

  @override
  String get freelanceTaxNetIncome => 'Venit net';

  @override
  String get freelanceTaxGrossIncomeRow => 'Venit brut';

  @override
  String get freelanceTaxDeductionRow => 'Deducere';

  @override
  String get freelanceTaxTaxableBaseRow => 'Baza impozabilă';

  @override
  String get freelanceTaxIncomeTaxRow => 'Impozit pe venit';

  @override
  String get freelanceTaxContributionsTotalRow => 'Total contribuții';

  @override
  String freelanceTaxRulesVersionBundle(String date) {
    return 'Cote incluse în aplicație · versiunea $date';
  }

  @override
  String freelanceTaxRulesVersionUpdated(String date) {
    return 'Cote actualizate online · versiunea $date';
  }

  @override
  String freelanceTaxSourcesLabel(String sources) {
    return 'Surse: $sources';
  }

  @override
  String get freelanceTaxNotAvailable => 'Indisponibil';

  @override
  String get freelanceTaxModelLabel => 'Model';

  @override
  String get freelanceTaxVariantLabel => 'Tip';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Categoria de activitate';

  @override
  String get freelanceFbihCategoryFreeProfessions => 'Profesii liberale';

  @override
  String get freelanceFbihCategoryObrt => 'Activitate meșteșugărească (obrt)';

  @override
  String get freelanceFbihCategoryAgriculture => 'Agricultură / silvicultură';

  @override
  String get freelanceFbihCategoryLumpSumObrt => 'Meșteșug cu impozit forfetar';

  @override
  String get freelanceFbihCategoryTraditionalCraftsTaxi =>
      'Meșteșuguri tradiționale / taxi';

  @override
  String get freelanceTaxCategoryLabel => 'Categorie';

  @override
  String get freelanceBaRsCategoryStandard => 'Antreprenor standard';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Profesii independente';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Activitate suplimentară / pensionar';

  @override
  String get freelanceTaxMunicipalityLabel => 'Municipalitate';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Podgorica / Cetinje';

  @override
  String get freelanceMeMunicipalityBudva => 'Budva';

  @override
  String get freelanceMeMunicipalityOther => 'Altă municipalitate';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'Prag de înregistrare TVA: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return 'Impozitul de 0% pe venit se aplică doar până la o cifră de afaceri de $amount $currency — peste acest prag, întregul profit este impozitat progresiv, nu doar diferența.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Deducerea de 80% cheltuieli normate se aplică doar până la un venit de $amount $currency.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Eligibilitatea pentru popoldanski s.p. încetează la un venit de $amount $currency.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'Statutul alternativ de antreprenor cu normă forfetară este plafonat la $amount $currency — doar informativ, nemodelat de acest calculator.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Încă neatins';

  @override
  String get freelanceCliffStatusCrossed => 'Depășit';

  @override
  String get freelanceRsInsuredElsewhereLabel =>
      'Deja asigurat pe alt temei (contribuția de sănătate nu se aplică)';

  @override
  String freelanceRsMinPioBaseBinds(String amount) {
    return 'Contribuția de pensie (PIO) la Modelul B este plafonată la baza minimă ($amount) — acesta este cazul pe care oamenii îl estimează greșit cel mai des.';
  }

  @override
  String get freelanceComparatorTitle => 'Compară Modelul A cu Modelul B';

  @override
  String get freelanceComparatorQuarterLabel => 'Trimestru';

  @override
  String freelanceComparatorDeadlineHint(String date) {
    return 'Termen de depunere pentru acest trimestru: $date';
  }

  @override
  String get freelanceComparatorNeedsIncome =>
      'Introduceți venitul de mai sus pentru a compara ambele modele.';

  @override
  String freelanceComparatorRecommended(String model, String amount) {
    return 'Recomandare: $model — economie de $amount la venitul net.';
  }

  @override
  String get settingsProActive => 'Pro — activ';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Reclamele sunt dezactivate în toată aplicația';

  @override
  String get settingsProSubtitleInactive =>
      'Elimină reclamele cu un abonament accesibil';

  @override
  String get settingsTrustTitle =>
      'De ce să ai încredere în această aplicație?';

  @override
  String get settingsTrustBody =>
      'Cifrele privind salariile, TVA și autoimpozitarea provin din surse guvernamentale și de consultanță fiscală citate, nu din estimări. Fiecare calculator arată anul pentru care sunt valabile cifrele și data la care au intrat în vigoare, astfel încât să poți evalua rapid actualitatea lor. Vezi „Confidențialitate și date” și „Funcționează complet offline” mai jos pentru modul în care sunt gestionate datele tale.';

  @override
  String get settingsAdPrivacyTitle =>
      'Confidențialitate și preferințe pentru reclame';

  @override
  String get settingsAdPrivacySubtitle =>
      'Revizuiește sau schimbă alegerile tale privind consimțământul pentru reclame';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Opțiunile de confidențialitate pentru reclame nu sunt disponibile pe această platformă.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'Pentru regiunea ta nu este necesară o alegere privind confidențialitatea reclamelor.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro acoperă calculul salariilor, conversia valutară și calculatoare financiare zilnice pentru Serbia, Croația, Bosnia și Herțegovina, Muntenegru, Macedonia de Nord, Slovenia, Bulgaria, Albania și România. Toate cifrele sunt cu sursă și dată — vezi avertismentul fiecărui calculator pentru detalii. Această aplicație oferă doar estimări, nu consultanță profesională.';

  @override
  String get paywallTitle => 'Devino Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Elimină toate reclamele din fiecare calculator, la un preț lunar accesibil. Toate țările pentru calculul salariilor, conversia valutară și instrumentele financiare rămân gratuite oricum.';

  @override
  String get paywallActiveMessage =>
      'Ești utilizator Pro — mulțumim! Reclamele sunt dezactivate în toată aplicația.';

  @override
  String get paywallStoreUnavailable =>
      'Magazinul nu este disponibil momentan (acest lucru este așteptat în versiunile de dezvoltare fără o listare Play Console configurată). Pro va putea fi cumpărat după publicare.';

  @override
  String get paywallProductUnavailable =>
      'Abonamentul Pro nu este încă configurat în magazin — acesta este un ecran temporar până când produsul real este creat în Play Console.';

  @override
  String get paywallSubscribe => 'Abonează-te';

  @override
  String get paywallProcessing => 'Se procesează…';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Achiziția a eșuat: $error';
  }

  @override
  String get paywallRestorePurchase => 'Restabilește achiziția';

  @override
  String get chartTakeHome => 'Sumă netă';

  @override
  String get chartTax => 'Impozit';

  @override
  String get chartContributions => 'Contribuții';

  @override
  String get homeRecentlyUsed => 'Folosite recent';

  @override
  String get categoryLoansSavings => 'Împrumuturi și economii';

  @override
  String get categoryBudgetTax => 'Buget și taxe';

  @override
  String get categoryFreelance => 'Freelancing';

  @override
  String get toolsSearchHint => 'Caută instrumente';

  @override
  String get toolsSearchNoResults => 'Nu s-au găsit instrumente';

  @override
  String get homeLastSalaryTitle => 'Ultimul calcul salarial';

  @override
  String get homeLastSalaryEmpty => 'Încă nu ai calculat salariul.';

  @override
  String get homeLastSalaryCta => 'Calculează acum';

  @override
  String get settingsPrivacyTitle => 'Confidențialitate și date';

  @override
  String get settingsPrivacyNote =>
      'Istoricul calculelor este stocat doar pe acest dispozitiv și nu este niciodată încărcat sau partajat. Ștergerea lui sau dezinstalarea aplicației îl elimină definitiv.';

  @override
  String get settingsClearHistory => 'Șterge istoricul';

  @override
  String get settingsClearHistorySubtitle =>
      'Elimină toate calculele recente din Acasă și Instrumente';

  @override
  String get settingsClearHistoryDialogTitle => 'Ștergi istoricul?';

  @override
  String get settingsClearHistoryDialogBody =>
      'Aceasta elimină toată activitatea recentă din Acasă și Instrumente. Acțiunea nu poate fi anulată.';

  @override
  String get settingsClearHistoryDialogCancel => 'Anulează';

  @override
  String get settingsClearHistoryDialogConfirm => 'Șterge';

  @override
  String get settingsClearHistoryDone => 'Istoricul a fost șters';

  @override
  String get commonCancel => 'Anulează';

  @override
  String get commonSave => 'Salvează';

  @override
  String get commonDelete => 'Șterge';

  @override
  String get commonRename => 'Redenumește';

  @override
  String get commonUndo => 'Anulează';

  @override
  String get scenarioSaveTooltip => 'Salvează acest calcul';

  @override
  String get scenarioSaveDialogTitle => 'Salvează calculul';

  @override
  String get scenarioNameLabel => 'Nume';

  @override
  String get scenarioSavedConfirmation => 'Scenariul a fost salvat';

  @override
  String get scenarioLimitTitle => 'Limită gratuită atinsă';

  @override
  String scenarioLimitBody(int limit) {
    return 'Conturile gratuite pot salva până la $limit scenarii. Treci la Pro pentru salvare, comparare și export nelimitate.';
  }

  @override
  String get scenarioLimitUpgrade => 'Treci la Pro';

  @override
  String get myScenariosTitle => 'Scenariile mele';

  @override
  String myScenariosSubtitle(int count) {
    return '$count salvate';
  }

  @override
  String get myScenariosSubtitleEmpty => 'Niciun scenariu salvat';

  @override
  String get myScenariosEmptyState =>
      'Salvează un calcul din orice instrument pentru a-l vedea aici.';

  @override
  String get scenarioRenameDialogTitle => 'Redenumește scenariul';

  @override
  String get scenarioDeleteDialogTitle => 'Ștergi scenariul?';

  @override
  String get scenarioDeleteDialogBody => 'Această acțiune nu poate fi anulată.';

  @override
  String get categoryTracking => 'Urmărire și planificare';

  @override
  String get toolsExpenseTrackerTitle => 'Urmărire cheltuieli';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Înregistrează venituri și cheltuieli, urmărește soldul lunar';

  @override
  String get expenseScreenTitle => 'Urmărire cheltuieli';

  @override
  String get expenseIncome => 'Venituri';

  @override
  String get expenseExpenses => 'Cheltuieli';

  @override
  String get expenseBalance => 'Sold';

  @override
  String get expenseEmptyState =>
      'Nicio tranzacție încă luna aceasta. Atinge + pentru a adăuga primul venit sau cheltuială.';

  @override
  String get expenseAddIncome => 'Adaugă venit';

  @override
  String get expenseAddExpense => 'Adaugă cheltuială';

  @override
  String get expenseAmount => 'Sumă';

  @override
  String get expenseCategory => 'Categorie';

  @override
  String get expenseNote => 'Notă (opțional)';

  @override
  String get expenseDate => 'Dată';

  @override
  String get expenseDeleteConfirmTitle => 'Ștergi această tranzacție?';

  @override
  String get expenseDeleteConfirmBody =>
      'Vei avea o scurtă șansă să anulezi imediat după aceea.';

  @override
  String get expenseDeletedConfirmation => 'Tranzacția a fost ștearsă';

  @override
  String get expenseEditTransaction => 'Editează tranzacția';

  @override
  String get expenseSearchHint => 'Caută în note sau categorii';

  @override
  String get expenseFilterAll => 'Toate';

  @override
  String get expenseSortByDate => 'Sortează după dată';

  @override
  String get expenseSortByAmount => 'Sortează după sumă';

  @override
  String get expenseNoResults => 'Nicio tranzacție nu corespunde căutării.';

  @override
  String expenseResultCount(int shown, int total) {
    return '$shown din $total';
  }

  @override
  String get expenseSpendingByCategory => 'Cheltuieli pe categorii';

  @override
  String get toolsRecurringTitle => 'Tranzacții recurente';

  @override
  String get toolsRecurringSubtitle =>
      'Chirie, abonamente și alte plăți regulate — definește o singură dată';

  @override
  String get recurringScreenTitle => 'Tranzacții recurente';

  @override
  String get recurringEmptyState =>
      'Nu există încă tranzacții recurente. Adaugă chiria, abonamentele sau alte plăți regulate o singură dată — se vor înregistra automat sau vor aștepta confirmarea ta, la alegere.';

  @override
  String get recurringAddTitle => 'Tranzacție recurentă nouă';

  @override
  String get recurringEditTitle => 'Editează tranzacția recurentă';

  @override
  String get recurringFrequencyLabel => 'Se repetă';

  @override
  String get recurringFrequencyWeekly => 'Săptămânal';

  @override
  String get recurringFrequencyMonthly => 'Lunar';

  @override
  String get recurringStartDateLabel => 'Începe';

  @override
  String get recurringAutoPostLabel => 'Înregistrare automată';

  @override
  String get recurringAutoPostSubtitle =>
      'Dezactivat: confirmă fiecare apariție înainte de a fi adăugată';

  @override
  String get recurringPausedLabel => 'În pauză';

  @override
  String get recurringPauseAction => 'Pauzează';

  @override
  String get recurringResumeAction => 'Reia';

  @override
  String get recurringDeleteConfirmTitle =>
      'Ștergi această tranzacție recurentă?';

  @override
  String get recurringDeleteConfirmBody =>
      'Aceasta oprește aparițiile viitoare. Tranzacțiile deja înregistrate nu sunt afectate.';

  @override
  String recurringReviewBannerTitle(int count) {
    return '$count tranzacții recurente de confirmat';
  }

  @override
  String get recurringReviewPost => 'Înregistrează';

  @override
  String get recurringReviewSkip => 'Omite';

  @override
  String get toolsRadarTitle => 'Radar costuri fixe';

  @override
  String get toolsRadarSubtitle =>
      'Vezi costurile recurente totale dintr-o privire';

  @override
  String get radarScreenTitle => 'Radar costuri fixe';

  @override
  String get radarEmptyState =>
      'Nu există încă cheltuieli recurente active. Adaugă una din Tranzacții recurente pentru a vedea aici costul fix total.';

  @override
  String get radarMonthlyTotal => 'Total lunar';

  @override
  String get radarWeeklyTotal => 'Total săptămânal';

  @override
  String radarNextDue(String date) {
    return 'Următoarea: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Bugete și obiective';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Stabilește limite lunare de cheltuieli și urmărește obiectivele de economisire';

  @override
  String get budgetsScreenTitle => 'Bugete și obiective';

  @override
  String get budgetsSectionCategoryBudgets => 'Bugete pe categorii';

  @override
  String get budgetsSectionGoals => 'Obiective de economisire';

  @override
  String get budgetsNoLimitSet => 'Nicio limită setată';

  @override
  String get budgetsSetLimit => 'Setează limita';

  @override
  String get budgetsEditLimit => 'Editează limita';

  @override
  String get budgetsMonthlyLimit => 'Limită lunară';

  @override
  String get budgetsOverBudget => 'Buget depășit';

  @override
  String get budgetsNoBudgetsHint =>
      'Setează o limită lunară pentru orice categorie de mai jos pentru a urmări cheltuielile față de aceasta.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Elimini această limită?';

  @override
  String get budgetsDeleteLimitConfirmBody => 'Poți seta una nouă oricând.';

  @override
  String get budgetsAddGoal => 'Adaugă obiectiv';

  @override
  String get budgetsGoalName => 'Numele obiectivului';

  @override
  String get budgetsTargetAmount => 'Suma țintă';

  @override
  String get budgetsTargetDateOptional => 'Data țintă (opțional)';

  @override
  String get budgetsNoTargetDate => 'Fără dată țintă';

  @override
  String get budgetsAddProgress => 'Adaugă progres';

  @override
  String get budgetsProgressAmountLabel => 'Sumă de adăugat';

  @override
  String get budgetsGoalComplete => 'Obiectiv atins!';

  @override
  String get budgetsNoGoalsYet =>
      'Niciun obiectiv de economisire încă. Adaugă unul pentru a începe să urmărești progresul către ceva concret.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Ștergi acest obiectiv?';

  @override
  String get budgetsDeleteGoalConfirmBody =>
      'Această acțiune nu poate fi anulată.';

  @override
  String get budgetsProgressExplanation =>
      'Progresul se actualizează doar când îl adaugi manual aici — această aplicație nu are conexiune bancară, deci nimic nu este urmărit automat.';

  @override
  String get expenseInsightsTitle => 'Perspective';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Cheltuielile sunt cu $percent% mai mari decât luna trecută ($current față de $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Cheltuielile sunt cu $percent% mai mici decât luna trecută ($current față de $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Cheltuielile sunt similare cu luna trecută ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category este cea mai mare categorie de cheltuieli luna aceasta, cu $percent% din cheltuielile totale.';
  }

  @override
  String get expenseInsightHowCalculated => 'Vezi calculul';

  @override
  String expenseInsightCounter(int current, int total) {
    return '$current din $total';
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
  String get expenseExportCsv => 'Exportă CSV';

  @override
  String get expenseExportCopied =>
      'CSV copiat în clipboard — lipește-l într-un tabel sau notițe';

  @override
  String get expenseExportEmpty => 'Nicio tranzacție luna aceasta de exportat';

  @override
  String get settingsDataManagementTitle => 'Gestionarea datelor';

  @override
  String get settingsExportAllData => 'Exportă toate datele (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Copiază tranzacțiile, scenariile, bugetele și obiectivele în clipboard';

  @override
  String get settingsExportAllDataEmpty => 'Nu există încă date de exportat';

  @override
  String get settingsExportAllDataDone =>
      'Toate datele au fost copiate în clipboard';

  @override
  String get settingsDeleteAllData => 'Șterge toate datele locale';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Șterge definitiv tranzacțiile, scenariile, bugetele și obiectivele de pe acest dispozitiv';

  @override
  String get settingsDeleteAllDataDialog1Title => 'Ștergi toate datele locale?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'Aceasta elimină definitiv fiecare tranzacție, scenariu salvat, buget pe categorie și obiectiv de economisire stocate pe acest dispozitiv. Această acțiune nu poate fi anulată. Istoricul tău de calcule va fi de asemenea șters.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Ești absolut sigur?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'Aceasta este ultima ta șansă de a anula. Nu există nicio modalitate de a recupera aceste date ulterior.';

  @override
  String get settingsDeleteAllDataConfirm => 'Șterge tot';

  @override
  String get settingsDeleteAllDataDone => 'Toate datele locale au fost șterse';

  @override
  String get settingsOfflineStatusTitle => 'Funcționează complet offline';

  @override
  String get settingsOfflineStatusBody =>
      'Această aplicație nu are cont, sincronizare în cloud sau server — tot ce introduci rămâne doar pe acest dispozitiv. Cursul de schimb valutar este singura funcție care are nevoie de o conexiune la internet; dacă ești offline, se folosește ultimul curs cunoscut.';

  @override
  String get toolsInvoicesTitle => 'Facturi';

  @override
  String get toolsInvoicesSubtitle =>
      'Urmărește ce îți datorează clienții — plătit, neplătit și restant';

  @override
  String get invoicesScreenTitle => 'Facturi';

  @override
  String get invoicesEmptyState =>
      'Nicio factură încă. Atinge + pentru a adăuga prima.';

  @override
  String get invoiceOutstanding => 'Neîncasat';

  @override
  String get invoiceOverdue => 'Restant';

  @override
  String get invoiceFilterAll => 'Toate';

  @override
  String get invoiceFilterUnpaid => 'Neplătite';

  @override
  String get invoiceFilterOverdue => 'Restante';

  @override
  String get invoiceFilterPaid => 'Plătite';

  @override
  String get invoiceStatusPaid => 'Plătit';

  @override
  String get invoiceStatusUnpaid => 'Neplătit';

  @override
  String get invoiceStatusOverdue => 'Restant';

  @override
  String get invoiceDueLabel => 'Scadență';

  @override
  String get invoiceMarkPaid => 'Marchează ca plătit';

  @override
  String get invoiceMarkUnpaid => 'Marchează ca neplătit';

  @override
  String get invoiceDeleteConfirmTitle => 'Ștergi această factură?';

  @override
  String get invoiceDeleteConfirmBody => 'Această acțiune nu poate fi anulată.';

  @override
  String get invoiceAddTitle => 'Adaugă factură';

  @override
  String get invoiceEditTitle => 'Editează factura';

  @override
  String get invoiceClientName => 'Numele clientului';

  @override
  String get invoiceDescription => 'Descriere (opțional)';

  @override
  String get invoiceAmount => 'Sumă';

  @override
  String get invoiceIssueDate => 'Data emiterii';

  @override
  String get invoiceDueDate => 'Data scadenței';

  @override
  String get invoiceNumberLabel => 'Număr factură (opțional)';

  @override
  String get invoiceAddItem => 'Adaugă articol';

  @override
  String get invoiceItemDescription => 'Descriere';

  @override
  String get invoiceItemQuantity => 'Cant.';

  @override
  String get invoiceItemUnitPrice => 'Preț unitar';

  @override
  String get invoiceItemSubtotal => 'Subtotal';

  @override
  String get invoiceAmountFromItemsHelper =>
      'Calculat din articolele de mai jos';

  @override
  String get invoiceRemoveItemTooltip => 'Elimină articolul';

  @override
  String get invoiceGeneratePdf => 'Generează PDF';

  @override
  String get invoiceGeneratingPdf => 'Se generează PDF-ul…';

  @override
  String get invoicePdfError =>
      'Generarea PDF-ului a eșuat. Factura nu s-a modificat — încercați din nou.';

  @override
  String get invoiceQrEligibleBody =>
      'Această factură va include un cod QR NBS IPS de plată.';

  @override
  String get invoiceQrIneligibleBody =>
      'Adăugați numărul de cont bancar și codul de plată în Setări → Profil de afaceri pentru a include un cod QR de plată pe această factură.';

  @override
  String get toolsPausalTrackerTitle => 'Monitor impozit forfetar (Serbia)';

  @override
  String get toolsPausalTrackerSubtitle =>
      'Urmărește cifra de afaceri față de plafonul forfetar și pragul de TVA';

  @override
  String get pausalTrackerCeilingCardTitle =>
      'Plafonul forfetar (acest an calendaristic)';

  @override
  String get pausalTrackerVatCardTitle =>
      'Pragul de înregistrare TVA (ultimele 12 luni)';

  @override
  String get pausalTrackerStateOk => 'În regulă';

  @override
  String get pausalTrackerStateWarning70 => 'Atins 70% — merită urmărit';

  @override
  String get pausalTrackerStateWarning85 =>
      'Atins 85% — acordă atenție deosebită';

  @override
  String get pausalTrackerStateWarning95 =>
      'Atins 95% — probabil va fi nevoie de acțiune în curând';

  @override
  String get pausalTrackerStateExceeded => 'Depășit';

  @override
  String pausalTrackerProjection(String date) {
    return 'În ritmul actual, ai atinge plafonul forfetar în jurul datei $date.';
  }

  @override
  String pausalTrackerExcludedBanner(int count) {
    return '$count factură(i) excluse — cursul de schimb nu este disponibil';
  }

  @override
  String get pausalTrackerSeeBreakdown => 'Vezi cifrele';

  @override
  String get pausalTrackerBreakdownTitle => 'Cum a fost calculat acest lucru';

  @override
  String get pausalTrackerBreakdownExcludedHeader =>
      'Excluse — cursul de schimb nu este disponibil';

  @override
  String pausalTrackerBreakdownRateLabel(String source) {
    return 'curs: $source';
  }

  @override
  String get pausalTrackerBreakdownExcludedReason =>
      'Pentru această factură nu s-a putut obține un curs de schimb — a fost exclusă din total în loc să fie estimată.';

  @override
  String get pausalTrackerAssessedAmountLabel =>
      'Suma lunară forfetară stabilită';

  @override
  String get pausalTrackerAssessedAmountHint =>
      'Opțional — introdu suma din decizia ta fiscală. Aplicația nu o poate calcula singură.';

  @override
  String get pausalTrackerAssessedAmountSaved => 'Salvat';

  @override
  String pausalTrackerAssessedAmountDecomposition(
    String tax,
    String pio,
    String health,
    String unemployment,
    String total,
  ) {
    return '= $tax impozit + $pio pensie + $health sănătate + $unemployment șomaj = $total din baza stabilită prin decizie.';
  }

  @override
  String get commonClearSearch => 'Șterge căutarea';

  @override
  String get expensePreviousMonth => 'Luna anterioară';

  @override
  String get expenseNextMonth => 'Luna următoare';

  @override
  String get homeExpenseTrackerTitle => 'Luna aceasta';

  @override
  String get homeExpenseTrackerCtaEmpty =>
      'Urmărește-ți veniturile și cheltuielile';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'Sunt urmărite mai multe valute — atinge pentru a le vedea pe toate';

  @override
  String get catHousing => 'Locuință și chirie';

  @override
  String get catUtilities => 'Utilități';

  @override
  String get catGroceries => 'Alimente';

  @override
  String get catTransport => 'Transport';

  @override
  String get catHealth => 'Sănătate';

  @override
  String get catEducation => 'Educație';

  @override
  String get catEntertainment => 'Divertisment';

  @override
  String get catOtherExpense => 'Altele';

  @override
  String get catSalary => 'Salariu';

  @override
  String get catFreelance => 'Freelance / afacere';

  @override
  String get catOtherIncome => 'Alte venituri';

  @override
  String get toolsCrossBorderTitle => 'Comparație transfrontalieră';

  @override
  String get toolsCrossBorderSubtitle =>
      'Compară același salariu brut în toate cele 9 țări';

  @override
  String get crossBorderGrossLabel => 'Salariu brut (EUR)';

  @override
  String get crossBorderPeriodMonthly => 'Lunar';

  @override
  String get crossBorderPeriodAnnual => 'Anual';

  @override
  String get crossBorderBaEntityLabel => 'Entitatea Bosniei și Herțegovinei';

  @override
  String get crossBorderColumnCountry => 'Țară';

  @override
  String get crossBorderColumnGross => 'Brut';

  @override
  String get crossBorderColumnDeductions => 'Deduceri angajat';

  @override
  String get crossBorderColumnNet => 'Net';

  @override
  String get crossBorderColumnEmployerCost => 'Cost angajator';

  @override
  String crossBorderColumnComparisonSuffix(String label, String currency) {
    return '$label ($currency)';
  }

  @override
  String crossBorderUnavailableNoRate(String currency) {
    return 'Nu există un curs salvat pentru $currency — convertește-l o dată în fila Conversie pentru a activa acest rând.';
  }

  @override
  String get crossBorderUnavailableConfig =>
      'Datele fiscale nu sunt disponibile pentru această țară.';

  @override
  String get crossBorderScopeNote =>
      'Această comparație acoperă doar salariul brut-net și costul angajatorului. Diurnele și kilometrajul nu sunt încă incluse — nu sunt disponibile rate oficiale verificate pentru toate țările.';

  @override
  String get crossBorderDisclaimer =>
      'Introdu un singur salariu brut în EUR. Fiecare țară îl convertește în moneda proprie folosind ultimul curs salvat, apoi îl calculează după regulile reale ale acelei țări — cifrele nu sunt niciodată comparate fără conversie valutară. Valorile anuale sunt calculul lunar × 12. Aceasta este o estimare doar pentru comparație, nu un sfat fiscal.';

  @override
  String crossBorderRateSourceLabel(String source, String date) {
    return '$source, salvat $date';
  }

  @override
  String get crossBorderSameCurrencyLabel =>
      'Deja în EUR — nu este necesară conversia';

  @override
  String get crossBorderInitialEmptyState =>
      'Introdu un salariu brut și apasă Calculează pentru a compara toate cele 9 țări.';

  @override
  String get crossBorderTapForDetail =>
      'Atinge un rând pentru detalierea completă';

  @override
  String get toolsReceiptScannerTitle => 'Scaner de bonuri fiscale';

  @override
  String get toolsReceiptScannerSubtitle =>
      'Scanează codul QR al unui bon și salvează-l local, offline';

  @override
  String get receiptScannerScreenTitle => 'Scaner de bonuri fiscale';

  @override
  String get receiptScannerStarting => 'Se pornește camera…';

  @override
  String get receiptScannerHint =>
      'Îndreaptă camera spre codul QR al bonului fiscal';

  @override
  String get receiptScannerPermissionDeniedTitle =>
      'Este necesar accesul la cameră';

  @override
  String get receiptScannerPermissionDeniedBody =>
      'Permite accesul la cameră pentru a scana codul QR al unui bon, sau introdu-l manual mai jos. Dacă ai refuzat anterior accesul, s-ar putea să fie nevoie să-l activezi din setările de sistem ale dispozitivului.';

  @override
  String get receiptScannerUnavailableTitle => 'Camera nu este disponibilă';

  @override
  String get receiptScannerUnavailableBody =>
      'Camera nu a putut fi pornită pe acest dispozitiv. Poți în continuare introduce manual codul bonului mai jos.';

  @override
  String get receiptScannerManualEntryButton => 'Introdu manual';

  @override
  String get receiptScannerManualEntryTitle =>
      'Introducere manuală a codului bonului';

  @override
  String get receiptScannerManualEntryHint =>
      'Lipește sau tastează conținutul codului QR';

  @override
  String get receiptScannerManualEntryEmptyError => 'Introdu mai întâi un text';

  @override
  String get receiptScannerManualEntrySubmit => 'Adaugă în coadă';

  @override
  String get receiptScanStatusAwaitingFetch =>
      'Scanat, în așteptarea preluării';

  @override
  String get receiptScannerResultRecognizedTitle =>
      'Bon fiscal sârbesc recunoscut';

  @override
  String receiptScannerResultRecognizedBody(String status) {
    return 'Acesta seamănă cu un cod QR de bon fiscal sârbesc după formatul local (nu este o verificare fiscală). A fost adăugat în coada ta locală ca „$status”.';
  }

  @override
  String get receiptScannerResultMalformedTitle =>
      'Nu pare un cod de bon valid';

  @override
  String get receiptScannerResultMalformedBody =>
      'Acesta seamănă cu un cod de bon fiscal sârbesc, dar nu corespunde formatului așteptat. A fost salvat pentru a-l putea revizui.';

  @override
  String get receiptScannerResultUnknownTitle => 'Bon fiscal nerecunoscut';

  @override
  String get receiptScannerResultUnknownBody =>
      'Acest cod QR nu corespunde formatului de bon fiscal al niciunei țări acceptate. A fost salvat pentru a-l putea revizui.';

  @override
  String get receiptScannerResultScanAnother => 'Scanează altul';

  @override
  String get receiptScannerResultDone => 'Gata';

  @override
  String get receiptScannerViewQueueTooltip => 'Vezi coada';

  @override
  String get toolsReceiptQueueTitle => 'Coada de bonuri';

  @override
  String get toolsReceiptQueueSubtitle =>
      'Vezi bonurile scanate și transformă-le în cheltuieli';

  @override
  String get receiptQueueScreenTitle => 'Coada de bonuri';

  @override
  String get receiptQueueEmptyState =>
      'Niciun bon scanat încă. Scanează codul QR al unui bon fiscal pentru a-l adăuga aici.';

  @override
  String get receiptQueueStatusLinked => 'Asociat unei cheltuieli';

  @override
  String get receiptQueueUnrecognizedFormat => 'Format nerecunoscut';

  @override
  String receiptQueueScannedAt(String date) {
    return 'Scanat $date';
  }

  @override
  String get receiptQueueDeleteConfirmTitle => 'Ștergi această scanare?';

  @override
  String get receiptQueueDeleteConfirmBody =>
      'Aceasta elimină bonul scanat din coada ta locală.';

  @override
  String get receiptQueueDeletedConfirmation => 'Scanare ștearsă';

  @override
  String get receiptHandoffTitle => 'Creează o cheltuială din scanare';

  @override
  String receiptHandoffFromScanNote(String date) {
    return 'Dintr-un bon scanat pe $date';
  }
}
