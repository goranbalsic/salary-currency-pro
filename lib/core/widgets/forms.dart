import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n.dart';
import '../design/tokens.dart';
import '../format/amount_input.dart';
import '../format/formats.dart';
import 'ledger.dart';

/// A titled group of form fields.
class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.children, this.spacing = 12});

  final String title;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Overline(title, padding: const EdgeInsets.only(bottom: 10)),
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          children[i],
        ],
      ],
    );
  }
}

/// Outlined text field with the app's standard behaviour: unfocus on
/// outside tap, sensible defaults for capitalization and actions.
class TextBox extends StatelessWidget {
  const TextBox({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.helper,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.autofillHints,
    this.suffixText,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helper;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final String? suffixText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      keyboardType: keyboardType ?? (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
      textInputAction: maxLines == 1 ? textInputAction : TextInputAction.newline,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      autofillHints: autofillHints,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        helperMaxLines: 3,
        errorMaxLines: 3,
        suffixText: suffixText,
        counterText: '',
      ),
    );
  }
}

/// Outlined numeric field with live grouping (see [AmountInputFormatter]).
/// Owns its controller so the parent only deals in numbers.
class NumberBox extends StatefulWidget {
  const NumberBox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.formats,
    this.decimals = 2,
    this.maxIntegerDigits = 12,
    this.suffixText,
    this.errorText,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final Formats formats;
  final int decimals;
  final int maxIntegerDigits;
  final String? suffixText;
  final String? errorText;
  final TextInputAction textInputAction;

  @override
  State<NumberBox> createState() => _NumberBoxState();
}

class _NumberBoxState extends State<NumberBox> {
  late AmountInputFormatter _formatter = _make();
  late final TextEditingController _controller =
      TextEditingController(text: widget.value == null ? '' : _formatter.formatNumberForEditing(widget.value!));
  final _focus = FocusNode();

  AmountInputFormatter _make() =>
      AmountInputFormatter(formats: widget.formats, decimals: widget.decimals, maxIntegerDigits: widget.maxIntegerDigits);

  @override
  void didUpdateWidget(covariant NumberBox old) {
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
    return TextField(
      controller: _controller,
      focusNode: _focus,
      keyboardType: TextInputType.numberWithOptions(decimal: widget.decimals > 0),
      textInputAction: widget.textInputAction,
      inputFormatters: [_formatter],
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFeatures: Fonts.tabular),
      onChanged: (s) => widget.onChanged(_formatter.parse(s)),
      onTapOutside: (_) => _focus.unfocus(),
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: widget.suffixText,
        errorText: widget.errorText,
        errorMaxLines: 2,
        hintText: '0',
      ),
    );
  }
}

/// A read-only field that opens a date picker.
class DateBox extends StatelessWidget {
  const DateBox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.errorText,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final f = context.fmt;
    final c = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.md),
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final first = firstDate ?? DateTime(2000);
        final last = lastDate ?? DateTime(2100);
        var initial = value;
        if (initial.isBefore(first)) initial = first;
        if (initial.isAfter(last)) initial = last;
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: first,
          lastDate: last,
          helpText: label,
        );
        if (picked != null) onChanged(DateTime(picked.year, picked.month, picked.day));
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          errorMaxLines: 2,
          suffixIcon: Icon(Icons.event_outlined, color: c.ink2, size: 20),
        ),
        child: Text(f.date(value), style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

/// A read-only field that opens a picker (currency, country...).
class PickerBox extends StatelessWidget {
  const PickerBox({super.key, required this.label, required this.value, required this.onTap, this.leading});

  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(Radii.md),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(Icons.expand_more, color: c.ink2, size: 22),
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 10)],
            Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

/// Asks before leaving a form with unsaved edits. Returns true to leave.
Future<bool> confirmDiscard(BuildContext context) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.discardTitle),
      content: Text(l.discardBody),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.discardKeep)),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l.discardAction)),
      ],
    ),
  );
  return ok ?? false;
}

/// A destructive confirmation. Returns true when confirmed.
Future<bool> confirmDestructive(BuildContext context, {required String title, String? body, required String action}) async {
  final l = context.l10n;
  final c = context.colors;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l.actionCancel)),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: c.brick),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(action),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Pinned bottom area for a screen's primary actions.
class BottomActions extends StatelessWidget {
  const BottomActions({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(color: c.paper, border: Border(top: BorderSide(color: c.line))),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.page, 10, Gap.page, 10),
          child: Row(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(child: children[i]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
