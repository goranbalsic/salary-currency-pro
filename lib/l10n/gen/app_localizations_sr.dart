// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appName => 'Bilans';

  @override
  String get appTagline => 'Финансијски калкулатор';

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
  String get actionSave => 'Сачувај';

  @override
  String get actionShare => 'Подели';

  @override
  String get actionDelete => 'Обриши';

  @override
  String get actionCancel => 'Откажи';

  @override
  String get actionClose => 'Затвори';

  @override
  String get actionDone => 'Готово';

  @override
  String get actionRetry => 'Покушај поново';

  @override
  String get actionEdit => 'Измени';

  @override
  String get actionContinue => 'Настави';

  @override
  String get actionRemove => 'Уклони';

  @override
  String get actionUndo => 'Поништи';

  @override
  String get actionDownloadPdf => 'Преузми PDF';

  @override
  String get actionRename => 'Преименуј';

  @override
  String get actionClear => 'Обриши све';

  @override
  String get commonMonthly => 'Месечно';

  @override
  String get commonAnnual => 'Годишње';

  @override
  String get commonMonthsShort => 'мес.';

  @override
  String commonMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месеци',
      few: '$count месеца',
      one: '$count месец',
    );
    return '$_temp0';
  }

  @override
  String commonYearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count година',
      few: '$count године',
      one: '$count година',
    );
    return '$_temp0';
  }

  @override
  String get commonPercentPa => '% год.';

  @override
  String get commonOptional => 'опционо';

  @override
  String get commonSearch => 'Претрага';

  @override
  String get commonToday => 'Данас';

  @override
  String get snackSaved => 'Сачувано';

  @override
  String get snackDeleted => 'Обрисано';

  @override
  String get errorGeneric => 'Нешто није у реду. Покушајте поново.';

  @override
  String get errorShare => 'Дељење тренутно није могуће.';

  @override
  String get errorOpenLink => 'Линк није могуће отворити.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature је део пакета Bilans Pro';
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
  String get countryBG => 'Бугарска';

  @override
  String get countryRO => 'Румунија';

  @override
  String get systemFbih => 'Федерација БиХ';

  @override
  String get systemRepublikaSrpska => 'Република Српска';

  @override
  String get curEUR => 'Евро';

  @override
  String get curUSD => 'Амерички долар';

  @override
  String get curCHF => 'Швајцарски франак';

  @override
  String get curGBP => 'Британска фунта';

  @override
  String get curRSD => 'Српски динар';

  @override
  String get curBAM => 'Конвертибилна марка';

  @override
  String get curMKD => 'Македонски денар';

  @override
  String get curRON => 'Румунски леј';

  @override
  String get curHUF => 'Мађарска форинта';

  @override
  String get curCZK => 'Чешка круна';

  @override
  String get curPLN => 'Пољски злот';

  @override
  String get curSEK => 'Шведска круна';

  @override
  String get curNOK => 'Норвешка круна';

  @override
  String get curDKK => 'Данска круна';

  @override
  String get curJPY => 'Јапански јен';

  @override
  String get curCNY => 'Кинески јуан';

  @override
  String get curCAD => 'Канадски долар';

  @override
  String get curAUD => 'Аустралијски долар';

  @override
  String get curTRY => 'Турска лира';

  @override
  String get curRUB => 'Руска рубља';

  @override
  String get formFixErrors => 'Исправите означена поља.';

  @override
  String get discardTitle => 'Одбацити измене?';

  @override
  String get discardBody => 'Измене нису сачуване.';

  @override
  String get discardKeep => 'Настави уређивање';

  @override
  String get discardAction => 'Одбаци';

  @override
  String get commonMore => 'Још опција';

  @override
  String get errorPdf => 'PDF није направљен. Покушајте поново.';

  @override
  String get pdfLanguageTitle => 'Језик фактуре';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + енглески';
  }

  @override
  String get onbHeadline => 'Бројке на које можете да се ослоните.';

  @override
  String get onbBody => 'Плате, кредити, званични курсеви и фактуре — обрачунати по правилима ваше земље. Без налога, без праћења.';

  @override
  String get onbCountry => 'Ваша земља';

  @override
  String get onbBihEntities => 'Федерација БиХ и Република Српска';

  @override
  String get onbLanguage => 'Језик апликације';

  @override
  String get onbLanguageDevice => 'Језик уређаја';

  @override
  String get onbPrivacy => 'Ваши подаци остају на овом телефону.';

  @override
  String get homeSearchHint => 'Претражи калкулаторе';

  @override
  String get homeSettings => 'Подешавања';

  @override
  String get homeRatesTitle => 'Данашњи курс';

  @override
  String homeRatesNbs(String date) {
    return 'Средњи курс НБС · $date';
  }

  @override
  String homeRatesEcb(String date) {
    return 'Референтни курс ЕЦБ · $date';
  }

  @override
  String get homeRatesEmpty => 'Данашњи званични курсеви појавиће се овде чим будете на мрежи.';

  @override
  String get homeRecent => 'Недавно';

  @override
  String get homeSeeAll => 'Све';

  @override
  String get homeSectionPayroll => 'Плата';

  @override
  String get homeSectionCredit => 'Кредити и штедња';

  @override
  String get homeSectionFx => 'Курсна листа';

  @override
  String get homeSectionBusiness => 'Бизнис';

  @override
  String homeNoResults(String query) {
    return 'Ниједан калкулатор не одговара појму „$query”.';
  }

  @override
  String get toolPayroll => 'Бруто и нето плата';

  @override
  String get toolPayrollDesc => 'Обрачун за 9 пореских система';

  @override
  String get toolTeam => 'Трошак тима';

  @override
  String get toolTeamDesc => 'Месечни и годишњи трошак зарада';

  @override
  String get toolCompare => 'Поређење земаља';

  @override
  String get toolCompareDesc => 'Иста плата у 9 система';

  @override
  String get toolLoan => 'Кредит';

  @override
  String get toolLoanDesc => 'Рата, ЕКС и план отплате';

  @override
  String get toolDeposit => 'Орочена штедња';

  @override
  String get toolDepositDesc => 'Камата и порез на камату';

  @override
  String get toolLoanCompare => 'Поређење кредита';

  @override
  String get toolLoanCompareDesc => 'До три понуде, рангиране по ЕКС';

  @override
  String get toolPrepay => 'Превремена отплата';

  @override
  String get toolPrepayDesc => 'Колико камате штедите';

  @override
  String get toolConverter => 'Конвертор валута';

  @override
  String get toolConverterDesc => 'Званични курсеви НБС и ЕЦБ';

  @override
  String get toolRateHistory => 'Историја курса';

  @override
  String get toolRateHistoryDesc => '30, 90 и 365 дана';

  @override
  String get toolInvoices => 'Фактуре';

  @override
  String get toolInvoicesDescRs => 'PDF са НБС ИПС QR кодом';

  @override
  String get toolInvoicesDesc => 'Proфесионалне PDF фактуре';

  @override
  String get toolPausal => 'Паушал лимити';

  @override
  String get toolPausalDesc => '6 и 8 милиона динара, уживо';

  @override
  String get toolVat => 'ПДВ';

  @override
  String get toolVatDesc => 'Додавање или издвајање ПДВ-а';

  @override
  String get toolMargin => 'Маржа и разлика у цени';

  @override
  String get toolMarginDesc => 'Набавна цена, продајна цена и попуст';

  @override
  String get toolBreakEven => 'Праг рентабилности';

  @override
  String get toolBreakEvenDesc => 'Колико треба да продате';

  @override
  String get toolInvestment => 'Инвестиција';

  @override
  String get toolInvestmentDesc => 'НСВ, ИСП и период повраћаја';

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
    return 'бруто у буџету $amount';
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
    return 'Штедња · $term';
  }

  @override
  String recentDepositSub(String rate) {
    return 'на крају рока · $rate';
  }

  @override
  String recentVatAdd(String amount, String rate) {
    return '$amount + ПДВ $rate';
  }

  @override
  String recentVatExtract(String amount, String rate) {
    return 'основица од $amount уз $rate';
  }

  @override
  String recentMarginSub(String margin) {
    return 'цена са ПДВ-ом · маржа $margin';
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
  String get historyTitle => 'Сачувано и недавно';

  @override
  String get historySaved => 'Сачувано';

  @override
  String get historySavedEmpty => 'Додирните Сачувај на било ком резултату да бисте га задржали овде под именом.';

  @override
  String get historyRecentEmpty => 'Завршени обрачуни појављују се овде аутоматски.';

  @override
  String get historyClearTitle => 'Обрисати листу недавних?';

  @override
  String get payTitle => 'Обрачун плате';

  @override
  String get payModeGross => 'Бруто → нето';

  @override
  String get payModeNet => 'Нето → бруто';

  @override
  String get payModeCost => 'Укупан трошак';

  @override
  String get payModeSemantic => 'Смер обрачуна';

  @override
  String get payInputGross => 'Бруто плата · месечно';

  @override
  String get payInputNet => 'Жељена нето плата · месечно';

  @override
  String get payInputCost => 'Буџет послодавца · месечно';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Најнижа основица доприноса: $amount';
  }

  @override
  String get payHelperNet => 'Износ који запослени добија';

  @override
  String get payHelperCost => 'Бруто плата са свим доприносима послодавца';

  @override
  String get payResultNet => 'Нето плата';

  @override
  String get payResultGross => 'Потребна бруто плата';

  @override
  String get payResultGrossBudget => 'Бруто плата у оквиру буџета';

  @override
  String payShareOfGross(String percent) {
    return '$percent од бруто износа';
  }

  @override
  String payNetLine(String amount) {
    return 'Нето плата: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Укупан трошак послодавца: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'На шта одлази укупан трошак послодавца';

  @override
  String get segNet => 'Нето плата';

  @override
  String get segTax => 'Порез';

  @override
  String get segEmployee => 'Доприноси запосленог';

  @override
  String get segEmployer => 'Доприноси послодавца';

  @override
  String get payBreakdown => 'Обрачун';

  @override
  String get payAnnualToggle => 'Годишње ×12';

  @override
  String get payEmployee => 'Запослени';

  @override
  String get payEmployer => 'Послодавац';

  @override
  String get payGross => 'Бруто плата';

  @override
  String get payNetTotal => 'Нето плата';

  @override
  String get payTotalCost => 'Укупан трошак зараде';

  @override
  String get payNonTaxable => 'Неопорезиви износ';

  @override
  String get payPersonalAllowance => 'Лични одбитак';

  @override
  String get payGeneralAllowance => 'Општа олакшица';

  @override
  String get payPersonalExemption => 'Лично ослобођење';

  @override
  String get payPersonalDeduction => 'Лична дедукција';

  @override
  String get payTaxBase => 'Пореска основица';

  @override
  String get payIncomeTax => 'Порез на зараду';

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
    return 'Порески клин $percent';
  }

  @override
  String payRulesFrom(String date) {
    return 'Proписи од $date';
  }

  @override
  String get paySources => 'Извори';

  @override
  String payDisclaimer(String date) {
    return 'Информативни обрачун по прописима који важе од $date. Не замењује званични обрачун зараде.';
  }

  @override
  String get payAnnualNote => 'Годишњи износи су 12 × месечни; годишње пореско усклађивање може се разликовати.';

  @override
  String payNoteMinBase(String amount) {
    return 'Доприноси се обрачунавају на најнижу основицу од $amount.';
  }

  @override
  String payNoteMaxBase(String amount) {
    return 'Доприноси се не обрачунавају изнад највише основице од $amount.';
  }

  @override
  String payNoteRelief(String amount) {
    return 'Олакшица за ниже плате смањује основицу за пензијско на $amount.';
  }

  @override
  String get payNoteNonPositive => 'Обавезна давања су већа од ове плате.';

  @override
  String get payEmpty => 'Унесите износ за потпун обрачун — доприносе, порез и укупан трошак послодавца.';

  @override
  String get payErrorTooLarge => 'Износ је превелик за обрачун.';

  @override
  String get paySystemTitle => 'Порески систем';

  @override
  String get paySystemProHint => 'Ваша земља је бесплатна. Остале земље су део пакета Pro.';

  @override
  String get payOptions => 'Опције';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Порез $lower / $higher · деца $children';
  }

  @override
  String payOptionsMeSummary(String rate) {
    return 'Прирез $rate';
  }

  @override
  String payOptionsRoSummary(int count) {
    return 'Издржавани чланови $count';
  }

  @override
  String get payOptionsRoMinWage => 'олакшица за минималну зараду';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Фонд за ОСИ $state';
  }

  @override
  String get payOn => 'укључен';

  @override
  String get payOff => 'искључен';

  @override
  String get payHrRates => 'Општинске стопе пореза на доходак';

  @override
  String get payHrLower => 'Нижа стопа';

  @override
  String get payHrHigher => 'Виша стопа';

  @override
  String get payHrRatesHint => 'Одређује их град или општина: 15–23% и 25–33%. Без одлуке важе 20% и 30%.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'Нижа стопа $lowRange, виша стопа $highRange';
  }

  @override
  String get payChildren => 'Деца';

  @override
  String get payDependents => 'Остали издржавани чланови';

  @override
  String get payRoDependents => 'Издржавани чланови';

  @override
  String get payRoMinWage => 'Олакшица за минималну зараду';

  @override
  String get payRoMinWageHint => 'За запослене са националном минималном зарадом 200 леја је ослобођено.';

  @override
  String get payMeSurtax => 'Стопа приреза';

  @override
  String get payMeSurtaxHint => '13% у већини општина, 15% у Подгорици и на Цетињу.';

  @override
  String get payFbihDisability => 'Фонд за запошљавање ОСИ 0,5%';

  @override
  String get payFbihDisabilityHint => 'Плаћају га фирме које не запошљавају прописани број особа са инвалидитетом.';

  @override
  String get itemPension => 'Пензијско и инвалидско осигурање';

  @override
  String get itemHealth => 'Здравствено осигурање';

  @override
  String get itemUnemployment => 'Осигурање за случај незапослености';

  @override
  String get itemChildProtection => 'Дечија заштита';

  @override
  String get itemWorkInjury => 'Осигурање од повреде на раду';

  @override
  String get itemLaborFund => 'Фонд рада';

  @override
  String get itemChamber => 'Привредна комора';

  @override
  String get itemPillar1 => 'Пензијско осигурање, И стуб';

  @override
  String get itemPillar2 => 'Пензијско осигурање, ИИ стуб';

  @override
  String get itemLongTermCare => 'Дуготрајна нега';

  @override
  String get itemParental => 'Родитељска заштита';

  @override
  String get itemCompulsoryHealth => 'Обавезни здравствени допринос';

  @override
  String get itemWaterFee => 'Општа водна накнада';

  @override
  String get itemDisasterFee => 'Накнада за заштиту од несрећа';

  @override
  String get itemDisabilityFund => 'Фонд за запошљавање ОСИ';

  @override
  String get itemSickness => 'Боловање и материнство';

  @override
  String get itemSupplementaryPension => 'Допунско пензијско (UPF)';

  @override
  String get itemCas => 'CAS (пензијско)';

  @override
  String get itemCass => 'CASS (здравствено)';

  @override
  String get itemCam => 'CAM (осигурање рада)';

  @override
  String get saveTitle => 'Сачувај обрачун';

  @override
  String get saveNameLabel => 'Назив';

  @override
  String get saveNameHint => 'нпр. Понуда за новог радника';

  @override
  String saveLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Бесплатна верзија чува $count обрачуна.',
      few: 'Бесплатна верзија чува $count обрачуна.',
      one: 'Бесплатна верзија чува $count обрачун.',
    );
    return '$_temp0';
  }

  @override
  String get shareFooter => 'Израчунато у апликацији Bilans';

  @override
  String get sourcesTitle => 'Извори и претпоставке';

  @override
  String get teamTitle => 'Трошак тима';

  @override
  String get teamAdd => 'Додај запосленог';

  @override
  String get teamEdit => 'Измени запосленог';

  @override
  String get teamEmptyTitle => 'Планирајте трошкове зарада';

  @override
  String get teamEmpty =>
      'Додајте тим — бруто, нето и укупан трошак послодавца за свакога, сабрано за месец и годину. Можете комбиновати земље ако запошљавате преко границе.';

  @override
  String teamMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запослених',
      few: '$count запослена',
      one: '$count запослени',
    );
    return '$_temp0';
  }

  @override
  String get teamNote => 'Свако се обрачунава по прописима свог пореског система. Годишњи износи су 12 × месечни.';

  @override
  String get teamCurrenciesNote => 'Збирови су приказани посебно за сваку валуту.';

  @override
  String get teamUnnamed => 'Без имена';

  @override
  String get teamTotal => 'Укупно';

  @override
  String get teamCostShort => 'укупан трошак';

  @override
  String teamRemoveTitle(String name) {
    return 'Уклонити $name из тима?';
  }

  @override
  String get teamName => 'Име';

  @override
  String get teamRole => 'Позиција';

  @override
  String get teamRoleHint => 'нпр. Proграмер';

  @override
  String get teamAmountError => 'Унесите износ плате.';

  @override
  String get cmpNeedsRates => 'За поређење земаља потребни су данашњи курсеви. Повежите се на интернет једном и биће сачувани за рад без мреже.';

  @override
  String get cmpRankedByNet => 'По нето плати';

  @override
  String get cmpRankedByCost => 'По трошку послодавца';

  @override
  String cmpCostLine(String cost, String wedge) {
    return 'Трошак послодавца $cost · порески клин $wedge';
  }

  @override
  String cmpGrossLine(String gross, String wedge) {
    return 'Бруто $gross · порески клин $wedge';
  }

  @override
  String get cmpTaxesKey => 'Порези и доприноси';

  @override
  String cmpNote(String date) {
    return 'Износи су прерачунати по званичним курсевима од $date. Свака земља користи подразумевана подешавања (без деце, стандардне локалне стопе). Порески клин је део укупног трошка послодавца који одлази на порезе и доприносе.';
  }

  @override
  String get payWedgeLabel => 'Порески клин';

  @override
  String get creditTitle => 'Кредити';

  @override
  String get creditTabLoan => 'Кредит';

  @override
  String get creditTabDeposit => 'Штедња';

  @override
  String get creditTabCompare => 'Поређење';

  @override
  String get loanAmount => 'Износ кредита';

  @override
  String get loanRate => 'Номинална каматна стопа';

  @override
  String get loanTerm => 'Рок';

  @override
  String get loanFee => 'Накнада за обраду';

  @override
  String get loanMonthlyFee => 'Месечни трошкови';

  @override
  String get loanMonthlyFeeHint => 'Рачун, осигурање…';

  @override
  String get loanRepayment => 'Отплата';

  @override
  String get loanAnnuity => 'Једнаке рате';

  @override
  String get loanLinear => 'Једнака главница';

  @override
  String get loanMore => 'Више опција';

  @override
  String get loanLess => 'Мање опција';

  @override
  String get loanCurrency => 'Валута';

  @override
  String get loanInstallment => 'Месечна рата';

  @override
  String get loanFirstInstallment => 'Прва рата';

  @override
  String get loanEir => 'ЕКС';

  @override
  String get loanTotalInterest => 'Укупна камата';

  @override
  String get loanTotal => 'Укупно за отплату';

  @override
  String loanTotalIncludes(String fees) {
    return 'Укључује главницу, камату и трошкове од $fees.';
  }

  @override
  String get loanEirNote => 'ЕКС је ефективна каматна стопа са свим трошковима, по формули ЕУ за потрошачке кредите.';

  @override
  String get loanByYear => 'По годинама';

  @override
  String get loanPrincipal => 'Главница';

  @override
  String get loanInterest => 'Камата';

  @override
  String loanYearShort(int n) {
    return '$n. г.';
  }

  @override
  String get loanSchedule => 'План отплате';

  @override
  String loanScheduleAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Цео план отплате · $count рата',
      few: 'Цео план отплате · $count рате',
      one: 'Цео план отплате · $count рата',
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
  String get loanColBalance => 'Стање дуга';

  @override
  String get loanPrepayTitle => 'Превремена отплата';

  @override
  String loanPrepayTeaser(String amount, int month, String months, String saved) {
    return 'Уплата од још $amount после рате $month скраћује кредит за $months и штеди $saved камате.';
  }

  @override
  String get loanPrepayCta => 'Израчунајте свој сценарио';

  @override
  String get loanErrorPrincipal => 'Унесите износ кредита.';

  @override
  String get loanErrorRate => 'Унесите каматну стопу између 0 и 100%.';

  @override
  String get loanErrorTerm => 'Рок мора бити између 1 и 600 месеци.';

  @override
  String get loanErrorFee => 'Трошкови морају бити мањи од кредита.';

  @override
  String get prepayTitle => 'Превремена отплата';

  @override
  String prepayIntro(String amount, String rate, String term) {
    return 'На основу вашег кредита: $amount уз $rate на $term.';
  }

  @override
  String get prepayNoLoan => 'Прво унесите кредит на картици Кредити.';

  @override
  String get prepayAmount => 'Додатна уплата';

  @override
  String get prepayAfter => 'Уплаћује се уз рату бр.';

  @override
  String get prepayMode => 'После уплате';

  @override
  String get prepayShorten => 'Краћи рок';

  @override
  String get prepayLower => 'Нижа рата';

  @override
  String get prepayFee => 'Накнада за превремену отплату';

  @override
  String get prepaySaved => 'Уштеда на камати';

  @override
  String get prepayNetSaving => 'Нето уштеда после накнаде';

  @override
  String get prepayNewTerm => 'Нови рок';

  @override
  String get prepayNewInstallment => 'Нова рата';

  @override
  String prepayMonthsSaved(String months) {
    return '$months раније';
  }

  @override
  String get prepayPaidOff => 'Додатна уплата затвара цео преостали дуг.';

  @override
  String get prepayBefore => 'Пре';

  @override
  String get prepayAfterLabel => 'После';

  @override
  String get depAmount => 'Износ штедње';

  @override
  String get depRate => 'Каматна стопа';

  @override
  String get depTerm => 'Рок';

  @override
  String get depPayout => 'Камата';

  @override
  String get depAtMaturity => 'На крају рока';

  @override
  String get depMonthly => 'Месечно, приписује се';

  @override
  String get depAnnually => 'Годишње, приписује се';

  @override
  String get depTax => 'Порез на камату';

  @override
  String get depTaxHintRs => 'У Србији је камата на динарску штедњу ослобођена пореза; на девизну штедњу порез је 15%.';

  @override
  String get depTaxHint => 'Унесите порез на камату који се на вас односи.';

  @override
  String get depContribution => 'Месечна уплата';

  @override
  String get depFinal => 'На крају рока';

  @override
  String get depGrossInterest => 'Камата пре пореза';

  @override
  String get depTaxAmount => 'Порез на камату';

  @override
  String get depNetInterest => 'Нето камата';

  @override
  String get depPaidIn => 'Уплаћено';

  @override
  String depYield(String percent) {
    return 'Нето принос $percent годишње';
  }

  @override
  String get depByYear => 'По годинама';

  @override
  String get depColYear => 'Година';

  @override
  String get depColInterest => 'Нето камата';

  @override
  String get depColBalance => 'Стање';

  @override
  String get depErrorAmount => 'Унесите износ штедње или месечну уплату.';

  @override
  String get depErrorRate => 'Унесите каматну стопу између 0 и 100%.';

  @override
  String get cmpLoanIntro => 'Исти износ за сваку понуду. Најповољнија је понуда са најмањим укупним трошком.';

  @override
  String cmpLoanOffer(int n) {
    return 'Понуда $n';
  }

  @override
  String get cmpLoanAdd => 'Додај понуду';

  @override
  String get cmpLoanRemove => 'Уклони понуду';

  @override
  String get cmpLoanBest => 'Најмањи укупан трошак';

  @override
  String cmpLoanSavesVs(String amount) {
    return '$amount јефтиније од најскупље понуде';
  }

  @override
  String get depYieldLabel => 'Нето годишњи принос';

  @override
  String get fxTitle => 'Девизни курсеви';

  @override
  String get fxTabConverter => 'Конвертор';

  @override
  String get fxTabList => 'Курсна листа';

  @override
  String fxAmount(String currency) {
    return 'Износ у $currency';
  }

  @override
  String get fxSwap => 'Замени валуте';

  @override
  String fxRateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get fxSourceNbsMiddle => 'средњи курс НБС';

  @override
  String get fxSourceNbsBuy => 'куповни курс НБС';

  @override
  String get fxSourceNbsSell => 'продајни курс НБС';

  @override
  String get fxSourceEcb => 'референтни курс ЕЦБ';

  @override
  String get fxSourceCross => 'унакрсни курс';

  @override
  String get fxKindMiddle => 'Средњи';

  @override
  String get fxKindBuy => 'Куповни';

  @override
  String get fxKindSell => 'Proдајни';

  @override
  String get fxKindHint => 'Куповни и продајни курс важе за конверзију динара.';

  @override
  String fxUpdated(String date) {
    return 'Ажурирано $date';
  }

  @override
  String fxOffline(String date) {
    return 'Без мреже · курс од $date';
  }

  @override
  String get fxLoading => 'Ажурирање курса…';

  @override
  String get fxNoRates => 'Још нема курса. Повежите се на интернет једном да преузмете данашње званичне курсеве — после тога конвертор ради и без мреже.';

  @override
  String get fxUnsupported => 'За овај пар не постоји званични курс.';

  @override
  String fxHistoryTitle(String from, String to, int days) {
    return '$from/$to · $days дана';
  }

  @override
  String fxHistoryDays(int days) {
    return '$days д';
  }

  @override
  String get fxHistoryError => 'Историја курса није доступна без мреже.';

  @override
  String get fxHistoryPro => 'Историја курса за 30, 90 и 365 дана је део пакета Pro.';

  @override
  String fxHistoryMinMax(String min, String max) {
    return 'мин $min · макс $max';
  }

  @override
  String get fxPerUnit => 'За 1 јединицу валуте';

  @override
  String get fxListNbs => 'Курсна листа НБС';

  @override
  String get fxListEcb => 'Референтни курсеви ЕЦБ, за 1 EUR';

  @override
  String get fxColBuy => 'Куповни';

  @override
  String get fxColMiddle => 'Средњи';

  @override
  String get fxColSell => 'Proдајни';

  @override
  String get fxColRate => 'Курс';

  @override
  String get fxRefresh => 'Освежи курс';

  @override
  String get fxPickFrom => 'Из валуте';

  @override
  String get fxPickTo => 'У валуту';

  @override
  String get fxSourcesNote =>
      'Званични курсеви Народне банке Србије преко kurs.resenje.org; референтни курсеви Европске централне банке преко сервиса Frankfurter. Марка је везана за евро по курсу 1,95583.';

  @override
  String get bizTitle => 'Бизнис';

  @override
  String get bizProfile => 'Подаци о фирми';

  @override
  String get bizInvoices => 'Фактуре';

  @override
  String get bizNewInvoice => 'Нова';

  @override
  String get bizInvoicesEmpty => 'Још нема фактура. Proфесионалну фактуру направите за мање од минут.';

  @override
  String bizFreeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Преостало је још $count бесплатних фактура',
      few: 'Преостале су још $count бесплатне фактуре',
      one: 'Преостала је још $count бесплатна фактура',
    );
    return '$_temp0';
  }

  @override
  String get bizTools => 'Алати';

  @override
  String bizShowAll(int count) {
    return 'Прикажи све ($count)';
  }

  @override
  String bizPausalCard(int year) {
    return 'Паушал · $year';
  }

  @override
  String get statusDraft => 'Нацрт';

  @override
  String get statusIssued => 'Чека уплату';

  @override
  String get statusPaid => 'Плаћена';

  @override
  String get statusCancelled => 'Сторнирана';

  @override
  String get statusOverdue => 'Касни';

  @override
  String get invNew => 'Нова фактура';

  @override
  String get invEdit => 'Измена фактуре';

  @override
  String get invNumber => 'Број фактуре';

  @override
  String get invIssueDate => 'Датум издавања';

  @override
  String get invServiceDate => 'Датум промета';

  @override
  String get invDueDate => 'Рок плаћања';

  @override
  String get invPlace => 'Место издавања';

  @override
  String get invClient => 'Клијент';

  @override
  String get invClientName => 'Назив клијента';

  @override
  String get invClientAddress => 'Адреса';

  @override
  String get invClientCity => 'Поштански број и место';

  @override
  String get invClientCountry => 'Држава';

  @override
  String get invClientTaxId => 'Порески број (ПИБ / VAT)';

  @override
  String get invClientRegNo => 'Матични број';

  @override
  String get invClientEmail => 'Е-пошта';

  @override
  String get invRecentClients => 'Недавни клијенти';

  @override
  String get invCurrency => 'Валута';

  @override
  String get invItems => 'Ставке';

  @override
  String get invItemDescription => 'Опис';

  @override
  String get invItemQty => 'Количина';

  @override
  String get invItemUnit => 'Јединица';

  @override
  String get invItemUnitHint => 'ком, сат, дан…';

  @override
  String get invItemPrice => 'Цена по јединици';

  @override
  String get invItemVat => 'ПДВ %';

  @override
  String get invAddItem => 'Додај ставку';

  @override
  String get invRemoveItem => 'Уклони ставку';

  @override
  String get invNote => 'Напомена';

  @override
  String get invReference => 'Позив на број';

  @override
  String get invReferenceHint => 'Модел и број, нпр. 97 1234';

  @override
  String get invSubtotal => 'Основица';

  @override
  String get invVat => 'ПДВ';

  @override
  String get invTotal => 'Укупно';

  @override
  String get invTotalDue => 'Укупно за уплату';

  @override
  String get invTotalRsd => 'Proтиввредност у RSD';

  @override
  String invRateLine(String rate, String date) {
    return 'Средњи курс НБС $rate на дан $date';
  }

  @override
  String get invRateFetching => 'Преузимање курса НБС…';

  @override
  String get invRateUnavailable => 'Курс НБС за овај датум још није објављен.';

  @override
  String get invRateRetry => 'Преузми курс';

  @override
  String get invSaveDraft => 'Сачувај нацрт';

  @override
  String get invIssue => 'Издај фактуру';

  @override
  String get invSave => 'Сачувај измене';

  @override
  String get invMarkPaid => 'Означи као плаћену';

  @override
  String get invMarkUnpaid => 'Означи као неплаћену';

  @override
  String get invCancelInvoice => 'Сторнирај фактуру';

  @override
  String get invDelete => 'Обриши фактуру';

  @override
  String invDeleteConfirm(String number) {
    return 'Обрисати фактуру $number? Ово се не може поништити.';
  }

  @override
  String get invDuplicate => 'Дуплирај';

  @override
  String get invProfileMissing => 'Прво унесите податке о фирми — појављују се на свакој фактури.';

  @override
  String get invNotInVat => 'Обвезник није у систему ПДВ-а.';

  @override
  String get invValidWithoutStamp => 'Фактура је важећа без печата и потписа.';

  @override
  String get invQrCaption => 'Скенирај и плати (НБС ИПС)';

  @override
  String get invQrHint => 'Клијент скенира QR код у апликацији своје банке — износ, рачун и позив на број попуњавају се сами.';

  @override
  String invQrMissing(String reason) {
    return 'Нема QR кода за плаћање: $reason';
  }

  @override
  String get invQrReasonAccount => 'унесите исправан рачун у подацима о фирми';

  @override
  String get invQrReasonOther => 'проверите назив фирме и позив на број';

  @override
  String get invDocTitle => 'Фактура';

  @override
  String get invSeller => 'Proдавац';

  @override
  String get invBuyer => 'Купац';

  @override
  String invPaidOn(String date) {
    return 'Плаћено $date';
  }

  @override
  String invDueOn(String date) {
    return 'Рок $date';
  }

  @override
  String get invErrorClient => 'Унесите назив клијента.';

  @override
  String get invErrorItems => 'Додајте бар једну ставку са описом и ценом.';

  @override
  String get invErrorNumber => 'Унесите број фактуре.';

  @override
  String get invErrorDue => 'Рок плаћања не може бити пре датума издавања.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Фактура $number већ постоји.';
  }

  @override
  String get invShare => 'Подели PDF';

  @override
  String get invAccount => 'Рачун';

  @override
  String get invPib => 'ПИБ';

  @override
  String get invMb => 'МБ';

  @override
  String get invReferenceLabel => 'Позив на број';

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
  String get profTitle => 'Подаци о фирми';

  @override
  String get profIntro => 'Штампају се на фактурама и, ако желите, на PDF извештајима.';

  @override
  String get profName => 'Назив фирме';

  @override
  String get profAddress => 'Улица и број';

  @override
  String get profCity => 'Поштански број и место';

  @override
  String get profCountry => 'Држава';

  @override
  String get profTaxId => 'Порески број (ПИБ)';

  @override
  String get profRegNo => 'Матични број (МБ)';

  @override
  String get profAccount => 'Текући рачун';

  @override
  String get profAccountHint => 'Рачун у Србији (160-0000000000000-00) или IBAN';

  @override
  String get profBank => 'Банка';

  @override
  String get profEmail => 'Е-пошта';

  @override
  String get profPhone => 'Телефон';

  @override
  String get profVat => 'У систему ПДВ-а';

  @override
  String get profVatHint => 'Додаје ПДВ на фактуре. Кад је искључено, на фактури пише да нисте у систему ПДВ-а.';

  @override
  String get profPaymentCode => 'Шифра плаћања за QR код';

  @override
  String get profPaymentCodeHint => '221 за плаћање робе и услуга';

  @override
  String get profDueDays => 'Подразумевани рок плаћања';

  @override
  String get profDueDaysSuffix => 'дана';

  @override
  String get profCurrency => 'Подразумевана валута фактуре';

  @override
  String get profNote => 'Подразумевана напомена на фактури';

  @override
  String get profShowOnReports => 'Прикажи податке о фирми на PDF извештајима';

  @override
  String get profInvalidPib => 'Контролна цифра ПИБ-а није исправна — проверите број.';

  @override
  String get profInvalidMb => 'Контролна цифра матичног броја није исправна.';

  @override
  String get profInvalidAccount => 'Контролни број рачуна није исправан.';

  @override
  String get profSaved => 'Подаци о фирми су сачувани';

  @override
  String get pausalTitle => 'Паушал лимити';

  @override
  String get pausalIntro =>
      'Паушалци губе паушално опорезивање изнад 6.000.000 RSD прихода у календарској години и морају у систем ПДВ-а изнад 8.000.000 RSD у било којих 12 месеци.';

  @override
  String get pausalAnnual => 'Паушал лимит, календарска година';

  @override
  String get pausalVat => 'ПДВ лимит, последњих 12 месеци';

  @override
  String pausalOf(String amount) {
    return 'од $amount';
  }

  @override
  String pausalLeft(String amount) {
    return 'Преостало $amount';
  }

  @override
  String pausalProjection(String amount) {
    return 'Овим темпом фактурисаћете око $amount до 31. децембра.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'Овим темпом прелазите паушал лимит пре краја године (око $amount).';
  }

  @override
  String get pausalWarn => 'Искористили сте више од 80% овог лимита.';

  @override
  String get pausalOver => 'Лимит је прекорачен — обратите се књиговођи.';

  @override
  String pausalMissingRate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count девизних фактура нема курс НБС и нису урачунате.',
      few: '$count девизне фактуре немају курс НБС и нису урачунате.',
      one: '$count девизна фактура нема курс НБС и није урачуната.',
    );
    return '$_temp0';
  }

  @override
  String get pausalSourceInvoices => 'Рачуна се из издатих и плаћених фактура (по датуму промета) и прихода који додате испод.';

  @override
  String get pausalManual => 'Приход ван апликације';

  @override
  String get pausalManualEmpty => 'Додајте фактуре издате на другом месту ове године да би збирови били потпуни.';

  @override
  String get pausalManualAdd => 'Додај приход';

  @override
  String get pausalManualDate => 'Датум';

  @override
  String get pausalManualAmount => 'Износ у RSD';

  @override
  String get pausalManualNote => 'Напомена';

  @override
  String get vatTitle => 'ПДВ калкулатор';

  @override
  String get vatAdd => 'Додај ПДВ';

  @override
  String get vatExtract => 'Издвој ПДВ';

  @override
  String get vatAmountNet => 'Износ без ПДВ-а';

  @override
  String get vatAmountGross => 'Износ са ПДВ-ом';

  @override
  String get vatRate => 'Стопа ПДВ-а';

  @override
  String get vatOther => 'Друга';

  @override
  String get vatNet => 'Без ПДВ-а';

  @override
  String get vatVat => 'ПДВ';

  @override
  String get vatGross => 'Са ПДВ-ом';

  @override
  String get mrgTitle => 'Маржа и разлика у цени';

  @override
  String get mrgFromPrice => 'Набавна и продајна';

  @override
  String get mrgFromMarkup => 'Разлика у цени';

  @override
  String get mrgFromMargin => 'Маржа';

  @override
  String get mrgCost => 'Набавна цена';

  @override
  String get mrgPrice => 'Proдајна цена (без ПДВ-а)';

  @override
  String get mrgMarkup => 'Разлика у цени';

  @override
  String get mrgMargin => 'Маржа';

  @override
  String get mrgDiscount => 'Попуст';

  @override
  String get mrgVat => 'ПДВ';

  @override
  String get mrgProfit => 'Бруто добит';

  @override
  String get mrgPriceAfterDiscount => 'Цена после попуста';

  @override
  String get mrgPriceWithVat => 'Цена са ПДВ-ом';

  @override
  String get mrgMarginHint => 'Маржа је добит као удео у продајној цени; разлика у цени је добит као удео у набавној цени.';

  @override
  String get mrgImpossible => 'Маржа од 100% или више није могућа.';

  @override
  String get beTitle => 'Праг рентабилности';

  @override
  String get beFixed => 'Фиксни трошкови месечно';

  @override
  String get bePrice => 'Цена по јединици';

  @override
  String get beVariable => 'Варијабилни трошак по јединици';

  @override
  String get beTarget => 'Жељена добит месечно';

  @override
  String get beUnits => 'Потребна продаја месечно';

  @override
  String beUnitsValue(int count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted комада',
      few: '$formatted комада',
      one: '$formatted комад',
    );
    return '$_temp0';
  }

  @override
  String get beRevenue => 'Потребан приход';

  @override
  String get beContribution => 'Контрибуциона маржа';

  @override
  String get beImpossible => 'Цена мора бити већа од варијабилног трошка по јединици.';

  @override
  String get invsTitle => 'Анализа инвестиције';

  @override
  String get invsInitial => 'Почетно улагање';

  @override
  String get invsRate => 'Дисконтна стопа';

  @override
  String get invsFlows => 'Нето новчани ток по годинама';

  @override
  String invsYear(int n) {
    return 'Година $n';
  }

  @override
  String get invsAddYear => 'Додај годину';

  @override
  String get invsRemoveYear => 'Уклони последњу годину';

  @override
  String get invsNpv => 'Нето садашња вредност (НСВ)';

  @override
  String get invsIrr => 'Интерна стопа приноса (ИСП)';

  @override
  String get invsPayback => 'Период повраћаја';

  @override
  String get invsDiscountedPayback => 'Дисконтовани период повраћаја';

  @override
  String get invsPi => 'Индекс профитабилности';

  @override
  String invsYears(String years) {
    return '$years год.';
  }

  @override
  String get invsNever => 'Не у овом периоду';

  @override
  String get invsNoIrr => 'Нема ИСП за ове токове';

  @override
  String invsGood(String rate) {
    return 'Ствара вредност уз дисконтну стопу $rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Умањује вредност уз дисконтну стопу $rate.';
  }

  @override
  String get profSectionBusiness => 'Фирма';

  @override
  String get profSectionPayment => 'Плаћање';

  @override
  String get profSectionContact => 'Контакт';

  @override
  String get profSectionInvoices => 'Подразумевано за фактуре';

  @override
  String get profTaxIdGeneric => 'Порески број';

  @override
  String get profRegNoGeneric => 'Матични број';

  @override
  String get profNameRequired => 'Унесите назив фирме.';

  @override
  String get profPibLength => 'ПИБ има 9 цифара.';

  @override
  String get profMbLength => 'Матични број има 8 цифара.';

  @override
  String get profInvalidAccountShape => 'Унесите рачун у Србији (160-0000000000000-00) или IBAN.';

  @override
  String get profInvalidEmail => 'Proверите адресу е-поште.';

  @override
  String get profInvalidPaymentCode => 'Шифра плаћања има три цифре, нпр. 221.';

  @override
  String get profPrivacy => 'Чува се само на овом телефону и улази у резервне копије које извезете.';

  @override
  String get profIban => 'IBAN за уплате из иностранства';

  @override
  String get profIbanHint => 'Штампа се на девизним фактурама. Оставите празно да се користи рачун изнад у IBAN облику.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban => 'Proверите IBAN — контролни бројеви нису исправни.';

  @override
  String get profInvalidSwift => 'SWIFT/BIC код има 8 или 11 знакова.';

  @override
  String get invIban => 'IBAN';

  @override
  String get invSwift => 'SWIFT/BIC';

  @override
  String get invBank => 'Банка';

  @override
  String get invSefNote =>
      'Фактуре јавном сектору — а за обвезнике ПДВ-а и фирмама у Србији — морају ићи и кроз СЕФ (е-Фактура). Bilans фактуре су за клијенте из иностранства, физичка лица и вашу евиденцију.';

  @override
  String get invRateOffline => 'НБС није доступна. Proверите везу — можете сачувати сада и преузети курс касније.';

  @override
  String get invMarkedPaid => 'Означена као плаћена';

  @override
  String get invMarkedUnpaid => 'Означена као неплаћена';

  @override
  String get invIssued => 'Фактура је издата';

  @override
  String get invCancelled => 'Фактура је сторнирана';

  @override
  String get invCompleteFirst => 'Пре издавања додајте клијента и бар једну ставку.';

  @override
  String invCancelConfirm(String number) {
    return 'Сторнирати фактуру $number?';
  }

  @override
  String get invCancelBody => 'Остаје на листи, означена као сторнирана, и више се не рачуна у приход.';

  @override
  String get invRateMissingNote => 'Још нема курса НБС — фактура се не рачуна у паушал лимите док га не добије.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'Да останете испод лимита, до краја године фактуришите највише око $amount месечно.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Приход по месецима, $year.';
  }

  @override
  String get pausalFromInvoices => 'Фактуре';

  @override
  String get pausalDisclaimer =>
      'Приход се рачуна по датуму промета. Девизне фактуре се прерачунавају по средњем курсу НБС на дан издавања. Коначне износе проверите са књиговођом.';

  @override
  String get pausalRemoveTitle => 'Уклонити овај приход?';

  @override
  String get pausalManualAmountError => 'Унесите износ.';

  @override
  String get invsFilterAll => 'Све';

  @override
  String get invsFilterDrafts => 'Нацрти';

  @override
  String get invsOutstanding => 'Чека уплату';

  @override
  String get invsSearchHint => 'Претрага по клијенту или броју';

  @override
  String get invsNoMatch => 'Ниједна фактура не одговара.';

  @override
  String get vatEmpty => 'Унесите износ да бисте га поделили на основицу и ПДВ.';

  @override
  String vatRatesNote(String country) {
    return 'Приказане стопе ПДВ-а важе за земљу: $country.';
  }

  @override
  String get mrgEmpty => 'Унесите набавну цену и продајну цену, разлику у цени или маржу.';

  @override
  String get mrgLoss => 'По овој цени продајете испод набавне цене.';

  @override
  String get beFixedHint => 'Закуп, плате, претплате…';

  @override
  String get beVariableHint => 'Материјал, провизије, достава…';

  @override
  String get beEmpty => 'Унесите фиксне трошкове, цену и варијабилни трошак по јединици.';

  @override
  String get beContributionUnit => 'Допринос по јединици';

  @override
  String get beExplain => 'Свака продата јединица доприноси ценом умањеном за варијабилни трошак покрићу фиксних трошкова и добити. Износи су без ПДВ-а.';

  @override
  String get invsFlowsHint => 'Нето новчани ток на крају сваке године. Укуцајте минус за годину у којој је више одлива него прилива.';

  @override
  String get invsEmpty => 'Унесите улагање, дисконтну стопу и новчани ток за бар једну годину.';

  @override
  String get invsCumulative => 'Кумулативни новчани ток';

  @override
  String get invCreatedWith => 'Направљено у апликацији Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead => 'Сви калкулатори, све земље, неограничене фактуре и PDF извештаји. Без реклама, без налога.';

  @override
  String get proFeatAllCountries => 'Обрачун плате за свих 9 пореских система';

  @override
  String get proFeatUnlimitedInvoices => 'Неограничен број фактура';

  @override
  String get proFeatPdf => 'PDF извештаји';

  @override
  String get proFeatUnlimitedSaves => 'Неограничен број сачуваних обрачуна';

  @override
  String get proBenefitCountries => 'Обрачун плате за свих 9 пореских система и поређење исте плате по земљама';

  @override
  String get proBenefitTeam => 'Трошак тима: све зараде по месецима и годинама';

  @override
  String get proBenefitInvoices => 'Неограничен број професионалних PDF фактура';

  @override
  String get proBenefitInvoicesRs => 'Неограничен број фактура са НБС ИПС QR кодом за плаћање';

  @override
  String get proBenefitPausal => 'Праћење паушал лимита од 6 и 8 милиона динара';

  @override
  String get proBenefitLoans => 'Поређење понуда за кредит и план превремене отплате';

  @override
  String get proBenefitHistory => 'Историја курса за 30, 90 и 365 дана';

  @override
  String get proBenefitInvestment => 'Анализа инвестиција: НСВ, ИСП и период повраћаја';

  @override
  String get proBenefitPdf => 'PDF извештаји за плате, кредите, штедњу и тимове';

  @override
  String get proYearly => 'Годишње';

  @override
  String get proMonthly => 'Месечно';

  @override
  String get proLifetime => 'Трајно';

  @override
  String get proPerYear => 'годишње';

  @override
  String get proPerMonth => 'месечно';

  @override
  String get proOnce => 'једнократно';

  @override
  String proSave(int percent) {
    return 'УШТЕДА $percent%';
  }

  @override
  String proTrialNote(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дана бесплатно, затим годишња наплата',
      few: '$days дана бесплатно, затим годишња наплата',
      one: '$days дан бесплатно, затим годишња наплата',
    );
    return '$_temp0';
  }

  @override
  String get proLifetimeNote => 'Платите једном, Pro остаје заувек';

  @override
  String proStartTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Почни бесплатну пробу од $days дана',
      few: 'Почни бесплатну пробу од $days дана',
      one: 'Почни бесплатну пробу од $days дана',
    );
    return '$_temp0';
  }

  @override
  String get proContinue => 'Настави';

  @override
  String get proRestore => 'Врати куповину';

  @override
  String get proRestored => 'Bilans Pro је активан на овом уређају.';

  @override
  String get proNothingToRestore => 'За овај Гоогле налог није пронађена куповина пакета Bilans Pro.';

  @override
  String get proPending => 'Плаћање је на чекању. Pro се откључава аутоматски чим Google Play потврди уплату.';

  @override
  String get proError => 'Куповина није успела. Новац није наплаћен — покушајте поново.';

  @override
  String get proUnavailable => 'Куповина тренутно није доступна. Proверите да ли је Google Play инсталиран и да ли сте пријављени, па покушајте поново.';

  @override
  String get proLegal =>
      'Претплата се аутоматски обнавља по приказаној цени док је не откажете. Отказати можете било кад у Google Play → Плаћања и претплате, најкасније 24 сата пре обнове. Бесплатна проба прелази у плаћену годишњу претплату ако је не откажете пре истека.';

  @override
  String get proLegalLifetime => 'Једнократна куповина: без претплате и без обнављања. Pro је активан на сваком уређају пријављеном на исти Гоогле налог.';

  @override
  String get proDevSimulate => 'Симулирај Pro (развојна верзија)';

  @override
  String get proWelcome => 'Добро дошли у Bilans Pro';

  @override
  String get proWelcomeBody => 'Све је откључано. Хвала што подржавате независну апликацију.';

  @override
  String get settingsPreferences => 'Подешавања';

  @override
  String get settingsTheme => 'Изглед';

  @override
  String get settingsThemeSystem => 'Системски';

  @override
  String get settingsThemeLight => 'Светли';

  @override
  String get settingsThemeDark => 'Тамни';

  @override
  String get settingsYourData => 'Ваши подаци';

  @override
  String get settingsExport => 'Извези резервну копију';

  @override
  String get settingsImport => 'Врати из резервне копије';

  @override
  String get settingsBackupSubject => 'Bilans резервна копија';

  @override
  String get settingsExported => 'Резервна копија је спремна';

  @override
  String get settingsImportInvalid => 'Та датотека није Bilans резервна копија.';

  @override
  String get settingsImportTitle => 'Вратити ову резервну копију?';

  @override
  String get settingsImportBody => 'Све у апликацији биће замењено садржајем копије — фактуре, подаци о фирми, тим и сачувани обрачуни.';

  @override
  String get settingsImportAction => 'Врати';

  @override
  String get settingsImported => 'Резервна копија је враћена';

  @override
  String get settingsDeleteAll => 'Обриши све податке';

  @override
  String get settingsDeleteTitle => 'Обрисати све податке?';

  @override
  String get settingsDeleteBody =>
      'Фактуре, подаци о фирми, тим, сачувани обрачуни и подешавања биће уклоњени са овог телефона. Ако вам могу затребати, прво извезите резервну копију. Куповина пакета Pro остаје.';

  @override
  String get settingsDeleteAction => 'Обриши све';

  @override
  String get settingsDataNote =>
      'Bilans нема налоге ни сервере: ваши подаци постоје само на овом телефону. Извезите резервну копију да их пренесете на нови телефон.';

  @override
  String get settingsAbout => 'О апликацији';

  @override
  String get settingsRate => 'Оцените Bilans на Google Play-у';

  @override
  String get settingsContact => 'Контакт';

  @override
  String get settingsPrivacy => 'Политика приватности';

  @override
  String get settingsTerms => 'Услови коришћења';

  @override
  String get settingsLicenses => 'Лиценце отвореног кода';

  @override
  String get settingsDisclaimer => 'Обрачуни су информативни и не замењују стручни порески, правни или финансијски савет.';

  @override
  String get settingsProActive => 'Bilans Pro је активан';

  @override
  String get settingsManageSubscription => 'Управљај претплатом';

  @override
  String get settingsProPitch => 'Све земље, трошак тима, неограничене фактуре, PDF извештаји и још много тога.';

  @override
  String get settingsSeePlans => 'Погледај пакете';

  @override
  String get proIncluded => 'Укључено у Pro';

  @override
  String proSummaryTrial(int days, String price, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дана бесплатно, затим $price $period. Откажите било кад.',
      few: '$days дана бесплатно, затим $price $period. Откажите било кад.',
      one: '$days дан бесплатно, затим $price $period. Откажите било кад.',
    );
    return '$_temp0';
  }

  @override
  String proSummary(String price, String period) {
    return '$price $period, аутоматска обнова. Откажите било кад.';
  }

  @override
  String proSummaryLifetime(String price) {
    return 'Једнократно плаћање од $price. Без претплате.';
  }
}

