// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appName => 'Bilans';

  @override
  String get appTagline => 'Finančni kalkulator';

  @override
  String get navHome => 'Domov';

  @override
  String get navPayroll => 'Plača';

  @override
  String get navCredit => 'Krediti';

  @override
  String get navFx => 'Tečaji';

  @override
  String get navBusiness => 'Posel';

  @override
  String get actionSave => 'Shrani';

  @override
  String get actionShare => 'Deli';

  @override
  String get actionDelete => 'Izbriši';

  @override
  String get actionCancel => 'Prekliči';

  @override
  String get actionClose => 'Zapri';

  @override
  String get actionDone => 'Končano';

  @override
  String get actionRetry => 'Poskusi znova';

  @override
  String get actionEdit => 'Uredi';

  @override
  String get actionContinue => 'Nadaljuj';

  @override
  String get actionRemove => 'Odstrani';

  @override
  String get actionUndo => 'Razveljavi';

  @override
  String get actionDownloadPdf => 'Prenesi PDF';

  @override
  String get actionRename => 'Preimenuj';

  @override
  String get actionClear => 'Počisti';

  @override
  String get commonMonthly => 'Mesečno';

  @override
  String get commonAnnual => 'Letno';

  @override
  String get commonMonthsShort => 'mes.';

  @override
  String commonMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mesecev',
      few: '$count meseci',
      two: '$count meseca',
      one: '$count mesec',
    );
    return '$_temp0';
  }

  @override
  String commonYearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count let',
      few: '$count leta',
      two: '$count leti',
      one: '$count leto',
    );
    return '$_temp0';
  }

  @override
  String get commonPercentPa => '% letno';

  @override
  String get commonOptional => 'neobvezno';

  @override
  String get commonSearch => 'Iskanje';

  @override
  String get commonToday => 'Danes';

  @override
  String get snackSaved => 'Shranjeno';

  @override
  String get snackDeleted => 'Izbrisano';

  @override
  String get errorGeneric => 'Prišlo je do napake. Poskusite znova.';

  @override
  String get errorShare => 'Deljenje trenutno ni mogoče.';

  @override
  String get errorOpenLink => 'Povezave ni mogoče odpreti.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature je del paketa Bilans Pro';
  }

  @override
  String get countryRS => 'Srbija';

  @override
  String get countryHR => 'Hrvaška';

  @override
  String get countryBA => 'Bosna in Hercegovina';

  @override
  String get countryME => 'Črna gora';

  @override
  String get countryMK => 'Severna Makedonija';

  @override
  String get countrySI => 'Slovenija';

  @override
  String get countryBG => 'Bolgarija';

  @override
  String get countryRO => 'Romunija';

  @override
  String get systemFbih => 'Federacija BiH';

  @override
  String get systemRepublikaSrpska => 'Republika Srbska';

  @override
  String get curEUR => 'Evro';

  @override
  String get curUSD => 'Ameriški dolar';

  @override
  String get curCHF => 'Švicarski frank';

  @override
  String get curGBP => 'Britanski funt';

  @override
  String get curRSD => 'Srbski dinar';

  @override
  String get curBAM => 'Konvertibilna marka';

  @override
  String get curMKD => 'Makedonski denar';

  @override
  String get curRON => 'Romunski lev';

  @override
  String get curHUF => 'Madžarski forint';

  @override
  String get curCZK => 'Češka krona';

  @override
  String get curPLN => 'Poljski zlot';

  @override
  String get curSEK => 'Švedska krona';

  @override
  String get curNOK => 'Norveška krona';

  @override
  String get curDKK => 'Danska krona';

  @override
  String get curJPY => 'Japonski jen';

  @override
  String get curCNY => 'Kitajski juan';

  @override
  String get curCAD => 'Kanadski dolar';

  @override
  String get curAUD => 'Avstralski dolar';

  @override
  String get curTRY => 'Turška lira';

  @override
  String get curRUB => 'Ruski rubelj';

  @override
  String get formFixErrors => 'Popravite označena polja.';

  @override
  String get discardTitle => 'Zavržem spremembe?';

  @override
  String get discardBody => 'Spremembe niso shranjene.';

  @override
  String get discardKeep => 'Nadaljuj z urejanjem';

  @override
  String get discardAction => 'Zavrzi';

  @override
  String get commonMore => 'Več možnosti';

  @override
  String get errorPdf => 'PDF-ja ni bilo mogoče ustvariti. Poskusite znova.';

  @override
  String get pdfLanguageTitle => 'Jezik računa';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + angleščina';
  }

  @override
  String get onbHeadline => 'Številke, na katere se lahko zanesete.';

  @override
  String get onbBody =>
      'Plače, krediti, uradni tečaji in računi — izračunani po pravilih vaše države. Brez računa, brez sledenja.';

  @override
  String get onbCountry => 'Vaša država';

  @override
  String get onbBihEntities => 'Federacija BiH in Republika Srbska';

  @override
  String get onbLanguage => 'Jezik aplikacije';

  @override
  String get onbLanguageDevice => 'Jezik naprave';

  @override
  String get onbPrivacy => 'Vaši podatki ostanejo na tem telefonu.';

  @override
  String get homeSearchHint => 'Išči kalkulatorje';

  @override
  String get homeSettings => 'Nastavitve';

  @override
  String get homeRatesTitle => 'Današnji tečaji';

  @override
  String homeRatesNbs(String date) {
    return 'Srednji tečaj NBS · $date';
  }

  @override
  String homeRatesEcb(String date) {
    return 'Referenčni tečaj ECB · $date';
  }

  @override
  String get homeRatesEmpty =>
      'Današnji uradni tečaji se prikažejo tukaj, ko boste povezani s spletom.';

  @override
  String get homeRecent => 'Nedavno';

  @override
  String get homeSeeAll => 'Vse';

  @override
  String get homeSectionPayroll => 'Plača';

  @override
  String get homeSectionCredit => 'Krediti in varčevanje';

  @override
  String get homeSectionFx => 'Tečajnica';

  @override
  String get homeSectionBusiness => 'Posel';

  @override
  String homeNoResults(String query) {
    return 'Noben kalkulator ne ustreza iskanju »$query«.';
  }

  @override
  String get toolPayroll => 'Bruto in neto plača';

  @override
  String get toolPayrollDesc => 'Obračun za 9 davčnih sistemov';

  @override
  String get toolTeam => 'Strošek ekipe';

  @override
  String get toolTeamDesc => 'Mesečni in letni strošek plač';

  @override
  String get toolCompare => 'Primerjava držav';

  @override
  String get toolCompareDesc => 'Ista plača v 9 sistemih';

  @override
  String get toolLoan => 'Kredit';

  @override
  String get toolLoanDesc => 'Obrok, EOM in amortizacijski načrt';

  @override
  String get toolDeposit => 'Vezana vloga';

  @override
  String get toolDepositDesc => 'Obresti in davek na obresti';

  @override
  String get toolLoanCompare => 'Primerjava kreditov';

  @override
  String get toolLoanCompareDesc => 'Do tri ponudbe, razvrščene po EOM';

  @override
  String get toolPrepay => 'Predčasno odplačilo';

  @override
  String get toolPrepayDesc => 'Koliko obresti prihranite';

  @override
  String get toolConverter => 'Pretvornik valut';

  @override
  String get toolConverterDesc => 'Uradni tečaji NBS in ECB';

  @override
  String get toolRateHistory => 'Zgodovina tečaja';

  @override
  String get toolRateHistoryDesc => '30, 90 in 365 dni';

  @override
  String get toolInvoices => 'Računi';

  @override
  String get toolInvoicesDescRs => 'PDF s kodo QR NBS IPS';

  @override
  String get toolInvoicesDesc => 'Profesionalni računi v PDF';

  @override
  String get toolPausal => 'Pavšalne meje';

  @override
  String get toolPausalDesc => '6 in 8 milijonov dinarjev, sproti';

  @override
  String get toolVat => 'DDV';

  @override
  String get toolVatDesc => 'Prištevanje ali izločanje DDV';

  @override
  String get toolMargin => 'Marža in pribitek';

  @override
  String get toolMarginDesc => 'Nabavna cena, prodajna cena in popust';

  @override
  String get toolBreakEven => 'Prag donosnosti';

  @override
  String get toolBreakEvenDesc => 'Koliko morate prodati';

  @override
  String get toolInvestment => 'Naložba';

  @override
  String get toolInvestmentDesc => 'NSV, NSD in doba vračila';

  @override
  String recentPayroll(String country) {
    return 'Plača · $country';
  }

  @override
  String recentFromGross(String amount) {
    return 'neto iz $amount bruto';
  }

  @override
  String recentFromNet(String amount) {
    return 'bruto za $amount neto';
  }

  @override
  String recentFromCost(String amount) {
    return 'bruto v proračunu $amount';
  }

  @override
  String recentLoan(String term) {
    return 'Kredit · $term';
  }

  @override
  String recentLoanSub(String eir) {
    return 'obrok · EOM $eir';
  }

  @override
  String recentDeposit(String term) {
    return 'Vloga · $term';
  }

  @override
  String recentDepositSub(String rate) {
    return 'ob zapadlosti · $rate';
  }

  @override
  String recentVatAdd(String amount, String rate) {
    return '$amount + DDV $rate';
  }

  @override
  String recentVatExtract(String amount, String rate) {
    return 'osnova iz $amount po $rate';
  }

  @override
  String recentMarginSub(String margin) {
    return 'cena z DDV · marža $margin';
  }

  @override
  String recentBreakEvenSub(String amount) {
    return 'mesečno · prihodek $amount';
  }

  @override
  String recentInvestmentSub(String irr) {
    return 'NSV · NSD $irr';
  }

  @override
  String get historyTitle => 'Shranjeno in nedavno';

  @override
  String get historySaved => 'Shranjeno';

  @override
  String get historySavedEmpty =>
      'Tapnite Shrani pri katerem koli rezultatu, da ga obdržite tukaj z imenom.';

  @override
  String get historyRecentEmpty =>
      'Dokončani izračuni se tukaj prikažejo samodejno.';

  @override
  String get historyClearTitle => 'Počistim seznam nedavnih?';

  @override
  String get payTitle => 'Obračun plače';

  @override
  String get payModeGross => 'Bruto → neto';

  @override
  String get payModeNet => 'Neto → bruto';

  @override
  String get payModeCost => 'Skupni strošek';

  @override
  String get payModeSemantic => 'Smer izračuna';

  @override
  String get payInputGross => 'Bruto plača · mesečno';

  @override
  String get payInputNet => 'Želena neto plača · mesečno';

  @override
  String get payInputCost => 'Proračun delodajalca · mesečno';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Najnižja osnova za prispevke: $amount';
  }

  @override
  String get payHelperNet => 'Znesek, ki ga prejme zaposleni';

  @override
  String get payHelperCost => 'Bruto plača z vsemi prispevki delodajalca';

  @override
  String get payResultNet => 'Neto plača';

  @override
  String get payResultGross => 'Potrebna bruto plača';

  @override
  String get payResultGrossBudget => 'Bruto plača v okviru proračuna';

  @override
  String payShareOfGross(String percent) {
    return '$percent bruto zneska';
  }

  @override
  String payNetLine(String amount) {
    return 'Neto plača: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Skupni strošek delodajalca: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'Kam gre skupni strošek delodajalca';

  @override
  String get segNet => 'Neto plača';

  @override
  String get segTax => 'Davek';

  @override
  String get segEmployee => 'Prispevki delojemalca';

  @override
  String get segEmployer => 'Prispevki delodajalca';

  @override
  String get payBreakdown => 'Obračun';

  @override
  String get payAnnualToggle => 'Letno ×12';

  @override
  String get payEmployee => 'Delojemalec';

  @override
  String get payEmployer => 'Delodajalec';

  @override
  String get payGross => 'Bruto plača';

  @override
  String get payNetTotal => 'Neto plača';

  @override
  String get payTotalCost => 'Skupni strošek plače';

  @override
  String get payNonTaxable => 'Neobdavčeni znesek';

  @override
  String get payPersonalAllowance => 'Osebna olajšava';

  @override
  String get payGeneralAllowance => 'Splošna olajšava';

  @override
  String get payPersonalExemption => 'Osebna oprostitev';

  @override
  String get payPersonalDeduction => 'Osebni odbitek';

  @override
  String get payTaxBase => 'Davčna osnova';

  @override
  String get payIncomeTax => 'Dohodnina';

  @override
  String payTaxOn(String rate, String amount) {
    return '$rate od $amount';
  }

  @override
  String get paySurtax => 'Občinski prirez';

  @override
  String payOnBase(String amount) {
    return 'od $amount';
  }

  @override
  String get payFixedMonthly => 'fiksno mesečno';

  @override
  String payWedge(String percent) {
    return 'Davčni primež $percent';
  }

  @override
  String payRulesFrom(String date) {
    return 'Predpisi od $date';
  }

  @override
  String get paySources => 'Viri';

  @override
  String payDisclaimer(String date) {
    return 'Informativni izračun po predpisih, veljavnih od $date. Ne nadomešča uradnega obračuna plače.';
  }

  @override
  String get payAnnualNote =>
      'Letni zneski so 12 × mesečni; letni poračun dohodnine se lahko razlikuje.';

  @override
  String payNoteMinBase(String amount) {
    return 'Prispevki se obračunajo od najnižje osnove $amount.';
  }

  @override
  String payNoteMaxBase(String amount) {
    return 'Nad najvišjo osnovo $amount se prispevki ne obračunajo.';
  }

  @override
  String payNoteRelief(String amount) {
    return 'Olajšava za nižje plače zniža osnovo za pokojninski prispevek na $amount.';
  }

  @override
  String get payNoteNonPositive => 'Obvezne dajatve presegajo to plačo.';

  @override
  String get payEmpty =>
      'Vnesite znesek za celoten obračun — prispevke, davek in skupni strošek delodajalca.';

  @override
  String get payErrorTooLarge => 'Znesek je prevelik za izračun.';

  @override
  String get paySystemTitle => 'Davčni sistem';

  @override
  String get paySystemProHint =>
      'Vaša država je brezplačna. Druge države so del paketa Pro.';

  @override
  String get payOptions => 'Možnosti';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Davek $lower / $higher · otroci $children';
  }

  @override
  String payOptionsMeSummary(String rate) {
    return 'Prirez $rate';
  }

  @override
  String payOptionsRoSummary(int count) {
    return 'Vzdrževani člani $count';
  }

  @override
  String get payOptionsRoMinWage => 'olajšava za minimalno plačo';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Sklad za invalide $state';
  }

  @override
  String get payOn => 'vklopljen';

  @override
  String get payOff => 'izklopljen';

  @override
  String get payHrRates => 'Občinske stopnje davka od dohodka';

  @override
  String get payHrLower => 'Nižja stopnja';

  @override
  String get payHrHigher => 'Višja stopnja';

  @override
  String get payHrRatesHint =>
      'Določi jih mesto ali občina: 15–23 % in 25–33 %. Brez odločitve veljata 20 % in 30 %.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'Nižja stopnja $lowRange, višja stopnja $highRange';
  }

  @override
  String get payChildren => 'Otroci';

  @override
  String get payDependents => 'Drugi vzdrževani člani';

  @override
  String get payRoDependents => 'Vzdrževani člani';

  @override
  String get payRoMinWage => 'Olajšava za minimalno plačo';

  @override
  String get payRoMinWageHint =>
      'Za zaposlene z nacionalno minimalno plačo je 200 levov oproščenih.';

  @override
  String get payMeSurtax => 'Stopnja prireza';

  @override
  String get payMeSurtaxHint =>
      '13 % v večini občin, 15 % v Podgorici in na Cetinju.';

  @override
  String get payFbihDisability => 'Sklad za zaposlovanje invalidov 0,5 %';

  @override
  String get payFbihDisabilityHint =>
      'Plačujejo ga podjetja, ki ne zaposlujejo predpisanega deleža invalidov.';

  @override
  String get itemPension => 'Pokojninsko in invalidsko zavarovanje';

  @override
  String get itemHealth => 'Zdravstveno zavarovanje';

  @override
  String get itemUnemployment => 'Zavarovanje za primer brezposelnosti';

  @override
  String get itemChildProtection => 'Otroško varstvo';

  @override
  String get itemWorkInjury => 'Zavarovanje za poškodbe pri delu';

  @override
  String get itemLaborFund => 'Sklad dela';

  @override
  String get itemChamber => 'Gospodarska zbornica';

  @override
  String get itemPillar1 => 'Pokojninsko zavarovanje, I. steber';

  @override
  String get itemPillar2 => 'Pokojninsko zavarovanje, II. steber';

  @override
  String get itemLongTermCare => 'Dolgotrajna oskrba';

  @override
  String get itemParental => 'Starševsko varstvo';

  @override
  String get itemCompulsoryHealth => 'Obvezni zdravstveni prispevek';

  @override
  String get itemWaterFee => 'Splošna vodna pristojbina';

  @override
  String get itemDisasterFee => 'Pristojbina za zaščito pred nesrečami';

  @override
  String get itemDisabilityFund => 'Sklad za zaposlovanje invalidov';

  @override
  String get itemSickness => 'Bolezen in materinstvo';

  @override
  String get itemSupplementaryPension => 'Dodatno pokojninsko (UPF)';

  @override
  String get itemCas => 'CAS (pokojninsko)';

  @override
  String get itemCass => 'CASS (zdravstveno)';

  @override
  String get itemCam => 'CAM (zavarovanje dela)';

  @override
  String get saveTitle => 'Shrani izračun';

  @override
  String get saveNameLabel => 'Ime';

  @override
  String get saveNameHint => 'npr. Ponudba za novega sodelavca';

  @override
  String saveLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Brezplačna različica hrani $count izračunov.',
      few: 'Brezplačna različica hrani $count izračune.',
      two: 'Brezplačna različica hrani $count izračuna.',
      one: 'Brezplačna različica hrani $count izračun.',
    );
    return '$_temp0';
  }

  @override
  String get shareFooter => 'Izračunano z aplikacijo Bilans';

  @override
  String get sourcesTitle => 'Viri in predpostavke';

  @override
  String get teamTitle => 'Strošek ekipe';

  @override
  String get teamAdd => 'Dodaj zaposlenega';

  @override
  String get teamEdit => 'Uredi zaposlenega';

  @override
  String get teamEmptyTitle => 'Načrtujte stroške plač';

  @override
  String get teamEmpty =>
      'Dodajte ekipo — bruto, neto in skupni strošek delodajalca za vsakogar, seštet za mesec in leto. Države lahko kombinirate, če zaposlujete čez mejo.';

  @override
  String teamMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zaposlenih',
      few: '$count zaposleni',
      two: '$count zaposlena',
      one: '$count zaposleni',
    );
    return '$_temp0';
  }

  @override
  String get teamNote =>
      'Vsak se obračuna po predpisih svojega davčnega sistema. Letni zneski so 12 × mesečni.';

  @override
  String get teamCurrenciesNote => 'Vsote so prikazane ločeno za vsako valuto.';

  @override
  String get teamUnnamed => 'Brez imena';

  @override
  String get teamTotal => 'Skupaj';

  @override
  String get teamCostShort => 'skupni strošek';

  @override
  String teamRemoveTitle(String name) {
    return 'Odstranim osebo $name iz ekipe?';
  }

  @override
  String get teamName => 'Ime';

  @override
  String get teamRole => 'Delovno mesto';

  @override
  String get teamRoleHint => 'npr. Razvijalec';

  @override
  String get teamAmountError => 'Vnesite znesek plače.';

  @override
  String get cmpNeedsRates =>
      'Za primerjavo držav so potrebni današnji tečaji. Enkrat se povežite s spletom in shranjeni bodo za uporabo brez povezave.';

  @override
  String get cmpRankedByNet => 'Po neto plači';

  @override
  String get cmpRankedByCost => 'Po strošku delodajalca';

  @override
  String cmpCostLine(String cost, String wedge) {
    return 'Strošek delodajalca $cost · davčni primež $wedge';
  }

  @override
  String cmpGrossLine(String gross, String wedge) {
    return 'Bruto $gross · davčni primež $wedge';
  }

  @override
  String get cmpTaxesKey => 'Davki in prispevki';

  @override
  String cmpNote(String date) {
    return 'Zneski so preračunani po uradnih tečajih z dne $date. Vsaka država uporablja privzete nastavitve (brez otrok, standardne lokalne stopnje). Davčni primež je delež skupnega stroška delodajalca, ki gre za davke in prispevke.';
  }

  @override
  String get payWedgeLabel => 'Davčni primež';

  @override
  String get creditTitle => 'Krediti';

  @override
  String get creditTabLoan => 'Kredit';

  @override
  String get creditTabDeposit => 'Varčevanje';

  @override
  String get creditTabCompare => 'Primerjava';

  @override
  String get loanAmount => 'Znesek kredita';

  @override
  String get loanRate => 'Nominalna obrestna mera';

  @override
  String get loanTerm => 'Doba';

  @override
  String get loanFee => 'Stroški odobritve';

  @override
  String get loanMonthlyFee => 'Mesečni stroški';

  @override
  String get loanMonthlyFeeHint => 'Račun, zavarovanje…';

  @override
  String get loanRepayment => 'Odplačevanje';

  @override
  String get loanAnnuity => 'Enaki obroki';

  @override
  String get loanLinear => 'Enaka glavnica';

  @override
  String get loanMore => 'Več možnosti';

  @override
  String get loanLess => 'Manj možnosti';

  @override
  String get loanCurrency => 'Valuta';

  @override
  String get loanInstallment => 'Mesečni obrok';

  @override
  String get loanFirstInstallment => 'Prvi obrok';

  @override
  String get loanEir => 'EOM';

  @override
  String get loanTotalInterest => 'Skupne obresti';

  @override
  String get loanTotal => 'Skupaj za odplačilo';

  @override
  String loanTotalIncludes(String fees) {
    return 'Vključuje glavnico, obresti in stroške v višini $fees.';
  }

  @override
  String get loanEirNote =>
      'EOM je efektivna obrestna mera z vsemi stroški, po formuli EU za potrošniške kredite.';

  @override
  String get loanByYear => 'Po letih';

  @override
  String get loanPrincipal => 'Glavnica';

  @override
  String get loanInterest => 'Obresti';

  @override
  String loanYearShort(int n) {
    return '$n. l.';
  }

  @override
  String get loanSchedule => 'Amortizacijski načrt';

  @override
  String loanScheduleAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celoten načrt · $count obrokov',
      few: 'Celoten načrt · $count obroki',
      two: 'Celoten načrt · $count obroka',
      one: 'Celoten načrt · $count obrok',
    );
    return '$_temp0';
  }

  @override
  String get loanColNo => 'Št.';

  @override
  String get loanColInstallment => 'Obrok';

  @override
  String get loanColInterest => 'Obresti';

  @override
  String get loanColPrincipal => 'Glavnica';

  @override
  String get loanColBalance => 'Stanje dolga';

  @override
  String get loanPrepayTitle => 'Predčasno odplačilo';

  @override
  String loanPrepayTeaser(
    String amount,
    int month,
    String months,
    String saved,
  ) {
    return 'Dodatno plačilo $amount po $month. obroku skrajša kredit za $months in prihrani $saved obresti.';
  }

  @override
  String get loanPrepayCta => 'Izračunajte svoj scenarij';

  @override
  String get loanErrorPrincipal => 'Vnesite znesek kredita.';

  @override
  String get loanErrorRate => 'Vnesite obrestno mero med 0 in 100 %.';

  @override
  String get loanErrorTerm => 'Doba mora biti med 1 in 600 meseci.';

  @override
  String get loanErrorFee => 'Stroški morajo biti manjši od kredita.';

  @override
  String get prepayTitle => 'Predčasno odplačilo';

  @override
  String prepayIntro(String amount, String rate, String term) {
    return 'Na podlagi vašega kredita: $amount po $rate za $term.';
  }

  @override
  String get prepayNoLoan => 'Najprej vnesite kredit na zavihku Krediti.';

  @override
  String get prepayAmount => 'Dodatno plačilo';

  @override
  String get prepayAfter => 'Plačano z obrokom št.';

  @override
  String get prepayMode => 'Po plačilu';

  @override
  String get prepayShorten => 'Krajša doba';

  @override
  String get prepayLower => 'Nižji obrok';

  @override
  String get prepayFee => 'Nadomestilo za predčasno odplačilo';

  @override
  String get prepaySaved => 'Prihranek pri obrestih';

  @override
  String get prepayNetSaving => 'Neto prihranek po nadomestilu';

  @override
  String get prepayNewTerm => 'Nova doba';

  @override
  String get prepayNewInstallment => 'Nov obrok';

  @override
  String prepayMonthsSaved(String months) {
    return '$months prej';
  }

  @override
  String get prepayPaidOff => 'Dodatno plačilo poravna ves preostali dolg.';

  @override
  String get prepayBefore => 'Prej';

  @override
  String get prepayAfterLabel => 'Potem';

  @override
  String get depAmount => 'Znesek vloge';

  @override
  String get depRate => 'Obrestna mera';

  @override
  String get depTerm => 'Doba';

  @override
  String get depPayout => 'Obresti';

  @override
  String get depAtMaturity => 'Ob zapadlosti';

  @override
  String get depMonthly => 'Mesečno, pripisane';

  @override
  String get depAnnually => 'Letno, pripisane';

  @override
  String get depTax => 'Davek na obresti';

  @override
  String get depTaxHintRs =>
      'V Srbiji so obresti na dinarske vloge neobdavčene; obresti na devizne vloge so obdavčene s 15 %.';

  @override
  String get depTaxHint => 'Vnesite davek na obresti, ki velja za vas.';

  @override
  String get depContribution => 'Mesečni polog';

  @override
  String get depFinal => 'Ob zapadlosti';

  @override
  String get depGrossInterest => 'Obresti pred davkom';

  @override
  String get depTaxAmount => 'Davek na obresti';

  @override
  String get depNetInterest => 'Neto obresti';

  @override
  String get depPaidIn => 'Vplačano';

  @override
  String depYield(String percent) {
    return 'Neto donos $percent letno';
  }

  @override
  String get depByYear => 'Po letih';

  @override
  String get depColYear => 'Leto';

  @override
  String get depColInterest => 'Neto obresti';

  @override
  String get depColBalance => 'Stanje';

  @override
  String get depErrorAmount => 'Vnesite znesek vloge ali mesečni polog.';

  @override
  String get depErrorRate => 'Vnesite obrestno mero med 0 in 100 %.';

  @override
  String get cmpLoanIntro =>
      'Enak znesek za vsako ponudbo. Najugodnejša je ponudba z najnižjim skupnim stroškom.';

  @override
  String cmpLoanOffer(int n) {
    return 'Ponudba $n';
  }

  @override
  String get cmpLoanAdd => 'Dodaj ponudbo';

  @override
  String get cmpLoanRemove => 'Odstrani ponudbo';

  @override
  String get cmpLoanBest => 'Najnižji skupni strošek';

  @override
  String cmpLoanSavesVs(String amount) {
    return '$amount ceneje od najdražje ponudbe';
  }

  @override
  String get depYieldLabel => 'Neto letni donos';

  @override
  String get fxTitle => 'Tečajnica';

  @override
  String get fxTabConverter => 'Pretvornik';

  @override
  String get fxTabList => 'Tečajnica';

  @override
  String fxAmount(String currency) {
    return 'Znesek v $currency';
  }

  @override
  String get fxSwap => 'Zamenjaj valuti';

  @override
  String fxRateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get fxSourceNbsMiddle => 'srednji tečaj NBS';

  @override
  String get fxSourceNbsBuy => 'nakupni tečaj NBS';

  @override
  String get fxSourceNbsSell => 'prodajni tečaj NBS';

  @override
  String get fxSourceEcb => 'referenčni tečaj ECB';

  @override
  String get fxSourceCross => 'navzkrižni tečaj';

  @override
  String get fxKindMiddle => 'Srednji';

  @override
  String get fxKindBuy => 'Nakupni';

  @override
  String get fxKindSell => 'Prodajni';

  @override
  String get fxKindHint =>
      'Nakupni in prodajni tečaj veljata za menjavo dinarjev.';

  @override
  String fxUpdated(String date) {
    return 'Posodobljeno $date';
  }

  @override
  String fxOffline(String date) {
    return 'Brez povezave · tečaji z dne $date';
  }

  @override
  String get fxLoading => 'Posodabljanje tečajev…';

  @override
  String get fxNoRates =>
      'Tečajev še ni. Enkrat se povežite s spletom, da prenesete današnje uradne tečaje — nato pretvornik deluje tudi brez povezave.';

  @override
  String get fxUnsupported => 'Za ta par ni uradnega tečaja.';

  @override
  String fxHistoryTitle(String from, String to, int days) {
    return '$from/$to · $days dni';
  }

  @override
  String fxHistoryDays(int days) {
    return '$days d';
  }

  @override
  String get fxHistoryError => 'Zgodovina ni na voljo brez povezave.';

  @override
  String get fxHistoryPro =>
      'Zgodovina tečajev za 30, 90 in 365 dni je del paketa Pro.';

  @override
  String fxHistoryMinMax(String min, String max) {
    return 'min $min · maks $max';
  }

  @override
  String get fxPerUnit => 'Za 1 enoto valute';

  @override
  String get fxListNbs => 'Tečajnica NBS';

  @override
  String get fxListEcb => 'Referenčni tečaji ECB, za 1 EUR';

  @override
  String get fxColBuy => 'Nakupni';

  @override
  String get fxColMiddle => 'Srednji';

  @override
  String get fxColSell => 'Prodajni';

  @override
  String get fxColRate => 'Tečaj';

  @override
  String get fxRefresh => 'Osveži tečaje';

  @override
  String get fxPickFrom => 'Iz valute';

  @override
  String get fxPickTo => 'V valuto';

  @override
  String get fxSourcesNote =>
      'Uradni tečaji Narodne banke Srbije prek kurs.resenje.org; referenčni tečaji Evropske centralne banke prek storitve Frankfurter. Marka je vezana na evro po tečaju 1,95583.';

  @override
  String get bizTitle => 'Posel';

  @override
  String get bizProfile => 'Podatki o podjetju';

  @override
  String get bizInvoices => 'Računi';

  @override
  String get bizNewInvoice => 'Nov';

  @override
  String get bizInvoicesEmpty =>
      'Računov še ni. Profesionalen račun izdelate v manj kot minuti.';

  @override
  String bizFreeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Še $count brezplačnih računov',
      few: 'Še $count brezplačni računi',
      two: 'Še $count brezplačna računa',
      one: 'Še $count brezplačen račun',
    );
    return '$_temp0';
  }

  @override
  String get bizTools => 'Orodja';

  @override
  String bizShowAll(int count) {
    return 'Prikaži vse ($count)';
  }

  @override
  String bizPausalCard(int year) {
    return 'Pavšal · $year';
  }

  @override
  String get statusDraft => 'Osnutek';

  @override
  String get statusIssued => 'Čaka na plačilo';

  @override
  String get statusPaid => 'Plačan';

  @override
  String get statusCancelled => 'Storniran';

  @override
  String get statusOverdue => 'Zapadel';

  @override
  String get invNew => 'Nov račun';

  @override
  String get invEdit => 'Urejanje računa';

  @override
  String get invNumber => 'Številka računa';

  @override
  String get invIssueDate => 'Datum izdaje';

  @override
  String get invServiceDate => 'Datum opravljene storitve';

  @override
  String get invDueDate => 'Rok plačila';

  @override
  String get invPlace => 'Kraj izdaje';

  @override
  String get invClient => 'Stranka';

  @override
  String get invClientName => 'Naziv stranke';

  @override
  String get invClientAddress => 'Naslov';

  @override
  String get invClientCity => 'Poštna številka in kraj';

  @override
  String get invClientCountry => 'Država';

  @override
  String get invClientTaxId => 'Davčna številka (ID za DDV)';

  @override
  String get invClientRegNo => 'Matična številka';

  @override
  String get invClientEmail => 'E-pošta';

  @override
  String get invRecentClients => 'Nedavne stranke';

  @override
  String get invCurrency => 'Valuta';

  @override
  String get invItems => 'Postavke';

  @override
  String get invItemDescription => 'Opis';

  @override
  String get invItemQty => 'Količina';

  @override
  String get invItemUnit => 'Enota';

  @override
  String get invItemUnitHint => 'kos, ura, dan…';

  @override
  String get invItemPrice => 'Cena na enoto';

  @override
  String get invItemVat => 'DDV %';

  @override
  String get invAddItem => 'Dodaj postavko';

  @override
  String get invRemoveItem => 'Odstrani postavko';

  @override
  String get invNote => 'Opomba';

  @override
  String get invReference => 'Sklic';

  @override
  String get invReferenceHint => 'Model in številka, npr. 97 1234';

  @override
  String get invSubtotal => 'Osnova';

  @override
  String get invVat => 'DDV';

  @override
  String get invTotal => 'Skupaj';

  @override
  String get invTotalDue => 'Za plačilo';

  @override
  String get invTotalRsd => 'Protivrednost v RSD';

  @override
  String invRateLine(String rate, String date) {
    return 'Srednji tečaj NBS $rate na dan $date';
  }

  @override
  String get invRateFetching => 'Pridobivanje tečaja NBS…';

  @override
  String get invRateUnavailable => 'Tečaj NBS za ta datum še ni objavljen.';

  @override
  String get invRateRetry => 'Pridobi tečaj';

  @override
  String get invSaveDraft => 'Shrani osnutek';

  @override
  String get invIssue => 'Izdaj račun';

  @override
  String get invSave => 'Shrani spremembe';

  @override
  String get invMarkPaid => 'Označi kot plačan';

  @override
  String get invMarkUnpaid => 'Označi kot neplačan';

  @override
  String get invCancelInvoice => 'Storniraj račun';

  @override
  String get invDelete => 'Izbriši račun';

  @override
  String invDeleteConfirm(String number) {
    return 'Izbrišem račun $number? Tega ni mogoče razveljaviti.';
  }

  @override
  String get invDuplicate => 'Podvoji';

  @override
  String get invProfileMissing =>
      'Najprej vnesite podatke o podjetju — izpišejo se na vsakem računu.';

  @override
  String get invNotInVat => 'Izdajatelj ni zavezanec za DDV.';

  @override
  String get invValidWithoutStamp => 'Račun je veljaven brez žiga in podpisa.';

  @override
  String get invQrCaption => 'Skeniraj in plačaj (NBS IPS)';

  @override
  String get invQrHint =>
      'Stranka skenira kodo QR v aplikaciji svoje banke — znesek, račun in sklic se izpolnijo sami.';

  @override
  String invQrMissing(String reason) {
    return 'Ni kode QR za plačilo: $reason';
  }

  @override
  String get invQrReasonAccount =>
      'v podatkih o podjetju vnesite veljaven srbski račun';

  @override
  String get invQrReasonOther => 'preverite naziv podjetja in sklic';

  @override
  String get invDocTitle => 'Račun';

  @override
  String get invSeller => 'Izdajatelj';

  @override
  String get invBuyer => 'Kupec';

  @override
  String invPaidOn(String date) {
    return 'Plačano $date';
  }

  @override
  String invDueOn(String date) {
    return 'Zapade $date';
  }

  @override
  String get invErrorClient => 'Vnesite naziv stranke.';

  @override
  String get invErrorItems => 'Dodajte vsaj eno postavko z opisom in ceno.';

  @override
  String get invErrorNumber => 'Vnesite številko računa.';

  @override
  String get invErrorDue => 'Rok plačila ne more biti pred datumom izdaje.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Račun $number že obstaja.';
  }

  @override
  String get invShare => 'Deli PDF';

  @override
  String get invAccount => 'Račun';

  @override
  String get invPib => 'PIB';

  @override
  String get invMb => 'MB';

  @override
  String get invReferenceLabel => 'Sklic';

  @override
  String get invPlaceLabel => 'Kraj';

  @override
  String get invColItem => 'Postavka';

  @override
  String get invColQty => 'Kol.';

  @override
  String get invColPrice => 'Cena';

  @override
  String get invColAmount => 'Znesek';

  @override
  String get profTitle => 'Podatki o podjetju';

  @override
  String get profIntro =>
      'Izpišejo se na računih in, če želite, na poročilih PDF.';

  @override
  String get profName => 'Naziv podjetja';

  @override
  String get profAddress => 'Ulica in hišna številka';

  @override
  String get profCity => 'Poštna številka in kraj';

  @override
  String get profCountry => 'Država';

  @override
  String get profTaxId => 'Davčna številka (PIB)';

  @override
  String get profRegNo => 'Matična številka (MB)';

  @override
  String get profAccount => 'Bančni račun';

  @override
  String get profAccountHint => 'Srbski račun (160-0000000000000-00) ali IBAN';

  @override
  String get profBank => 'Banka';

  @override
  String get profEmail => 'E-pošta';

  @override
  String get profPhone => 'Telefon';

  @override
  String get profVat => 'Zavezanec za DDV';

  @override
  String get profVatHint =>
      'Na račune doda DDV. Ko je izklopljeno, račun navaja, da niste zavezanec za DDV.';

  @override
  String get profPaymentCode => 'Šifra plačila za kodo QR';

  @override
  String get profPaymentCodeHint => '221 za plačilo blaga in storitev';

  @override
  String get profDueDays => 'Privzeti rok plačila';

  @override
  String get profDueDaysSuffix => 'dni';

  @override
  String get profCurrency => 'Privzeta valuta računa';

  @override
  String get profNote => 'Privzeta opomba na računu';

  @override
  String get profShowOnReports => 'Prikaži podatke o podjetju na poročilih PDF';

  @override
  String get profInvalidPib =>
      'Kontrolna številka PIB ni pravilna — preverite številko.';

  @override
  String get profInvalidMb =>
      'Kontrolna številka matične številke ni pravilna.';

  @override
  String get profInvalidAccount => 'Kontrolna številka računa ni pravilna.';

  @override
  String get profSaved => 'Podatki o podjetju so shranjeni';

  @override
  String get pausalTitle => 'Pavšalne meje';

  @override
  String get pausalIntro =>
      'Pavšalisti v Srbiji izgubijo pavšalno obdavčitev nad 6.000.000 RSD prihodkov v koledarskem letu in morajo v sistem DDV nad 8.000.000 RSD v katerih koli 12 mesecih.';

  @override
  String get pausalAnnual => 'Pavšalna meja, koledarsko leto';

  @override
  String get pausalVat => 'Meja za DDV, zadnjih 12 mesecev';

  @override
  String pausalOf(String amount) {
    return 'od $amount';
  }

  @override
  String pausalLeft(String amount) {
    return 'Še $amount';
  }

  @override
  String pausalProjection(String amount) {
    return 'S tem tempom boste do 31. decembra zaračunali približno $amount.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'S tem tempom boste pavšalno mejo presegli pred koncem leta (približno $amount).';
  }

  @override
  String get pausalWarn => 'Porabili ste več kot 80 % te meje.';

  @override
  String get pausalOver => 'Meja je presežena — posvetujte se z računovodjo.';

  @override
  String pausalMissingRate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deviznih računov nima tečaja NBS, zato niso upoštevani.',
      few: '$count devizni računi nimajo tečaja NBS in niso upoštevani.',
      two: '$count devizna računa nimata tečaja NBS in nista upoštevana.',
      one: '$count devizni račun nima tečaja NBS in ni upoštevan.',
    );
    return '$_temp0';
  }

  @override
  String get pausalSourceInvoices =>
      'Upoštevani so izdani in plačani računi (po datumu storitve) ter prihodki, ki jih dodate spodaj.';

  @override
  String get pausalManual => 'Prihodki zunaj aplikacije';

  @override
  String get pausalManualEmpty =>
      'Dodajte račune, izdane drugje v tem letu, da bodo vsote popolne.';

  @override
  String get pausalManualAdd => 'Dodaj prihodek';

  @override
  String get pausalManualDate => 'Datum';

  @override
  String get pausalManualAmount => 'Znesek v RSD';

  @override
  String get pausalManualNote => 'Opomba';

  @override
  String get vatTitle => 'Kalkulator DDV';

  @override
  String get vatAdd => 'Prištej DDV';

  @override
  String get vatExtract => 'Izloči DDV';

  @override
  String get vatAmountNet => 'Znesek brez DDV';

  @override
  String get vatAmountGross => 'Znesek z DDV';

  @override
  String get vatRate => 'Stopnja DDV';

  @override
  String get vatOther => 'Druga';

  @override
  String get vatNet => 'Brez DDV';

  @override
  String get vatVat => 'DDV';

  @override
  String get vatGross => 'Z DDV';

  @override
  String get mrgTitle => 'Marža in pribitek';

  @override
  String get mrgFromPrice => 'Nabavna in prodajna';

  @override
  String get mrgFromMarkup => 'Pribitek';

  @override
  String get mrgFromMargin => 'Marža';

  @override
  String get mrgCost => 'Nabavna cena';

  @override
  String get mrgPrice => 'Prodajna cena (brez DDV)';

  @override
  String get mrgMarkup => 'Pribitek';

  @override
  String get mrgMargin => 'Marža';

  @override
  String get mrgDiscount => 'Popust';

  @override
  String get mrgVat => 'DDV';

  @override
  String get mrgProfit => 'Bruto dobiček';

  @override
  String get mrgPriceAfterDiscount => 'Cena po popustu';

  @override
  String get mrgPriceWithVat => 'Cena z DDV';

  @override
  String get mrgMarginHint =>
      'Marža je dobiček kot delež prodajne cene; pribitek je dobiček kot delež nabavne cene.';

  @override
  String get mrgImpossible => 'Marža 100 % ali več ni mogoča.';

  @override
  String get beTitle => 'Prag donosnosti';

  @override
  String get beFixed => 'Fiksni stroški na mesec';

  @override
  String get bePrice => 'Cena na enoto';

  @override
  String get beVariable => 'Variabilni strošek na enoto';

  @override
  String get beTarget => 'Ciljni dobiček na mesec';

  @override
  String get beUnits => 'Potrebna prodaja na mesec';

  @override
  String beUnitsValue(int count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted kosov',
      few: '$formatted kosi',
      two: '$formatted kosa',
      one: '$formatted kos',
    );
    return '$_temp0';
  }

  @override
  String get beRevenue => 'Potrebni prihodki';

  @override
  String get beContribution => 'Stopnja kritja';

  @override
  String get beImpossible =>
      'Cena mora biti višja od variabilnega stroška na enoto.';

  @override
  String get invsTitle => 'Analiza naložbe';

  @override
  String get invsInitial => 'Začetna naložba';

  @override
  String get invsRate => 'Diskontna stopnja';

  @override
  String get invsFlows => 'Neto denarni tok po letih';

  @override
  String invsYear(int n) {
    return 'Leto $n';
  }

  @override
  String get invsAddYear => 'Dodaj leto';

  @override
  String get invsRemoveYear => 'Odstrani zadnje leto';

  @override
  String get invsNpv => 'Neto sedanja vrednost (NSV)';

  @override
  String get invsIrr => 'Notranja stopnja donosnosti (NSD)';

  @override
  String get invsPayback => 'Doba vračila';

  @override
  String get invsDiscountedPayback => 'Diskontirana doba vračila';

  @override
  String get invsPi => 'Indeks donosnosti';

  @override
  String invsYears(String years) {
    return '$years let';
  }

  @override
  String get invsNever => 'Ne v tem obdobju';

  @override
  String get invsNoIrr => 'Za te tokove NSD ne obstaja';

  @override
  String invsGood(String rate) {
    return 'Ustvarja vrednost pri diskontni stopnji $rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Uničuje vrednost pri diskontni stopnji $rate.';
  }

  @override
  String get profSectionBusiness => 'Podjetje';

  @override
  String get profSectionPayment => 'Plačilo';

  @override
  String get profSectionContact => 'Kontakt';

  @override
  String get profSectionInvoices => 'Privzeto za račune';

  @override
  String get profTaxIdGeneric => 'Davčna številka';

  @override
  String get profRegNoGeneric => 'Matična številka';

  @override
  String get profNameRequired => 'Vnesite naziv podjetja.';

  @override
  String get profPibLength => 'PIB ima 9 števk.';

  @override
  String get profMbLength => 'Matična številka ima 8 števk.';

  @override
  String get profInvalidAccountShape =>
      'Vnesite srbski račun (160-0000000000000-00) ali IBAN.';

  @override
  String get profInvalidEmail => 'Preverite e-poštni naslov.';

  @override
  String get profInvalidPaymentCode =>
      'Šifra plačila ima tri števke, npr. 221.';

  @override
  String get profPrivacy =>
      'Shranjeno samo na tem telefonu in vključeno v varnostne kopije, ki jih izvozite.';

  @override
  String get profIban => 'IBAN za plačila iz tujine';

  @override
  String get profIbanHint =>
      'Izpiše se na deviznih računih. Pustite prazno za zgornji račun v obliki IBAN.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban =>
      'Preverite IBAN — kontrolni števki nista pravilni.';

  @override
  String get profInvalidSwift => 'Koda SWIFT/BIC ima 8 ali 11 znakov.';

  @override
  String get invIban => 'IBAN';

  @override
  String get invSwift => 'SWIFT/BIC';

  @override
  String get invBank => 'Banka';

  @override
  String get invSefNote =>
      'Računi srbskemu javnemu sektorju — za zavezance za DDV pa tudi srbskim podjetjem — morajo iti tudi prek SEF (e-Faktura). Računi Bilans so primerni za stranke v tujini, fizične osebe in vašo evidenco.';

  @override
  String get invRateOffline =>
      'NBS ni dosegljiva. Preverite povezavo — lahko shranite zdaj in tečaj pridobite pozneje.';

  @override
  String get invMarkedPaid => 'Označen kot plačan';

  @override
  String get invMarkedUnpaid => 'Označen kot neplačan';

  @override
  String get invIssued => 'Račun je izdan';

  @override
  String get invCancelled => 'Račun je storniran';

  @override
  String get invCompleteFirst =>
      'Pred izdajo dodajte stranko in vsaj eno postavko.';

  @override
  String invCancelConfirm(String number) {
    return 'Storniram račun $number?';
  }

  @override
  String get invCancelBody =>
      'Ostane na seznamu, označen kot storniran, in se ne šteje več med prihodke.';

  @override
  String get invRateMissingNote =>
      'Tečaja NBS še ni — račun se ne šteje v pavšalne meje, dokler ga ne dobi.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'Da ostanete pod mejo, do konca leta zaračunajte največ približno $amount na mesec.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Prihodki po mesecih, $year';
  }

  @override
  String get pausalFromInvoices => 'Računi';

  @override
  String get pausalDisclaimer =>
      'Prihodki se štejejo po datumu storitve. Devizni računi se preračunajo po srednjem tečaju NBS na dan izdaje. Končne zneske preverite z računovodjo.';

  @override
  String get pausalRemoveTitle => 'Odstranim ta prihodek?';

  @override
  String get pausalManualAmountError => 'Vnesite znesek.';

  @override
  String get invsFilterAll => 'Vsi';

  @override
  String get invsFilterDrafts => 'Osnutki';

  @override
  String get invsOutstanding => 'Čaka na plačilo';

  @override
  String get invsSearchHint => 'Iskanje po stranki ali številki';

  @override
  String get invsNoMatch => 'Noben račun ne ustreza.';

  @override
  String get vatEmpty => 'Vnesite znesek, da ga razdelite na osnovo in DDV.';

  @override
  String vatRatesNote(String country) {
    return 'Prikazane stopnje DDV veljajo za državo: $country.';
  }

  @override
  String get mrgEmpty =>
      'Vnesite nabavno ceno in prodajno ceno, pribitek ali maržo.';

  @override
  String get mrgLoss => 'Po tej ceni prodajate pod nabavno ceno.';

  @override
  String get beFixedHint => 'Najemnina, plače, naročnine…';

  @override
  String get beVariableHint => 'Material, provizije, dostava…';

  @override
  String get beEmpty =>
      'Vnesite fiksne stroške, ceno in variabilni strošek na enoto.';

  @override
  String get beContributionUnit => 'Prispevek na enoto';

  @override
  String get beExplain =>
      'Vsaka prodana enota prispeva ceno, zmanjšano za variabilni strošek, h kritju fiksnih stroškov in dobička. Zneski so brez DDV.';

  @override
  String get invsFlowsHint =>
      'Neto denarni tok ob koncu vsakega leta. Za leto z več odlivi kot prilivi vpišite minus.';

  @override
  String get invsEmpty =>
      'Vnesite naložbo, diskontno stopnjo in denarni tok za vsaj eno leto.';

  @override
  String get invsCumulative => 'Kumulativni denarni tok';

  @override
  String get invCreatedWith => 'Izdelano z aplikacijo Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead =>
      'Vsi kalkulatorji, vse države, neomejeni računi in poročila PDF. Brez oglasov, brez računa.';

  @override
  String get proFeatAllCountries => 'Obračun plače za vseh 9 davčnih sistemov';

  @override
  String get proFeatUnlimitedInvoices => 'Neomejeno število računov';

  @override
  String get proFeatPdf => 'Poročila PDF';

  @override
  String get proFeatUnlimitedSaves => 'Neomejeno število shranjenih izračunov';

  @override
  String get proBenefitCountries =>
      'Obračun plače za vseh 9 davčnih sistemov in primerjava iste plače med državami';

  @override
  String get proBenefitTeam => 'Strošek ekipe: vse plače po mesecih in letih';

  @override
  String get proBenefitInvoices =>
      'Neomejeno število profesionalnih računov v PDF';

  @override
  String get proBenefitInvoicesRs =>
      'Neomejeno število računov s kodo QR NBS IPS za plačilo';

  @override
  String get proBenefitPausal =>
      'Spremljanje pavšalnih mej 6 in 8 milijonov dinarjev';

  @override
  String get proBenefitLoans =>
      'Primerjava ponudb za kredit in načrt predčasnega odplačila';

  @override
  String get proBenefitHistory => 'Zgodovina tečajev za 30, 90 in 365 dni';

  @override
  String get proBenefitInvestment => 'Analiza naložb: NSV, NSD in doba vračila';

  @override
  String get proBenefitPdf =>
      'Poročila PDF za plače, kredite, varčevanje in ekipe';

  @override
  String get proYearly => 'Letno';

  @override
  String get proMonthly => 'Mesečno';

  @override
  String get proLifetime => 'Trajno';

  @override
  String get proPerYear => 'na leto';

  @override
  String get proPerMonth => 'na mesec';

  @override
  String get proOnce => 'enkratno';

  @override
  String proSave(int percent) {
    return 'PRIHRANEK $percent %';
  }

  @override
  String proTrialNote(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dni brezplačno, nato letno plačilo',
      few: '$days dni brezplačno, nato letno plačilo',
      two: '$days dneva brezplačno, nato letno plačilo',
      one: '$days dan brezplačno, nato letno plačilo',
    );
    return '$_temp0';
  }

  @override
  String get proLifetimeNote => 'Plačate enkrat, Pro ostane za vedno';

  @override
  String proStartTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Začni $days-dnevni brezplačni preizkus',
      few: 'Začni $days-dnevni brezplačni preizkus',
      two: 'Začni $days-dnevni brezplačni preizkus',
      one: 'Začni $days-dnevni brezplačni preizkus',
    );
    return '$_temp0';
  }

  @override
  String get proContinue => 'Nadaljuj';

  @override
  String get proRestore => 'Obnovi nakup';

  @override
  String get proRestored => 'Bilans Pro je aktiven v tej napravi.';

  @override
  String get proNothingToRestore =>
      'Za ta račun Google ni bil najden nakup paketa Bilans Pro.';

  @override
  String get proPending =>
      'Plačilo je v obdelavi. Pro se odklene samodejno, ko Google Play potrdi plačilo.';

  @override
  String get proError =>
      'Nakup ni uspel. Ničesar vam ni bilo zaračunano — poskusite znova.';

  @override
  String get proUnavailable =>
      'Nakupi trenutno niso na voljo. Preverite, ali je Google Play nameščen in ali ste prijavljeni, nato poskusite znova.';

  @override
  String get proLegal =>
      'Naročnina se samodejno podaljšuje po prikazani ceni, dokler je ne prekličete. Prekličete jo lahko kadar koli v Google Play → Plačila in naročnine, najpozneje 24 ur pred podaljšanjem. Brezplačni preizkus preide v plačljivo letno naročnino, če ga ne prekličete pred iztekom.';

  @override
  String get proLegalLifetime =>
      'Enkratni nakup: brez naročnine in brez podaljševanja. Pro je aktiven v vseh napravah, prijavljenih v isti račun Google.';

  @override
  String get proDevSimulate => 'Simuliraj Pro (razvojna različica)';

  @override
  String get proWelcome => 'Dobrodošli v Bilans Pro';

  @override
  String get proWelcomeBody =>
      'Vse je odklenjeno. Hvala, ker podpirate neodvisno aplikacijo.';

  @override
  String get settingsPreferences => 'Nastavitve';

  @override
  String get settingsTheme => 'Videz';

  @override
  String get settingsThemeSystem => 'Sistemski';

  @override
  String get settingsThemeLight => 'Svetli';

  @override
  String get settingsThemeDark => 'Temni';

  @override
  String get settingsYourData => 'Vaši podatki';

  @override
  String get settingsExport => 'Izvozi varnostno kopijo';

  @override
  String get settingsImport => 'Obnovi iz varnostne kopije';

  @override
  String get settingsBackupSubject => 'Varnostna kopija Bilans';

  @override
  String get settingsExported => 'Varnostna kopija je pripravljena';

  @override
  String get settingsImportInvalid => 'Ta datoteka ni varnostna kopija Bilans.';

  @override
  String get settingsImportTitle => 'Obnovim to varnostno kopijo?';

  @override
  String get settingsImportBody =>
      'Vse v aplikaciji bo nadomeščeno z vsebino kopije — računi, podatki o podjetju, ekipa in shranjeni izračuni.';

  @override
  String get settingsImportAction => 'Obnovi';

  @override
  String get settingsImported => 'Varnostna kopija je obnovljena';

  @override
  String get settingsDeleteAll => 'Izbriši vse podatke';

  @override
  String get settingsDeleteTitle => 'Izbrišem vse podatke?';

  @override
  String get settingsDeleteBody =>
      'Računi, podatki o podjetju, ekipa, shranjeni izračuni in nastavitve bodo odstranjeni s tega telefona. Če bi jih morda potrebovali, najprej izvozite varnostno kopijo. Nakup paketa Pro ostane.';

  @override
  String get settingsDeleteAction => 'Izbriši vse';

  @override
  String get settingsDataNote =>
      'Bilans nima računov ne strežnikov: vaši podatki so samo na tem telefonu. Z varnostno kopijo jih prenesete na nov telefon.';

  @override
  String get settingsAbout => 'O aplikaciji';

  @override
  String get settingsRate => 'Ocenite Bilans v Google Play';

  @override
  String get settingsContact => 'Stik';

  @override
  String get settingsPrivacy => 'Pravilnik o zasebnosti';

  @override
  String get settingsTerms => 'Pogoji uporabe';

  @override
  String get settingsLicenses => 'Licence odprte kode';

  @override
  String get settingsDisclaimer =>
      'Izračuni so informativni in ne nadomeščajo strokovnega davčnega, pravnega ali finančnega nasveta.';

  @override
  String get settingsProActive => 'Bilans Pro je aktiven';

  @override
  String get settingsManageSubscription => 'Upravljaj naročnino';

  @override
  String get settingsProPitch =>
      'Vse države, strošek ekipe, neomejeni računi, poročila PDF in še več.';

  @override
  String get settingsSeePlans => 'Oglejte si pakete';

  @override
  String get proIncluded => 'Vključeno v Pro';

  @override
  String proSummaryTrial(int days, String price, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          '$days dni brezplačno, nato $price $period. Prekličete lahko kadar koli.',
      few:
          '$days dni brezplačno, nato $price $period. Prekličete lahko kadar koli.',
      two:
          '$days dneva brezplačno, nato $price $period. Prekličete lahko kadar koli.',
      one:
          '$days dan brezplačno, nato $price $period. Prekličete lahko kadar koli.',
    );
    return '$_temp0';
  }

  @override
  String proSummary(String price, String period) {
    return '$price $period, samodejno podaljšanje. Prekličete lahko kadar koli.';
  }

  @override
  String proSummaryLifetime(String price) {
    return 'Enkratno plačilo $price. Brez naročnine.';
  }
}
