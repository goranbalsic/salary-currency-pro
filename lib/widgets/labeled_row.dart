import 'package:flutter/material.dart';

/// A label/value line used throughout every calculator's result breakdown.
/// The label is always wrapped in [Expanded] so a long translated label
/// (this app ships 9 languages) wraps instead of overflowing the row —
/// several screens got this wrong before this widget existed, each with
/// its own copy-pasted, non-expanding version.
class LabeledRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const LabeledRow(this.label, this.value, {super.key, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Text(value, style: style),
        ],
      ),
    );
  }
}
