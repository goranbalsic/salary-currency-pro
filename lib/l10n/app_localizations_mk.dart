// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Macedonian (`mk`).
class AppLocalizationsMk extends AppLocalizations {
  AppLocalizationsMk([String locale = 'mk']) : super(locale);

  @override
  String get appTitle => 'Salary & Currency Pro';

  @override
  String get navHome => 'Почетна';

  @override
  String get navConvert => 'Конверзија';

  @override
  String get navSalary => 'Плата';

  @override
  String get navTools => 'Алатки';

  @override
  String get navSettings => 'Поставки';

  @override
  String themeToggleTooltip(String mode) {
    return 'Смени тема ($mode)';
  }

  @override
  String get themeModeSystem => 'системска';

  @override
  String get themeModeLight => 'светла';

  @override
  String get themeModeDark => 'темна';

  @override
  String get onboardingSkip => 'Прескокни';

  @override
  String get onboardingContinue => 'Продолжи';

  @override
  String get onboardingGetStarted => 'Започни';

  @override
  String get onboardingWelcomeTitle => 'Добредојде';

  @override
  String get onboardingWelcomeSubtitle =>
      'Изберете држава и јазик за да започнете. Ова можете да го промените во секое време во Поставки.';

  @override
  String get onboardingCountryLabel => 'Држава';

  @override
  String get onboardingPrivacyTitle =>
      'Вашите податоци остануваат на телефонот';

  @override
  String get onboardingPrivacyBody =>
      'Без сметка. Без синхронизација во облак. Без сервер. Сè што внесувате — плати, трошоци, фактури — останува само на овој уред. Конверзијата на валути е единствената функција на која ѝ треба интернет врска; без неа се користи последниот познат курс.';

  @override
  String get onboardingGoalTitle => 'Што ве доведе овде?';

  @override
  String get onboardingGoalSubtitle =>
      'Ќе го прилагодиме почетниот екран според тоа — сè останато остана на дофат.';

  @override
  String get onboardingGoalSalaryTitle => 'Плата и пресметка на заработка';

  @override
  String get onboardingGoalSalaryDesc =>
      'Пресметајте нето од бруто плата за 9 земји';

  @override
  String get onboardingGoalExpensesTitle => 'Следење приходи и трошоци';

  @override
  String get onboardingGoalExpensesDesc =>
      'Бележете трошоци, поставете буџети, остварете цели за штедење';

  @override
  String get onboardingGoalBusinessTitle => 'Слободна професија и бизнис';

  @override
  String get onboardingGoalBusinessDesc => 'Фактури, исплати и деловни алатки';

  @override
  String get commonCalculate => 'Пресметај';

  @override
  String get commonConvert => 'Конвертирај';

  @override
  String get commonRetry => 'Обиди се повторно';

  @override
  String get commonSwapCurrencies => 'Замени валути';

  @override
  String get commonSomethingWentWrong => 'Нешто тргна наопаку.';

  @override
  String get commonFrom => 'Од';

  @override
  String get commonTo => 'До';

  @override
  String get commonAmount => 'Износ';

  @override
  String get convertCardTitle => 'Конверзија';

  @override
  String get convertEmptyState =>
      'Внесете износ и притиснете Конвертирај за да го видите реалниот, тековен курс.';

  @override
  String convertLiveRate(String source, String formatted) {
    return 'Тековен курс од $source · $formatted';
  }

  @override
  String convertCachedRate(String formatted, String source) {
    return 'Зачуван курс од $formatted (офлајн) · $source';
  }

  @override
  String get convertAmountIssueEmpty => 'Внесете износ.';

  @override
  String get convertAmountIssueInvalid => 'Тоа не изгледа како валиден број.';

  @override
  String get convertAmountIssueNegative => 'Износот не може да биде негативен.';

  @override
  String get convertAmountIssueZero => 'Износот мора да биде поголем од нула.';

  @override
  String get convertAmountIssueTooLarge =>
      'Тоа изгледа необично големо за износ — проверете дали не е грешка при внесувањето.';

  @override
  String salaryTitle(String country) {
    return 'Калкулатор за плата — $country';
  }

  @override
  String salaryParamsLine(int year, String date) {
    return 'Параметри за $year. · на сила од $date';
  }

  @override
  String get salaryModeGrossToNet => 'Бруто → Нето';

  @override
  String get salaryModeNetToGross => 'Нето → Бруто';

  @override
  String salaryGrossLabel(String currencyCode) {
    return 'Бруто плата, $currencyCode';
  }

  @override
  String salaryNetLabel(String currencyCode) {
    return 'Нето плата, $currencyCode';
  }

  @override
  String get salaryEmptyState =>
      'Внесете плата и притиснете Пресметај за целосна пресметка.';

  @override
  String get salaryNeto => 'Нето (за исплата)';

  @override
  String get salaryBruto => 'Бруто (плата)';

  @override
  String get salaryAllowance => 'Лично ослободување';

  @override
  String get salaryTaxableBase => 'Даночна основа';

  @override
  String get salaryIncomeTax => 'Персонален данок';

  @override
  String get salaryLocalSurtax => 'Локален надомест';

  @override
  String get salaryEmployeeContribTotal => 'Придонеси на вработениот (вкупно)';

