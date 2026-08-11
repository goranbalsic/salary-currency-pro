import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shows a modal bottom sheet with the app's standard grab handle and top
/// padding, so every sheet (country picker, filters, action menus) enters
/// and looks the same instead of each call site reimplementing the shape.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            Flexible(child: builder(context)),
          ],
        ),
      ),
    ),
  );
}
