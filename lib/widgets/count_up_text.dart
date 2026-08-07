import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Animates a numeric headline counting up (or down) to [value] whenever it
/// changes, instead of the new number just popping in. Takes a raw [double]
/// plus a [formatter] rather than a pre-formatted string, since currency
/// formatting (symbol/decimals/locale) can't be reliably reversed out of
/// display text.
class CountUpText extends StatelessWidget {
  final double value;
  final String Function(double) formatter;
  final TextStyle? style;

  const CountUpText({
    super.key,
    required this.value,
    required this.formatter,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: value, end: value),
      duration: Motion.medium,
      curve: Motion.curve,
      builder: (context, animatedValue, child) {
        return Text(formatter(animatedValue), style: style);
      },
    );
  }
}