  @override
  String get salaryEmployerContribTotal =>
      'Придонеси на работодавачот (вкупно)';

  @override
  String get salaryBruto2 => 'Бруто 2 (вкупен трошок за работодавачот)';

  @override
  String salarySurtaxLabel(String rate) {
    return 'Локален надомест: $rate% — поставете ја стапката на вашата општина';
  }

  @override
  String get salaryDisclaimer =>
      'Ова е проценка исклучиво за информативни цели и не претставува даночен, правен или финансиски совет. Вистинските обврски може да се разликуваат во зависност од вашата конкретна ситуација — консултирајте се со лиценциран сметководител или надлежната даночна управа пред да донесете одлуки.';

  @override
  String salaryNegativeNetoFloored(String base) {
    return 'Овој бруто износ е под законски пропишаната минимална основа за придонеси ($base). Задолжителните придонеси сами по себе ја достигнуваат или надминуваат оваа плата, па износот за исплата е нула или негативен — ова ниво на плата не е практично формално да се пријави.';
  }

  @override
  String get salaryNegativeNetoGeneric =>
      'На ова ниво на приход, задолжителните придонеси и данокот заедно ја достигнуваат или надминуваат бруто платата, па износот за исплата е нула или негативен.';

  @override
  String salaryConfigError(String country) {
    return 'Не може да се вчита даночната конфигурација за $country.';
  }

  @override
  String get salaryAmountIssueEmpty => 'Внесете плата.';

  @override
  String get salaryAmountIssueInvalid => 'Тоа не изгледа како валиден број.';

  @override
  String get salaryAmountIssueNegative => 'Платата не може да биде негативна.';

  @override
  String get salaryAmountIssueZero => 'Платата мора да биде поголема од нула.';

  @override
  String get salaryAmountIssueTooLarge =>
      'Тоа изгледа необично големо за плата — проверете дали не е грешка при внесувањето.';

  @override
  String get toolsHubTitle => 'Финансиски алатки';

  @override
  String get toolsLoanTitle => 'Кредити и долгови';

  @override
  String get toolsSavingsTitle => 'Заштеда и раст';

  @override
  String get toolsVatTitle => 'ДДВ калкулатор';

  @override
  String get toolsBudgetTitle => 'Планер за буџет';

  @override
  String get toolsFreelancerPayoutTitle => 'Исплата на фриленсер';

  @override
  String get toolsFreelanceTaxTitle => 'Самооданочување на фриленсери';

  @override
  String get homeQuoteOfDay => 'Цитат на денот';

  @override
  String get homeQuickActions => 'Брзи дејства';

  @override
  String get settingsLanguage => 'Јазик';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsAbout => 'За апликацијата';

  @override
  String get settingsSystemDefault => 'Системско стандардно';

  @override
  String get settingsNotificationsTitle => 'Известувања';

  @override
  String get notifExpenseNudgeTitle => 'Евидентирај трошоци';

  @override
  String get notifExpenseNudgeSubtitle =>
      'Дневен вечерен потсетник да ги внесете денешните приходи и трошоци';

  @override
  String get notifExpenseNudgeNotifTitle => 'Внесете ги денешните трошоци?';

  @override
  String get notifExpenseNudgeNotifBody =>
      'Додадете ги денешните приходи и трошоци пред да заборавите.';

  @override
  String get notifBudgetThresholdTitle => 'Известувања за буџет';

  @override
  String get notifBudgetThresholdSubtitle =>
      'Известувај кога буџетот на категорија ќе достигне 80% или 100%';

  @override
  String notifBudgetThresholdNotifTitle(String category, int percent) {
    return '$category: $percent% од буџетот';
  }

  @override
  String notifBudgetThresholdNotifBody(String category, int percent) {
    return 'Потрошивте $percent% од буџетот за $category овој месец.';
  }

  @override
  String get notifInvoiceDueTitle => 'Потсетници за фактури';

  @override
  String get notifInvoiceDueSubtitle =>
      'Известувај еден ден пред рокот на фактура';

  @override
  String get notifInvoiceDueNotifTitle => 'Фактура доспева утре';

  @override
  String notifInvoiceDueNotifBody(
    String client,
    String amount,
    String currency,
  ) {
    return '$client: $amount $currency доспева утре.';
  }

  @override
  String get notifPausalReminderTitle => 'Потсетник за паушал (Србија)';

  @override
  String get notifPausalReminderSubtitle =>
      'Месечен потсетник на 15-ти за пријавување на паушалните обврски';

  @override
  String get notifPausalReminderNotifTitle => 'Потсетник за пријава на паушал';

  @override
  String get notifPausalReminderNotifBody =>
      'Не заборавајте ја месечната пријава и уплата на паушалот.';

  @override
  String get settingsWidgetsTitle => 'Виџети на почетниот екран';

  @override
  String get settingsWidgetsExplainer =>
      'Додајте виџет од почетниот екран на уредот (притиснете и задржете на празен простор → Виџети → Salary & Currency Pro) — апликацијата не може сама да го додаде. По додавањето, се ажурира автоматски.';

  @override
  String get settingsWidgetsPinnedPairTitle => 'Закачен валутен пар за виџетот';

