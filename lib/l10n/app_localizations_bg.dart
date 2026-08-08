// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Начало';

  @override
  String get navConvert => 'Конвертиране';

  @override
  String get navSalary => 'Заплата';

  @override
  String get navTools => 'Инструменти';

  @override
  String get navSettings => 'Настройки';

  @override
  String themeToggleTooltip(String mode) {
    return 'Смяна на тема ($mode)';
  }

  @override
  String get themeModeSystem => 'системна';

  @override
  String get themeModeLight => 'светла';

  @override
  String get themeModeDark => 'тъмна';

  @override
  String get onboardingSkip => 'Пропусни';

  @override
  String get onboardingContinue => 'Напред';

  @override
  String get onboardingGetStarted => 'Начало';

  @override
  String get onboardingWelcomeTitle => 'Добре дошли';

  @override
  String get onboardingWelcomeSubtitle =>
      'Изберете държава и език, за да започнете. Можете да ги промените по всяко време в Настройки.';

  @override
  String get onboardingCountryLabel => 'Държава';

  @override
  String get onboardingPrivacyTitle => 'Вашите данни остават на телефона';

  @override
  String get onboardingPrivacyBody =>
      'Без акаунт. Без облачна синхронизация. Без сървър. Всичко, което въведете — заплати, разходи, фактури — остава само на това устройство. Конвертирането на валута е единствената функция, която се нуждае от интернет връзка; без нея се използва последният известен курс.';

  @override
  String get onboardingGoalTitle => 'Какво ви води тук?';

  @override
  String get onboardingGoalSubtitle =>
      'Ще настроим началния екран според това — всичко останало остава на едно докосване разстояние.';

  @override
  String get onboardingGoalSalaryTitle => 'Заплата и изчисление на доходи';

  @override
  String get onboardingGoalSalaryDesc =>
      'Изчислете нето от брутна заплата за 9 държави';

  @override
  String get onboardingGoalExpensesTitle => 'Проследяване на приходи и разходи';

  @override
  String get onboardingGoalExpensesDesc =>
      'Записвайте разходи, задайте бюджети, постигайте цели за спестявания';

  @override
  String get onboardingGoalBusinessTitle => 'Свободна практика и бизнес';

  @override
  String get onboardingGoalBusinessDesc =>
      'Фактури, изплащания и бизнес инструменти';

  @override
  String get commonCalculate => 'Изчисли';

  @override
  String get commonConvert => 'Конвертирай';

  @override
  String get commonRetry => 'Опитай отново';

  @override
  String get commonSwapCurrencies => 'Размени валутите';

  @override
  String get commonSomethingWentWrong => 'Нещо се обърка.';

  @override
  String get commonFrom => 'От';

  @override
  String get commonTo => 'Към';

  @override
  String get commonAmount => 'Сума';

  @override
  String get convertCardTitle => 'Конвертиране';

  @override
  String get convertEmptyState =>
      'Въведете сума и натиснете Конвертирай, за да видите реалния, актуален курс.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Актуален курс от $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Запазен курс от $formatted (офлайн) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Въведете сума.';

  @override
  String get convertAmountIssueInvalid =>
      'Това не изглежда като валидно число.';

  @override
  String get convertAmountIssueNegative =>
      'Сумата не може да бъде отрицателна.';

  @override
  String get convertAmountIssueZero =>
      'Сумата трябва да бъде по-голяма от нула.';

  @override
  String get convertAmountIssueTooLarge =>
      'Това изглежда необичайно голямо за сума — проверете дали няма печатна грешка.';

  @override
  String salaryTitle(String country) {
    return 'Калкулатор на заплата — $country';
  }

  @override
  String salaryParamsLine(int year, String date) {
    return 'Параметри за $year г. · в сила от $date';
  }

  @override
  String get salaryModeGrossToNet => 'Бруто → Нето';

  @override
  String get salaryModeNetToGross => 'Нето → Бруто';

  @override
  String salaryGrossLabel(String currencyCode) {
    return 'Брутна заплата, $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Нетна заплата, $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Въведете заплата и натиснете Изчисли за пълна разбивка.';

  @override
  String get salaryNeto => 'Нето (за получаване)';

  @override
  String get salaryBruto => 'Бруто (заплата)';

  @override
  String get salaryAllowance => 'Лично освобождаване';

  @override
  String get salaryTaxableBase => 'Облагаема основа';

  @override
  String get salaryIncomeTax => 'Данък върху дохода';

  @override
  String get salaryLocalSurtax => 'Местна надбавка';

  @override
  String get salaryEmployeeContribTotal => 'Осигуровки на служителя (общо)';

  @override
  String get salaryEmployerContribTotal => 'Осигуровки на работодателя (общо)';

  @override
  String get salaryBruto2 => 'Бруто 2 (общ разход за работодателя)';

  @override
  String salarySurtaxLabel(String rate) {
    return 'Местна надбавка: $rate% — задайте според ставката на вашата община';
  }

  @override
  String get salaryDisclaimer =>
      'Това е оценка само за информационни цели и не представлява данъчен, правен или финансов съвет. Действителните задължения може да варират в зависимост от вашата конкретна ситуация — консултирайте се с лицензиран счетоводител или местната данъчна администрация, преди да вземете решения.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Тази брутна сума е под законово определената минимална осигурителна основа ($base). Задължителните осигуровки сами по себе си достигат или надвишават тази заплата, така че сумата за получаване е нула или отрицателна — това ниво на заплата е непрактично да се регистрира официално.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'На това ниво на доход задължителните осигуровки и данъкът заедно достигат или надвишават брутната заплата, така че сумата за получаване е нула или отрицателна.';

  @override
  String salaryConfigError(String country) {
    return 'Данъчната конфигурация за $country не можа да бъде заредена.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Въведете заплата.';

  @override
  String get salaryAmountIssueInvalid => 'Това не изглежда като валидно число.';

  @override
  String get salaryAmountIssueNegative =>
      'Заплатата не може да бъде отрицателна.';

  @override
  String get salaryAmountIssueZero =>
      'Заплатата трябва да бъде по-голяма от нула.';

  @override
  String get salaryAmountIssueTooLarge =>
      'Това изглежда необичайно голямо за заплата — проверете дали няма печатна грешка.';

  @override
  String get toolsHubTitle => 'Финансови инструменти';

  @override
  String get toolsLoanTitle => 'Заеми и дългове';

  @override
  String get toolsSavingsTitle => 'Спестявания и растеж';

  @override
  String get toolsVatTitle => 'ДДС калкулатор';

  @override
  String get toolsBudgetTitle => 'Планер на бюджет';

  @override
  String get toolsFreelancerPayoutTitle => 'Изплащане на фрийлансър';

  @override
  String get toolsFreelanceTaxTitle => 'Самооблагане на фрийлансъри';

  @override
  String get homeQuoteOfDay => 'Цитат на деня';

  @override
  String get homeQuickActions => 'Бързи действия';

  @override
  String get settingsLanguage => 'Език';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsAbout => 'За приложението';

  @override
  String get settingsSystemDefault => 'По подразбиране от системата';

  @override
  String get settingsNotificationsTitle => 'Известия';

  @override
  String get notifExpenseNudgeTitle => 'Записвай разходите си';

  @override
  String get notifExpenseNudgeSubtitle =>
      'Ежедневно вечерно напомняне да въведете днешните приходи и разходи';

  @override
  String get notifExpenseNudgeNotifTitle => 'Да въведете днешните разходи?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Добавете днешните приходи и разходи, преди да забравите.';

  @override
  String get notifBudgetThresholdTitle => 'Известия за бюджет';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Известявай при достигане на 80% или 100% от бюджета на категория';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent% от бюджета';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'Изхарчили сте $percent% от бюджета за $category този месец.';
  }

  @override
  String get notifInvoiceDueTitle => 'Напомняния за фактури';

  @override
  String get notifInvoiceDueSubtitle =>
      'Известявай ден преди падежа на фактура';

  @override
  String get notifInvoiceDueNotifTitle => 'Фактура с падеж утре';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency с падеж утре.';
  }

  @override
  String get notifPausalReminderTitle => 'Напомняне за патент (Сърбия)';

  @override
  String get notifPausalReminderSubtitle =>
      'Месечно напомняне на 15-о число за подаване на патентната декларация';

  @override
  String get notifPausalReminderNotifTitle => 'Напомняне за подаване на патент';

  @override
  String get notifPausalReminderNotifBody =>
      'Не забравяйте месечната декларация и плащане на патента.';

  @override
  String notifPausalReminderNotifBodyWithAmount(String amount) {
    return 'Не забравяйте месечната декларация и плащане на патента в размер на $amount RSD.';
  }

  @override
  String get notifPausalLeadReminderTitle => 'Напомни ми и 3 дни по-рано';

  @override
  String get notifPausalLeadReminderSubtitle =>
      'Допълнително напомняне на 12-о число, преди основното на 15-о';

  @override
  String get notifPausalLeadReminderNotifTitle =>
      'Декларация за патент след 3 дни';

  @override
  String get notifPausalLeadReminderNotifBody =>
      'Месечната декларация и плащане на патента изтичат след 3 дни, на 15-о число.';

  @override
  String get settingsWidgetsTitle => 'Джаджи за начален екран';

  @override
  String get settingsWidgetsExplainer =>
      'Добавете джаджа от началния екран на устройството (задръжте продължително на празно място → Джаджи → Salary & Currency Pro) — приложението не може да я добави вместо вас. След добавяне тя се обновява автоматично.';

  @override
  String get settingsWidgetsPinnedPairTitle =>
      'Закачена валутна двойка за джаджата';

  @override
  String get homeWidgetBudgetLabel => 'Похарчено този месец';

  @override
  String get homeWidgetBudgetEmpty =>
      'Задайте бюджет в приложението, за да го видите тук';

  @override
  String get homeWidgetPairUnavailable =>
      'Неуспешно обновяване — показан е последният известен курс';

  @override
  String get settingsBusinessProfileTitle => 'Бизнес профил';

  @override
  String get settingsBusinessProfileExplainer =>
      'Използва се в генерираните фактури в PDF и, за допустими фактури в RSD, в NBS IPS QR кода за плащане.';

  @override
  String get businessProfileNameLabel => 'Име на фирма / издател';

  @override
  String get businessProfileAddressLabel => 'Адрес';

  @override
  String get businessProfileCityLabel => 'Град';

  @override
  String get businessProfileBankAccountLabel =>
      'Номер на банкова сметка (Сърбия)';

  @override
  String get businessProfileBankAccountHelper =>
      'Необходимо само за NBS IPS QR кода на фактури в RSD';

  @override
  String get businessProfilePaymentCodeLabel =>
      'Код на плащане по подразбиране (Сърбия)';

  @override
  String get businessProfilePaymentCodeHelper =>
      'Трицифрен NBS код за плащане, напр. 289 — необходим само за QR кода';

  @override
  String get countryRs => 'Сърбия';

  @override
  String get countryHr => 'Хърватия';

  @override
  String get countryBa => 'Босна и Херцеговина';

  @override
  String get countryMe => 'Черна гора';

  @override
  String get countryMk => 'Северна Македония';

  @override
  String get countrySi => 'Словения';

  @override
  String get countryBg => 'България';

  @override
  String get countryAl => 'Албания';

  @override
  String get countryRo => 'Румъния';

  @override
  String get entityFbih => 'Федерация БиХ';

  @override
  String get entityRepublikaSrpska => 'Република Сръбска';

  @override
  String get contribPio => 'ПИО (пенсионно и инвалидно)';

  @override
  String get contribHealth => 'Здравна осигуровка';

  @override
  String get contribUnemployment => 'Осигуровка за безработица';

  @override
  String get contribPension => 'Пенсионна осигуровка';

  @override
  String get contribSocial => 'Социална осигуровка';

  @override
  String get contribChildProtection => 'Вноска за закрила на детето';

  @override
  String get contribHealthAndEmployment =>
      'Здравна осигуровка и осигуровка за заетост';

  @override
  String get contribCas => 'CAS (пенсионна осигуровка)';

  @override
  String get contribCass => 'CASS (здравна осигуровка)';

  @override
  String get contribCam => 'CAM (осигуровка за труд)';

  @override
  String get suffixEmployee => 'служител';

  @override
  String get suffixEmployer => 'работодател';

  @override
  String get toolsLoanSubtitle =>
      'Месечна вноска, срок на изплащане, амортизация';

  @override
  String get toolsSavingsSubtitle => 'Сложна лихва с редовни вноски';

  @override
  String get toolsVatSubtitle =>
      'Добавете или премахнете ДДС по ставката на вашата държава';

  @override
  String get toolsBudgetSubtitle =>
      'Разделете месечния доход на нужди / желания / спестявания';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Чуждестранна фактура → такси → реално локално плащане';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Данък и осигуровки за фрийлансъри, 9 държави';

  @override
  String get loanScreenTitle => 'Заеми и дългове';

  @override
  String get loanModePayment => 'Вноска от срок';

  @override
  String get loanModePayoff => 'Срок от вноска';

  @override
  String get loanPrincipal => 'Размер на заема (главница)';

  @override
  String get loanRate => 'Годишен лихвен процент (%)';

  @override
  String get loanTermMonths => 'Срок на заема (месеци)';

  @override
  String get loanFixedPayment => 'Фиксирана месечна вноска';

  @override
  String get loanErrorPrincipalRate =>
      'Въведете валидна главница и лихвен процент.';

  @override
  String get loanErrorTerm => 'Въведете валиден срок в месеци.';

  @override
  String get loanErrorPayment => 'Въведете валидна месечна вноска.';

  @override
  String get loanErrorTooLow =>
      'Тази вноска е твърде ниска, за да изплати дълга някога — не покрива дори лихвата, натрупваща се всеки месец.';

  @override
  String get loanMonthlyPayment => 'Месечна вноска';

  @override
  String get loanTotalPaid => 'Общо платено';

  @override
  String get loanTotalInterest => 'Обща лихва';

  @override
  String get loanNumberOfPayments => 'Брой вноски';

  @override
  String get loanTimeToPayOff => 'Време до изплащане';

  @override
  String loanMonthsCount(int months) {
    return '$months месеца';
  }

  @override
  String get savingsScreenTitle => 'Спестявания и растеж';

  @override
  String get savingsStartingAmount => 'Начална сума';

  @override
  String get savingsMonthlyContribution => 'Месечна вноска';

  @override
  String get savingsExpectedReturn => 'Очакван годишен доход (%)';

  @override
  String get savingsTimeHorizon => 'Времеви хоризонт (години)';

  @override
  String get savingsErrorRateYears =>
      'Въведете валиден годишен процент и брой години.';

  @override
  String get savingsFutureValue => 'Бъдеща стойност';

  @override
  String get savingsTotalContributed => 'Общо внесено';

  @override
  String get savingsInterestEarned => 'Спечелена лихва';

  @override
  String get vatScreenTitle => 'ДДС калкулатор';

  @override
  String get vatStandardRateFor => 'Стандартна ставка за';

  @override
  String get vatAdd => 'Добави ДДС';

  @override
  String get vatRemove => 'Премахни ДДС';

  @override
  String get vatNetAmount => 'Нетна сума (без ДДС)';

  @override
  String get vatGrossAmount => 'Брутна сума (с ДДС)';

  @override
  String get vatRateEditable =>
      'Ставка на ДДС (%) — редактируема за намалени ставки';

  @override
  String get vatGrossWithVat => 'Брутно (с ДДС)';

  @override
  String get vatAmountLabel => 'Сума на ДДС';

  @override
  String get vatNetWithoutVat => 'Нетно (без ДДС)';

  @override
  String vatRatesAsOf(String date) {
    return 'Стандартна ставка към $date';
  }

  @override
  String get budgetScreenTitle => 'Планер на бюджет';

  @override
  String get budgetMonthlyIncome => 'Месечен нетен доход';

  @override
  String get budgetSplit => 'Разпределение';

  @override
  String get budgetPresetSuffix => '(нужди/желания/спестявания)';

  @override
  String get budgetNeeds => 'Нужди';

  @override
  String get budgetWants => 'Желания';

  @override
  String get budgetSavings => 'Спестявания';

  @override
  String get freelancerScreenTitle =>
      'Проверка на реалното плащане на фрийлансър';

  @override
  String get freelancerInvoiceAmount => 'Сума на фактурата';

  @override
  String get freelancerCurrency => 'Валута';

  @override
  String get freelancerPlatform => 'Платформа';

  @override
  String get freelancerPlatformCustom => 'По избор';

  @override
  String get freelancerPlatformDirect => 'Директен клиент / превод (0%)';

  @override
  String get freelancerPlatformFee => 'Такса на платформата (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Банкова такса (фиксна, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Банкова такса (%)';

  @override
  String get freelancerPayoutCurrency => 'Валута на плащане';

  @override
  String get freelancerCalculateButton => 'Изчисли реалното плащане';

  @override
  String get freelancerErrorInvoice => 'Въведете валидна сума на фактурата.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Неочаквана грешка: $error';
  }

  @override
  String get freelancerRealPayout => 'Реално плащане';

  @override
  String get freelancerInvoiceAmountRow => 'Сума на фактурата';

  @override
  String get freelancerPlatformFeeRow => 'Такса на платформата';

  @override
  String get freelancerBankFeeRow => 'Банкова такса';

  @override
  String get freelancerNetForeignAmount => 'Нетна сума в чуждестранна валута';

  @override
  String get samoFixedModel => 'Модел с фиксирани разходи';

  @override
  String get samoMixedModel => 'Модел със смесени разходи';

  @override
  String get samoCheaperSame =>
      'Този модел е по-евтиният вариант за тази сума.';

  @override
  String get samoCheaperOther =>
      'Другият модел би довел до по-нисък данък за тази сума — можете свободно да сменяте моделите всяко тримесечие.';

  @override
  String get freelanceTaxScreenTitle => 'Самооблагане на фрийлансъри';

  @override
  String get freelanceTaxCountryLabel => 'Държава / режим';

  @override
  String get freelanceTaxIncomeLabelQuarterly => 'Тримесечен брутен доход';

  @override
  String get freelanceTaxIncomeLabelAnnual => 'Годишен брутен доход';

  @override
  String get freelanceTaxNetIncome => 'Нетен доход';

  @override
  String get freelanceTaxGrossIncomeRow => 'Брутен доход';

  @override
  String get freelanceTaxDeductionRow => 'Приспадане';

  @override
  String get freelanceTaxTaxableBaseRow => 'Данъчна основа';

  @override
  String get freelanceTaxIncomeTaxRow => 'Данък върху дохода';

  @override
  String get freelanceTaxContributionsTotalRow => 'Общо осигуровки';

  @override
  String freelanceTaxRulesVersionBundle(String date) {
    return 'Ставки, вградени в приложението · версия $date';
  }

  @override
  String freelanceTaxRulesVersionUpdated(String date) {
    return 'Ставки, обновени онлайн · версия $date';
  }

  @override
  String freelanceTaxSourcesLabel(String sources) {
    return 'Източници: $sources';
  }

  @override
  String get freelanceTaxNotAvailable => 'Не е налично';

  @override
  String get freelanceTaxModelLabel => 'Модел';

  @override
  String get freelanceTaxVariantLabel => 'Вид';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Категория дейност';

  @override
  String get freelanceFbihCategoryFreeProfessions => 'Свободни професии';

  @override
  String get freelanceFbihCategoryObrt => 'Занаятчийска дейност (obrt)';

  @override
  String get freelanceFbihCategoryAgriculture =>
      'Земеделие / горско стопанство';

  @override
  String get freelanceFbihCategoryLumpSumObrt =>
      'Патентна занаятчийска дейност';

  @override
  String get freelanceFbihCategoryTraditionalCraftsTaxi =>
      'Традиционни занаяти / такси';

  @override
  String get freelanceTaxCategoryLabel => 'Категория';

  @override
  String get freelanceBaRsCategoryStandard => 'Стандартен предприемач';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Независими професии';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Допълнителна дейност / пенсионер';

  @override
  String get freelanceTaxMunicipalityLabel => 'Община';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Подгорица / Цетине';

  @override
  String get freelanceMeMunicipalityBudva => 'Будва';

  @override
  String get freelanceMeMunicipalityOther => 'Друга община';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'Праг за регистрация по ДДС: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return '0% данък върху дохода важи само до оборот от $amount $currency — над него цялата печалба се облага прогресивно, не само превишението.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Облекчението от 80% признати разходи важи само до приход от $amount $currency.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Правото на popoldanski s.p. отпада при приход от $amount $currency.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'Алтернативният патентен статут е ограничен до $amount $currency — само информативно, не се изчислява от този калкулатор.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Все още не е достигнат';

  @override
  String get freelanceCliffStatusCrossed => 'Надвишен';

  @override
  String get freelanceRsInsuredElsewhereLabel =>
      'Вече осигурен(а) на друго основание (здравната осигуровка не се начислява)';

  @override
  String freelanceRsMinPioBaseBinds(String amount) {
    return 'Пенсионната осигуровка при Модел Б е ограничена до минималната основа ($amount) — това е случаят, който хората най-често подценяват.';
  }

  @override
  String get freelanceComparatorTitle => 'Сравни Модел А и Модел Б';

  @override
  String get freelanceComparatorQuarterLabel => 'Тримесечие';

  @override
  String freelanceComparatorDeadlineHint(String date) {
    return 'Краен срок за подаване за това тримесечие: $date';
  }

  @override
  String get freelanceComparatorNeedsIncome =>
      'Въведете доход по-горе, за да сравните двата модела.';

  @override
  String freelanceComparatorRecommended(String model, String amount) {
    return 'Препоръка: $model — спестява $amount нетен доход.';
  }

  @override
  String get settingsProActive => 'Pro — активен';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Рекламите са изключени в цялото приложение';

  @override
  String get settingsProSubtitleInactive =>
      'Премахнете рекламите с достъпен абонамент';

  @override
  String get settingsTrustTitle => 'Защо да се доверите на това приложение?';

  @override
  String get settingsTrustBody =>
      'Данните за заплати, ДДС и самооблагане идват от цитирани държавни и професионални данъчни консултантски източници, не са оценки. Всеки калкулатор показва годината, за която важат числата, и датата на влизане в сила, за да прецените актуалността им бързо. Вижте „Поверителност и данни“ и „Работи напълно офлайн“ по-долу за начина, по който се обработва вашата информация.';

  @override
  String get settingsAdPrivacyTitle => 'Поверителност и реклами';

  @override
  String get settingsAdPrivacySubtitle =>
      'Прегледайте или променете избора си за съгласие за реклами';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Опциите за поверителност на реклами не са налични на тази платформа.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'За вашия регион не се изисква избор за поверителност на реклами.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro обхваща изчисляване на заплати, конвертиране на валута и ежедневни финансови калкулатори за Сърбия, Хърватия, Босна и Херцеговина, Черна гора, Северна Македония, Словения, България, Албания и Румъния. Всички стойности са с посочен източник и дата — вижте бележката на всеки калкулатор за подробности. Това приложение предоставя само оценки, не професионален съвет.';

  @override
  String get paywallTitle => 'Стани Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Премахнете всички реклами във всеки калкулатор, на достъпна месечна цена. Всички държави за заплати, конвертиране на валута и финансови инструменти остават безплатни във всеки случай.';

  @override
  String get paywallActiveMessage =>
      'Вие сте Pro потребител — благодарим ви! Рекламите са изключени в цялото приложение.';

  @override
  String get paywallStoreUnavailable =>
      'Магазинът в момента не е достъпен (това е очаквано в разработващи версии без конфигуриран списък в Play Console). Pro ще може да се закупи след публикуване.';

  @override
  String get paywallProductUnavailable =>
      'Абонаментът Pro все още не е настроен в магазина — това е временен екран, докато истинският продукт не бъде създаден в Play Console.';

  @override
  String get paywallSubscribe => 'Абонирай се';

  @override
  String get paywallProcessing => 'Обработка…';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Покупката не бе успешна: $error';
  }

  @override
  String get paywallRestorePurchase => 'Възстанови покупка';

  @override
  String get chartTakeHome => 'За получаване';

  @override
  String get chartTax => 'Данък';

  @override
  String get chartContributions => 'Осигуровки';

  @override
  String get homeRecentlyUsed => 'Наскоро използвани';

  @override
  String get categoryLoansSavings => 'Заеми и спестявания';

  @override
  String get categoryBudgetTax => 'Бюджетиране и данъци';

  @override
  String get categoryFreelance => 'Фрийланс';

  @override
  String get toolsSearchHint => 'Търсене на инструменти';

  @override
  String get toolsSearchNoResults => 'Не са намерени инструменти';

  @override
  String get homeLastSalaryTitle => 'Последно изчисление на заплата';

  @override
  String get homeLastSalaryEmpty => 'Все още не сте изчислили заплата.';

  @override
  String get homeLastSalaryCta => 'Изчисли сега';

  @override
  String get settingsPrivacyTitle => 'Поверителност и данни';

  @override
  String get settingsPrivacyNote =>
      'Историята на изчисленията се съхранява само на това устройство и никога не се качва или споделя. Изтриването ѝ или деинсталирането на приложението я премахва завинаги.';

  @override
  String get settingsClearHistory => 'Изчисти историята';

  @override
  String get settingsClearHistorySubtitle =>
      'Премахни всички скорошни изчисления от Начало и Инструменти';

  @override
  String get settingsClearHistoryDialogTitle => 'Да се изчисти историята?';

  @override
  String get settingsClearHistoryDialogBody =>
      'Това премахва цялата скорошна активност от Начало и Инструменти. Действието не може да бъде отменено.';

  @override
  String get settingsClearHistoryDialogCancel => 'Отказ';

  @override
  String get settingsClearHistoryDialogConfirm => 'Изчисти';

  @override
  String get settingsClearHistoryDone => 'Историята е изчистена';

  @override
  String get commonCancel => 'Отказ';

  @override
  String get commonSave => 'Запази';

  @override
  String get commonDelete => 'Изтрий';

  @override
  String get commonRename => 'Преименувай';

  @override
  String get commonUndo => 'Отмени';

  @override
  String get scenarioSaveTooltip => 'Запази това изчисление';

  @override
  String get scenarioSaveDialogTitle => 'Запази изчисление';

  @override
  String get scenarioNameLabel => 'Име';

  @override
  String get scenarioSavedConfirmation => 'Сценарият е запазен';

  @override
  String get scenarioLimitTitle => 'Достигнат безплатен лимит';

  @override
  String scenarioLimitBody(int limit) {
    return 'Безплатните акаунти могат да запазят до $limit сценария. Надградете до Pro за неограничено запазване, сравнение и износ.';
  }

  @override
  String get scenarioLimitUpgrade => 'Надгради до Pro';

  @override
  String get myScenariosTitle => 'Моите сценарии';

  @override
  String myScenariosSubtitle(int count) {
    return '$count запазени';
  }

  @override
  String get myScenariosSubtitleEmpty => 'Няма запазени сценарии';

  @override
  String get myScenariosEmptyState =>
      'Запазете изчисление от кой да е инструмент, за да го видите тук.';

  @override
  String get scenarioRenameDialogTitle => 'Преименувай сценарий';

  @override
  String get scenarioDeleteDialogTitle => 'Изтриване на сценария?';

  @override
  String get scenarioDeleteDialogBody => 'Това не може да бъде отменено.';

  @override
  String get categoryTracking => 'Проследяване и планиране';

  @override
  String get toolsExpenseTrackerTitle => 'Проследяване на разходи';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Записвайте приходи и разходи, следете месечния баланс';

  @override
  String get expenseScreenTitle => 'Проследяване на разходи';

  @override
  String get expenseIncome => 'Приходи';

  @override
  String get expenseExpenses => 'Разходи';

  @override
  String get expenseBalance => 'Баланс';

  @override
  String get expenseEmptyState =>
      'Все още няма транзакции този месец. Докоснете +, за да добавите първия си приход или разход.';

  @override
  String get expenseAddIncome => 'Добави приход';

  @override
  String get expenseAddExpense => 'Добави разход';

  @override
  String get expenseAmount => 'Сума';

  @override
  String get expenseCategory => 'Категория';

  @override
  String get expenseNote => 'Бележка (незадължително)';

  @override
  String get expenseDate => 'Дата';

  @override
  String get expenseDeleteConfirmTitle => 'Да се изтрие ли тази транзакция?';

  @override
  String get expenseDeleteConfirmBody =>
      'Веднага след това ще имате кратка възможност за отмяна.';

  @override
  String get expenseDeletedConfirmation => 'Транзакцията е изтрита';

  @override
  String get expenseEditTransaction => 'Редактирай транзакция';

  @override
  String get expenseSearchHint => 'Търсене по бележки или категории';

  @override
  String get expenseFilterAll => 'Всички';

  @override
  String get expenseSortByDate => 'Сортирай по дата';

  @override
  String get expenseSortByAmount => 'Сортирай по сума';

  @override
  String get expenseNoResults => 'Няма транзакции, отговарящи на търсенето.';

  @override
  String expenseResultCount(int shown, int total) {
    return '$shown от $total';
  }

  @override
  String get expenseSpendingByCategory => 'Разходи по категория';

  @override
  String get toolsRecurringTitle => 'Повтарящи се транзакции';

  @override
  String get toolsRecurringSubtitle =>
      'Наем, абонаменти и други редовни плащания — задайте веднъж';

  @override
  String get recurringScreenTitle => 'Повтарящи се транзакции';

  @override
  String get recurringEmptyState =>
      'Все още няма повтарящи се транзакции. Добавете наем, абонаменти или други редовни плащания веднъж — те ще се записват автоматично или ще чакат вашия преглед, по ваш избор.';

  @override
  String get recurringAddTitle => 'Нова повтаряща се транзакция';

  @override
  String get recurringEditTitle => 'Редактиране на повтаряща се транзакция';

  @override
  String get recurringFrequencyLabel => 'Повтаря се';

  @override
  String get recurringFrequencyWeekly => 'Седмично';

  @override
  String get recurringFrequencyMonthly => 'Месечно';

  @override
  String get recurringStartDateLabel => 'Започва';

  @override
  String get recurringAutoPostLabel => 'Автоматично записване';

  @override
  String get recurringAutoPostSubtitle =>
      'Изключено: прегледайте всяко повторение преди добавяне';

  @override
  String get recurringPausedLabel => 'На пауза';

  @override
  String get recurringPauseAction => 'Пауза';

  @override
  String get recurringResumeAction => 'Възобнови';

  @override
  String get recurringDeleteConfirmTitle =>
      'Да се изтрие ли тази повтаряща се транзакция?';

  @override
  String get recurringDeleteConfirmBody =>
      'Това спира бъдещите повторения. Вече записаните транзакции не се засягат.';

  @override
  String recurringReviewBannerTitle(int count) {
    return '$count повтарящи се транзакции за преглед';
  }

  @override
  String get recurringReviewPost => 'Запиши';

  @override
  String get recurringReviewSkip => 'Пропусни';

  @override
  String get toolsRadarTitle => 'Радар за фиксни разходи';

  @override
  String get toolsRadarSubtitle =>
      'Вижте общите си повтарящи се разходи на едно място';

  @override
  String get radarScreenTitle => 'Радар за фиксни разходи';

  @override
  String get radarEmptyState =>
      'Все още няма активни повтарящи се разходи. Добавете такъв в Повтарящи се транзакции, за да видите тук общия си фиксен разход.';

  @override
  String get radarMonthlyTotal => 'Месечно общо';

  @override
  String get radarWeeklyTotal => 'Седмично общо';

  @override
  String radarNextDue(String date) {
    return 'Следващо: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Бюджети и цели';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Задайте месечни лимити за разходи и следете целите си за спестяване';

  @override
  String get budgetsScreenTitle => 'Бюджети и цели';

  @override
  String get budgetsSectionCategoryBudgets => 'Бюджети по категории';

  @override
  String get budgetsSectionGoals => 'Цели за спестяване';

  @override
  String get budgetsNoLimitSet => 'Няма зададен лимит';

  @override
  String get budgetsSetLimit => 'Задай лимит';

  @override
  String get budgetsEditLimit => 'Редактирай лимит';

  @override
  String get budgetsMonthlyLimit => 'Месечен лимит';

  @override
  String get budgetsOverBudget => 'Надвишен бюджет';

  @override
  String get budgetsNoBudgetsHint =>
      'Задайте месечен лимит за която да е категория по-долу, за да следите разходите си спрямо него.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Премахване на този лимит?';

  @override
  String get budgetsDeleteLimitConfirmBody =>
      'Можете да зададете нов по всяко време.';

  @override
  String get budgetsAddGoal => 'Добави цел';

  @override
  String get budgetsGoalName => 'Име на целта';

  @override
  String get budgetsTargetAmount => 'Целева сума';

  @override
  String get budgetsTargetDateOptional => 'Целева дата (незадължително)';

  @override
  String get budgetsNoTargetDate => 'Без целева дата';

  @override
  String get budgetsAddProgress => 'Добави напредък';

  @override
  String get budgetsProgressAmountLabel => 'Сума за добавяне';

  @override
  String get budgetsGoalComplete => 'Целта е постигната!';

  @override
  String get budgetsNoGoalsYet =>
      'Все още няма цели за спестяване. Добавете една, за да проследявате напредъка към нещо конкретно.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Изтриване на тази цел?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'Това не може да бъде отменено.';

  @override
  String get budgetsProgressExplanation =>
      'Напредъкът се обновява само когато го добавите ръчно тук — това приложение няма банкова връзка, така че нищо не се проследява автоматично.';

  @override
  String get expenseInsightsTitle => 'Прозрения';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Разходите са с $percent% по-високи от миналия месец ($current срещу $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Разходите са с $percent% по-ниски от миналия месец ($current срещу $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Разходите са подобни на миналия месец ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category е вашата най-голяма категория разходи този месец, с $percent% от общите разходи.';
  }

  @override
  String get expenseInsightHowCalculated => 'Вижте изчислението';

  @override
  String expenseInsightCounter(int current, int total) {
    return '$current от $total';
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
    return '$categoryAmount ÷ $total общо × 100 = $percent%';
  }

  @override
  String get expenseExportCsv => 'Изнеси CSV';

  @override
  String get expenseExportCopied =>
      'CSV е копиран в клипборда — поставете го в таблица или бележки';

  @override
  String get expenseExportEmpty => 'Няма транзакции този месец за изнасяне';

  @override
  String get settingsDataManagementTitle => 'Управление на данни';

  @override
  String get settingsExportAllData => 'Изнеси всички данни (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Копирайте транзакции, сценарии, бюджети и цели в клипборда';

  @override
  String get settingsExportAllDataEmpty => 'Все още няма данни за изнасяне';

  @override
  String get settingsExportAllDataDone =>
      'Всички данни са копирани в клипборда';

  @override
  String get settingsDeleteAllData => 'Изтрий всички локални данни';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Трайно изтрийте транзакции, сценарии, бюджети и цели от това устройство';

  @override
  String get settingsDeleteAllDataDialog1Title =>
      'Да се изтрият ли всички локални данни?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'Това трайно премахва всяка транзакция, запазен сценарий, бюджет по категория и цел за спестяване, съхранени на това устройство. Това не може да бъде отменено. Вашата история на изчисления също ще бъде изтрита.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Абсолютно сигурни ли сте?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'Това е последният ви шанс да отмените. След това няма начин да възстановите тези данни.';

  @override
  String get settingsDeleteAllDataConfirm => 'Изтрий всичко';

  @override
  String get settingsDeleteAllDataDone => 'Всички локални данни са изтрити';

  @override
  String get settingsOfflineStatusTitle => 'Работи напълно офлайн';

  @override
  String get settingsOfflineStatusBody =>
      'Това приложение няма акаунт, облачна синхронизация или сървър — всичко, което въведете, остава само на това устройство. Курсът за конвертиране на валута е единствената функция, която се нуждае от интернет връзка; ако сте офлайн, се използва последният известен курс.';

  @override
  String get toolsInvoicesTitle => 'Фактури';

  @override
  String get toolsInvoicesSubtitle =>
      'Следете какво ви дължат клиентите — платено, неплатено и просрочено';

  @override
  String get invoicesScreenTitle => 'Фактури';

  @override
  String get invoicesEmptyState =>
      'Все още няма фактури. Докоснете +, за да добавите първата.';

  @override
  String get invoiceOutstanding => 'Неплатено';

  @override
  String get invoiceOverdue => 'Просрочено';

  @override
  String get invoiceFilterAll => 'Всички';

  @override
  String get invoiceFilterUnpaid => 'Неплатени';

  @override
  String get invoiceFilterOverdue => 'Просрочени';

  @override
  String get invoiceFilterPaid => 'Платени';

  @override
  String get invoiceStatusPaid => 'Платено';

  @override
  String get invoiceStatusUnpaid => 'Неплатено';

  @override
  String get invoiceStatusOverdue => 'Просрочено';

  @override
  String get invoiceDueLabel => 'Падеж';

  @override
  String get invoiceMarkPaid => 'Маркирай като платено';

  @override
  String get invoiceMarkUnpaid => 'Маркирай като неплатено';

  @override
  String get invoiceDeleteConfirmTitle => 'Да се изтрие ли тази фактура?';

  @override
  String get invoiceDeleteConfirmBody => 'Това не може да бъде отменено.';

  @override
  String get invoiceAddTitle => 'Добави фактура';

  @override
  String get invoiceEditTitle => 'Редактирай фактура';

  @override
  String get invoiceClientName => 'Име на клиент';

  @override
  String get invoiceDescription => 'Описание (незадължително)';

  @override
  String get invoiceAmount => 'Сума';

  @override
  String get invoiceIssueDate => 'Дата на издаване';

  @override
  String get invoiceDueDate => 'Дата на падеж';

  @override
  String get invoiceNumberLabel => 'Номер на фактура (незадължително)';

  @override
  String get invoiceAddItem => 'Добави артикул';

  @override
  String get invoiceItemDescription => 'Описание';

  @override
  String get invoiceItemQuantity => 'Кол.';

  @override
  String get invoiceItemUnitPrice => 'Ед. цена';

  @override
  String get invoiceItemSubtotal => 'Сума';

  @override
  String get invoiceAmountFromItemsHelper =>
      'Изчислено въз основа на артикулите по-долу';

  @override
  String get invoiceRemoveItemTooltip => 'Премахни артикул';

  @override
  String get invoiceGeneratePdf => 'Генерирай PDF';

  @override
  String get invoicePdfError =>
      'Генерирането на PDF не бе успешно. Фактурата не е променена — опитайте отново.';

  @override
  String get toolsPausalTrackerTitle => 'Проследяване на патента (Сърбия)';

  @override
  String get toolsPausalTrackerSubtitle =>
      'Проследявайте оборота спрямо тавана за патент и прага за ДДС';

  @override
  String get pausalTrackerCeilingCardTitle =>
      'Таван за патент (тази календарна година)';

  @override
  String get pausalTrackerVatCardTitle =>
      'Праг за регистрация по ДДС (последните 12 месеца)';

  @override
  String get pausalTrackerStateOk => 'В норма';

  @override
  String get pausalTrackerStateWarning70 =>
      'Достигнати 70% — заслужава наблюдение';

  @override
  String get pausalTrackerStateWarning85 =>
      'Достигнати 85% — обърнете специално внимание';

  @override
  String get pausalTrackerStateWarning95 =>
      'Достигнати 95% — вероятно скоро ще е нужно действие';

  @override
  String get pausalTrackerStateExceeded => 'Надвишено';

  @override
  String pausalTrackerProjection(String date) {
    return 'При текущия темп бихте достигнали тавана за патент около $date.';
  }

  @override
  String pausalTrackerExcludedBanner(int count) {
    return '$count фактура(и) изключени — липсва обменен курс';
  }

  @override
  String get pausalTrackerSeeBreakdown => 'Вижте изчисленията';

  @override
  String get pausalTrackerBreakdownTitle => 'Как е изчислено това';

  @override
  String get pausalTrackerBreakdownExcludedHeader =>
      'Изключени — липсва обменен курс';

  @override
  String pausalTrackerBreakdownRateLabel(String source) {
    return 'курс: $source';
  }

  @override
  String get pausalTrackerBreakdownExcludedReason =>
      'За тази фактура не можа да се получи обменен курс — изключена е от общата сума, вместо да бъде оценена приблизително.';

  @override
  String get pausalTrackerAssessedAmountLabel =>
      'Определена месечна сума на патента';

  @override
  String get pausalTrackerAssessedAmountHint =>
      'По желание — въведете сумата от данъчното си решение. Приложението не може да я изчисли самостоятелно.';

  @override
  String get pausalTrackerAssessedAmountSaved => 'Запазено';

  @override
  String pausalTrackerAssessedAmountDecomposition(
    String tax,
    String pio,
    String health,
    String unemployment,
    String total,
  ) {
    return '= $tax данък + $pio пенсия + $health здраве + $unemployment безработица = $total от базата, определена с решението.';
  }

  @override
  String get commonClearSearch => 'Изчисти търсенето';

  @override
  String get expensePreviousMonth => 'Предишен месец';

  @override
  String get expenseNextMonth => 'Следващ месец';

  @override
  String get homeExpenseTrackerTitle => 'Този месец';

  @override
  String get homeExpenseTrackerCtaEmpty => 'Следете приходите и разходите си';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'Проследени са повече валути — докоснете, за да видите всички';

  @override
  String get catHousing => 'Жилище и наем';

  @override
  String get catUtilities => 'Комунални услуги';

  @override
  String get catGroceries => 'Хранителни стоки';

  @override
  String get catTransport => 'Транспорт';

  @override
  String get catHealth => 'Здраве';

  @override
  String get catEducation => 'Образование';

  @override
  String get catEntertainment => 'Забавления';

  @override
  String get catOtherExpense => 'Друго';

  @override
  String get catSalary => 'Заплата';

  @override
  String get catFreelance => 'Фрийланс / бизнес';

  @override
  String get catOtherIncome => 'Други приходи';
}
