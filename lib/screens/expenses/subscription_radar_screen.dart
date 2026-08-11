import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/expense_entry.dart';
import '../../models/recurring_transaction.dart';
import '../../services/recurring_transaction_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_empty_state.dart';

/// Read-only overview of active recurring EXPENSES — PROMPT-003 Stage B
/// item 6 ("subscription/fixed-cost radar screen"). Deliberately excludes
/// recurring income and paused templates: this screen answers "what am I
/// committed to paying, right now" — editing/pausing/deleting still
/// happens on [RecurringTransactionsScreen], reached from the Tools hub
/// like this screen, not from here, to keep this one purely informational.
///
/// Weekly and monthly totals are shown separately, per currency, rather
/// than converted into a single blended "monthly equivalent" — an
/// average-weeks-per-month conversion would be real math, but showing it
/// as if it were an actual monthly bill risks being read as a promise
/// this app doesn't make about any specific month.
class SubscriptionRadarScreen extends StatefulWidget {
  const SubscriptionRadarScreen({super.key});

  @override
  State<SubscriptionRadarScreen> createState() => _SubscriptionRadarScreenState();
}

class _SubscriptionRadarScreenState extends State<SubscriptionRadarScreen> {
  final _service = RecurringTransactionService();
  List<RecurringTransaction> _fixedCosts = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
    RecurringTransactionService.changes.addListener(_load);
  }

  @override
  void dispose() {
    RecurringTransactionService.changes.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    final all = await _service.loadAll();
    if (!mounted) return;
    setState(() {
      _fixedCosts = all.where((t) => t.active && t.type == TransactionType.expense).toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));
      _loaded = true;
    });
  }

  /// {(currencyCode, frequency): total} — only combinations actually
  /// present appear, so a household with only monthly EUR subscriptions
  /// never sees a spurious "Weekly total: 0".
  Map<(String, RecurrenceFrequency), double> _totals() {
    final totals = <(String, RecurrenceFrequency), double>{};
    for (final t in _fixedCosts) {
      final key = (t.currencyCode, t.frequency);
      totals[key] = (totals[key] ?? 0) + t.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.radarScreenTitle)),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : _fixedCosts.isEmpty
              ? AppEmptyState(
                  icon: Icons.radar,
                  message: l10n.radarEmptyState,
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final entry in _totals().entries)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            entry.key.$2 == RecurrenceFrequency.weekly
                                ? Icons.calendar_view_week
                                : Icons.calendar_view_month,
                            color: AppColors.alertRed,
                          ),
                          title: Text(
                            entry.key.$2 == RecurrenceFrequency.weekly
                                ? l10n.radarWeeklyTotal
                                : l10n.radarMonthlyTotal,
                          ),
                          trailing: Text(
                            '${fmt.format(entry.value)} ${entry.key.$1}',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.alertRed),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    for (final t in _fixedCosts)
                      Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.alertRed.withValues(alpha: 0.12),
                            child: Icon(categoryIcon(t.categoryId), color: AppColors.alertRed),
                          ),
                          title: Text(localizedCategoryLabel(l10n, t.categoryId)),
                          subtitle: Text(l10n.radarNextDue(dateFmt.format(t.nextOccurrenceOnOrAfter(now)))),
                          trailing: Text(
                            '${fmt.format(t.amount)} ${t.currencyCode}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}