  @override
  String get homeWidgetBudgetLabel => 'Потрошено овој месец';

  @override
  String get homeWidgetBudgetEmpty =>
      'Поставете буџет во апликацијата за да го видите тука';

  @override
  String get homeWidgetPairUnavailable =>
      'Освежувањето не успеа — прикажан е последниот познат курс';

  @override
  String get countryRs => 'Србија';

  @override
  String get countryHr => 'Хрватска';

  @override
  String get countryBa => 'Босна и Херцеговина';

  @override
  String get countryMe => 'Црна Гора';

  @override
  String get countryMk => 'Северна Македонија';

  @override
  String get countrySi => 'Словенија';

  @override
  String get countryBg => 'Бугарија';

  @override
  String get countryAl => 'Албанија';

  @override
  String get countryRo => 'Романија';

  @override
  String get entityFbih => 'Федерација на БиХ';

  @override
  String get entityRepublikaSrpska => 'Република Српска';

  @override
  String get contribPio => 'ПИО (пензиско и инвалидско)';

  @override
  String get contribHealth => 'Здравствено осигурување';

  @override
  String get contribUnemployment => 'Осигурување за случај на невработеност';

  @override
  String get contribPension => 'Пензиско осигурување';

  @override
  String get contribSocial => 'Социјално осигурување';

  @override
  String get contribChildProtection => 'Придонес за детска заштита';

  @override
  String get contribHealthAndEmployment =>
      'Здравствено и осигурување за вработување';

  @override
  String get contribCas => 'CAS (пензиско осигурување)';

  @override
  String get contribCass => 'CASS (здравствено осигурување)';

  @override
  String get contribCam => 'CAM (осигурување за работа)';

  @override
  String get suffixEmployee => 'вработен';

  @override
  String get suffixEmployer => 'работодавач';

  @override
  String get toolsLoanSubtitle => 'Месечна рата, рок на отплата, амортизација';

  @override
  String get toolsSavingsSubtitle => 'Сложена камата со редовни уплати';

  @override
  String get toolsVatSubtitle =>
      'Додадете или одземете ДДВ по стапката на вашата земја';

  @override
  String get toolsBudgetSubtitle =>
      'Поделете го месечниот приход на потреби / желби / штедење';

  @override
  String get toolsFreelancerPayoutSubtitle =>
      'Странска фактура → провизии → реална локална исплата';

  @override
  String get toolsFreelanceTaxSubtitle =>
      'Данок и придонеси за фриленсери, 9 земји';

  @override
  String get loanScreenTitle => 'Кредити и долгови';

  @override
  String get loanModePayment => 'Рата од рок на отплата';

  @override
  String get loanModePayoff => 'Рок на отплата од рата';

  @override
  String get loanPrincipal => 'Износ на кредит (главница)';

  @override
  String get loanRate => 'Годишна каматна стапка (%)';

  @override
  String get loanTermMonths => 'Рок на отплата (месеци)';

  @override
  String get loanFixedPayment => 'Фиксна месечна рата';

  @override
  String get loanErrorPrincipalRate =>
      'Внесете валидна главница и каматна стапка.';

  @override
  String get loanErrorTerm => 'Внесете валиден рок на отплата во месеци.';

  @override
  String get loanErrorPayment => 'Внесете валидна месечна рата.';

  @override
  String get loanErrorTooLow =>
      'Оваа рата е премала за да го отплати долгот некогаш — не ја покрива ни каматата што се пресметува секој месец.';

  @override
  String get loanMonthlyPayment => 'Месечна рата';

  @override
  String get loanTotalPaid => 'Вкупно платено';

  @override
  String get loanTotalInterest => 'Вкупна камата';

  @override
  String get loanNumberOfPayments => 'Број на рати';

  @override
  String get loanTimeToPayOff => 'Време до отплата';

  @override
  String loanMonthsCount(int months) {
    return '$months месеци';
  }

  @override
  String get savingsScreenTitle => 'Заштеда и раст';

  @override
  String get savingsStartingAmount => 'Почетен износ';

  @override
  String get savingsMonthlyContribution => 'Месечна уплата';

  @override
  String get savingsExpectedReturn => 'Очекуван годишен принос (%)';

  @override
  String get savingsTimeHorizon => 'Временски период (години)';

  @override
  String get savingsErrorRateYears =>
      'Внесете валидна годишна стапка и број на години.';

  @override
  String get savingsFutureValue => 'Идна вредност';

  @override
  String get savingsTotalContributed => 'Вкупно уплатено';

  @override
  String get savingsInterestEarned => 'Заработена камата';

  @override
  String get vatScreenTitle => 'ДДВ калкулатор';

  @override
  String get vatStandardRateFor => 'Стандардна стапка за';

  @override
  String get vatAdd => 'Додади ДДВ';

  @override
  String get vatRemove => 'Отстрани ДДВ';

  @override
  String get vatNetAmount => 'Нето износ (без ДДВ)';

  @override
  String get vatGrossAmount => 'Бруто износ (со ДДВ)';

  @override
  String get vatRateEditable =>
      'Стапка на ДДВ (%) — може да се измени за намалени стапки';

  @override
  String get vatGrossWithVat => 'Бруто (со ДДВ)';

