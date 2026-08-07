import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../navigation/app_page_route.dart';
import '../providers/pro_provider.dart';
import '../screens/paywall/paywall_screen.dart';
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
  final isPro = context.read<ProProvider>().isPro;

  final nameCtrl = TextEditingController(text: defaultName);
  final name = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.scenarioSaveDialogTitle),
      content: TextField(
        controller: nameCtrl,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.scenarioNameLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(
            nameCtrl.text.trim().isEmpty ? defaultName : nameCtrl.text.trim(),
          ),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
  nameCtrl.dispose();
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
