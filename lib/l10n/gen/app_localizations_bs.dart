// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

  @override
  String get appName => 'Bilans';

  @override
  String get appTagline => 'Finansijski kalkulator';

  @override
  String get navHome => 'Početna';

  @override
  String get navPayroll => 'Plata';

  @override
  String get navCredit => 'Krediti';

  @override
  String get navFx => 'Kurs';

  @override
  String get navBusiness => 'Biznis';

  @override
  String get actionSave => 'Sačuvaj';

  @override
  String get actionShare => 'Podijeli';

  @override
  String get actionDelete => 'Izbriši';

  @override
  String get actionCancel => 'Otkaži';

  @override
  String get actionClose => 'Zatvori';

  @override
  String get actionDone => 'Gotovo';

  @override
  String get actionRetry => 'Pokušaj ponovo';

  @override
  String get actionEdit => 'Uredi';

  @override
  String get actionContinue => 'Nastavi';

  @override
  String get actionRemove => 'Ukloni';

  @override
  String get actionUndo => 'Poništi';

  @override
  String get actionDownloadPdf => 'Preuzmi PDF';

  @override
  String get actionRename => 'Preimenuj';

  @override
  String get actionClear => 'Očisti';

  @override
  String get commonMonthly => 'Mjesečno';

  @override
  String get commonAnnual => 'Godišnje';

  @override
  String get commonMonthsShort => 'mj.';

  @override
  String commonMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mjeseci',
      few: '$count mjeseca',
      one: '$count mjesec',
    );
    return '$_temp0';
  }

  @override
  String commonYearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godina',
      few: '$count godine',
      one: '$count godina',
    );
    return '$_temp0';
  }

  @override
  String get commonPercentPa => '% god.';

  @override
  String get commonOptional => 'neobavezno';

  @override
  String get commonSearch => 'Pretraga';

  @override
  String get commonToday => 'Danas';

  @override
  String get snackSaved => 'Sačuvano';

  @override
  String get snackDeleted => 'Izbrisano';

  @override
  String get errorGeneric => 'Nešto nije u redu. Pokušajte ponovo.';

  @override
  String get errorShare => 'Dijeljenje trenutno nije moguće.';

  @override
  String get errorOpenLink => 'Link nije moguće otvoriti.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature je dio paketa Bilans Pro';
  }

  @override
  String get countryRS => 'Srbija';

  @override
  String get countryHR => 'Hrvatska';

  @override
  String get countryBA => 'Bosna i Hercegovina';

  @override
  String get countryME => 'Crna Gora';

  @override
  String get countryMK => 'Sjeverna Makedonija';

  @override
  String get countrySI => 'Slovenija';

  @override
  String get countryBG => 'Bugarska';

  @override
  String get countryRO => 'Rumunija';

  @override
  String get systemFbih => 'Federacija BiH';

  @override
  String get systemRepublikaSrpska => 'Republika Srpska';

  @override
  String get curEUR => 'Euro';

  @override
  String get curUSD => 'Američki dolar';

  @override
  String get curCHF => 'Švicarski franak';

  @override
  String get curGBP => 'Britanska funta';

  @override
  String get curRSD => 'Srpski dinar';

  @override
  String get curBAM => 'Konvertibilna marka';

  @override
  String get curMKD => 'Makedonski denar';

  @override
  String get curRON => 'Rumunski lej';

  @override
  String get curHUF => 'Mađarska forinta';

  @override
  String get curCZK => 'Češka kruna';

  @override
  String get curPLN => 'Poljski zlot';

  @override
  String get curSEK => 'Švedska kruna';

  @override
  String get curNOK => 'Norveška kruna';

  @override
  String get curDKK => 'Danska kruna';

  @override
  String get curJPY => 'Japanski jen';

  @override
  String get curCNY => 'Kineski juan';

  @override
  String get curCAD => 'Kanadski dolar';

  @override
  String get curAUD => 'Australijski dolar';

  @override
  String get curTRY => 'Turska lira';

  @override
  String get curRUB => 'Ruska rublja';

  @override
  String get formFixErrors => 'Ispravite označena polja.';

  @override
  String get discardTitle => 'Odbaciti izmjene?';

  @override
  String get discardBody => 'Izmjene nisu sačuvane.';

  @override
  String get discardKeep => 'Nastavi uređivanje';

  @override
  String get discardAction => 'Odbaci';

  @override
  String get commonMore => 'Više opcija';

  @override
  String get errorPdf => 'PDF nije napravljen. Pokušajte ponovo.';

  @override
  String get pdfLanguageTitle => 'Jezik fakture';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + engleski';
  }

  @override
  String get onbHeadline => 'Brojke na koje se možete osloniti.';

  @override
  String get onbBody =>
      'Plate, krediti, zvanični kursevi i fakture — izračunati po pravilima vaše zemlje. Bez računa, bez praćenja.';

  @override
  String get onbCountry => 'Vaša zemlja';

  @override
  String get onbBihEntities => 'Federacija BiH i Republika Srpska';

  @override
  String get onbLanguage => 'Jezik aplikacije';

  @override
  String get onbLanguageDevice => 'Jezik uređaja';

  @override
  String get onbPrivacy => 'Vaši podaci ostaju na ovom telefonu.';

  @override
  String get homeSearchHint => 'Pretraži kalkulatore';

  @override
  String get homeSettings => 'Postavke';

  @override
  String get homeRatesTitle => 'Današnji kurs';

  @override
  String homeRatesNbs(String date) {
    return 'Srednji kurs NBS · $date';
  }

  @override
  String homeRatesEcb(String date) {
    return 'Referentni kurs ECB · $date';
  }

  @override
  String get homeRatesEmpty =>
      'Današnji zvanični kursevi pojavit će se ovdje čim budete na mreži.';

  @override
  String get homeRecent => 'Nedavno';

  @override
  String get homeSeeAll => 'Sve';

  @override
  String get homeSectionPayroll => 'Plata';

  @override
  String get homeSectionCredit => 'Krediti i štednja';

  @override
  String get homeSectionFx => 'Kursna lista';

  @override
  String get homeSectionBusiness => 'Biznis';

  @override
  String homeNoResults(String query) {
    return 'Nijedan kalkulator ne odgovara pojmu „$query”.';
  }

  @override
  String get toolPayroll => 'Bruto i neto plata';

  @override
  String get toolPayrollDesc => 'Obračun za 9 poreskih sistema';

  @override
  String get toolTeam => 'Trošak tima';

  @override
  String get toolTeamDesc => 'Mjesečni i godišnji trošak plata';

  @override
  String get toolCompare => 'Poređenje zemalja';

  @override
  String get toolCompareDesc => 'Ista plata u 9 sistema';

  @override
  String get toolLoan => 'Kredit';

  @override
  String get toolLoanDesc => 'Rata, EKS i plan otplate';

  @override
  String get toolDeposit => 'Oročena štednja';

  @override
  String get toolDepositDesc => 'Kamata i porez na kamatu';

  @override
  String get toolLoanCompare => 'Poređenje kredita';

  @override
  String get toolLoanCompareDesc => 'Do tri ponude, poredane po EKS-u';

  @override
  String get toolPrepay => 'Prijevremena otplata';

  @override
  String get toolPrepayDesc => 'Koliko kamate uštedite';

  @override
  String get toolConverter => 'Konvertor valuta';

  @override
  String get toolConverterDesc => 'Zvanični kursevi NBS i ECB';

  @override
  String get toolRateHistory => 'Historija kursa';

  @override
  String get toolRateHistoryDesc => '30, 90 i 365 dana';

  @override
  String get toolInvoices => 'Fakture';

  @override
  String get toolInvoicesDescRs => 'PDF s NBS IPS QR kodom';

  @override
  String get toolInvoicesDesc => 'Profesionalne PDF fakture';

  @override
  String get toolPausal => 'Paušal limiti';

  @override
  String get toolPausalDesc => '6 i 8 miliona dinara, uživo';

  @override
  String get toolVat => 'PDV';

  @override
  String get toolVatDesc => 'Dodavanje ili izdvajanje PDV-a';

  @override
  String get toolMargin => 'Marža i razlika u cijeni';

  @override
  String get toolMarginDesc => 'Nabavna cijena, prodajna cijena i popust';

  @override
  String get toolBreakEven => 'Tačka pokrića';

  @override
  String get toolBreakEvenDesc => 'Koliko trebate prodati';

  @override
  String get toolInvestment => 'Investicija';

  @override
  String get toolInvestmentDesc => 'NSV, ISP i period povrata';

  @override
  String recentPayroll(String country) {
    return 'Plata · $country';
  }

  @override
  String recentFromGross(String amount) {
    return 'neto od $amount bruto';
  }

  @override
  String recentFromNet(String amount) {
    return 'bruto za $amount neto';
  }

  @override
  String recentFromCost(String amount) {
    return 'bruto u budžetu $amount';
  }

  @override
  String recentLoan(String term) {
    return 'Kredit · $term';
  }

  @override
  String recentLoanSub(String eir) {
    return 'rata · EKS $eir';
  }

  @override
  String recentDeposit(String term) {
    return 'Štednja · $term';
  }

  @override
  String recentDepositSub(String rate) {
    return 'na kraju roka · $rate';
  }

  @override
  String recentVatAdd(String amount, String rate) {
    return '$amount + PDV $rate';
  }

  @override
  String recentVatExtract(String amount, String rate) {
    return 'osnovica od $amount uz $rate';
  }

  @override
  String recentMarginSub(String margin) {
    return 'cijena s PDV-om · marža $margin';
  }

  @override
  String recentBreakEvenSub(String amount) {
    return 'mjesečno · prihod $amount';
  }

  @override
  String recentInvestmentSub(String irr) {
    return 'NSV · ISP $irr';
  }

  @override
  String get historyTitle => 'Sačuvano i nedavno';

  @override
  String get historySaved => 'Sačuvano';

  @override
  String get historySavedEmpty =>
      'Dodirnite Sačuvaj na bilo kojem rezultatu da biste ga zadržali ovdje pod nazivom.';

  @override
  String get historyRecentEmpty =>
      'Završeni obračuni pojavljuju se ovdje automatski.';

  @override
  String get historyClearTitle => 'Očistiti listu nedavnih?';

  @override
  String get payTitle => 'Obračun plate';

  @override
  String get payModeGross => 'Bruto → neto';

  @override
  String get payModeNet => 'Neto → bruto';

  @override
  String get payModeCost => 'Ukupni trošak';

  @override
  String get payModeSemantic => 'Smjer obračuna';

  @override
  String get payInputGross => 'Bruto plata · mjesečno';

  @override
  String get payInputNet => 'Željena neto plata · mjesečno';

  @override
  String get payInputCost => 'Budžet poslodavca · mjesečno';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Najniža osnovica doprinosa: $amount';
  }

  @override
  String get payHelperNet => 'Iznos koji zaposleni prima';

  @override
  String get payHelperCost => 'Bruto plata sa svim doprinosima poslodavca';

  @override
  String get payResultNet => 'Neto plata';

  @override
  String get payResultGross => 'Potrebna bruto plata';

  @override
  String get payResultGrossBudget => 'Bruto plata u okviru budžeta';

  @override
  String payShareOfGross(String percent) {
    return '$percent bruto iznosa';
  }

  @override
  String payNetLine(String amount) {
    return 'Neto plata: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Ukupni trošak poslodavca: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'Na šta odlazi ukupni trošak poslodavca';

  @override
  String get segNet => 'Neto plata';

  @override
  String get segTax => 'Porez';

  @override
  String get segEmployee => 'Doprinosi zaposlenog';

  @override
  String get segEmployer => 'Doprinosi poslodavca';

  @override
  String get payBreakdown => 'Obračun';

  @override
  String get payAnnualToggle => 'Godišnje ×12';

  @override
  String get payEmployee => 'Zaposleni';

  @override
  String get payEmployer => 'Poslodavac';

  @override
  String get payGross => 'Bruto plata';

  @override
  String get payNetTotal => 'Neto plata';

  @override
  String get payTotalCost => 'Ukupni trošak plate';

  @override
  String get payNonTaxable => 'Neoporezivi iznos';

  @override
  String get payPersonalAllowance => 'Lični odbitak';

  @override
  String get payGeneralAllowance => 'Opća olakšica';

  @override
  String get payPersonalExemption => 'Lično oslobođenje';

  @override
  String get payPersonalDeduction => 'Lična olakšica';

  @override
  String get payTaxBase => 'Poreska osnovica';

  @override
  String get payIncomeTax => 'Porez na dohodak';

  @override
  String payTaxOn(String rate, String amount) {
    return '$rate na $amount';
  }

  @override
  String get paySurtax => 'Prirez';

  @override
  String payOnBase(String amount) {
    return 'na $amount';
  }

  @override
  String get payFixedMonthly => 'fiksno mjesečno';

  @override
  String payWedge(String percent) {
    return 'Poreski klin $percent';
  }

  @override
  String payRulesFrom(String date) {
    return 'Propisi od $date';
  }

  @override
  String get paySources => 'Izvori';

  @override
  String payDisclaimer(String date) {
    return 'Informativni obračun prema propisima koji vrijede od $date. Ne zamjenjuje zvanični obračun plate.';
  }

  @override
  String get payAnnualNote =>
      'Godišnji iznosi su 12 × mjesečni; godišnje poresko usklađivanje može se razlikovati.';

  @override
  String payNoteMinBase(String amount) {
    return 'Doprinosi se obračunavaju na najnižu osnovicu od $amount.';
  }

  @override
  String payNoteMaxBase(String amount) {
    return 'Doprinosi se ne obračunavaju iznad najviše osnovice od $amount.';
  }

  @override
  String payNoteRelief(String amount) {
    return 'Olakšica za niže plate smanjuje osnovicu za penzijsko na $amount.';
  }

  @override
  String get payNoteNonPositive => 'Obavezna davanja veća su od ove plate.';

  @override
  String get payEmpty =>
      'Unesite iznos za potpuni obračun — doprinose, porez i ukupni trošak poslodavca.';

  @override
  String get payErrorTooLarge => 'Iznos je prevelik za obračun.';

  @override
  String get paySystemTitle => 'Poreski sistem';

  @override
  String get paySystemProHint =>
      'Vaša zemlja je besplatna. Ostale zemlje dio su paketa Pro.';

  @override
  String get payOptions => 'Opcije';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Porez $lower / $higher · djeca $children';
  }

  @override
  String payOptionsMeSummary(String rate) {
    return 'Prirez $rate';
  }

  @override
  String payOptionsRoSummary(int count) {
    return 'Izdržavani članovi $count';
  }

  @override
  String get payOptionsRoMinWage => 'olakšica za minimalnu platu';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Fond za OSI $state';
  }

  @override
  String get payOn => 'uključen';

  @override
  String get payOff => 'isključen';

  @override
  String get payHrRates => 'Općinske stope poreza na dohodak';

  @override
  String get payHrLower => 'Niža stopa';

  @override
  String get payHrHigher => 'Viša stopa';

  @override
  String get payHrRatesHint =>
      'Određuje ih grad ili općina: 15–23% i 25–33%. Bez odluke vrijede 20% i 30%.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'Niža stopa $lowRange, viša stopa $highRange';
  }

  @override
  String get payChildren => 'Djeca';

  @override
  String get payDependents => 'Ostali izdržavani članovi';

  @override
  String get payRoDependents => 'Izdržavani članovi';

  @override
  String get payRoMinWage => 'Olakšica za minimalnu platu';

  @override
  String get payRoMinWageHint =>
      'Za zaposlene s nacionalnom minimalnom platom 200 leja je oslobođeno.';

  @override
  String get payMeSurtax => 'Stopa prireza';

  @override
  String get payMeSurtaxHint =>
      '13% u većini općina, 15% u Podgorici i na Cetinju.';

  @override
  String get payFbihDisability => 'Fond za zapošljavanje OSI 0,5%';

  @override
  String get payFbihDisabilityHint =>
      'Plaćaju ga firme koje ne zapošljavaju propisani broj osoba s invaliditetom.';

  @override
  String get itemPension => 'Penzijsko i invalidsko osiguranje';

  @override
  String get itemHealth => 'Zdravstveno osiguranje';

  @override
  String get itemUnemployment => 'Osiguranje od nezaposlenosti';

  @override
  String get itemChildProtection => 'Dječija zaštita';

  @override
  String get itemWorkInjury => 'Osiguranje od povrede na radu';

  @override
  String get itemLaborFund => 'Fond rada';

  @override
  String get itemChamber => 'Privredna komora';

  @override
  String get itemPillar1 => 'Penzijsko osiguranje, I stub';

  @override
  String get itemPillar2 => 'Penzijsko osiguranje, II stub';

  @override
  String get itemLongTermCare => 'Dugotrajna njega';

  @override
  String get itemParental => 'Roditeljska zaštita';

  @override
  String get itemCompulsoryHealth => 'Obavezni zdravstveni doprinos';

  @override
  String get itemWaterFee => 'Opća vodna naknada';

  @override
  String get itemDisasterFee => 'Naknada za zaštitu od nesreća';

  @override
  String get itemDisabilityFund => 'Fond za zapošljavanje OSI';

  @override
  String get itemSickness => 'Bolovanje i materinstvo';

  @override
  String get itemSupplementaryPension => 'Dopunsko penzijsko (UPF)';

  @override
  String get itemCas => 'CAS (penzijsko)';

  @override
  String get itemCass => 'CASS (zdravstveno)';

  @override
  String get itemCam => 'CAM (osiguranje rada)';

  @override
  String get saveTitle => 'Sačuvaj obračun';

  @override
  String get saveNameLabel => 'Naziv';

  @override
  String get saveNameHint => 'npr. Ponuda za novog radnika';

  @override
  String saveLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Besplatna verzija čuva $count obračuna.',
      few: 'Besplatna verzija čuva $count obračuna.',
      one: 'Besplatna verzija čuva $count obračun.',
    );
    return '$_temp0';
  }

  @override
  String get shareFooter => 'Izračunato u aplikaciji Bilans';

  @override
  String get sourcesTitle => 'Izvori i pretpostavke';

  @override
  String get teamTitle => 'Trošak tima';

  @override
  String get teamAdd => 'Dodaj zaposlenog';

  @override
  String get teamEdit => 'Uredi zaposlenog';

  @override
  String get teamEmptyTitle => 'Planirajte troškove plata';

  @override
  String get teamEmpty =>
      'Dodajte tim — bruto, neto i ukupni trošak poslodavca za svakoga, sabrano za mjesec i godinu. Možete kombinovati zemlje ako zapošljavate preko granice.';

  @override
  String teamMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaposlenih',
      few: '$count zaposlena',
      one: '$count zaposleni',
    );
    return '$_temp0';
  }

  @override
  String get teamNote =>
      'Svako se obračunava prema propisima svog poreskog sistema. Godišnji iznosi su 12 × mjesečni.';

  @override
  String get teamCurrenciesNote =>
      'Zbirovi su prikazani posebno za svaku valutu.';

  @override
  String get teamUnnamed => 'Bez imena';

  @override
  String get teamTotal => 'Ukupno';

  @override
  String get teamCostShort => 'ukupni trošak';

  @override
  String teamRemoveTitle(String name) {
    return 'Ukloniti $name iz tima?';
  }

  @override
  String get teamName => 'Ime';

  @override
  String get teamRole => 'Pozicija';

  @override
  String get teamRoleHint => 'npr. Programer';

  @override
  String get teamAmountError => 'Unesite iznos plate.';

  @override
  String get cmpNeedsRates =>
      'Za poređenje zemalja potrebni su današnji kursevi. Povežite se na internet jednom i bit će sačuvani za rad bez mreže.';

  @override
  String get cmpRankedByNet => 'Po neto plati';

  @override
  String get cmpRankedByCost => 'Po trošku poslodavca';

  @override
  String cmpCostLine(String cost, String wedge) {
    return 'Trošak poslodavca $cost · poreski klin $wedge';
  }

  @override
  String cmpGrossLine(String gross, String wedge) {
    return 'Bruto $gross · poreski klin $wedge';
  }

  @override
  String get cmpTaxesKey => 'Porezi i doprinosi';

  @override
  String cmpNote(String date) {
    return 'Iznosi su preračunati po zvaničnim kursevima od $date. Svaka zemlja koristi podrazumijevane postavke (bez djece, standardne lokalne stope). Poreski klin je udio ukupnog troška poslodavca koji odlazi na poreze i doprinose.';
  }

  @override
  String get payWedgeLabel => 'Poreski klin';

  @override
  String get creditTitle => 'Krediti';

  @override
  String get creditTabLoan => 'Kredit';

  @override
  String get creditTabDeposit => 'Štednja';

  @override
  String get creditTabCompare => 'Poređenje';

  @override
  String get loanAmount => 'Iznos kredita';

  @override
  String get loanRate => 'Nominalna kamatna stopa';

  @override
  String get loanTerm => 'Rok';

  @override
  String get loanFee => 'Naknada za obradu';

  @override
  String get loanMonthlyFee => 'Mjesečni troškovi';

  @override
  String get loanMonthlyFeeHint => 'Račun, osiguranje…';

  @override
  String get loanRepayment => 'Otplata';

  @override
  String get loanAnnuity => 'Jednake rate';

  @override
  String get loanLinear => 'Jednaka glavnica';

  @override
  String get loanMore => 'Više opcija';

  @override
  String get loanLess => 'Manje opcija';

  @override
  String get loanCurrency => 'Valuta';

  @override
  String get loanInstallment => 'Mjesečna rata';

  @override
  String get loanFirstInstallment => 'Prva rata';

  @override
  String get loanEir => 'EKS';

  @override
  String get loanTotalInterest => 'Ukupna kamata';

  @override
  String get loanTotal => 'Ukupno za otplatu';

  @override
  String loanTotalIncludes(String fees) {
    return 'Uključuje glavnicu, kamatu i troškove od $fees.';
  }

  @override
  String get loanEirNote =>
      'EKS je efektivna kamatna stopa sa svim troškovima, po formuli EU za potrošačke kredite.';

  @override
  String get loanByYear => 'Po godinama';

  @override
  String get loanPrincipal => 'Glavnica';

  @override
  String get loanInterest => 'Kamata';

  @override
  String loanYearShort(int n) {
    return '$n. g.';
  }

  @override
  String get loanSchedule => 'Plan otplate';

  @override
  String loanScheduleAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cijeli plan otplate · $count rata',
      few: 'Cijeli plan otplate · $count rate',
      one: 'Cijeli plan otplate · $count rata',
    );
    return '$_temp0';
  }

  @override
  String get loanColNo => 'Br.';

  @override
  String get loanColInstallment => 'Rata';

  @override
  String get loanColInterest => 'Kamata';

  @override
  String get loanColPrincipal => 'Glavnica';

  @override
  String get loanColBalance => 'Stanje duga';

  @override
  String get loanPrepayTitle => 'Prijevremena otplata';

  @override
  String loanPrepayTeaser(
    String amount,
    int month,
    String months,
    String saved,
  ) {
    return 'Uplata dodatnih $amount nakon rate $month skraćuje kredit za $months i štedi $saved kamate.';
  }

  @override
  String get loanPrepayCta => 'Izračunajte svoj scenarij';

  @override
  String get loanErrorPrincipal => 'Unesite iznos kredita.';

  @override
  String get loanErrorRate => 'Unesite kamatnu stopu između 0 i 100%.';

  @override
  String get loanErrorTerm => 'Rok mora biti između 1 i 600 mjeseci.';

  @override
  String get loanErrorFee => 'Troškovi moraju biti manji od kredita.';

  @override
  String get prepayTitle => 'Prijevremena otplata';

  @override
  String prepayIntro(String amount, String rate, String term) {
    return 'Na osnovu vašeg kredita: $amount uz $rate na $term.';
  }

  @override
  String get prepayNoLoan => 'Prvo unesite kredit na kartici Krediti.';

  @override
  String get prepayAmount => 'Dodatna uplata';

  @override
  String get prepayAfter => 'Uplaćuje se uz ratu br.';

  @override
  String get prepayMode => 'Nakon uplate';

  @override
  String get prepayShorten => 'Kraći rok';

  @override
  String get prepayLower => 'Niža rata';

  @override
  String get prepayFee => 'Naknada za prijevremenu otplatu';

  @override
  String get prepaySaved => 'Ušteda na kamati';

  @override
  String get prepayNetSaving => 'Neto ušteda nakon naknade';

  @override
  String get prepayNewTerm => 'Novi rok';

  @override
  String get prepayNewInstallment => 'Nova rata';

  @override
  String prepayMonthsSaved(String months) {
    return '$months ranije';
  }

  @override
  String get prepayPaidOff => 'Dodatna uplata zatvara cijeli preostali dug.';

  @override
  String get prepayBefore => 'Prije';

  @override
  String get prepayAfterLabel => 'Poslije';

  @override
  String get depAmount => 'Iznos štednje';

  @override
  String get depRate => 'Kamatna stopa';

  @override
  String get depTerm => 'Rok';

  @override
  String get depPayout => 'Kamata';

  @override
  String get depAtMaturity => 'Na kraju roka';

  @override
  String get depMonthly => 'Mjesečno, pripisuje se';

  @override
  String get depAnnually => 'Godišnje, pripisuje se';

  @override
  String get depTax => 'Porez na kamatu';

  @override
  String get depTaxHintRs =>
      'U Srbiji je kamata na dinarsku štednju oslobođena poreza; na deviznu štednju porez je 15%.';

  @override
  String get depTaxHint => 'Unesite porez na kamatu koji se odnosi na vas.';

  @override
  String get depContribution => 'Mjesečna uplata';

  @override
  String get depFinal => 'Na kraju roka';

  @override
  String get depGrossInterest => 'Kamata prije poreza';

  @override
  String get depTaxAmount => 'Porez na kamatu';

  @override
  String get depNetInterest => 'Neto kamata';

  @override
  String get depPaidIn => 'Uplaćeno';

  @override
  String depYield(String percent) {
    return 'Neto prinos $percent godišnje';
  }

  @override
  String get depByYear => 'Po godinama';

  @override
  String get depColYear => 'Godina';

  @override
  String get depColInterest => 'Neto kamata';

  @override
  String get depColBalance => 'Stanje';

  @override
  String get depErrorAmount => 'Unesite iznos štednje ili mjesečnu uplatu.';

  @override
  String get depErrorRate => 'Unesite kamatnu stopu između 0 i 100%.';

  @override
  String get cmpLoanIntro =>
      'Isti iznos za svaku ponudu. Najpovoljnija je ponuda s najmanjim ukupnim troškom.';

  @override
  String cmpLoanOffer(int n) {
    return 'Ponuda $n';
  }

  @override
  String get cmpLoanAdd => 'Dodaj ponudu';

  @override
  String get cmpLoanRemove => 'Ukloni ponudu';

  @override
  String get cmpLoanBest => 'Najmanji ukupni trošak';

  @override
  String cmpLoanSavesVs(String amount) {
    return '$amount jeftinije od najskuplje ponude';
  }

  @override
  String get depYieldLabel => 'Neto godišnji prinos';

  @override
  String get fxTitle => 'Kursna lista';

  @override
  String get fxTabConverter => 'Konvertor';

  @override
  String get fxTabList => 'Kursna lista';

  @override
  String fxAmount(String currency) {
    return 'Iznos u $currency';
  }

  @override
  String get fxSwap => 'Zamijeni valute';

  @override
  String fxRateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get fxSourceNbsMiddle => 'srednji kurs NBS';

  @override
  String get fxSourceNbsBuy => 'kupovni kurs NBS';

  @override
  String get fxSourceNbsSell => 'prodajni kurs NBS';

  @override
  String get fxSourceEcb => 'referentni kurs ECB';

  @override
  String get fxSourceCross => 'unakrsni kurs';

  @override
  String get fxKindMiddle => 'Srednji';

  @override
  String get fxKindBuy => 'Kupovni';

  @override
  String get fxKindSell => 'Prodajni';

  @override
  String get fxKindHint =>
      'Kupovni i prodajni kurs vrijede za konverziju dinara.';

  @override
  String fxUpdated(String date) {
    return 'Ažurirano $date';
  }

  @override
  String fxOffline(String date) {
    return 'Bez mreže · kurs od $date';
  }

  @override
  String get fxLoading => 'Ažuriranje kursa…';

  @override
  String get fxNoRates =>
      'Još nema kurseva. Povežite se na internet jednom da preuzmete današnje zvanične kurseve — nakon toga konvertor radi i bez mreže.';

  @override
  String get fxUnsupported => 'Za ovaj par ne postoji zvanični kurs.';

  @override
  String fxHistoryTitle(String from, String to, int days) {
    return '$from/$to · $days dana';
  }

  @override
  String fxHistoryDays(int days) {
    return '$days d';
  }

  @override
  String get fxHistoryError => 'Historija kursa nije dostupna bez mreže.';

  @override
  String get fxHistoryPro =>
      'Historija kursa za 30, 90 i 365 dana dio je paketa Pro.';

  @override
  String fxHistoryMinMax(String min, String max) {
    return 'min $min · maks $max';
  }

  @override
  String get fxPerUnit => 'Za 1 jedinicu valute';

  @override
  String get fxListNbs => 'Kursna lista NBS';

  @override
  String get fxListEcb => 'Referentni kursevi ECB, za 1 EUR';

  @override
  String get fxColBuy => 'Kupovni';

  @override
  String get fxColMiddle => 'Srednji';

  @override
  String get fxColSell => 'Prodajni';

  @override
  String get fxColRate => 'Kurs';

  @override
  String get fxRefresh => 'Osvježi kurs';

  @override
  String get fxPickFrom => 'Iz valute';

  @override
  String get fxPickTo => 'U valutu';

  @override
  String get fxSourcesNote =>
      'Zvanični kursevi Narodne banke Srbije putem kurs.resenje.org; referentni kursevi Evropske centralne banke putem servisa Frankfurter. Marka je vezana za euro po kursu 1,95583.';

  @override
  String get bizTitle => 'Biznis';

  @override
  String get bizProfile => 'Podaci o firmi';

  @override
  String get bizInvoices => 'Fakture';

  @override
  String get bizNewInvoice => 'Nova';

  @override
  String get bizInvoicesEmpty =>
      'Još nema faktura. Profesionalnu fakturu napravite za manje od minute.';

  @override
  String bizFreeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Preostalo je još $count besplatnih faktura',
      few: 'Preostale su još $count besplatne fakture',
      one: 'Preostala je još $count besplatna faktura',
    );
    return '$_temp0';
  }

  @override
  String get bizTools => 'Alati';

  @override
  String bizShowAll(int count) {
    return 'Prikaži sve ($count)';
  }

  @override
  String bizPausalCard(int year) {
    return 'Paušal · $year';
  }

  @override
  String get statusDraft => 'Nacrt';

  @override
  String get statusIssued => 'Čeka uplatu';

  @override
  String get statusPaid => 'Plaćena';

  @override
  String get statusCancelled => 'Stornirana';

  @override
  String get statusOverdue => 'Kasni';

  @override
  String get invNew => 'Nova faktura';

  @override
  String get invEdit => 'Izmjena fakture';

  @override
  String get invNumber => 'Broj fakture';

  @override
  String get invIssueDate => 'Datum izdavanja';

  @override
  String get invServiceDate => 'Datum isporuke';

  @override
  String get invDueDate => 'Rok plaćanja';

  @override
  String get invPlace => 'Mjesto izdavanja';

  @override
  String get invClient => 'Klijent';

  @override
  String get invClientName => 'Naziv klijenta';

  @override
  String get invClientAddress => 'Adresa';

  @override
  String get invClientCity => 'Poštanski broj i mjesto';

  @override
  String get invClientCountry => 'Država';

  @override
  String get invClientTaxId => 'Poreski broj (JIB / VAT)';

  @override
  String get invClientRegNo => 'Matični broj';

  @override
  String get invClientEmail => 'E-mail';

  @override
  String get invRecentClients => 'Nedavni klijenti';

  @override
  String get invCurrency => 'Valuta';

  @override
  String get invItems => 'Stavke';

  @override
  String get invItemDescription => 'Opis';

  @override
  String get invItemQty => 'Količina';

  @override
  String get invItemUnit => 'Jedinica';

  @override
  String get invItemUnitHint => 'kom, sat, dan…';

  @override
  String get invItemPrice => 'Cijena po jedinici';

  @override
  String get invItemVat => 'PDV %';

  @override
  String get invAddItem => 'Dodaj stavku';

  @override
  String get invRemoveItem => 'Ukloni stavku';

  @override
  String get invNote => 'Napomena';

  @override
  String get invReference => 'Poziv na broj';

  @override
  String get invReferenceHint => 'Model i broj, npr. 97 1234';

  @override
  String get invSubtotal => 'Osnovica';

  @override
  String get invVat => 'PDV';

  @override
  String get invTotal => 'Ukupno';

  @override
  String get invTotalDue => 'Ukupno za uplatu';

  @override
  String get invTotalRsd => 'Protuvrijednost u RSD';

  @override
  String invRateLine(String rate, String date) {
    return 'Srednji kurs NBS $rate na dan $date';
  }

  @override
  String get invRateFetching => 'Preuzimanje kursa NBS…';

  @override
  String get invRateUnavailable => 'Kurs NBS za ovaj datum još nije objavljen.';

  @override
  String get invRateRetry => 'Preuzmi kurs';

  @override
  String get invSaveDraft => 'Sačuvaj nacrt';

  @override
  String get invIssue => 'Izdaj fakturu';

  @override
  String get invSave => 'Sačuvaj izmjene';

  @override
  String get invMarkPaid => 'Označi kao plaćenu';

  @override
  String get invMarkUnpaid => 'Označi kao neplaćenu';

  @override
  String get invCancelInvoice => 'Storniraj fakturu';

  @override
  String get invDelete => 'Izbriši fakturu';

  @override
  String invDeleteConfirm(String number) {
    return 'Izbrisati fakturu $number? Ovo se ne može poništiti.';
  }

  @override
  String get invDuplicate => 'Dupliciraj';

  @override
  String get invProfileMissing =>
      'Prvo unesite podatke o firmi — pojavljuju se na svakoj fakturi.';

  @override
  String get invNotInVat => 'Izdavalac nije u sistemu PDV-a.';

  @override
  String get invValidWithoutStamp => 'Faktura je važeća bez pečata i potpisa.';

  @override
  String get invQrCaption => 'Skeniraj i plati (NBS IPS)';

  @override
  String get invQrHint =>
      'Klijent skenira QR kod u aplikaciji svoje banke — iznos, račun i poziv na broj popunjavaju se sami.';

  @override
  String invQrMissing(String reason) {
    return 'Nema QR koda za plaćanje: $reason';
  }

  @override
  String get invQrReasonAccount =>
      'unesite ispravan srpski račun u podacima o firmi';

  @override
  String get invQrReasonOther => 'provjerite naziv firme i poziv na broj';

  @override
  String get invDocTitle => 'Faktura';

  @override
  String get invSeller => 'Prodavac';

  @override
  String get invBuyer => 'Kupac';

  @override
  String invPaidOn(String date) {
    return 'Plaćeno $date';
  }

  @override
  String invDueOn(String date) {
    return 'Rok $date';
  }

  @override
  String get invErrorClient => 'Unesite naziv klijenta.';

  @override
  String get invErrorItems => 'Dodajte barem jednu stavku s opisom i cijenom.';

  @override
  String get invErrorNumber => 'Unesite broj fakture.';

  @override
  String get invErrorDue => 'Rok plaćanja ne može biti prije datuma izdavanja.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Faktura $number već postoji.';
  }

  @override
  String get invShare => 'Podijeli PDF';

  @override
  String get invAccount => 'Račun';

  @override
  String get invPib => 'PIB';

  @override
  String get invMb => 'MB';

  @override
  String get invReferenceLabel => 'Poziv na broj';

  @override
  String get invPlaceLabel => 'Mjesto';

  @override
  String get invColItem => 'Stavka';

  @override
  String get invColQty => 'Kol.';

  @override
  String get invColPrice => 'Cijena';

  @override
  String get invColAmount => 'Iznos';

  @override
  String get profTitle => 'Podaci o firmi';

  @override
  String get profIntro =>
      'Štampaju se na fakturama i, ako želite, na PDF izvještajima.';

  @override
  String get profName => 'Naziv firme';

  @override
  String get profAddress => 'Ulica i broj';

  @override
  String get profCity => 'Poštanski broj i mjesto';

  @override
  String get profCountry => 'Država';

  @override
  String get profTaxId => 'Poreski broj (PIB)';

  @override
  String get profRegNo => 'Matični broj (MB)';

  @override
  String get profAccount => 'Bankovni račun';

  @override
  String get profAccountHint => 'Srpski račun (160-0000000000000-00) ili IBAN';

  @override
  String get profBank => 'Banka';

  @override
  String get profEmail => 'E-mail';

  @override
  String get profPhone => 'Telefon';

  @override
  String get profVat => 'U sistemu PDV-a';

  @override
  String get profVatHint =>
      'Dodaje PDV na fakture. Kad je isključeno, na fakturi piše da niste u sistemu PDV-a.';

  @override
  String get profPaymentCode => 'Šifra plaćanja za QR kod';

  @override
  String get profPaymentCodeHint => '221 za plaćanje robe i usluga';

  @override
  String get profDueDays => 'Podrazumijevani rok plaćanja';

  @override
  String get profDueDaysSuffix => 'dana';

  @override
  String get profCurrency => 'Podrazumijevana valuta fakture';

  @override
  String get profNote => 'Podrazumijevana napomena na fakturi';

  @override
  String get profShowOnReports => 'Prikaži podatke o firmi na PDF izvještajima';

  @override
  String get profInvalidPib =>
      'Kontrolna cifra PIB-a nije ispravna — provjerite broj.';

  @override
  String get profInvalidMb => 'Kontrolna cifra matičnog broja nije ispravna.';

  @override
  String get profInvalidAccount => 'Kontrolni broj računa nije ispravan.';

  @override
  String get profSaved => 'Podaci o firmi su sačuvani';

  @override
  String get pausalTitle => 'Paušal limiti';

  @override
  String get pausalIntro =>
      'Paušalci u Srbiji gube paušalno oporezivanje iznad 6.000.000 RSD prihoda u kalendarskoj godini i moraju u sistem PDV-a iznad 8.000.000 RSD u bilo kojih 12 mjeseci.';

  @override
  String get pausalAnnual => 'Paušal limit, kalendarska godina';

  @override
  String get pausalVat => 'PDV limit, posljednjih 12 mjeseci';

  @override
  String pausalOf(String amount) {
    return 'od $amount';
  }

  @override
  String pausalLeft(String amount) {
    return 'Preostalo $amount';
  }

  @override
  String pausalProjection(String amount) {
    return 'Ovim tempom fakturisat ćete oko $amount do 31. decembra.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'Ovim tempom prelazite paušal limit prije kraja godine (oko $amount).';
  }

  @override
  String get pausalWarn => 'Iskoristili ste više od 80% ovog limita.';

  @override
  String get pausalOver => 'Limit je prekoračen — obratite se knjigovođi.';

  @override
  String pausalMissingRate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deviznih faktura nema kurs NBS i nisu uračunate.',
      few: '$count devizne fakture nemaju kurs NBS i nisu uračunate.',
      one: '$count devizna faktura nema kurs NBS i nije uračunata.',
    );
    return '$_temp0';
  }

  @override
  String get pausalSourceInvoices =>
      'Računa se iz izdatih i plaćenih faktura (po datumu isporuke) i prihoda koji dodate ispod.';

  @override
  String get pausalManual => 'Prihod izvan aplikacije';

  @override
  String get pausalManualEmpty =>
      'Dodajte fakture izdate negdje drugo ove godine kako bi zbirovi bili potpuni.';

  @override
  String get pausalManualAdd => 'Dodaj prihod';

  @override
  String get pausalManualDate => 'Datum';

  @override
  String get pausalManualAmount => 'Iznos u RSD';

  @override
  String get pausalManualNote => 'Napomena';

  @override
  String get vatTitle => 'PDV kalkulator';

  @override
  String get vatAdd => 'Dodaj PDV';

  @override
  String get vatExtract => 'Izdvoji PDV';

  @override
  String get vatAmountNet => 'Iznos bez PDV-a';

  @override
  String get vatAmountGross => 'Iznos s PDV-om';

  @override
  String get vatRate => 'Stopa PDV-a';

  @override
  String get vatOther => 'Druga';

  @override
  String get vatNet => 'Bez PDV-a';

  @override
  String get vatVat => 'PDV';

  @override
  String get vatGross => 'S PDV-om';

  @override
  String get mrgTitle => 'Marža i razlika u cijeni';

  @override
  String get mrgFromPrice => 'Nabavna i prodajna';

  @override
  String get mrgFromMarkup => 'Razlika u cijeni';

  @override
  String get mrgFromMargin => 'Marža';

  @override
  String get mrgCost => 'Nabavna cijena';

  @override
  String get mrgPrice => 'Prodajna cijena (bez PDV-a)';

  @override
  String get mrgMarkup => 'Razlika u cijeni';

  @override
  String get mrgMargin => 'Marža';

  @override
  String get mrgDiscount => 'Popust';

  @override
  String get mrgVat => 'PDV';

  @override
  String get mrgProfit => 'Bruto dobit';

  @override
  String get mrgPriceAfterDiscount => 'Cijena nakon popusta';

  @override
  String get mrgPriceWithVat => 'Cijena s PDV-om';

  @override
  String get mrgMarginHint =>
      'Marža je dobit kao udio u prodajnoj cijeni; razlika u cijeni je dobit kao udio u nabavnoj cijeni.';

  @override
  String get mrgImpossible => 'Marža od 100% ili više nije moguća.';

  @override
  String get beTitle => 'Tačka pokrića';

  @override
  String get beFixed => 'Fiksni troškovi mjesečno';

  @override
  String get bePrice => 'Cijena po jedinici';

  @override
  String get beVariable => 'Varijabilni trošak po jedinici';

  @override
  String get beTarget => 'Željena dobit mjesečno';

  @override
  String get beUnits => 'Potrebna prodaja mjesečno';

  @override
  String beUnitsValue(int count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted komada',
      few: '$formatted komada',
      one: '$formatted komad',
    );
    return '$_temp0';
  }

  @override
  String get beRevenue => 'Potreban prihod';

  @override
  String get beContribution => 'Kontribuciona marža';

  @override
  String get beImpossible =>
      'Cijena mora biti veća od varijabilnog troška po jedinici.';

  @override
  String get invsTitle => 'Analiza investicije';

  @override
  String get invsInitial => 'Početno ulaganje';

  @override
  String get invsRate => 'Diskontna stopa';

  @override
  String get invsFlows => 'Neto novčani tok po godinama';

  @override
  String invsYear(int n) {
    return 'Godina $n';
  }

  @override
  String get invsAddYear => 'Dodaj godinu';

  @override
  String get invsRemoveYear => 'Ukloni posljednju godinu';

  @override
  String get invsNpv => 'Neto sadašnja vrijednost (NSV)';

  @override
  String get invsIrr => 'Interna stopa prinosa (ISP)';

  @override
  String get invsPayback => 'Period povrata';

  @override
  String get invsDiscountedPayback => 'Diskontovani period povrata';

  @override
  String get invsPi => 'Indeks profitabilnosti';

  @override
  String invsYears(String years) {
    return '$years god.';
  }

  @override
  String get invsNever => 'Ne u ovom periodu';

  @override
  String get invsNoIrr => 'Nema ISP za ove tokove';

  @override
  String invsGood(String rate) {
    return 'Stvara vrijednost uz diskontnu stopu $rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Umanjuje vrijednost uz diskontnu stopu $rate.';
  }

  @override
  String get profSectionBusiness => 'Firma';

  @override
  String get profSectionPayment => 'Plaćanje';

  @override
  String get profSectionContact => 'Kontakt';

  @override
  String get profSectionInvoices => 'Podrazumijevano za fakture';

  @override
  String get profTaxIdGeneric => 'Identifikacioni broj';

  @override
  String get profRegNoGeneric => 'Matični broj';

  @override
  String get profNameRequired => 'Unesite naziv firme.';

  @override
  String get profPibLength => 'PIB ima 9 cifara.';

  @override
  String get profMbLength => 'Matični broj ima 8 cifara.';

  @override
  String get profInvalidAccountShape =>
      'Unesite srpski račun (160-0000000000000-00) ili IBAN.';

  @override
  String get profInvalidEmail => 'Provjerite e-mail adresu.';

  @override
  String get profInvalidPaymentCode =>
      'Šifra plaćanja ima tri cifre, npr. 221.';

  @override
  String get profPrivacy =>
      'Čuva se samo na ovom telefonu i ulazi u rezervne kopije koje izvezete.';

  @override
  String get profIban => 'IBAN za uplate iz inostranstva';

  @override
  String get profIbanHint =>
      'Štampa se na deviznim fakturama. Ostavite prazno da se koristi račun iznad u IBAN obliku.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban =>
      'Provjerite IBAN — kontrolni brojevi nisu ispravni.';

  @override
  String get profInvalidSwift => 'SWIFT/BIC kod ima 8 ili 11 znakova.';

  @override
  String get invIban => 'IBAN';

  @override
  String get invSwift => 'SWIFT/BIC';

  @override
  String get invBank => 'Banka';

  @override
  String get invSefNote =>
      'Fakture srpskom javnom sektoru — a za obveznike PDV-a i firmama u Srbiji — moraju ići i kroz SEF (e-Faktura). Bilans fakture su za klijente iz inostranstva, fizička lica i vašu evidenciju.';

  @override
  String get invRateOffline =>
      'NBS nije dostupna. Provjerite vezu — možete sačuvati sada i preuzeti kurs kasnije.';

  @override
  String get invMarkedPaid => 'Označena kao plaćena';

  @override
  String get invMarkedUnpaid => 'Označena kao neplaćena';

  @override
  String get invIssued => 'Faktura je izdata';

  @override
  String get invCancelled => 'Faktura je stornirana';

  @override
  String get invCompleteFirst =>
      'Prije izdavanja dodajte klijenta i barem jednu stavku.';

  @override
  String invCancelConfirm(String number) {
    return 'Stornirati fakturu $number?';
  }

  @override
  String get invCancelBody =>
      'Ostaje na listi, označena kao stornirana, i više se ne računa u prihod.';

  @override
  String get invRateMissingNote =>
      'Još nema kursa NBS — faktura se ne računa u paušal limite dok ga ne dobije.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'Da ostanete ispod limita, do kraja godine fakturišite najviše oko $amount mjesečno.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Prihod po mjesecima, $year.';
  }

  @override
  String get pausalFromInvoices => 'Fakture';

  @override
  String get pausalDisclaimer =>
      'Prihod se računa po datumu isporuke. Devizne fakture se preračunavaju po srednjem kursu NBS na dan izdavanja. Konačne iznose provjerite s knjigovođom.';

  @override
  String get pausalRemoveTitle => 'Ukloniti ovaj prihod?';

  @override
  String get pausalManualAmountError => 'Unesite iznos.';

  @override
  String get invsFilterAll => 'Sve';

  @override
  String get invsFilterDrafts => 'Nacrti';

  @override
  String get invsOutstanding => 'Čeka uplatu';

  @override
  String get invsSearchHint => 'Pretraga po klijentu ili broju';

  @override
  String get invsNoMatch => 'Nijedna faktura ne odgovara.';

  @override
  String get vatEmpty =>
      'Unesite iznos da biste ga podijelili na osnovicu i PDV.';

  @override
  String vatRatesNote(String country) {
    return 'Prikazane stope PDV-a važe za zemlju: $country.';
  }

  @override
  String get mrgEmpty =>
      'Unesite nabavnu cijenu i prodajnu cijenu, razliku u cijeni ili maržu.';

  @override
  String get mrgLoss => 'Po ovoj cijeni prodajete ispod nabavne cijene.';

  @override
  String get beFixedHint => 'Zakup, plate, pretplate…';

  @override
  String get beVariableHint => 'Materijal, provizije, dostava…';

  @override
  String get beEmpty =>
      'Unesite fiksne troškove, cijenu i varijabilni trošak po jedinici.';

  @override
  String get beContributionUnit => 'Doprinos po jedinici';

  @override
  String get beExplain =>
      'Svaka prodana jedinica doprinosi cijenom umanjenom za varijabilni trošak pokriću fiksnih troškova i dobiti. Iznosi su bez PDV-a.';

  @override
  String get invsFlowsHint =>
      'Neto novčani tok na kraju svake godine. Ukucajte minus za godinu u kojoj je više odliva nego priliva.';

  @override
  String get invsEmpty =>
      'Unesite ulaganje, diskontnu stopu i novčani tok za barem jednu godinu.';

  @override
  String get invsCumulative => 'Kumulativni novčani tok';

  @override
  String get invCreatedWith => 'Napravljeno u aplikaciji Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead =>
      'Svi kalkulatori, sve zemlje, neograničene fakture i PDF izvještaji. Bez reklama, bez korisničkog računa.';

  @override
  String get proFeatAllCountries => 'Obračun plate za svih 9 poreskih sistema';

  @override
  String get proFeatUnlimitedInvoices => 'Neograničen broj faktura';

  @override
  String get proFeatPdf => 'PDF izvještaji';

  @override
  String get proFeatUnlimitedSaves => 'Neograničen broj sačuvanih obračuna';

  @override
  String get proBenefitCountries =>
      'Obračun plate za svih 9 poreskih sistema i poređenje iste plate po zemljama';

  @override
  String get proBenefitTeam => 'Trošak tima: sve plate po mjesecima i godinama';

  @override
  String get proBenefitInvoices =>
      'Neograničen broj profesionalnih PDF faktura';

  @override
  String get proBenefitInvoicesRs =>
      'Neograničen broj faktura s NBS IPS QR kodom za plaćanje';

  @override
  String get proBenefitPausal =>
      'Praćenje paušal limita od 6 i 8 miliona dinara';

  @override
  String get proBenefitLoans =>
      'Poređenje ponuda za kredit i plan prijevremene otplate';

  @override
  String get proBenefitHistory => 'Historija kursa za 30, 90 i 365 dana';

  @override
  String get proBenefitInvestment =>
      'Analiza investicija: NSV, ISP i period povrata';

  @override
  String get proBenefitPdf =>
      'PDF izvještaji za plate, kredite, štednju i timove';

  @override
  String get proYearly => 'Godišnje';

  @override
  String get proMonthly => 'Mjesečno';

  @override
  String get proLifetime => 'Trajno';

  @override
  String get proPerYear => 'godišnje';

  @override
  String get proPerMonth => 'mjesečno';

  @override
  String get proOnce => 'jednokratno';

  @override
  String proSave(int percent) {
    return 'UŠTEDA $percent%';
  }

  @override
  String proTrialNote(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana besplatno, zatim godišnja naplata',
      few: '$days dana besplatno, zatim godišnja naplata',
      one: '$days dan besplatno, zatim godišnja naplata',
    );
    return '$_temp0';
  }

  @override
  String get proLifetimeNote => 'Platite jednom, Pro ostaje zauvijek';

  @override
  String proStartTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Počni besplatnu probu od $days dana',
      few: 'Počni besplatnu probu od $days dana',
      one: 'Počni besplatnu probu od $days dana',
    );
    return '$_temp0';
  }

  @override
  String get proContinue => 'Nastavi';

  @override
  String get proRestore => 'Vrati kupovinu';

  @override
  String get proRestored => 'Bilans Pro je aktivan na ovom uređaju.';

  @override
  String get proNothingToRestore =>
      'Za ovaj Google račun nije pronađena kupovina paketa Bilans Pro.';

  @override
  String get proPending =>
      'Plaćanje je na čekanju. Pro se otključava automatski čim Google Play potvrdi uplatu.';

  @override
  String get proError =>
      'Kupovina nije uspjela. Novac nije naplaćen — pokušajte ponovo.';

  @override
  String get proUnavailable =>
      'Kupovina trenutno nije dostupna. Provjerite da li je Google Play instaliran i da li ste prijavljeni, pa pokušajte ponovo.';

  @override
  String get proLegal =>
      'Pretplata se automatski obnavlja po prikazanoj cijeni dok je ne otkažete. Otkazati možete bilo kada u Google Play → Plaćanja i pretplate, najkasnije 24 sata prije obnove. Besplatna proba prelazi u plaćenu godišnju pretplatu ako je ne otkažete prije isteka.';

  @override
  String get proLegalLifetime =>
      'Jednokratna kupovina: bez pretplate i bez obnavljanja. Pro je aktivan na svakom uređaju prijavljenom na isti Google račun.';

  @override
  String get proDevSimulate => 'Simuliraj Pro (razvojna verzija)';

  @override
  String get proWelcome => 'Dobro došli u Bilans Pro';

  @override
  String get proWelcomeBody =>
      'Sve je otključano. Hvala što podržavate nezavisnu aplikaciju.';

  @override
  String get settingsPreferences => 'Postavke';

  @override
  String get settingsTheme => 'Izgled';

  @override
  String get settingsThemeSystem => 'Sistemski';

  @override
  String get settingsThemeLight => 'Svijetli';

  @override
  String get settingsThemeDark => 'Tamni';

  @override
  String get settingsYourData => 'Vaši podaci';

  @override
  String get settingsExport => 'Izvezi rezervnu kopiju';

  @override
  String get settingsImport => 'Vrati iz rezervne kopije';

  @override
  String get settingsBackupSubject => 'Bilans rezervna kopija';

  @override
  String get settingsExported => 'Rezervna kopija je spremna';

  @override
  String get settingsImportInvalid =>
      'Ta datoteka nije Bilans rezervna kopija.';

  @override
  String get settingsImportTitle => 'Vratiti ovu rezervnu kopiju?';

  @override
  String get settingsImportBody =>
      'Sve u aplikaciji bit će zamijenjeno sadržajem kopije — fakture, podaci o firmi, tim i sačuvani obračuni.';

  @override
  String get settingsImportAction => 'Vrati';

  @override
  String get settingsImported => 'Rezervna kopija je vraćena';

  @override
  String get settingsDeleteAll => 'Izbriši sve podatke';

  @override
  String get settingsDeleteTitle => 'Izbrisati sve podatke?';

  @override
  String get settingsDeleteBody =>
      'Fakture, podaci o firmi, tim, sačuvani obračuni i postavke bit će uklonjeni s ovog telefona. Ako bi vam mogli zatrebati, prvo izvezite rezervnu kopiju. Kupovina paketa Pro ostaje.';

  @override
  String get settingsDeleteAction => 'Izbriši sve';

  @override
  String get settingsDataNote =>
      'Bilans nema korisničke račune ni servere: vaši podaci postoje samo na ovom telefonu. Izvezite rezervnu kopiju da ih prenesete na novi telefon.';

  @override
  String get settingsAbout => 'O aplikaciji';

  @override
  String get settingsRate => 'Ocijenite Bilans na Google Playu';

  @override
  String get settingsContact => 'Kontakt';

  @override
  String get settingsPrivacy => 'Politika privatnosti';

  @override
  String get settingsTerms => 'Uslovi korištenja';

  @override
  String get settingsLicenses => 'Licence otvorenog koda';

  @override
  String get settingsDisclaimer =>
      'Obračuni su informativni i ne zamjenjuju stručni poreski, pravni ili finansijski savjet.';

  @override
  String get settingsProActive => 'Bilans Pro je aktivan';

  @override
  String get settingsManageSubscription => 'Upravljaj pretplatom';

  @override
  String get settingsProPitch =>
      'Sve zemlje, trošak tima, neograničene fakture, PDF izvještaji i još mnogo toga.';

  @override
  String get settingsSeePlans => 'Pogledaj pakete';

  @override
  String get proIncluded => 'Uključeno u Pro';

  @override
  String proSummaryTrial(int days, String price, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana besplatno, zatim $price $period. Otkažite bilo kada.',
      few: '$days dana besplatno, zatim $price $period. Otkažite bilo kada.',
      one: '$days dan besplatno, zatim $price $period. Otkažite bilo kada.',
    );
    return '$_temp0';
  }

  @override
  String proSummary(String price, String period) {
    return '$price $period, automatska obnova. Otkažite bilo kada.';
  }

  @override
  String proSummaryLifetime(String price) {
    return 'Jednokratno plaćanje od $price. Bez pretplate.';
  }
}
