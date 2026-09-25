import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/design/tokens.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../l10n/l10n.dart';
import '../../pro/pro_controller.dart';
import '../../shell/root_shell.dart';
import 'deposit_view.dart';
import 'loan_compare_view.dart';
import 'loan_view.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  int _section = 0;
  ShellController? _shell;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shell = ShellScope.of(context);
    if (shell != _shell) {
      _shell?.removeListener(_onShell);
      _shell = shell;
      _shell?.addListener(_onShell);
      _onShell();
    }
  }

  void _onShell() {
    final s = _shell?.takeSection(AppTab.credit);
    if (s != null && mounted && s != _section) setState(() => _section = s.clamp(0, 2));
  }

  @override
  void dispose() {
    _shell?.removeListener(_onShell);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pro = context.watch<ProController>();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.page, 16, Gap.page, 0),
              child: Column(
                children: [
                  ScreenHeader(title: l.creditTitle),
                  const SizedBox(height: 18),
                  Segmented<int>(
                    values: const [0, 1, 2],
                    selected: _section,
                    lockedValues: pro.can(ProFeature.compareLoans) ? const {} : const {2},
                    labelOf: (i) => [l.creditTabLoan, l.creditTabDeposit, l.creditTabCompare][i],
                    onChanged: (i) => setState(() => _section = i),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _section,
                children: const [LoanView(), DepositView(), LoanCompareView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
