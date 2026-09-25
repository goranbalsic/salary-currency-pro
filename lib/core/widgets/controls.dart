import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/tokens.dart';
import '../format/amount_input.dart';
import '../format/formats.dart';
import 'ledger.dart';

/// Pill segmented control with a raised selected segment.
class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.semanticLabel,
    this.lockedValues = const {},
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  /// Values shown with a small lock (still tappable — the handler decides).
  final Set<T> lockedValues;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: c.sunken, borderRadius: BorderRadius.circular(Radii.md)),
        child: Row(
          children: [
            for (final v in values)
              Expanded(
                child: Semantics(
                  selected: v == selected,
                  button: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (v != selected) {
                        unawaited(HapticFeedback.selectionClick());
                        onChanged(v);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      constraints: const BoxConstraints(minHeight: 44),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: v == selected ? c.surface : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: v == selected
                            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 2, offset: const Offset(0, 1))]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              labelOf(v),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: t.labelMedium!.copyWith(
                                fontWeight: v == selected ? FontWeight.w600 : FontWeight.w500,
                                color: v == selected ? c.ink : c.ink2,
                              ),
                            ),
                          ),
                          if (lockedValues.contains(v)) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.lock_outline, size: 13, color: c.brassText),
                          ],
                        ],
                      ),
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

/// Small brass "PRO" tag.
class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.strong = false, this.label = 'PRO'});

  final bool strong;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: strong ? c.brass : c.brassTint,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: Fonts.sans,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.9,
          color: strong ? c.onBrass : c.brassText,
          height: 1.1,
        ),
      ),
    );
  }
}

/// Monospaced code tile ("RS", "EUR"). Filled for the active choice.
class CodeTile extends StatelessWidget {
  const CodeTile(this.code, {super.key, this.filled = false, this.accent = false, this.width = 36});

  final String code;
  final bool filled;
  final bool accent;
  final double width;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bg = accent ? c.green : (filled ? c.ink : Colors.transparent);
    final fg = accent ? c.onGreen : (filled ? c.paper : c.ink);
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: filled || accent ? null : Border.all(color: c.ink, width: 1),
        ),
        child: Text(
          code,
          style: TextStyle(fontFamily: Fonts.mono, fontSize: 11, fontWeight: FontWeight.w500, color: fg, height: 1),
        ),
      ),
    );
  }
}

/// The large serif amount field with an underline and a currency suffix.
class AmountField extends StatefulWidget {
  const AmountField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.formats,
    this.suffix,
    this.helper,
    this.decimals = 2,
    this.fontSize = 40,
    this.autofocus = false,
    this.semanticsLabel,
    this.maxIntegerDigits = 12,
    this.textInputAction = TextInputAction.done,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final Formats formats;
  final String? suffix;
  final String? helper;
  final int decimals;
  final double fontSize;
  final bool autofocus;
  final String? semanticsLabel;
  final int maxIntegerDigits;
  final TextInputAction textInputAction;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  late AmountInputFormatter _formatter = _makeFormatter();
  late final TextEditingController _controller =
      TextEditingController(text: widget.value == null ? '' : _formatter.formatNumberForEditing(widget.value!));
  final _focus = FocusNode();

  AmountInputFormatter _makeFormatter() => AmountInputFormatter(
        formats: widget.formats,
        decimals: widget.decimals,
        maxIntegerDigits: widget.maxIntegerDigits,
      );

  @override
  void didUpdateWidget(covariant AmountField old) {
    super.didUpdateWidget(old);
    final formatsChanged = old.formats.languageCode != widget.formats.languageCode || old.decimals != widget.decimals;
    if (formatsChanged) _formatter = _makeFormatter();
    final current = _formatter.parse(_controller.text);
    final external = widget.value;
    final differs = (external == null && _controller.text.isNotEmpty) ||
        (external != null && (current == null || (current - external).abs() > 1e-9));
    if (formatsChanged || (differs && !_focus.hasFocus)) {
      final text = external == null ? '' : _formatter.formatNumberForEditing(external);
      _controller.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Overline(widget.label),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.ink, width: 2))),
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.numberWithOptions(decimal: widget.decimals > 0),
                  textInputAction: widget.textInputAction,
                  inputFormatters: [_formatter],
                  onChanged: (s) => widget.onChanged(_formatter.parse(s)),
                  onTapOutside: (_) => _focus.unfocus(),
                  style: t.displayLarge!.copyWith(fontSize: widget.fontSize),
                  cursorWidth: 2.4,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '0',
                    hintStyle: t.displayLarge!.copyWith(fontSize: widget.fontSize, color: c.ink3.withValues(alpha: 0.6)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    semanticCounterText: '',
                    labelText: null,
                  ),
                ),
              ),
              if (widget.suffix != null) ...[
                const SizedBox(width: Gap.sm),
                Text(widget.suffix!, style: t.titleMedium!.copyWith(color: c.ink2)),
              ],
            ],
          ),
        ),
        if (widget.helper != null) ...[
          const SizedBox(height: 6),
          Text(widget.helper!, style: t.bodySmall),
        ],
      ],
    );
  }
}

