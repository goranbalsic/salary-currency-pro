// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Domov';

  @override
  String get navConvert => 'Pretvorba';

  @override
  String get navSalary => 'Plača';

  @override
  String get navTools => 'Orodja';

  @override
  String get navSettings => 'Nastavitve';

  @override
  String themeToggleTooltip(String mode) {
    return 'Preklopi temo ($mode)';
  }

  @override
  String get themeModeSystem => 'sistemska';

  @override
  String get themeModeLight => 'svetla';

  @override
  String get themeModeDark => 'temna';

  @override
  String get onboardingSkip => 'Preskoči';

  @override
  String get onboardingContinue => 'Naprej';

  @override
  String get onboardingGetStarted => 'Začni';

  @override
  String get onboardingWelcomeTitle => 'Dobrodošli';

  @override
  String get onboardingWelcomeSubtitle =>
      'Izberite državo in jezik za začetek. To lahko kadar koli spremenite v Nastavitvah.';

  @override
  String get onboardingCountryLabel => 'Država';

  @override
  String get onboardingPrivacyTitle => 'Vaši podatki ostanejo na telefonu';

  @override
  String get onboardingPrivacyBody =>
      'Brez računa. Brez sinhronizacije v oblaku. Brez strežnika. Vse, kar vnesete — plače, stroške, račune — ostane samo na tej napravi. Menjava valut je edina funkcija, ki potrebuje internetno povezavo; brez nje se uporabi zadnji znani tečaj.';

  @override
  String get onboardingGoalTitle => 'Kaj vas je pripeljalo sem?';

  @override
  String get onboardingGoalSubtitle =>
      'Domači zaslon bomo prilagodili temu — vse ostalo ostane en dotik stran.';

  @override
  String get onboardingGoalSalaryTitle => 'Plača in obračun zaslužka';

  @override
  String get onboardingGoalSalaryDesc =>
      'Izračunajte neto iz bruto plače za 9 držav';

  @override
  String get onboardingGoalExpensesTitle => 'Sledenje prihodkom in stroškom';

  @override
  String get onboardingGoalExpensesDesc =>
      'Beležite stroške, določite proračune, dosezite prihranke';

  @override
  String get onboardingGoalBusinessTitle => 'Samostojno delo in posel';

  @override
  String get onboardingGoalBusinessDesc =>
      'Računi, izplačila in poslovna orodja';

  @override
  String get commonCalculate => 'Izračunaj';

  @override
  String get commonConvert => 'Pretvori';

  @override
  String get commonRetry => 'Poskusi znova';

  @override
  String get commonSwapCurrencies => 'Zamenjaj valuti';

  @override
  String get commonSomethingWentWrong => 'Nekaj je šlo narobe.';

  @override
  String get commonFrom => 'Iz';

  @override
  String get commonTo => 'V';

  @override
  String get commonAmount => 'Znesek';

  @override
  String get convertCardTitle => 'Pretvorba';

  @override
  String get convertEmptyState =>
      'Vnesite znesek in pritisnite Pretvori za pravi, trenutni tečaj.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Trenutni tečaj iz $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Shranjeni tečaj od $formatted (brez povezave) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Vnesite znesek.';

  @override
  String get convertAmountIssueInvalid => 'To ni videti kot veljavno število.';

  @override
  String get convertAmountIssueNegative => 'Znesek ne more biti negativen.';

  @override
  String get convertAmountIssueZero => 'Znesek mora biti večji od nič.';

  @override
  String get convertAmountIssueTooLarge =>
      'To se zdi nenavadno veliko za znesek — preverite, ali ni tipkarska napaka.';

  @override
  String salaryTitle(String country) {
    return 'Kalkulator plače — $country';
  }

  @override
  String salaryParamsLine(int year, String date) {
    return 'Parametri za leto $year · velja od $date';
  }

  @override
  String get salaryModeGrossToNet => 'Bruto → Neto';

  @override
  String get salaryModeNetToGross => 'Neto → Bruto';

  @override
  String salaryGrossLabel(String currencyCode) {
    return 'Bruto plača, $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Neto plača, $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Vnesite plačo in pritisnite Izračunaj za popoln obračun.';

  @override
  String get salaryNeto => 'Neto (izplačilo)';

  @override
  String get salaryBruto => 'Bruto (plača)';

  @override
  String get salaryAllowance => 'Splošna olajšava';

  @override
  String get salaryTaxableBase => 'Davčna osnova';

  @override
  String get salaryIncomeTax => 'Dohodnina';

  @override
  String get salaryLocalSurtax => 'Lokalni pribitek';

  @override
  String get salaryEmployeeContribTotal => 'Prispevki delojemalca (skupaj)';

  @override
  String get salaryEmployerContribTotal => 'Prispevki delodajalca (skupaj)';

  @override
  String get salaryBruto2 => 'Bruto 2 (skupni strošek delodajalca)';

  @override
  String salarySurtaxLabel(String rate) {
    return 'Lokalni pribitek: $rate % — nastavite na stopnjo vaše občine';
  }

  @override
  String get salaryDisclaimer =>
      'To je ocena zgolj v informativne namene in ne predstavlja davčnega, pravnega ali finančnega nasveta. Dejanske obveznosti se lahko razlikujejo glede na vaše konkretne okoliščine — pred odločitvami se posvetujte s pooblaščenim računovodjo ali pristojnim davčnim organom.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Ta bruto znesek je pod zakonsko določeno najnižjo osnovo za prispevke ($base). Obvezni prispevki sami dosežejo ali presežejo to plačo, zato je znesek izplačila nič ali negativen — te ravni plače ni praktično uradno prijaviti.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'Pri tej ravni dohodka obvezni prispevki in davek skupaj dosežejo ali presežejo bruto plačo, zato je znesek izplačila nič ali negativen.';

  @override
  String salaryConfigError(String country) {
    return 'Davčne konfiguracije za $country ni bilo mogoče naložiti.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Vnesite plačo.';

  @override
  String get salaryAmountIssueInvalid => 'To ni videti kot veljavno število.';

  @override
  String get salaryAmountIssueNegative => 'Plača ne more biti negativna.';

  @override
  String get salaryAmountIssueZero => 'Plača mora biti večja od nič.';

  @override
  String get salaryAmountIssueTooLarge =>
      'To se zdi nenavadno veliko za plačo — preverite, ali ni tipkarska napaka.';

  @override
  String get toolsHubTitle => 'Finančna orodja';

  @override
  String get toolsLoanTitle => 'Posojila in dolgovi';

  @override
  String get toolsSavingsTitle => 'Varčevanje in rast';

  @override
  String get toolsVatTitle => 'Kalkulator DDV';

  @override
  String get toolsBudgetTitle => 'Načrtovalnik proračuna';

  @override
  String get toolsFreelancerPayoutTitle => 'Izplačilo freelancerja';

  @override
  String get toolsFreelanceTaxTitle => 'Samoobdavčitev samozaposlenih';

  @override
  String get homeQuoteOfDay => 'Citat dneva';

  @override
  String get homeQuickActions => 'Hitra dejanja';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsAbout => 'O aplikaciji';

  @override
  String get settingsSystemDefault => 'Privzeto sistemsko';

  @override
  String get settingsNotificationsTitle => 'Obvestila';

  @override
  String get notifExpenseNudgeTitle => 'Beleži porabo';

  @override
  String get notifExpenseNudgeSubtitle =>
      'Dnevni večerni opomnik za vnos današnjih prihodkov in odhodkov';

  @override
  String get notifExpenseNudgeNotifTitle => 'Vnesete današnjo porabo?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Dodajte današnje prihodke in odhodke, preden pozabite.';

  @override
  String get notifBudgetThresholdTitle => 'Opozorila o proračunu';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Obvesti, ko proračun kategorije doseže 80 % ali 100 %';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent % proračuna';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'Porabili ste $percent % proračuna za $category ta mesec.';
  }

  @override
  String get notifInvoiceDueTitle => 'Opomniki za račune';

  @override
  String get notifInvoiceDueSubtitle => 'Obvesti dan pred zapadlostjo računa';

  @override
  String get notifInvoiceDueNotifTitle => 'Račun zapade jutri';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency zapade jutri.';
  }

  @override
  String get notifPausalReminderTitle => 'Opomnik za pavšal (Srbija)';

  @override
  String get notifPausalReminderSubtitle =>
      'Mesečni opomnik 15. za oddajo pavšalne prijave';

  @override
  String get notifPausalReminderNotifTitle => 'Opomnik za oddajo pavšala';

  @override
  String get notifPausalReminderNotifBody =>
      'Ne pozabite na mesečno prijavo in plačilo pavšala.';

  @override
  String notifPausalReminderNotifBodyWithAmount(String amount) {
    return 'Ne pozabite na mesečno prijavo in plačilo pavšala v znesku $amount RSD.';
  }

  @override
  String get notifPausalLeadReminderTitle => 'Opomni me tudi 3 dni prej';

  @override
  String get notifPausalLeadReminderSubtitle =>
      'Dodaten opomnik 12., pred glavnim 15.';

  @override
  String get notifPausalLeadReminderNotifTitle => 'Prijava pavšala čez 3 dni';

  @override
  String get notifPausalLeadReminderNotifBody =>
      'Mesečna prijava in plačilo pavšala zapade čez 3 dni, 15. v mesecu.';

  @override
  String get settingsWidgetsTitle => 'Pripomočki na začetnem zaslonu';

  @override
  String get settingsWidgetsExplainer =>
      'Dodajte pripomoček z začetnega zaslona naprave (dolgo pritisnite prazen prostor → Pripomočki → Salary & Currency Pro) — aplikacija ga ne more dodati namesto vas. Po dodajanju se posodablja samodejno.';

  @override
  String get settingsWidgetsPinnedPairTitle =>
      'Pripeti valutni par za pripomoček';

  @override
  String get homeWidgetBudgetLabel => 'Porabljeno ta mesec';

  @override
  String get homeWidgetBudgetEmpty =>
      'Nastavite proračun v aplikaciji, da ga vidite tukaj';

  @override
  String get homeWidgetPairUnavailable =>
      'Osvežitev ni uspela — prikazan je zadnji znani tečaj';

  @override
  String get settingsBusinessProfileTitle => 'Poslovni profil';

  @override
  String get settingsBusinessProfileExplainer =>
      'Uporablja se na ustvarjenih PDF računih in, za upravičene račune v RSD, na kodi NBS IPS QR za plačilo.';

  @override
  String get businessProfileNameLabel => 'Naziv podjetja / izdajatelja';

  @override
  String get businessProfileAddressLabel => 'Naslov';

  @override
  String get businessProfileCityLabel => 'Kraj';

  @override
  String get businessProfileBankAccountLabel => 'Številka računa (Srbija)';

  @override
  String get businessProfileBankAccountHelper =>
      'Potrebno samo za kodo NBS IPS QR na računih v RSD';

  @override
  String get businessProfilePaymentCodeLabel =>
      'Privzeta plačilna šifra (Srbija)';

  @override
  String get businessProfilePaymentCodeHelper =>
      'Trimestna NBS plačilna šifra, npr. 289 — potrebna samo za kodo QR';

  @override
  String get countryRs => 'Srbija';

  @override
  String get countryHr => 'Hrvaška';

  @override
  String get countryBa => 'Bosna in Hercegovina';

  @override
  String get countryMe => 'Črna gora';

  @override
  String get countryMk => 'Severna Makedonija';

  @override
  String get countrySi => 'Slovenija';

  @override
  String get countryBg => 'Bolgarija';

  @override
  String get countryAl => 'Albanija';

  @override
  String get countryRo => 'Romunija';

  @override
  String get entityFbih => 'Federacija BiH';

  @override
  String get entityRepublikaSrpska => 'Republika Srbska';

  @override
  String get contribPio => 'PIO (pokojninsko in invalidsko)';

  @override
  String get contribHealth => 'Zdravstveno zavarovanje';

  @override
  String get contribUnemployment => 'Zavarovanje za primer brezposelnosti';

  @override
  String get contribPension => 'Pokojninsko zavarovanje';

  @override
  String get contribSocial => 'Socialno zavarovanje';

  @override
  String get contribChildProtection => 'Prispevek za zaščito otrok';

  @override
  String get contribHealthAndEmployment =>
      'Zdravstveno in zaposlitveno zavarovanje';

  @override
  String get contribCas => 'CAS (pokojninsko zavarovanje)';

  @override
  String get contribCass => 'CASS (zdravstveno zavarovanje)';

  @override
  String get contribCam => 'CAM (zavarovanje za delo)';

  @override
  String get suffixEmployee => 'delojemalec';

  @override
  String get suffixEmployer => 'delodajalec';

  @override
  String get toolsLoanSubtitle => 'Mesečni obrok, čas odplačila, amortizacija';

  @override
  String get toolsSavingsSubtitle => 'Obrestne obresti z rednimi vplačili';

  @override
  String get toolsVatSubtitle =>
      'Dodajte ali odštejte DDV po stopnji vaše države';

  @override
  String get toolsBudgetSubtitle =>
      'Razdelite mesečni dohodek na potrebe / želje / prihranke';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Tuji račun → provizije → dejansko lokalno izplačilo';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Dohodnina in prispevki za samozaposlene, 9 držav';

  @override
  String get loanScreenTitle => 'Posojila in dolgovi';

  @override
  String get loanModePayment => 'Obrok iz ročnosti';

  @override
  String get loanModePayoff => 'Rok odplačila iz obroka';

  @override
  String get loanPrincipal => 'Znesek posojila (glavnica)';

  @override
  String get loanRate => 'Letna obrestna mera (%)';

  @override
  String get loanTermMonths => 'Ročnost posojila (meseci)';

  @override
  String get loanFixedPayment => 'Fiksni mesečni obrok';

  @override
  String get loanErrorPrincipalRate =>
      'Vnesite veljavno glavnico in obrestno mero.';

  @override
  String get loanErrorTerm => 'Vnesite veljavno ročnost v mesecih.';

  @override
  String get loanErrorPayment => 'Vnesite veljaven mesečni obrok.';

  @override
  String get loanErrorTooLow =>
      'Ta obrok je prenizek, da bi kdaj odplačal dolg — ne pokrije niti obresti, ki se obračunajo vsak mesec.';

  @override
  String get loanMonthlyPayment => 'Mesečni obrok';

  @override
  String get loanTotalPaid => 'Skupaj plačano';

  @override
  String get loanTotalInterest => 'Skupne obresti';

  @override
  String get loanNumberOfPayments => 'Število obrokov';

  @override
  String get loanTimeToPayOff => 'Čas do odplačila';

  @override
  String loanMonthsCount(int months) {
    return '$months mesecev';
  }

  @override
  String get savingsScreenTitle => 'Varčevanje in rast';

  @override
  String get savingsStartingAmount => 'Začetni znesek';

  @override
  String get savingsMonthlyContribution => 'Mesečni prispevek';

  @override
  String get savingsExpectedReturn => 'Pričakovani letni donos (%)';

  @override
  String get savingsTimeHorizon => 'Časovni horizont (leta)';

  @override
  String get savingsErrorRateYears =>
      'Vnesite veljavno letno stopnjo in število let.';

  @override
  String get savingsFutureValue => 'Prihodnja vrednost';

  @override
  String get savingsTotalContributed => 'Skupaj vplačano';

  @override
  String get savingsInterestEarned => 'Zaslužene obresti';

  @override
  String get vatScreenTitle => 'Kalkulator DDV';

  @override
  String get vatStandardRateFor => 'Standardna stopnja za';

  @override
  String get vatAdd => 'Dodaj DDV';

  @override
  String get vatRemove => 'Odstrani DDV';

  @override
  String get vatNetAmount => 'Neto znesek (brez DDV)';

  @override
  String get vatGrossAmount => 'Bruto znesek (z DDV)';

  @override
  String get vatRateEditable =>
      'Stopnja DDV (%) — spremenljivo za znižane stopnje';

  @override
  String get vatGrossWithVat => 'Bruto (z DDV)';

  @override
  String get vatAmountLabel => 'Znesek DDV';

  @override
  String get vatNetWithoutVat => 'Neto (brez DDV)';

  @override
  String vatRatesAsOf(String date) {
    return 'Standardna stopnja od $date';
  }

  @override
  String get budgetScreenTitle => 'Načrtovalnik proračuna';

  @override
  String get budgetMonthlyIncome => 'Mesečni neto dohodek';

  @override
  String get budgetSplit => 'Razdelitev';

  @override
  String get budgetPresetSuffix => '(potrebe/želje/prihranki)';

  @override
  String get budgetNeeds => 'Potrebe';

  @override
  String get budgetWants => 'Želje';

  @override
  String get budgetSavings => 'Prihranki';

  @override
  String get freelancerScreenTitle =>
      'Preverjanje dejanskega izplačila freelancerja';

  @override
  String get freelancerInvoiceAmount => 'Znesek računa';

  @override
  String get freelancerCurrency => 'Valuta';

  @override
  String get freelancerPlatform => 'Platforma';

  @override
  String get freelancerPlatformCustom => 'Po meri';

  @override
  String get freelancerPlatformDirect => 'Neposredna stranka / nakazilo (0 %)';

  @override
  String get freelancerPlatformFee => 'Provizija platforme (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Bančna provizija (fiksna, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Bančna provizija (%)';

  @override
  String get freelancerPayoutCurrency => 'Valuta izplačila';

  @override
  String get freelancerCalculateButton => 'Izračunaj dejansko izplačilo';

  @override
  String get freelancerErrorInvoice => 'Vnesite veljaven znesek računa.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Nepričakovana napaka: $error';
  }

  @override
  String get freelancerRealPayout => 'Dejansko izplačilo';

  @override
  String get freelancerInvoiceAmountRow => 'Znesek računa';

  @override
  String get freelancerPlatformFeeRow => 'Provizija platforme';

  @override
  String get freelancerBankFeeRow => 'Bančna provizija';

  @override
  String get freelancerNetForeignAmount => 'Neto znesek v tuji valuti';

  @override
  String get samoFixedModel => 'Model s fiksnimi stroški';

  @override
  String get samoMixedModel => 'Model z mešanimi stroški';

  @override
  String get samoCheaperSame => 'Ta model je cenejša možnost za ta znesek.';

  @override
  String get samoCheaperOther =>
      'Drugi model bi za ta znesek prinesel nižji davek — modela lahko prosto menjavate vsako četrtletje.';

  @override
  String get freelanceTaxScreenTitle => 'Samoobdavčitev samozaposlenih';

  @override
  String get freelanceTaxCountryLabel => 'Država / režim';

  @override
  String get freelanceTaxIncomeLabelQuarterly => 'Četrtletni bruto prihodek';

  @override
  String get freelanceTaxIncomeLabelAnnual => 'Letni bruto prihodek';

  @override
  String get freelanceTaxNetIncome => 'Neto prihodek';

  @override
  String get freelanceTaxGrossIncomeRow => 'Bruto prihodek';

  @override
  String get freelanceTaxDeductionRow => 'Odbitek';

  @override
  String get freelanceTaxTaxableBaseRow => 'Davčna osnova';

  @override
  String get freelanceTaxIncomeTaxRow => 'Dohodnina';

  @override
  String get freelanceTaxContributionsTotalRow => 'Skupni prispevki';

  @override
  String freelanceTaxRulesVersionBundle(String date) {
    return 'Stopnje, vgrajene v aplikacijo · različica $date';
  }

  @override
  String freelanceTaxRulesVersionUpdated(String date) {
    return 'Stopnje, posodobljene prek spleta · različica $date';
  }

  @override
  String freelanceTaxSourcesLabel(String sources) {
    return 'Viri: $sources';
  }

  @override
  String get freelanceTaxNotAvailable => 'Ni na voljo';

  @override
  String get freelanceTaxModelLabel => 'Model';

  @override
  String get freelanceTaxVariantLabel => 'Vrsta';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Kategorija dejavnosti';

  @override
  String get freelanceFbihCategoryFreeProfessions => 'Svobodni poklici';

  @override
  String get freelanceFbihCategoryObrt => 'Obrtna dejavnost (obrt)';

  @override
  String get freelanceFbihCategoryAgriculture => 'Kmetijstvo / gozdarstvo';

  @override
  String get freelanceFbihCategoryLumpSumObrt => 'Pavšalni obrt';

  @override
  String get freelanceFbihCategoryTraditionalCraftsTaxi =>
      'Tradicionalne obrti / taksi';

  @override
  String get freelanceTaxCategoryLabel => 'Kategorija';

  @override
  String get freelanceBaRsCategoryStandard => 'Standardni podjetnik';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Samostojni poklici';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Dopolnilna dejavnost / upokojenec';

  @override
  String get freelanceTaxMunicipalityLabel => 'Občina';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Podgorica / Cetinje';

  @override
  String get freelanceMeMunicipalityBudva => 'Budva';

  @override
  String get freelanceMeMunicipalityOther => 'Druga občina';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'Prag za registracijo DDV: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return '0-odstotna dohodnina velja le do prometa $amount $currency — nad tem se ves dobiček obdavči progresivno, ne le presežek.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Ugodnost 80-odstotnih normiranih odhodkov velja le do prihodka $amount $currency.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Upravičenost do popoldanskega s.p. preneha pri prihodku $amount $currency.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'Alternativni status pavšalnega podjetnika je omejen na $amount $currency — zgolj informativno, tega ta kalkulator ne modelira.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Še ni doseženo';

  @override
  String get freelanceCliffStatusCrossed => 'Preseženo';

  @override
  String get freelanceRsInsuredElsewhereLabel =>
      'Že zavarovan(a) po drugi podlagi (prispevek za zdravstvo se ne plača)';

  @override
  String freelanceRsMinPioBaseBinds(String amount) {
    return 'Prispevek za PIO pri Modelu B je omejen na minimalno osnovo ($amount) — to je primer, ki ga ljudje najpogosteje napačno ocenijo.';
  }

  @override
  String get freelanceComparatorTitle => 'Primerjaj Model A in Model B';

  @override
  String get freelanceComparatorQuarterLabel => 'Četrtletje';

  @override
  String freelanceComparatorDeadlineHint(String date) {
    return 'Rok za prijavo za to četrtletje: $date';
  }

  @override
  String get freelanceComparatorNeedsIncome =>
      'Vnesite dohodek zgoraj za primerjavo obeh modelov.';

  @override
  String freelanceComparatorRecommended(String model, String amount) {
    return 'Priporočilo: $model — prihranek $amount pri neto dohodku.';
  }

  @override
  String get settingsProActive => 'Pro — aktivno';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Oglasi so izklopljeni po celotni aplikaciji';

  @override
  String get settingsProSubtitleInactive =>
      'Odstranite oglase s cenovno dostopno naročnino';

  @override
  String get settingsTrustTitle => 'Zakaj zaupati tej aplikaciji?';

  @override
  String get settingsTrustBody =>
      'Podatki o plačah, DDV-ju in samoobdavčitvi izhajajo iz navedenih državnih in strokovnih davčnih virov, ne iz ocen. Vsak kalkulator prikazuje leto, za katero številke veljajo, in datum uveljavitve, tako da lahko na prvi pogled ocenite ažurnost. Za način obravnave vaših podatkov glejte „Zasebnost in podatki“ in „Deluje popolnoma brez povezave“ spodaj.';

  @override
  String get settingsAdPrivacyTitle => 'Zasebnost in oglasi';

  @override
  String get settingsAdPrivacySubtitle =>
      'Preglejte ali spremenite svojo izbiro glede soglasja za oglase';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Možnosti zasebnosti oglasov niso na voljo na tej platformi.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'Za vašo regijo izbira zasebnosti oglasov ni potrebna.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro pokriva obračun plač, pretvorbo valut in vsakdanje finančne kalkulatorje za Srbijo, Hrvaško, Bosno in Hercegovino, Črno goro, Severno Makedonijo, Slovenijo, Bolgarijo, Albanijo in Romunijo. Vse številke so navedene z virom in datumom — za podrobnosti glejte opozorilo posameznega kalkulatorja. Ta aplikacija ponuja le ocene, ne strokovnega nasveta.';

  @override
  String get paywallTitle => 'Postani Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Odstranite vse oglase v vsakem kalkulatorju, po cenovno dostopni mesečni ceni. Vse države za obračun plač, pretvorba valut in finančna orodja ostanejo brezplačni v vsakem primeru.';

  @override
  String get paywallActiveMessage =>
      'Ste uporabnik Pro — hvala! Oglasi so izklopljeni po celotni aplikaciji.';

  @override
  String get paywallStoreUnavailable =>
      'Trgovina trenutno ni na voljo (to je pričakovano v razvojnih različicah brez nastavljenega seznama Play Console). Pro bo mogoče kupiti po objavi.';

  @override
  String get paywallProductUnavailable =>
      'Naročnina Pro v trgovini še ni nastavljena — to je nadomestni zaslon, dokler se pravi izdelek ne ustvari v Play Consoleu.';

  @override
  String get paywallSubscribe => 'Naroči se';

  @override
  String get paywallProcessing => 'Obdelava …';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Nakup ni uspel: $error';
  }

  @override
  String get paywallRestorePurchase => 'Obnovi nakup';

  @override
  String get chartTakeHome => 'Izplačilo';

  @override
  String get chartTax => 'Davek';

  @override
  String get chartContributions => 'Prispevki';

  @override
  String get homeRecentlyUsed => 'Nedavno uporabljeno';

  @override
  String get categoryLoansSavings => 'Posojila in varčevanje';

  @override
  String get categoryBudgetTax => 'Proračun in davki';

  @override
  String get categoryFreelance => 'Freelancing';

  @override
  String get toolsSearchHint => 'Iskanje orodij';

  @override
  String get toolsSearchNoResults => 'Ni najdenih orodij';

  @override
  String get homeLastSalaryTitle => 'Zadnji izračun plače';

  @override
  String get homeLastSalaryEmpty => 'Plače še niste izračunali.';

  @override
  String get homeLastSalaryCta => 'Izračunaj zdaj';

  @override
  String get settingsPrivacyTitle => 'Zasebnost in podatki';

  @override
  String get settingsPrivacyNote =>
      'Zgodovina izračunov je shranjena samo v tej napravi in se nikoli ne pošilja ali deli. Če jo izbrišete ali odstranite aplikacijo, se trajno odstrani.';

  @override
  String get settingsClearHistory => 'Izbriši zgodovino';

  @override
  String get settingsClearHistorySubtitle =>
      'Odstrani vse nedavne izračune z Domov in Orodij';

  @override
  String get settingsClearHistoryDialogTitle => 'Izbrišem zgodovino?';

  @override
  String get settingsClearHistoryDialogBody =>
      'S tem odstranite vso nedavno dejavnost z Domov in Orodij. Tega dejanja ni mogoče razveljaviti.';

  @override
  String get settingsClearHistoryDialogCancel => 'Prekliči';

  @override
  String get settingsClearHistoryDialogConfirm => 'Izbriši';

  @override
  String get settingsClearHistoryDone => 'Zgodovina izbrisana';

  @override
  String get commonCancel => 'Prekliči';

  @override
  String get commonSave => 'Shrani';

  @override
  String get commonDelete => 'Izbriši';

  @override
  String get commonRename => 'Preimenuj';

  @override
  String get commonUndo => 'Razveljavi';

  @override
  String get scenarioSaveTooltip => 'Shrani ta izračun';

  @override
  String get scenarioSaveDialogTitle => 'Shrani izračun';

  @override
  String get scenarioNameLabel => 'Ime';

  @override
  String get scenarioSavedConfirmation => 'Scenarij je shranjen';

  @override
  String get scenarioLimitTitle => 'Dosežena brezplačna omejitev';

  @override
  String scenarioLimitBody(int limit) {
    return 'Brezplačni računi lahko shranijo do $limit scenarijev. Nadgradite na Pro za neomejeno shranjevanje, primerjavo in izvoz.';
  }

  @override
  String get scenarioLimitUpgrade => 'Nadgradi na Pro';

  @override
  String get myScenariosTitle => 'Moji scenariji';

  @override
  String myScenariosSubtitle(int count) {
    return '$count shranjenih';
  }

  @override
  String get myScenariosSubtitleEmpty => 'Ni shranjenih scenarijev';

  @override
  String get myScenariosEmptyState =>
      'Shranite izračun iz katerega koli orodja, da ga vidite tukaj.';

  @override
  String get scenarioRenameDialogTitle => 'Preimenuj scenarij';

  @override
  String get scenarioDeleteDialogTitle => 'Izbrišem scenarij?';

  @override
  String get scenarioDeleteDialogBody => 'Tega ni mogoče razveljaviti.';

  @override
  String get categoryTracking => 'Sledenje in načrtovanje';

  @override
  String get toolsExpenseTrackerTitle => 'Pregled stroškov';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Beležite prihodke in odhodke, spremljajte mesečno stanje';

  @override
  String get expenseScreenTitle => 'Pregled stroškov';

  @override
  String get expenseIncome => 'Prihodki';

  @override
  String get expenseExpenses => 'Odhodki';

  @override
  String get expenseBalance => 'Stanje';

  @override
  String get expenseEmptyState =>
      'Ta mesec še ni transakcij. Dotaknite se + za dodajanje prvega prihodka ali odhodka.';

  @override
  String get expenseAddIncome => 'Dodaj prihodek';

  @override
  String get expenseAddExpense => 'Dodaj odhodek';

  @override
  String get expenseAmount => 'Znesek';

  @override
  String get expenseCategory => 'Kategorija';

  @override
  String get expenseNote => 'Opomba (neobvezno)';

  @override
  String get expenseDate => 'Datum';

  @override
  String get expenseDeleteConfirmTitle => 'Izbrišem to transakcijo?';

  @override
  String get expenseDeleteConfirmBody =>
      'Takoj zatem boste imeli kratko možnost za razveljavitev.';

  @override
  String get expenseDeletedConfirmation => 'Transakcija je izbrisana';

  @override
  String get expenseEditTransaction => 'Uredi transakcijo';

  @override
  String get expenseSearchHint => 'Iskanje po opombah ali kategorijah';

  @override
  String get expenseFilterAll => 'Vse';

  @override
  String get expenseSortByDate => 'Razvrsti po datumu';

  @override
  String get expenseSortByAmount => 'Razvrsti po znesku';

  @override
  String get expenseNoResults => 'Nobena transakcija ne ustreza iskanju.';

  @override
  String expenseResultCount(int shown, int total) {
    return '$shown od $total';
  }

  @override
  String get expenseSpendingByCategory => 'Poraba po kategorijah';

  @override
  String get toolsRecurringTitle => 'Ponavljajoče transakcije';

  @override
  String get toolsRecurringSubtitle =>
      'Najemnina, naročnine in druga redna plačila — določite enkrat';

  @override
  String get recurringScreenTitle => 'Ponavljajoče transakcije';

  @override
  String get recurringEmptyState =>
      'Še ni ponavljajočih transakcij. Dodajte najemnino, naročnine ali druga redna plačila enkrat — samodejno se bodo beležila ali počakala na vaš pregled, po vaši izbiri.';

  @override
  String get recurringAddTitle => 'Nova ponavljajoča transakcija';

  @override
  String get recurringEditTitle => 'Urejanje ponavljajoče transakcije';

  @override
  String get recurringFrequencyLabel => 'Se ponavlja';

  @override
  String get recurringFrequencyWeekly => 'Tedensko';

  @override
  String get recurringFrequencyMonthly => 'Mesečno';

  @override
  String get recurringStartDateLabel => 'Začne se';

  @override
  String get recurringAutoPostLabel => 'Samodejno beleženje';

  @override
  String get recurringAutoPostSubtitle =>
      'Izklopljeno: pred dodajanjem preglejte vsako pojavitev';

  @override
  String get recurringPausedLabel => 'V premoru';

  @override
  String get recurringPauseAction => 'Premor';

  @override
  String get recurringResumeAction => 'Nadaljuj';

  @override
  String get recurringDeleteConfirmTitle =>
      'Izbrišem to ponavljajočo transakcijo?';

  @override
  String get recurringDeleteConfirmBody =>
      'To ustavi prihodnje pojavitve. Že knjižene transakcije ostanejo nespremenjene.';

  @override
  String recurringReviewBannerTitle(int count) {
    return '$count ponavljajočih transakcij za pregled';
  }

  @override
  String get recurringReviewPost => 'Knjiži';

  @override
  String get recurringReviewSkip => 'Preskoči';

  @override
  String get toolsRadarTitle => 'Radar stalnih stroškov';

  @override
  String get toolsRadarSubtitle =>
      'Preglejte skupne ponavljajoče stroške na enem mestu';

  @override
  String get radarScreenTitle => 'Radar stalnih stroškov';

  @override
  String get radarEmptyState =>
      'Še ni aktivnih ponavljajočih stroškov. Dodajte enega v Ponavljajočih transakcijah, da tukaj vidite skupni stalni strošek.';

  @override
  String get radarMonthlyTotal => 'Mesečno skupaj';

  @override
  String get radarWeeklyTotal => 'Tedensko skupaj';

  @override
  String radarNextDue(String date) {
    return 'Naslednje: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Proračuni in cilji';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Nastavite mesečne omejitve porabe in spremljajte cilje varčevanja';

  @override
  String get budgetsScreenTitle => 'Proračuni in cilji';

  @override
  String get budgetsSectionCategoryBudgets => 'Proračuni po kategorijah';

  @override
  String get budgetsSectionGoals => 'Cilji varčevanja';

  @override
  String get budgetsNoLimitSet => 'Omejitev ni nastavljena';

  @override
  String get budgetsSetLimit => 'Nastavi omejitev';

  @override
  String get budgetsEditLimit => 'Uredi omejitev';

  @override
  String get budgetsMonthlyLimit => 'Mesečna omejitev';

  @override
  String get budgetsOverBudget => 'Prekoračen proračun';

  @override
  String get budgetsNoBudgetsHint =>
      'Nastavite mesečno omejitev za katero koli kategorijo spodaj, da spremljate porabo glede nanjo.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Odstranim to omejitev?';

  @override
  String get budgetsDeleteLimitConfirmBody =>
      'Novo lahko nastavite kadar koli.';

  @override
  String get budgetsAddGoal => 'Dodaj cilj';

  @override
  String get budgetsGoalName => 'Ime cilja';

  @override
  String get budgetsTargetAmount => 'Ciljni znesek';

  @override
  String get budgetsTargetDateOptional => 'Ciljni datum (neobvezno)';

  @override
  String get budgetsNoTargetDate => 'Brez ciljnega datuma';

  @override
  String get budgetsAddProgress => 'Dodaj napredek';

  @override
  String get budgetsProgressAmountLabel => 'Znesek za dodajanje';

  @override
  String get budgetsGoalComplete => 'Cilj dosežen!';

  @override
  String get budgetsNoGoalsYet =>
      'Še ni ciljev varčevanja. Dodajte enega, da začnete spremljati napredek proti nečemu konkretnemu.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Izbrišem ta cilj?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'Tega ni mogoče razveljaviti.';

  @override
  String get budgetsProgressExplanation =>
      'Napredek se posodobi le, ko ga ročno dodate tukaj — ta aplikacija nima bančne povezave, zato se nič ne spremlja samodejno.';

  @override
  String get expenseInsightsTitle => 'Vpogledi';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Poraba je $percent% višja kot prejšnji mesec ($current proti $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Poraba je $percent% nižja kot prejšnji mesec ($current proti $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Poraba je podobna kot prejšnji mesec ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category je vaša največja kategorija odhodkov ta mesec, z $percent% skupne porabe.';
  }

  @override
  String get expenseInsightHowCalculated => 'Poglejte izračun';

  @override
  String expenseInsightCounter(int current, int total) {
    return '$current od $total';
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
    return '$categoryAmount ÷ $total skupaj × 100 = $percent%';
  }

  @override
  String get expenseExportCsv => 'Izvozi CSV';

  @override
  String get expenseExportCopied =>
      'CSV je kopiran v odložišče — prilepite ga v preglednico ali beležko';

  @override
  String get expenseExportEmpty => 'Ta mesec ni transakcij za izvoz';

  @override
  String get settingsDataManagementTitle => 'Upravljanje podatkov';

  @override
  String get settingsExportAllData => 'Izvozi vse podatke (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Kopirajte transakcije, scenarije, proračune in cilje v odložišče';

  @override
  String get settingsExportAllDataEmpty => 'Ni še podatkov za izvoz';

  @override
  String get settingsExportAllDataDone => 'Vsi podatki so kopirani v odložišče';

  @override
  String get settingsDeleteAllData => 'Izbriši vse lokalne podatke';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Trajno odstranite transakcije, scenarije, proračune in cilje s te naprave';

  @override
  String get settingsDeleteAllDataDialog1Title =>
      'Izbrišem vse lokalne podatke?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'To trajno odstrani vsako transakcijo, shranjeni scenarij, proračun po kategoriji in cilj varčevanja, shranjen na tej napravi. Tega ni mogoče razveljaviti. Izbrisana bo tudi vaša zgodovina izračunov.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Ste popolnoma prepričani?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'To je vaša zadnja priložnost za preklic. Teh podatkov kasneje ne bo mogoče obnoviti.';

  @override
  String get settingsDeleteAllDataConfirm => 'Izbriši vse';

  @override
  String get settingsDeleteAllDataDone => 'Vsi lokalni podatki so izbrisani';

  @override
  String get settingsOfflineStatusTitle => 'Deluje popolnoma brez povezave';

  @override
  String get settingsOfflineStatusBody =>
      'Ta aplikacija nima računa, sinhronizacije v oblaku ali strežnika — vse, kar vnesete, ostane samo na tej napravi. Tečaj menjave valut je edina funkcija, ki potrebuje internetno povezavo; če ste brez povezave, se uporabi zadnji znani tečaj.';

  @override
  String get toolsInvoicesTitle => 'Računi';

  @override
  String get toolsInvoicesSubtitle =>
      'Sledite, kaj vam dolgujejo stranke — plačano, neplačano in zapadlo';

  @override
  String get invoicesScreenTitle => 'Računi';

  @override
  String get invoicesEmptyState =>
      'Še ni računov. Dotaknite se + za dodajanje prvega.';

  @override
  String get invoiceOutstanding => 'Neplačano';

  @override
  String get invoiceOverdue => 'Zapadlo';

  @override
  String get invoiceFilterAll => 'Vsi';

  @override
  String get invoiceFilterUnpaid => 'Neplačano';

  @override
  String get invoiceFilterOverdue => 'Zapadlo';

  @override
  String get invoiceFilterPaid => 'Plačano';

  @override
  String get invoiceStatusPaid => 'Plačano';

  @override
  String get invoiceStatusUnpaid => 'Neplačano';

  @override
  String get invoiceStatusOverdue => 'Zapadlo';

  @override
  String get invoiceDueLabel => 'Rok';

  @override
  String get invoiceMarkPaid => 'Označi kot plačano';

  @override
  String get invoiceMarkUnpaid => 'Označi kot neplačano';

  @override
  String get invoiceDeleteConfirmTitle => 'Izbrišem ta račun?';

  @override
  String get invoiceDeleteConfirmBody => 'Tega ni mogoče razveljaviti.';

  @override
  String get invoiceAddTitle => 'Dodaj račun';

  @override
  String get invoiceEditTitle => 'Uredi račun';

  @override
  String get invoiceClientName => 'Ime stranke';

  @override
  String get invoiceDescription => 'Opis (neobvezno)';

  @override
  String get invoiceAmount => 'Znesek';

  @override
  String get invoiceIssueDate => 'Datum izdaje';

  @override
  String get invoiceDueDate => 'Rok plačila';

  @override
  String get invoiceNumberLabel => 'Številka računa (neobvezno)';

  @override
  String get invoiceAddItem => 'Dodaj postavko';

  @override
  String get invoiceItemDescription => 'Opis';

  @override
  String get invoiceItemQuantity => 'Kol.';

  @override
  String get invoiceItemUnitPrice => 'Cena/enoto';

  @override
  String get invoiceItemSubtotal => 'Znesek';

  @override
  String get invoiceAmountFromItemsHelper =>
      'Izračunano na podlagi spodnjih postavk';

  @override
  String get invoiceRemoveItemTooltip => 'Odstrani postavko';

  @override
  String get invoiceGeneratePdf => 'Ustvari PDF';

  @override
  String get invoiceGeneratingPdf => 'Ustvarjanje PDF-ja…';

  @override
  String get invoicePdfError =>
      'Ustvarjanje PDF-ja ni uspelo. Račun se ni spremenil — poskusite znova.';

  @override
  String get invoiceQrEligibleBody =>
      'Ta račun bo vseboval NBS IPS QR kodo za plačilo.';

  @override
  String get invoiceQrIneligibleBody =>
      'Dodajte številko računa in plačilno šifro v Nastavitve → Poslovni profil, da vključite QR kodo za plačilo na tem računu.';

  @override
  String get toolsPausalTrackerTitle => 'Sledilnik pavšala (Srbija)';

  @override
  String get toolsPausalTrackerSubtitle =>
      'Spremljajte promet glede na prag pavšala in prag za DDV';

  @override
  String get pausalTrackerCeilingCardTitle =>
      'Prag pavšala (to koledarsko leto)';

  @override
  String get pausalTrackerVatCardTitle => 'Prag za DDV (zadnjih 12 mesecev)';

  @override
  String get pausalTrackerStateOk => 'V redu';

  @override
  String get pausalTrackerStateWarning70 =>
      'Doseženih 70 % — vredno spremljanja';

  @override
  String get pausalTrackerStateWarning85 =>
      'Doseženih 85 % — bodite posebej pozorni';

  @override
  String get pausalTrackerStateWarning95 =>
      'Doseženih 95 % — verjetno bo kmalu potreben ukrep';

  @override
  String get pausalTrackerStateExceeded => 'Preseženo';

  @override
  String pausalTrackerProjection(String date) {
    return 'Pri trenutnem tempu bi prag pavšala dosegli okoli $date.';
  }

  @override
  String pausalTrackerExcludedBanner(int count) {
    return '$count račun(ov) izključenih — menjalni tečaj ni na voljo';
  }

  @override
  String get pausalTrackerSeeBreakdown => 'Poglejte številke';

  @override
  String get pausalTrackerBreakdownTitle => 'Kako je bilo to izračunano';

  @override
  String get pausalTrackerBreakdownExcludedHeader =>
      'Izključeno — menjalni tečaj ni na voljo';

  @override
  String pausalTrackerBreakdownRateLabel(String source) {
    return 'tečaj: $source';
  }

  @override
  String get pausalTrackerBreakdownExcludedReason =>
      'Za ta račun ni bilo mogoče pridobiti menjalnega tečaja — izključen je iz skupnega zneska, namesto da bi bil ocenjen.';

  @override
  String get pausalTrackerAssessedAmountLabel =>
      'Odmerjeni mesečni znesek pavšala';

  @override
  String get pausalTrackerAssessedAmountHint =>
      'Neobvezno — vnesite znesek iz vaše davčne odločbe. Aplikacija ga ne more izračunati sama.';

  @override
  String get pausalTrackerAssessedAmountSaved => 'Shranjeno';

  @override
  String pausalTrackerAssessedAmountDecomposition(
    String tax,
    String pio,
    String health,
    String unemployment,
    String total,
  ) {
    return '= $tax davek + $pio PIO + $health zdravstvo + $unemployment brezposelnost = $total osnove, določene z odločbo.';
  }

  @override
  String get commonClearSearch => 'Počisti iskanje';

  @override
  String get expensePreviousMonth => 'Prejšnji mesec';

  @override
  String get expenseNextMonth => 'Naslednji mesec';

  @override
  String get homeExpenseTrackerTitle => 'Ta mesec';

  @override
  String get homeExpenseTrackerCtaEmpty =>
      'Spremljajte svoje prihodke in odhodke';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'Spremljanih je več valut — dotaknite se za prikaz vseh';

  @override
  String get catHousing => 'Stanovanje in najemnina';

  @override
  String get catUtilities => 'Položnice';

  @override
  String get catGroceries => 'Živila';

  @override
  String get catTransport => 'Prevoz';

  @override
  String get catHealth => 'Zdravje';

  @override
  String get catEducation => 'Izobraževanje';

  @override
  String get catEntertainment => 'Zabava';

  @override
  String get catOtherExpense => 'Drugo';

  @override
  String get catSalary => 'Plača';

  @override
  String get catFreelance => 'Freelance / posel';

  @override
  String get catOtherIncome => 'Drugi prihodki';
}
