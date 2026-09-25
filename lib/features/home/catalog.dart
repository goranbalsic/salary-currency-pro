import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n.dart';
import '../business/ui/break_even_screen.dart';
import '../business/ui/investment_screen.dart';
import '../business/ui/margin_screen.dart';
import '../business/ui/pausal_screen.dart';
import '../business/ui/vat_screen.dart';
import '../credit/ui/prepayment_screen.dart';
import '../payroll/ui/compare_countries_screen.dart';
import '../payroll/ui/team_screen.dart';
import '../pro/pro_controller.dart';
import '../pro/pro_gate.dart';
import '../shell/root_shell.dart';

enum CatalogSection { payroll, credit, fx, business }

enum Tool {
  payroll(CatalogSection.payroll),
  team(CatalogSection.payroll, pro: ProFeature.teamPayroll),
  compareCountries(CatalogSection.payroll, pro: ProFeature.compareCountries),
  loan(CatalogSection.credit),
  deposit(CatalogSection.credit),
  loanCompare(CatalogSection.credit, pro: ProFeature.compareLoans),
  prepay(CatalogSection.credit, pro: ProFeature.earlyRepayment),
  converter(CatalogSection.fx),
  rateHistory(CatalogSection.fx, pro: ProFeature.fxHistory),
  invoices(CatalogSection.business),
  pausal(CatalogSection.business, pro: ProFeature.pausalTracker, onlyCountry: 'RS'),
  vat(CatalogSection.business),
  margin(CatalogSection.business),
  breakEven(CatalogSection.business),
  investment(CatalogSection.business, pro: ProFeature.investment);

  const Tool(this.section, {this.pro, this.onlyCountry});

  final CatalogSection section;
  final ProFeature? pro;

  /// Country-specific tools only show for that home country.
  final String? onlyCountry;

  bool availableIn(String country) => onlyCountry == null || onlyCountry == country;

  String title(AppLocalizations l) => switch (this) {
    Tool.payroll => l.toolPayroll,
    Tool.team => l.toolTeam,
    Tool.compareCountries => l.toolCompare,
    Tool.loan => l.toolLoan,
    Tool.deposit => l.toolDeposit,
    Tool.loanCompare => l.toolLoanCompare,
    Tool.prepay => l.toolPrepay,
    Tool.converter => l.toolConverter,
    Tool.rateHistory => l.toolRateHistory,
    Tool.invoices => l.toolInvoices,
    Tool.pausal => l.toolPausal,
    Tool.vat => l.toolVat,
    Tool.margin => l.toolMargin,
    Tool.breakEven => l.toolBreakEven,
    Tool.investment => l.toolInvestment,
  };

  String description(AppLocalizations l, String country) => switch (this) {
    Tool.payroll => l.toolPayrollDesc,
    Tool.team => l.toolTeamDesc,
    Tool.compareCountries => l.toolCompareDesc,
    Tool.loan => l.toolLoanDesc,
    Tool.deposit => l.toolDepositDesc,
    Tool.loanCompare => l.toolLoanCompareDesc,
    Tool.prepay => l.toolPrepayDesc,
    Tool.converter => l.toolConverterDesc,
    Tool.rateHistory => l.toolRateHistoryDesc,
    Tool.invoices => country == 'RS' ? l.toolInvoicesDescRs : l.toolInvoicesDesc,
    Tool.pausal => l.toolPausalDesc,
    Tool.vat => l.toolVatDesc,
    Tool.margin => l.toolMarginDesc,
    Tool.breakEven => l.toolBreakEvenDesc,
    Tool.investment => l.toolInvestmentDesc,
  };
}

String sectionTitle(AppLocalizations l, CatalogSection s) => switch (s) {
  CatalogSection.payroll => l.homeSectionPayroll,
  CatalogSection.credit => l.homeSectionCredit,
  CatalogSection.fx => l.homeSectionFx,
  CatalogSection.business => l.homeSectionBusiness,
};

/// Opens a tool: switches tab or pushes its screen, asking for Pro first
/// when the tool needs it.
Future<void> openTool(BuildContext context, Tool tool) async {
  final shell = ShellScope.of(context);
  final pro = context.read<ProController>();
  final feature = tool.pro;
  if (feature != null && !pro.can(feature)) {
    final unlocked = await requirePro(context, feature);
    if (!unlocked || !context.mounted) return;
  }
  if (!context.mounted) return;
  Future<void> push(Widget screen) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  switch (tool) {
    case Tool.payroll:
      shell?.select(AppTab.payroll);
    case Tool.loan:
      shell?.select(AppTab.credit, section: 0);
    case Tool.deposit:
      shell?.select(AppTab.credit, section: 1);
    case Tool.loanCompare:
      shell?.select(AppTab.credit, section: 2);
    case Tool.converter || Tool.rateHistory:
      shell?.select(AppTab.fx, section: 0);
    case Tool.invoices:
      shell?.select(AppTab.business);
    case Tool.team:
      await push(const TeamScreen());
    case Tool.compareCountries:
      await push(const CompareCountriesScreen());
    case Tool.prepay:
      await push(const PrepaymentScreen());
    case Tool.pausal:
      await push(const PausalScreen());
    case Tool.vat:
      await push(const VatScreen());
    case Tool.margin:
      await push(const MarginScreen());
    case Tool.breakEven:
      await push(const BreakEvenScreen());
    case Tool.investment:
      await push(const InvestmentScreen());
  }
}
