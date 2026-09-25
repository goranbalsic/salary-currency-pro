import 'dart:async';
import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/app_config.dart';
import '../../../app/bootstrap.dart';
import '../../../core/design/tokens.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/controls.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/ledger.dart';
import '../../../l10n/l10n.dart';
import '../../business/ui/profile_screen.dart';
import '../../history/history_screen.dart';
import '../../history/history_store.dart';
import '../../pro/paywall_screen.dart';
import '../../pro/pro_controller.dart';
import '../data/backup.dart';
import '../settings_controller.dart';
import 'language_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _version;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadVersion());
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _version = '${info.version} (${info.buildNumber})');
    } catch (_) {
      // The version line is cosmetic; leave it out when unavailable.
    }
  }

  Future<void> _pickCountry(SettingsController settings) async {
    final l = context.l10n;
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        final c = context.colors;
        final t = Theme.of(context).textTheme;
        return SafeArea(
          top: false,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: Gap.lg),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.sm),
                child: Text(l.onbCountry, style: t.titleLarge),
              ),
              for (final country in HomeCountry.all)
                ListTile(
                  leading: CodeTile(country.code, filled: country.code == settings.country.code),
                  title: Text(l.countryName(country.code), style: t.titleMedium),
                  subtitle: Text(country.currency),
                  trailing: country.code == settings.country.code ? Icon(Icons.check, color: c.green) : null,
                  onTap: () => Navigator.of(context).pop(country.code),
                ),
            ],
          ),
        );
      },
    );
    if (picked != null) await settings.setCountry(picked);
  }

  Future<void> _export() async {
    final l = context.l10n;
    final store = context.read<AppServices>().store;
    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      final bytes = Uint8List.fromList(utf8.encode(Backup.encode(store, now: now)));
      final name = Backup.fileName(now);
      final result = await SharePlus.instance.share(ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'application/json', name: name)],
        fileNameOverrides: [name],
        subject: l.settingsBackupSubject,
      ));
      if (!mounted) return;
      if (result.status == ShareResultStatus.success) showSnack(context, l.settingsExported);
    } catch (_) {
      if (mounted) showSnack(context, l.errorShare);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final l = context.l10n;
    final services = context.read<AppServices>();
    XFile? file;
    try {
      file = await openFile(acceptedTypeGroups: [
        const XTypeGroup(label: 'JSON', extensions: ['json'], mimeTypes: ['application/json', 'text/plain', 'application/octet-stream']),
      ]);
    } catch (_) {
      if (mounted) showSnack(context, l.errorGeneric);
      return;
    }
    if (file == null || !mounted) return;
    Map<String, Object?>? data;
    try {
      final length = await file.length();
      if (length <= 5 * 1024 * 1024) data = Backup.decode(await file.readAsString());
    } catch (_) {
      data = null;
    }
    if (!mounted) return;
    if (data == null) {
      showSnack(context, l.settingsImportInvalid);
      return;
    }
    final ok = await confirmDestructive(context, title: l.settingsImportTitle, body: l.settingsImportBody, action: l.settingsImportAction);
    if (!ok || !mounted) return;
    await Backup.restore(services.store, data);
    services.reloadAll();
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(l.settingsImported)));
  }

  Future<void> _deleteAll() async {
    final l = context.l10n;
    final services = context.read<AppServices>();
    final ok = await confirmDestructive(context, title: l.settingsDeleteTitle, body: l.settingsDeleteBody, action: l.settingsDeleteAction);
    if (!ok || !mounted) return;
    final navigator = Navigator.of(context);
    await Backup.wipe(services.store);
    services.reloadAll();
    navigator.popUntil((r) => r.isFirst);
  }

  Future<void> _rate() async {
    final l = context.l10n;
    try {
      await InAppReview.instance.openStoreListing();
    } catch (_) {
      if (mounted) showSnack(context, l.errorOpenLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final settings = context.watch<SettingsController>();
    final pro = context.watch<ProController>();
    final history = context.watch<HistoryStore>();

    return Scaffold(
      appBar: AppBar(title: Text(l.homeSettings)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          _ProCard(pro: pro),
          const SizedBox(height: 26),
          Overline(l.settingsPreferences, padding: const EdgeInsets.only(bottom: 4)),
          SelectRow(label: l.onbCountry, value: l.countryName(settings.country.code), onTap: () => _pickCountry(settings)),
          SelectRow(
            label: l.onbLanguage,
            value: settings.language?.nativeName ?? l.onbLanguageDevice,
            onTap: () async {
              final picked = await showLanguageSheet(context, current: settings.language);
              if (picked != null) await settings.setLanguage(picked.language);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.settingsTheme, style: t.bodyMedium!.copyWith(color: c.ink2)),
                const SizedBox(height: 8),
                Segmented<ThemeMode>(
                  values: const [ThemeMode.system, ThemeMode.light, ThemeMode.dark],
                  selected: settings.themeMode,
                  labelOf: (m) => switch (m) {
                    ThemeMode.system => l.settingsThemeSystem,
                    ThemeMode.light => l.settingsThemeLight,
                    ThemeMode.dark => l.settingsThemeDark,
                  },
                  onChanged: settings.setTheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Overline(l.settingsYourData, padding: const EdgeInsets.only(bottom: 4)),
          SelectRow(
            label: l.bizProfile,
            value: '',
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen())),
          ),
          SelectRow(
            label: l.historyTitle,
            value: history.savedCount == 0 ? '' : '${history.savedCount}',
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const HistoryScreen())),
          ),
          SelectRow(label: l.settingsExport, value: '', onTap: _busy ? () {} : _export),
          SelectRow(label: l.settingsImport, value: '', onTap: _import),
          InkWell(
            onTap: _deleteAll,
            child: Container(
              constraints: const BoxConstraints(minHeight: 56),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
              child: Text(l.settingsDeleteAll, style: t.bodyMedium!.copyWith(color: c.brick)),
            ),
          ),
          const SizedBox(height: 8),
          FinePrint(l.settingsDataNote),
          const SizedBox(height: 26),
          Overline(l.settingsAbout, padding: const EdgeInsets.only(bottom: 4)),
          SelectRow(label: l.settingsRate, value: '', onTap: _rate),
          if (AppConfig.supportEmail.isNotEmpty)
            SelectRow(
              label: l.settingsContact,
              value: AppConfig.supportEmail,
              onTap: () => openExternal(context, Uri(scheme: 'mailto', path: AppConfig.supportEmail, queryParameters: {'subject': 'Bilans'})),
            ),
          SelectRow(label: l.settingsPrivacy, value: '', onTap: () => openExternal(context, Uri.parse(AppConfig.privacyPolicyUrl))),
          SelectRow(label: l.settingsTerms, value: '', onTap: () => openExternal(context, Uri.parse(AppConfig.termsUrl))),
          SelectRow(
            label: l.settingsLicenses,
            value: '',
            onTap: () => showLicensePage(context: context, applicationName: l.appName, applicationVersion: _version),
          ),
          if (AppConfig.isDev) ...[
            const SizedBox(height: 18),
            const Overline('Developer', padding: EdgeInsets.only(bottom: 4)),
            SwitchRow(label: l.proDevSimulate, value: pro.devSimulated, onChanged: pro.setDevSimulated),
          ],
          const SizedBox(height: 24),
          Center(child: Text('${l.appName} ${_version ?? ''}'.trim(), style: t.bodySmall)),
          const SizedBox(height: 4),
          Center(child: Text(l.settingsDisclaimer, style: t.bodySmall, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard({required this.pro});
  final ProController pro;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    if (pro.isPro) {
      final plan = switch (pro.productId) {
        AppConfig.proLifetime => l.proLifetime,
        AppConfig.proYearly => l.proYearly,
        AppConfig.proMonthly => l.proMonthly,
        _ => null,
      };
      return Panel(
        color: c.brassTint,
        borderColor: c.brass.withValues(alpha: 0.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.settingsProActive, style: t.titleLarge)),
                const ProBadge(strong: true),
              ],
            ),
            if (plan != null) ...[const SizedBox(height: 4), Text(plan, style: t.bodyMedium!.copyWith(color: c.ink2))],
            if (pro.isSubscription) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () => openExternal(context, AppConfig.manageSubscriptionUri(pro.productId)),
                  child: Text(l.settingsManageSubscription),
                ),
              ),
            ],
          ],
        ),
      );
    }
    return Panel(
      color: c.brassTint,
      borderColor: c.brass.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(l.proHeadline, style: t.titleLarge)),
              const ProBadge(strong: true),
            ],
          ),
          const SizedBox(height: 6),
          Text(l.settingsProPitch, style: t.bodyMedium!.copyWith(color: c.ink2)),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: c.brass, foregroundColor: c.onBrass),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => const PaywallScreen())),
            child: Text(l.settingsSeePlans),
          ),
          TextButton(
            onPressed: () async {
              final ok = await pro.restore();
              if (context.mounted) showSnack(context, ok ? l.proRestored : l.proNothingToRestore);
            },
            child: Text(l.proRestore),
          ),
        ],
      ),
    );
  }
}
