import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Small caps-style label above a group of related rows (e.g. "Track &
/// Plan", "Freelance" in the Tools hub). Kept as a shared widget so every
/// section header in the app renders with the same weight/spacing/color.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