/// Compact labelled number input for forms (rate, term, fee...).
class NumberInputRow extends StatefulWidget {
  const NumberInputRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.formats,
    this.suffix,
    this.decimals = 2,
    this.maxIntegerDigits = 12,
    this.divider = true,
    this.error = false,
    this.hint,
    this.signed = false,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final Formats formats;
  final String? suffix;
  final int decimals;
  final int maxIntegerDigits;
  final bool divider;
  final bool error;
  final String? hint;

  /// Accept negative values (typed with a leading minus).
  final bool signed;

  @override
  State<NumberInputRow> createState() => _NumberInputRowState();
}

class _NumberInputRowState extends State<NumberInputRow> {
  late AmountInputFormatter _formatter = _make();
  late final TextEditingController _controller =
      TextEditingController(text: widget.value == null ? '' : _formatter.formatNumberForEditing(widget.value!));
  final _focus = FocusNode();

  AmountInputFormatter _make() => AmountInputFormatter(
        formats: widget.formats,
        decimals: widget.decimals,
        maxIntegerDigits: widget.maxIntegerDigits,
        allowNegative: widget.signed,
      );

  @override
  void didUpdateWidget(covariant NumberInputRow old) {
    super.didUpdateWidget(old);
    final formatsChanged = old.formats.languageCode != widget.formats.languageCode || old.decimals != widget.decimals;
    if (formatsChanged) _formatter = _make();
    final current = _formatter.parse(_controller.text);
    final external = widget.value;
    final differs = (external == null && _controller.text.isNotEmpty) ||
        (external != null && (current == null || (current - external).abs() > 1e-9));
    if (formatsChanged || (differs && !_focus.hasFocus)) {
      final text = external == null ? '' : _formatter.formatNumberForEditing(external);
      _controller.value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(border: widget.divider ? Border(bottom: BorderSide(color: c.line)) : null),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _focus.requestFocus,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.label, style: t.bodyMedium!.copyWith(color: widget.error ? c.brick : c.ink2)),
                    if (widget.hint != null) Text(widget.hint!, style: t.bodySmall),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: Gap.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 72, maxWidth: 170),
            child: IntrinsicWidth(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.numberWithOptions(decimal: widget.decimals > 0, signed: widget.signed),
                textInputAction: TextInputAction.done,
                inputFormatters: [_formatter],
                onChanged: (s) => widget.onChanged(_formatter.parse(s)),
                onTapOutside: (_) => _focus.unfocus(),
                style: t.titleLarge!.copyWith(fontSize: 21, color: widget.error ? c.brick : c.ink),
                decoration: InputDecoration(
                  isCollapsed: true,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '0',
                  hintStyle: t.titleLarge!.copyWith(fontSize: 21, color: c.ink3),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          if (widget.suffix != null) ...[
            const SizedBox(width: 6),
            Text(widget.suffix!, style: t.bodyMedium!.copyWith(color: c.ink2)),
          ],
        ],
      ),
    );
  }
}

/// Selectable pill chip.
class PillChip extends StatelessWidget {
  const PillChip({super.key, required this.label, required this.selected, required this.onTap, this.leading});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? c.ink : Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: selected ? c.ink : c.line)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 6)],
                  // Long translations wrap inside the pill instead of overflowing.
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: t.labelMedium!.copyWith(color: selected ? c.paper : c.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// −/+ stepper for whole numbers (loan term, children...).
class StepperRow extends StatelessWidget {
  const StepperRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.suffix,
    this.divider = true,
    this.decrementLabel = '−',
    this.incrementLabel = '+',
    this.hint,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final String? suffix;
  final bool divider;
  final String decrementLabel;
  final String incrementLabel;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    Widget btn(IconData icon, String semantic, int? next) => SizedBox(
          width: 44,
          height: 44,
          child: IconButton.outlined(
            tooltip: semantic,
            onPressed: next == null
                ? null
                : () {
                    unawaited(HapticFeedback.selectionClick());
                    onChanged(next);
                  },
            icon: Icon(icon, size: 18),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              side: BorderSide(color: c.line),
              backgroundColor: c.paper,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        );
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(border: divider ? Border(bottom: BorderSide(color: c.line)) : null),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: t.bodyMedium!.copyWith(color: c.ink2)),
                if (hint != null) Text(hint!, style: t.bodySmall),
              ],
            ),
          ),
          btn(Icons.remove, decrementLabel, value - step >= min ? value - step : (value > min ? min : null)),
          SizedBox(
            width: 52,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: t.titleLarge!.copyWith(fontSize: 21),
            ),
          ),
          btn(Icons.add, incrementLabel, value + step <= max ? value + step : (value < max ? max : null)),
          if (suffix != null) ...[
            const SizedBox(width: 8),
            ConstrainedBox(constraints: const BoxConstraints(minWidth: 28), child: Text(suffix!, style: t.bodyMedium!.copyWith(color: c.ink2))),
          ],
        ],
      ),
    );
  }
}
