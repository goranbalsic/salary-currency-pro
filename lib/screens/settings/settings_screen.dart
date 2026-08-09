import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/app_flavor.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/business_profile.dart';
import '../../models/currency.dart';
import '../../models/entitlement.dart';
import '../../models/expense_entry.dart';
import '../../navigation/app_page_route.dart';
import '../../services/budget_service.dart';
import '../../services/business_profile_service.dart';
import '../../services/entitlement_service.dart';
import '../../services/expense_service.dart';
import '../../services/history_service.dart';
import '../../services/notification_service.dart';
import '../../services/pausal_tracker_service.dart';
import '../../services/pinned_pair_service.dart';
import '../../services/scenario_service.dart';
import '../../theme/app_theme.dart';
import '../paywall/paywall_screen.dart';
import 'entitlement_preview_section.dart';

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
            final entitlementService = context.watch<EntitlementService>();
            return ValueListenableBuilder<EntitlementState>(
              valueListenable: entitlementService.state,
              builder: (context, entitlement, _) {
                final (title, subtitle) = entitlementStatusCopy(l10n, entitlement.status);
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.workspace_premium_outlined, color: AppColors.gold),
                    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      appPageRoute((_) => const PaywallScreen()),
                    ),
                  ),
                );
              },
            );
          }),
          // PROMPT-003J checkpoint 2: AppConfig.isDev gates this at the
          // call site — EntitlementPreviewSection is simply never
          // constructed in a prod build, not merely hidden.
          if (AppConfig.isDev) ...[
            const SizedBox(height: 16),
            const EntitlementPreviewSection(),
          ],
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
          if (!kIsWeb && Platform.isAndroid) ...[
            const SizedBox(height: 16),
            const _WidgetsSection(),
          ],
          const SizedBox(height: 16),
          const _BusinessProfileSection(),
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
  final _pausalTrackerService = PausalTrackerService();
  bool _expenseNudge = false;
  bool _budgetThreshold = false;
  bool _invoiceDue = false;
  bool _pausalReminder = false;
  bool _pausalLeadReminder = false;
  double? _pausalAssessedAmount;
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
    final pausalLeadReminder = await _service.isPausalLeadReminderEnabled();
    final pausalAssessedAmount = await _pausalTrackerService.getAssessedMonthlyAmount();
    if (!mounted) return;
    setState(() {
      _expenseNudge = expenseNudge;
      _budgetThreshold = budgetThreshold;
      _invoiceDue = invoiceDue;
      _pausalReminder = pausalReminder;
      _pausalLeadReminder = pausalLeadReminder;
      _pausalAssessedAmount = pausalAssessedAmount;
      _loaded = true;
    });
  }

  /// Includes the user's stored assessed paušal amount (from their tax
  /// ruling) in the notification body when it's set — PROMPT-003E 11.2.
  String _pausalBody(AppLocalizations l10n) {
    final amount = _pausalAssessedAmount;
    if (amount == null) return l10n.notifPausalReminderNotifBody;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 0);
    return l10n.notifPausalReminderNotifBodyWithAmount(fmt.format(amount));
  }

  Future<void> _applyPausalReminderState(AppLocalizations l10n) async {
    await _service.setPausalReminderEnabled(
      _pausalReminder,
      title: l10n.notifPausalReminderNotifTitle,
      body: _pausalBody(l10n),
      leadReminderEnabled: _pausalLeadReminder,
      leadTitle: l10n.notifPausalLeadReminderNotifTitle,
      leadBody: l10n.notifPausalLeadReminderNotifBody,
    );
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
              setState(() => _pausalReminder = v);
              await _applyPausalReminderState(l10n);
            },
          ),
          if (_pausalReminder)
            SwitchListTile(
              title: Text(l10n.notifPausalLeadReminderTitle),
              subtitle: Text(l10n.notifPausalLeadReminderSubtitle),
              value: _pausalLeadReminder,
              onChanged: (v) async {
                setState(() => _pausalLeadReminder = v);
                await _applyPausalReminderState(l10n);
              },
            ),
        ],
      ),
    );
  }
}

/// Lets the user pick which currency pair the pinned-pair home-screen
/// widget shows (PROMPT-003 Stage B item 8). The app cannot add the widget
/// to the home screen itself — that's a system-level, long-press action —
/// so this section only configures what an already-added widget displays,
/// and says so explicitly.
class _WidgetsSection extends StatefulWidget {
  const _WidgetsSection();

