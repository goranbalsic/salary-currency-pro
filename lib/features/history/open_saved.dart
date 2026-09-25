import 'package:flutter/material.dart';

import '../business/ui/break_even_screen.dart';
import '../business/ui/investment_screen.dart';
import '../business/ui/margin_screen.dart';
import '../business/ui/vat_screen.dart';
import '../pro/pro_controller.dart';
import '../pro/pro_gate.dart';
import '../shell/shell_controller.dart';
import 'history_store.dart';

/// Reopens a saved or recent calculation where it belongs: tab tools get
/// the inputs handed over (after returning to the root screen), the
/// stand-alone calculators open on top with the inputs filled in.
Future<void> openSavedCalc(BuildContext context, SavedCalc calc) async {
  if (ShellController.restoresInTab(calc.tool)) {
    final shell = ShellScope.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    shell?.restore(calc);
    return;
  }
  if (calc.tool == ToolId.investment && !await requirePro(context, ProFeature.investment)) return;
  if (!context.mounted) return;
  final screen = switch (calc.tool) {
    ToolId.vat => VatScreen(initial: calc.inputs),
    ToolId.margin => MarginScreen(initial: calc.inputs),
    ToolId.breakEven => BreakEvenScreen(initial: calc.inputs),
    _ => InvestmentScreen(initial: calc.inputs),
  };
  await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
}
