// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Početna';

  @override
  String get navConvert => 'Konverzija';

  @override
  String get navSalary => 'Plaća';

  @override
  String get navTools => 'Alati';

  @override
  String get navSettings => 'Postavke';

  @override
  String themeToggleTooltip(String mode) {
    return 'Promijeni temu ($mode)';
  }

  @override
  String get themeModeSystem => 'sustavska';

  @override
  String get themeModeLight => 'svijetla';

  @override
  String get themeModeDark => 'tamna';

  @override
  String get onboardingSkip => 'Preskoči';

  @override
  String get onboardingContinue => 'Nastavi';

  @override
  String get onboardingGetStarted => 'Započni';

  @override
  String get onboardingWelcomeTitle => 'Dobrodošli';

  @override
  String get onboardingWelcomeSubtitle =>
      'Odaberite državu i jezik za početak. Ovo možete promijeniti bilo kada u Postavkama.';

  @override
  String get onboardingCountryLabel => 'Država';

  @override
  String get onboardingPrivacyTitle => 'Vaši podaci ostaju na telefonu';

  @override
  String get onboardingPrivacyBody =>
      'Bez računa. Bez sinkronizacije u oblaku. Bez poslužitelja. Sve što unesete — plaće, troškove, račune — ostaje samo na ovom uređaju. Konverzija valuta jedina je značajka kojoj je potrebna internetska veza; bez nje se koristi posljednji poznati tečaj.';

  @override
  String get onboardingGoalTitle => 'Što vas dovodi ovamo?';

  @override
  String get onboardingGoalSubtitle =>
      'Prilagodit ćemo početni zaslon tome — sve ostalo ostaje jedan dodir dalje.';

  @override
  String get onboardingGoalSalaryTitle => 'Plaća i obračun zarade';

  @override
  String get onboardingGoalSalaryDesc =>
      'Izračunajte neto od bruto plaće za 9 zemalja';

  @override
  String get onboardingGoalExpensesTitle => 'Praćenje prihoda i troškova';

  @override
  String get onboardingGoalExpensesDesc =>
      'Bilježite troškove, postavite proračune, ostvarite ciljeve štednje';

  @override
  String get onboardingGoalBusinessTitle => 'Freelance i posao';

  @override
  String get onboardingGoalBusinessDesc => 'Računi, isplate i poslovni alati';

  @override
  String get commonCalculate => 'Izračunaj';

  @override
  String get commonConvert => 'Konvertiraj';

  @override
  String get commonRetry => 'Pokušaj ponovno';

  @override
  String get commonSwapCurrencies => 'Zamijeni valute';

  @override
  String get commonSomethingWentWrong => 'Nešto je pošlo po zlu.';

  @override
  String get commonFrom => 'Iz';

  @override
  String get commonTo => 'U';

  @override
  String get commonAmount => 'Iznos';

  @override
  String get convertCardTitle => 'Konverzija';

  @override
  String get convertEmptyState =>
      'Unesite iznos i pritisnite Konvertiraj za stvarni, trenutni tečaj.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Trenutni tečaj iz $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Spremljeni tečaj od $formatted (offline) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Unesite iznos.';

  @override
  String get convertAmountIssueInvalid => 'To ne izgleda kao valjan broj.';

  @override
  String get convertAmountIssueNegative => 'Iznos ne može biti negativan.';

  @override
  String get convertAmountIssueZero => 'Iznos mora biti veći od nule.';

  @override
  String get convertAmountIssueTooLarge =>
      'To izgleda neuobičajeno veliko za iznos — provjerite je li greška u tipkanju.';

  @override
  String salaryTitle(String country) {
    return 'Kalkulator plaće — $country';
  }

  @override
  String salaryParamsLine(int year, String date) {
    return 'Parametri za $year. · na snazi od $date';
  }

  @override
  String get salaryModeGrossToNet => 'Bruto → Neto';

  @override
  String get salaryModeNetToGross => 'Neto → Bruto';

  @override
  String salaryGrossLabel(String currencyCode) {
    return 'Bruto plaća, $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Neto plaća, $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Unesite plaću i pritisnite Izračunaj za potpuni obračun.';

  @override
  String get salaryNeto => 'Neto (za isplatu)';

  @override
  String get salaryBruto => 'Bruto (plaća)';

  @override
  String get salaryAllowance => 'Osobni odbitak';

  @override
  String get salaryTaxableBase => 'Porezna osnovica';

  @override
  String get salaryIncomeTax => 'Porez na dohodak';

  @override
  String get salaryLocalSurtax => 'Prirez';

  @override
  String get salaryEmployeeContribTotal => 'Doprinosi zaposlenika (ukupno)';

  @override
  String get salaryEmployerContribTotal => 'Doprinosi poslodavca (ukupno)';

  @override
  String get salaryBruto2 => 'Bruto 2 (ukupan trošak poslodavca)';

  @override
  String salarySurtaxLabel(String rate) {
    return 'Prirez: $rate% — postavite na stopu vaše općine';
  }

  @override
  String get salaryDisclaimer =>
      'Ovo je procjena isključivo u informativne svrhe i ne predstavlja porezni, pravni ili financijski savjet. Stvarne obveze mogu se razlikovati ovisno o vašoj konkretnoj situaciji — prije donošenja odluka posavjetujte se s ovlaštenim knjigovođom ili nadležnom poreznom upravom.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Ovaj bruto iznos je ispod zakonom propisane minimalne osnovice za doprinose ($base). Obvezni doprinosi sami dosežu ili premašuju ovu plaću, pa je iznos za isplatu nula ili negativan — ovu razinu plaće nije praktično službeno prijaviti.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'Na ovoj razini prihoda, obvezni doprinosi i porez zajedno dosežu ili premašuju bruto plaću, pa je iznos za isplatu nula ili negativan.';

  @override
  String salaryConfigError(String country) {
    return 'Nije moguće učitati poreznu konfiguraciju za $country.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Unesite plaću.';

  @override
  String get salaryAmountIssueInvalid => 'To ne izgleda kao valjan broj.';

  @override
  String get salaryAmountIssueNegative => 'Plaća ne može biti negativna.';

  @override
  String get salaryAmountIssueZero => 'Plaća mora biti veća od nule.';

  @override
  String get salaryAmountIssueTooLarge =>
      'To izgleda neuobičajeno veliko za plaću — provjerite je li greška u tipkanju.';

  @override
  String get toolsHubTitle => 'Financijski alati';

  @override
  String get toolsLoanTitle => 'Krediti i dugovi';

  @override
  String get toolsSavingsTitle => 'Štednja i rast';

  @override
  String get toolsVatTitle => 'PDV kalkulator';

  @override
  String get toolsBudgetTitle => 'Planer proračuna';

  @override
  String get toolsFreelancerPayoutTitle => 'Isplata freelancera';

  @override
  String get toolsFreelanceTaxTitle => 'Samoprijava freelancera';

  @override
  String get homeQuoteOfDay => 'Citat dana';

  @override
  String get homeQuickActions => 'Brze radnje';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsAbout => 'O aplikaciji';

  @override
  String get settingsSystemDefault => 'Zadano sustava';

  @override
  String get countryRs => 'Srbija';

  @override
  String get countryHr => 'Hrvatska';

  @override
  String get countryBa => 'Bosna i Hercegovina';

  @override
  String get countryMe => 'Crna Gora';

  @override
  String get countryMk => 'Sjeverna Makedonija';

  @override
  String get countrySi => 'Slovenija';

  @override
  String get countryBg => 'Bugarska';

  @override
  String get countryAl => 'Albanija';

  @override
  String get countryRo => 'Rumunjska';

  @override
  String get entityFbih => 'Federacija BiH';

  @override
  String get entityRepublikaSrpska => 'Republika Srpska';

  @override
  String get contribPio => 'PIO (mirovinsko i invalidsko)';

  @override
  String get contribHealth => 'Zdravstveno osiguranje';

  @override
  String get contribUnemployment => 'Osiguranje za slučaj nezaposlenosti';

  @override
  String get contribPension => 'Mirovinsko osiguranje';

  @override
  String get contribSocial => 'Socijalno osiguranje';

  @override
  String get contribChildProtection => 'Doprinos za zaštitu djece';

  @override
  String get contribHealthAndEmployment =>
      'Zdravstveno i osiguranje za zapošljavanje';

  @override
  String get contribCas => 'CAS (mirovinsko osiguranje)';

  @override
  String get contribCass => 'CASS (zdravstveno osiguranje)';

  @override
  String get contribCam => 'CAM (osiguranje za rad)';

  @override
  String get suffixEmployee => 'zaposlenik';

  @override
  String get suffixEmployer => 'poslodavac';

  @override
  String get toolsLoanSubtitle => 'Mjesečna rata, rok otplate, amortizacija';

  @override
  String get toolsSavingsSubtitle => 'Složena kamata s redovitim uplatama';

  @override
  String get toolsVatSubtitle =>
      'Dodajte ili oduzmite PDV po stopi vaše zemlje';

  @override
  String get toolsBudgetSubtitle =>
      'Podijelite mjesečni prihod na potrebe / želje / štednju';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Strani račun → naknade → stvarna lokalna isplata';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Porez na dohodak i doprinosi za freelancere, 9 zemalja';

  @override
  String get loanScreenTitle => 'Krediti i dugovi';

  @override
  String get loanModePayment => 'Rata iz roka otplate';

  @override
  String get loanModePayoff => 'Rok otplate iz rate';

  @override
  String get loanPrincipal => 'Iznos kredita (glavnica)';

  @override
  String get loanRate => 'Godišnja kamatna stopa (%)';

  @override
  String get loanTermMonths => 'Rok otplate (mjeseci)';

  @override
  String get loanFixedPayment => 'Fiksna mjesečna rata';

  @override
  String get loanErrorPrincipalRate =>
      'Unesite ispravnu glavnicu i kamatnu stopu.';

  @override
  String get loanErrorTerm => 'Unesite ispravan rok otplate u mjesecima.';

  @override
  String get loanErrorPayment => 'Unesite ispravnu mjesečnu ratu.';

  @override
  String get loanErrorTooLow =>
      'Ova rata je premala da bi ikada otplatila dug — ne pokriva ni kamatu koja se obračunava svakog mjeseca.';

  @override
  String get loanMonthlyPayment => 'Mjesečna rata';

  @override
  String get loanTotalPaid => 'Ukupno plaćeno';

  @override
  String get loanTotalInterest => 'Ukupna kamata';

  @override
  String get loanNumberOfPayments => 'Broj rata';

  @override
  String get loanTimeToPayOff => 'Vrijeme do otplate';

  @override
  String loanMonthsCount(int months) {
    return '$months mjeseci';
  }

  @override
  String get savingsScreenTitle => 'Štednja i rast';

  @override
  String get savingsStartingAmount => 'Početni iznos';

  @override
  String get savingsMonthlyContribution => 'Mjesečna uplata';

  @override
  String get savingsExpectedReturn => 'Očekivani godišnji prinos (%)';

  @override
  String get savingsTimeHorizon => 'Vremensko razdoblje (godine)';

  @override
  String get savingsErrorRateYears =>
      'Unesite ispravnu godišnju stopu i broj godina.';

  @override
  String get savingsFutureValue => 'Buduća vrijednost';

  @override
  String get savingsTotalContributed => 'Ukupno uplaćeno';

  @override
  String get savingsInterestEarned => 'Zarađena kamata';

  @override
  String get vatScreenTitle => 'PDV kalkulator';

  @override
  String get vatStandardRateFor => 'Standardna stopa za';

  @override
  String get vatAdd => 'Dodaj PDV';

  @override
  String get vatRemove => 'Ukloni PDV';

  @override
  String get vatNetAmount => 'Neto iznos (bez PDV-a)';

  @override
  String get vatGrossAmount => 'Bruto iznos (s PDV-om)';

  @override
  String get vatRateEditable => 'Stopa PDV-a (%) — izmjenjivo za snižene stope';

  @override
  String get vatGrossWithVat => 'Bruto (s PDV-om)';

  @override
  String get vatAmountLabel => 'Iznos PDV-a';

  @override
  String get vatNetWithoutVat => 'Neto (bez PDV-a)';

  @override
  String vatRatesAsOf(String date) {
    return 'Standardna stopa od $date';
  }

  @override
  String get budgetScreenTitle => 'Planer proračuna';

  @override
  String get budgetMonthlyIncome => 'Mjesečni neto prihod';

  @override
  String get budgetSplit => 'Podjela';

  @override
  String get budgetPresetSuffix => '(potrebe/želje/štednja)';

  @override
  String get budgetNeeds => 'Potrebe';

  @override
  String get budgetWants => 'Želje';

  @override
  String get budgetSavings => 'Štednja';

  @override
  String get freelancerScreenTitle => 'Provjera stvarne isplate freelancera';

  @override
  String get freelancerInvoiceAmount => 'Iznos računa';

  @override
  String get freelancerCurrency => 'Valuta';

  @override
  String get freelancerPlatform => 'Platforma';

  @override
  String get freelancerPlatformCustom => 'Prilagođeno';

  @override
  String get freelancerPlatformDirect => 'Izravan klijent / transfer (0%)';

  @override
  String get freelancerPlatformFee => 'Naknada platforme (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Bankovna naknada (fiksna, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Bankovna naknada (%)';

  @override
  String get freelancerPayoutCurrency => 'Valuta isplate';

  @override
  String get freelancerCalculateButton => 'Izračunaj stvarnu isplatu';

  @override
  String get freelancerErrorInvoice => 'Unesite ispravan iznos računa.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Neočekivana pogreška: $error';
  }

  @override
  String get freelancerRealPayout => 'Stvarna isplata';

  @override
  String get freelancerInvoiceAmountRow => 'Iznos računa';

  @override
  String get freelancerPlatformFeeRow => 'Naknada platforme';

  @override
  String get freelancerBankFeeRow => 'Bankovna naknada';

  @override
  String get freelancerNetForeignAmount => 'Neto iznos u stranoj valuti';

  @override
  String get samoFixedModel => 'Model s fiksnim troškom';

  @override
  String get samoMixedModel => 'Model s mješovitim troškom';

  @override
  String get samoCheaperSame => 'Ovaj model je jeftinija opcija za ovaj iznos.';

  @override
  String get samoCheaperOther =>
      'Drugi model bi proizveo manji porez za ovaj iznos — modele možete slobodno mijenjati svakog kvartala.';

  @override
  String get freelanceTaxScreenTitle => 'Samoprijava freelancera';

  @override
  String get freelanceTaxCountryLabel => 'Zemlja / režim';

  @override
  String get freelanceTaxIncomeLabelQuarterly => 'Kvartalni bruto prihod';

  @override
  String get freelanceTaxIncomeLabelAnnual => 'Godišnji bruto prihod';

  @override
  String get freelanceTaxNetIncome => 'Neto prihod';

  @override
  String get freelanceTaxGrossIncomeRow => 'Bruto prihod';

  @override
  String get freelanceTaxDeductionRow => 'Odbitak';

  @override
  String get freelanceTaxTaxableBaseRow => 'Porezna osnovica';

  @override
  String get freelanceTaxIncomeTaxRow => 'Porez na dohodak';

  @override
  String get freelanceTaxContributionsTotalRow => 'Ukupni doprinosi';

  @override
  String freelanceTaxRulesVersionBundle(String date) {
    return 'Stope ugrađene u aplikaciju · verzija $date';
  }

  @override
  String freelanceTaxRulesVersionUpdated(String date) {
    return 'Stope ažurirane putem interneta · verzija $date';
  }

  @override
  String freelanceTaxSourcesLabel(String sources) {
    return 'Izvori: $sources';
  }

  @override
  String get freelanceTaxNotAvailable => 'Nije dostupno';

  @override
  String get freelanceTaxModelLabel => 'Model';

  @override
  String get freelanceTaxVariantLabel => 'Vrsta';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Kategorija djelatnosti';

  @override
  String get freelanceFbihCategoryFreeProfessions => 'Slobodna zanimanja';

  @override
  String get freelanceFbihCategoryObrt => 'Obrt';

  @override
  String get freelanceFbihCategoryAgriculture => 'Poljoprivreda / šumarstvo';

  @override
  String get freelanceFbihCategoryLumpSumObrt => 'Paušalni obrt';

  @override
  String get freelanceFbihCategoryTraditionalCraftsTaxi =>
      'Tradicionalni obrti / taksi';

  @override
  String get freelanceTaxCategoryLabel => 'Kategorija';

  @override
  String get freelanceBaRsCategoryStandard => 'Standardni poduzetnik';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Samostalne profesije';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Dopunska djelatnost / umirovljenik';

  @override
  String get freelanceTaxMunicipalityLabel => 'Općina';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Podgorica / Cetinje';

  @override
  String get freelanceMeMunicipalityBudva => 'Budva';

  @override
  String get freelanceMeMunicipalityOther => 'Druga općina';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'Prag za registraciju PDV-a: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return 'Stopa od 0% poreza na dohodak vrijedi samo do prometa od $amount $currency — iznad toga se cijela dobit oporezuje progresivno, ne samo višak.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Olakšica od 80% priznatih troškova vrijedi samo do prihoda od $amount $currency.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Pravo na popoldanski s.p. prestaje kod prihoda od $amount $currency.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'Alternativni status paušalnog poduzetnika ograničen je na $amount $currency — samo informativno, ovaj kalkulator ga ne modelira.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Još nije dosegnuto';

  @override
  String get freelanceCliffStatusCrossed => 'Prekoračeno';

  @override
  String get settingsProActive => 'Pro — aktivno';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Oglasi su isključeni u cijeloj aplikaciji';

  @override
  String get settingsProSubtitleInactive =>
      'Uklonite oglase uz pristupačnu pretplatu';

  @override
  String get settingsTrustTitle => 'Zašto vjerovati ovoj aplikaciji?';

  @override
  String get settingsTrustBody =>
      'Podaci o plaćama, PDV-u i samooporezivanju dolaze iz citiranih državnih i stručnih poreznih izvora, a ne procjena. Svaki kalkulator prikazuje godinu na koju se brojke odnose i datum stupanja na snagu, tako da odmah možete procijeniti ažurnost. Pogledajte „Privatnost i podaci“ i „Radi potpuno offline“ ispod za način na koji se vaši podaci obrađuju.';

  @override
  String get settingsAdPrivacyTitle => 'Privatnost i oglasi';

  @override
  String get settingsAdPrivacySubtitle =>
      'Pregledajte ili promijenite svoj izbor pristanka za oglase';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Opcije privatnosti oglasa nisu dostupne na ovoj platformi.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'Za vašu regiju nije potreban izbor privatnosti oglasa.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro obuhvaća obračun plaća, konverziju valuta i svakodnevne financijske kalkulatore za Srbiju, Hrvatsku, Bosnu i Hercegovinu, Crnu Goru, Sjevernu Makedoniju, Sloveniju, Bugarsku, Albaniju i Rumunjsku. Svi podaci su izvorno navedeni i datirani — pogledajte napomenu svakog kalkulatora za detalje. Ova aplikacija pruža samo procjene, a ne stručni savjet.';

  @override
  String get paywallTitle => 'Postani Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Uklonite sve oglase u svakom kalkulatoru, po pristupačnoj mjesečnoj cijeni. Sve zemlje za obračun plaća, konverzija valuta i financijski alati ostaju besplatni u svakom slučaju.';

  @override
  String get paywallActiveMessage =>
      'Vi ste Pro korisnik — hvala vam! Oglasi su isključeni u cijeloj aplikaciji.';

  @override
  String get paywallStoreUnavailable =>
      'Trgovina trenutno nije dostupna (ovo je očekivano u razvojnim verzijama bez podešene Play Console liste). Pro će biti moguće kupiti nakon objave.';

  @override
  String get paywallProductUnavailable =>
      'Pro pretplata još nije podešena u trgovini — ovo je privremeni zaslon dok se pravi proizvod ne kreira u Play Consoleu.';

  @override
  String get paywallSubscribe => 'Pretplati se';

  @override
  String get paywallProcessing => 'Obrada…';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Kupnja nije uspjela: $error';
  }

  @override
  String get paywallRestorePurchase => 'Vrati kupnju';

  @override
  String get chartTakeHome => 'Za isplatu';

  @override
  String get chartTax => 'Porez';

  @override
  String get chartContributions => 'Doprinosi';

  @override
  String get homeRecentlyUsed => 'Nedavno korišteno';

  @override
  String get categoryLoansSavings => 'Krediti i štednja';

  @override
  String get categoryBudgetTax => 'Proračun i porezi';

  @override
  String get categoryFreelance => 'Freelancing';

  @override
  String get toolsSearchHint => 'Pretraga alata';

  @override
  String get toolsSearchNoResults => 'Nema pronađenih alata';

  @override
  String get homeLastSalaryTitle => 'Zadnji obračun plaće';

  @override
  String get homeLastSalaryEmpty => 'Još niste izračunali plaću.';

  @override
  String get homeLastSalaryCta => 'Izračunaj sada';

  @override
  String get settingsPrivacyTitle => 'Privatnost i podaci';

  @override
  String get settingsPrivacyNote =>
      'Povijest izračuna pohranjuje se samo na ovom uređaju i nikada se ne šalje niti dijeli. Brisanjem povijesti ili deinstalacijom aplikacije trajno se uklanja.';

  @override
  String get settingsClearHistory => 'Izbriši povijest';

  @override
  String get settingsClearHistorySubtitle =>
      'Ukloni sve nedavne izračune s Početne i Alata';

  @override
  String get settingsClearHistoryDialogTitle => 'Izbrisati povijest?';

  @override
  String get settingsClearHistoryDialogBody =>
      'Ovim se uklanja sva nedavna aktivnost s Početne i Alata. Ova radnja se ne može poništiti.';

  @override
  String get settingsClearHistoryDialogCancel => 'Odustani';

  @override
  String get settingsClearHistoryDialogConfirm => 'Izbriši';

  @override
  String get settingsClearHistoryDone => 'Povijest je izbrisana';

  @override
  String get commonCancel => 'Odustani';

  @override
  String get commonSave => 'Spremi';

  @override
  String get commonDelete => 'Izbriši';

  @override
  String get commonRename => 'Preimenuj';

  @override
  String get commonUndo => 'Poništi';

  @override
  String get scenarioSaveTooltip => 'Spremi ovaj izračun';

  @override
  String get scenarioSaveDialogTitle => 'Spremi izračun';

  @override
  String get scenarioNameLabel => 'Naziv';

  @override
  String get scenarioSavedConfirmation => 'Scenarij je spremljen';

  @override
  String get scenarioLimitTitle => 'Dosegnut je besplatni limit';

  @override
  String scenarioLimitBody(int limit) {
    return 'Besplatni računi mogu spremiti do $limit scenarija. Nadogradite na Pro za neograničeno spremanje, usporedbu i izvoz.';
  }

  @override
  String get scenarioLimitUpgrade => 'Nadogradi na Pro';

  @override
  String get myScenariosTitle => 'Moji scenariji';

  @override
  String myScenariosSubtitle(int count) {
    return '$count spremljeno';
  }

  @override
  String get myScenariosSubtitleEmpty => 'Nema spremljenih scenarija';

  @override
  String get myScenariosEmptyState =>
      'Spremite izračun iz bilo kojeg alata da ga vidite ovdje.';

  @override
  String get scenarioRenameDialogTitle => 'Preimenuj scenarij';

  @override
  String get scenarioDeleteDialogTitle => 'Izbrisati scenarij?';

  @override
  String get scenarioDeleteDialogBody => 'Ovo se ne može poništiti.';

  @override
  String get categoryTracking => 'Praćenje i planiranje';

  @override
  String get toolsExpenseTrackerTitle => 'Pregled troškova';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Bilježite prihode i troškove, pratite mjesečni saldo';

  @override
  String get expenseScreenTitle => 'Pregled troškova';

  @override
  String get expenseIncome => 'Prihodi';

  @override
  String get expenseExpenses => 'Troškovi';

  @override
  String get expenseBalance => 'Saldo';

  @override
  String get expenseEmptyState =>
      'Još nema transakcija ovog mjeseca. Dodirnite + za dodavanje prvog prihoda ili troška.';

  @override
  String get expenseAddIncome => 'Dodaj prihod';

  @override
  String get expenseAddExpense => 'Dodaj trošak';

  @override
  String get expenseAmount => 'Iznos';

  @override
  String get expenseCategory => 'Kategorija';

  @override
  String get expenseNote => 'Napomena (neobavezno)';

  @override
  String get expenseDate => 'Datum';

  @override
  String get expenseDeleteConfirmTitle => 'Izbrisati ovu transakciju?';

  @override
  String get expenseDeleteConfirmBody =>
      'Nakon toga ćete imati kratku priliku za poništavanje.';

  @override
  String get expenseDeletedConfirmation => 'Transakcija je izbrisana';

  @override
  String get expenseEditTransaction => 'Uredi transakciju';

  @override
  String get expenseSearchHint => 'Pretraži bilješke ili kategorije';

  @override
  String get expenseFilterAll => 'Sve';

  @override
  String get expenseSortByDate => 'Razvrstaj po datumu';

  @override
  String get expenseSortByAmount => 'Razvrstaj po iznosu';

  @override
  String get expenseNoResults => 'Nema transakcija koje odgovaraju pretrazi.';

  @override
  String expenseResultCount(int shown, int total) {
    return '$shown od $total';
  }

  @override
  String get expenseSpendingByCategory => 'Potrošnja po kategoriji';

  @override
  String get toolsRecurringTitle => 'Ponavljajuće transakcije';

  @override
  String get toolsRecurringSubtitle =>
      'Najamnina, pretplate i druga redovna plaćanja — definirajte jednom';

  @override
  String get recurringScreenTitle => 'Ponavljajuće transakcije';

  @override
  String get recurringEmptyState =>
      'Još nema ponavljajućih transakcija. Dodajte najamninu, pretplate ili druga redovna plaćanja jednom — bit će automatski knjižene ili će čekati vaš pregled, po vašem izboru.';

  @override
  String get recurringAddTitle => 'Nova ponavljajuća transakcija';

  @override
  String get recurringEditTitle => 'Uređivanje ponavljajuće transakcije';

  @override
  String get recurringFrequencyLabel => 'Ponavlja se';

  @override
  String get recurringFrequencyWeekly => 'Tjedno';

  @override
  String get recurringFrequencyMonthly => 'Mjesečno';

  @override
  String get recurringStartDateLabel => 'Počinje';

  @override
  String get recurringAutoPostLabel => 'Automatsko knjiženje';

  @override
  String get recurringAutoPostSubtitle =>
      'Isključeno: pregledajte svako pojavljivanje prije dodavanja';

  @override
  String get recurringPausedLabel => 'Pauzirano';

  @override
  String get recurringPauseAction => 'Pauziraj';

  @override
  String get recurringResumeAction => 'Nastavi';

  @override
  String get recurringDeleteConfirmTitle =>
      'Izbrisati ovu ponavljajuću transakciju?';

  @override
  String get recurringDeleteConfirmBody =>
      'Ovo zaustavlja buduća pojavljivanja. Već knjižene transakcije ostaju netaknute.';

  @override
  String recurringReviewBannerTitle(int count) {
    return '$count ponavljajućih transakcija za pregled';
  }

  @override
  String get recurringReviewPost => 'Knjiži';

  @override
  String get recurringReviewSkip => 'Preskoči';

  @override
  String get toolsRadarTitle => 'Radar fiksnih troškova';

  @override
  String get toolsRadarSubtitle =>
      'Pogledajte ukupne ponavljajuće troškove na jednom mjestu';

  @override
  String get radarScreenTitle => 'Radar fiksnih troškova';

  @override
  String get radarEmptyState =>
      'Još nema aktivnih ponavljajućih troškova. Dodajte jedan u Ponavljajućim transakcijama da biste ovdje vidjeli ukupan fiksni trošak.';

  @override
  String get radarMonthlyTotal => 'Mjesečno ukupno';

  @override
  String get radarWeeklyTotal => 'Tjedno ukupno';

  @override
  String radarNextDue(String date) {
    return 'Sljedeće: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Proračuni i ciljevi';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Postavite mjesečne limite potrošnje i pratite ciljeve štednje';

  @override
  String get budgetsScreenTitle => 'Proračuni i ciljevi';

  @override
  String get budgetsSectionCategoryBudgets => 'Proračuni po kategorijama';

  @override
  String get budgetsSectionGoals => 'Ciljevi štednje';

  @override
  String get budgetsNoLimitSet => 'Limit nije postavljen';

  @override
  String get budgetsSetLimit => 'Postavi limit';

  @override
  String get budgetsEditLimit => 'Uredi limit';

  @override
  String get budgetsMonthlyLimit => 'Mjesečni limit';

  @override
  String get budgetsOverBudget => 'Prekoračen proračun';

  @override
  String get budgetsNoBudgetsHint =>
      'Postavite mjesečni limit za bilo koju kategoriju ispod kako biste pratili potrošnju u odnosu na njega.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Ukloniti ovaj limit?';

  @override
  String get budgetsDeleteLimitConfirmBody =>
      'Možete postaviti novi u bilo kojem trenutku.';

  @override
  String get budgetsAddGoal => 'Dodaj cilj';

  @override
  String get budgetsGoalName => 'Naziv cilja';

  @override
  String get budgetsTargetAmount => 'Ciljani iznos';

  @override
  String get budgetsTargetDateOptional => 'Ciljani datum (neobavezno)';

  @override
  String get budgetsNoTargetDate => 'Bez ciljanog datuma';

  @override
  String get budgetsAddProgress => 'Dodaj napredak';

  @override
  String get budgetsProgressAmountLabel => 'Iznos za dodavanje';

  @override
  String get budgetsGoalComplete => 'Cilj ostvaren!';

  @override
  String get budgetsNoGoalsYet =>
      'Još nema ciljeva štednje. Dodajte jedan kako biste počeli pratiti napredak prema nečemu konkretnom.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Izbrisati ovaj cilj?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'Ovo se ne može poništiti.';

  @override
  String get budgetsProgressExplanation =>
      'Napredak se ažurira samo kada ga ovdje ručno dodate — ova aplikacija nema vezu s bankom, pa se ništa ne prati automatski.';

  @override
  String get expenseInsightsTitle => 'Uvidi';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Potrošnja je $percent% veća nego prošlog mjeseca ($current naspram $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Potrošnja je $percent% manja nego prošlog mjeseca ($current naspram $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Potrošnja je slična kao prošlog mjeseca ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category je vaša najveća kategorija troškova ovog mjeseca, s $percent% ukupne potrošnje.';
  }

  @override
  String get expenseExportCsv => 'Izvezi CSV';

  @override
  String get expenseExportCopied =>
      'CSV je kopiran u međuspremnik — zalijepite ga u tablicu ili bilješke';

  @override
  String get expenseExportEmpty => 'Nema transakcija ovog mjeseca za izvoz';

  @override
  String get settingsDataManagementTitle => 'Upravljanje podacima';

  @override
  String get settingsExportAllData => 'Izvezi sve podatke (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Kopirajte transakcije, scenarije, proračune i ciljeve u međuspremnik';

  @override
  String get settingsExportAllDataEmpty => 'Još nema podataka za izvoz';

  @override
  String get settingsExportAllDataDone =>
      'Svi podaci su kopirani u međuspremnik';

  @override
  String get settingsDeleteAllData => 'Izbriši sve lokalne podatke';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Trajno uklonite transakcije, scenarije, proračune i ciljeve s ovog uređaja';

  @override
  String get settingsDeleteAllDataDialog1Title =>
      'Izbrisati sve lokalne podatke?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'Ovo trajno uklanja svaku transakciju, spremljeni scenarij, proračun po kategoriji i cilj štednje pohranjen na ovom uređaju. Ovo se ne može poništiti. Vaša povijest izračuna također će biti izbrisana.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Jeste li apsolutno sigurni?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'Ovo je vaša posljednja prilika za odustajanje. Nakon toga nema načina da povratite ove podatke.';

  @override
  String get settingsDeleteAllDataConfirm => 'Izbriši sve';

  @override
  String get settingsDeleteAllDataDone => 'Svi lokalni podaci su izbrisani';

  @override
  String get settingsOfflineStatusTitle => 'Radi potpuno offline';

  @override
  String get settingsOfflineStatusBody =>
      'Ova aplikacija nema račun, sinkronizaciju u oblaku niti poslužitelj — sve što unesete ostaje samo na ovom uređaju. Tečaj konverzije valuta jedina je značajka kojoj je potrebna internetska veza; ako ste offline, koristi se posljednji poznati tečaj.';

  @override
  String get toolsInvoicesTitle => 'Računi';

  @override
  String get toolsInvoicesSubtitle =>
      'Pratite što vam klijenti duguju — plaćeno, neplaćeno i zakašnjelo';

  @override
  String get invoicesScreenTitle => 'Računi';

  @override
  String get invoicesEmptyState =>
      'Još nema računa. Dodirnite + za dodavanje prvog.';

  @override
  String get invoiceOutstanding => 'Nenaplaćeno';

  @override
  String get invoiceOverdue => 'Zakašnjelo';

  @override
  String get invoiceFilterAll => 'Svi';

  @override
  String get invoiceFilterUnpaid => 'Neplaćeno';

  @override
  String get invoiceFilterOverdue => 'Zakašnjelo';

  @override
  String get invoiceFilterPaid => 'Plaćeno';

  @override
  String get invoiceStatusPaid => 'Plaćeno';

  @override
  String get invoiceStatusUnpaid => 'Neplaćeno';

  @override
  String get invoiceStatusOverdue => 'Zakašnjelo';

  @override
  String get invoiceDueLabel => 'Rok';

  @override
  String get invoiceMarkPaid => 'Označi kao plaćeno';

  @override
  String get invoiceMarkUnpaid => 'Označi kao neplaćeno';

  @override
  String get invoiceDeleteConfirmTitle => 'Izbrisati ovaj račun?';

  @override
  String get invoiceDeleteConfirmBody => 'Ovo se ne može poništiti.';

  @override
  String get invoiceAddTitle => 'Dodaj račun';

  @override
  String get invoiceEditTitle => 'Uredi račun';

  @override
  String get invoiceClientName => 'Ime klijenta';

  @override
  String get invoiceDescription => 'Opis (neobavezno)';

  @override
  String get invoiceAmount => 'Iznos';

  @override
  String get invoiceIssueDate => 'Datum izdavanja';

  @override
  String get invoiceDueDate => 'Rok plaćanja';

  @override
  String get commonClearSearch => 'Obriši pretragu';

  @override
  String get expensePreviousMonth => 'Prethodni mjesec';

  @override
  String get expenseNextMonth => 'Sljedeći mjesec';

  @override
  String get homeExpenseTrackerTitle => 'Ovaj mjesec';

  @override
  String get homeExpenseTrackerCtaEmpty => 'Pratite svoje prihode i troškove';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'Praćeno je više valuta — dodirnite za prikaz svih';

  @override
  String get catHousing => 'Stanovanje i najam';

  @override
  String get catUtilities => 'Režije';

  @override
  String get catGroceries => 'Namirnice';

  @override
  String get catTransport => 'Prijevoz';

  @override
  String get catHealth => 'Zdravlje';

  @override
  String get catEducation => 'Obrazovanje';

  @override
  String get catEntertainment => 'Zabava';

  @override
  String get catOtherExpense => 'Ostalo';

  @override
  String get catSalary => 'Plaća';

  @override
  String get catFreelance => 'Freelance / posao';

  @override
  String get catOtherIncome => 'Ostali prihodi';
}
