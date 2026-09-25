// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Macedonian (`mk`).
class AppLocalizationsMk extends AppLocalizations {
  AppLocalizationsMk([String locale = 'mk']) : super(locale);

  @override
  String get appName => 'Bilans';

  @override
  String get appTagline => 'Финансиски калкулатор';

  @override
  String get navHome => 'Почетна';

  @override
  String get navPayroll => 'Плата';

  @override
  String get navCredit => 'Кредити';

  @override
  String get navFx => 'Курс';

  @override
  String get navBusiness => 'Бизнис';

  @override
  String get actionSave => 'Зачувај';

  @override
  String get actionShare => 'Сподели';

  @override
  String get actionDelete => 'Избриши';

  @override
  String get actionCancel => 'Откажи';

  @override
  String get actionClose => 'Затвори';

  @override
  String get actionDone => 'Готово';

  @override
  String get actionRetry => 'Обиди се повторно';

  @override
  String get actionEdit => 'Уреди';

  @override
  String get actionContinue => 'Продолжи';

  @override
  String get actionRemove => 'Отстрани';

  @override
  String get actionUndo => 'Врати';

  @override
  String get actionDownloadPdf => 'Преземи PDF';

  @override
  String get actionRename => 'Преименувај';

  @override
  String get actionClear => 'Исчисти';

  @override
  String get commonMonthly => 'Месечно';

  @override
  String get commonAnnual => 'Годишно';

  @override
  String get commonMonthsShort => 'мес.';