  @override
  String get vatAmountLabel => 'Износ на ДДВ';

  @override
  String get vatNetWithoutVat => 'Нето (без ДДВ)';

  @override
  String vatRatesAsOf(String date) {
    return 'Стандардна стапка од $date';
  }

  @override
  String get budgetScreenTitle => 'Планер за буџет';

  @override
  String get budgetMonthlyIncome => 'Месечен нето приход';

  @override
  String get budgetSplit => 'Поделба';

  @override
  String get budgetPresetSuffix => '(потреби/желби/штедење)';

  @override
  String get budgetNeeds => 'Потреби';

  @override
  String get budgetWants => 'Желби';

  @override
  String get budgetSavings => 'Штедење';

  @override
  String get freelancerScreenTitle =>
      'Проверка на реалната исплата на фриленсер';

  @override
  String get freelancerInvoiceAmount => 'Износ на фактура';

  @override
  String get freelancerCurrency => 'Валута';

  @override
  String get freelancerPlatform => 'Платформа';

  @override
  String get freelancerPlatformCustom => 'Прилагодено';

  @override
  String get freelancerPlatformDirect => 'Директен клиент / трансфер (0%)';

  @override
  String get freelancerPlatformFee => 'Провизија на платформата (%)';

  @override
  String freelancerBankFeeFlat(String currency) {
    return 'Банкарска провизија (фиксна, $currency)';
  }

  @override
  String get freelancerBankFeePercent => 'Банкарска провизија (%)';

  @override
  String get freelancerPayoutCurrency => 'Валута на исплата';

  @override
  String get freelancerCalculateButton => 'Пресметај реална исплата';

  @override
  String get freelancerErrorInvoice => 'Внесете валиден износ на фактура.';

  @override
  String freelancerErrorUnexpected(String error) {
    return 'Неочекувана грешка: $error';
  }

  @override
  String get freelancerRealPayout => 'Реална исплата';

  @override
  String get freelancerInvoiceAmountRow => 'Износ на фактура';

  @override
  String get freelancerPlatformFeeRow => 'Провизија на платформата';

  @override
  String get freelancerBankFeeRow => 'Банкарска провизија';

  @override
  String get freelancerNetForeignAmount => 'Нето износ во странска валута';

  @override
  String get samoFixedModel => 'Модел со фиксен трошок';

  @override
  String get samoMixedModel => 'Модел со мешан трошок';

  @override
  String get samoCheaperSame => 'Овој модел е поевтината опција за овој износ.';

  @override
  String get samoCheaperOther =>
      'Другиот модел би произвел помал данок за овој износ — моделите може слободно да ги менувате секој квартал.';

  @override
  String get freelanceTaxScreenTitle => 'Самооданочување на фриленсери';

  @override
  String get freelanceTaxCountryLabel => 'Земја / режим';

  @override
  String get freelanceTaxIncomeLabelQuarterly => 'Квартален бруто приход';

  @override
  String get freelanceTaxIncomeLabelAnnual => 'Годишен бруто приход';

  @override
  String get freelanceTaxNetIncome => 'Нето приход';

  @override
  String get freelanceTaxGrossIncomeRow => 'Бруто приход';

  @override
  String get freelanceTaxDeductionRow => 'Одбивка';

  @override
  String get freelanceTaxTaxableBaseRow => 'Даночна основа';

  @override
  String get freelanceTaxIncomeTaxRow => 'Данок на доход';

  @override
  String get freelanceTaxContributionsTotalRow => 'Вкупно придонеси';

  @override
  String freelanceTaxRulesVersionBundle(String date) {
    return 'Стапки вградени во апликацијата · верзија $date';
  }

  @override
  String freelanceTaxRulesVersionUpdated(String date) {
    return 'Стапки ажурирани онлајн · верзија $date';
  }

  @override
  String freelanceTaxSourcesLabel(String sources) {
    return 'Извори: $sources';
  }

  @override
  String get freelanceTaxNotAvailable => 'Не е достапно';

  @override
  String get freelanceTaxModelLabel => 'Модел';

  @override
  String get freelanceTaxVariantLabel => 'Тип';

  @override
  String get freelanceTaxActivityCategoryLabel => 'Категорија на дејност';

  @override
  String get freelanceFbihCategoryFreeProfessions => 'Слободни професии';

  @override
  String get freelanceFbihCategoryObrt => 'Занаетчиска дејност (obrt)';

  @override
  String get freelanceFbihCategoryAgriculture => 'Земјоделство / шумарство';

  @override
  String get freelanceFbihCategoryLumpSumObrt => 'Паушален занает';

  @override
  String get freelanceFbihCategoryTraditionalCraftsTaxi =>
      'Традиционни занаети / такси';

  @override
  String get freelanceTaxCategoryLabel => 'Категорија';

  @override
  String get freelanceBaRsCategoryStandard => 'Стандарден претприемач';

  @override
  String get freelanceBaRsCategoryIndependentProfessions =>
      'Независни професии';

  @override
  String get freelanceBaRsCategorySupplementary =>
      'Дополнителна дејност / пензионер';

  @override
  String get freelanceTaxMunicipalityLabel => 'Општина';

