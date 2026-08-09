import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../navigation/app_page_route.dart';
import '../screens/paywall/paywall_screen.dart';

/// Shows a small "this is a Pro feature" dialog with Cancel/Upgrade
/// actions, routing to [PaywallScreen] on Upgrade — the shared contextual
/// paywall-trigger pattern for PROMPT-003I's feature gates (country
/// switch, cross-border save cap, invoice PDF, paušal tracker). Mirrors
/// `save_scenario_action.dart`'s own scenario-limit dialog, generalized
/// for gates that aren't about the scenario-save limit specifically.
Future<void> showUpgradePrompt(
  BuildContext context, {
  required String title,
  required String body,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final goToPaywall = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(body),
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
    Navigator.of(context).push(appPageRoute((_) => const PaywallScreen()));
  }
}
