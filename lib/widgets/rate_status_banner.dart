import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Discloses, in plain language, whether a shown rate is live or cached and
/// exactly when it's from. Every screen that shows a rate must use this —
/// never show a number without this context.
class RateStatusBanner extends StatelessWidget {
  final bool isLive;
  final DateTime asOf;
  final String source;

  const RateStatusBanner({
    super.key,
    required this.isLive,
    required this.asOf,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatted = DateFormat('MMM d, HH:mm').format(asOf);
    final color = isLive ? AppColors.moneyGreen : AppColors.gold;
    final icon = isLive ? Icons.bolt : Icons.history;
    final label = isLive
        ? l10n.convertLiveRate(source, formatted)
        : l10n.convertCachedRate(formatted, source);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