  @override
  String get freelanceMeMunicipalityPodgoricaCetinje => 'Подгорица / Цетиње';

  @override
  String get freelanceMeMunicipalityBudva => 'Будва';

  @override
  String get freelanceMeMunicipalityOther => 'Друга општина';

  @override
  String freelanceCliffVatThreshold(String amount, String currency) {
    return 'Праг за регистрација на ДДВ: $amount $currency';
  }

  @override
  String freelanceCliffAlbaniaZeroTax(String amount, String currency) {
    return 'Стапката од 0% данок на доход важи само до промет од $amount $currency — над тоа целиот профит се оданочува прогресивно, не само вишокот.';
  }

  @override
  String freelanceCliffSloveniaNormirani(String amount, String currency) {
    return 'Олеснувањето од 80% признати трошоци важи само до приход од $amount $currency.';
  }

  @override
  String freelanceCliffSloveniaPopoldanski(String amount, String currency) {
    return 'Правото на popoldanski s.p. престанува при приход од $amount $currency.';
  }

  @override
  String freelanceCliffSerbiaPausal(String amount, String currency) {
    return 'Алтернативниот паушален статус е ограничен на $amount $currency — само информативно, овој калкулатор не го моделира.';
  }

  @override
  String get freelanceCliffStatusApproaching => 'Сè уште не е достигнато';

  @override
  String get freelanceCliffStatusCrossed => 'Надминато';

  @override
  String get settingsProActive => 'Pro — активно';

  @override
  String get settingsProInactive => 'Pro';

  @override
  String get settingsProSubtitleActive =>
      'Рекламите се исклучени во целата апликација';

  @override
  String get settingsProSubtitleInactive =>
      'Отстранете ги рекламите со достапна претплата';

  @override
  String get settingsTrustTitle => 'Зошто да се верува на оваа апликација?';

  @override
  String get settingsTrustBody =>
      'Податоците за плати, ДДВ и самооданочување доаѓаат од цитирани државни и професионални даночни извори, не се проценки. Секој калкулатор ја прикажува годината за која важат бројките и датумот на стапување во сила, за да можете веднаш да ја процените нивната ажурност. Погледнете „Приватност и податоци“ и „Работи целосно офлајн“ подолу за начинот на кој се обработуваат вашите податоци.';

  @override
  String get settingsAdPrivacyTitle => 'Приватност и реклами';

  @override
  String get settingsAdPrivacySubtitle =>
      'Прегледајте или променете го вашиот избор за согласност за реклами';

  @override
  String get settingsAdPrivacyUnavailable =>
      'Опциите за приватност на реклами не се достапни на оваа платформа.';

  @override
  String get settingsAdPrivacyNotRequired =>
      'За вашиот регион не е потребен избор за приватност на реклами.';

  @override
  String get settingsAboutBody =>
      'Salary & Currency Pro опфаќа пресметка на плата, конверзија на валути и секојдневни финансиски калкулатори за Србија, Хрватска, Босна и Херцеговина, Црна Гора, Северна Македонија, Словенија, Бугарија, Албанија и Романија. Сите бројки се извор наведени и датирани — погледнете ја напомената на секој калкулатор за детали. Оваа апликација дава само проценки, а не стручен совет.';

  @override
  String get paywallTitle => 'Стани Pro';

  @override
  String get paywallHeadline => 'Salary & Currency Pro';

  @override
  String get paywallPitch =>
      'Отстранете ги сите реклами во секој калкулатор, по достапна месечна цена. Сите земји за пресметка на плата, конверзија на валути и финансиски алатки остануваат бесплатни во секој случај.';

  @override
  String get paywallActiveMessage =>
      'Вие сте Pro корисник — ви благодариме! Рекламите се исклучени во целата апликација.';

  @override
  String get paywallStoreUnavailable =>
      'Продавницата моментално не е достапна (ова е очекувано во развојни верзии без конфигурирана Play Console листа). Pro ќе биде достапен за купување откако ќе биде објавен.';

  @override
  String get paywallProductUnavailable =>
      'Pro претплатата сè уште не е поставена во продавницата — ова е привремен екран додека вистинскиот производ не се креира во Play Console.';

  @override
  String get paywallSubscribe => 'Претплати се';

  @override
  String get paywallProcessing => 'Обработка…';

  @override
  String paywallPurchaseFailed(String error) {
    return 'Купувањето не успеа: $error';
  }

  @override
  String get paywallRestorePurchase => 'Врати купување';

  @override
  String get chartTakeHome => 'За исплата';

  @override
  String get chartTax => 'Данок';

  @override
  String get chartContributions => 'Придонеси';

  @override
  String get homeRecentlyUsed => 'Неодамна користено';

  @override
  String get categoryLoansSavings => 'Кредити и штедење';

  @override
  String get categoryBudgetTax => 'Буџетирање и даноци';

  @override
  String get categoryFreelance => 'Фриленсинг';

  @override
  String get toolsSearchHint => 'Пребарување алатки';

  @override
  String get toolsSearchNoResults => 'Не се пронајдени алатки';

  @override
  String get homeLastSalaryTitle => 'Последна пресметка на плата';

  @override
  String get homeLastSalaryEmpty => 'Сè уште немате пресметано плата.';

