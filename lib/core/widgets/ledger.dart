import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// Small uppercase section label ("ZAPOSLENI").
class Overline extends StatelessWidget {
  const Overline(this.text, {super.key, this.padding = EdgeInsets.zero, this.color});

  final String text;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    return Padding(
      padding: padding,
      child: Text(
        text.toUpperCase(),
        style: color == null ? style : style?.copyWith(color: color),
        semanticsLabel: text,
      ),
    );
  }
}

/// One statement line: label on the left, tabular amount on the right.
class LedgerRow extends StatelessWidget {
  const LedgerRow({
    super.key,
    required this.label,
    required this.value,
    this.hint,
    this.note,
    this.divider = true,
    this.emphasis = false,
    this.valueColor,
    this.onTap,
  });

  final String label;
  final String value;

  /// Muted inline suffix after the label, e.g. a rate "14%".
  final String? hint;

  /// Muted second line under the label.
  final String? note;
  final bool divider;
  final bool emphasis;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final base = t.bodyMedium!.copyWith(
      fontFeatures: Fonts.tabular,
      fontWeight: emphasis ? FontWeight.w600 : FontWeight.w400,
    );
    Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: _LabelValue(
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: label,
                children: [
                  if (hint != null)
                    TextSpan(
                      text: '  $hint',
                      style: base.copyWith(color: c.ink3, fontWeight: FontWeight.w400),
                    ),
                ],
              ),
              style: base,
            ),
            if (note != null) ...[
              const SizedBox(height: 2),
              Text(note!, style: t.bodySmall),
            ],
          ],
        ),
        value: Text(
          value,
          style: base.copyWith(color: valueColor),
          textAlign: TextAlign.right,
        ),
      ),
    );
    if (onTap != null) {
      row = InkWell(onTap: onTap, child: row);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: divider ? Border(bottom: BorderSide(color: c.line)) : null,
      ),
      child: row,
    );
  }
}

/// A total line closed by an accountant's double rule above it.
class LedgerTotal extends StatelessWidget {
  const LedgerTotal({super.key, required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 2),
        Container(height: 1.2, color: c.ink),
        const SizedBox(height: 2.4),
        Container(height: 1.2, color: c.ink),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 12),
          child: _LabelValue(
            baseline: true,
            label: Text(label, style: t.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
            value: Text(
              value,
              style: t.titleLarge!.copyWith(fontSize: 18, color: valueColor),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}

/// Section title in the serif face, optionally with a trailing action.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing, this.padding = const EdgeInsets.only(bottom: Gap.sm)});

  final String text;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge)),
          ?trailing,
        ],
      ),
    );
  }
}

/// Rounded, hairline-bordered surface.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
    this.color,
    this.borderColor,
    this.radius = Radii.lg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? c.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? c.line),
      ),
      child: child,
    );
  }
}

/// Label on the left, value on the right. The value keeps its natural
/// width up to 62% of the row and wraps beyond that, so a long value or a
/// large text size can never push the row past the screen edge.
class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value, this.baseline = false});

  final Widget label;
  final Widget value;

  /// Align label and value on their text baseline (totals).
  final bool baseline;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        crossAxisAlignment: baseline ? CrossAxisAlignment.baseline : CrossAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(child: label),
          const SizedBox(width: Gap.md),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.62),
            child: value,
          ),
        ],
      ),
    );
  }
}
