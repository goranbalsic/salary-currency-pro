import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The standard "headline value + breakdown rows" shell used by every
/// single-result calculator (Loans, Savings, VAT, Budget's siblings,
/// Freelancer Payout, Freelancer Self-Assessment). Screens with a genuinely different
/// shape (the salary breakdown has two dividers and three sections) build
/// their own layout instead of forcing this one to be more flexible than
/// it needs to be — but still reuse [LabeledRow] for each line.
class ResultCard extends StatelessWidget {
  final String headlineLabel;
  final String headlineValue;
  final Color? headlineColor;

  /// Placed between the headline and the divider — e.g. a rate-status
  /// banner or a small chart. Omit for the common case.
  final Widget? leading;

  final List<Widget> rows;

  const ResultCard({
    super.key,
    required this.headlineLabel,
    required this.headlineValue,
    required this.rows,
    this.headlineColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(headlineLabel, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              headlineValue,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: headlineColor ?? AppColors.moneyGreen,
                  ),
            ),
            if (leading != null) ...[
              const SizedBox(height: 12),
              leading!,
            ],
            const Divider(height: 32),
            ...rows,
          ],
        ),
      ),
    );

    // A fresh calculation should visibly "arrive" rather than pop in — keyed
    // on the headline value so a recalculated result re-triggers the
    // transition, while unrelated rebuilds (e.g. theme changes) don't.
    return AnimatedSwitcher(
      duration: Motion.medium,
      switchInCurve: Motion.curve,
      switchOutCurve: Motion.curve,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(key: ValueKey(headlineValue), child: card),
    );
  }
}
