import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../l10n/l10n.dart';
import '../business/ui/business_screen.dart';
import '../credit/ui/credit_screen.dart';
import '../fx/ui/fx_screen.dart';
import '../home/home_screen.dart';
import '../payroll/ui/payroll_screen.dart';
import 'shell_controller.dart';

export 'shell_controller.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late final ShellController _controller = context.read<ShellController>();
  final Set<AppTab> _built = {AppTab.home};

  AppTab get _tab => _controller.tab;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChange);
    _built.add(_controller.tab);
  }

  void _onChange() {
    if (!mounted) return;
    setState(() => _built.add(_controller.tab));
  }

  @override
  void dispose() {
    _controller.removeListener(_onChange);
    super.dispose();
  }

  void _select(AppTab tab) => _controller.select(tab);

  Widget _page(AppTab tab) {
    if (!_built.contains(tab)) return const SizedBox.shrink();
    return switch (tab) {
      AppTab.home => const HomeScreen(),
      AppTab.payroll => const PayrollScreen(),
      AppTab.credit => const CreditScreen(),
      AppTab.fx => const FxScreen(),
      AppTab.business => const BusinessScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tab == AppTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _select(AppTab.home);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _tab.index,
          children: [for (final t in AppTab.values) TickerMode(enabled: t == _tab, child: _page(t))],
        ),
        bottomNavigationBar: _BottomBar(current: _tab, onSelect: _select),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.current, required this.onSelect});

  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final items = [
      (AppTab.home, l.navHome, Icons.grid_view_outlined, Icons.grid_view_rounded),
      (AppTab.payroll, l.navPayroll, Icons.receipt_long_outlined, Icons.receipt_long),
      (AppTab.credit, l.navCredit, Icons.percent_outlined, Icons.percent),
      (AppTab.fx, l.navFx, Icons.currency_exchange_outlined, Icons.currency_exchange),
      (AppTab.business, l.navBusiness, Icons.work_outline, Icons.work),
    ];
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 68,
        child: Row(
          children: [
            for (final (tab, label, icon, activeIcon) in items)
              Expanded(
                child: Semantics(
                  selected: tab == current,
                  button: true,
                  label: label,
                  excludeSemantics: true,
                  child: InkResponse(
                    onTap: () {
                      unawaited(HapticFeedback.selectionClick());
                      onSelect(tab);
                    },
                    highlightShape: BoxShape.rectangle,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: tab == current ? 22 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                              color: c.green,
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(3)),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(tab == current ? activeIcon : icon, size: 24, color: tab == current ? c.green : c.ink3),
                            const SizedBox(height: 4),
                            Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: Fonts.sans,
                                fontSize: 12,
                                fontWeight: tab == current ? FontWeight.w600 : FontWeight.w500,
                                color: tab == current ? c.ink : c.ink3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