  @override
  String get homeLastSalaryCta => 'Пресметај сега';

  @override
  String get settingsPrivacyTitle => 'Приватност и податоци';

  @override
  String get settingsPrivacyNote =>
      'Историјата на пресметки се чува само на овој уред и никогаш не се испраќа или споделува. Со бришење на историјата или деинсталирање на апликацијата, таа трајно се отстранува.';

  @override
  String get settingsClearHistory => 'Избриши историја';

  @override
  String get settingsClearHistorySubtitle =>
      'Отстрани ги сите неодамнешни пресметки од Почетна и Алатки';

  @override
  String get settingsClearHistoryDialogTitle => 'Да се избрише историјата?';

  @override
  String get settingsClearHistoryDialogBody =>
      'Ова ги отстранува сите неодамнешни активности од Почетна и Алатки. Ова дејство не може да се врати.';

  @override
  String get settingsClearHistoryDialogCancel => 'Откажи';

  @override
  String get settingsClearHistoryDialogConfirm => 'Избриши';

  @override
  String get settingsClearHistoryDone => 'Историјата е избришана';

  @override
  String get commonCancel => 'Откажи';

  @override
  String get commonSave => 'Зачувај';

  @override
  String get commonDelete => 'Избриши';

  @override
  String get commonRename => 'Преименувај';

  @override
  String get commonUndo => 'Врати';

  @override
  String get scenarioSaveTooltip => 'Зачувај ја оваа пресметка';

  @override
  String get scenarioSaveDialogTitle => 'Зачувај пресметка';

  @override
  String get scenarioNameLabel => 'Име';

  @override
  String get scenarioSavedConfirmation => 'Сценариото е зачувано';

  @override
  String get scenarioLimitTitle => 'Достигнат бесплатен лимит';

  @override
  String scenarioLimitBody(int limit) {
    return 'Бесплатните сметки можат да зачуваат до $limit сценарија. Надградете на Pro за неограничено зачувување, споредба и извоз.';
  }

  @override
  String get scenarioLimitUpgrade => 'Надгради на Pro';

  @override
  String get myScenariosTitle => 'Мои сценарија';

  @override
  String myScenariosSubtitle(int count) {
    return '$count зачувани';
  }

  @override
  String get myScenariosSubtitleEmpty => 'Нема зачувани сценарија';

  @override
  String get myScenariosEmptyState =>
      'Зачувајте пресметка од која било алатка за да ја видите тука.';

  @override
  String get scenarioRenameDialogTitle => 'Преименувај сценарио';

  @override
  String get scenarioDeleteDialogTitle => 'Да се избрише сценариото?';

  @override
  String get scenarioDeleteDialogBody => 'Ова не може да се врати.';

  @override
  String get categoryTracking => 'Следење и планирање';

  @override
  String get toolsExpenseTrackerTitle => 'Преглед на трошоци';

  @override
  String get toolsExpenseTrackerSubtitle =>
      'Евидентирајте приходи и трошоци, следете го месечниот биланс';

  @override
  String get expenseScreenTitle => 'Преглед на трошоци';

  @override
  String get expenseIncome => 'Приходи';

  @override
  String get expenseExpenses => 'Трошоци';

  @override
  String get expenseBalance => 'Биланс';

  @override
  String get expenseEmptyState =>
      'Сè уште нема трансакции овој месец. Допрете + за да додадете прв приход или трошок.';

  @override
  String get expenseAddIncome => 'Додај приход';

  @override
  String get expenseAddExpense => 'Додај трошок';

  @override
  String get expenseAmount => 'Износ';

  @override
  String get expenseCategory => 'Категорија';

  @override
  String get expenseNote => 'Забелешка (опционално)';

  @override
  String get expenseDate => 'Датум';

  @override
  String get expenseDeleteConfirmTitle => 'Да се избрише оваа трансакција?';

  @override
  String get expenseDeleteConfirmBody =>
      'Ќе имате кратка можност да го вратите ова веднаш потоа.';

  @override
  String get expenseDeletedConfirmation => 'Трансакцијата е избришана';

  @override
  String get expenseEditTransaction => 'Уреди трансакција';

  @override
  String get expenseSearchHint => 'Пребарај забелешки или категории';

  @override
  String get expenseFilterAll => 'Сите';

  @override
  String get expenseSortByDate => 'Сортирај по датум';

  @override
  String get expenseSortByAmount => 'Сортирај по износ';

  @override
  String get expenseNoResults =>
      'Нема трансакции што одговараат на пребарувањето.';

  @override
  String expenseResultCount(int shown, int total) {
    return '$shown од $total';
  }

  @override
  String get expenseSpendingByCategory => 'Трошење по категорија';

  @override
  String get toolsRecurringTitle => 'Повторливи трансакции';

  @override
  String get toolsRecurringSubtitle =>
      'Кирија, претплати и други редовни плаќања — дефинирајте еднаш';

  @override
  String get recurringScreenTitle => 'Повторливи трансакции';

  @override
  String get recurringEmptyState =>
      'Сè уште нема повторливи трансакции. Додадете кирија, претплати или други редовни плаќања еднаш — ќе се внесуваат автоматски или ќе чекаат ваш преглед, по ваш избор.';