  @override
  String commonMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месеци',
      one: '$count месец',
    );
    return '$_temp0';
  }

  @override
  String commonYearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count години',
      one: '$count година',
    );
    return '$_temp0';
  }

  @override
  String get commonPercentPa => '% год.';

  @override
  String get commonOptional => 'незадолжително';

  @override
  String get commonSearch => 'Пребарување';

  @override
  String get commonToday => 'Денес';

  @override
  String get snackSaved => 'Зачувано';

  @override
  String get snackDeleted => 'Избришано';

  @override
  String get errorGeneric => 'Нешто тргна наопаку. Обидете се повторно.';

  @override
  String get errorShare => 'Споделувањето моментално не е можно.';

  @override
  String get errorOpenLink => 'Врската не може да се отвори.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature е дел од пакетот Bilans Pro';
  }

  @override
  String get countryRS => 'Србија';

  @override
  String get countryHR => 'Хрватска';

  @override
  String get countryBA => 'Босна и Херцеговина';

  @override
  String get countryME => 'Црна Гора';

  @override
  String get countryMK => 'Северна Македонија';

  @override
  String get countrySI => 'Словенија';

  @override
  String get countryBG => 'Бугарија';

  @override
  String get countryRO => 'Романија';

  @override
  String get systemFbih => 'Федерација на БиХ';

  @override
  String get systemRepublikaSrpska => 'Република Српска';

  @override
  String get curEUR => 'Евро';

  @override
  String get curUSD => 'Американски долар';

  @override
  String get curCHF => 'Швајцарски франк';

  @override
  String get curGBP => 'Британска фунта';

  @override
  String get curRSD => 'Српски динар';

  @override
  String get curBAM => 'Конвертибилна марка';

  @override
  String get curMKD => 'Македонски денар';

  @override
  String get curRON => 'Романски леј';

  @override
  String get curHUF => 'Унгарска форинта';

  @override
  String get curCZK => 'Чешка круна';

  @override
  String get curPLN => 'Полски злот';

  @override
  String get curSEK => 'Шведска круна';

  @override
  String get curNOK => 'Норвешка круна';

  @override
  String get curDKK => 'Данска круна';

  @override
  String get curJPY => 'Јапонски јен';

  @override
  String get curCNY => 'Кинески јуан';

  @override
  String get curCAD => 'Канадски долар';

  @override
  String get curAUD => 'Австралиски долар';

  @override
  String get curTRY => 'Турска лира';

  @override
  String get curRUB => 'Руска рубља';

  @override
  String get formFixErrors => 'Поправете ги означените полиња.';

  @override
  String get discardTitle => 'Да се отфрлат промените?';

  @override
  String get discardBody => 'Промените не се зачувани.';

  @override
  String get discardKeep => 'Продолжи со уредување';

  @override
  String get discardAction => 'Отфрли';

  @override
  String get commonMore => 'Повеќе опции';

  @override
  String get errorPdf => 'PDF-от не беше направен. Обидете се повторно.';

  @override
  String get pdfLanguageTitle => 'Јазик на фактурата';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + англиски';
  }

  @override
  String get onbHeadline => 'Бројки на кои можете да се потпрете.';

  @override
  String get onbBody => 'Плати, кредити, официјални курсеви и фактури — пресметани според правилата на вашата земја. Без сметка, без следење.';

  @override
  String get onbCountry => 'Вашата земја';

  @override
  String get onbBihEntities => 'Федерација на БиХ и Република Српска';

  @override
  String get onbLanguage => 'Јазик на апликацијата';

  @override
  String get onbLanguageDevice => 'Јазик на уредот';

  @override
  String get onbPrivacy => 'Вашите податоци остануваат на овој телефон.';

  @override
  String get homeSearchHint => 'Пребарај калкулатори';

  @override
  String get homeSettings => 'Поставки';

  @override
  String get homeRatesTitle => 'Денешен курс';

  @override
  String homeRatesNbs(String date) {
    return 'Среден курс на НБС · $date';
  }

  @override
  String homeRatesEcb(String date) {
    return 'Референтен курс на ЕЦБ · $date';
  }

  @override
  String get homeRatesEmpty => 'Денешните официјални курсеви ќе се појават тука штом ќе бидете на интернет.';

  @override
  String get homeRecent => 'Неодамна';

  @override
  String get homeSeeAll => 'Сите';

  @override
  String get homeSectionPayroll => 'Плата';

  @override
  String get homeSectionCredit => 'Кредити и штедење';

  @override
  String get homeSectionFx => 'Курсна листа';

  @override
  String get homeSectionBusiness => 'Бизнис';

  @override
  String homeNoResults(String query) {
    return 'Ниеден калкулатор не одговара на „$query“.';
  }

  @override
  String get toolPayroll => 'Бруто и нето плата';

  @override
  String get toolPayrollDesc => 'Пресметка за 9 даночни системи';

  @override
  String get toolTeam => 'Трошок за тимот';

  @override
  String get toolTeamDesc => 'Месечен и годишен трошок за плати';

  @override
  String get toolCompare => 'Споредба на земји';

  @override
  String get toolCompareDesc => 'Иста плата во 9 системи';

  @override
  String get toolLoan => 'Кредит';

  @override
  String get toolLoanDesc => 'Рата, ЕКС и отплатен план';

  @override
  String get toolDeposit => 'Орочен депозит';

  @override
  String get toolDepositDesc => 'Камата и данок на камата';

  @override
  String get toolLoanCompare => 'Споредба на кредити';

  @override
  String get toolLoanCompareDesc => 'До три понуди, подредени по ЕКС';

  @override
  String get toolPrepay => 'Предвремена отплата';

  @override
  String get toolPrepayDesc => 'Колку камата заштедувате';

  @override
  String get toolConverter => 'Конвертор на валути';

  @override
  String get toolConverterDesc => 'Официјални курсеви на НБС и ЕЦБ';

  @override
  String get toolRateHistory => 'Историја на курсот';

  @override
  String get toolRateHistoryDesc => '30, 90 и 365 дена';

  @override
  String get toolInvoices => 'Фактури';

  @override
  String get toolInvoicesDescRs => 'PDF со NBS IPS QR-код';

  @override
  String get toolInvoicesDesc => 'Професионални PDF фактури';

  @override
  String get toolPausal => 'Паушал лимити';

  @override
  String get toolPausalDesc => '6 и 8 милиони динари, во живо';

  @override
  String get toolVat => 'ДДВ';

  @override
  String get toolVatDesc => 'Додавање или издвојување ДДВ';

  @override
  String get toolMargin => 'Маржа и надценка';

  @override
  String get toolMarginDesc => 'Набавна цена, продажна цена и попуст';

  @override
  String get toolBreakEven => 'Точка на рентабилност';

  @override
  String get toolBreakEvenDesc => 'Колку треба да продадете';

  @override
  String get toolInvestment => 'Инвестиција';

  @override
  String get toolInvestmentDesc => 'НСВ, ИСП и период на поврат';

  @override
  String recentPayroll(String country) {
    return 'Плата · $country';
  }

  @override
  String recentFromGross(String amount) {
    return 'нето од $amount бруто';
  }

  @override
  String recentFromNet(String amount) {
    return 'бруто за $amount нето';
  }

  @override
  String recentFromCost(String amount) {
    return 'бруто во буџет од $amount';
  }

  @override
  String recentLoan(String term) {
    return 'Кредит · $term';
  }

  @override
  String recentLoanSub(String eir) {
    return 'рата · ЕКС $eir';
  }

  @override
  String recentDeposit(String term) {
    return 'Депозит · $term';
  }

  @override
  String recentDepositSub(String rate) {
    return 'на достасување · $rate';
  }

  @override
  String recentVatAdd(String amount, String rate) {
    return '$amount + ДДВ $rate';
  }

  @override
  String recentVatExtract(String amount, String rate) {
    return 'основица од $amount по $rate';
  }

  @override
  String recentMarginSub(String margin) {
    return 'цена со ДДВ · маржа $margin';
  }

  @override
  String recentBreakEvenSub(String amount) {
    return 'месечно · приход $amount';
  }

  @override
  String recentInvestmentSub(String irr) {
    return 'НСВ · ИСП $irr';
  }

  @override
  String get historyTitle => 'Зачувани и неодамнешни';

  @override
  String get historySaved => 'Зачувани';

  @override
  String get historySavedEmpty => 'Допрете Зачувај на кој било резултат за да го чувате тука под име.';

  @override
  String get historyRecentEmpty => 'Завршените пресметки се појавуваат тука автоматски.';

  @override
  String get historyClearTitle => 'Да се исчисти списокот на неодамнешни?';

  @override
  String get payTitle => 'Пресметка на плата';

  @override
  String get payModeGross => 'Бруто → нето';

  @override
  String get payModeNet => 'Нето → бруто';

  @override
  String get payModeCost => 'Вкупен трошок';

  @override
  String get payModeSemantic => 'Насока на пресметката';

  @override
  String get payInputGross => 'Бруто плата · месечно';

  @override
  String get payInputNet => 'Посакувана нето плата · месечно';

  @override
  String get payInputCost => 'Буџет на работодавачот · месечно';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Најниска основица за придонеси: $amount';
  }

  @override
  String get payHelperNet => 'Износот што го прима вработениот';

  @override
  String get payHelperCost => 'Бруто плата со сите придонеси на работодавачот';

  @override
  String get payResultNet => 'Нето плата';

  @override
  String get payResultGross => 'Потребна бруто плата';

  @override
  String get payResultGrossBudget => 'Бруто плата во рамките на буџетот';

  @override
  String payShareOfGross(String percent) {
    return '$percent од бруто износот';
  }

  @override
  String payNetLine(String amount) {
    return 'Нето плата: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Вкупен трошок на работодавачот: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'Каде оди вкупниот трошок на работодавачот';

  @override
  String get segNet => 'Нето плата';

  @override
  String get segTax => 'Данок';

  @override
  String get segEmployee => 'Придонеси на вработениот';

  @override
  String get segEmployer => 'Придонеси на работодавачот';

  @override
  String get payBreakdown => 'Пресметка';

  @override
  String get payAnnualToggle => 'Годишно ×12';

  @override
  String get payEmployee => 'Вработен';

  @override
  String get payEmployer => 'Работодавач';

  @override
  String get payGross => 'Бруто плата';

  @override
  String get payNetTotal => 'Нето плата';

  @override
  String get payTotalCost => 'Вкупен трошок за платата';

  @override
  String get payNonTaxable => 'Неоданочив износ';

  @override
  String get payPersonalAllowance => 'Личен одбиток';

  @override
  String get payGeneralAllowance => 'Општо намалување';

  @override
  String get payPersonalExemption => 'Лично ослободување';

  @override
  String get payPersonalDeduction => 'Лично намалување';

  @override
  String get payTaxBase => 'Даночна основа';

  @override
  String get payIncomeTax => 'Персонален данок на доход';

  @override
  String payTaxOn(String rate, String amount) {
    return '$rate на $amount';
  }

  @override
  String get paySurtax => 'Прирез';

  @override
  String payOnBase(String amount) {
    return 'на $amount';
  }

  @override
  String get payFixedMonthly => 'фиксно месечно';

  @override
  String payWedge(String percent) {
    return 'Даночен клин $percent';
  }

  @override
  String payRulesFrom(String date) {
    return 'Прописи од $date';
  }

  @override
  String get paySources => 'Извори';

  @override
  String payDisclaimer(String date) {
    return 'Информативна пресметка според прописите што важат од $date. Не ја заменува официјалната пресметка на плата.';
  }

  @override
  String get payAnnualNote => 'Годишните износи се 12 × месечните; годишното даночно усогласување може да се разликува.';

  @override
  String payNoteMinBase(String amount) {
    return 'Придонесите се пресметуваат на најниската основица од $amount.';
  }

  @override
  String payNoteMaxBase(String amount) {
    return 'Над највисоката основица од $amount придонеси не се пресметуваат.';
  }

  @override
  String payNoteRelief(String amount) {
    return 'Олеснувањето за пониски плати ја намалува основицата за пензиско на $amount.';
  }

  @override
  String get payNoteNonPositive => 'Задолжителните давачки се поголеми од оваа плата.';

  @override
  String get payEmpty => 'Внесете износ за целосна пресметка — придонеси, данок и вкупен трошок на работодавачот.';

  @override
  String get payErrorTooLarge => 'Износот е преголем за пресметка.';

  @override
  String get paySystemTitle => 'Даночен систем';

  @override
  String get paySystemProHint => 'Вашата земја е бесплатна. Другите земји се дел од пакетот Pro.';

  @override
  String get payOptions => 'Опции';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Данок $lower / $higher · деца $children';
  }

  @override
  String payOptionsMeSummary(String rate) {
    return 'Прирез $rate';
  }

  @override
  String payOptionsRoSummary(int count) {
    return 'Издржувани членови $count';
  }

  @override
  String get payOptionsRoMinWage => 'олеснување за минимална плата';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Фонд за лица со попреченост $state';
  }

  @override
  String get payOn => 'вклучен';

  @override
  String get payOff => 'исклучен';

  @override
  String get payHrRates => 'Општински стапки на данок на доход';

  @override
  String get payHrLower => 'Пониска стапка';

  @override
  String get payHrHigher => 'Повисока стапка';

  @override
  String get payHrRatesHint => 'Ги утврдува градот или општината: 15–23 % и 25–33 %. Без одлука важат 20 % и 30 %.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'Пониска стапка $lowRange, повисока стапка $highRange';
  }

  @override
  String get payChildren => 'Деца';

  @override
  String get payDependents => 'Други издржувани членови';

  @override
  String get payRoDependents => 'Издржувани членови';

  @override
  String get payRoMinWage => 'Олеснување за минимална плата';

  @override
  String get payRoMinWageHint => 'За вработените со национална минимална плата 200 леи се ослободени.';

  @override
  String get payMeSurtax => 'Стапка на прирез';

  @override
  String get payMeSurtaxHint => '13 % во повеќето општини, 15 % во Подгорица и Цетиње.';

  @override
  String get payFbihDisability => 'Фонд за вработување лица со попреченост 0,5 %';

  @override
  String get payFbihDisabilityHint => 'Го плаќаат фирмите што не вработуваат пропишан број лица со попреченост.';

  @override
  String get itemPension => 'Пензиско и инвалидско осигурување';

  @override
  String get itemHealth => 'Здравствено осигурување';

  @override
  String get itemUnemployment => 'Осигурување во случај на невработеност';

  @override
  String get itemChildProtection => 'Детска заштита';

  @override
  String get itemWorkInjury => 'Осигурување од повреда при работа';

  @override
  String get itemLaborFund => 'Фонд на трудот';

  @override
  String get itemChamber => 'Стопанска комора';

  @override
  String get itemPillar1 => 'Пензиско осигурување, I столб';

  @override
  String get itemPillar2 => 'Пензиско осигурување, II столб';

  @override
  String get itemLongTermCare => 'Долготрајна нега';

  @override
  String get itemParental => 'Родителска заштита';

  @override
  String get itemCompulsoryHealth => 'Задолжителен здравствен придонес';

  @override
  String get itemWaterFee => 'Општ воден надомест';

  @override
  String get itemDisasterFee => 'Надомест за заштита од несреќи';

  @override
  String get itemDisabilityFund => 'Фонд за вработување лица со попреченост';

  @override
  String get itemSickness => 'Боледување и мајчинство';

  @override
  String get itemSupplementaryPension => 'Дополнително пензиско (UPF)';

  @override
  String get itemCas => 'CAS (пензиско)';

  @override
  String get itemCass => 'CASS (здравствено)';

  @override
  String get itemCam => 'CAM (осигурување на трудот)';

  @override
  String get saveTitle => 'Зачувај пресметка';

  @override
  String get saveNameLabel => 'Име';

  @override
  String get saveNameHint => 'на пр. Понуда за нов вработен';

  @override
  String saveLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Бесплатната верзија чува $count пресметки.',
      one: 'Бесплатната верзија чува $count пресметка.',
    );
    return '$_temp0';
  }

  @override
  String get shareFooter => 'Пресметано со апликацијата Bilans';

  @override
  String get sourcesTitle => 'Извори и претпоставки';

  @override
  String get teamTitle => 'Трошок за тимот';

  @override
  String get teamAdd => 'Додај вработен';

  @override
  String get teamEdit => 'Уреди вработен';

  @override
  String get teamEmptyTitle => 'Планирајте ги трошоците за плати';

  @override
  String get teamEmpty =>
      'Додајте го тимот — бруто, нето и вкупниот трошок на работодавачот за секого, збирно за месец и година. Можете да комбинирате земји ако вработувате преку граница.';

  @override
  String teamMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вработени',
      one: '$count вработен',
    );
    return '$_temp0';
  }

  @override
  String get teamNote => 'Секој се пресметува според прописите на својот даночен систем. Годишните износи се 12 × месечните.';

  @override
  String get teamCurrenciesNote => 'Збировите се прикажани посебно за секоја валута.';

  @override
  String get teamUnnamed => 'Без име';

  @override
  String get teamTotal => 'Вкупно';

  @override
  String get teamCostShort => 'вкупен трошок';

  @override
  String teamRemoveTitle(String name) {
    return 'Да се отстрани $name од тимот?';
  }

  @override
  String get teamName => 'Име';

  @override
  String get teamRole => 'Позиција';

  @override
  String get teamRoleHint => 'на пр. Програмер';

  @override
  String get teamAmountError => 'Внесете износ на платата.';

  @override
  String get cmpNeedsRates => 'За споредба на земјите потребни се денешните курсеви. Поврзете се на интернет еднаш и ќе бидат зачувани за работа без мрежа.';

  @override
  String get cmpRankedByNet => 'По нето плата';

  @override
  String get cmpRankedByCost => 'По трошок на работодавачот';

  @override
  String cmpCostLine(String cost, String wedge) {
    return 'Трошок на работодавачот $cost · даночен клин $wedge';
  }

  @override
  String cmpGrossLine(String gross, String wedge) {
    return 'Бруто $gross · даночен клин $wedge';
  }

  @override
  String get cmpTaxesKey => 'Даноци и придонеси';

  @override
  String cmpNote(String date) {
    return 'Износите се пресметани по официјалните курсеви од $date. Секоја земја ги користи стандардните поставки (без деца, стандардни локални стапки). Даночниот клин е делот од вкупниот трошок на работодавачот што оди на даноци и придонеси.';
  }

  @override
  String get payWedgeLabel => 'Даночен клин';

  @override
  String get creditTitle => 'Кредити';

  @override
  String get creditTabLoan => 'Кредит';

  @override
  String get creditTabDeposit => 'Штедење';

  @override
  String get creditTabCompare => 'Споредба';

  @override
  String get loanAmount => 'Износ на кредитот';

  @override
  String get loanRate => 'Номинална каматна стапка';

  @override
  String get loanTerm => 'Рок';

  @override
  String get loanFee => 'Надомест за обработка';

  @override
  String get loanMonthlyFee => 'Месечни трошоци';

  @override
  String get loanMonthlyFeeHint => 'Сметка, осигурување…';

  @override
  String get loanRepayment => 'Отплата';

  @override
  String get loanAnnuity => 'Еднакви рати';

  @override
  String get loanLinear => 'Еднаква главница';

  @override
  String get loanMore => 'Повеќе опции';

  @override
  String get loanLess => 'Помалку опции';

  @override
  String get loanCurrency => 'Валута';

  @override
  String get loanInstallment => 'Месечна рата';

  @override
  String get loanFirstInstallment => 'Прва рата';

  @override
  String get loanEir => 'ЕКС';

  @override
  String get loanTotalInterest => 'Вкупна камата';

  @override
  String get loanTotal => 'Вкупно за отплата';

  @override
  String loanTotalIncludes(String fees) {
    return 'Ги вклучува главницата, каматата и трошоците од $fees.';
  }

  @override
  String get loanEirNote => 'ЕКС е ефективната каматна стапка со сите трошоци, според формулата на ЕУ за потрошувачки кредити.';

  @override
  String get loanByYear => 'По години';

  @override
  String get loanPrincipal => 'Главница';

  @override
  String get loanInterest => 'Камата';

  @override
  String loanYearShort(int n) {
    return '$n. г.';
  }

  @override
  String get loanSchedule => 'Отплатен план';

  @override
  String loanScheduleAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Целосен отплатен план · $count рати',
      one: 'Целосен отплатен план · $count рата',
    );
    return '$_temp0';
  }

  @override
  String get loanColNo => 'Бр.';

  @override
  String get loanColInstallment => 'Рата';

  @override
  String get loanColInterest => 'Камата';

  @override
  String get loanColPrincipal => 'Главница';

  @override
  String get loanColBalance => 'Остаток на долг';

  @override
  String get loanPrepayTitle => 'Предвремена отплата';

  @override
  String loanPrepayTeaser(
    String amount,
    int month,
    String months,
    String saved,
  ) {
    return 'Дополнителна уплата од $amount по ратата $month го скратува кредитот за $months и заштедува $saved камата.';
  }

  @override
  String get loanPrepayCta => 'Пресметајте го вашето сценарио';

  @override
  String get loanErrorPrincipal => 'Внесете износ на кредитот.';

  @override
  String get loanErrorRate => 'Внесете каматна стапка меѓу 0 и 100 %.';

  @override
  String get loanErrorTerm => 'Рокот мора да биде меѓу 1 и 600 месеци.';

  @override
  String get loanErrorFee => 'Трошоците мора да бидат помали од кредитот.';

  @override
  String get prepayTitle => 'Предвремена отплата';

  @override
  String prepayIntro(String amount, String rate, String term) {
    return 'Врз основа на вашиот кредит: $amount со $rate на $term.';
  }

  @override
  String get prepayNoLoan => 'Прво внесете кредит во картичката Кредити.';

  @override
  String get prepayAmount => 'Дополнителна уплата';

  @override
  String get prepayAfter => 'Се уплаќа со ратата бр.';

  @override
  String get prepayMode => 'По уплатата';

  @override
  String get prepayShorten => 'Пократок рок';

  @override
  String get prepayLower => 'Пониска рата';

  @override
  String get prepayFee => 'Надомест за предвремена отплата';

  @override
  String get prepaySaved => 'Заштеда на камата';

  @override
  String get prepayNetSaving => 'Нето заштеда по надоместот';

  @override
  String get prepayNewTerm => 'Нов рок';

  @override
  String get prepayNewInstallment => 'Нова рата';

  @override
  String prepayMonthsSaved(String months) {
    return '$months порано';
  }

  @override
  String get prepayPaidOff => 'Дополнителната уплата го затвора целиот преостанат долг.';

  @override
  String get prepayBefore => 'Пред';

  @override
  String get prepayAfterLabel => 'Потоа';

  @override
  String get depAmount => 'Износ на депозитот';

  @override
  String get depRate => 'Каматна стапка';

  @override
  String get depTerm => 'Рок';

  @override
  String get depPayout => 'Камата';

  @override
  String get depAtMaturity => 'На достасување';

  @override
  String get depMonthly => 'Месечно, се припишува';

  @override
  String get depAnnually => 'Годишно, се припишува';

  @override
  String get depTax => 'Данок на камата';

  @override
  String get depTaxHintRs => 'Во Србија каматата на динарско штедење е ослободена од данок; на девизно штедење данокот е 15 %.';

  @override
  String get depTaxHint => 'Внесете го данокот на камата што се однесува на вас.';

  @override
  String get depContribution => 'Месечна уплата';

  @override
  String get depFinal => 'На достасување';

  @override
  String get depGrossInterest => 'Камата пред данок';

  @override
  String get depTaxAmount => 'Данок на камата';

  @override
  String get depNetInterest => 'Нето камата';

  @override
  String get depPaidIn => 'Уплатено';

  @override
  String depYield(String percent) {
    return 'Нето принос $percent годишно';
  }

  @override
  String get depByYear => 'По години';

  @override
  String get depColYear => 'Година';

  @override
  String get depColInterest => 'Нето камата';

  @override
  String get depColBalance => 'Салдо';

  @override
  String get depErrorAmount => 'Внесете износ на депозит или месечна уплата.';

  @override
  String get depErrorRate => 'Внесете каматна стапка меѓу 0 и 100 %.';

  @override
  String get cmpLoanIntro => 'Ист износ за секоја понуда. Најповолна е понудата со најнизок вкупен трошок.';

  @override
  String cmpLoanOffer(int n) {
    return 'Понуда $n';
  }

  @override
  String get cmpLoanAdd => 'Додај понуда';

  @override
  String get cmpLoanRemove => 'Отстрани понуда';

  @override
  String get cmpLoanBest => 'Најнизок вкупен трошок';

  @override
  String cmpLoanSavesVs(String amount) {
    return '$amount поевтино од најскапата понуда';
  }

  @override
  String get depYieldLabel => 'Нето годишен принос';

  @override
  String get fxTitle => 'Курсна листа';

  @override
  String get fxTabConverter => 'Конвертор';

  @override
  String get fxTabList => 'Курсна листа';

  @override
  String fxAmount(String currency) {
    return 'Износ во $currency';
  }

  @override
  String get fxSwap => 'Замени ги валутите';

  @override
  String fxRateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get fxSourceNbsMiddle => 'среден курс на НБС';

  @override
  String get fxSourceNbsBuy => 'куповен курс на НБС';

  @override
  String get fxSourceNbsSell => 'продажен курс на НБС';

  @override
  String get fxSourceEcb => 'референтен курс на ЕЦБ';

  @override
  String get fxSourceCross => 'вкрстен курс';

  @override
  String get fxKindMiddle => 'Среден';

  @override
  String get fxKindBuy => 'Куповен';

  @override
  String get fxKindSell => 'Продажен';

  @override
  String get fxKindHint => 'Куповниот и продажниот курс важат за конверзија на динари.';

  @override
  String fxUpdated(String date) {
    return 'Ажурирано $date';
  }

  @override
  String fxOffline(String date) {
    return 'Без мрежа · курс од $date';
  }

  @override
  String get fxLoading => 'Ажурирање на курсот…';

  @override
  String get fxNoRates =>
      'Сè уште нема курсеви. Поврзете се на интернет еднаш за да ги преземете денешните официјални курсеви — потоа конверторот работи и без мрежа.';

  @override
  String get fxUnsupported => 'За овој пар нема официјален курс.';

  @override
  String fxHistoryTitle(String from, String to, int days) {
    return '$from/$to · $days дена';
  }

  @override
  String fxHistoryDays(int days) {
    return '$days д';
  }

  @override
  String get fxHistoryError => 'Историјата не е достапна без мрежа.';

  @override
  String get fxHistoryPro => 'Историјата на курсот за 30, 90 и 365 дена е дел од пакетот Pro.';

  @override
  String fxHistoryMinMax(String min, String max) {
    return 'мин $min · макс $max';
  }

  @override
  String get fxPerUnit => 'За 1 единица валута';

  @override
  String get fxListNbs => 'Курсна листа на НБС';

  @override
  String get fxListEcb => 'Референтни курсеви на ЕЦБ, за 1 EUR';

  @override
  String get fxColBuy => 'Куповен';

  @override
  String get fxColMiddle => 'Среден';

  @override
  String get fxColSell => 'Продажен';

  @override
  String get fxColRate => 'Курс';

  @override
  String get fxRefresh => 'Освежи го курсот';

  @override
  String get fxPickFrom => 'Од валута';

  @override
  String get fxPickTo => 'Во валута';

  @override
  String get fxSourcesNote =>
      'Официјални курсеви на Народната банка на Србија преку kurs.resenje.org; референтни курсеви на Европската централна банка преку сервисот Frankfurter. Марката е врзана за еврото по курс 1,95583.';

  @override
  String get bizTitle => 'Бизнис';

  @override
  String get bizProfile => 'Податоци за фирмата';

  @override
  String get bizInvoices => 'Фактури';

  @override
  String get bizNewInvoice => 'Нова';

  @override
  String get bizInvoicesEmpty => 'Сè уште нема фактури. Направете професионална фактура за помалку од една минута.';

  @override
  String bizFreeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Остануваат уште $count бесплатни фактури',
      one: 'Останува уште $count бесплатна фактура',
    );
    return '$_temp0';
  }

  @override
  String get bizTools => 'Алатки';

  @override
  String bizShowAll(int count) {
    return 'Прикажи ги сите ($count)';
  }

  @override
  String bizPausalCard(int year) {
    return 'Паушал · $year';
  }

  @override
  String get statusDraft => 'Нацрт';

  @override
  String get statusIssued => 'Чека плаќање';

  @override
  String get statusPaid => 'Платена';

  @override
  String get statusCancelled => 'Сторнирана';

  @override
  String get statusOverdue => 'Задоцнета';

  @override
  String get invNew => 'Нова фактура';

  @override
  String get invEdit => 'Уредување фактура';

  @override
  String get invNumber => 'Број на фактура';

  @override
  String get invIssueDate => 'Датум на издавање';

  @override
  String get invServiceDate => 'Датум на промет';

  @override
  String get invDueDate => 'Датум на доспевање';

  @override
  String get invPlace => 'Место на издавање';

  @override
  String get invClient => 'Клиент';

  @override
  String get invClientName => 'Назив на клиентот';

  @override
  String get invClientAddress => 'Адреса';

  @override
  String get invClientCity => 'Поштенски број и место';

  @override
  String get invClientCountry => 'Држава';

  @override
  String get invClientTaxId => 'Даночен број (ЕДБ / ПИБ / VAT)';

  @override
  String get invClientRegNo => 'Матичен број';

  @override
  String get invClientEmail => 'Е-пошта';

  @override
  String get invRecentClients => 'Неодамнешни клиенти';

  @override
  String get invCurrency => 'Валута';

  @override
  String get invItems => 'Ставки';

  @override
  String get invItemDescription => 'Опис';

  @override
  String get invItemQty => 'Количина';

  @override
  String get invItemUnit => 'Единица мерка';

  @override
  String get invItemUnitHint => 'парче, час, ден…';

  @override
  String get invItemPrice => 'Единечна цена';

  @override
  String get invItemVat => 'ДДВ %';

  @override
  String get invAddItem => 'Додај ставка';

  @override
  String get invRemoveItem => 'Отстрани ставка';

  @override
  String get invNote => 'Забелешка';

  @override
  String get invReference => 'Повикување на број';

  @override
  String get invReferenceHint => 'Модел и број, на пр. 97 1234';

  @override
  String get invSubtotal => 'Основица';

  @override
  String get invVat => 'ДДВ';

  @override
  String get invTotal => 'Вкупно';

  @override
  String get invTotalDue => 'Вкупно за плаќање';

  @override
  String get invTotalRsd => 'Противвредност во RSD';

  @override
  String invRateLine(String rate, String date) {
    return 'Среден курс на НБС $rate на $date';
  }

  @override
  String get invRateFetching => 'Се презема курсот на НБС…';

  @override
  String get invRateUnavailable => 'Курсот на НБС за овој датум сè уште не е објавен.';

  @override
  String get invRateRetry => 'Преземи курс';

  @override
  String get invSaveDraft => 'Зачувај нацрт';

  @override
  String get invIssue => 'Издај фактура';

  @override
  String get invSave => 'Зачувај ги промените';

  @override
  String get invMarkPaid => 'Означи како платена';

  @override
  String get invMarkUnpaid => 'Означи како неплатена';

  @override
  String get invCancelInvoice => 'Сторнирај фактура';

  @override
  String get invDelete => 'Избриши фактура';

  @override
  String invDeleteConfirm(String number) {
    return 'Да се избрише фактурата $number? Ова не може да се врати.';
  }

  @override
  String get invDuplicate => 'Дуплирај';

  @override
  String get invProfileMissing => 'Прво внесете ги податоците за фирмата — тие се појавуваат на секоја фактура.';

  @override
  String get invNotInVat => 'Издавачот не е обврзник за ДДВ.';

  @override
  String get invValidWithoutStamp => 'Фактурата е валидна без печат и потпис.';

  @override
  String get invQrCaption => 'Скенирај и плати (NBS IPS)';

  @override
  String get invQrHint => 'Клиентот го скенира QR-кодот во апликацијата на својата банка — износот, сметката и повикувањето на број се пополнуваат сами.';

  @override
  String invQrMissing(String reason) {
    return 'Нема QR-код за плаќање: $reason';
  }

  @override
  String get invQrReasonAccount => 'внесете валидна српска банкарска сметка во податоците за фирмата';

  @override
  String get invQrReasonOther => 'проверете го називот на фирмата и повикувањето на број';

  @override
  String get invDocTitle => 'Фактура';

  @override
  String get invSeller => 'Продавач';

  @override
  String get invBuyer => 'Купувач';

  @override
  String invPaidOn(String date) {
    return 'Платена на $date';
  }

  @override
  String invDueOn(String date) {
    return 'Доспева на $date';
  }

  @override
  String get invErrorClient => 'Внесете го називот на клиентот.';

  @override
  String get invErrorItems => 'Додајте барем една ставка со опис и цена.';

  @override
  String get invErrorNumber => 'Внесете број на фактура.';

  @override
  String get invErrorDue => 'Датумот на доспевање не може да биде пред датумот на издавање.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Фактурата $number веќе постои.';
  }

  @override
  String get invShare => 'Сподели PDF';

  @override
  String get invAccount => 'Сметка';

  @override
  String get invPib => 'ПИБ';

  @override
  String get invMb => 'МБ';

  @override
  String get invReferenceLabel => 'Повикување на број';

  @override
  String get invPlaceLabel => 'Место';

  @override
  String get invColItem => 'Ставка';

  @override
  String get invColQty => 'Кол.';

  @override
  String get invColPrice => 'Цена';

  @override
  String get invColAmount => 'Износ';

  @override
  String get profTitle => 'Податоци за фирмата';

  @override
  String get profIntro => 'Се печатат на фактурите и, ако сакате, на PDF-извештаите.';

  @override
  String get profName => 'Назив на фирмата';

  @override
  String get profAddress => 'Улица и број';

  @override
  String get profCity => 'Поштенски број и место';

  @override
  String get profCountry => 'Држава';

  @override
  String get profTaxId => 'Даночен број (ПИБ)';

  @override
  String get profRegNo => 'Матичен број (МБ)';

  @override
  String get profAccount => 'Банкарска сметка';

  @override
  String get profAccountHint => 'Српска сметка (160-0000000000000-00) или IBAN';

  @override
  String get profBank => 'Банка';

  @override
  String get profEmail => 'Е-пошта';

  @override
  String get profPhone => 'Телефон';

  @override
  String get profVat => 'Обврзник за ДДВ';

  @override
  String get profVatHint => 'Додава ДДВ на фактурите. Кога е исклучено, на фактурите пишува дека не сте обврзник за ДДВ.';

  @override
  String get profPaymentCode => 'Шифра на плаќање за QR-кодот';

  @override
  String get profPaymentCodeHint => '221 за плаќање на стоки и услуги';

  @override
  String get profDueDays => 'Стандарден рок на плаќање';

  @override
  String get profDueDaysSuffix => 'дена';

  @override
  String get profCurrency => 'Стандардна валута на фактурите';

  @override
  String get profNote => 'Стандардна забелешка на фактурите';

  @override
  String get profShowOnReports => 'Прикажи ги податоците за фирмата на PDF-извештаите';

  @override
  String get profInvalidPib => 'Контролната цифра на ПИБ не се совпаѓа — проверете го бројот.';

  @override
  String get profInvalidMb => 'Контролната цифра на матичниот број не се совпаѓа.';

  @override
  String get profInvalidAccount => 'Контролните цифри на бројот на сметката не се совпаѓаат.';

  @override
  String get profSaved => 'Податоците за фирмата се зачувани';

  @override
  String get pausalTitle => 'Паушални лимити';

  @override
  String get pausalIntro =>
      'Паушалците во Србија го губат паушалното оданочување над 6.000.000 RSD приход во календарската година и мора да се регистрираат за ДДВ над 8.000.000 RSD во кои било 12 месеци.';

  @override
  String get pausalAnnual => 'Паушален лимит, календарска година';

  @override
  String get pausalVat => 'Лимит за ДДВ, последните 12 месеци';

  @override
  String pausalOf(String amount) {
    return 'од $amount';
  }

  @override
  String pausalLeft(String amount) {
    return 'Преостанато $amount';
  }

  @override
  String pausalProjection(String amount) {
    return 'Со ова темпо ќе фактурирате околу $amount до 31 декември.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'Со ова темпо ќе го надминете паушалниот лимит пред крајот на годината (околу $amount).';
  }

  @override
  String get pausalWarn => 'Искористивте повеќе од 80 % од овој лимит.';

  @override
  String get pausalOver => 'Лимитот е надминат — разговарајте со вашиот сметководител.';

  @override
  String pausalMissingRate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count девизни фактури немаат курс на НБС и не се пресметани.',
      one: '$count девизна фактура нема курс на НБС и не е пресметана.',
    );
    return '$_temp0';
  }

  @override
  String get pausalSourceInvoices => 'Се пресметува од издадените и платените фактури (според датумот на промет) и од приходот што ќе го додадете подолу.';

  @override
  String get pausalManual => 'Приход надвор од апликацијата';

  @override
  String get pausalManualEmpty => 'Додајте ги фактурите што оваа година сте ги издале на друго место, за збировите да бидат целосни.';

  @override
  String get pausalManualAdd => 'Додај приход';

  @override
  String get pausalManualDate => 'Датум';

  @override
  String get pausalManualAmount => 'Износ во RSD';

  @override
  String get pausalManualNote => 'Забелешка';

  @override
  String get vatTitle => 'Калкулатор за ДДВ';

  @override
  String get vatAdd => 'Додај ДДВ';

  @override
  String get vatExtract => 'Издвој ДДВ';

  @override
  String get vatAmountNet => 'Износ без ДДВ';

  @override
  String get vatAmountGross => 'Износ со ДДВ';

  @override
  String get vatRate => 'Стапка на ДДВ';

  @override
  String get vatOther => 'Друга';

  @override
  String get vatNet => 'Без ДДВ';

  @override
  String get vatVat => 'ДДВ';

  @override
  String get vatGross => 'Со ДДВ';

  @override
  String get mrgTitle => 'Маржа и надценка';

  @override
  String get mrgFromPrice => 'Набавна и продажна';

  @override
  String get mrgFromMarkup => 'Надценка';

  @override
  String get mrgFromMargin => 'Маржа';

  @override
  String get mrgCost => 'Набавна цена';

  @override
  String get mrgPrice => 'Продажна цена (без ДДВ)';

  @override
  String get mrgMarkup => 'Надценка';

  @override
  String get mrgMargin => 'Маржа';

  @override
  String get mrgDiscount => 'Попуст';

  @override
  String get mrgVat => 'ДДВ';

  @override
  String get mrgProfit => 'Бруто добивка';

  @override
  String get mrgPriceAfterDiscount => 'Цена по попустот';

  @override
  String get mrgPriceWithVat => 'Цена со ДДВ';

  @override
  String get mrgMarginHint => 'Маржата е добивката како удел во продажната цена; надценката е добивката како удел во набавната цена.';

  @override
  String get mrgImpossible => 'Маржа од 100 % или повеќе не е можна.';

  @override
  String get beTitle => 'Точка на рентабилност';

  @override
  String get beFixed => 'Фиксни трошоци месечно';

  @override
  String get bePrice => 'Цена по единица';

  @override
  String get beVariable => 'Варијабилен трошок по единица';

  @override
  String get beTarget => 'Целна добивка месечно';

  @override
  String get beUnits => 'Потребна продажба месечно';

  @override
  String beUnitsValue(int count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted единици',
      one: '$formatted единица',
    );
    return '$_temp0';
  }

  @override
  String get beRevenue => 'Потребен приход';

  @override
  String get beContribution => 'Маржа на покритие';

  @override
  String get beImpossible => 'Цената мора да биде повисока од варијабилниот трошок по единица.';

  @override
  String get invsTitle => 'Анализа на инвестиција';

  @override
  String get invsInitial => 'Почетно вложување';

  @override
  String get invsRate => 'Дисконтна стапка';

  @override
  String get invsFlows => 'Нето паричен тек по години';

  @override
  String invsYear(int n) {
    return 'Година $n';
  }

  @override
  String get invsAddYear => 'Додај година';

  @override
  String get invsRemoveYear => 'Отстрани ја последната година';

  @override
  String get invsNpv => 'Нето сегашна вредност (НСВ)';

  @override
  String get invsIrr => 'Интерна стапка на поврат (ИСП)';

  @override
  String get invsPayback => 'Период на враќање';

  @override
  String get invsDiscountedPayback => 'Дисконтиран период на враќање';

  @override
  String get invsPi => 'Индекс на профитабилност';

  @override
  String invsYears(String years) {
    return '$years год.';
  }

  @override
  String get invsNever => 'Не во овие години';

  @override
  String get invsNoIrr => 'Нема ИСП за овие парични текови';

  @override
  String invsGood(String rate) {
    return 'Создава вредност при дисконтна стапка од $rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Уништува вредност при дисконтна стапка од $rate.';
  }

  @override
  String get profSectionBusiness => 'Фирма';

  @override
  String get profSectionPayment => 'Плаќање';

  @override
  String get profSectionContact => 'Контакт';

  @override
  String get profSectionInvoices => 'Стандардно за фактурите';

  @override
  String get profTaxIdGeneric => 'Даночен број';

  @override
  String get profRegNoGeneric => 'Матичен број';

  @override
  String get profNameRequired => 'Внесете го називот на фирмата.';

  @override
  String get profPibLength => 'ПИБ има 9 цифри.';

  @override
  String get profMbLength => 'Матичниот број има 8 цифри.';

  @override
  String get profInvalidAccountShape => 'Внесете српска сметка (160-0000000000000-00) или IBAN.';

  @override
  String get profInvalidEmail => 'Проверете ја адресата на е-пошта.';

  @override
  String get profInvalidPaymentCode => 'Шифрата на плаќање има три цифри, на пр. 221.';

  @override
  String get profPrivacy => 'Се чуваат само на овој телефон и се вклучени во резервните копии што ги извезувате.';

  @override
  String get profIban => 'IBAN за уплати од странство';

  @override
  String get profIbanHint => 'Се печати на девизните фактури. Оставете празно за да се користи сметката погоре во IBAN-форма.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban => 'Проверете го IBAN — контролните цифри не се совпаѓаат.';

  @override
  String get profInvalidSwift => 'SWIFT/BIC-кодот има 8 или 11 знаци.';

  @override
  String get invIban => 'IBAN';

  @override
  String get invSwift => 'SWIFT/BIC';

  @override
  String get invBank => 'Банка';

  @override
  String get invSefNote =>
      'Фактурите до српскиот јавен сектор — а за обврзниците за ДДВ и до српските фирми — мора да поминат и низ SEF (е-Фактура). Фактурите од Bilans се погодни за клиенти од странство, физички лица и за вашата евиденција.';

  @override
  String get invRateOffline => 'НБС не е достапна. Проверете ја врската — можете да зачувате сега, а курсот да го преземете подоцна.';

  @override
  String get invMarkedPaid => 'Означена како платена';

  @override
  String get invMarkedUnpaid => 'Означена како неплатена';

  @override
  String get invIssued => 'Фактурата е издадена';

  @override
  String get invCancelled => 'Фактурата е сторнирана';

  @override
  String get invCompleteFirst => 'Пред издавањето додајте клиент и барем една ставка.';

  @override
  String invCancelConfirm(String number) {
    return 'Да се сторнира фактурата $number?';
  }

  @override
  String get invCancelBody => 'Останува во листата, означена како сторнирана, и повеќе не се смета во приходот.';

  @override
  String get invRateMissingNote => 'Сè уште нема курс на НБС — фактурата не се пресметува во паушалните лимити додека не го добие.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'За да останете под лимитот, до крајот на годината фактурирајте најмногу околу $amount месечно.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Приход по месеци, $year';
  }

  @override
  String get pausalFromInvoices => 'Фактури';

  @override
  String get pausalDisclaimer =>
      'Приходот се пресметува според датумот на промет. Девизните фактури се пресметуваат по средниот курс на НБС на датумот на издавање. Конечните износи проверете ги со сметководител.';

  @override
  String get pausalRemoveTitle => 'Да се отстрани овој приход?';

  @override
  String get pausalManualAmountError => 'Внесете износ.';

  @override
  String get invsFilterAll => 'Сите';

  @override
  String get invsFilterDrafts => 'Нацрти';

  @override
  String get invsOutstanding => 'Чекаат плаќање';

  @override
  String get invsSearchHint => 'Пребарувај по клиент или број';

  @override
  String get invsNoMatch => 'Ниту една фактура не одговара.';

  @override
  String get vatEmpty => 'Внесете износ за да го поделите на основица и ДДВ.';

  @override
  String vatRatesNote(String country) {
    return 'Прикажани се стандардната и намалените стапки на ДДВ за: $country.';
  }

  @override
  String get mrgEmpty => 'Внесете ја набавната цена и продажната цена, надценката или маржата.';

  @override
  String get mrgLoss => 'По оваа цена продавате под набавната цена.';

  @override
  String get beFixedHint => 'Кирија, плати, претплати…';

  @override
  String get beVariableHint => 'Материјал, провизии, достава…';

  @override
  String get beEmpty => 'Внесете ги фиксните трошоци, цената и варијабилниот трошок по единица.';

  @override
  String get beContributionUnit => 'Покритие по единица';

  @override
  String get beExplain =>
      'Секоја продадена единица придонесува со својата цена намалена за варијабилниот трошок кон покривање на фиксните трошоци и добивката. Износите се без ДДВ.';

  @override
  String get invsFlowsHint => 'Нето паричен тек на крајот на секоја година. Внесете минус за година во која одливите се поголеми од приливите.';

  @override
  String get invsEmpty => 'Внесете го вложувањето, дисконтната стапка и паричниот тек за барем една година.';

  @override
  String get invsCumulative => 'Кумулативен паричен тек';

  @override
  String get invCreatedWith => 'Направено со Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead => 'Сите калкулатори, сите држави, неограничен број фактури и PDF-извештаи. Без реклами, без кориснички профил.';

  @override
  String get proFeatAllCountries => 'Пресметка на плата за сите 9 даночни системи';

  @override
  String get proFeatUnlimitedInvoices => 'Неограничен број фактури';

  @override
  String get proFeatPdf => 'PDF-извештаи';

  @override
  String get proFeatUnlimitedSaves => 'Неограничен број зачувани пресметки';

  @override
  String get proBenefitCountries => 'Пресметка на плата за сите 9 даночни системи и споредба на истата плата меѓу државите';

  @override
  String get proBenefitTeam => 'Трошок за тимот: сите плати по месеци и години';

  @override
  String get proBenefitInvoices => 'Неограничен број професионални фактури во PDF';

  @override
  String get proBenefitInvoicesRs => 'Неограничен број фактури со QR-код за плаќање NBS IPS';

  @override
  String get proBenefitPausal => 'Следење на паушалните лимити од 6 и 8 милиони динари';

  @override
  String get proBenefitLoans => 'Споредба на понуди за кредит и план за предвремена отплата';

  @override
  String get proBenefitHistory => 'Историја на курсот за 30, 90 и 365 дена';

  @override
  String get proBenefitInvestment => 'Анализа на инвестиции: НСВ, ИСП и период на враќање';

  @override
  String get proBenefitPdf => 'PDF-извештаи за плати, кредити, штедење и тимови';

  @override
  String get proYearly => 'Годишно';

  @override
  String get proMonthly => 'Месечно';

  @override
  String get proLifetime => 'Трајно';

  @override
  String get proPerYear => 'годишно';

  @override
  String get proPerMonth => 'месечно';

  @override
  String get proOnce => 'еднократно';

  @override
  String proSave(int percent) {
    return 'ЗАШТЕДА $percent %';
  }

  @override
  String proTrialNote(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дена бесплатно, потоа годишна наплата',
      one: '$days ден бесплатно, потоа годишна наплата',
    );
    return '$_temp0';
  }

  @override
  String get proLifetimeNote => 'Платете еднаш, Pro останува засекогаш';

  @override
  String proStartTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Започни бесплатна проба од $days дена',
      one: 'Започни бесплатна проба од $days ден',
    );
    return '$_temp0';
  }

  @override
  String get proContinue => 'Продолжи';

  @override
  String get proRestore => 'Врати купување';

  @override
  String get proRestored => 'Bilans Pro е активен на овој уред.';

  @override
  String get proNothingToRestore => 'За оваа Google-сметка не е пронајдено купување на Bilans Pro.';

  @override
  String get proPending => 'Плаќањето е во тек. Pro ќе се отклучи автоматски штом Google Play го потврди.';

  @override
  String get proError => 'Купувањето не успеа. Ништо не ви е наплатено — обидете се повторно.';

  @override
  String get proUnavailable => 'Купувањето моментално не е достапно. Проверете дали Google Play е инсталиран и дали сте најавени, па обидете се повторно.';

  @override
  String get proLegal =>
      'Претплатата автоматски се обновува по прикажаната цена додека не ја откажете. Можете да ја откажете во секое време во Google Play → Плаќања и претплати, најдоцна 24 часа пред обновувањето. Бесплатната проба преминува во платена годишна претплата ако не ја откажете пред да истече.';

  @override
  String get proLegalLifetime => 'Еднократно купување: без претплата и без обновување. Pro е активен на секој уред најавен на истата Google-сметка.';

  @override
  String get proDevSimulate => 'Симулирај Pro (развојна верзија)';

  @override
  String get proWelcome => 'Добредојдовте во Bilans Pro';

  @override
  String get proWelcomeBody => 'Сè е отклучено. Ви благодариме што поддржувате независна апликација.';

  @override
  String get settingsPreferences => 'Поставки';

  @override
  String get settingsTheme => 'Изглед';

  @override
  String get settingsThemeSystem => 'Системски';

  @override
  String get settingsThemeLight => 'Светол';

  @override
  String get settingsThemeDark => 'Темен';

  @override
  String get settingsYourData => 'Вашите податоци';

  @override
  String get settingsExport => 'Извези резервна копија';

  @override
  String get settingsImport => 'Врати од резервна копија';

  @override
  String get settingsBackupSubject => 'Резервна копија од Bilans';

  @override
  String get settingsExported => 'Резервната копија е подготвена';

  @override
  String get settingsImportInvalid => 'Таа датотека не е резервна копија од Bilans.';

  @override
  String get settingsImportTitle => 'Да се врати оваа резервна копија?';

  @override
  String get settingsImportBody => 'Сè во апликацијата ќе биде заменето со содржината на копијата — фактури, податоци за фирмата, тим и зачувани пресметки.';

  @override
  String get settingsImportAction => 'Врати';

  @override
  String get settingsImported => 'Резервната копија е вратена';

  @override
  String get settingsDeleteAll => 'Избриши ги сите податоци';

  @override
  String get settingsDeleteTitle => 'Да се избришат сите податоци?';

  @override
  String get settingsDeleteBody =>
      'Фактурите, податоците за фирмата, тимот, зачуваните пресметки и поставките ќе бидат отстранети од овој телефон. Ако можеби ќе ви требаат, прво извезете резервна копија. Купувањето на Pro не е засегнато.';

  @override
  String get settingsDeleteAction => 'Избриши сè';

  @override
  String get settingsDataNote =>
      'Bilans нема кориснички профили ни сервери: вашите податоци постојат само на овој телефон. Извезете резервна копија за да ги пренесете на нов телефон.';

  @override
  String get settingsAbout => 'За апликацијата';

  @override
  String get settingsRate => 'Оценете го Bilans на Google Play';

  @override
  String get settingsContact => 'Контакт';

  @override
  String get settingsPrivacy => 'Политика за приватност';

  @override
  String get settingsTerms => 'Услови за користење';

  @override
  String get settingsLicenses => 'Лиценци за отворен код';

  @override
  String get settingsDisclaimer => 'Пресметките се информативни и не заменуваат стручен даночен, правен или финансиски совет.';

  @override
  String get settingsProActive => 'Bilans Pro е активен';

  @override
  String get settingsManageSubscription => 'Управувај со претплатата';

  @override
  String get settingsProPitch => 'Сите држави, трошок за тимот, неограничен број фактури, PDF-извештаи и многу повеќе.';

  @override
  String get settingsSeePlans => 'Погледни ги пакетите';

  @override
  String get proIncluded => 'Вклучено во Pro';

  @override
  String proSummaryTrial(int days, String price, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дена бесплатно, потоа $price $period. Откажете во секое време.',
      one: '$days ден бесплатно, потоа $price $period. Откажете во секое време.',
    );
    return '$_temp0';
  }

  @override
  String proSummary(String price, String period) {
    return '$price $period, автоматско обновување. Откажете во секое време.';
  }

  @override
  String proSummaryLifetime(String price) {
    return 'Еднократно плаќање од $price. Без претплата.';
  }
}
