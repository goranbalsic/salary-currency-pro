import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/expense_entry.dart';
import '../../navigation/app_page_route.dart';
import '../../providers/pro_provider.dart';
import '../../services/budget_service.dart';
import '../../services/consent_service.dart';
import '../../services/expense_service.dart';
import '../../services/history_service.dart';
import '../../services/notification_service.dart';
import '../../services/scenario_service.dart';
import '../../theme/app_theme.dart';
import '../paywall/paywall_screen.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onSetThemeMode;
  final Locale? locale;
  final ValueChanged<Locale?> onSetLocale;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onSetThemeMode,
    required this.locale,
    required this.onSetLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionCard(
            title: l10n.settingsLanguage,
            child: RadioGroup<String?>(
              groupValue: locale?.languageCode,
              onChanged: (code) =>
                  onSetLocale(code == null ? null : Locale(code)),
              child: Column(
                children: [
                  RadioListTile<String?>(
                    value: null,
                    title: Text(l10n.settingsSystemDefault),
                  ),
                  for (final entry in kLanguageNames.entries)
                    RadioListTile<String?>(
                      value: entry.key,
                      title: Text(entry.value),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.settingsTheme,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeModeSystem),
                    icon: const Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeModeLight),
                    icon: const Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeModeDark),
                    icon: const Icon(Icons.dark_mode),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (s) => onSetThemeMode(s.first),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Builder(builder: (context) {
            final isPro = context.watch<ProProvider>().isPro;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium_outlined, color: AppColors.gold),
                title: Text(isPro ? l10n.settingsProActive : l10n.settingsProInactive,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(isPro
                    ? l10n.settingsProSubtitleActive
                    : l10n.settingsProSubtitleInactive),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  appPageRoute((_) => const PaywallScreen()),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.settingsTrustTitle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.settingsTrustBody,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _NotificationsSection(),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.settingsPrivacyTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    l10n.settingsPrivacyNote,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.delete_outline, color: AppColors.alertRed),
                  title: Text(l10n.settingsClearHistory),
                  subtitle: Text(l10n.settingsClearHistorySubtitle),
                  onTap: () => _confirmClearHistory(context, l10n),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.settingsAdPrivacyTitle),
                  subtitle: Text(l10n.settingsAdPrivacySubtitle),
                  onTap: () => _openAdPrivacyOptions(context, l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.settingsDataManagementTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.ios_share),
                  title: Text(l10n.settingsExportAllData),
                  subtitle: Text(l10n.settingsExportAllDataSubtitle),
                  onTap: () => _exportAllData(context, l10n),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.delete_forever_outlined, color: AppColors.alertRed),
                  title: Text(l10n.settingsDeleteAllData),
                  subtitle: Text(l10n.settingsDeleteAllDataSubtitle),
                  onTap: () => _confirmDeleteAllData(context, l10n),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.settingsOfflineStatusTitle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.settingsOfflineStatusBody,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.settingsAbout,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.settingsAboutBody,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAdPrivacyOptions(BuildContext context, AppLocalizations l10n) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.settingsAdPrivacyUnavailable)));
      return;
    }
    final required = await ConsentService.isPrivacyOptionsFormRequired();
    if (!context.mounted) return;
    if (!required) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.settingsAdPrivacyNotRequired)));
      return;
    }
    await ConsentService.showPrivacyOptionsForm();
  }

  Future<void> _confirmClearHistory(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearHistoryDialogTitle),
        content: Text(l10n.settingsClearHistoryDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.settingsClearHistoryDialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.settingsClearHistoryDialogConfirm,
              style: const TextStyle(color: AppColors.alertRed),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await HistoryService().clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.settingsClearHistoryDone)));
  }

  Future<void> _exportAllData(BuildContext context, AppLocalizations l10n) async {
    final expenses = await ExpenseService().loadAll();
    final scenarios = await ScenarioService().loadAll();
    final budgets = await BudgetService().loadCategoryBudgets();
    final goals = await BudgetService().loadGoals();

    if (expenses.isEmpty && scenarios.isEmpty && budgets.isEmpty && goals.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsExportAllDataEmpty)),
      );
      return;
    }

    String csvField(String s) => '"${s.replaceAll('"', '""')}"';

    final buffer = StringBuffer();
    buffer.writeln('# Transactions');
    buffer.writeln('Date,Type,Category,Amount,Currency,Note');
    for (final e in expenses) {
      final type = e.type == TransactionType.income ? 'Income' : 'Expense';
      buffer.writeln(
        '${e.date.toIso8601String().split('T').first},$type,'
        '${localizedCategoryLabel(l10n, e.categoryId)},${e.amount.toStringAsFixed(2)},'
        '${e.currencyCode},${csvField(e.note)}',
      );
    }
    buffer.writeln();
    buffer.writeln('# Saved scenarios');
    buffer.writeln('Name,Tool,Summary,Created');
    for (final s in scenarios) {
      buffer.writeln(
        '${csvField(s.name)},${s.toolId},${csvField(s.summary)},${s.createdAt.toIso8601String()}',
      );
    }
    buffer.writeln();
    buffer.writeln('# Category budgets');
    buffer.writeln('Category,MonthlyLimit,Currency');
    for (final b in budgets) {
      buffer.writeln(
        '${localizedCategoryLabel(l10n, b.categoryId)},${b.monthlyLimit.toStringAsFixed(2)},${b.currencyCode}',
      );
    }
    buffer.writeln();
    buffer.writeln('# Savings goals');
    buffer.writeln('Name,Target,Current,Currency,TargetDate');
    for (final g in goals) {
      buffer.writeln(
        '${csvField(g.name)},${g.targetAmount.toStringAsFixed(2)},${g.currentAmount.toStringAsFixed(2)},'
        '${g.currencyCode},${g.targetDate?.toIso8601String().split('T').first ?? ''}',
      );
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!context.mounted) return;
    // Hide any snackbar still showing/queued (e.g. from a just-completed
    // action) instead of silently queuing behind it — without this, a user
    // triggering two data actions in quick succession wouldn't see the
    // second confirmation until the first one's multi-second timeout
    // finally elapsed.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.settingsExportAllDataDone)));
  }

  Future<void> _confirmDeleteAllData(BuildContext context, AppLocalizations l10n) async {
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsDeleteAllDataDialog1Title),
        content: Text(l10n.settingsDeleteAllDataDialog1Body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete, style: const TextStyle(color: AppColors.alertRed)),
          ),
        ],
      ),
    );
    if (firstConfirm != true || !context.mounted) return;

    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsDeleteAllDataDialog2Title),
        content: Text(l10n.settingsDeleteAllDataDialog2Body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.settingsDeleteAllDataConfirm,
                style: const TextStyle(color: AppColors.alertRed, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (secondConfirm != true) return;

    await ExpenseService().clear();
    await BudgetService().clearAll();
    await ScenarioService().clear();
    await HistoryService().clear();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.settingsDeleteAllDataDone)));
  }
}

