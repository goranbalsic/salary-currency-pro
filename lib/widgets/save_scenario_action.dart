import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../navigation/app_page_route.dart';
import '../screens/paywall/paywall_screen.dart';
import '../services/entitlement_service.dart';
import '../services/scenario_service.dart';

/// The shared "Save this calculation as a scenario" flow, used by every
/// tool screen: prompts for a name, persists via [ScenarioService], and —
/// if the free-tier cap is hit — shows an upgrade prompt that routes to
/// the paywall instead of silently failing.
Future<void> saveScenario(
  BuildContext context, {
  required String toolId,
  required String defaultName,
  required String summary,
  required Map<String, dynamic> inputs,
  String? countryId,
  String? currencyCode,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final isPro = context.read<EntitlementService>().state.value.hasFullAccess;

  final name = await showDialog<String>(
    context: context,
    builder: (dialogContext) => _SaveScenarioDialog(l10n: l10n, defaultName: defaultName),
  );
  if (name == null) return;

  try {
    await ScenarioService().add(
      toolId: toolId,
      name: name,
      summary: summary,
      inputs: inputs,
      countryId: countryId,
      currencyCode: currencyCode,
      isPro: isPro,
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.scenarioSavedConfirmation)),
    );
  } on ScenarioLimitReachedException {
    if (!context.mounted) return;
    final goToPaywall = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.scenarioLimitTitle),
        content: Text(l10n.scenarioLimitBody(ScenarioService.freeLimit)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.scenarioLimitUpgrade),
          ),
        ],
      ),
    );
    if (goToPaywall == true && context.mounted) {
      Navigator.of(context).push(
        appPageRoute((_) => const PaywallScreen()),
      );
    }
  }
}

/// The name-entry dialog's content, split into its own `State` (rather
/// than a `TextEditingController` owned by the calling function and
/// disposed the instant `showDialog` resolves) so the controller stays
/// valid for as long as the `TextField` is actually in the tree, including
/// during the dialog's own close/exit animation. An earlier version
/// disposed the controller in the caller immediately after the dialog
/// popped, which crashed ("used after being disposed") because the exit
/// animation could still be holding a live `TextField` attached to it —
/// the same class of bug already fixed once in this app for the fiscal
/// receipt scanner's manual-entry sheet (see DECISIONS.md D-032).
class _SaveScenarioDialog extends StatefulWidget {
  final AppLocalizations l10n;
  final String defaultName;

  const _SaveScenarioDialog({required this.l10n, required this.defaultName});

  @override
  State<_SaveScenarioDialog> createState() => _SaveScenarioDialogState();
}

class _SaveScenarioDialogState extends State<_SaveScenarioDialog> {
  late final _nameCtrl = TextEditingController(text: widget.defaultName);

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.scenarioSaveDialogTitle),
      content: TextField(
        controller: _nameCtrl,
        autofocus: true,
        decoration: InputDecoration(labelText: widget.l10n.scenarioNameLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            _nameCtrl.text.trim().isEmpty ? widget.defaultName : _nameCtrl.text.trim(),
          ),
          child: Text(widget.l10n.commonSave),
        ),
      ],
    );
  }
}

/// A right-aligned "Save this calculation" text button, placed under a
/// result card on every tool screen that offers saving.
class SaveScenarioRow extends StatelessWidget {
  final VoidCallback onSave;
  const SaveScenarioRow({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.bookmark_add_outlined),
          label: Text(l10n.scenarioSaveTooltip),
        ),
      ),
    );
  }
}
