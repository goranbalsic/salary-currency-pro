// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appName => 'Bilans';

  @override
  String get appTagline => 'Финансов калкулатор';

  @override
  String get navHome => 'Начало';

  @override
  String get navPayroll => 'Заплата';

  @override
  String get navCredit => 'Кредити';

  @override
  String get navFx => 'Курсове';

  @override
  String get navBusiness => 'Бизнес';

  @override
  String get actionSave => 'Запази';

  @override
  String get actionShare => 'Сподели';

  @override
  String get actionDelete => 'Изтрий';

  @override
  String get actionCancel => 'Отказ';

  @override
  String get actionClose => 'Затвори';

  @override
  String get actionDone => 'Готово';

  @override
  String get actionRetry => 'Опитай отново';

  @override
  String get actionEdit => 'Редактирай';

  @override
  String get actionContinue => 'Продължи';

  @override
  String get actionRemove => 'Премахни';

  @override
  String get actionUndo => 'Отмени';

  @override
  String get actionDownloadPdf => 'Изтегли PDF';

  @override
  String get actionRename => 'Преименувай';

  @override
  String get actionClear => 'Изчисти';

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
      other: '$count месеца',
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
  String get commonOptional => 'по избор';

  @override
  String get commonSearch => 'Търсене';

  @override
  String get commonToday => 'Днес';

  @override
  String get snackSaved => 'Запазено';

  @override
  String get snackDeleted => 'Изтрито';

  @override
  String get errorGeneric => 'Нещо се обърка. Опитайте отново.';

  @override
  String get errorShare => 'Менюто за споделяне не можа да се отвори.';

  @override
  String get errorOpenLink => 'Връзката не можа да се отвори.';

  @override
  String proFeatureTitle(String feature) {
    return '$feature е част от Bilans Pro';
  }

  @override
  String get countryRS => 'Сърбия';

  @override
  String get countryHR => 'Хърватия';

  @override
  String get countryBA => 'Босна и Херцеговина';

  @override
  String get countryME => 'Черна гора';

  @override
  String get countryMK => 'Северна Македония';

  @override
  String get countrySI => 'Словения';

  @override
  String get countryBG => 'България';

  @override
  String get countryRO => 'Румъния';

  @override
  String get systemFbih => 'Федерация на БиХ';

  @override
  String get systemRepublikaSrpska => 'Република Сръбска';

  @override
  String get curEUR => 'Евро';

  @override
  String get curUSD => 'Щатски долар';

  @override
  String get curCHF => 'Швейцарски франк';

  @override
  String get curGBP => 'Британска лира';

  @override
  String get curRSD => 'Сръбски динар';

  @override
  String get curBAM => 'Конвертируема марка';

  @override
  String get curMKD => 'Македонски денар';

  @override
  String get curRON => 'Румънска лея';

  @override
  String get curHUF => 'Унгарски форинт';

  @override
  String get curCZK => 'Чешка крона';

  @override
  String get curPLN => 'Полска злота';

  @override
  String get curSEK => 'Шведска крона';

  @override
  String get curNOK => 'Норвежка крона';

  @override
  String get curDKK => 'Датска крона';

  @override
  String get curJPY => 'Японска йена';

  @override
  String get curCNY => 'Китайски юан';

  @override
  String get curCAD => 'Канадски долар';

  @override
  String get curAUD => 'Австралийски долар';

  @override
  String get curTRY => 'Турска лира';

  @override
  String get curRUB => 'Руска рубла';

  @override
  String get formFixErrors => 'Поправете отбелязаните полета.';

  @override
  String get discardTitle => 'Да се отхвърлят ли промените?';

  @override
  String get discardBody => 'Промените не са запазени.';

  @override
  String get discardKeep => 'Продължи редакцията';

  @override
  String get discardAction => 'Отхвърли';

  @override
  String get commonMore => 'Още опции';

  @override
  String get errorPdf =>
      'PDF файлът не можа да бъде създаден. Опитайте отново.';

  @override
  String get pdfLanguageTitle => 'Език на фактурата';

  @override
  String pdfLanguageBoth(String language) {
    return '$language + английски';
  }

  @override
  String get onbHeadline => 'Числа, на които можете да разчитате.';

  @override
  String get onbBody =>
      'Заплати, кредити, официални валутни курсове и фактури — изчислени по правилата на вашата държава. Без регистрация, без проследяване.';

  @override
  String get onbCountry => 'Вашата държава';

  @override
  String get onbBihEntities => 'Федерация на БиХ и Република Сръбска';

  @override
  String get onbLanguage => 'Език на приложението';

  @override
  String get onbLanguageDevice => 'Езикът на устройството';

  @override
  String get onbPrivacy => 'Данните ви остават на този телефон.';

  @override
  String get homeSearchHint => 'Търсене на калкулатори';

  @override
  String get homeSettings => 'Настройки';

  @override
  String get homeRatesTitle => 'Курсове днес';

  @override
  String homeRatesNbs(String date) {
    return 'Среден курс на НБС · $date';
  }

  @override
  String homeRatesEcb(String date) {
    return 'Референтен курс на ЕЦБ · $date';
  }

  @override
  String get homeRatesEmpty =>
      'Днешните официални курсове ще се появят тук, когато сте онлайн.';

  @override
  String get homeRecent => 'Последни';

  @override
  String get homeSeeAll => 'Виж всички';

  @override
  String get homeSectionPayroll => 'Заплата';

  @override
  String get homeSectionCredit => 'Кредити и спестявания';

  @override
  String get homeSectionFx => 'Валутни курсове';

  @override
  String get homeSectionBusiness => 'Бизнес';

  @override
  String homeNoResults(String query) {
    return 'Няма калкулатор, който да отговаря на „$query“.';
  }

  @override
  String get toolPayroll => 'Брутна и нетна заплата';

  @override
  String get toolPayrollDesc => 'Заплати по 9 данъчни системи';

  @override
  String get toolTeam => 'Разходи за екипа';

  @override
  String get toolTeamDesc => 'Месечен и годишен разход за заплати';

  @override
  String get toolCompare => 'Сравнение на държави';

  @override
  String get toolCompareDesc => 'Една и съща заплата в 9 системи';

  @override
  String get toolLoan => 'Кредит';

  @override
  String get toolLoanDesc => 'Вноска, ГПР и погасителен план';

  @override
  String get toolDeposit => 'Срочен депозит';

  @override
  String get toolDepositDesc => 'Лихва и данък върху лихвата';

  @override
  String get toolLoanCompare => 'Сравнение на кредити';

  @override
  String get toolLoanCompareDesc => 'До три оферти, подредени по ГПР';

  @override
  String get toolPrepay => 'Предсрочно погасяване';

  @override
  String get toolPrepayDesc => 'Колко лихва спестявате';

  @override
  String get toolConverter => 'Валутен конвертор';

  @override
  String get toolConverterDesc => 'Официални курсове на НБС и ЕЦБ';

  @override
  String get toolRateHistory => 'История на курса';

  @override
  String get toolRateHistoryDesc => '30, 90 и 365 дни';

  @override
  String get toolInvoices => 'Фактури';

  @override
  String get toolInvoicesDescRs => 'PDF с QR код NBS IPS';

  @override
  String get toolInvoicesDesc => 'Професионални фактури в PDF';

  @override
  String get toolPausal => 'Лимити за паушал';

  @override
  String get toolPausalDesc => '6 и 8 милиона динара, в реално време';

  @override
  String get toolVat => 'ДДС';

  @override
  String get toolVatDesc => 'Добавяне или изваждане на ДДС';

  @override
  String get toolMargin => 'Марж и надценка';

  @override
  String get toolMarginDesc => 'Себестойност, цена и отстъпка';

  @override
  String get toolBreakEven => 'Точка на рентабилност';

  @override
  String get toolBreakEvenDesc => 'Колко трябва да продадете';

  @override
  String get toolInvestment => 'Инвестиция';

  @override
  String get toolInvestmentDesc => 'NPV, IRR и срок на откупуване';

  @override
  String recentPayroll(String country) {
    return 'Заплата · $country';
  }

  @override
  String recentFromGross(String amount) {
    return 'нето от $amount бруто';
  }

  @override
  String recentFromNet(String amount) {
    return 'бруто за $amount нето';
  }

  @override
  String recentFromCost(String amount) {
    return 'бруто в рамките на бюджет $amount';
  }

  @override
  String recentLoan(String term) {
    return 'Кредит · $term';
  }

  @override
  String recentLoanSub(String eir) {
    return 'вноска · ГПР $eir';
  }

  @override
  String recentDeposit(String term) {
    return 'Депозит · $term';
  }

  @override
  String recentDepositSub(String rate) {
    return 'на падежа · $rate';
  }

  @override
  String recentVatAdd(String amount, String rate) {
    return '$amount + ДДС $rate';
  }

  @override
  String recentVatExtract(String amount, String rate) {
    return 'без ДДС от $amount при $rate';
  }

  @override
  String recentMarginSub(String margin) {
    return 'цена с ДДС · марж $margin';
  }

  @override
  String recentBreakEvenSub(String amount) {
    return 'месечно · приход $amount';
  }

  @override
  String recentInvestmentSub(String irr) {
    return 'NPV · IRR $irr';
  }

  @override
  String get historyTitle => 'Запазени и последни';

  @override
  String get historySaved => 'Запазени';

  @override
  String get historySavedEmpty =>
      'Докоснете „Запази“ при всеки резултат, за да го пазите тук с име.';

  @override
  String get historyRecentEmpty =>
      'Завършените изчисления се появяват тук автоматично.';

  @override
  String get historyClearTitle =>
      'Да се изчисти ли списъкът с последни изчисления?';

  @override
  String get payTitle => 'Калкулатор на заплата';

  @override
  String get payModeGross => 'Бруто → нето';

  @override
  String get payModeNet => 'Нето → бруто';

  @override
  String get payModeCost => 'Общ разход';

  @override
  String get payModeSemantic => 'Посока на изчислението';

  @override
  String get payInputGross => 'Брутна заплата · месечно';

  @override
  String get payInputNet => 'Желана нетна заплата · месечно';

  @override
  String get payInputCost => 'Бюджет на работодателя · месечно';

  @override
  String payHelperRsMinBase(String amount) {
    return 'Минимална осигурителна основа: $amount';
  }

  @override
  String get payHelperNet => 'Сумата, която служителят получава';

  @override
  String get payHelperCost =>
      'Брутна заплата плюс всички вноски за сметка на работодателя';

  @override
  String get payResultNet => 'Нетна заплата';

  @override
  String get payResultGross => 'Необходима брутна заплата';

  @override
  String get payResultGrossBudget => 'Брутна заплата в рамките на бюджета';

  @override
  String payShareOfGross(String percent) {
    return '$percent от брутната заплата';
  }

  @override
  String payNetLine(String amount) {
    return 'Нетна заплата: $amount';
  }

  @override
  String payTotalCostLine(String amount) {
    return 'Общ разход за работодателя: $amount';
  }

  @override
  String payApprox(String amount) {
    return '≈ $amount';
  }

  @override
  String get payComposition => 'Къде отива общият разход на работодателя';

  @override
  String get segNet => 'Нетна заплата';

  @override
  String get segTax => 'Данък';

  @override
  String get segEmployee => 'Вноски за сметка на служителя';

  @override
  String get segEmployer => 'Вноски за сметка на работодателя';

  @override
  String get payBreakdown => 'Разбивка';

  @override
  String get payAnnualToggle => 'Годишно ×12';

  @override
  String get payEmployee => 'Служител';

  @override
  String get payEmployer => 'Работодател';

  @override
  String get payGross => 'Брутна заплата';

  @override
  String get payNetTotal => 'Нетна заплата';

  @override
  String get payTotalCost => 'Общ разход за заплатата';

  @override
  String get payNonTaxable => 'Необлагаема сума';

  @override
  String get payPersonalAllowance => 'Личен необлагаем минимум';

  @override
  String get payGeneralAllowance => 'Общо данъчно облекчение';

  @override
  String get payPersonalExemption => 'Лично освобождаване';

  @override
  String get payPersonalDeduction => 'Лично приспадане';

  @override
  String get payTaxBase => 'Данъчна основа';

  @override
  String get payIncomeTax => 'Данък върху доходите';

  @override
  String payTaxOn(String rate, String amount) {
    return '$rate върху $amount';
  }

  @override
  String get paySurtax => 'Общинска добавка';

  @override
  String payOnBase(String amount) {
    return 'върху $amount';
  }

  @override
  String get payFixedMonthly => 'фиксирано месечно';

  @override
  String payWedge(String percent) {
    return 'Данъчен клин $percent';
  }

  @override
  String payRulesFrom(String date) {
    return 'Правила от $date';
  }

  @override
  String get paySources => 'Източници';

  @override
  String payDisclaimer(String date) {
    return 'Ориентировъчно изчисление по правилата, действащи от $date. Не замества официалното изчисление на заплатата.';
  }

  @override
  String get payAnnualNote =>
      'Годишните суми са 12 × месечните; годишното данъчно изравняване може да се различава.';

  @override
  String payNoteMinBase(String amount) {
    return 'Вноските се изчисляват върху минималната основа от $amount.';
  }

  @override
  String payNoteMaxBase(String amount) {
    return 'Вноските спират при максималната основа от $amount.';
  }

  @override
  String payNoteRelief(String amount) {
    return 'Облекчението за ниски заплати намалява основата за пенсионната вноска до $amount.';
  }

  @override
  String get payNoteNonPositive =>
      'Задължителните удръжки надвишават тази заплата.';

  @override
  String get payEmpty =>
      'Въведете сума, за да видите пълната разбивка — вноски, данък и общия разход на работодателя.';

  @override
  String get payErrorTooLarge => 'Сумата е твърде голяма за изчисление.';

  @override
  String get paySystemTitle => 'Данъчна система';

  @override
  String get paySystemProHint =>
      'Вашата държава е безплатна. Другите държави са част от Pro.';

  @override
  String get payOptions => 'Опции';

  @override
  String payOptionsHrSummary(String lower, String higher, int children) {
    return 'Данък $lower / $higher · деца $children';
  }

  @override
  String payOptionsMeSummary(String rate) {
    return 'Добавка $rate';
  }

  @override
  String payOptionsRoSummary(int count) {
    return 'Издържани лица $count';
  }

  @override
  String get payOptionsRoMinWage => 'облекчение за минимална заплата';

  @override
  String payOptionsFbihSummary(String state) {
    return 'Фонд за хора с увреждания $state';
  }

  @override
  String get payOn => 'включен';

  @override
  String get payOff => 'изключен';

  @override
  String get payHrRates => 'Общински ставки на данъка върху доходите';

  @override
  String get payHrLower => 'По-ниска ставка';

  @override
  String get payHrHigher => 'По-висока ставка';

  @override
  String get payHrRatesHint =>
      'Определят се от вашия град или община: 15–23% и 25–33%. Ако няма решение, се прилагат 20% и 30%.';

  @override
  String payHrRateError(String lowRange, String highRange) {
    return 'По-ниска ставка $lowRange, по-висока ставка $highRange';
  }

  @override
  String get payChildren => 'Деца';

  @override
  String get payDependents => 'Други издържани лица';

  @override
  String get payRoDependents => 'Издържани лица';

  @override
  String get payRoMinWage => 'Облекчение за минимална заплата';

  @override
  String get payRoMinWageHint =>
      '200 леи са освободени за служители на национална минимална заплата.';

  @override
  String get payMeSurtax => 'Ставка на добавката';

  @override
  String get payMeSurtaxHint =>
      '13% в повечето общини, 15% в Подгорица и Цетине.';

  @override
  String get payFbihDisability => 'Фонд за заетост на хора с увреждания 0,5%';

  @override
  String get payFbihDisabilityHint =>
      'Плаща се от фирми, които не наемат изисквания дял хора с увреждания.';

  @override
  String get itemPension => 'Пенсионно и инвалидно осигуряване';

  @override
  String get itemHealth => 'Здравно осигуряване';

  @override
  String get itemUnemployment => 'Осигуряване за безработица';

  @override
  String get itemChildProtection => 'Закрила на детето';

  @override
  String get itemWorkInjury => 'Трудова злополука';

  @override
  String get itemLaborFund => 'Фонд на труда';

  @override
  String get itemChamber => 'Стопанска камара';

  @override
  String get itemPillar1 => 'Пенсионно осигуряване, първи стълб';

  @override
  String get itemPillar2 => 'Пенсионно осигуряване, втори стълб';

  @override
  String get itemLongTermCare => 'Дългосрочни грижи';

  @override
  String get itemParental => 'Родителска закрила';

  @override
  String get itemCompulsoryHealth => 'Задължителна здравна вноска';

  @override
  String get itemWaterFee => 'Обща такса за води';

  @override
  String get itemDisasterFee => 'Такса за защита от бедствия';

  @override
  String get itemDisabilityFund => 'Фонд за заетост на хора с увреждания';

  @override
  String get itemSickness => 'Общо заболяване и майчинство';

  @override
  String get itemSupplementaryPension =>
      'Допълнително пенсионно осигуряване (УПФ)';

  @override
  String get itemCas => 'CAS (пенсия)';

  @override
  String get itemCass => 'CASS (здраве)';

  @override
  String get itemCam => 'CAM (осигуряване за труд)';

  @override
  String get saveTitle => 'Запазване на изчислението';

  @override
  String get saveNameLabel => 'Име';

  @override
  String get saveNameHint => 'напр. Оферта за нов служител';

  @override
  String saveLimit(int count) {
    return 'Безплатният план пази до $count запазени изчисления.';
  }

  @override
  String get shareFooter => 'Изчислено с Bilans';

  @override
  String get sourcesTitle => 'Източници и допускания';

  @override
  String get teamTitle => 'Разходи за екипа';

  @override
  String get teamAdd => 'Добави служител';

  @override
  String get teamEdit => 'Редактиране на служител';

  @override
  String get teamEmptyTitle => 'Планирайте разходите за заплати';

  @override
  String get teamEmpty =>
      'Добавете екипа си — брутната и нетната заплата на всеки човек и общият разход на работодателя, сумирани за месеца и за годината. Можете да комбинирате държави, ако наемате хора в различни държави.';

  @override
  String teamMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count служители',
      one: '$count служител',
    );
    return '$_temp0';
  }

  @override
  String get teamNote =>
      'Всеки служител се изчислява по правилата на своята данъчна система. Годишните суми са 12 × месечните.';

  @override
  String get teamCurrenciesNote =>
      'Общите суми се показват отделно за всяка валута.';

  @override
  String get teamUnnamed => 'Без име';

  @override
  String get teamTotal => 'Общо';

  @override
  String get teamCostShort => 'общ разход';

  @override
  String teamRemoveTitle(String name) {
    return 'Да се премахне ли $name от екипа?';
  }

  @override
  String get teamName => 'Име';

  @override
  String get teamRole => 'Длъжност';

  @override
  String get teamRoleHint => 'напр. Програмист';

  @override
  String get teamAmountError => 'Въведете размера на заплатата.';

  @override
  String get cmpNeedsRates =>
      'За сравнението на държави са нужни днешните валутни курсове. Свържете се с интернет веднъж и те ще бъдат запазени за използване офлайн.';

  @override
  String get cmpRankedByNet => 'Подредени по нетна заплата';

  @override
  String get cmpRankedByCost => 'Подредени по разход за работодателя';

  @override
  String cmpCostLine(String cost, String wedge) {
    return 'Разход за работодателя $cost · данъчен клин $wedge';
  }

  @override
  String cmpGrossLine(String gross, String wedge) {
    return 'Бруто $gross · данъчен клин $wedge';
  }

  @override
  String get cmpTaxesKey => 'Данъци и вноски';

  @override
  String cmpNote(String date) {
    return 'Сумите са превалутирани по официалните курсове от $date. За всяка държава се използват стандартните настройки (без деца, стандартни местни ставки). Данъчният клин е делът от общия разход на работодателя, който отива за данъци и вноски.';
  }

  @override
  String get payWedgeLabel => 'Данъчен клин';

  @override
  String get creditTitle => 'Кредити';

  @override
  String get creditTabLoan => 'Кредит';

  @override
  String get creditTabDeposit => 'Спестявания';

  @override
  String get creditTabCompare => 'Сравнение';

  @override
  String get loanAmount => 'Размер на кредита';

  @override
  String get loanRate => 'Номинален лихвен процент';

  @override
  String get loanTerm => 'Срок';

  @override
  String get loanFee => 'Такса за обработка';

  @override
  String get loanMonthlyFee => 'Месечни такси';

  @override
  String get loanMonthlyFeeHint => 'Сметка, застраховка…';

  @override
  String get loanRepayment => 'Погасяване';

  @override
  String get loanAnnuity => 'Равни вноски';

  @override
  String get loanLinear => 'Равни главници';

  @override
  String get loanMore => 'Още опции';

  @override
  String get loanLess => 'По-малко опции';

  @override
  String get loanCurrency => 'Валута';

  @override
  String get loanInstallment => 'Месечна вноска';

  @override
  String get loanFirstInstallment => 'Първа вноска';

  @override
  String get loanEir => 'ГПР';

  @override
  String get loanTotalInterest => 'Обща лихва';

  @override
  String get loanTotal => 'Обща дължима сума';

  @override
  String loanTotalIncludes(String fees) {
    return 'Включва главница, лихва и такси в размер на $fees.';
  }

  @override
  String get loanEirNote =>
      'ГПР е ефективният годишен процент с всички такси, изчислен по формулата на ЕС за потребителски кредити.';

  @override
  String get loanByYear => 'По години';

  @override
  String get loanPrincipal => 'Главница';

  @override
  String get loanInterest => 'Лихва';

  @override
  String loanYearShort(int n) {
    return '$n г.';
  }

  @override
  String get loanSchedule => 'Погасителен план';

  @override
  String loanScheduleAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пълен план · $count вноски',
      one: 'Пълен план · $count вноска',
    );
    return '$_temp0';
  }

  @override
  String get loanColNo => '№';

  @override
  String get loanColInstallment => 'Вноска';

  @override
  String get loanColInterest => 'Лихва';

  @override
  String get loanColPrincipal => 'Главница';

  @override
  String get loanColBalance => 'Остатък';

  @override
  String get loanPrepayTitle => 'Предсрочно погасяване';

  @override
  String loanPrepayTeaser(
    String amount,
    int month,
    String months,
    String saved,
  ) {
    return 'Ако платите допълнително $amount след вноска $month, кредитът се скъсява с $months и спестявате $saved лихва.';
  }

  @override
  String get loanPrepayCta => 'Изчислете своя сценарий';

  @override
  String get loanErrorPrincipal => 'Въведете размер на кредита.';

  @override
  String get loanErrorRate => 'Въведете лихвен процент между 0 и 100%.';

  @override
  String get loanErrorTerm => 'Срокът трябва да е между 1 и 600 месеца.';

  @override
  String get loanErrorFee => 'Таксите трябва да са по-малки от кредита.';

  @override
  String get prepayTitle => 'Предсрочно погасяване';

  @override
  String prepayIntro(String amount, String rate, String term) {
    return 'Въз основа на текущия ви кредит: $amount при $rate за $term.';
  }

  @override
  String get prepayNoLoan => 'Първо въведете кредит в раздел „Кредити“.';

  @override
  String get prepayAmount => 'Допълнително плащане';

  @override
  String get prepayAfter => 'Плаща се заедно с вноска №';

  @override
  String get prepayMode => 'След плащането';

  @override
  String get prepayShorten => 'По-кратък срок';

  @override
  String get prepayLower => 'По-ниска вноска';

  @override
  String get prepayFee => 'Такса за предсрочно погасяване';

  @override
  String get prepaySaved => 'Спестена лихва';

  @override
  String get prepayNetSaving => 'Нетна икономия след таксата';

  @override
  String get prepayNewTerm => 'Нов срок';

  @override
  String get prepayNewInstallment => 'Нова вноска';

  @override
  String prepayMonthsSaved(String months) {
    return '$months по-рано';
  }

  @override
  String get prepayPaidOff => 'Допълнителното плащане погасява целия остатък.';

  @override
  String get prepayBefore => 'Преди';

  @override
  String get prepayAfterLabel => 'След';

  @override
  String get depAmount => 'Депозит';

  @override
  String get depRate => 'Лихвен процент';

  @override
  String get depTerm => 'Срок';

  @override
  String get depPayout => 'Лихва';

  @override
  String get depAtMaturity => 'На падежа';

  @override
  String get depMonthly => 'Месечно, с капитализация';

  @override
  String get depAnnually => 'Годишно, с капитализация';

  @override
  String get depTax => 'Данък върху лихвата';

  @override
  String get depTaxHintRs =>
      'В Сърбия лихвата по спестявания в динари не се облага, а по спестявания във валута се облага с 15%.';

  @override
  String get depTaxHint =>
      'Въведете данъка върху лихвата, удържан при източника, който важи за вас.';

  @override
  String get depContribution => 'Месечна вноска';

  @override
  String get depFinal => 'На падежа';

  @override
  String get depGrossInterest => 'Лихва преди данък';

  @override
  String get depTaxAmount => 'Данък върху лихвата';

  @override
  String get depNetInterest => 'Нетна лихва';

  @override
  String get depPaidIn => 'Внесено';

  @override
  String depYield(String percent) {
    return 'Нетна доходност $percent годишно';
  }

  @override
  String get depByYear => 'По години';

  @override
  String get depColYear => 'Година';

  @override
  String get depColInterest => 'Нетна лихва';

  @override
  String get depColBalance => 'Салдо';

  @override
  String get depErrorAmount => 'Въведете депозит или месечна вноска.';

  @override
  String get depErrorRate => 'Въведете лихвен процент между 0 и 100%.';

  @override
  String get cmpLoanIntro =>
      'Една и съща сума за всички оферти. Най-изгодна е офертата с най-нисък общ разход.';

  @override
  String cmpLoanOffer(int n) {
    return 'Оферта $n';
  }

  @override
  String get cmpLoanAdd => 'Добави оферта';

  @override
  String get cmpLoanRemove => 'Премахни оферта';

  @override
  String get cmpLoanBest => 'Най-нисък общ разход';

  @override
  String cmpLoanSavesVs(String amount) {
    return 'с $amount по-евтино от най-скъпата оферта';
  }

  @override
  String get depYieldLabel => 'Нетна годишна доходност';

  @override
  String get fxTitle => 'Валутни курсове';

  @override
  String get fxTabConverter => 'Конвертор';

  @override
  String get fxTabList => 'Курсов лист';

  @override
  String fxAmount(String currency) {
    return 'Сума в $currency';
  }

  @override
  String get fxSwap => 'Размени валутите';

  @override
  String fxRateLine(String from, String rate, String to) {
    return '1 $from = $rate $to';
  }

  @override
  String get fxSourceNbsMiddle => 'среден курс на НБС';

  @override
  String get fxSourceNbsBuy => 'курс купува на НБС';

  @override
  String get fxSourceNbsSell => 'курс продава на НБС';

  @override
  String get fxSourceEcb => 'референтен курс на ЕЦБ';

  @override
  String get fxSourceCross => 'кръстосан курс';

  @override
  String get fxKindMiddle => 'Среден';

  @override
  String get fxKindBuy => 'Купува';

  @override
  String get fxKindSell => 'Продава';

  @override
  String get fxKindHint =>
      'Курсовете „купува“ и „продава“ важат за обмяна в динари.';

  @override
  String fxUpdated(String date) {
    return 'Обновено $date';
  }

  @override
  String fxOffline(String date) {
    return 'Офлайн · курсове от $date';
  }

  @override
  String get fxLoading => 'Курсовете се обновяват…';

  @override
  String get fxNoRates =>
      'Все още няма курсове. Свържете се с интернет веднъж, за да изтеглите днешните официални курсове — след това конверторът работи и офлайн.';

  @override
  String get fxUnsupported => 'Няма официален курс за тази двойка валути.';

  @override
  String fxHistoryTitle(String from, String to, int days) {
    return '$from/$to · $days дни';
  }

  @override
  String fxHistoryDays(int days) {
    return '$days д.';
  }

  @override
  String get fxHistoryError => 'Историята не е достъпна офлайн.';

  @override
  String get fxHistoryPro =>
      'Историята на курса за 30, 90 и 365 дни е част от Pro.';

  @override
  String fxHistoryMinMax(String min, String max) {
    return 'мин. $min · макс. $max';
  }

  @override
  String get fxPerUnit => 'За 1 единица валута';

  @override
  String get fxListNbs => 'Курсов лист на НБС';

  @override
  String get fxListEcb => 'Референтни курсове на ЕЦБ за 1 EUR';

  @override
  String get fxColBuy => 'Купува';

  @override
  String get fxColMiddle => 'Среден';

  @override
  String get fxColSell => 'Продава';

  @override
  String get fxColRate => 'Курс';

  @override
  String get fxRefresh => 'Обнови курсовете';

  @override
  String get fxPickFrom => 'От валута';

  @override
  String get fxPickTo => 'Към валута';

  @override
  String get fxSourcesNote =>
      'Официални курсове на Народната банка на Сърбия чрез kurs.resenje.org; референтни курсове на Европейската централна банка чрез Frankfurter. Марката е фиксирана на 1,95583 за едно евро.';

  @override
  String get bizTitle => 'Бизнес';

  @override
  String get bizProfile => 'Данни за фирмата';

  @override
  String get bizInvoices => 'Фактури';

  @override
  String get bizNewInvoice => 'Нова';

  @override
  String get bizInvoicesEmpty =>
      'Все още няма фактури. Създайте професионална фактура за по-малко от минута.';

  @override
  String bizFreeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Остават още $count безплатни фактури',
      one: 'Остава още $count безплатна фактура',
    );
    return '$_temp0';
  }

  @override
  String get bizTools => 'Инструменти';

  @override
  String bizShowAll(int count) {
    return 'Покажи всички ($count)';
  }

  @override
  String bizPausalCard(int year) {
    return 'Паушал · $year';
  }

  @override
  String get statusDraft => 'Чернова';

  @override
  String get statusIssued => 'Очаква плащане';

  @override
  String get statusPaid => 'Платена';

  @override
  String get statusCancelled => 'Анулирана';

  @override
  String get statusOverdue => 'Просрочена';

  @override
  String get invNew => 'Нова фактура';

  @override
  String get invEdit => 'Редактиране на фактура';

  @override
  String get invNumber => 'Номер на фактурата';

  @override
  String get invIssueDate => 'Дата на издаване';

  @override
  String get invServiceDate => 'Дата на данъчното събитие';

  @override
  String get invDueDate => 'Срок за плащане';

  @override
  String get invPlace => 'Място на издаване';

  @override
  String get invClient => 'Клиент';

  @override
  String get invClientName => 'Име на клиента';

  @override
  String get invClientAddress => 'Адрес';

  @override
  String get invClientCity => 'Пощенски код и град';

  @override
  String get invClientCountry => 'Държава';

  @override
  String get invClientTaxId => 'Данъчен номер (ЕИК / ПИБ / ДДС №)';

  @override
  String get invClientRegNo => 'Регистрационен номер';

  @override
  String get invClientEmail => 'Имейл';

  @override
  String get invRecentClients => 'Последни клиенти';

  @override
  String get invCurrency => 'Валута';

  @override
  String get invItems => 'Позиции';

  @override
  String get invItemDescription => 'Описание';

  @override
  String get invItemQty => 'Количество';

  @override
  String get invItemUnit => 'Мярка';

  @override
  String get invItemUnitHint => 'бр., ч, ден…';

  @override
  String get invItemPrice => 'Единична цена';

  @override
  String get invItemVat => 'ДДС %';

  @override
  String get invAddItem => 'Добави позиция';

  @override
  String get invRemoveItem => 'Премахни позицията';

  @override
  String get invNote => 'Бележка';

  @override
  String get invReference => 'Референция за плащане';

  @override
  String get invReferenceHint => 'Модел и номер, напр. 97 1234';

  @override
  String get invSubtotal => 'Данъчна основа';

  @override
  String get invVat => 'ДДС';

  @override
  String get invTotal => 'Общо';

  @override
  String get invTotalDue => 'Сума за плащане';

  @override
  String get invTotalRsd => 'Равностойност в RSD';

  @override
  String invRateLine(String rate, String date) {
    return 'Среден курс на НБС $rate към $date';
  }

  @override
  String get invRateFetching => 'Курсът на НБС се изтегля…';

  @override
  String get invRateUnavailable =>
      'Курсът на НБС за тази дата все още не е публикуван.';

  @override
  String get invRateRetry => 'Изтегли курса';

  @override
  String get invSaveDraft => 'Запази като чернова';

  @override
  String get invIssue => 'Издай фактурата';

  @override
  String get invSave => 'Запази промените';

  @override
  String get invMarkPaid => 'Отбележи като платена';

  @override
  String get invMarkUnpaid => 'Отбележи като неплатена';

  @override
  String get invCancelInvoice => 'Анулирай фактурата';

  @override
  String get invDelete => 'Изтрий фактурата';

  @override
  String invDeleteConfirm(String number) {
    return 'Да се изтрие ли фактура $number? Това действие е необратимо.';
  }

  @override
  String get invDuplicate => 'Дублирай';

  @override
  String get invProfileMissing =>
      'Първо въведете данните за фирмата — те се появяват на всяка фактура.';

  @override
  String get invNotInVat => 'Издателят не е регистриран по ДДС.';

  @override
  String get invValidWithoutStamp => 'Фактурата е валидна без печат и подпис.';

  @override
  String get invQrCaption => 'Сканирай и плати (NBS IPS)';

  @override
  String get invQrHint =>
      'Клиентът сканира QR кода в приложението на своята банка — сумата, сметката и референцията се попълват автоматично.';

  @override
  String invQrMissing(String reason) {
    return 'Няма QR код за плащане: $reason';
  }

  @override
  String get invQrReasonAccount =>
      'въведете валидна сръбска банкова сметка в данните за фирмата';

  @override
  String get invQrReasonOther =>
      'проверете името на фирмата и референцията за плащане';

  @override
  String get invDocTitle => 'Фактура';

  @override
  String get invSeller => 'Доставчик';

  @override
  String get invBuyer => 'Получател';

  @override
  String invPaidOn(String date) {
    return 'Платена на $date';
  }

  @override
  String invDueOn(String date) {
    return 'Падеж $date';
  }

  @override
  String get invErrorClient => 'Въведете името на клиента.';

  @override
  String get invErrorItems => 'Добавете поне една позиция с описание и цена.';

  @override
  String get invErrorNumber => 'Въведете номер на фактурата.';

  @override
  String get invErrorDue =>
      'Срокът за плащане не може да е преди датата на издаване.';

  @override
  String invErrorNumberTaken(String number) {
    return 'Фактура $number вече съществува.';
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
  String get invReferenceLabel => 'Референция';

  @override
  String get invPlaceLabel => 'Място';

  @override
  String get invColItem => 'Позиция';

  @override
  String get invColQty => 'Кол.';

  @override
  String get invColPrice => 'Цена';

  @override
  String get invColAmount => 'Стойност';

  @override
  String get profTitle => 'Данни за фирмата';

  @override
  String get profIntro =>
      'Отпечатват се на фактурите и, ако желаете, в PDF отчетите.';

  @override
  String get profName => 'Име на фирмата';

  @override
  String get profAddress => 'Улица и номер';

  @override
  String get profCity => 'Пощенски код и град';

  @override
  String get profCountry => 'Държава';

  @override
  String get profTaxId => 'Данъчен номер (ПИБ)';

  @override
  String get profRegNo => 'Регистрационен номер (МБ)';

  @override
  String get profAccount => 'Банкова сметка';

  @override
  String get profAccountHint =>
      'Сръбска сметка (160-0000000000000-00) или IBAN';

  @override
  String get profBank => 'Банка';

  @override
  String get profEmail => 'Имейл';

  @override
  String get profPhone => 'Телефон';

  @override
  String get profVat => 'Регистрация по ДДС';

  @override
  String get profVatHint =>
      'Добавя ДДС във фактурите. Когато е изключено, във фактурите пише, че не сте регистрирани по ДДС.';

  @override
  String get profPaymentCode => 'Код на плащането за QR кода';

  @override
  String get profPaymentCodeHint => '221 за плащане на стоки и услуги';

  @override
  String get profDueDays => 'Срок за плащане по подразбиране';

  @override
  String get profDueDaysSuffix => 'дни';

  @override
  String get profCurrency => 'Валута на фактурите по подразбиране';

  @override
  String get profNote => 'Бележка по подразбиране във фактурите';

  @override
  String get profShowOnReports => 'Показвай данните за фирмата в PDF отчетите';

  @override
  String get profInvalidPib =>
      'Контролната цифра на ПИБ не съвпада — проверете номера.';

  @override
  String get profInvalidMb =>
      'Контролната цифра на регистрационния номер не съвпада.';

  @override
  String get profInvalidAccount =>
      'Контролните цифри на номера на сметката не съвпадат.';

  @override
  String get profSaved => 'Данните за фирмата са запазени';

  @override
  String get pausalTitle => 'Лимити за паушал';

  @override
  String get pausalIntro =>
      'Предприемачите на паушално облагане в Сърбия губят този режим при приходи над 6 000 000 RSD за календарната година и трябва да се регистрират по ДДС при над 8 000 000 RSD за които и да е 12 месеца.';

  @override
  String get pausalAnnual => 'Лимит за паушал, календарна година';

  @override
  String get pausalVat => 'Лимит за ДДС, последните 12 месеца';

  @override
  String pausalOf(String amount) {
    return 'от $amount';
  }

  @override
  String pausalLeft(String amount) {
    return 'Остават $amount';
  }

  @override
  String pausalProjection(String amount) {
    return 'С това темпо ще фактурирате около $amount до 31 декември.';
  }

  @override
  String pausalProjectionOver(String amount) {
    return 'С това темпо ще надхвърлите лимита за паушал преди края на годината (около $amount).';
  }

  @override
  String get pausalWarn => 'Използвали сте над 80% от този лимит.';

  @override
  String get pausalOver =>
      'Лимитът е надхвърлен — свържете се със своя счетоводител.';

  @override
  String pausalMissingRate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фактури във валута нямат курс на НБС и не са включени.',
      one: '$count фактура във валута няма курс на НБС и не е включена.',
    );
    return '$_temp0';
  }

  @override
  String get pausalSourceInvoices =>
      'Изчислява се от издадените и платените фактури (по дата на данъчното събитие) и от приходите, които добавите по-долу.';

  @override
  String get pausalManual => 'Приходи извън приложението';

  @override
  String get pausalManualEmpty =>
      'Добавете фактурите, издадени другаде през тази година, за да са пълни сумите.';

  @override
  String get pausalManualAdd => 'Добави приход';

  @override
  String get pausalManualDate => 'Дата';

  @override
  String get pausalManualAmount => 'Сума в RSD';

  @override
  String get pausalManualNote => 'Бележка';

  @override
  String get vatTitle => 'Калкулатор за ДДС';

  @override
  String get vatAdd => 'Добави ДДС';

  @override
  String get vatExtract => 'Извади ДДС';

  @override
  String get vatAmountNet => 'Сума без ДДС';

  @override
  String get vatAmountGross => 'Сума с ДДС';

  @override
  String get vatRate => 'Ставка на ДДС';

  @override
  String get vatOther => 'Друга';

  @override
  String get vatNet => 'Без ДДС';

  @override
  String get vatVat => 'ДДС';

  @override
  String get vatGross => 'С ДДС';

  @override
  String get mrgTitle => 'Марж и надценка';

  @override
  String get mrgFromPrice => 'Себестойност и цена';

  @override
  String get mrgFromMarkup => 'Надценка';

  @override
  String get mrgFromMargin => 'Марж';

  @override
  String get mrgCost => 'Себестойност';

  @override
  String get mrgPrice => 'Продажна цена (без ДДС)';

  @override
  String get mrgMarkup => 'Надценка';

  @override
  String get mrgMargin => 'Марж';

  @override
  String get mrgDiscount => 'Отстъпка';

  @override
  String get mrgVat => 'ДДС';

  @override
  String get mrgProfit => 'Брутна печалба';

  @override
  String get mrgPriceAfterDiscount => 'Цена след отстъпка';

  @override
  String get mrgPriceWithVat => 'Цена с ДДС';

  @override
  String get mrgMarginHint =>
      'Маржът е печалбата като дял от продажната цена; надценката е печалбата като дял от себестойността.';

  @override
  String get mrgImpossible => 'Марж от 100% или повече не е възможен.';

  @override
  String get beTitle => 'Точка на рентабилност';

  @override
  String get beFixed => 'Постоянни разходи на месец';

  @override
  String get bePrice => 'Цена за единица';

  @override
  String get beVariable => 'Променлив разход за единица';

  @override
  String get beTarget => 'Целева печалба на месец';

  @override
  String get beUnits => 'Необходими продажби на месец';

  @override
  String beUnitsValue(int count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted броя',
      one: '$formatted брой',
    );
    return '$_temp0';
  }

  @override
  String get beRevenue => 'Необходим приход';

  @override
  String get beContribution => 'Маржинален доход';

  @override
  String get beImpossible =>
      'Цената трябва да е по-висока от променливия разход за единица.';

  @override
  String get invsTitle => 'Инвестиционен анализ';

  @override
  String get invsInitial => 'Първоначална инвестиция';

  @override
  String get invsRate => 'Дисконтов процент';

  @override
  String get invsFlows => 'Нетен паричен поток по години';

  @override
  String invsYear(int n) {
    return 'Година $n';
  }

  @override
  String get invsAddYear => 'Добави година';

  @override
  String get invsRemoveYear => 'Премахни последната година';

  @override
  String get invsNpv => 'Нетна настояща стойност (NPV)';

  @override
  String get invsIrr => 'Вътрешна норма на възвръщаемост (IRR)';

  @override
  String get invsPayback => 'Срок на откупуване';

  @override
  String get invsDiscountedPayback => 'Дисконтиран срок на откупуване';

  @override
  String get invsPi => 'Индекс на рентабилност';

  @override
  String invsYears(String years) {
    return '$years г.';
  }

  @override
  String get invsNever => 'Не в рамките на тези години';

  @override
  String get invsNoIrr => 'Няма IRR за тези парични потоци';

  @override
  String invsGood(String rate) {
    return 'Създава стойност при дисконтов процент $rate.';
  }

  @override
  String invsBad(String rate) {
    return 'Унищожава стойност при дисконтов процент $rate.';
  }

  @override
  String get profSectionBusiness => 'Фирма';

  @override
  String get profSectionPayment => 'Плащане';

  @override
  String get profSectionContact => 'Контакт';

  @override
  String get profSectionInvoices => 'Настройки на фактурите';

  @override
  String get profTaxIdGeneric => 'Данъчен номер';

  @override
  String get profRegNoGeneric => 'Регистрационен номер';

  @override
  String get profNameRequired => 'Въведете името на фирмата.';

  @override
  String get profPibLength => 'ПИБ се състои от 9 цифри.';

  @override
  String get profMbLength => 'Регистрационният номер се състои от 8 цифри.';

  @override
  String get profInvalidAccountShape =>
      'Въведете сръбска сметка (160-0000000000000-00) или IBAN.';

  @override
  String get profInvalidEmail => 'Проверете имейл адреса.';

  @override
  String get profInvalidPaymentCode =>
      'Кодът на плащането е трицифрен, напр. 221.';

  @override
  String get profPrivacy =>
      'Съхраняват се само на този телефон и се включват в резервните копия, които експортирате.';

  @override
  String get profIban => 'IBAN за плащания от чужбина';

  @override
  String get profIbanHint =>
      'Отпечатва се на фактурите във валута. Оставете празно, за да се използва сметката по-горе във формат IBAN.';

  @override
  String get profSwift => 'SWIFT / BIC';

  @override
  String get profInvalidIban =>
      'Проверете IBAN — контролните цифри не съвпадат.';

  @override
  String get profInvalidSwift => 'Кодът SWIFT/BIC е от 8 или 11 знака.';

  @override
  String get invIban => 'IBAN';

  @override
  String get invSwift => 'SWIFT/BIC';

  @override
  String get invBank => 'Банка';

  @override
  String get invSefNote =>
      'Фактурите към сръбския публичен сектор — а за регистрираните по ДДС и към сръбски фирми — трябва да минат и през SEF (e-Faktura). Фактурите от Bilans са подходящи за клиенти в чужбина, физически лица и за вашата отчетност.';

  @override
  String get invRateOffline =>
      'НБС не е достъпна. Проверете връзката — можете да запазите сега и да изтеглите курса по-късно.';

  @override
  String get invMarkedPaid => 'Отбелязана като платена';

  @override
  String get invMarkedUnpaid => 'Отбелязана като неплатена';

  @override
  String get invIssued => 'Фактурата е издадена';

  @override
  String get invCancelled => 'Фактурата е анулирана';

  @override
  String get invCompleteFirst =>
      'Преди издаване добавете клиент и поне една позиция.';

  @override
  String invCancelConfirm(String number) {
    return 'Да се анулира ли фактура $number?';
  }

  @override
  String get invCancelBody =>
      'Остава в списъка, отбелязана като анулирана, и вече не се брои като приход.';

  @override
  String get invRateMissingNote =>
      'Все още няма курс на НБС — фактурата не се включва в лимитите за паушал, докато не получи курс.';

  @override
  String pausalMonthlyRoom(String amount) {
    return 'За да останете под лимита, до края на годината фактурирайте не повече от около $amount на месец.';
  }

  @override
  String pausalByMonth(int year) {
    return 'Приходи по месеци, $year';
  }

  @override
  String get pausalFromInvoices => 'Фактури';

  @override
  String get pausalDisclaimer =>
      'Приходите се отчитат по дата на данъчното събитие. Фактурите във валута се преизчисляват по средния курс на НБС към датата на издаване. Проверете окончателните суми със своя счетоводител.';

  @override
  String get pausalRemoveTitle => 'Да се премахне ли този приход?';

  @override
  String get pausalManualAmountError => 'Въведете сума.';

  @override
  String get invsFilterAll => 'Всички';

  @override
  String get invsFilterDrafts => 'Чернови';

  @override
  String get invsOutstanding => 'Очакват плащане';

  @override
  String get invsSearchHint => 'Търсене по клиент или номер';

  @override
  String get invsNoMatch => 'Няма съвпадащи фактури.';

  @override
  String get vatEmpty =>
      'Въведете сума, за да я разделите на данъчна основа и ДДС.';

  @override
  String vatRatesNote(String country) {
    return 'Показани са основната и намалените ставки на ДДС за: $country.';
  }

  @override
  String get mrgEmpty => 'Въведете себестойността и цена, надценка или марж.';

  @override
  String get mrgLoss => 'На тази цена продавате под себестойност.';

  @override
  String get beFixedHint => 'Наем, заплати, абонаменти…';

  @override
  String get beVariableHint => 'Материали, комисиони, доставка…';

  @override
  String get beEmpty =>
      'Въведете постоянните разходи, цената и променливия разход за единица.';

  @override
  String get beContributionUnit => 'Маржинален доход за единица';

  @override
  String get beExplain =>
      'Всяка продадена единица допринася с цената си минус променливия разход за покриване на постоянните разходи и за печалба. Сумите са без ДДС.';

  @override
  String get invsFlowsHint =>
      'Нетен паричен поток в края на всяка година. Въведете минус за година, в която изходящите потоци са повече от входящите.';

  @override
  String get invsEmpty =>
      'Въведете инвестицията, дисконтов процент и паричния поток за поне една година.';

  @override
  String get invsCumulative => 'Кумулативен паричен поток';

  @override
  String get invCreatedWith => 'Създадено с Bilans';

  @override
  String get proHeadline => 'Bilans Pro';

  @override
  String get proSubhead =>
      'Всички калкулатори, всички държави, неограничен брой фактури и PDF отчети. Без реклами, без регистрация.';

  @override
  String get proFeatAllCountries => 'Заплати по всичките 9 данъчни системи';

  @override
  String get proFeatUnlimitedInvoices => 'Неограничен брой фактури';

  @override
  String get proFeatPdf => 'PDF отчети';

  @override
  String get proFeatUnlimitedSaves => 'Неограничен брой запазени изчисления';

  @override
  String get proBenefitCountries =>
      'Заплати по всичките 9 данъчни системи и сравнение на една и съща заплата между държавите';

  @override
  String get proBenefitTeam =>
      'Разходи за екипа: всички заплати по месеци и години';

  @override
  String get proBenefitInvoices =>
      'Неограничен брой професионални фактури в PDF';

  @override
  String get proBenefitInvoicesRs =>
      'Неограничен брой фактури с QR код за плащане NBS IPS';

  @override
  String get proBenefitPausal =>
      'Проследяване на лимитите за паушал от 6 и 8 милиона динара';

  @override
  String get proBenefitLoans =>
      'Сравнение на оферти за кредит и план за предсрочно погасяване';

  @override
  String get proBenefitHistory => 'История на курса за 30, 90 и 365 дни';

  @override
  String get proBenefitInvestment =>
      'Инвестиционен анализ: NPV, IRR и срок на откупуване';

  @override
  String get proBenefitPdf =>
      'PDF отчети за заплати, кредити, спестявания и екипи';

  @override
  String get proYearly => 'Годишно';

  @override
  String get proMonthly => 'Месечно';

  @override
  String get proLifetime => 'Завинаги';

  @override
  String get proPerYear => 'на година';

  @override
  String get proPerMonth => 'на месец';

  @override
  String get proOnce => 'еднократно';

  @override
  String proSave(int percent) {
    return 'СПЕСТЕТЕ $percent%';
  }

  @override
  String proTrialNote(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дни безплатно, после годишно плащане',
      one: '$days ден безплатно, после годишно плащане',
    );
    return '$_temp0';
  }

  @override
  String get proLifetimeNote => 'Платете веднъж и Pro остава завинаги';

  @override
  String proStartTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Започни $days-дневен безплатен пробен период',
      one: 'Започни $days-дневен безплатен пробен период',
    );
    return '$_temp0';
  }

  @override
  String get proContinue => 'Продължи';

  @override
  String get proRestore => 'Възстанови покупка';

  @override
  String get proRestored => 'Bilans Pro е активен на това устройство.';

  @override
  String get proNothingToRestore =>
      'Не е намерена покупка на Bilans Pro за този профил в Google.';

  @override
  String get proPending =>
      'Плащането се обработва. Pro ще се отключи автоматично веднага щом Google Play го потвърди.';

  @override
  String get proError =>
      'Покупката не беше извършена. Не сте таксувани — опитайте отново.';

  @override
  String get proUnavailable =>
      'В момента покупките не са достъпни. Проверете дали Google Play е инсталиран и дали сте влезли в профила си, след което опитайте отново.';

  @override
  String get proLegal =>
      'Абонаментите се подновяват автоматично на показаната цена, докато не ги откажете. Можете да откажете по всяко време от Google Play → Плащания и абонаменти, най-късно 24 часа преди датата на подновяване. Безплатният пробен период преминава в платен годишен абонамент, ако не го откажете преди края му.';

  @override
  String get proLegalLifetime =>
      'Еднократна покупка: без абонамент и без подновявания. Pro остава активен на всяко устройство, влязло в същия профил в Google.';

  @override
  String get proDevSimulate => 'Симулирай Pro (версия за разработка)';

  @override
  String get proWelcome => 'Добре дошли в Bilans Pro';

  @override
  String get proWelcomeBody =>
      'Всичко е отключено. Благодарим ви, че подкрепяте независимо приложение.';

  @override
  String get settingsPreferences => 'Предпочитания';

  @override
  String get settingsTheme => 'Външен вид';

  @override
  String get settingsThemeSystem => 'Системен';

  @override
  String get settingsThemeLight => 'Светъл';

  @override
  String get settingsThemeDark => 'Тъмен';

  @override
  String get settingsYourData => 'Вашите данни';

  @override
  String get settingsExport => 'Експортирай резервно копие';

  @override
  String get settingsImport => 'Възстанови от резервно копие';

  @override
  String get settingsBackupSubject => 'Резервно копие на Bilans';

  @override
  String get settingsExported => 'Резервното копие е готово';

  @override
  String get settingsImportInvalid =>
      'Този файл не е резервно копие на Bilans.';

  @override
  String get settingsImportTitle => 'Да се възстанови ли това резервно копие?';

  @override
  String get settingsImportBody =>
      'Всичко в приложението ще бъде заменено със съдържанието на копието — фактури, данни за фирмата, екип и запазени изчисления.';

  @override
  String get settingsImportAction => 'Възстанови';

  @override
  String get settingsImported => 'Резервното копие е възстановено';

  @override
  String get settingsDeleteAll => 'Изтрий всички данни';

  @override
  String get settingsDeleteTitle => 'Да се изтрият ли всички данни?';

  @override
  String get settingsDeleteBody =>
      'Фактурите, данните за фирмата, екипът, запазените изчисления и настройките ще бъдат премахнати от този телефон. Ако може да ви потрябват, първо експортирайте резервно копие. Покупката на Pro не се засяга.';

  @override
  String get settingsDeleteAction => 'Изтрий всичко';

  @override
  String get settingsDataNote =>
      'Bilans няма регистрация и сървъри: данните ви съществуват само на този телефон. Експортирайте резервно копие, за да ги прехвърлите на нов телефон.';

  @override
  String get settingsAbout => 'За приложението';

  @override
  String get settingsRate => 'Оценете Bilans в Google Play';

  @override
  String get settingsContact => 'Контакт';

  @override
  String get settingsPrivacy => 'Политика за поверителност';

  @override
  String get settingsTerms => 'Условия за ползване';

  @override
  String get settingsLicenses => 'Лицензи за отворен код';

  @override
  String get settingsDisclaimer =>
      'Изчисленията са ориентировъчни и не заместват професионален данъчен, правен или финансов съвет.';

  @override
  String get settingsProActive => 'Bilans Pro е активен';

  @override
  String get settingsManageSubscription => 'Управление на абонамента';

  @override
  String get settingsProPitch =>
      'Всички държави, разходи за екипа, неограничен брой фактури, PDF отчети и още.';

  @override
  String get settingsSeePlans => 'Вижте плановете';

  @override
  String get proIncluded => 'Включено в Pro';

  @override
  String proSummaryTrial(int days, String price, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          '$days дни безплатно, после $price $period. Откажете по всяко време.',
      one:
          '$days ден безплатно, после $price $period. Откажете по всяко време.',
    );
    return '$_temp0';
  }

  @override
  String proSummary(String price, String period) {
    return '$price $period, подновява се автоматично. Откажете по всяко време.';
  }

  @override
  String proSummaryLifetime(String price) {
    return 'Еднократно плащане от $price. Без абонамент.';
  }
}
