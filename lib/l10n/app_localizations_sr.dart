// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Početna';

  @override
  String get navConvert => 'Konverzija';

  @override
  String get navSalary => 'Plata';

  @override
  String get navTools => 'Alati';

  @override
  String get navSettings => 'Podešavanja';

  @override
  String themeToggleTooltip(String mode) {
    return 'Promeni temu ($mode)';
  }

  @override
  String get themeModeSystem => 'sistemska';

  @override
  String get themeModeLight => 'svetla';

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
      'Izaberite državu i jezik da biste počeli. Ovo možete promeniti bilo kada u Podešavanjima.';

  @override
  String get onboardingCountryLabel => 'Država';

  @override
  String get onboardingPrivacyTitle => 'Vaši podaci ostaju na telefonu';

  @override
  String get onboardingPrivacyBody =>
      'Bez naloga. Bez sinhronizacije u oblaku. Bez servera. Sve što unesete — plate, troškove, fakture — ostaje samo na ovom uređaju. Konverzija valuta je jedina funkcija kojoj je potrebna internet veza; bez nje se koristi poslednji poznati kurs.';

  @override
  String get onboardingGoalTitle => 'Šta vas dovodi ovde?';

  @override
  String get onboardingGoalSubtitle =>
      'Prilagodićemo početni ekran tome — sve ostalo je i dalje na dohvat ruke.';

  @override
  String get onboardingGoalSalaryTitle => 'Plata i obračun zarade';

  @override
  String get onboardingGoalSalaryDesc =>
      'Izračunajte neto od bruto zarade za 9 zemalja';

  @override
  String get onboardingGoalExpensesTitle => 'Praćenje prihoda i troškova';

  @override
  String get onboardingGoalExpensesDesc =>
      'Beležite troškove, postavite budžete, ostvarite ciljeve štednje';

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
  String get commonSwapCurrencies => 'Zameni valute';

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
      'Unesite iznos i pritisnite Konvertuj da vidite pravi, trenutni kurs.';

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
      'To deluje neuobičajeno veliko za iznos — proverite da nije greška u kucanju.';

  @override
  String salaryTitle(String country) {
    return 'Kalkulator plate — $country';
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
    return 'Bruto zarada, $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Neto zarada, $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Unesite platu i pritisnite Izračunaj za potpuni obračun.';

  @override
  String get salaryNeto => 'Neto (za isplatu)';

  @override
  String get salaryBruto => 'Bruto (zarada)';

  @override
  String get salaryAllowance => 'Neoporezivi deo';

  @override
  String get salaryTaxableBase => 'Poreska osnovica';

  @override
  String get salaryIncomeTax => 'Porez na dohodak';

  @override
  String get salaryLocalSurtax => 'Prirez';

  @override
  String get salaryEmployeeContribTotal => 'Doprinosi zaposlenog (ukupno)';

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
      'Ovo je procena isključivo u informativne svrhe i ne predstavlja poreski, pravni ili finansijski savet. Stvarne obaveze mogu se razlikovati u zavisnosti od vaše konkretne situacije — pre donošenja odluka posavetujte se sa licenciranim knjigovođom ili nadležnom poreskom upravom.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Ovaj bruto iznos je ispod zakonom propisane minimalne osnovice za doprinose ($base). Obavezni doprinosi sami po sebi dostižu ili premašuju ovu platu, pa je iznos za isplatu nula ili negativan — ovaj nivo plate nije praktično zvanično prijaviti.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'Na ovom nivou prihoda, obavezni doprinosi i porez zajedno dostižu ili premašuju bruto platu, pa je iznos za isplatu nula ili negativan.';

  @override
  String salaryConfigError(String country) {
    return 'Nije moguće učitati poresku konfiguraciju za $country.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Unesite platu.';

  @override
  String get salaryAmountIssueInvalid => 'To ne izgleda kao ispravan broj.';

  @override
  String get salaryAmountIssueNegative => 'Plata ne može biti negativna.';

  @override
  String get salaryAmountIssueZero => 'Plata mora biti veća od nule.';

  @override
  String get salaryAmountIssueTooLarge =>
      'To deluje neuobičajeno veliko za platu — proverite da nije greška u kucanju.';

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
  String get settingsSystemDefault => 'Sistemski podrazumevano';

  @override
  String get settingsNotificationsTitle => 'Obaveštenja';

  @override
  String get notifExpenseNudgeTitle => 'Evidentiraj potrošnju';

  @override
  String get notifExpenseNudgeSubtitle =>
      'Svakodnevni večernji podsetnik da unesete današnje prihode i troškove';

  @override
  String get notifExpenseNudgeNotifTitle => 'Unesite današnju potrošnju?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Dodajte današnje prihode i troškove pre nego što zaboravite.';

  @override
  String get notifBudgetThresholdTitle => 'Upozorenja o budžetu';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Obavesti kada budžet kategorije dostigne 80% ili 100%';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent% budžeta';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'Potrošili ste $percent% budžeta za $category ovog meseca.';
  }

  @override
  String get notifInvoiceDueTitle => 'Podsetnici za fakture';

  @override
  String get notifInvoiceDueSubtitle => 'Obavesti dan pre roka dospeća fakture';

  @override
  String get notifInvoiceDueNotifTitle => 'Faktura dospeva sutra';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency dospeva sutra.';
  }

  @override
  String get notifPausalReminderTitle => 'Podsetnik za paušal (Srbija)';

  @override
  String get notifPausalReminderSubtitle =>
      'Mesečni podsetnik 15-og da prijavite paušalne obaveze';

  @override
  String get notifPausalReminderNotifTitle => 'Podsetnik za prijavu paušala';

  @override
  String get notifPausalReminderNotifBody =>
      'Ne zaboravite mesečnu prijavu i uplatu paušala.';

  @override
  String get countryRs => 'Srbija';

  @override
  String get countryHr => 'Hrvatska';

  @override
  String get countryBa => 'Bosna i Hercegovina';

  @override
  String get countryMe => 'Crna Gora';

  @override
  String get countryMk => 'Severna Makedonija';

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
  String get contribChildProtection => 'Doprinos za dečju zaštitu';

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
  String get suffixEmployee => 'zaposleni';

  @override
  String get suffixEmployer => 'poslodavac';

  @override
  String get toolsLoanSubtitle => 'Mesečna rata, rok otplate, amortizacija';

  @override
  String get toolsSavingsSubtitle => 'Složena kamata sa redovnim uplatama';

  @override
  String get toolsVatSubtitle =>
      'Dodajte ili oduzmite PDV po stopi vaše zemlje';

  @override
  String get toolsBudgetSubtitle =>
      'Podelite mesečni prihod na potrebe / želje / štednju';

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
  String get loanTermMonths => 'Rok otplate (meseci)';

  @override
  String get loanFixedPayment => 'Fiksna mesečna rata';

  @override
  String get loanErrorPrincipalRate =>
      'Unesite ispravnu glavnicu i kamatnu stopu.';

  @override
  String get loanErrorTerm => 'Unesite ispravan rok otplate u mesecima.';

  @override
  String get loanErrorPayment => 'Unesite ispravnu mesečnu ratu.';

  @override
  String get loanErrorTooLow =>
      'Ova rata je premala da bi ikada otplatila dug — ne pokriva ni kamatu koja se obračunava svakog meseca.';

  @override
  String get loanMonthlyPayment => 'Mesečna rata';

  @override
  String get loanTotalPaid => 'Ukupno plaćeno';

  @override
  String get loanTotalInterest => 'Ukupna kamata';

  @override
  String get loanNumberOfPayments => 'Broj rata';

  @override
  String get loanTimeToPayOff => 'Vreme do otplate';

  @override
  String loanMonthsCount(int months) {
    return '$months meseci';
  }

  @override
  String get savingsScreenTitle => 'Štednja i rast';

  @override
  String get savingsStartingAmount => 'Početni iznos';

  @override
  String get savingsMonthlyContribution => 'Mesečna uplata';

  @override
  String get savingsExpectedReturn => 'Očekivani godišnji prinos (%)';

  @override
  String get savingsTimeHorizon => 'Vremenski period (godine)';

  @override
  String get savingsErrorRateYears =>
      'Unesite ispravnu godišnju stopu i broj godina.';

  @override
  String get savingsFutureValue => 'Buduća vrednost';

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
  String get vatRateEditable => 'Stopa PDV-a (%) — izmenljivo za snižene stope';

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
  String get budgetMonthlyIncome => 'Mesečni neto prihod';

  @override
  String get budgetSplit => 'Podela';

  @override
  String get budgetPresetSuffix => '(potrebe/želje/štednja)';

  @override
  String get budgetNeeds => 'Potrebe';

  @override
  String get budgetWants => 'Želje';

  @override
  String get budgetSavings => 'Štednja';

  @override
  String get freelancerScreenTitle => 'Provera stvarne isplate frilensera';

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
  String get samoMixedModel => 'Model sa mešovitim troškom';

  @override
  String get samoCheaperSame => 'Ovaj model je jeftinija opcija za ovaj iznos.';

  @override
  String get samoCheaperOther =>
      'Drugi model bi proizveo manji porez za ovaj iznos — modele možete slobodno menjati svakog kvartala.';

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
  String get freelanceTaxTaxableBaseRow => 'Poreska osnovica';

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
  String get freelanceTaxVariantLabel => 'Tip';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Kategorija delatnosti';

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
      'Dopunska delatnost / penzioner';

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
    return 'Stopa od 0% poreza na dohodak važi samo do prometa od $amount $currency — iznad toga se ceo profit oporezuje progresivno, ne samo višak.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Olakšica od 80% priznatih rashoda važi samo do prihoda od $amount $currency.';
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
  String get settingsProActive => 'Pro — aktivno';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Reklame su isključene u celoj aplikaciji';

  @override
  String get settingsProSubtitleInactive =>
      'Uklonite reklame uz pristupačnu pretplatu';

  @override
  String get settingsTrustTitle => 'Zašto verovati ovoj aplikaciji?';

  @override
  String get settingsTrustBody =>
      'Podaci o zaradama, PDV-u i samooporezivanju potiču iz citiranih državnih i stručnih poreskih izvora, a ne procena. Svaki kalkulator prikazuje godinu na koju se brojke odnose i datum stupanja na snagu, tako da odmah možete proceniti ažurnost. Pogledajte „Privatnost i podaci“ i „Radi potpuno bez interneta“ ispod za način na koji se vaši podaci obrađuju.';

  @override
  String get settingsAdPrivacyTitle => 'Privatnost i reklame';

  @override
  String get settingsAdPrivacySubtitle =>
      'Pregledajte ili promenite svoj izbor pristanka za reklame';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Opcije privatnosti reklama nisu dostupne na ovoj platformi.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'Za vaš region nije potreban izbor privatnosti reklama.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro obuhvata obračun zarada, konverziju valuta i svakodnevne finansijske kalkulatore za Srbiju, Hrvatsku, Bosnu i Hercegovinu, Crnu Goru, Severnu Makedoniju, Sloveniju, Bugarsku, Albaniju i Rumuniju. Svi podaci su izvorno navedeni i datirani — pogledajte napomenu svakog kalkulatora za detalje. Ova aplikacija pruža samo procene, a ne stručni savet.';

  @override
  String get paywallTitle => 'Postani Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Uklonite sve reklame u svakom kalkulatoru, po pristupačnoj mesečnoj ceni. Sve zemlje za obračun zarada, konverzija valuta i finansijski alati ostaju besplatni u svakom slučaju.';

  @override
  String get paywallActiveMessage =>
      'Vi ste Pro korisnik — hvala vam! Reklame su isključene u celoj aplikaciji.';

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
    return 'Kupovina nije uspela: $error';
  }

  @override
  String get paywallRestorePurchase => 'Povrati kupovinu';

  @override
  String get chartTakeHome => 'Za isplatu';

  @override
  String get chartTax => 'Porez';

  @override
  String get chartContributions => 'Doprinosi';

  @override
  String get homeRecentlyUsed => 'Nedavno korišćeno';

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
  String get homeLastSalaryTitle => 'Poslednji obračun plate';

  @override
  String get homeLastSalaryEmpty => 'Još uvek niste izračunali platu.';

  @override
  String get homeLastSalaryCta => 'Izračunaj sada';

  @override
  String get settingsPrivacyTitle => 'Privatnost i podaci';

  @override
  String get settingsPrivacyNote =>
      'Istorija obračuna se čuva samo na ovom uređaju i nikada se ne šalje niti deli. Brisanjem istorije ili deinstalacijom aplikacije trajno se uklanja.';

  @override
  String get settingsClearHistory => 'Obriši istoriju';

  @override
  String get settingsClearHistorySubtitle =>
      'Ukloni sve nedavne obračune sa Početne i Alata';

  @override
  String get settingsClearHistoryDialogTitle => 'Obrisati istoriju?';

  @override
  String get settingsClearHistoryDialogBody =>
      'Ovim se uklanja sva nedavna aktivnost sa Početne i Alata. Ova radnja se ne može poništiti.';

  @override
  String get settingsClearHistoryDialogCancel => 'Otkaži';

  @override
  String get settingsClearHistoryDialogConfirm => 'Obriši';

  @override
  String get settingsClearHistoryDone => 'Istorija je obrisana';

  @override
  String get commonCancel => 'Otkaži';

  @override
  String get commonSave => 'Sačuvaj';

  @override
  String get commonDelete => 'Obriši';

  @override
  String get commonRename => 'Preimenuj';

  @override
  String get commonUndo => 'Opozovi';

  @override
  String get scenarioSaveTooltip => 'Sačuvaj ovaj obračun';

  @override
  String get scenarioSaveDialogTitle => 'Sačuvaj obračun';

  @override
  String get scenarioNameLabel => 'Naziv';

  @override
  String get scenarioSavedConfirmation => 'Scenario je sačuvan';

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
      'Sačuvajte obračun iz bilo kog alata da biste ga videli ovde.';

  @override
  String get scenarioRenameDialogTitle => 'Preimenuj scenario';

  @override
  String get scenarioDeleteDialogTitle => 'Obrisati scenario?';

  @override
  String get scenarioDeleteDialogBody => 'Ovo se ne može poništiti.';

  @override
  String get categoryTracking => 'Praćenje i planiranje';

  @override
  String get toolsExpenseTrackerTitle => 'Pregled troškova';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Beležite prihode i troškove, pratite mesečni bilans';

  @override
  String get expenseScreenTitle => 'Pregled troškova';

  @override
  String get expenseIncome => 'Prihodi';

  @override
  String get expenseExpenses => 'Troškovi';

  @override
  String get expenseBalance => 'Bilans';

  @override
  String get expenseEmptyState =>
      'Još nema transakcija ovog meseca. Dodirnite + da dodate prvi prihod ili trošak.';

  @override
  String get expenseAddIncome => 'Dodaj prihod';

  @override
  String get expenseAddExpense => 'Dodaj trošak';

  @override
  String get expenseAmount => 'Iznos';

  @override
  String get expenseCategory => 'Kategorija';

  @override
  String get expenseNote => 'Napomena (opciono)';

  @override
  String get expenseDate => 'Datum';

  @override
  String get expenseDeleteConfirmTitle => 'Obrisati ovu transakciju?';

  @override
  String get expenseDeleteConfirmBody =>
      'Imaćete kratku priliku da opozovete brisanje odmah nakon toga.';

  @override
  String get expenseDeletedConfirmation => 'Transakcija je obrisana';

  @override
  String get expenseEditTransaction => 'Izmeni transakciju';

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
      'Kirija, pretplate i druga redovna plaćanja — definišite jednom';

  @override
  String get recurringScreenTitle => 'Ponavljajuće transakcije';

  @override
  String get recurringEmptyState =>
      'Još nema ponavljajućih transakcija. Dodajte kiriju, pretplate ili druga redovna plaćanja jednom — biće automatski knjižene ili će čekati vaš pregled, po vašem izboru.';

  @override
  String get recurringAddTitle => 'Nova ponavljajuća transakcija';

  @override
  String get recurringEditTitle => 'Izmena ponavljajuće transakcije';

  @override
  String get recurringFrequencyLabel => 'Ponavlja se';

  @override
  String get recurringFrequencyWeekly => 'Nedeljno';

  @override
  String get recurringFrequencyMonthly => 'Mesečno';

  @override
  String get recurringStartDateLabel => 'Počinje';

  @override
  String get recurringAutoPostLabel => 'Automatsko knjiženje';

  @override
  String get recurringAutoPostSubtitle =>
      'Isključeno: pregledajte svako pojavljivanje pre dodavanja';

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
      'Pogledajte ukupne ponavljajuće troškove na jednom mestu';

  @override
  String get radarScreenTitle => 'Radar fiksnih troškova';

  @override
  String get radarEmptyState =>
      'Još nema aktivnih ponavljajućih troškova. Dodajte jedan u Ponavljajućim transakcijama da biste ovde videli ukupan fiksni trošak.';

  @override
  String get radarMonthlyTotal => 'Mesečno ukupno';

  @override
  String get radarWeeklyTotal => 'Nedeljno ukupno';

  @override
  String radarNextDue(String date) {
    return 'Sledeće: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Budžeti i ciljevi';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Postavite mesečne limite potrošnje i pratite ciljeve štednje';

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
  String get budgetsEditLimit => 'Izmeni limit';

  @override
  String get budgetsMonthlyLimit => 'Mesečni limit';

  @override
  String get budgetsOverBudget => 'Prekoračen budžet';

  @override
  String get budgetsNoBudgetsHint =>
      'Postavite mesečni limit za bilo koju kategoriju ispod da biste pratili potrošnju u odnosu na njega.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Ukloniti ovaj limit?';

  @override
  String get budgetsDeleteLimitConfirmBody =>
      'Možete postaviti novi u bilo kom trenutku.';

  @override
  String get budgetsAddGoal => 'Dodaj cilj';

  @override
  String get budgetsGoalName => 'Naziv cilja';

  @override
  String get budgetsTargetAmount => 'Ciljani iznos';

  @override
  String get budgetsTargetDateOptional => 'Ciljani datum (opciono)';

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
      'Još nema ciljeva štednje. Dodajte jedan da počnete da pratite napredak ka nečemu konkretnom.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Obrisati ovaj cilj?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'Ovo se ne može poništiti.';

  @override
  String get budgetsProgressExplanation =>
      'Napredak se ažurira samo kada ga ovde ručno dodate — ova aplikacija nema vezu sa bankom, tako da se ništa ne prati automatski.';

  @override
  String get expenseInsightsTitle => 'Uvidi';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Potrošnja je $percent% veća nego prošlog meseca ($current naspram $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Potrošnja je $percent% manja nego prošlog meseca ($current naspram $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Potrošnja je slična kao prošlog meseca ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category je vaša najveća kategorija troškova ovog meseca, sa $percent% ukupne potrošnje.';
  }

  @override
  String get expenseExportCsv => 'Izvezi CSV';

  @override
  String get expenseExportCopied =>
      'CSV je kopiran u privremenu memoriju — nalepite ga u tabelu ili beleške';

  @override
  String get expenseExportEmpty => 'Nema transakcija ovog meseca za izvoz';

  @override
  String get settingsDataManagementTitle => 'Upravljanje podacima';

  @override
  String get settingsExportAllData => 'Izvezi sve podatke (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Kopirajte transakcije, scenarije, budžete i ciljeve u privremenu memoriju';

  @override
  String get settingsExportAllDataEmpty => 'Još nema podataka za izvoz';

  @override
  String get settingsExportAllDataDone =>
      'Svi podaci su kopirani u privremenu memoriju';

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
      'Ovo trajno uklanja svaku transakciju, sačuvani scenario, budžet po kategoriji i cilj štednje sačuvan na ovom uređaju. Ovo se ne može poništiti. Istorija obračuna će takođe biti obrisana.';

  @override
  String get settingsDeleteAllDataDialog2Title =>
      'Da li ste apsolutno sigurni?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'Ovo je vaša poslednja prilika da otkažete. Nema načina da povratite ove podatke kasnije.';

  @override
  String get settingsDeleteAllDataConfirm => 'Obriši sve';

  @override
  String get settingsDeleteAllDataDone => 'Svi lokalni podaci su obrisani';

  @override
  String get settingsOfflineStatusTitle => 'Radi potpuno bez interneta';

  @override
  String get settingsOfflineStatusBody =>
      'Ova aplikacija nema nalog, sinhronizaciju u oblaku niti server — sve što unesete ostaje samo na ovom uređaju. Kurs konverzije valuta je jedina funkcija kojoj je potrebna internet veza; ako ste offline, koristi se poslednji poznati kurs.';

  @override
  String get toolsInvoicesTitle => 'Fakture';

  @override
  String get toolsInvoicesSubtitle =>
      'Pratite šta vam klijenti duguju — plaćeno, neplaćeno i zakasnelo';

  @override
  String get invoicesScreenTitle => 'Fakture';

  @override
  String get invoicesEmptyState =>
      'Još nema faktura. Dodirnite + da dodate prvu.';

  @override
  String get invoiceOutstanding => 'Nenaplaćeno';

  @override
  String get invoiceOverdue => 'Zakasnelo';

  @override
  String get invoiceFilterAll => 'Sve';

  @override
  String get invoiceFilterUnpaid => 'Neplaćeno';

  @override
  String get invoiceFilterOverdue => 'Zakasnelo';

  @override
  String get invoiceFilterPaid => 'Plaćeno';

  @override
  String get invoiceStatusPaid => 'Plaćeno';

  @override
  String get invoiceStatusUnpaid => 'Neplaćeno';

  @override
  String get invoiceStatusOverdue => 'Zakasnelo';

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
  String get invoiceEditTitle => 'Izmeni fakturu';

  @override
  String get invoiceClientName => 'Ime klijenta';

  @override
  String get invoiceDescription => 'Opis (opciono)';

  @override
  String get invoiceAmount => 'Iznos';

  @override
  String get invoiceIssueDate => 'Datum izdavanja';

  @override
  String get invoiceDueDate => 'Rok plaćanja';

  @override
  String get commonClearSearch => 'Obriši pretragu';

  @override
  String get expensePreviousMonth => 'Prethodni mesec';

  @override
  String get expenseNextMonth => 'Sledeći mesec';

  @override
  String get homeExpenseTrackerTitle => 'Ovaj mesec';

  @override
  String get homeExpenseTrackerCtaEmpty => 'Pratite svoje prihode i troškove';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'Praćeno je više valuta — dodirnite da vidite sve';

  @override
  String get catHousing => 'Stanovanje i kirija';

  @override
  String get catUtilities => 'Režije';

  @override
  String get catGroceries => 'Namirnice';

  @override
  String get catTransport => 'Prevoz';

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
  String get catFreelance => 'Frilens / biznis';

  @override
  String get catOtherIncome => 'Ostali prihodi';
}
