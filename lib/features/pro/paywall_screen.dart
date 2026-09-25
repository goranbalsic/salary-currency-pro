import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_config.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/controls.dart';
import '../../core/widgets/ledger.dart';
import '../../l10n/l10n.dart';
import '../settings/settings_controller.dart';
import 'billing_gateway.dart';
import 'pro_controller.dart';

String proFeatureName(AppLocalizations l, ProFeature f) => switch (f) {
  ProFeature.allCountries => l.proFeatAllCountries,
  ProFeature.teamPayroll => l.toolTeam,
  ProFeature.compareCountries => l.toolCompare,
  ProFeature.compareLoans => l.toolLoanCompare,
  ProFeature.earlyRepayment => l.toolPrepay,
  ProFeature.fxHistory => l.toolRateHistory,
  ProFeature.unlimitedInvoices => l.proFeatUnlimitedInvoices,
  ProFeature.pausalTracker => l.toolPausal,
  ProFeature.investment => l.toolInvestment,
  ProFeature.pdfExport => l.proFeatPdf,
  ProFeature.unlimitedSaves => l.proFeatUnlimitedSaves,
};

/// Opens a URL in the browser; shows a snack when that fails.
Future<void> openExternal(BuildContext context, Uri uri) async {
  final l = context.l10n;
  var ok = false;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
  if (!ok && context.mounted) showSnack(context, l.errorOpenLink);
}

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key, this.feature});

  /// What the person tried to use, shown as context. Null when opened from
  /// Settings.
  final ProFeature? feature;

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selected = AppConfig.proYearly;
  late final ProController _pro = context.read<ProController>();

  @override
  void initState() {
    super.initState();
    // The controller notifies listeners elsewhere in the tree, which must
    // not happen while this route is being built or torn down.
    scheduleMicrotask(() {
      _pro.resetFlow();
      if (_pro.products.isEmpty) unawaited(_pro.loadProducts());
    });
  }

  @override
  void dispose() {
    final pro = _pro;
    scheduleMicrotask(pro.resetFlow);
    super.dispose();
  }

  Future<void> _buy(ProController pro) async {
    final product = pro.product(_selected);
    if (product == null) return;
    await pro.buy(product);
  }

  Future<void> _restore(ProController pro) async {
    final l = context.l10n;
    final ok = await pro.restore();
    if (!mounted) return;
    showSnack(context, ok ? l.proRestored : l.proNothingToRestore);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final pro = context.watch<ProController>();
    final serbian = context.select<SettingsController, bool>((s) => s.country.code == 'RS');

    if (pro.isPro) return _SuccessView(onDone: () => Navigator.of(context).pop());

    final monthly = pro.product(AppConfig.proMonthly);
    final yearly = pro.product(AppConfig.proYearly);
    final lifetime = pro.product(AppConfig.proLifetime);
    final loading = pro.flow == PurchaseFlow.loadingProducts;
    final purchasing = pro.flow == PurchaseFlow.purchasing;
    final unavailable = !loading && pro.products.isEmpty;
    final selected = pro.product(_selected) ?? yearly ?? monthly ?? lifetime;
    if (selected != null && selected.id != _selected) _selected = selected.id;

    int? yearlySaving;
    if (monthly != null && yearly != null && monthly.rawPrice > 0 && monthly.currencyCode == yearly.currencyCode) {
      final saving = 1 - yearly.rawPrice / (monthly.rawPrice * 12);
      if (saving >= 0.05) yearlySaving = (saving * 100).floor();
    }

    final benefits = <(IconData, String)>[
      (Icons.public, l.proBenefitCountries),
      (Icons.groups_outlined, l.proBenefitTeam),
      (Icons.receipt_long_outlined, serbian ? l.proBenefitInvoicesRs : l.proBenefitInvoices),
      if (serbian) (Icons.speed, l.proBenefitPausal),
      (Icons.compare_arrows, l.proBenefitLoans),
      (Icons.show_chart, l.proBenefitHistory),
      (Icons.insights_outlined, l.proBenefitInvestment),
      (Icons.picture_as_pdf_outlined, l.proBenefitPdf),
    ];

    String cta() {
      final p = selected;
      if (p == null) return l.proContinue;
      if (p.id == AppConfig.proYearly && p.hasFreeTrial) return l.proStartTrial(p.freeTrialDays ?? 7);
      return l.proContinue;
    }

    // What the button will charge, spelled out under it (Play policy:
    // price and renewal terms must be clear before the purchase).
    String? summary() {
      final p = selected;
      if (p == null) return null;
      if (p.id == AppConfig.proLifetime) return l.proSummaryLifetime(p.price);
      final period = p.id == AppConfig.proYearly ? l.proPerYear : l.proPerMonth;
      if (p.hasFreeTrial) return l.proSummaryTrial(p.freeTrialDays ?? 7, p.price, period);
      return l.proSummary(p.price, period);
    }

    final plans = <Widget>[
      if (yearly != null)
        _PlanCard(
          product: yearly,
          selected: _selected == yearly.id,
          title: l.proYearly,
          period: l.proPerYear,
          badge: yearlySaving != null ? l.proSave(yearlySaving) : null,
          note: yearly.hasFreeTrial ? l.proTrialNote(yearly.freeTrialDays ?? 7) : null,
          onTap: () => setState(() => _selected = yearly.id),
        ),
      if (monthly != null)
        _PlanCard(
          product: monthly,
          selected: _selected == monthly.id,
          title: l.proMonthly,
          period: l.proPerMonth,
          onTap: () => setState(() => _selected = monthly.id),
        ),
      if (lifetime != null)
        _PlanCard(
          product: lifetime,
          selected: _selected == lifetime.id,
          title: l.proLifetime,
          period: l.proOnce,
          note: l.proLifetimeNote,
          onTap: () => setState(() => _selected = lifetime.id),
        ),
    ];
    final summaryText = summary();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(tooltip: l.actionClose, onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
        actions: [
          TextButton(onPressed: loading || purchasing ? null : () => _restore(pro), child: Text(l.proRestore)),
        ],
      ),
      // The purchase button stays in reach while the plans and benefits
      // scroll.
      bottomNavigationBar: unavailable
          ? null
          : Container(
              decoration: BoxDecoration(
                color: c.paper,
                border: Border(top: BorderSide(color: c.line)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Gap.page, 12, Gap.page, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: c.brass,
                          foregroundColor: c.onBrass,
                          minimumSize: const Size.fromHeight(54),
                        ),
                        onPressed: selected == null || purchasing || loading ? null : () => _buy(pro),
                        child: purchasing
                            ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: c.onBrass))
                            : Text(
                                cta(),
                                style: t.titleMedium!.copyWith(color: c.onBrass),
                                textAlign: TextAlign.center,
                              ),
                      ),
                      if (summaryText != null) ...[
                        const SizedBox(height: 8),
                        Text(summaryText, style: t.bodySmall, textAlign: TextAlign.center),
                      ],
                    ],
                  ),
                ),
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, 24),
        children: [
          Row(
            children: [
              const BrandMark(size: 36),
              const SizedBox(width: 12),
              Text('Bilans', style: t.headlineSmall),
              const SizedBox(width: 8),
              const ProBadge(strong: true),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.feature == null ? l.proHeadline : l.proFeatureTitle(proFeatureName(l, widget.feature!)),
            style: t.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(l.proSubhead, style: t.bodyMedium!.copyWith(color: c.ink2)),
          const SizedBox(height: 18),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (unavailable)
            _Unavailable(onRetry: pro.loadProducts)
          else
            ...plans,
          if (pro.flow == PurchaseFlow.pending) ...[
            const SizedBox(height: 4),
            InfoNote(l.proPending, icon: Icons.hourglass_top),
          ],
          if (pro.flow == PurchaseFlow.error && pro.products.isNotEmpty) ...[
            const SizedBox(height: 4),
            InfoNote(l.proError, warning: true),
          ],
          const SizedBox(height: 18),
          Overline(l.proIncluded, padding: const EdgeInsets.only(bottom: 6)),
          for (final (icon, text) in benefits)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: c.brassText),
                  const SizedBox(width: 12),
                  Expanded(child: Text(text, style: t.bodyMedium)),
                ],
              ),
            ),
          const SizedBox(height: 18),
          Text(
            selected?.id == AppConfig.proLifetime ? l.proLegalLifetime : l.proLegal,
            style: t.bodySmall!.copyWith(height: 1.5),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: [
              TextButton(onPressed: () => openExternal(context, Uri.parse(AppConfig.termsUrl)), child: Text(l.settingsTerms)),
              TextButton(onPressed: () => openExternal(context, Uri.parse(AppConfig.privacyPolicyUrl)), child: Text(l.settingsPrivacy)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.product,
    required this.selected,
    required this.title,
    required this.period,
    required this.onTap,
    this.badge,
    this.note,
  });

  final StoreProduct product;
  final bool selected;
  final String title;
  final String period;
  final String? badge;
  final String? note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? c.brassTint : c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.lg),
            side: BorderSide(color: selected ? c.brass : c.line, width: selected ? 2 : 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(Radii.lg),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
              child: Row(
                children: [
                  Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: selected ? c.brassText : c.ink3),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(title, style: t.titleMedium),
                            if (badge != null) ProBadge(label: badge!, strong: true),
                          ],
                        ),
                        if (note != null) ...[const SizedBox(height: 2), Text(note!, style: t.bodySmall)],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(product.price, style: t.titleLarge!.copyWith(fontSize: 18)),
                      Text(period, style: t.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pro = context.watch<ProController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoNote(l.proUnavailable, warning: true),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(onPressed: onRetry, child: Text(l.actionRetry)),
        ),
        if (AppConfig.isDev) ...[
          const SizedBox(height: 8),
          SwitchRow(
            label: l.proDevSimulate,
            value: pro.devSimulated,
            onChanged: pro.setDevSimulated,
            divider: false,
          ),
        ],
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Gap.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(child: Icon(Icons.verified_outlined, size: 64, color: c.brassText)),
              const SizedBox(height: 18),
              Text(l.proWelcome, style: t.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                l.proWelcomeBody,
                style: t.bodyMedium!.copyWith(color: c.ink2),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(onPressed: onDone, child: Text(l.actionContinue)),
            ],
          ),
        ),
      ),
    );
  }
}
