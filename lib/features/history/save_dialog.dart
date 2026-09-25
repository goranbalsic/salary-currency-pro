import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_config.dart';
import '../../app/bootstrap.dart';
import '../../core/widgets/common.dart';
import '../../l10n/l10n.dart';
import '../pro/pro_controller.dart';
import '../pro/pro_gate.dart';
import 'history_store.dart';

/// Asks for a name and saves the calculation. Free users can keep
/// [AppConfig.freeSavedLimit] saved calculations.
Future<void> saveCalculation(BuildContext context, ToolId tool, Map<String, Object?> inputs, {String suggestedName = ''}) async {
  final history = context.read<HistoryStore>();
  final pro = context.read<ProController>();
  final review = context.read<AppServices>().review;
  final l = context.l10n;
  if (!pro.can(ProFeature.unlimitedSaves) && history.savedCount >= AppConfig.freeSavedLimit) {
    final unlocked = await requirePro(context, ProFeature.unlimitedSaves);
    if (!unlocked || !context.mounted) return;
  }
  final name = await askName(context, title: l.saveTitle, initial: suggestedName, showLimit: true);
  if (name == null || !context.mounted) return;
  await history.saveNamed(tool, inputs, name);
  if (context.mounted) showSnack(context, l.snackSaved);
  unawaited(review.recordWin());
}

/// Asks for a calculation name. Returns null when cancelled.
Future<String?> askName(BuildContext context, {required String title, String initial = '', bool showLimit = false}) => showDialog<String>(
  context: context,
  builder: (context) => _NameDialog(title: title, initial: initial, showLimit: showLimit),
);

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.title, required this.initial, required this.showLimit});
  final String title;
  final String initial;
  final bool showLimit;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pro = context.read<ProController>();
    final history = context.read<HistoryStore>();
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 60,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l.saveNameLabel, hintText: l.saveNameHint, counterText: ''),
            onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
          ),
          if (widget.showLimit && !pro.can(ProFeature.unlimitedSaves)) ...[
            const SizedBox(height: 8),
            FinePrint('${l.saveLimit(AppConfig.freeSavedLimit)} (${history.savedCount}/${AppConfig.freeSavedLimit})'),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.actionCancel)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(88, 44)),
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