  @override
  State<_WidgetsSection> createState() => _WidgetsSectionState();
}

class _WidgetsSectionState extends State<_WidgetsSection> {
  final _service = PinnedPairService();
  String _from = PinnedPairService.defaultFrom;
  String _to = PinnedPairService.defaultTo;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final (from, to) = await _service.loadPair();
    if (!mounted) return;
    setState(() {
      _from = from;
      _to = to;
      _loaded = true;
    });
  }

  Future<void> _setFrom(String code) async {
    if (code == _from) return;
    setState(() => _from = code);
    await _service.setPair(code, _to);
  }

  Future<void> _setTo(String code) async {
    if (code == _to) return;
    setState(() => _to = code);
    await _service.setPair(_from, code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_loaded) return const SizedBox.shrink();

    return _SectionCard(
      title: l10n.settingsWidgetsTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.settingsWidgetsExplainer,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsWidgetsPinnedPairTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _PairDropdown(
                        value: _from,
                        label: l10n.commonFrom,
                        onChanged: _setFrom,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PairDropdown(
                        value: _to,
                        label: l10n.commonTo,
                        onChanged: _setTo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PairDropdown extends StatelessWidget {
  final String value;
  final String label;
  final ValueChanged<String> onChanged;

  const _PairDropdown({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: supportedCurrencies
          .map(
            (c) => DropdownMenuItem(
              value: c.code,
              child: Text(c.code, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (code) {
        if (code != null) onChanged(code);
      },
    );
  }
}

/// The invoice issuer's identity — business name, address, and (Serbia
/// only) a bank account/payment code used for generated PDFs and the NBS
/// IPS QR code (PROMPT-003 Stage C item 12). One global record, since
/// this is a single-user offline tool with exactly one issuer per install.
class _BusinessProfileSection extends StatefulWidget {
  const _BusinessProfileSection();

  @override
  State<_BusinessProfileSection> createState() => _BusinessProfileSectionState();
}

class _BusinessProfileSectionState extends State<_BusinessProfileSection> {
  final _service = BusinessProfileService();
  late final _nameCtrl = TextEditingController();
  late final _address1Ctrl = TextEditingController();
  late final _address2Ctrl = TextEditingController();
  late final _accountCtrl = TextEditingController();
  late final _paymentCodeCtrl = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _address1Ctrl.dispose();
    _address2Ctrl.dispose();
    _accountCtrl.dispose();
    _paymentCodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final profile = await _service.load();
    if (!mounted) return;
    _nameCtrl.text = profile.businessName;
    _address1Ctrl.text = profile.addressLine1;
    _address2Ctrl.text = profile.addressLine2;
    _accountCtrl.text = profile.bankAccountNumber;
    _paymentCodeCtrl.text = profile.defaultPaymentCode;
    setState(() => _loaded = true);
  }

  Future<void> _save() async {
    await _service.save(BusinessProfile(
      businessName: _nameCtrl.text.trim(),
      addressLine1: _address1Ctrl.text.trim(),
      addressLine2: _address2Ctrl.text.trim(),
      bankAccountNumber: _accountCtrl.text.trim(),
      defaultPaymentCode: _paymentCodeCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_loaded) return const SizedBox.shrink();

    return _SectionCard(
      title: l10n.settingsBusinessProfileTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.settingsBusinessProfileExplainer,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: l10n.businessProfileNameLabel),
              onChanged: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _address1Ctrl,
              decoration: InputDecoration(labelText: l10n.businessProfileAddressLabel),
              onChanged: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _address2Ctrl,
              decoration: InputDecoration(labelText: l10n.businessProfileCityLabel),
              onChanged: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _accountCtrl,
              decoration: InputDecoration(
                labelText: l10n.businessProfileBankAccountLabel,
                helperText: l10n.businessProfileBankAccountHelper,
              ),
              onChanged: (_) => _save(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _paymentCodeCtrl,
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: InputDecoration(
                labelText: l10n.businessProfilePaymentCodeLabel,
                helperText: l10n.businessProfilePaymentCodeHelper,
              ),
              onChanged: (_) => _save(),
            ),
          ],
        ),
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