/// The translations for Serbian, using the Latin script (`sr_Latn`).
class AppLocalizationsSrLatn extends AppLocalizationsSr {
  AppLocalizationsSrLatn() : super('sr_Latn');

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
  String get actionShare => 'Podeli';

  @override
  String get actionDelete => 'Obriši';

  @override
  String get actionCancel => 'Otkaži';

  @override
  String get actionClose => 'Zatvori';

  @override
  String get actionDone => 'Gotovo';

  @override
  String get actionRetry => 'Pokušaj ponovo';

  @override
  String get actionEdit => 'Izmeni';

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
  String get actionClear => 'Obriši sve';

  @override
  String get commonMonthly => 'Mesečno';

  @override
  String get commonAnnual => 'Godišnje';

  @override
  String get commonMonthsShort => 'mes.';

  @override
  String commonMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meseci',
      few: '$count meseca',
      one: '$count mesec',
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
  String get commonOptional => 'opciono';

  @override
  String get commonSearch => 'Pretraga';

  @override
  String get commonToday => 'Danas';

  @override
  String get snackSaved => 'Sačuvano';

  @override
  String get snackDeleted => 'Obrisano';

  @override
  String get errorGeneric => 'Nešto nije u redu. Pokušajte ponovo.';

  @override
  String get errorShare => 'Deljenje trenutno nije moguće.';