  @override
  String get recurringAddTitle => 'Нова повторлива трансакција';

  @override
  String get recurringEditTitle => 'Уредување повторлива трансакција';

  @override
  String get recurringFrequencyLabel => 'Се повторува';

  @override
  String get recurringFrequencyWeekly => 'Неделно';

  @override
  String get recurringFrequencyMonthly => 'Месечно';

  @override
  String get recurringStartDateLabel => 'Почнува';

  @override
  String get recurringAutoPostLabel => 'Автоматско внесување';

  @override
  String get recurringAutoPostSubtitle =>
      'Исклучено: прегледајте секое појавување пред да се додаде';

  @override
  String get recurringPausedLabel => 'Паузирано';

  @override
  String get recurringPauseAction => 'Паузирај';

  @override
  String get recurringResumeAction => 'Продолжи';

  @override
  String get recurringDeleteConfirmTitle =>
      'Да се избрише оваа повторлива трансакција?';

  @override
  String get recurringDeleteConfirmBody =>
      'Ова ги запира идните појавувања. Веќе внесените трансакции не се засегнати.';

  @override
  String recurringReviewBannerTitle(int count) {
    return '$count повторливи трансакции за преглед';
  }

  @override
  String get recurringReviewPost => 'Внеси';

  @override
  String get recurringReviewSkip => 'Прескокни';

  @override
  String get toolsRadarTitle => 'Радар за фиксни трошоци';

  @override
  String get toolsRadarSubtitle =>
      'Погледнете ги вкупните повторливи трошоци на едно место';

  @override
  String get radarScreenTitle => 'Радар за фиксни трошоци';

  @override
  String get radarEmptyState =>
      'Сè уште нема активни повторливи трошоци. Додадете еден во Повторливи трансакции за да го видите вкупниот фиксен трошок овде.';

  @override
  String get radarMonthlyTotal => 'Месечно вкупно';

  @override
  String get radarWeeklyTotal => 'Неделно вкупно';

  @override
  String radarNextDue(String date) {
    return 'Следно: $date';
  }

  @override
  String get toolsBudgetsGoalsTitle => 'Буџети и цели';

  @override
  String get toolsBudgetsGoalsSubtitle =>
      'Поставете месечни лимити за трошење и следете ги целите за штедење';

  @override
  String get budgetsScreenTitle => 'Буџети и цели';

  @override
  String get budgetsSectionCategoryBudgets => 'Буџети по категории';

  @override
  String get budgetsSectionGoals => 'Цели за штедење';

  @override
  String get budgetsNoLimitSet => 'Не е поставен лимит';

  @override
  String get budgetsSetLimit => 'Постави лимит';

  @override
  String get budgetsEditLimit => 'Уреди лимит';

  @override
  String get budgetsMonthlyLimit => 'Месечен лимит';

  @override
  String get budgetsOverBudget => 'Надминат буџет';

  @override
  String get budgetsNoBudgetsHint =>
      'Поставете месечен лимит за која било категорија подолу за да ја следите потрошувачката во однос на него.';

  @override
  String get budgetsDeleteLimitConfirmTitle => 'Да се отстрани овој лимит?';

  @override
  String get budgetsDeleteLimitConfirmBody =>
      'Можете да поставите нов во секое време.';

  @override
  String get budgetsAddGoal => 'Додај цел';

  @override
  String get budgetsGoalName => 'Име на целта';

  @override
  String get budgetsTargetAmount => 'Целен износ';

  @override
  String get budgetsTargetDateOptional => 'Целен датум (опционално)';

  @override
  String get budgetsNoTargetDate => 'Без целен датум';

  @override
  String get budgetsAddProgress => 'Додај напредок';

  @override
  String get budgetsProgressAmountLabel => 'Износ за додавање';

  @override
  String get budgetsGoalComplete => 'Целта е остварена!';

  @override
  String get budgetsNoGoalsYet =>
      'Сè уште нема цели за штедење. Додадете една за да почнете да го следите напредокот кон нешто конкретно.';

  @override
  String get budgetsDeleteGoalConfirmTitle => 'Да се избрише оваа цел?';

  @override
  String get budgetsDeleteGoalConfirmBody => 'Ова не може да се врати.';

  @override
  String get budgetsProgressExplanation =>
      'Напредокот се ажурира само кога рачно ќе го додадете тука — оваа апликација нема банкарска врска, па ништо не се следи автоматски.';

  @override
  String get expenseInsightsTitle => 'Согледувања';

