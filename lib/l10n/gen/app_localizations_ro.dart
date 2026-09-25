// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appName => 'Bilans';

  @override
  String get appTagline => 'Calculator financiar';

  @override
  String get navHome => 'Acasă';

  @override
  String get navPayroll => 'Salariu';

  @override
  String get navCredit => 'Credite';

  @override
  String get navFx => 'Cursuri';

  @override
  String get navBusiness => 'Afaceri';

  @override
  String get actionSave => 'Salvează';

  @override
  String get actionShare => 'Distribuie';

  @override
  String get actionDelete => 'Șterge';

  @override
  String get actionCancel => 'Renunță';

  @override
  String get actionClose => 'Închide';

  @override
  String get actionDone => 'Gata';

  @override
  String get actionRetry => 'Încearcă din nou';

  @override
  String get actionEdit => 'Editează';

  @override
  String get actionContinue => 'Continuă';

  @override
  String get actionRemove => 'Elimină';

  @override
  String get actionUndo => 'Anulează';

  @override
  String get actionDownloadPdf => 'Descarcă PDF';

  @override
  String get actionRename => 'Redenumește';

  @override
  String get actionClear => 'Golește';

  @override
  String get commonMonthly => 'Lunar';

  @override
  String get commonAnnual => 'Anual';

  @override
  String get commonMonthsShort => 'luni';

  @override
  String commonMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de luni',
      few: '$count luni',
      one: '$count lună',
    );
    return '$_temp0';
  }

  @override
  String commonYearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de ani',
      few: '$count ani',
      one: '$count an',
    );
    return '$_temp0';
  }

  @override
  String get commonPercentPa => '% pe an';

  @override
  String get commonOptional => 'opțional';

  @override
  String get commonSearch => 'Căutare';

  @override
  String get commonToday => 'Azi';

  @override
  String get snackSaved => 'Salvat';

  @override
  String get snackDeleted => 'Șters';

  @override
  String get errorGeneric => 'A apărut o eroare. Încercați din nou.';

  @override
  String get errorShare => 'Meniul de distribuire nu s-a putut deschide.';

  @override
  String get errorOpenLink => 'Linkul nu s-a putut deschide.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature face parte din Bilans Pro';
  }

  @override
  String get countryRS => 'Serbia';

  @override
  String get countryHR => 'Croația';

  @override
  String get countryBA => 'Bosnia și Herțegovina';

  @override
  String get countryME => 'Muntenegru';

  @override
  String get countryMK => 'Macedonia de Nord';

  @override
  String get countrySI => 'Slovenia';

  @override
  String get countryBG => 'Bulgaria';

  @override
  String get countryRO => 'România';

  @override
  String get systemFbih => 'Federația BiH';

  @override
  String get systemRepublikaSrpska => 'Republica Srpska';

  @override
  String get curEUR => 'Euro';

  @override
  String get curUSD => 'Dolar american';

  @override
  String get curCHF => 'Franc elvețian';

  @override
  String get curGBP => 'Liră sterlină';

  @override
  String get curRSD => 'Dinar sârbesc';

  @override
  String get curBAM => 'Marcă convertibilă';

  @override
  String get curMKD => 'Denar macedonean';

  @override
  String get curRON => 'Leu românesc';

  @override
  String get curHUF => 'Forint maghiar';

  @override
  String get curCZK => 'Coroană cehă';

  @override
  String get curPLN => 'Zlot polonez';

  @override
  String get curSEK => 'Coroană suedeză';

  @override
  String get curNOK => 'Coroană norvegiană';

  @override
  String get curDKK => 'Coroană daneză';

  @override
  String get curJPY => 'Yen japonez';

  @override
  String get curCNY => 'Yuan chinezesc';

  @override
  String get curCAD => 'Dolar canadian';

  @override
  String get curAUD => 'Dolar australian';

  @override
  String get curTRY => 'Liră turcească';

  @override
  String get curRUB => 'Rublă rusească';

  @override
  String get formFixErrors => 'Corectați câmpurile marcate.';

  @override
  String get discardTitle => 'Renunțați la modificări?';

  @override
  String get discardBody => 'Modificările nu au fost salvate.';

  @override
  String get discardKeep => 'Continuați editarea';

  @override
  String get discardAction => 'Renunță';

  @override
  String get commonMore => 'Mai multe opțiuni';

  @override
  String get errorPdf => 'PDF-ul nu a putut fi creat. Încercați din nou.';

  @override
  String get pdfLanguageTitle => 'Limba facturii';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + engleză';
  }

  @override
  String get onbHeadline => 'Cifre în care puteți avea încredere.';

  @override
  String get onbBody =>
      'Salarii, credite, cursuri valutare oficiale și facturi — calculate după regulile țării dvs. Fără cont, fără urmărire.';

  @override
  String get onbCountry => 'Țara dvs.';

  @override
  String get onbBihEntities => 'Federația BiH și Republica Srpska';

  @override
  String get onbLanguage => 'Limba aplicației';

  @override
  String get onbLanguageDevice => 'Limba dispozitivului';

  @override
  String get onbPrivacy => 'Datele dvs. rămân pe acest telefon.';

  @override
  String get homeSearchHint => 'Căutați un calculator';

  @override
  String get homeSettings => 'Setări';

  @override
  String get homeRatesTitle => 'Cursuri azi';

  @override
  String homeRatesNbs(String date) {
    return 'Curs mediu BNS · $date';
  }

  @override
  String homeRatesEcb(String date) {
    return 'Curs de referință BCE · $date';
  }

  @override
  String get homeRatesEmpty =>
      'Cursurile oficiale de azi apar aici când sunteți online.';

  @override
  String get homeRecent => 'Recente';

  @override
  String get homeSeeAll => 'Vezi tot';

  @override
  String get homeSectionPayroll => 'Salariu';

  @override
  String get homeSectionCredit => 'Credite și economii';

  @override
  String get homeSectionFx => 'Cursuri valutare';

  @override
  String get homeSectionBusiness => 'Afaceri';

  @override
  String homeNoResults(String query) {
    return 'Niciun calculator nu corespunde căutării „$query”.';
  }

  @override
  String get toolPayroll => 'Salariu brut și net';

  @override
  String get toolPayrollDesc => 'Salarii pentru 9 sisteme fiscale';

  @override
  String get toolTeam => 'Costul echipei';

  @override
  String get toolTeamDesc => 'Costul salarial lunar și anual';

  @override
  String get toolCompare => 'Comparați țări';

  @override
  String get toolCompareDesc => 'Același salariu în 9 sisteme';

  @override
  String get toolLoan => 'Credit';

  @override
  String get toolLoanDesc => 'Rată, DAE și grafic de rambursare';

  @override
  String get toolDeposit => 'Depozit la termen';

  @override
  String get toolDepositDesc => 'Dobândă și impozit pe dobândă';

  @override
  String get toolLoanCompare => 'Comparați credite';

  @override
  String get toolLoanCompareDesc => 'Până la trei oferte, ordonate după DAE';

  @override
  String get toolPrepay => 'Rambursare anticipată';

  @override
  String get toolPrepayDesc => 'Câtă dobândă economisiți';

  @override
  String get toolConverter => 'Convertor valutar';

  @override
  String get toolConverterDesc => 'Cursuri oficiale BNS și BCE';

  @override
  String get toolRateHistory => 'Istoricul cursului';

  @override
  String get toolRateHistoryDesc => '30, 90 și 365 de zile';

  @override
  String get toolInvoices => 'Facturi';

  @override
  String get toolInvoicesDescRs => 'PDF cu cod QR NBS IPS';

  @override
  String get toolInvoicesDesc => 'Facturi PDF profesionale';

  @override
  String get toolPausal => 'Plafoane paušal';

  @override
  String get toolPausalDesc => '6 și 8 milioane de dinari, în timp real';

  @override
  String get toolVat => 'TVA';

  @override
  String get toolVatDesc => 'Adăugați sau extrageți TVA';

  @override
  String get toolMargin => 'Marjă și adaos';

  @override
  String get toolMarginDesc => 'Cost, preț și reducere';

  @override
  String get toolBreakEven => 'Prag de rentabilitate';

  @override
  String get toolBreakEvenDesc => 'Cât trebuie să vindeți';

  @override
  String get toolInvestment => 'Investiție';

  @override
  String get toolInvestmentDesc => 'VAN, RIR și perioadă de recuperare';

  @override
  String recentPayroll(String country) {
    return 'Salariu · $country';
  }

  @override
  String recentFromGross(String amount) {
    return 'net din $amount brut';
  }

  @override
  String recentFromNet(String amount) {
    return 'brut pentru $amount net';
  }

  @override
  String recentFromCost(String amount) {
    return 'brut în bugetul de $amount';
  }

  @override
  String recentLoan(String term) {
    return 'Credit · $term';
  }

  @override
  String recentLoanSub(String eir) {
    return 'rată · DAE $eir';
  }

  @override
  String recentDeposit(String term) {
    return 'Depozit · $term';
  }

  @override
  String recentDepositSub(String rate) {
    return 'la scadență · $rate';
  }

  @override
  String recentVatAdd(String amount, String rate) {
    return '$amount + TVA $rate';
  }

  @override
  String recentVatExtract(String amount, String rate) {
    return 'fără TVA din $amount la $rate';
  }

  @override
  String recentMarginSub(String margin) {
    return 'preț cu TVA · marjă $margin';
  }

  @override
  String recentBreakEvenSub(String amount) {
    return 'pe lună · venit $amount';
  }

  @override
  String recentInvestmentSub(String irr) {
    return 'VAN · RIR $irr';
  }

  @override
  String get historyTitle => 'Salvate și recente';

  @override
  String get historySaved => 'Salvate';

  @override
  String get historySavedEmpty =>
      'Atingeți Salvează la orice rezultat pentru a-l păstra aici cu un nume.';

  @override
  String get historyRecentEmpty => 'Calculele finalizate apar aici automat.';

  @override
  String get historyClearTitle => 'Goliți lista de calcule recente?';

  @override
  String get payTitle => 'Calculator de salariu';

  @override
  String get payModeGross => 'Brut → net';

  @override
  String get payModeNet => 'Net → brut';

  @override
  String get payModeCost => 'Cost total';

  @override
  String get payModeSemantic => 'Direcția calculului';

  @override
  String get payInputGross => 'Salariu brut · lunar';

  @override
  String get payInputNet => 'Salariu net dorit · lunar';

  @override
  String get payInputCost => 'Bugetul angajatorului · lunar';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Baza minimă de contribuții: $amount';
  }

  @override
  String get payHelperNet => 'Suma pe care o primește angajatul';

  @override
  String get payHelperCost =>
      'Salariul brut plus toate contribuțiile angajatorului';

  @override
  String get payResultNet => 'Salariu net';

  @override
  String get payResultGross => 'Salariu brut necesar';

  @override
  String get payResultGrossBudget => 'Salariu brut în limita bugetului';

  @override
  String payShareOfGross(String percent) {
    return '$percent din brut';
  }

  @override
  String payNetLine(String amount) {
    return 'Salariu net: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Cost total pentru angajator: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'Unde merge costul total al angajatorului';

  @override
  String get segNet => 'Salariu net';

  @override
  String get segTax => 'Impozit';

  @override
  String get segEmployee => 'Contribuțiile angajatului';

  @override
  String get segEmployer => 'Contribuțiile angajatorului';

  @override
  String get payBreakdown => 'Detaliere';

  @override
  String get payAnnualToggle => 'Anual ×12';

  @override
  String get payEmployee => 'Angajat';

  @override
  String get payEmployer => 'Angajator';

  @override
  String get payGross => 'Salariu brut';

  @override
  String get payNetTotal => 'Salariu net';

  @override
  String get payTotalCost => 'Costul total al salariului';

  @override
  String get payNonTaxable => 'Sumă neimpozabilă';

  @override
  String get payPersonalAllowance => 'Deducere personală';

  @override
  String get payGeneralAllowance => 'Deducere generală';

  @override
  String get payPersonalExemption => 'Scutire personală';

  @override
  String get payPersonalDeduction => 'Deducere personală';

  @override
  String get payTaxBase => 'Baza de impozitare';

  @override
  String get payIncomeTax => 'Impozit pe venit';

  @override
  String payTaxOn(String rate, String amount) {
    return '$rate din $amount';
  }

  @override
  String get paySurtax => 'Suprataxă locală';

  @override
  String payOnBase(String amount) {
    return 'din $amount';
  }

  @override
  String get payFixedMonthly => 'fix lunar';

  @override
  String payWedge(String percent) {
    return 'Pană fiscală $percent';
  }

  @override
  String payRulesFrom(String date) {
    return 'Reguli de la $date';
  }

  @override
  String get paySources => 'Surse';

  @override
  String payDisclaimer(String date) {
    return 'Calcul orientativ conform regulilor în vigoare de la $date. Nu înlocuiește un stat de plată oficial.';
  }

  @override
  String get payAnnualNote =>
      'Sumele anuale sunt 12 × sumele lunare; regularizarea anuală a impozitului poate diferi.';

  @override
  String payNoteMinBase(String amount) {
    return 'Contribuțiile se calculează la baza minimă de $amount.';
  }

  @override
  String payNoteMaxBase(String amount) {
    return 'Contribuțiile se opresc la baza maximă de $amount.';
  }

  @override
  String payNoteRelief(String amount) {
    return 'Facilitatea pentru salarii mici reduce baza contribuției la pensie la $amount.';
  }

  @override
  String get payNoteNonPositive =>
      'Contribuțiile și impozitele obligatorii depășesc acest salariu.';

  @override
  String get payEmpty =>
      'Introduceți o sumă pentru a vedea detalierea completă — contribuții, impozit și costul total al angajatorului.';

  @override
  String get payErrorTooLarge => 'Suma este prea mare pentru a fi calculată.';

  @override
  String get paySystemTitle => 'Sistem fiscal';

  @override
  String get paySystemProHint =>
      'Țara dvs. este gratuită. Celelalte țări fac parte din Pro.';

  @override
  String get payOptions => 'Opțiuni';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Impozit $lower / $higher · copii $children';
  }

  @override
  String payOptionsMeSummary(String rate) {
    return 'Suprataxă $rate';
  }

  @override
  String payOptionsRoSummary(int count) {
    return 'Persoane în întreținere: $count';
  }

  @override
  String get payOptionsRoMinWage => 'scutire pentru salariul minim';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Fondul pentru persoane cu dizabilități: $state';
  }

  @override
  String get payOn => 'activat';

  @override
  String get payOff => 'dezactivat';

  @override
  String get payHrRates => 'Cote locale ale impozitului pe venit';

  @override
  String get payHrLower => 'Cota inferioară';

  @override
  String get payHrHigher => 'Cota superioară';

  @override
  String get payHrRatesHint =>
      'Stabilite de orașul sau comuna dvs.: 15–23 % și 25–33 %. Fără o decizie se aplică 20 % și 30 %.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'Cota inferioară $lowRange, cota superioară $highRange';
  }

  @override
  String get payChildren => 'Copii';

  @override
  String get payDependents => 'Alte persoane în întreținere';

  @override
  String get payRoDependents => 'Persoane în întreținere';

  @override
  String get payRoMinWage => 'Scutire pentru salariul minim';

  @override
  String get payRoMinWageHint =>
      '200 de lei sunt neimpozabili pentru angajații plătiți cu salariul minim pe economie.';

  @override
  String get payMeSurtax => 'Cota suprataxei';

  @override
  String get payMeSurtaxHint =>
      '13 % în majoritatea municipiilor, 15 % în Podgorica și Cetinje.';

  @override
  String get payFbihDisability =>
      'Fondul pentru angajarea persoanelor cu dizabilități 0,5 %';

  @override
  String get payFbihDisabilityHint =>
      'Plătit de firmele care nu angajează ponderea obligatorie de persoane cu dizabilități.';

  @override
  String get itemPension => 'Asigurare de pensie și invaliditate';

  @override
  String get itemHealth => 'Asigurare de sănătate';

  @override
  String get itemUnemployment => 'Asigurare de șomaj';

  @override
  String get itemChildProtection => 'Protecția copilului';

  @override
  String get itemWorkInjury => 'Asigurare pentru accidente de muncă';

  @override
  String get itemLaborFund => 'Fondul Muncii';

  @override
  String get itemChamber => 'Camera de Comerț';

  @override
  String get itemPillar1 => 'Asigurare de pensie, pilonul I';

  @override
  String get itemPillar2 => 'Asigurare de pensie, pilonul II';

  @override
  String get itemLongTermCare => 'Îngrijire pe termen lung';

  @override
  String get itemParental => 'Protecție parentală';

  @override
  String get itemCompulsoryHealth => 'Contribuția obligatorie de sănătate';

  @override
  String get itemWaterFee => 'Taxa generală pentru apă';

  @override
  String get itemDisasterFee => 'Taxa de protecție împotriva dezastrelor';

  @override
  String get itemDisabilityFund =>
      'Fondul pentru angajarea persoanelor cu dizabilități';

  @override
  String get itemSickness => 'Boală și maternitate';

  @override
  String get itemSupplementaryPension => 'Pensie suplimentară (UPF)';

  @override
  String get itemCas => 'CAS (pensie)';

  @override
  String get itemCass => 'CASS (sănătate)';

  @override
  String get itemCam => 'CAM (asigurare pentru muncă)';

  @override
  String get saveTitle => 'Salvați calculul';

  @override
  String get saveNameLabel => 'Nume';

  @override
  String get saveNameHint => 'de ex. Ofertă pentru un angajat nou';

  @override
  String saveLimit(int count) {
    return 'Planul gratuit păstrează $count calcule salvate.';
  }

  @override
  String get shareFooter => 'Calculat cu Bilans';

  @override
  String get sourcesTitle => 'Surse și ipoteze';

  @override
  String get teamTitle => 'Costul echipei';

  @override
  String get teamAdd => 'Adaugă angajat';

  @override
  String get teamEdit => 'Editați angajatul';

  @override
  String get teamEmptyTitle => 'Planificați costurile salariale';

  @override
  String get teamEmpty =>
      'Adăugați echipa — salariul brut și net al fiecărei persoane și costul total al angajatorului, însumate pe lună și pe an. Puteți combina țări dacă angajați peste granițe.';

  @override
  String teamMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de angajați',
      few: '$count angajați',
      one: '$count angajat',
    );
    return '$_temp0';
  }

  @override
  String get teamNote =>
      'Fiecare angajat este calculat după regulile propriului sistem fiscal. Sumele anuale sunt 12 × sumele lunare.';

  @override
  String get teamCurrenciesNote =>
      'Totalurile sunt afișate separat pentru fiecare monedă.';

  @override
  String get teamUnnamed => 'Fără nume';

  @override
  String get teamTotal => 'Total';

  @override
  String get teamCostShort => 'cost total';

  @override
  String teamRemoveTitle(String name) {
    return 'Eliminați $name din echipă?';
  }

  @override
  String get teamName => 'Nume';

  @override
  String get teamRole => 'Funcție';

  @override
  String get teamRoleHint => 'de ex. Programator';

  @override
  String get teamAmountError => 'Introduceți suma salariului.';

  @override
  String get cmpNeedsRates =>
      'Compararea țărilor necesită cursurile valutare de azi. Conectați-vă o dată la internet și vor fi salvate pentru utilizare offline.';

  @override
  String get cmpRankedByNet => 'Ordonate după salariul net';

  @override
  String get cmpRankedByCost => 'Ordonate după costul angajatorului';

  @override
  String cmpCostLine(String cost, String wedge) {
    return 'Costul angajatorului $cost · pană fiscală $wedge';
  }

  @override
  String cmpGrossLine(String gross, String wedge) {
    return 'Brut $gross · pană fiscală $wedge';
  }

  @override
  String get cmpTaxesKey => 'Impozite și contribuții';

  @override
  String cmpNote(String date) {
    return 'Sume convertite la cursurile oficiale din $date. Fiecare țară folosește setările implicite (fără copii, cote locale standard). Pana fiscală este partea din costul total al angajatorului care merge la impozite și contribuții.';
  }

  @override
  String get payWedgeLabel => 'Pană fiscală';

  @override
  String get creditTitle => 'Credite';

  @override
  String get creditTabLoan => 'Credit';

  @override
  String get creditTabDeposit => 'Economii';

  @override
  String get creditTabCompare => 'Comparație';

  @override
  String get loanAmount => 'Valoarea creditului';

  @override
  String get loanRate => 'Rata nominală a dobânzii';

  @override
  String get loanTerm => 'Perioadă';

  @override
  String get loanFee => 'Comision de acordare';

  @override
  String get loanMonthlyFee => 'Comisioane lunare';

  @override
  String get loanMonthlyFeeHint => 'Cont, asigurare…';

  @override
  String get loanRepayment => 'Rambursare';

  @override
  String get loanAnnuity => 'Rate egale';

  @override
  String get loanLinear => 'Rate descrescătoare';

  @override
  String get loanMore => 'Mai multe opțiuni';

  @override
  String get loanLess => 'Mai puține opțiuni';

  @override
  String get loanCurrency => 'Monedă';

  @override
  String get loanInstallment => 'Rată lunară';

  @override
  String get loanFirstInstallment => 'Prima rată';

  @override
  String get loanEir => 'DAE';

  @override
  String get loanTotalInterest => 'Dobândă totală';

  @override
  String get loanTotal => 'Total de rambursat';

  @override
  String loanTotalIncludes(String fees) {
    return 'Include principalul, dobânda și comisioane de $fees.';
  }

  @override
  String get loanEirNote =>
      'DAE este dobânda anuală efectivă, cu toate comisioanele incluse, calculată după formula UE pentru creditele de consum.';

  @override
  String get loanByYear => 'Pe ani';

  @override
  String get loanPrincipal => 'Principal';

  @override
  String get loanInterest => 'Dobândă';

  @override
  String loanYearShort(int n) {
    return 'An $n';
  }

  @override
  String get loanSchedule => 'Grafic de rambursare';

  @override
  String loanScheduleAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Graficul complet · $count de rate',
      few: 'Graficul complet · $count rate',
      one: 'Graficul complet · $count rată',
    );
    return '$_temp0';
  }

  @override
  String get loanColNo => 'Nr.';

  @override
  String get loanColInstallment => 'Rată';

  @override
  String get loanColInterest => 'Dobândă';

  @override
  String get loanColPrincipal => 'Principal';

  @override
  String get loanColBalance => 'Sold';

  @override
  String get loanPrepayTitle => 'Rambursare anticipată';

  @override
  String loanPrepayTeaser(
    String amount,
    int month,
    String months,
    String saved,
  ) {
    return 'O plată suplimentară de $amount după rata $month scurtează creditul cu $months și economisește $saved din dobândă.';
  }

  @override
  String get loanPrepayCta => 'Calculați scenariul dvs.';

  @override
  String get loanErrorPrincipal => 'Introduceți valoarea creditului.';

  @override
  String get loanErrorRate => 'Introduceți o rată a dobânzii între 0 și 100 %.';

  @override
  String get loanErrorTerm => 'Perioada trebuie să fie între 1 și 600 de luni.';

  @override
  String get loanErrorFee =>
      'Comisioanele trebuie să fie mai mici decât creditul.';

  @override
  String get prepayTitle => 'Rambursare anticipată';

  @override
  String prepayIntro(String amount, String rate, String term) {
    return 'Pe baza creditului dvs. actual: $amount la $rate pe $term.';
  }

  @override
  String get prepayNoLoan => 'Configurați mai întâi un credit în fila Credite.';

  @override
  String get prepayAmount => 'Plată suplimentară';

  @override
  String get prepayAfter => 'Plătită odată cu rata nr.';

  @override
  String get prepayMode => 'După plată';

  @override
  String get prepayShorten => 'Perioadă mai scurtă';

  @override
  String get prepayLower => 'Rată mai mică';

  @override
  String get prepayFee => 'Comision de rambursare anticipată';

  @override
  String get prepaySaved => 'Dobândă economisită';

  @override
  String get prepayNetSaving => 'Economie netă după comision';

  @override
  String get prepayNewTerm => 'Perioadă nouă';

  @override
  String get prepayNewInstallment => 'Rată nouă';

  @override
  String prepayMonthsSaved(String months) {
    return 'cu $months mai devreme';
  }

  @override
  String get prepayPaidOff => 'Plata suplimentară achită tot soldul rămas.';

  @override
  String get prepayBefore => 'Înainte';

  @override
  String get prepayAfterLabel => 'După';

  @override
  String get depAmount => 'Depozit';

  @override
  String get depRate => 'Rata dobânzii';

  @override
  String get depTerm => 'Perioadă';

  @override
  String get depPayout => 'Dobândă';

  @override
  String get depAtMaturity => 'La scadență';

  @override
  String get depMonthly => 'Lunar, capitalizată';

  @override
  String get depAnnually => 'Anual, capitalizată';

  @override
  String get depTax => 'Impozit pe dobândă';

  @override
  String get depTaxHintRs =>
      'În Serbia, dobânda la economiile în dinari este neimpozabilă; cea la economiile în valută se impozitează cu 15 %.';

  @override
  String get depTaxHint =>
      'Introduceți impozitul pe dobândă reținut la sursă care vi se aplică.';

  @override
  String get depContribution => 'Depunere lunară';

  @override
  String get depFinal => 'La scadență';

  @override
  String get depGrossInterest => 'Dobândă înainte de impozit';

  @override
  String get depTaxAmount => 'Impozit pe dobândă';

  @override
  String get depNetInterest => 'Dobândă netă';

  @override
  String get depPaidIn => 'Depus';

  @override
  String depYield(String percent) {
    return 'Randament net de $percent pe an';
  }

  @override
  String get depByYear => 'Pe ani';

  @override
  String get depColYear => 'An';

  @override
  String get depColInterest => 'Dobândă netă';

  @override
  String get depColBalance => 'Sold';

  @override
  String get depErrorAmount => 'Introduceți un depozit sau o depunere lunară.';

  @override
  String get depErrorRate => 'Introduceți o rată a dobânzii între 0 și 100 %.';

  @override
  String get cmpLoanIntro =>
      'Aceeași sumă pentru toate ofertele. Cea mai avantajoasă ofertă este cea cu cel mai mic cost total.';

  @override
  String cmpLoanOffer(int n) {
    return 'Oferta $n';
  }

  @override
  String get cmpLoanAdd => 'Adaugă ofertă';

  @override
  String get cmpLoanRemove => 'Elimină oferta';

  @override
  String get cmpLoanBest => 'Cel mai mic cost total';

  @override
  String cmpLoanSavesVs(String amount) {
    return 'cu $amount mai ieftină decât cea mai scumpă ofertă';
  }

  @override
  String get depYieldLabel => 'Randament anual net';

  @override
  String get fxTitle => 'Cursuri valutare';

  @override
  String get fxTabConverter => 'Convertor';

  @override
  String get fxTabList => 'Listă de cursuri';

  @override
  String fxAmount(String currency) {
    return 'Sumă în $currency';
  }

  @override
  String get fxSwap => 'Inversează monedele';

  @override
  String fxRateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get fxSourceNbsMiddle => 'curs mediu BNS';

  @override
  String get fxSourceNbsBuy => 'curs de cumpărare BNS';

  @override
  String get fxSourceNbsSell => 'curs de vânzare BNS';

  @override
  String get fxSourceEcb => 'curs de referință BCE';

  @override
  String get fxSourceCross => 'curs încrucișat';

  @override
  String get fxKindMiddle => 'Mediu';

  @override
  String get fxKindBuy => 'Cumpărare';

  @override
  String get fxKindSell => 'Vânzare';

  @override
  String get fxKindHint =>
      'Cursurile de cumpărare și vânzare se aplică la schimburile în dinari.';

  @override
  String fxUpdated(String date) {
    return 'Actualizat $date';
  }

  @override
  String fxOffline(String date) {
    return 'Offline · cursuri din $date';
  }

  @override
  String get fxLoading => 'Se actualizează cursurile…';

  @override
  String get fxNoRates =>
      'Încă nu există cursuri. Conectați-vă o dată la internet pentru a descărca cursurile oficiale de azi — după aceea convertorul funcționează și offline.';

  @override
  String get fxUnsupported =>
      'Nu există un curs oficial pentru această pereche.';

  @override
  String fxHistoryTitle(String from, String to, int days) {
    return '$from/$to · $days de zile';
  }

  @override
  String fxHistoryDays(int days) {
    return '$days z';
  }

  @override
  String get fxHistoryError => 'Istoricul nu este disponibil offline.';

  @override
  String get fxHistoryPro =>
      'Istoricul cursului pentru 30, 90 și 365 de zile face parte din Pro.';

  @override
  String fxHistoryMinMax(String min, String max) {
    return 'min. $min · max. $max';
  }

  @override
  String get fxPerUnit => 'Pentru 1 unitate de monedă';

  @override
  String get fxListNbs => 'Lista de cursuri BNS';

  @override
  String get fxListEcb => 'Cursuri de referință BCE, pentru 1 EUR';

  @override
  String get fxColBuy => 'Cumpărare';

  @override
  String get fxColMiddle => 'Mediu';

  @override
  String get fxColSell => 'Vânzare';

  @override
  String get fxColRate => 'Curs';

  @override
  String get fxRefresh => 'Actualizează cursurile';

  @override
  String get fxPickFrom => 'Convertește din';

  @override
  String get fxPickTo => 'Convertește în';

  @override
  String get fxSourcesNote =>
      'Cursuri oficiale ale Băncii Naționale a Serbiei prin kurs.resenje.org; cursuri de referință ale Băncii Centrale Europene prin Frankfurter. Marca este fixată la 1,95583 pentru un euro.';

  @override
  String get bizTitle => 'Afaceri';

  @override
  String get bizProfile => 'Datele firmei';

  @override
  String get bizInvoices => 'Facturi';

  @override
  String get bizNewInvoice => 'Nouă';

  @override
  String get bizInvoicesEmpty =>
      'Încă nu aveți facturi. Creați o factură profesională în mai puțin de un minut.';

  @override
  String bizFreeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Au mai rămas $count de facturi gratuite',
      few: 'Au mai rămas $count facturi gratuite',
      one: 'A mai rămas $count factură gratuită',
    );
    return '$_temp0';
  }

  @override
  String get bizTools => 'Instrumente';

  @override
  String bizShowAll(int count) {
    return 'Afișează toate ($count)';
  }

  @override
  String bizPausalCard(int year) {
    return 'Paušal · $year';
  }

  @override
  String get statusDraft => 'Ciornă';

  @override
  String get statusIssued => 'În așteptarea plății';

  @override
  String get statusPaid => 'Plătită';

  @override
  String get statusCancelled => 'Anulată';

  @override
  String get statusOverdue => 'Restantă';

  @override
  String get invNew => 'Factură nouă';

  @override
  String get invEdit => 'Editare factură';

  @override
  String get invNumber => 'Numărul facturii';

  @override
  String get invIssueDate => 'Data emiterii';

  @override
  String get invServiceDate => 'Data livrării';

  @override
  String get invDueDate => 'Data scadenței';

  @override
  String get invPlace => 'Locul emiterii';

  @override
  String get invClient => 'Client';

  @override
  String get invClientName => 'Numele clientului';

  @override
  String get invClientAddress => 'Adresă';

  @override
  String get invClientCity => 'Cod poștal și localitate';

  @override
  String get invClientCountry => 'Țară';

  @override
  String get invClientTaxId => 'Cod fiscal (CUI / PIB / VAT)';

  @override
  String get invClientRegNo => 'Număr de înregistrare';

  @override
  String get invClientEmail => 'E-mail';

  @override
  String get invRecentClients => 'Clienți recenți';

  @override
  String get invCurrency => 'Monedă';

  @override
  String get invItems => 'Articole';

  @override
  String get invItemDescription => 'Descriere';

  @override
  String get invItemQty => 'Cantitate';

  @override
  String get invItemUnit => 'U.M.';

  @override
  String get invItemUnitHint => 'buc., oră, zi…';

  @override
  String get invItemPrice => 'Preț unitar';

  @override
  String get invItemVat => 'TVA %';

  @override
  String get invAddItem => 'Adaugă articol';

  @override
  String get invRemoveItem => 'Elimină articolul';

  @override
  String get invNote => 'Notă';

  @override
  String get invReference => 'Referință de plată';

  @override
  String get invReferenceHint => 'Model și număr, de ex. 97 1234';

  @override
  String get invSubtotal => 'Subtotal';

  @override
  String get invVat => 'TVA';

  @override
  String get invTotal => 'Total';

  @override
  String get invTotalDue => 'Total de plată';

  @override
  String get invTotalRsd => 'Contravaloare în RSD';

  @override
  String invRateLine(String rate, String date) {
    return 'Cursul mediu BNS $rate la $date';
  }

  @override
  String get invRateFetching => 'Se descarcă cursul BNS…';

  @override
  String get invRateUnavailable =>
      'Cursul BNS pentru această dată nu este încă publicat.';

  @override
  String get invRateRetry => 'Descarcă cursul';

  @override
  String get invSaveDraft => 'Salvează ciorna';

  @override
  String get invIssue => 'Emite factura';

  @override
  String get invSave => 'Salvează modificările';

  @override
  String get invMarkPaid => 'Marchează ca plătită';

  @override
  String get invMarkUnpaid => 'Marchează ca neplătită';

  @override
  String get invCancelInvoice => 'Anulează factura';

  @override
  String get invDelete => 'Șterge factura';

  @override
  String invDeleteConfirm(String number) {
    return 'Ștergeți factura $number? Acțiunea este ireversibilă.';
  }

  @override
  String get invDuplicate => 'Duplică';

  @override
  String get invProfileMissing =>
      'Adăugați mai întâi datele firmei — apar pe fiecare factură.';

  @override
  String get invNotInVat => 'Emitentul nu este înregistrat în scopuri de TVA.';

  @override
  String get invValidWithoutStamp =>
      'Factura este valabilă fără ștampilă și semnătură.';

  @override
  String get invQrCaption => 'Scanați pentru a plăti (NBS IPS)';

  @override
  String get invQrHint =>
      'Clientul scanează codul QR în aplicația băncii sale — suma, contul și referința se completează automat.';

  @override
  String invQrMissing(String reason) {
    return 'Fără cod QR de plată: $reason';
  }

  @override
  String get invQrReasonAccount =>
      'adăugați un cont bancar sârbesc valid în datele firmei';

  @override
  String get invQrReasonOther =>
      'verificați numele firmei și referința de plată';

  @override
  String get invDocTitle => 'Factură';

  @override
  String get invSeller => 'Furnizor';

  @override
  String get invBuyer => 'Cumpărător';

  @override
  String invPaidOn(String date) {
    return 'Plătită la $date';
  }

  @override
  String invDueOn(String date) {
    return 'Scadentă la $date';
  }

  @override
  String get invErrorClient => 'Introduceți numele clientului.';

  @override
  String get invErrorItems =>
      'Adăugați cel puțin un articol cu descriere și preț.';

  @override
  String get invErrorNumber => 'Introduceți numărul facturii.';

  @override
  String get invErrorDue =>
      'Data scadenței nu poate fi înaintea datei emiterii.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Factura $number există deja.';
  }

  @override
  String get invShare => 'Distribuie PDF';

  @override
  String get invAccount => 'Cont';

  @override
  String get invPib => 'PIB';

  @override
  String get invMb => 'MB';

  @override
  String get invReferenceLabel => 'Referință';

  @override
  String get invPlaceLabel => 'Loc';

  @override
  String get invColItem => 'Articol';

  @override
  String get invColQty => 'Cant.';

  @override
  String get invColPrice => 'Preț';

  @override
  String get invColAmount => 'Valoare';

  @override
  String get profTitle => 'Datele firmei';

  @override
  String get profIntro => 'Apar pe facturi și, dacă doriți, în rapoartele PDF.';

  @override
  String get profName => 'Numele firmei';

  @override
  String get profAddress => 'Strada și numărul';

  @override
  String get profCity => 'Cod poștal și localitate';

  @override
  String get profCountry => 'Țară';

  @override
  String get profTaxId => 'Cod fiscal (PIB)';

  @override
  String get profRegNo => 'Număr de înregistrare (MB)';

  @override
  String get profAccount => 'Cont bancar';

  @override
  String get profAccountHint => 'Cont sârbesc (160-0000000000000-00) sau IBAN';

  @override
  String get profBank => 'Bancă';

  @override
  String get profEmail => 'E-mail';

  @override
  String get profPhone => 'Telefon';

  @override
  String get profVat => 'Înregistrat în scopuri de TVA';

  @override
  String get profVatHint =>
      'Adaugă TVA pe facturi. Când este dezactivat, facturile menționează că nu sunteți plătitor de TVA.';

  @override
  String get profPaymentCode => 'Codul plății pentru codul QR';

  @override
  String get profPaymentCodeHint => '221 pentru plata bunurilor și serviciilor';

  @override
  String get profDueDays => 'Termen de plată implicit';

  @override
  String get profDueDaysSuffix => 'zile';

  @override
  String get profCurrency => 'Moneda implicită a facturilor';

  @override
  String get profNote => 'Nota implicită pe facturi';

  @override
  String get profShowOnReports => 'Afișează datele firmei în rapoartele PDF';

  @override
  String get profInvalidPib =>
      'Cifra de control a PIB-ului nu corespunde — verificați numărul.';

  @override
  String get profInvalidMb =>
      'Cifra de control a numărului de înregistrare nu corespunde.';

  @override
  String get profInvalidAccount =>
      'Cifrele de control ale numărului de cont nu corespund.';

  @override
  String get profSaved => 'Datele firmei au fost salvate';

  @override
  String get pausalTitle => 'Plafoane paušal';

  @override
  String get pausalIntro =>
      'Întreprinzătorii paušal din Serbia pierd acest regim dacă depășesc 6.000.000 RSD venituri într-un an calendaristic și trebuie să se înregistreze în scopuri de TVA peste 8.000.000 RSD în orice 12 luni.';

  @override
  String get pausalAnnual => 'Plafon paušal, an calendaristic';

  @override
  String get pausalVat => 'Plafon TVA, ultimele 12 luni';

  @override
  String pausalOf(String amount) {
    return 'din $amount';
  }

  @override
  String pausalLeft(String amount) {
    return 'Rămân $amount';
  }

  @override
  String pausalProjection(String amount) {
    return 'În acest ritm veți factura aproximativ $amount până la 31 decembrie.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'În acest ritm veți depăși plafonul paušal înainte de sfârșitul anului (aproximativ $amount).';
  }

  @override
  String get pausalWarn => 'Ați folosit peste 80 % din acest plafon.';

  @override
  String get pausalOver => 'Plafon depășit — discutați cu contabilul dvs.';

  @override
  String pausalMissingRate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de facturi în valută nu au curs BNS și nu sunt incluse.',
      few: '$count facturi în valută nu au curs BNS și nu sunt incluse.',
      one: '$count factură în valută nu are curs BNS și nu este inclusă.',
    );
    return '$_temp0';
  }

  @override
  String get pausalSourceInvoices =>
      'Calculat din facturile emise și plătite (după data livrării), plus veniturile adăugate mai jos.';

  @override
  String get pausalManual => 'Venituri din afara aplicației';

  @override
  String get pausalManualEmpty =>
      'Adăugați facturile emise în altă parte anul acesta, pentru ca totalurile să fie complete.';

  @override
  String get pausalManualAdd => 'Adaugă venit';

  @override
  String get pausalManualDate => 'Data';

  @override
  String get pausalManualAmount => 'Suma în RSD';

  @override
  String get pausalManualNote => 'Notă';

  @override
  String get vatTitle => 'Calculator TVA';

  @override
  String get vatAdd => 'Adaugă TVA';

  @override
  String get vatExtract => 'Extrage TVA';

  @override
  String get vatAmountNet => 'Suma fără TVA';

  @override
  String get vatAmountGross => 'Suma cu TVA';

  @override
  String get vatRate => 'Cota de TVA';

  @override
  String get vatOther => 'Alta';

  @override
  String get vatNet => 'Fără TVA';

  @override
  String get vatVat => 'TVA';

  @override
  String get vatGross => 'Cu TVA';

  @override
  String get mrgTitle => 'Marjă și adaos comercial';

  @override
  String get mrgFromPrice => 'Cost și preț';

  @override
  String get mrgFromMarkup => 'Adaos';

  @override
  String get mrgFromMargin => 'Marjă';

  @override
  String get mrgCost => 'Preț de achiziție';

  @override
  String get mrgPrice => 'Preț de vânzare (fără TVA)';

  @override
  String get mrgMarkup => 'Adaos comercial';

  @override
  String get mrgMargin => 'Marjă';

  @override
  String get mrgDiscount => 'Reducere';

  @override
  String get mrgVat => 'TVA';

  @override
  String get mrgProfit => 'Profit brut';

  @override
  String get mrgPriceAfterDiscount => 'Preț după reducere';

  @override
  String get mrgPriceWithVat => 'Preț cu TVA';

  @override
  String get mrgMarginHint =>
      'Marja este profitul ca pondere din prețul de vânzare; adaosul este profitul ca pondere din cost.';

  @override
  String get mrgImpossible => 'O marjă de 100 % sau mai mare nu este posibilă.';

  @override
  String get beTitle => 'Prag de rentabilitate';

  @override
  String get beFixed => 'Costuri fixe lunare';

  @override
  String get bePrice => 'Preț pe unitate';

  @override
  String get beVariable => 'Cost variabil pe unitate';

  @override
  String get beTarget => 'Profit țintă lunar';

  @override
  String get beUnits => 'Unități de vândut pe lună';

  @override
  String beUnitsValue(int count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted de unități',
      few: '$formatted unități',
      one: '$formatted unitate',
    );
    return '$_temp0';
  }

  @override
  String get beRevenue => 'Venit necesar';

  @override
  String get beContribution => 'Marjă de contribuție';

  @override
  String get beImpossible =>
      'Prețul trebuie să fie mai mare decât costul variabil pe unitate.';

  @override
  String get invsTitle => 'Analiza investiției';

  @override
  String get invsInitial => 'Investiția inițială';

  @override
  String get invsRate => 'Rata de actualizare';

  @override
  String get invsFlows => 'Flux de numerar net pe ani';

  @override
  String invsYear(int n) {
    return 'Anul $n';
  }

  @override
  String get invsAddYear => 'Adaugă un an';

  @override
  String get invsRemoveYear => 'Elimină ultimul an';

  @override
  String get invsNpv => 'Valoarea actualizată netă (VAN)';

  @override
  String get invsIrr => 'Rata internă de rentabilitate (RIR)';

  @override
  String get invsPayback => 'Perioada de recuperare';

  @override
  String get invsDiscountedPayback => 'Perioada de recuperare actualizată';

  @override
  String get invsPi => 'Indicele de profitabilitate';

  @override
  String invsYears(String years) {
    return '$years ani';
  }

  @override
  String get invsNever => 'Nu în acești ani';

  @override
  String get invsNoIrr => 'Nu există RIR pentru aceste fluxuri';

  @override
  String invsGood(String rate) {
    return 'Creează valoare la o rată de actualizare de $rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Distruge valoare la o rată de actualizare de $rate.';
  }

  @override
  String get profSectionBusiness => 'Firmă';

  @override
  String get profSectionPayment => 'Plată';

  @override
  String get profSectionContact => 'Contact';

  @override
  String get profSectionInvoices => 'Setări implicite pentru facturi';

  @override
  String get profTaxIdGeneric => 'Cod fiscal';

  @override
  String get profRegNoGeneric => 'Număr de înregistrare';

  @override
  String get profNameRequired => 'Introduceți numele firmei.';

  @override
  String get profPibLength => 'PIB-ul are 9 cifre.';

  @override
  String get profMbLength => 'Numărul de înregistrare are 8 cifre.';

  @override
  String get profInvalidAccountShape =>
      'Introduceți un cont sârbesc (160-0000000000000-00) sau un IBAN.';

  @override
  String get profInvalidEmail => 'Verificați adresa de e-mail.';

  @override
  String get profInvalidPaymentCode =>
      'Codul plății are trei cifre, de ex. 221.';

  @override
  String get profPrivacy =>
      'Datele sunt stocate doar pe acest telefon și sunt incluse în copiile de rezervă pe care le exportați.';

  @override
  String get profIban => 'IBAN pentru plăți din străinătate';

  @override
  String get profIbanHint =>
      'Apare pe facturile în valută. Lăsați gol pentru a folosi contul de mai sus în format IBAN.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban =>
      'Verificați IBAN-ul — cifrele de control nu corespund.';

  @override
  String get profInvalidSwift => 'Un cod SWIFT/BIC are 8 sau 11 caractere.';

  @override
  String get invIban => 'IBAN';

  @override
  String get invSwift => 'SWIFT/BIC';

  @override
  String get invBank => 'Bancă';

  @override
  String get invSefNote =>
      'Facturile către sectorul public sârbesc — și, pentru plătitorii de TVA, către firmele sârbești — trebuie trimise și prin SEF (e-Faktura). Facturile Bilans sunt potrivite pentru clienți din străinătate, persoane fizice și evidența proprie.';

  @override
  String get invRateOffline =>
      'BNS nu poate fi contactată. Verificați conexiunea — puteți salva acum și descărca cursul mai târziu.';

  @override
  String get invMarkedPaid => 'Marcată ca plătită';

  @override
  String get invMarkedUnpaid => 'Marcată ca neplătită';

  @override
  String get invIssued => 'Factura a fost emisă';

  @override
  String get invCancelled => 'Factura a fost anulată';

  @override
  String get invCompleteFirst =>
      'Adăugați clientul și cel puțin un articol înainte de emitere.';

  @override
  String invCancelConfirm(String number) {
    return 'Anulați factura $number?';
  }

  @override
  String get invCancelBody =>
      'Rămâne în listă, marcată ca anulată, și nu mai este inclusă în venituri.';

  @override
  String get invRateMissingNote =>
      'Încă nu există curs BNS — factura nu este inclusă în plafoanele paušal până nu îl primește.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'Pentru a rămâne sub plafon, facturați cel mult aproximativ $amount pe lună până la sfârșitul anului.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Venituri pe luni, $year';
  }

  @override
  String get pausalFromInvoices => 'Facturi';

  @override
  String get pausalDisclaimer =>
      'Veniturile sunt calculate după data livrării. Facturile în valută folosesc cursul mediu BNS din data emiterii. Verificați cifrele finale cu contabilul dvs.';

  @override
  String get pausalRemoveTitle => 'Eliminați acest venit?';

  @override
  String get pausalManualAmountError => 'Introduceți o sumă.';

  @override
  String get invsFilterAll => 'Toate';

  @override
  String get invsFilterDrafts => 'Ciorne';

  @override
  String get invsOutstanding => 'În așteptarea plății';

  @override
  String get invsSearchHint => 'Căutați după client sau număr';

  @override
  String get invsNoMatch => 'Nicio factură nu corespunde.';

  @override
  String get vatEmpty =>
      'Introduceți o sumă pentru a o împărți în valoare netă și TVA.';

  @override
  String vatRatesNote(String country) {
    return 'Sunt afișate cotele de TVA standard și reduse pentru: $country.';
  }

  @override
  String get mrgEmpty => 'Introduceți costul și un preț, un adaos sau o marjă.';

  @override
  String get mrgLoss => 'La acest preț vindeți sub cost.';

  @override
  String get beFixedHint => 'Chirie, salarii, abonamente…';

  @override
  String get beVariableHint => 'Materiale, comisioane, livrare…';

  @override
  String get beEmpty =>
      'Introduceți costurile fixe, prețul și costul variabil pe unitate.';

  @override
  String get beContributionUnit => 'Contribuție pe unitate';

  @override
  String get beExplain =>
      'Fiecare unitate vândută contribuie cu prețul minus costul variabil la acoperirea costurilor fixe și la profit. Sumele sunt fără TVA.';

  @override
  String get invsFlowsHint =>
      'Fluxul de numerar net la sfârșitul fiecărui an. Introduceți un minus pentru un an cu mai multe ieșiri decât intrări.';

  @override
  String get invsEmpty =>
      'Introduceți investiția, o rată de actualizare și fluxul de numerar pentru cel puțin un an.';

  @override
  String get invsCumulative => 'Flux de numerar cumulat';

  @override
  String get invCreatedWith => 'Creat cu Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead =>
      'Toate calculatoarele, toate țările, facturi nelimitate și rapoarte PDF. Fără reclame, fără cont.';

  @override
  String get proFeatAllCountries =>
      'Salarii pentru toate cele 9 sisteme fiscale';

  @override
  String get proFeatUnlimitedInvoices => 'Facturi nelimitate';

  @override
  String get proFeatPdf => 'Rapoarte PDF';

  @override
  String get proFeatUnlimitedSaves => 'Calcule salvate nelimitate';

  @override
  String get proBenefitCountries =>
      'Salarii pentru toate cele 9 sisteme fiscale și același salariu comparat între țări';

  @override
  String get proBenefitTeam =>
      'Costul echipei: toate salariile pe luni și pe ani';

  @override
  String get proBenefitInvoices =>
      'Facturi nelimitate, ca PDF-uri profesionale';

  @override
  String get proBenefitInvoicesRs =>
      'Facturi nelimitate cu cod QR de plată NBS IPS';

  @override
  String get proBenefitPausal =>
      'Monitorizarea plafoanelor paušal de 6 și 8 milioane de dinari';

  @override
  String get proBenefitLoans =>
      'Comparați oferte de credit și planificați rambursări anticipate';

  @override
  String get proBenefitHistory =>
      'Istoricul cursului pentru 30, 90 și 365 de zile';

  @override
  String get proBenefitInvestment =>
      'Analiza investițiilor: VAN, RIR și perioada de recuperare';

  @override
  String get proBenefitPdf =>
      'Rapoarte PDF pentru salarii, credite, economii și echipe';

  @override
  String get proYearly => 'Anual';

  @override
  String get proMonthly => 'Lunar';

  @override
  String get proLifetime => 'Pe viață';

  @override
  String get proPerYear => 'pe an';

  @override
  String get proPerMonth => 'pe lună';

  @override
  String get proOnce => 'o singură dată';

  @override
  String proSave(int percent) {
    return 'ECONOMISIȚI $percent %';
  }

  @override
  String proTrialNote(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days de zile gratuite, apoi facturare anuală',
      few: '$days zile gratuite, apoi facturare anuală',
      one: '$days zi gratuită, apoi facturare anuală',
    );
    return '$_temp0';
  }

  @override
  String get proLifetimeNote => 'Plătiți o dată, păstrați Pro pentru totdeauna';

  @override
  String proStartTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Începeți perioada de probă de $days de zile',
      few: 'Începeți perioada de probă de $days zile',
      one: 'Începeți perioada de probă de $days zi',
    );
    return '$_temp0';
  }

  @override
  String get proContinue => 'Continuă';

  @override
  String get proRestore => 'Restabilește';

  @override
  String get proRestored => 'Bilans Pro este activ pe acest dispozitiv.';

  @override
  String get proNothingToRestore =>
      'Nu a fost găsită nicio achiziție Bilans Pro pentru acest cont Google.';

  @override
  String get proPending =>
      'Plata este în curs de procesare. Pro se deblochează automat imediat ce Google Play o confirmă.';

  @override
  String get proError =>
      'Achiziția nu a reușit. Nu ați fost taxat — încercați din nou.';

  @override
  String get proUnavailable =>
      'Achizițiile nu sunt disponibile acum. Verificați dacă Google Play este instalat și dacă sunteți conectat, apoi încercați din nou.';

  @override
  String get proLegal =>
      'Abonamentele se reînnoiesc automat la prețul afișat până când le anulați. Puteți anula oricând din Google Play → Plăți și abonamente, cu cel puțin 24 de ore înainte de data reînnoirii. Perioada de probă gratuită devine un abonament anual plătit dacă nu o anulați înainte de încheierea ei.';

  @override
  String get proLegalLifetime =>
      'O achiziție unică: fără abonament și fără reînnoiri. Pro rămâne activ pe fiecare dispozitiv conectat la același cont Google.';

  @override
  String get proDevSimulate => 'Simulează Pro (versiune de dezvoltare)';

  @override
  String get proWelcome => 'Bun venit la Bilans Pro';

  @override
  String get proWelcomeBody =>
      'Totul este deblocat. Vă mulțumim că susțineți o aplicație independentă.';

  @override
  String get settingsPreferences => 'Preferințe';

  @override
  String get settingsTheme => 'Aspect';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsThemeLight => 'Luminos';

  @override
  String get settingsThemeDark => 'Întunecat';

  @override
  String get settingsYourData => 'Datele dvs.';

  @override
  String get settingsExport => 'Exportă o copie de rezervă';

  @override
  String get settingsImport => 'Restabilește dintr-o copie de rezervă';

  @override
  String get settingsBackupSubject => 'Copie de rezervă Bilans';

  @override
  String get settingsExported => 'Copia de rezervă este gata';

  @override
  String get settingsImportInvalid =>
      'Fișierul nu este o copie de rezervă Bilans.';

  @override
  String get settingsImportTitle => 'Restabiliți această copie de rezervă?';

  @override
  String get settingsImportBody =>
      'Tot conținutul aplicației va fi înlocuit cu cel din copie — facturi, datele firmei, echipa și calculele salvate.';

  @override
  String get settingsImportAction => 'Restabilește';

  @override
  String get settingsImported => 'Copia de rezervă a fost restabilită';

  @override
  String get settingsDeleteAll => 'Șterge toate datele';

  @override
  String get settingsDeleteTitle => 'Ștergeți toate datele?';

  @override
  String get settingsDeleteBody =>
      'Facturile, datele firmei, echipa, calculele salvate și setările vor fi eliminate de pe acest telefon. Dacă ați putea avea nevoie de ele, exportați mai întâi o copie de rezervă. Achiziția Pro nu este afectată.';

  @override
  String get settingsDeleteAction => 'Șterge tot';

  @override
  String get settingsDataNote =>
      'Bilans nu are conturi și nici servere: datele dvs. există doar pe acest telefon. Exportați o copie de rezervă pentru a le muta pe un telefon nou.';

  @override
  String get settingsAbout => 'Despre';

  @override
  String get settingsRate => 'Evaluați Bilans pe Google Play';

  @override
  String get settingsContact => 'Contact';

  @override
  String get settingsPrivacy => 'Politica de confidențialitate';

  @override
  String get settingsTerms => 'Termeni de utilizare';

  @override
  String get settingsLicenses => 'Licențe open source';

  @override
  String get settingsDisclaimer =>
      'Calculele sunt orientative și nu înlocuiesc consultanța fiscală, juridică sau financiară de specialitate.';

  @override
  String get settingsProActive => 'Bilans Pro este activ';

  @override
  String get settingsManageSubscription => 'Gestionează abonamentul';

  @override
  String get settingsProPitch =>
      'Toate țările, costul echipei, facturi nelimitate, rapoarte PDF și multe altele.';

  @override
  String get settingsSeePlans => 'Vezi planurile';

  @override
  String get proIncluded => 'Inclus în Pro';

  @override
  String proSummaryTrial(int days, String price, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days de zile gratuite, apoi $price $period. Anulați oricând.',
      few: '$days zile gratuite, apoi $price $period. Anulați oricând.',
      one: '$days zi gratuită, apoi $price $period. Anulați oricând.',
    );
    return '$_temp0';
  }

  @override
  String proSummary(String price, String period) {
    return '$price $period, cu reînnoire automată. Anulați oricând.';
  }

  @override
  String proSummaryLifetime(String price) {
    return 'O singură plată de $price. Fără abonament.';
  }
}