/// Four independent reminder toggles — PROMPT-003 Stage B item 7. Every
/// one is off by default and stays off until the user flips it here;
/// flipping one on is also the first moment OS notification permission is
/// requested (never proactively at app start). Budget-threshold alerts
/// and invoice-due reminders don't get scheduled directly from this
/// screen — enabling just requests permission; the actual scheduling
/// happens at the natural trigger point (an expense crossing a budget
/// threshold, an invoice being added/edited) in
/// `budgets_screen.dart`/`invoices_screen.dart`, which check the
/// preference themselves via `NotificationService`.
class _NotificationsSection extends StatefulWidget {
  const _NotificationsSection();

  @override
  State<_NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<_NotificationsSection> {
  final _service = NotificationService();
  bool _expenseNudge = false;
  bool _budgetThreshold = false;
  bool _invoiceDue = false;
  bool _pausalReminder = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final expenseNudge = await _service.isExpenseNudgeEnabled();
    final budgetThreshold = await _service.isBudgetThresholdEnabled();
    final invoiceDue = await _service.isInvoiceDueEnabled();
    final pausalReminder = await _service.isPausalReminderEnabled();
    if (!mounted) return;
    setState(() {
      _expenseNudge = expenseNudge;
      _budgetThreshold = budgetThreshold;
      _invoiceDue = invoiceDue;
      _pausalReminder = pausalReminder;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_loaded) return const SizedBox.shrink();

    return _SectionCard(
      title: l10n.settingsNotificationsTitle,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.notifExpenseNudgeTitle),
            subtitle: Text(l10n.notifExpenseNudgeSubtitle),
            value: _expenseNudge,
            onChanged: (v) async {
              await _service.setExpenseNudgeEnabled(
                v,
                title: l10n.notifExpenseNudgeNotifTitle,
                body: l10n.notifExpenseNudgeNotifBody,
              );
              if (mounted) setState(() => _expenseNudge = v);
            },
          ),
          SwitchListTile(
            title: Text(l10n.notifBudgetThresholdTitle),
            subtitle: Text(l10n.notifBudgetThresholdSubtitle),
            value: _budgetThreshold,
            onChanged: (v) async {
              await _service.setBudgetThresholdEnabled(v);
              if (mounted) setState(() => _budgetThreshold = v);
            },
          ),
          SwitchListTile(
            title: Text(l10n.notifInvoiceDueTitle),
            subtitle: Text(l10n.notifInvoiceDueSubtitle),
            value: _invoiceDue,
            onChanged: (v) async {
              await _service.setInvoiceDueEnabled(v);
              if (mounted) setState(() => _invoiceDue = v);
            },
          ),
          SwitchListTile(
            title: Text(l10n.notifPausalReminderTitle),
            subtitle: Text(l10n.notifPausalReminderSubtitle),
            value: _pausalReminder,
            onChanged: (v) async {
              await _service.setPausalReminderEnabled(
                v,
                title: l10n.notifPausalReminderNotifTitle,
                body: l10n.notifPausalReminderNotifBody,
              );
              if (mounted) setState(() => _pausalReminder = v);
            },
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}
