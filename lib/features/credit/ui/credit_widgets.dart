import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/widgets/controls.dart';
import '../../../l10n/l10n.dart';
import '../../fx/ui/currency_sheet.dart';

/// Months input with quick-pick chips.
class TermField extends StatelessWidget {
  const TermField({
    super.key,
    required this.label,
    required this.months,
    required this.onChanged,
    this.presets = const [12, 24, 36, 60, 84, 120, 240, 360],
    this.divider = true,
  });

  final String label;
  final int months;
  final ValueChanged<int> onChanged;
  final List<int> presets;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final f = context.fmt;
    return Container(
      decoration: BoxDecoration(
        border: divider ? Border(bottom: BorderSide(color: c.line)) : null,
      ),
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NumberInputRow(
            label: label,
            hint: months >= 12 ? _years(l, months) : null,
            value: months.toDouble(),
            formats: f,
            decimals: 0,
            maxIntegerDigits: 3,
            suffix: l.commonMonthsShort,
            divider: false,
            onChanged: (v) {
              final m = v?.round();
              if (m != null && m >= 1 && m <= 600) onChanged(m);
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final p in presets) ...[
                  PillChip(
                    label: p % 12 == 0 && p >= 12 ? l.commonYearsCount(p ~/ 12) : l.commonMonthsCount(p),
                    selected: months == p,
                    onTap: () => onChanged(p),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _years(AppLocalizations l, int months) {
    final y = months ~/ 12;
    final m = months % 12;
    return m == 0 ? l.commonYearsCount(y) : '${l.commonYearsCount(y)} ${l.commonMonthsCount(m)}';
  }
}

/// Amount row whose currency suffix opens a currency picker.
class CurrencyAmountRow extends StatelessWidget {
  const CurrencyAmountRow({
    super.key,
    required this.label,
    required this.value,
    required this.currency,
    required this.onChanged,
    required this.onCurrency,
    required this.currencies,
    this.error = false,
  });

  final String label;
  final double? value;
  final String currency;
  final ValueChanged<double?> onChanged;
  final ValueChanged<String> onCurrency;
  final List<String> currencies;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Row(
      children: [
        Expanded(
          child: NumberInputRow(
            label: label,
            value: value,
            formats: context.fmt,
            decimals: 2,
            error: error,
            onChanged: onChanged,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.line)),
          ),
          height: 60,
          alignment: Alignment.center,
          child: Tooltip(
            message: l.loanCurrency,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final picked = await showCurrencySheet(context, current: currency, available: currencies, pinned: currencies.take(4).toList());
                if (picked != null) onCurrency(picked);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: Row(
                  children: [
                    CodeTile(currency, width: 40),
                    Icon(Icons.expand_more, size: 18, color: c.ink2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Loan / deposit currencies offered in pickers.
List<String> creditCurrencies(String home) => {home, 'EUR', 'CHF', 'USD', 'RSD', 'BAM', 'MKD', 'RON', 'GBP', 'HUF'}.toList();

/// The dark result card from the design.
class InkResultCard extends StatelessWidget {
  const InkResultCard({super.key, required this.label, required this.figure, required this.stats, this.footnote});

  final String label;
  final String figure;
  final List<(String, String, bool)> stats; // (label, value, accent)
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(color: c.inkCard, borderRadius: BorderRadius.circular(Radii.xl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label.toUpperCase(), style: t.labelSmall!.copyWith(color: c.onInkCardMuted)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(figure, style: t.displayLarge!.copyWith(color: c.onInkCard)),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: c.inkCardLine),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              children: [
                for (var i = 0; i < stats.length; i++) ...[
                  if (i > 0) VerticalDivider(color: c.inkCardLine, width: 20, thickness: 1),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stats[i].$1, style: t.bodySmall!.copyWith(color: c.onInkCardMuted), maxLines: 2),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            stats[i].$2,
                            style: t.titleLarge!.copyWith(fontSize: 19, color: stats[i].$3 ? c.accentOnInk : c.onInkCard),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (footnote != null) ...[
            const SizedBox(height: 12),
            Text(footnote!, style: t.bodySmall!.copyWith(color: c.onInkCardMuted)),
          ],
        ],
      ),
    );
  }
}
