import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/entitlement.dart';
import '../../services/entitlement_service.dart';
import '../../theme/app_theme.dart';

/// PROMPT-003J checkpoint 2's dev-only entitlement simulator. Only ever
/// constructed by [SettingsScreen] when `AppConfig.isDev` — that check
/// lives at the call site, not here, so this widget's mere *existence* in
/// a prod build's compiled widget tree is the thing that must never
/// happen (a `if (isDev) build...` check deep inside a shared widget
/// would still leave the code reachable; the call site simply not
/// constructing this class at all is what makes it truly compile-time
/// absent from prod). Writes through
/// `EntitlementService.setDevSimulatedStatus`, the *same* single
/// [EntitlementService] instance every real gate already reads — no
/// parallel entitlement truth is introduced.
class EntitlementPreviewSection extends StatelessWidget {
  const EntitlementPreviewSection({super.key});

  static const _options = [
    EntitlementStatus.free,
    EntitlementStatus.trialing,
    EntitlementStatus.pro,
    EntitlementStatus.lifetime,
    EntitlementStatus.expired,
  ];

  String _label(AppLocalizations l10n, EntitlementStatus status) =>
      entitlementStatusCopy(l10n, status).$1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entitlementService = context.watch<EntitlementService>();

    return Card(
      color: AppColors.gold.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.gold, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.science_outlined, size: 18, color: AppColors.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.settingsEntitlementPreviewTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.settingsEntitlementPreviewDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<EntitlementState>(
              valueListenable: entitlementService.state,
              builder: (context, entitlement, _) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final status in _options)
                    ChoiceChip(
                      label: Text(_label(l10n, status)),
                      selected: entitlement.status == status,
                      onSelected: (_) => entitlementService.setDevSimulatedStatus(status),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