  @override
  String get errorOpenLink => 'Link nije moguće otvoriti.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature je deo paketa Bilans Pro';
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
  String get countryMK => 'Severna Makedonija';

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
  String get curEUR => 'Evro';

  @override
  String get curUSD => 'Američki dolar';

  @override
  String get curCHF => 'Švajcarski franak';

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
  String get discardTitle => 'Odbaciti izmene?';

  @override
  String get discardBody => 'Izmene nisu sačuvane.';

  @override
  String get discardKeep => 'Nastavi uređivanje';

  @override
  String get discardAction => 'Odbaci';

  @override
  String get commonMore => 'Još opcija';

  @override
  String get errorPdf => 'PDF nije napravljen. Pokušajte ponovo.';

  @override
  String get pdfLanguageTitle => 'Jezik fakture';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + engleski';
  }

  @override
  String get onbHeadline => 'Brojke na koje možete da se oslonite.';

  @override
  String get onbBody => 'Plate, krediti, zvanični kursevi i fakture — obračunati po pravilima vaše zemlje. Bez naloga, bez praćenja.';

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
  String get homeSettings => 'Podešavanja';

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
  String get homeRatesEmpty => 'Današnji zvanični kursevi pojaviće se ovde čim budete na mreži.';

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
  String get toolTeamDesc => 'Mesečni i godišnji trošak zarada';

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
  String get toolLoanCompareDesc => 'Do tri ponude, rangirane po EKS';

  @override
  String get toolPrepay => 'Prevremena otplata';

  @override
  String get toolPrepayDesc => 'Koliko kamate štedite';

  @override
  String get toolConverter => 'Konvertor valuta';

  @override
  String get toolConverterDesc => 'Zvanični kursevi NBS i ECB';

  @override
  String get toolRateHistory => 'Istorija kursa';

  @override
  String get toolRateHistoryDesc => '30, 90 i 365 dana';

  @override
  String get toolInvoices => 'Fakture';

  @override
  String get toolInvoicesDescRs => 'PDF sa NBS IPS QR kodom';

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
  String get toolMargin => 'Marža i razlika u ceni';

  @override
  String get toolMarginDesc => 'Nabavna cena, prodajna cena i popust';

  @override
  String get toolBreakEven => 'Prag rentabilnosti';

  @override
  String get toolBreakEvenDesc => 'Koliko treba da prodate';

  @override
  String get toolInvestment => 'Investicija';

  @override
  String get toolInvestmentDesc => 'NSV, ISP i period povraćaja';

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
    return 'cena sa PDV-om · marža $margin';
  }

  @override
  String recentBreakEvenSub(String amount) {
    return 'mesečno · prihod $amount';
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
  String get historySavedEmpty => 'Dodirnite Sačuvaj na bilo kom rezultatu da biste ga zadržali ovde pod imenom.';

  @override
  String get historyRecentEmpty => 'Završeni obračuni pojavljuju se ovde automatski.';

  @override
  String get historyClearTitle => 'Obrisati listu nedavnih?';

  @override
  String get payTitle => 'Obračun plate';

  @override
  String get payModeGross => 'Bruto → neto';

  @override
  String get payModeNet => 'Neto → bruto';

  @override
  String get payModeCost => 'Ukupan trošak';

  @override
  String get payModeSemantic => 'Smer obračuna';

  @override
  String get payInputGross => 'Bruto plata · mesečno';

  @override
  String get payInputNet => 'Željena neto plata · mesečno';

  @override
  String get payInputCost => 'Budžet poslodavca · mesečno';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Najniža osnovica doprinosa: $amount';
  }

  @override
  String get payHelperNet => 'Iznos koji zaposleni dobija';

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
    return '$percent od bruto iznosa';
  }

  @override
  String payNetLine(String amount) {
    return 'Neto plata: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Ukupan trošak poslodavca: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'Na šta odlazi ukupan trošak poslodavca';

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
  String get payTotalCost => 'Ukupan trošak zarade';

  @override
  String get payNonTaxable => 'Neoporezivi iznos';

  @override
  String get payPersonalAllowance => 'Lični odbitak';

  @override
  String get payGeneralAllowance => 'Opšta olakšica';

  @override
  String get payPersonalExemption => 'Lično oslobođenje';

  @override
  String get payPersonalDeduction => 'Lična dedukcija';

  @override
  String get payTaxBase => 'Poreska osnovica';

  @override
  String get payIncomeTax => 'Porez na zaradu';

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
  String get payFixedMonthly => 'fiksno mesečno';

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
    return 'Informativni obračun po propisima koji važe od $date. Ne zamenjuje zvanični obračun zarade.';
  }

  @override
  String get payAnnualNote => 'Godišnji iznosi su 12 × mesečni; godišnje poresko usklađivanje može se razlikovati.';

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
  String get payNoteNonPositive => 'Obavezna davanja su veća od ove plate.';

  @override
  String get payEmpty => 'Unesite iznos za potpun obračun — doprinose, porez i ukupan trošak poslodavca.';

  @override
  String get payErrorTooLarge => 'Iznos je prevelik za obračun.';

  @override
  String get paySystemTitle => 'Poreski sistem';

  @override
  String get paySystemProHint => 'Vaša zemlja je besplatna. Ostale zemlje su deo paketa Pro.';

  @override
  String get payOptions => 'Opcije';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Porez $lower / $higher · deca $children';
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
  String get payOptionsRoMinWage => 'olakšica za minimalnu zaradu';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Fond za OSI $state';
  }

  @override
  String get payOn => 'uključen';

  @override
  String get payOff => 'isključen';

  @override
  String get payHrRates => 'Opštinske stope poreza na dohodak';

  @override
  String get payHrLower => 'Niža stopa';

  @override
  String get payHrHigher => 'Viša stopa';

  @override
  String get payHrRatesHint => 'Određuje ih grad ili opština: 15–23% i 25–33%. Bez odluke važe 20% i 30%.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'Niža stopa $lowRange, viša stopa $highRange';
  }

  @override
  String get payChildren => 'Deca';

  @override
  String get payDependents => 'Ostali izdržavani članovi';

  @override
  String get payRoDependents => 'Izdržavani članovi';

  @override
  String get payRoMinWage => 'Olakšica za minimalnu zaradu';

  @override
  String get payRoMinWageHint => 'Za zaposlene sa nacionalnom minimalnom zaradom 200 leja je oslobođeno.';

  @override
  String get payMeSurtax => 'Stopa prireza';

  @override
  String get payMeSurtaxHint => '13% u većini opština, 15% u Podgorici i na Cetinju.';

  @override
  String get payFbihDisability => 'Fond za zapošljavanje OSI 0,5%';

  @override
  String get payFbihDisabilityHint => 'Plaćaju ga firme koje ne zapošljavaju propisani broj osoba sa invaliditetom.';

  @override
  String get itemPension => 'Penzijsko i invalidsko osiguranje';

  @override
  String get itemHealth => 'Zdravstveno osiguranje';

  @override
  String get itemUnemployment => 'Osiguranje za slučaj nezaposlenosti';

  @override
  String get itemChildProtection => 'Dečija zaštita';

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
  String get itemLongTermCare => 'Dugotrajna nega';

  @override
  String get itemParental => 'Roditeljska zaštita';

  @override
  String get itemCompulsoryHealth => 'Obavezni zdravstveni doprinos';

  @override
  String get itemWaterFee => 'Opšta vodna naknada';

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
  String get teamEdit => 'Izmeni zaposlenog';

  @override
  String get teamEmptyTitle => 'Planirajte troškove zarada';

  @override
  String get teamEmpty =>
      'Dodajte tim — bruto, neto i ukupan trošak poslodavca za svakoga, sabrano za mesec i godinu. Možete kombinovati zemlje ako zapošljavate preko granice.';

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
  String get teamNote => 'Svako se obračunava po propisima svog poreskog sistema. Godišnji iznosi su 12 × mesečni.';

  @override
  String get teamCurrenciesNote => 'Zbirovi su prikazani posebno za svaku valutu.';

  @override
  String get teamUnnamed => 'Bez imena';

  @override
  String get teamTotal => 'Ukupno';

  @override
  String get teamCostShort => 'ukupan trošak';

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
  String get cmpNeedsRates => 'Za poređenje zemalja potrebni su današnji kursevi. Povežite se na internet jednom i biće sačuvani za rad bez mreže.';

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
    return 'Iznosi su preračunati po zvaničnim kursevima od $date. Svaka zemlja koristi podrazumevana podešavanja (bez dece, standardne lokalne stope). Poreski klin je deo ukupnog troška poslodavca koji odlazi na poreze i doprinose.';
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
  String get loanMonthlyFee => 'Mesečni troškovi';

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
  String get loanInstallment => 'Mesečna rata';

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
  String get loanEirNote => 'EKS je efektivna kamatna stopa sa svim troškovima, po formuli EU za potrošačke kredite.';

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
      other: 'Ceo plan otplate · $count rata',
      few: 'Ceo plan otplate · $count rate',
      one: 'Ceo plan otplate · $count rata',
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
  String get loanPrepayTitle => 'Prevremena otplata';

  @override
  String loanPrepayTeaser(String amount, int month, String months, String saved) {
    return 'Uplata od još $amount posle rate $month skraćuje kredit za $months i štedi $saved kamate.';
  }

  @override
  String get loanPrepayCta => 'Izračunajte svoj scenario';

  @override
  String get loanErrorPrincipal => 'Unesite iznos kredita.';

  @override
  String get loanErrorRate => 'Unesite kamatnu stopu između 0 i 100%.';

  @override
  String get loanErrorTerm => 'Rok mora biti između 1 i 600 meseci.';

  @override
  String get loanErrorFee => 'Troškovi moraju biti manji od kredita.';

  @override
  String get prepayTitle => 'Prevremena otplata';

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
  String get prepayMode => 'Posle uplate';

  @override
  String get prepayShorten => 'Kraći rok';

  @override
  String get prepayLower => 'Niža rata';

  @override
  String get prepayFee => 'Naknada za prevremenu otplatu';

  @override
  String get prepaySaved => 'Ušteda na kamati';

  @override
  String get prepayNetSaving => 'Neto ušteda posle naknade';

  @override
  String get prepayNewTerm => 'Novi rok';

  @override
  String get prepayNewInstallment => 'Nova rata';

  @override
  String prepayMonthsSaved(String months) {
    return '$months ranije';
  }

  @override
  String get prepayPaidOff => 'Dodatna uplata zatvara ceo preostali dug.';

  @override
  String get prepayBefore => 'Pre';

  @override
  String get prepayAfterLabel => 'Posle';

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
  String get depMonthly => 'Mesečno, pripisuje se';

  @override
  String get depAnnually => 'Godišnje, pripisuje se';

  @override
  String get depTax => 'Porez na kamatu';

  @override
  String get depTaxHintRs => 'U Srbiji je kamata na dinarsku štednju oslobođena poreza; na deviznu štednju porez je 15%.';

  @override
  String get depTaxHint => 'Unesite porez na kamatu koji se na vas odnosi.';

  @override
  String get depContribution => 'Mesečna uplata';

  @override
  String get depFinal => 'Na kraju roka';

  @override
  String get depGrossInterest => 'Kamata pre poreza';

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
  String get depErrorAmount => 'Unesite iznos štednje ili mesečnu uplatu.';

  @override
  String get depErrorRate => 'Unesite kamatnu stopu između 0 i 100%.';

  @override
  String get cmpLoanIntro => 'Isti iznos za svaku ponudu. Najpovoljnija je ponuda sa najmanjim ukupnim troškom.';

  @override
  String cmpLoanOffer(int n) {
    return 'Ponuda $n';
  }

  @override
  String get cmpLoanAdd => 'Dodaj ponudu';

  @override
  String get cmpLoanRemove => 'Ukloni ponudu';

  @override
  String get cmpLoanBest => 'Najmanji ukupan trošak';

  @override
  String cmpLoanSavesVs(String amount) {
    return '$amount jeftinije od najskuplje ponude';
  }

  @override
  String get depYieldLabel => 'Neto godišnji prinos';

  @override
  String get fxTitle => 'Devizni kursevi';

  @override
  String get fxTabConverter => 'Konvertor';

  @override
  String get fxTabList => 'Kursna lista';

  @override
  String fxAmount(String currency) {
    return 'Iznos u $currency';
  }

  @override
  String get fxSwap => 'Zameni valute';

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
  String get fxKindHint => 'Kupovni i prodajni kurs važe za konverziju dinara.';

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
  String get fxNoRates => 'Još nema kursa. Povežite se na internet jednom da preuzmete današnje zvanične kurseve — posle toga konvertor radi i bez mreže.';

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
  String get fxHistoryError => 'Istorija kursa nije dostupna bez mreže.';

  @override
  String get fxHistoryPro => 'Istorija kursa za 30, 90 i 365 dana je deo paketa Pro.';

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
  String get fxRefresh => 'Osveži kurs';

  @override
  String get fxPickFrom => 'Iz valute';

  @override
  String get fxPickTo => 'U valutu';

  @override
  String get fxSourcesNote =>
      'Zvanični kursevi Narodne banke Srbije preko kurs.resenje.org; referentni kursevi Evropske centralne banke preko servisa Frankfurter. Marka je vezana za evro po kursu 1,95583.';

  @override
  String get bizTitle => 'Biznis';

  @override
  String get bizProfile => 'Podaci o firmi';

  @override
  String get bizInvoices => 'Fakture';

  @override
  String get bizNewInvoice => 'Nova';

  @override
  String get bizInvoicesEmpty => 'Još nema faktura. Profesionalnu fakturu napravite za manje od minut.';

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
  String get invEdit => 'Izmena fakture';

  @override
  String get invNumber => 'Broj fakture';

  @override
  String get invIssueDate => 'Datum izdavanja';

  @override
  String get invServiceDate => 'Datum prometa';

  @override
  String get invDueDate => 'Rok plaćanja';

  @override
  String get invPlace => 'Mesto izdavanja';

  @override
  String get invClient => 'Klijent';

  @override
  String get invClientName => 'Naziv klijenta';

  @override
  String get invClientAddress => 'Adresa';

  @override
  String get invClientCity => 'Poštanski broj i mesto';

  @override
  String get invClientCountry => 'Država';

  @override
  String get invClientTaxId => 'Poreski broj (PIB / VAT)';

  @override
  String get invClientRegNo => 'Matični broj';

  @override
  String get invClientEmail => 'E-pošta';

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
  String get invItemPrice => 'Cena po jedinici';

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
  String get invTotalRsd => 'Protivvrednost u RSD';

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
  String get invSave => 'Sačuvaj izmene';

  @override
  String get invMarkPaid => 'Označi kao plaćenu';

  @override
  String get invMarkUnpaid => 'Označi kao neplaćenu';

  @override
  String get invCancelInvoice => 'Storniraj fakturu';

  @override
  String get invDelete => 'Obriši fakturu';

  @override
  String invDeleteConfirm(String number) {
    return 'Obrisati fakturu $number? Ovo se ne može poništiti.';
  }

  @override
  String get invDuplicate => 'Dupliraj';

  @override
  String get invProfileMissing => 'Prvo unesite podatke o firmi — pojavljuju se na svakoj fakturi.';

  @override
  String get invNotInVat => 'Obveznik nije u sistemu PDV-a.';

  @override
  String get invValidWithoutStamp => 'Faktura je važeća bez pečata i potpisa.';

  @override
  String get invQrCaption => 'Skeniraj i plati (NBS IPS)';

  @override
  String get invQrHint => 'Klijent skenira QR kod u aplikaciji svoje banke — iznos, račun i poziv na broj popunjavaju se sami.';

  @override
  String invQrMissing(String reason) {
    return 'Nema QR koda za plaćanje: $reason';
  }

  @override
  String get invQrReasonAccount => 'unesite ispravan račun u podacima o firmi';

  @override
  String get invQrReasonOther => 'proverite naziv firme i poziv na broj';

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
  String get invErrorItems => 'Dodajte bar jednu stavku sa opisom i cenom.';

  @override
  String get invErrorNumber => 'Unesite broj fakture.';

  @override
  String get invErrorDue => 'Rok plaćanja ne može biti pre datuma izdavanja.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Faktura $number već postoji.';
  }

  @override
  String get invShare => 'Podeli PDF';

  @override
  String get invAccount => 'Račun';

  @override
  String get invPib => 'PIB';

  @override
  String get invMb => 'MB';

  @override
  String get invReferenceLabel => 'Poziv na broj';

  @override
  String get invPlaceLabel => 'Mesto';

  @override
  String get invColItem => 'Stavka';

  @override
  String get invColQty => 'Kol.';

  @override
  String get invColPrice => 'Cena';

  @override
  String get invColAmount => 'Iznos';

  @override
  String get profTitle => 'Podaci o firmi';

  @override
  String get profIntro => 'Štampaju se na fakturama i, ako želite, na PDF izveštajima.';

  @override
  String get profName => 'Naziv firme';

  @override
  String get profAddress => 'Ulica i broj';

  @override
  String get profCity => 'Poštanski broj i mesto';

  @override
  String get profCountry => 'Država';

  @override
  String get profTaxId => 'Poreski broj (PIB)';

  @override
  String get profRegNo => 'Matični broj (MB)';

  @override
  String get profAccount => 'Tekući račun';

  @override
  String get profAccountHint => 'Račun u Srbiji (160-0000000000000-00) ili IBAN';

  @override
  String get profBank => 'Banka';

  @override
  String get profEmail => 'E-pošta';

  @override
  String get profPhone => 'Telefon';

  @override
  String get profVat => 'U sistemu PDV-a';

  @override
  String get profVatHint => 'Dodaje PDV na fakture. Kad je isključeno, na fakturi piše da niste u sistemu PDV-a.';

  @override
  String get profPaymentCode => 'Šifra plaćanja za QR kod';

  @override
  String get profPaymentCodeHint => '221 za plaćanje robe i usluga';

  @override
  String get profDueDays => 'Podrazumevani rok plaćanja';

  @override
  String get profDueDaysSuffix => 'dana';

  @override
  String get profCurrency => 'Podrazumevana valuta fakture';

  @override
  String get profNote => 'Podrazumevana napomena na fakturi';

  @override
  String get profShowOnReports => 'Prikaži podatke o firmi na PDF izveštajima';

  @override
  String get profInvalidPib => 'Kontrolna cifra PIB-a nije ispravna — proverite broj.';

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
      'Paušalci gube paušalno oporezivanje iznad 6.000.000 RSD prihoda u kalendarskoj godini i moraju u sistem PDV-a iznad 8.000.000 RSD u bilo kojih 12 meseci.';

  @override
  String get pausalAnnual => 'Paušal limit, kalendarska godina';

  @override
  String get pausalVat => 'PDV limit, poslednjih 12 meseci';

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
    return 'Ovim tempom fakturisaćete oko $amount do 31. decembra.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'Ovim tempom prelazite paušal limit pre kraja godine (oko $amount).';
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
  String get pausalSourceInvoices => 'Računa se iz izdatih i plaćenih faktura (po datumu prometa) i prihoda koji dodate ispod.';

  @override
  String get pausalManual => 'Prihod van aplikacije';

  @override
  String get pausalManualEmpty => 'Dodajte fakture izdate na drugom mestu ove godine da bi zbirovi bili potpuni.';

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
  String get vatExtract => 'Izdvoj PDV';

  @override
  String get vatAmountNet => 'Iznos bez PDV-a';

  @override
  String get vatAmountGross => 'Iznos sa PDV-om';

  @override
  String get vatRate => 'Stopa PDV-a';

  @override
  String get vatOther => 'Druga';

  @override
  String get vatNet => 'Bez PDV-a';

  @override
  String get vatVat => 'PDV';

  @override
  String get vatGross => 'Sa PDV-om';

  @override
  String get mrgTitle => 'Marža i razlika u ceni';

  @override
  String get mrgFromPrice => 'Nabavna i prodajna';

  @override
  String get mrgFromMarkup => 'Razlika u ceni';

  @override
  String get mrgFromMargin => 'Marža';

  @override
  String get mrgCost => 'Nabavna cena';

  @override
  String get mrgPrice => 'Prodajna cena (bez PDV-a)';

  @override
  String get mrgMarkup => 'Razlika u ceni';

  @override
  String get mrgMargin => 'Marža';

  @override
  String get mrgDiscount => 'Popust';

  @override
  String get mrgVat => 'PDV';

  @override
  String get mrgProfit => 'Bruto dobit';

  @override
  String get mrgPriceAfterDiscount => 'Cena posle popusta';

  @override
  String get mrgPriceWithVat => 'Cena sa PDV-om';

  @override
  String get mrgMarginHint => 'Marža je dobit kao udeo u prodajnoj ceni; razlika u ceni je dobit kao udeo u nabavnoj ceni.';

  @override
  String get mrgImpossible => 'Marža od 100% ili više nije moguća.';

  @override
  String get beTitle => 'Prag rentabilnosti';

  @override
  String get beFixed => 'Fiksni troškovi mesečno';

  @override
  String get bePrice => 'Cena po jedinici';

  @override
  String get beVariable => 'Varijabilni trošak po jedinici';

  @override
  String get beTarget => 'Željena dobit mesečno';

  @override
  String get beUnits => 'Potrebna prodaja mesečno';

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
  String get beImpossible => 'Cena mora biti veća od varijabilnog troška po jedinici.';

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
  String get invsRemoveYear => 'Ukloni poslednju godinu';

  @override
  String get invsNpv => 'Neto sadašnja vrednost (NSV)';

  @override
  String get invsIrr => 'Interna stopa prinosa (ISP)';

  @override
  String get invsPayback => 'Period povraćaja';

  @override
  String get invsDiscountedPayback => 'Diskontovani period povraćaja';

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
    return 'Stvara vrednost uz diskontnu stopu $rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Umanjuje vrednost uz diskontnu stopu $rate.';
  }

  @override
  String get profSectionBusiness => 'Firma';

  @override
  String get profSectionPayment => 'Plaćanje';

  @override
  String get profSectionContact => 'Kontakt';

  @override
  String get profSectionInvoices => 'Podrazumevano za fakture';

  @override
  String get profTaxIdGeneric => 'Poreski broj';

  @override
  String get profRegNoGeneric => 'Matični broj';

  @override
  String get profNameRequired => 'Unesite naziv firme.';

  @override
  String get profPibLength => 'PIB ima 9 cifara.';

  @override
  String get profMbLength => 'Matični broj ima 8 cifara.';

  @override
  String get profInvalidAccountShape => 'Unesite račun u Srbiji (160-0000000000000-00) ili IBAN.';

  @override
  String get profInvalidEmail => 'Proverite adresu e-pošte.';

  @override
  String get profInvalidPaymentCode => 'Šifra plaćanja ima tri cifre, npr. 221.';

  @override
  String get profPrivacy => 'Čuva se samo na ovom telefonu i ulazi u rezervne kopije koje izvezete.';

  @override
  String get profIban => 'IBAN za uplate iz inostranstva';

  @override
  String get profIbanHint => 'Štampa se na deviznim fakturama. Ostavite prazno da se koristi račun iznad u IBAN obliku.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban => 'Proverite IBAN — kontrolni brojevi nisu ispravni.';

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
      'Fakture javnom sektoru — a za obveznike PDV-a i firmama u Srbiji — moraju ići i kroz SEF (e-Faktura). Bilans fakture su za klijente iz inostranstva, fizička lica i vašu evidenciju.';

  @override
  String get invRateOffline => 'NBS nije dostupna. Proverite vezu — možete sačuvati sada i preuzeti kurs kasnije.';

  @override
  String get invMarkedPaid => 'Označena kao plaćena';

  @override
  String get invMarkedUnpaid => 'Označena kao neplaćena';

  @override
  String get invIssued => 'Faktura je izdata';

  @override
  String get invCancelled => 'Faktura je stornirana';

  @override
  String get invCompleteFirst => 'Pre izdavanja dodajte klijenta i bar jednu stavku.';

  @override
  String invCancelConfirm(String number) {
    return 'Stornirati fakturu $number?';
  }

  @override
  String get invCancelBody => 'Ostaje na listi, označena kao stornirana, i više se ne računa u prihod.';

  @override
  String get invRateMissingNote => 'Još nema kursa NBS — faktura se ne računa u paušal limite dok ga ne dobije.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'Da ostanete ispod limita, do kraja godine fakturišite najviše oko $amount mesečno.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Prihod po mesecima, $year.';
  }

  @override
  String get pausalFromInvoices => 'Fakture';

  @override
  String get pausalDisclaimer =>
      'Prihod se računa po datumu prometa. Devizne fakture se preračunavaju po srednjem kursu NBS na dan izdavanja. Konačne iznose proverite sa knjigovođom.';

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
  String get vatEmpty => 'Unesite iznos da biste ga podelili na osnovicu i PDV.';

  @override
  String vatRatesNote(String country) {
    return 'Prikazane stope PDV-a važe za zemlju: $country.';
  }

  @override
  String get mrgEmpty => 'Unesite nabavnu cenu i prodajnu cenu, razliku u ceni ili maržu.';

  @override
  String get mrgLoss => 'Po ovoj ceni prodajete ispod nabavne cene.';

  @override
  String get beFixedHint => 'Zakup, plate, pretplate…';

  @override
  String get beVariableHint => 'Materijal, provizije, dostava…';

  @override
  String get beEmpty => 'Unesite fiksne troškove, cenu i varijabilni trošak po jedinici.';

  @override
  String get beContributionUnit => 'Doprinos po jedinici';

  @override
  String get beExplain => 'Svaka prodata jedinica doprinosi cenom umanjenom za varijabilni trošak pokriću fiksnih troškova i dobiti. Iznosi su bez PDV-a.';

  @override
  String get invsFlowsHint => 'Neto novčani tok na kraju svake godine. Ukucajte minus za godinu u kojoj je više odliva nego priliva.';

  @override
  String get invsEmpty => 'Unesite ulaganje, diskontnu stopu i novčani tok za bar jednu godinu.';

  @override
  String get invsCumulative => 'Kumulativni novčani tok';

  @override
  String get invCreatedWith => 'Napravljeno u aplikaciji Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead => 'Svi kalkulatori, sve zemlje, neograničene fakture i PDF izveštaji. Bez reklama, bez naloga.';

  @override
  String get proFeatAllCountries => 'Obračun plate za svih 9 poreskih sistema';

  @override
  String get proFeatUnlimitedInvoices => 'Neograničen broj faktura';

  @override
  String get proFeatPdf => 'PDF izveštaji';

  @override
  String get proFeatUnlimitedSaves => 'Neograničen broj sačuvanih obračuna';

  @override
  String get proBenefitCountries => 'Obračun plate za svih 9 poreskih sistema i poređenje iste plate po zemljama';

  @override
  String get proBenefitTeam => 'Trošak tima: sve zarade po mesecima i godinama';

  @override
  String get proBenefitInvoices => 'Neograničen broj profesionalnih PDF faktura';

  @override
  String get proBenefitInvoicesRs => 'Neograničen broj faktura sa NBS IPS QR kodom za plaćanje';

  @override
  String get proBenefitPausal => 'Praćenje paušal limita od 6 i 8 miliona dinara';

  @override
  String get proBenefitLoans => 'Poređenje ponuda za kredit i plan prevremene otplate';

  @override
  String get proBenefitHistory => 'Istorija kursa za 30, 90 i 365 dana';

  @override
  String get proBenefitInvestment => 'Analiza investicija: NSV, ISP i period povraćaja';

  @override
  String get proBenefitPdf => 'PDF izveštaji za plate, kredite, štednju i timove';

  @override
  String get proYearly => 'Godišnje';

  @override
  String get proMonthly => 'Mesečno';

  @override
  String get proLifetime => 'Trajno';

  @override
  String get proPerYear => 'godišnje';

  @override
  String get proPerMonth => 'mesečno';

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
  String get proLifetimeNote => 'Platite jednom, Pro ostaje zauvek';

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
  String get proNothingToRestore => 'Za ovaj Google nalog nije pronađena kupovina paketa Bilans Pro.';

  @override
  String get proPending => 'Plaćanje je na čekanju. Pro se otključava automatski čim Google Play potvrdi uplatu.';

  @override
  String get proError => 'Kupovina nije uspela. Novac nije naplaćen — pokušajte ponovo.';

  @override
  String get proUnavailable => 'Kupovina trenutno nije dostupna. Proverite da li je Google Play instaliran i da li ste prijavljeni, pa pokušajte ponovo.';

  @override
  String get proLegal =>
      'Pretplata se automatski obnavlja po prikazanoj ceni dok je ne otkažete. Otkazati možete bilo kad u Google Play → Plaćanja i pretplate, najkasnije 24 sata pre obnove. Besplatna proba prelazi u plaćenu godišnju pretplatu ako je ne otkažete pre isteka.';

  @override
  String get proLegalLifetime => 'Jednokratna kupovina: bez pretplate i bez obnavljanja. Pro je aktivan na svakom uređaju prijavljenom na isti Google nalog.';

  @override
  String get proDevSimulate => 'Simuliraj Pro (razvojna verzija)';

  @override
  String get proWelcome => 'Dobro došli u Bilans Pro';

  @override
  String get proWelcomeBody => 'Sve je otključano. Hvala što podržavate nezavisnu aplikaciju.';

  @override
  String get settingsPreferences => 'Podešavanja';

  @override
  String get settingsTheme => 'Izgled';

  @override
  String get settingsThemeSystem => 'Sistemski';

  @override
  String get settingsThemeLight => 'Svetli';

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
  String get settingsImportInvalid => 'Ta datoteka nije Bilans rezervna kopija.';

  @override
  String get settingsImportTitle => 'Vratiti ovu rezervnu kopiju?';

  @override
  String get settingsImportBody => 'Sve u aplikaciji biće zamenjeno sadržajem kopije — fakture, podaci o firmi, tim i sačuvani obračuni.';

  @override
  String get settingsImportAction => 'Vrati';

  @override
  String get settingsImported => 'Rezervna kopija je vraćena';

  @override
  String get settingsDeleteAll => 'Obriši sve podatke';

  @override
  String get settingsDeleteTitle => 'Obrisati sve podatke?';

  @override
  String get settingsDeleteBody =>
      'Fakture, podaci o firmi, tim, sačuvani obračuni i podešavanja biće uklonjeni sa ovog telefona. Ako vam mogu zatrebati, prvo izvezite rezervnu kopiju. Kupovina paketa Pro ostaje.';

  @override
  String get settingsDeleteAction => 'Obriši sve';

  @override
  String get settingsDataNote =>
      'Bilans nema naloge ni servere: vaši podaci postoje samo na ovom telefonu. Izvezite rezervnu kopiju da ih prenesete na novi telefon.';

  @override
  String get settingsAbout => 'O aplikaciji';

  @override
  String get settingsRate => 'Ocenite Bilans na Google Play-u';

  @override
  String get settingsContact => 'Kontakt';

  @override
  String get settingsPrivacy => 'Politika privatnosti';

  @override
  String get settingsTerms => 'Uslovi korišćenja';

  @override
  String get settingsLicenses => 'Licence otvorenog koda';

  @override
  String get settingsDisclaimer => 'Obračuni su informativni i ne zamenjuju stručni poreski, pravni ili finansijski savet.';

  @override
  String get settingsProActive => 'Bilans Pro je aktivan';

  @override
  String get settingsManageSubscription => 'Upravljaj pretplatom';

  @override
  String get settingsProPitch => 'Sve zemlje, trošak tima, neograničene fakture, PDF izveštaji i još mnogo toga.';

  @override
  String get settingsSeePlans => 'Pogledaj pakete';

  @override
  String get proIncluded => 'Uključeno u Pro';

  @override
  String proSummaryTrial(int days, String price, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana besplatno, zatim $price $period. Otkažite bilo kad.',
      few: '$days dana besplatno, zatim $price $period. Otkažite bilo kad.',
      one: '$days dan besplatno, zatim $price $period. Otkažite bilo kad.',
    );
    return '$_temp0';
  }

  @override
  String proSummary(String price, String period) {
    return '$price $period, automatska obnova. Otkažite bilo kad.';
  }

  @override
  String proSummaryLifetime(String price) {
    return 'Jednokratno plaćanje od $price. Bez pretplate.';
  }
}