  @override
  String expenseInsightHigherThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Трошењето е $percent% повисоко од минатиот месец ($current наспроти $previous).';
  }

  @override
  String expenseInsightLowerThanLastMonth(
    int percent,
    String current,
    String previous,
  ) {
    return 'Трошењето е $percent% пониско од минатиот месец ($current наспроти $previous).';
  }

  @override
  String expenseInsightSameAsLastMonth(String current) {
    return 'Трошењето е слично на минатиот месец ($current).';
  }

  @override
  String expenseInsightTopCategory(String category, int percent) {
    return '$category е вашата најголема категорија на трошоци овој месец, со $percent% од вкупната потрошувачка.';
  }

  @override
  String get expenseExportCsv => 'Извези CSV';

  @override
  String get expenseExportCopied =>
      'CSV е копиран во привремената меморија — залепете го во табела или белешки';

  @override
  String get expenseExportEmpty => 'Нема трансакции овој месец за извоз';

  @override
  String get settingsDataManagementTitle => 'Управување со податоци';

  @override
  String get settingsExportAllData => 'Извези ги сите податоци (CSV)';

  @override
  String get settingsExportAllDataSubtitle =>
      'Копирајте трансакции, сценарија, буџети и цели во привремената меморија';

  @override
  String get settingsExportAllDataEmpty => 'Сè уште нема податоци за извоз';

  @override
  String get settingsExportAllDataDone =>
      'Сите податоци се копирани во привремената меморија';

  @override
  String get settingsDeleteAllData => 'Избриши ги сите локални податоци';

  @override
  String get settingsDeleteAllDataSubtitle =>
      'Трајно отстранете трансакции, сценарија, буџети и цели од овој уред';

  @override
  String get settingsDeleteAllDataDialog1Title =>
      'Да се избришат сите локални податоци?';

  @override
  String get settingsDeleteAllDataDialog1Body =>
      'Ова трајно ги отстранува сите трансакции, зачувани сценарија, буџети по категорија и цели за штедење зачувани на овој уред. Ова не може да се врати. Вашата историја на пресметки исто така ќе биде избришана.';

  @override
  String get settingsDeleteAllDataDialog2Title => 'Дали сте апсолутно сигурни?';

  @override
  String get settingsDeleteAllDataDialog2Body =>
      'Ова е вашата последна можност да откажете. Нема начин да ги вратите овие податоци потоа.';

  @override
  String get settingsDeleteAllDataConfirm => 'Избриши сè';

  @override
  String get settingsDeleteAllDataDone => 'Сите локални податоци се избришани';

  @override
  String get settingsOfflineStatusTitle => 'Работи целосно офлајн';

  @override
  String get settingsOfflineStatusBody =>
      'Оваа апликација нема сметка, синхронизација во облак ниту сервер — сè што внесувате останува само на овој уред. Курсот за конверзија на валути е единствената функција на која ѝ треба интернет врска; ако сте офлајн, се користи последниот познат курс.';

  @override
  String get toolsInvoicesTitle => 'Фактури';

  @override
  String get toolsInvoicesSubtitle =>
      'Следете што ви должат клиентите — платено, неплатено и задоцнето';

  @override
  String get invoicesScreenTitle => 'Фактури';

  @override
  String get invoicesEmptyState =>
      'Сè уште нема фактури. Допрете + за да ја додадете првата.';

  @override
  String get invoiceOutstanding => 'Ненаплатено';

  @override
  String get invoiceOverdue => 'Задоцнето';

  @override
  String get invoiceFilterAll => 'Сите';

  @override
  String get invoiceFilterUnpaid => 'Неплатено';

  @override
  String get invoiceFilterOverdue => 'Задоцнето';

  @override
  String get invoiceFilterPaid => 'Платено';

  @override
  String get invoiceStatusPaid => 'Платено';

  @override
  String get invoiceStatusUnpaid => 'Неплатено';

  @override
  String get invoiceStatusOverdue => 'Задоцнето';

  @override
  String get invoiceDueLabel => 'Рок';

  @override
  String get invoiceMarkPaid => 'Означи како платено';

  @override
  String get invoiceMarkUnpaid => 'Означи како неплатено';

  @override
  String get invoiceDeleteConfirmTitle => 'Да се избрише оваа фактура?';

  @override
  String get invoiceDeleteConfirmBody => 'Ова не може да се врати.';

  @override
  String get invoiceAddTitle => 'Додај фактура';

  @override
  String get invoiceEditTitle => 'Уреди фактура';

  @override
  String get invoiceClientName => 'Име на клиент';

  @override
  String get invoiceDescription => 'Опис (опционално)';

  @override
  String get invoiceAmount => 'Износ';

  @override
  String get invoiceIssueDate => 'Датум на издавање';

  @override
  String get invoiceDueDate => 'Рок на плаќање';

  @override
  String get commonClearSearch => 'Избриши пребарување';

  @override
  String get expensePreviousMonth => 'Претходен месец';

  @override
  String get expenseNextMonth => 'Следен месец';

  @override
  String get homeExpenseTrackerTitle => 'Овој месец';

  @override
  String get homeExpenseTrackerCtaEmpty =>
      'Следете ги вашите приходи и трошоци';

  @override
  String get homeExpenseTrackerMoreCurrencies =>
      'Следени се повеќе валути — допрете за да ги видите сите';

  @override
  String get catHousing => 'Домување и кирија';

  @override
  String get catUtilities => 'Режиски трошоци';

  @override
  String get catGroceries => 'Намирници';

  @override
  String get catTransport => 'Превоз';

  @override
  String get catHealth => 'Здравство';

  @override
  String get catEducation => 'Образование';

  @override
  String get catEntertainment => 'Забава';

  @override
  String get catOtherExpense => 'Друго';

  @override
  String get catSalary => 'Плата';

  @override
  String get catFreelance => 'Фриленс / бизнис';

  @override
  String get catOtherIncome => 'Други приходи';
}
