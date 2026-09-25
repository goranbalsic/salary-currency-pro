import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../history/history_store.dart';

enum AppTab { home, payroll, credit, fx, business }

/// Tab selection plus one-shot requests for a tab (open a section, restore
/// a saved calculation). Tab screens consume requests addressed to them.
class ShellController extends ChangeNotifier {
  AppTab _tab = AppTab.home;
  final Map<AppTab, int> _sections = {};
  SavedCalc? _restore;

  AppTab get tab => _tab;

  void select(AppTab tab, {int? section}) {
    if (section != null) _sections[tab] = section;
    _tab = tab;
    notifyListeners();
  }

  /// Returns and clears a pending section request for [tab].
  int? takeSection(AppTab tab) => _sections.remove(tab);

  /// Tools that live in a tab (the rest open as pushed screens).
  static bool restoresInTab(ToolId tool) => tool == ToolId.payroll || tool == ToolId.loan || tool == ToolId.deposit || tool == ToolId.fx;

  /// Switches to the tab that owns [calc] and hands it the inputs.
  void restore(SavedCalc calc) {
    assert(restoresInTab(calc.tool));
    _restore = calc;
    final (tab, section) = switch (calc.tool) {
      ToolId.loan => (AppTab.credit, 0),
      ToolId.deposit => (AppTab.credit, 1),
      ToolId.fx => (AppTab.fx, 0),
      _ => (AppTab.payroll, null),
    };
    select(tab, section: section);
  }

  /// Back to Home, e.g. after a data reset.
  void reset() {
    _sections.clear();
    _restore = null;
    select(AppTab.home);
  }

  /// Returns and clears a pending restore for [tool].
  SavedCalc? takeRestore(ToolId tool) {
    final r = _restore;
    if (r == null || r.tool != tool) return null;
    _restore = null;
    return r;
  }
}

/// Access from any route (the controller is provided above the Navigator).
abstract final class ShellScope {
  static ShellController? of(BuildContext context) {
    try {
      return Provider.of<ShellController>(context, listen: false);
    } on ProviderNotFoundException {
      return null;
    }
  }
}
