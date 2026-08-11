import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Small pill-shaped status/selection chip (Pro badges, entitlement
/// preview states, segmented-style filters). Replaces the ad hoc
/// Container+BoxDecoration chips each screen currently builds by hand.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bg = selected
        ? colorScheme.secondaryContainer
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);
    final fg = selected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurfaceVariant;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.check, size: 16, color: fg),
                )
              else if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(icon, size: 16, color: fg),
                ),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
