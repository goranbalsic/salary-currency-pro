// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

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
  String get themeModeSystem => 'sistemska';

  @override
  String get themeModeLight => 'svijetla';

  @override
  String get themeModeDark => 'tamna';

  @override
  String get onboardingSkip => 'Preskoči';

  @override
  String get onboardingContinue => 'Nastavi';

  @override
  String get onboardingGetStarted => 'Počni';

  @override
  String get onboardingWelcomeTitle => 'Dobrodošli';

  @override
  String get onboardingWelcomeSubtitle =>
      'Izaberite državu i jezik da počnete. Ovo možete promijeniti bilo kada u Postavkama.';

  @override
  String get onboardingCountryLabel => 'Država';

  @override
  String get onboardingPrivacyTitle => 'Vaši podaci ostaju na telefonu';

  @override
  String get onboardingPrivacyBody =>
      'Bez računa. Bez sinhronizacije u oblaku. Bez servera. Sve što unesete — plaće, troškove, fakture — ostaje samo na ovom uređaju. Konverzija valuta je jedina funkcija kojoj je potrebna internetska veza; bez nje se koristi posljednji poznati kurs.';

  @override
  String get onboardingGoalTitle => 'Šta vas dovodi ovdje?';

  @override
  String get onboardingGoalSubtitle =>
      'Prilagodit ćemo početni ekran tome — sve ostalo ostaje na dohvat ruke.';

  @override
  String get onboardingGoalSalaryTitle => 'Plaća i obračun zarade';

  @override
  String get onboardingGoalSalaryDesc =>
      'Izračunajte neto od bruto plaće za 9 zemalja';

  @override
  String get onboardingGoalExpensesTitle => 'Praćenje prihoda i troškova';

  @override
  String get onboardingGoalExpensesDesc =>
      'Bilježite troškove, postavite budžete, ostvarite ciljeve štednje';

  @override
  String get onboardingGoalBusinessTitle => 'Freelance i biznis';

  @override
  String get onboardingGoalBusinessDesc => 'Fakture, isplate i poslovni alati';

  @override
  String get commonCalculate => 'Izračunaj';

  @override
  String get commonConvert => 'Konvertuj';

  @override
  String get commonRetry => 'Pokušaj ponovo';

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
      'Unesite iznos i pritisnite Konvertuj da vidite stvarni, trenutni kurs.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Trenutni kurs iz $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Sačuvani kurs od $formatted (offline) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Unesite iznos.';

  @override
  String get convertAmountIssueInvalid => 'To ne izgleda kao ispravan broj.';

  @override
  String get convertAmountIssueNegative => 'Iznos ne može biti negativan.';

  @override
  String get convertAmountIssueZero => 'Iznos mora biti veći od nule.';

  @override
  String get convertAmountIssueTooLarge =>
      'To djeluje neuobičajeno veliko za iznos — provjerite da nije greška u kucanju.';

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
  String get salaryAllowance => 'Lični odbitak';

  @override
  String get salaryTaxableBase => 'Poreska osnovica';

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
    return 'Prirez: $rate% — podesite na stopu vaše opštine';
  }

  @override
  String get salaryDisclaimer =>
      'Ovo je procjena isključivo u informativne svrhe i ne predstavlja poreski, pravni ili finansijski savjet. Stvarne obaveze mogu se razlikovati zavisno od vaše konkretne situacije — prije donošenja odluka posavjetujte se sa licenciranim računovođom ili nadležnom poreskom upravom.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Ovaj bruto iznos je ispod zakonom propisane minimalne osnovice za doprinose ($base). Obavezni doprinosi sami dostižu ili premašuju ovu plaću, pa je iznos za isplatu nula ili negativan — ovaj nivo plaće nije praktično zvanično prijaviti.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'Na ovom nivou prihoda, obavezni doprinosi i porez zajedno dostižu ili premašuju bruto plaću, pa je iznos za isplatu nula ili negativan.';

  @override
  String salaryConfigError(String country) {
    return 'Nije moguće učitati poresku konfiguraciju za $country.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Unesite plaću.';

  @override
  String get salaryAmountIssueInvalid => 'To ne izgleda kao ispravan broj.';

  @override
  String get salaryAmountIssueNegative => 'Plaća ne može biti negativna.';

  @override
  String get salaryAmountIssueZero => 'Plaća mora biti veća od nule.';

  @override
  String get salaryAmountIssueTooLarge =>
      'To djeluje neuobičajeno veliko za plaću — provjerite da nije greška u kucanju.';

  @override
  String get toolsHubTitle => 'Finansijski alati';

  @override
  String get toolsLoanTitle => 'Krediti i dugovi';

  @override
  String get toolsSavingsTitle => 'Štednja i rast';

  @override
  String get toolsVatTitle => 'PDV kalkulator';

  @override
  String get toolsBudgetTitle => 'Planer budžeta';

  @override
  String get toolsFreelancerPayoutTitle => 'Isplata frilensera';

  @override
  String get toolsFreelanceTaxTitle => 'Samoprijava frilensera';

  @override
  String get homeQuoteOfDay => 'Citat dana';

  @override
  String get homeQuickActions => 'Brze akcije';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsAbout => 'O aplikaciji';

  @override
  String get settingsSystemDefault => 'Sistemski zadano';

  @override
  String get settingsNotificationsTitle => 'Obavještenja';

  @override
  String get notifExpenseNudgeTitle => 'Evidentiraj potrošnju';

  @override
  String get notifExpenseNudgeSubtitle =>
      'Svakodnevni večernji podsjetnik da unesete današnje prihode i troškove';

  @override
  String get notifExpenseNudgeNotifTitle => 'Unesite današnju potrošnju?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Dodajte današnje prihode i troškove prije nego što zaboravite.';

  @override
  String get notifBudgetThresholdTitle => 'Upozorenja o budžetu';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Obavijesti kada budžet kategorije dostigne 80% ili 100%';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent% budžeta';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'Potrošili ste $percent% budžeta za $category ovog mjeseca.';
  }

  @override
  String get notifInvoiceDueTitle => 'Podsjetnici za fakture';

  @override
  String get notifInvoiceDueSubtitle =>
      'Obavijesti dan prije roka dospijeća fakture';

  @override
  String get notifInvoiceDueNotifTitle => 'Faktura dospijeva sutra';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency dospijeva sutra.';
  }

  @override
  String get notifPausalReminderTitle => 'Podsjetnik za paušal (Srbija)';

  @override
  String get notifPausalReminderSubtitle =>
      'Mjesečni podsjetnik 15-og za prijavu paušalnih obaveza';

  @override
  String get notifPausalReminderNotifTitle => 'Podsjetnik za prijavu paušala';

  @override
  String get notifPausalReminderNotifBody =>
      'Ne zaboravite mjesečnu prijavu i uplatu paušala.';

  @override
  String notifPausalReminderNotifBodyWithAmount(String amount) {
    return 'Ne zaboravite mjesečnu prijavu i uplatu paušala u iznosu od $amount RSD.';
  }

  @override
  String get notifPausalLeadReminderTitle => 'Podsjeti me i 3 dana ranije';

  @override
  String get notifPausalLeadReminderSubtitle =>
      'Dodatni podsjetnik 12-og, prije glavnog 15-og';

  @override
  String get notifPausalLeadReminderNotifTitle => 'Prijava paušala za 3 dana';

  @override
  String get notifPausalLeadReminderNotifBody =>
      'Mjesečna prijava i uplata paušala dospijeva za 3 dana, 15-og u mjesecu.';

  @override
  String get settingsWidgetsTitle => 'Vidžeti na početnom ekranu';

  @override
  String get settingsWidgetsExplainer =>
      'Dodajte vidžet s početnog ekrana uređaja (dugo pritisnite prazan prostor → Vidžeti → Salary & Currency Pro) — aplikacija ga ne može dodati umjesto vas. Nakon dodavanja se sam ažurira.';

  @override
  String get settingsWidgetsPinnedPairTitle => 'Zakačeni valutni par za vidžet';

  @override
  String get homeWidgetBudgetLabel => 'Potrošeno ovog mjeseca';

  @override
  String get homeWidgetBudgetEmpty =>
      'Postavite budžet u aplikaciji da ga vidite ovdje';

  @override
  String get homeWidgetPairUnavailable =>
      'Osvježavanje nije uspjelo — prikazan je posljednji poznati kurs';

  @override
  String get settingsBusinessProfileTitle => 'Poslovni profil';

  @override
  String get settingsBusinessProfileExplainer =>
      'Koristi se na generisanim PDF fakturama i, za prihvatljive fakture u RSD, NBS IPS QR kodu za plaćanje.';

  @override
  String get businessProfileNameLabel => 'Naziv firme / izdavaoca';

  @override
  String get businessProfileAddressLabel => 'Adresa';

  @override
  String get businessProfileCityLabel => 'Grad';

  @override
  String get businessProfileBankAccountLabel => 'Broj računa (Srbija)';

  @override
  String get businessProfileBankAccountHelper =>
      'Potrebno samo za NBS IPS QR kod na RSD fakturama';

  @override
  String get businessProfilePaymentCodeLabel =>
      'Podrazumijevana šifra plaćanja (Srbija)';

  @override
  String get businessProfilePaymentCodeHelper =>
      'Trocifrena NBS šifra plaćanja, npr. 289 — potrebna samo za QR kod';

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
  String get countryRo => 'Rumunija';

  @override
  String get entityFbih => 'Federacija BiH';

  @override
  String get entityRepublikaSrpska => 'Republika Srpska';

  @override
  String get contribPio => 'PIO (penzijsko i invalidsko)';

  @override
  String get contribHealth => 'Zdravstveno osiguranje';

  @override
  String get contribUnemployment => 'Osiguranje za slučaj nezaposlenosti';

  @override
  String get contribPension => 'Penzijsko osiguranje';

  @override
  String get contribSocial => 'Socijalno osiguranje';

  @override
  String get contribChildProtection => 'Doprinos za zaštitu djece';

  @override
  String get contribHealthAndEmployment =>
      'Zdravstveno i osiguranje za zapošljavanje';

  @override
  String get contribCas => 'CAS (penzijsko osiguranje)';

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
  String get toolsSavingsSubtitle => 'Složena kamata sa redovnim uplatama';

  @override
  String get toolsVatSubtitle =>
      'Dodajte ili oduzmite PDV po stopi vaše zemlje';

  @override
  String get toolsBudgetSubtitle =>
      'Podijelite mjesečni prihod na potrebe / želje / štednju';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Strana faktura → naknade → stvarna lokalna isplata';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Porez na dohodak i doprinosi za frilensere, 9 zemalja';

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
  String get savingsTimeHorizon => 'Vremenski period (godine)';

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
  String get vatGrossAmount => 'Bruto iznos (sa PDV-om)';

  @override
  String get vatRateEditable => 'Stopa PDV-a (%) — izmjenjivo za snižene stope';

  @override
  String get vatGrossWithVat => 'Bruto (sa PDV-om)';

  @override
  String get vatAmountLabel => 'Iznos PDV-a';

  @override
  String get vatNetWithoutVat => 'Neto (bez PDV-a)';

  @override
  String vatRatesAsOf(String date) {
    return 'Standardna stopa od $date';
  }

  @override
  String get budgetScreenTitle => 'Planer budžeta';

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
  String get freelancerScreenTitle => 'Provjera stvarne isplate frilensera';

  @override
  String get freelancerInvoiceAmount => 'Iznos fakture';

  @override
  String get freelancerCurrency => 'Valuta';

  @override
  String get freelancerPlatform => 'Platforma';

  @override
  String get freelancerPlatformCustom => 'Prilagođeno';

  @override
  String get freelancerPlatformDirect => 'Direktan klijent / transfer (0%)';

  @override
  String get freelancerPlatformFee => 'Naknada platforme (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Bankarska naknada (fiksna, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Bankarska naknada (%)';

  @override
  String get freelancerPayoutCurrency => 'Valuta isplate';

  @override
  String get freelancerCalculateButton => 'Izračunaj stvarnu isplatu';

  @override
  String get freelancerErrorInvoice => 'Unesite ispravan iznos fakture.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Neočekivana greška: $error';
  }

  @override
  String get freelancerRealPayout => 'Stvarna isplata';

  @override
  String get freelancerInvoiceAmountRow => 'Iznos fakture';

  @override
  String get freelancerPlatformFeeRow => 'Naknada platforme';

  @override
  String get freelancerBankFeeRow => 'Bankarska naknada';

  @override
  String get freelancerNetForeignAmount => 'Neto iznos u stranoj valuti';

  @override
  String get samoFixedModel => 'Model sa fiksnim troškom';

  @override
  String get samoMixedModel => 'Model sa mješovitim troškom';

  @override
  String get samoCheaperSame => 'Ovaj model je jeftinija opcija za ovaj iznos.';

  @override
  String get samoCheaperOther =>
      'Drugi model bi proizveo manji porez za ovaj iznos — modele možete slobodno mijenjati svakog kvartala.';

  @override
  String get freelanceTaxScreenTitle => 'Samoprijava frilensera';

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
      'Tradicionalni zanati / taksi';

  @override
  String get freelanceTaxCategoryLabel => 'Kategorija';

  @override
  String get freelanceBaRsCategoryStandard => 'Standardni preduzetnik';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Samostalne profesije';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Dopunska djelatnost / penzioner';

  @override
  String get freelanceTaxMunicipalityLabel => 'Opština';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Podgorica / Cetinje';

  @override
  String get freelanceMeMunicipalityBudva => 'Budva';

  @override
  String get freelanceMeMunicipalityOther => 'Druga opština';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'Prag za registraciju PDV-a: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return 'Stopa od 0% poreza na dohodak vrijedi samo do prometa od $amount $currency — iznad toga se cijeli profit oporezuje progresivno, ne samo višak.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Olakšica od 80% priznatih rashoda vrijedi samo do prihoda od $amount $currency.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Pravo na popoldanski s.p. prestaje pri prihodu od $amount $currency.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'Alternativni status paušalnog preduzetnika ograničen je na $amount $currency — samo informativno, ovaj kalkulator ga ne modelira.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Još nije dostignuto';

  @override
  String get freelanceCliffStatusCrossed => 'Prekoračeno';

  @override
  String get freelanceRsInsuredElsewhereLabel =>
      'Već ste osigurani po drugoj osnovi (zdravstveni doprinos se ne plaća)';

  @override
  String freelanceRsMinPioBaseBinds(String amount) {
    return 'Doprinos za PIO kod Modela B je ograničen na minimalnu osnovicu ($amount) — ovo je situacija koju ljudi najčešće krivo procijene.';
  }

  @override
  String get freelanceComparatorTitle => 'Uporedi Model A i Model B';

  @override
  String get freelanceComparatorQuarterLabel => 'Kvartal';

  @override
  String freelanceComparatorDeadlineHint(String date) {
    return 'Rok za prijavu za ovaj kvartal: $date';
  }

  @override
  String get freelanceComparatorNeedsIncome =>
      'Unesite prihod iznad kako biste uporedili oba modela.';

  @override
  String freelanceComparatorRecommended(String model, String amount) {
    return 'Preporuka: $model — ušteda od $amount u neto prihodu.';
  }

  @override
  String get settingsProActive => 'Pro — aktivno';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Reklame su isključene u cijeloj aplikaciji';

  @override
  String get settingsProSubtitleInactive =>
      'Uklonite reklame uz pristupačnu pretplatu';

  @override
  String get settingsTrustTitle => 'Zašto vjerovati ovoj aplikaciji?';

  @override
  String get settingsTrustBody =>
      'Podaci o platama, PDV-u i samooporezivanju potiču iz citiranih državnih i stručnih poreznih izvora, a ne procjena. Svaki kalkulator prikazuje godinu na koju se brojke odnose i datum stupanja na snagu, tako da odmah možete procijeniti ažurnost. Pogledajte „Privatnost i podaci“ i „Radi potpuno bez interneta“ ispod za način na koji se vaši podaci obrađuju.';

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
      'Za vaš region nije potreban izbor privatnosti oglasa.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro obuhvata obračun plata, konverziju valuta i svakodnevne finansijske kalkulatore za Srbiju, Hrvatsku, Bosnu i Hercegovinu, Crnu Goru, Sjevernu Makedoniju, Sloveniju, Bugarsku, Albaniju i Rumuniju. Svi podaci su izvorno navedeni i datirani — pogledajte napomenu svakog kalkulatora za detalje. Ova aplikacija pruža samo procjene, a ne stručni savjet.';

  @override
  String get paywallTitle => 'Postani Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Uklonite sve reklame u svakom kalkulatoru, po pristupačnoj mjesečnoj cijeni. Sve zemlje za obračun plata, konverzija valuta i finansijski alati ostaju besplatni u svakom slučaju.';

  @override
  String get paywallActiveMessage =>
      'Vi ste Pro korisnik — hvala vam! Reklame su isključene u cijeloj aplikaciji.';

  @override
  String get paywallStoreUnavailable =>
      'Prodavnica trenutno nije dostupna (ovo je očekivano u razvojnim verzijama bez podešene Play Console liste). Pro će moći da se kupi nakon objavljivanja.';

  @override
  String get paywallProductUnavailable =>
      'Pro pretplata još nije podešena u prodavnici — ovo je privremeni ekran dok se pravi proizvod ne kreira u Play Console-u.';

  @override
  String get paywallSubscribe => 'Pretplati se';

  @override
  String get paywallProcessing => 'Obrada…';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Kupovina nije uspjela: $error';
  }

  @override
  String get paywallRestorePurchase => 'Vrati kupovinu';

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
  String get categoryBudgetTax => 'Budžetiranje i porezi';

  @override
  String get categoryFreelance => 'Frilensing';

  @override
  String get toolsSearchHint => 'Pretraga alata';

  @override
  String get toolsSearchNoResults => 'Nema pronađenih alata';

  @override
  String get homeLastSalaryTitle => 'Posljednji obračun plaće';

  @override
  String get homeLastSalaryEmpty => 'Još niste izračunali plaću.';

  @override
  String get homeLastSalaryCta => 'Izračunaj sada';

  @override
  String get settingsPrivacyTitle => 'Privatnost i podaci';

  @override
  String get settingsPrivacyNote =>
      'Historija obračuna se čuva samo na ovom uređaju i nikada se ne šalje niti dijeli. Brisanjem historije ili deinstalacijom aplikacije trajno se uklanja.';

  @override
  String get settingsClearHistory => 'Obriši historiju';

  @override
  String get settingsClearHistorySubtitle =>
      'Ukloni sve nedavne obračune s Početne i Alata';

  @override
  String get settingsClearHistoryDialogTitle => 'Obrisati historiju?';

  @override
  String get settingsClearHistoryDialogBody =>
      'Ovim se uklanja sva nedavna aktivnost s Početne i Alata. Ova radnja se ne može poništiti.';

  @override
  String get settingsClearHistoryDialogCancel => 'Otkaži';

  @override
  String get settingsClearHistoryDialogConfirm => 'Obriši';

  @override
  String get settingsClearHistoryDone => 'Historija je obrisana';

  @override
  String get commonCancel => 'Otkaži';

  @override
  String get commonSave => 'Sačuvaj';

  @override
  String get commonDelete => 'Obriši';

  @override
  String get commonRename => 'Preimenuj';

  @override
  String get commonUndo => 'Poništi';

  @override
  String get scenarioSaveTooltip => 'Sačuvaj ovaj obračun';

  @override
  String get scenarioSaveDialogTitle => 'Sačuvaj obračun';

  @override
  String get scenarioNameLabel => 'Naziv';

  @override
  String get scenarioSavedConfirmation => 'Scenarij je sačuvan';

  @override
  String get scenarioLimitTitle => 'Dostignut je besplatni limit';

  @override
  String scenarioLimitBody(int limit) {
    return 'Besplatni nalozi mogu sačuvati do $limit scenarija. Nadogradite na Pro za neograničeno čuvanje, poređenje i izvoz.';
  }

  @override
  String get scenarioLimitUpgrade => 'Nadogradi na Pro';

  @override
  String get myScenariosTitle => 'Moji scenariji';

  @override
  String myScenariosSubtitle(int count) {
    return '$count sačuvano';
  }

  @override
  String get myScenariosSubtitleEmpty => 'Nema sačuvanih scenarija';

  @override
  String get myScenariosEmptyState =>
      'Sačuvajte obračun iz bilo kojeg alata da ga vidite ovdje.';

  @override
  String get scenarioRenameDialogTitle => 'Preimenuj scenarij';

  @override
  String get scenarioDeleteDialogTitle => 'Obrisati scenarij?';

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
      'Još nema transakcija ovog mjeseca. Dodirnite + da dodate prvi prihod ili trošak.';

  @override
  String get expenseAddIncome => 'Dodaj prihod';

  @override
  String get expenseAddExpense => 'Dodaj trošak';

  @override
  String get expenseAmount => 'Iznos';

  @override
  String get expenseCategory => 'Kategorija';

  @override
  String get expenseNote => 'Napomena (opcionalno)';

  @override
  String get expenseDate => 'Datum';

  @override
  String get expenseDeleteConfirmTitle => 'Obrisati ovu transakciju?';

  @override
  String get expenseDeleteConfirmBody =>
      'Imaćete kratku priliku da poništite brisanje odmah nakon toga.';

  @override
  String get expenseDeletedConfirmation => 'Transakcija je obrisana';

  @override
  String get expenseEditTransaction => 'Uredi transakciju';

  @override
  String get expenseSearchHint => 'Pretraži napomene ili kategorije';

  @override
  String get expenseFilterAll => 'Sve';

  @override
  String get expenseSortByDate => 'Sortiraj po datumu';

  @override
  String get expenseSortByAmount => 'Sortiraj po iznosu';

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
      'Kirija, pretplate i druga redovna plaćanja — definirajte jednom';

  @override
  String get recurringScreenTitle => 'Ponavljajuće transakcije';

  @override
  String get recurringEmptyState =>
      'Još nema ponavljajućih transakcija. Dodajte kiriju, pretplate ili druga redovna plaćanja jednom — bit će automatski knjižene ili će čekati vaš pregled, po vašem izboru.';

  @override
  String get recurringAddTitle => 'Nova ponavljajuća transakcija';

  @override
  String get recurringEditTitle => 'Izmjena ponavljajuće transakcije';

  @override
  String get recurringFrequencyLabel => 'Ponavlja se';

  @override
  String get recurringFrequencyWeekly => 'Sedmično';

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
      'Obrisati ovu ponavljajuću transakciju?';

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
  String get radarWeeklyTotal => 'Sedmično ukupno';

  @override
  String radarNextDue(String date) {
    return 'Sljedeće: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Budžeti i ciljevi';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Postavite mjesečne limite potrošnje i pratite ciljeve štednje';

  @override
  String get budgetsScreenTitle => 'Budžeti i ciljevi';

  @override
  String get budgetsSectionCategoryBudgets => 'Budžeti po kategorijama';

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
  String get budgetsOverBudget => 'Prekoračen budžet';

  @override
  String get budgetsNoBudgetsHint =>
      'Postavite mjesečni limit za bilo koju kategoriju ispod da biste pratili potrošnju u odnosu na njega.';

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
  String get budgetsTargetDateOptional => 'Ciljani datum (opcionalno)';

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
      'Još nema ciljeva štednje. Dodajte jedan da počnete pratiti napredak ka nečemu konkretnom.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Obrisati ovaj cilj?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'Ovo se ne može poništiti.';

  @override
  String get budgetsProgressExplanation =>
      'Napredak se ažurira samo kada ga ovdje ručno dodate — ova aplikacija nema vezu s bankom, tako da se ništa ne prati automatski.';

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
    return '$category je vaša najveća kategorija troškova ovog mjeseca, sa $percent% ukupne potrošnje.';
  }

  @override
  String get expenseInsightHowCalculated => 'Pogledajte izračun';

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
    return '$categoryAmount ÷ $total ukupno × 100 = $percent%';
  }

  @override
  String get expenseExportCsv => 'Izvezi CSV';

  @override
  String get expenseExportCopied =>
      'CSV je kopiran u međuspremnik — nalijepite ga u tabelu ili bilješke';

  @override
  String get expenseExportEmpty => 'Nema transakcija ovog mjeseca za izvoz';

  @override
  String get settingsDataManagementTitle => 'Upravljanje podacima';

  @override
  String get settingsExportAllData => 'Izvezi sve podatke (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Kopirajte transakcije, scenarije, budžete i ciljeve u međuspremnik';

  @override
  String get settingsExportAllDataEmpty => 'Još nema podataka za izvoz';

  @override
  String get settingsExportAllDataDone =>
      'Svi podaci su kopirani u međuspremnik';

  @override
  String get settingsDeleteAllData => 'Obriši sve lokalne podatke';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Trajno uklonite transakcije, scenarije, budžete i ciljeve sa ovog uređaja';

  @override
  String get settingsDeleteAllDataDialog1Title =>
      'Obrisati sve lokalne podatke?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'Ovo trajno uklanja svaku transakciju, sačuvani scenarij, budžet po kategoriji i cilj štednje sačuvan na ovom uređaju. Ovo se ne može poništiti. Vaša historija obračuna će također biti obrisana.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Jeste li apsolutno sigurni?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'Ovo je vaša posljednja prilika da otkažete. Nema načina da povratite ove podatke nakon toga.';

  @override
  String get settingsDeleteAllDataConfirm => 'Obriši sve';

  @override
  String get settingsDeleteAllDataDone => 'Svi lokalni podaci su obrisani';

  @override
  String get settingsOfflineStatusTitle => 'Radi potpuno bez interneta';

  @override
  String get settingsOfflineStatusBody =>
      'Ova aplikacija nema račun, sinhronizaciju u oblaku niti server — sve što unesete ostaje samo na ovom uređaju. Kurs konverzije valuta je jedina funkcija kojoj je potrebna internetska veza; ako ste offline, koristi se posljednji poznati kurs.';

  @override
  String get toolsInvoicesTitle => 'Fakture';

  @override
  String get toolsInvoicesSubtitle =>
      'Pratite šta vam klijenti duguju — plaćeno, neplaćeno i zakašnjelo';

  @override
  String get invoicesScreenTitle => 'Fakture';

  @override
  String get invoicesEmptyState =>
      'Još nema faktura. Dodirnite + da dodate prvu.';

  @override
  String get invoiceOutstanding => 'Nenaplaćeno';

  @override
  String get invoiceOverdue => 'Zakašnjelo';

  @override
  String get invoiceFilterAll => 'Sve';

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
  String get invoiceDeleteConfirmTitle => 'Obrisati ovu fakturu?';

  @override
  String get invoiceDeleteConfirmBody => 'Ovo se ne može poništiti.';

  @override
  String get invoiceAddTitle => 'Dodaj fakturu';

  @override
  String get invoiceEditTitle => 'Uredi fakturu';

  @override
  String get invoiceClientName => 'Ime klijenta';

  @override
  String get invoiceDescription => 'Opis (opcionalno)';

  @override
  String get invoiceAmount => 'Iznos';

  @override
  String get invoiceIssueDate => 'Datum izdavanja';

  @override
  String get invoiceDueDate => 'Rok plaćanja';

  @override
  String get toolsPausalTrackerTitle => 'Praćenje paušala (Srbija)';

  @override
  String get toolsPausalTrackerSubtitle =>
      'Pratite promet u odnosu na paušalni cenzus i prag za PDV';

  @override
  String get pausalTrackerCeilingCardTitle =>
      'Paušalni cenzus (ova kalendarska godina)';

  @override
  String get pausalTrackerVatCardTitle =>
      'Prag za PDV (posljednjih 12 mjeseci)';

  @override
  String get pausalTrackerStateOk => 'U redu je';

  @override
  String get pausalTrackerStateWarning70 => 'Dosegnuto 70% — vrijedi pratiti';

  @override
  String get pausalTrackerStateWarning85 =>
      'Dosegnuto 85% — obratite posebnu pažnju';

  @override
  String get pausalTrackerStateWarning95 =>
      'Dosegnuto 95% — vjerovatno je uskoro potrebna akcija';

  @override
  String get pausalTrackerStateExceeded => 'Prekoračeno';

  @override
  String pausalTrackerProjection(String date) {
    return 'Po trenutnom tempu, paušalni cenzus dosegnuli biste oko $date.';
  }

  @override
  String pausalTrackerExcludedBanner(int count) {
    return '$count račun(a) isključeno — kurs nije dostupan';
  }

  @override
  String get pausalTrackerSeeBreakdown => 'Pogledajte brojke';

  @override
  String get pausalTrackerBreakdownTitle => 'Kako je ovo izračunato';

  @override
  String get pausalTrackerBreakdownExcludedHeader =>
      'Isključeno — kurs nije dostupan';

  @override
  String pausalTrackerBreakdownRateLabel(String source) {
    return 'kurs: $source';
  }

  @override
  String get pausalTrackerBreakdownExcludedReason =>
      'Za ovaj račun nije bilo moguće dobiti kurs — isključen je iz ukupnog iznosa umjesto da bude procijenjen.';

  @override
  String get pausalTrackerAssessedAmountLabel =>
      'Utvrđeni mjesečni iznos paušala';

  @override
  String get pausalTrackerAssessedAmountHint =>
      'Neobavezno — unesite iznos iz vašeg poreznog rješenja. Aplikacija ga ne može sama izračunati.';

  @override
  String get pausalTrackerAssessedAmountSaved => 'Sačuvano';

  @override
  String pausalTrackerAssessedAmountDecomposition(
    String tax,
    String pio,
    String health,
    String unemployment,
    String total,
  ) {
    return '= $tax porez + $pio PIO + $health zdravstveno + $unemployment nezaposlenost = $total osnovice utvrđene rješenjem.';
  }

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
      'Praćeno je više valuta — dodirnite da vidite sve';

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
  String get catSalary => 'Plata';

  @override
  String get catFreelance => 'Frilens / posao';

  @override
  String get catOtherIncome => 'Ostali prihodi';
}
