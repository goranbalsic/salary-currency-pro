import 'package:flutter/material.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/monetization_config.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_lookups.dart';
import '../../models/entitlement.dart';
import '../../services/entitlement_service.dart';
import '../../theme/app_theme.dart';

/// PROMPT-003I (Stage D go-ahead) checkpoint 2's paywall: four products
/// (monthly, annual with a 7-day trial, lifetime, a non-gating support
/// purchase), annual visually favored as the primary target plan per
/// Decision 2, lifetime/support as secondary options below the fold.
/// Replaces the old single-product paywall built for the earlier
/// ProProvider/PurchaseService system (superseded, deleted — see
/// DECISIONS.md D-033).
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _loading = true;
  bool _storeAvailable = true;
  String? _buyingProductId;
  String? _error;
  Map<String, ProductDetails> _products = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = context.read<EntitlementService>();
    bool available;
    try {
      // Bounded: a store that can't actually connect (no host billing
      // service reachable) can leave isAvailable() pending indefinitely
      // rather than throwing — same "never let a real integration failure
      // hang the UI forever" discipline as this app's other native-plugin
      // boundaries (e.g. ConsentService's own startup-safety timeout).
      available = await service.isAvailable.timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
    } catch (_) {
      // No store on this platform (desktop/web dev builds) — treat the
      // same as "unavailable" rather than crashing the screen.
      available = false;
    }
    if (!mounted) return;
    if (!available) {
      setState(() {
        _storeAvailable = false;
        _loading = false;
      });
      return;
    }
    try {
      final response = await service.queryProducts();
      if (!mounted) return;
      setState(() {
        _products = {for (final p in response.productDetails) p.id: p};
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _buy(AppLocalizations l10n, String productId) async {
    final product = _products[productId];
    if (product == null) return;
    setState(() {
      _buyingProductId = productId;
      _error = null;
    });
    try {
      await context.read<EntitlementService>().buy(product);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = l10n.paywallPurchaseFailed('$e'));
    } finally {
      if (mounted) setState(() => _buyingProductId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entitlementService = context.watch<EntitlementService>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paywallTitle)),
      body: ValueListenableBuilder<EntitlementState>(
        valueListenable: entitlementService.state,
        builder: (context, entitlement, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroCard(l10n: l10n),
              const SizedBox(height: 16),
              _StatusBanner(entitlement: entitlement, l10n: l10n),
              const SizedBox(height: 20),
              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (!_storeAvailable)
                _InfoCard(text: l10n.paywallStoreUnavailable)
              else ...[
                Text(l10n.paywallFeaturesTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                _FeatureList(l10n: l10n),
                const SizedBox(height: 20),
                _PlanCard(
                  key: const Key('paywall_annual_plan'),
                  highlighted: true,
                  badge: l10n.paywallAnnualBadge,
                  title: l10n.paywallSectionAnnualTitle,
                  priceLine: _priceLine(
                    l10n,
                    _products[MonetizationConfig.proAnnualSubscriptionId],
                    MonetizationConfig.annualReferenceUsd,
                    l10n.paywallPricePerYear,
                  ),
                  subLine: l10n.paywallAnnualTrialNote(_perMonthEquivalent(
                    _products[MonetizationConfig.proAnnualSubscriptionId],
                    MonetizationConfig.annualReferenceUsd,
                  )),
                  buying: _buyingProductId == MonetizationConfig.proAnnualSubscriptionId,
                  available: _products.containsKey(MonetizationConfig.proAnnualSubscriptionId),
                  buyLabel: l10n.paywallBuySubscription,
                  onBuy: () => _buy(l10n, MonetizationConfig.proAnnualSubscriptionId),
                  color: AppColors.positiveAction(Theme.of(context).brightness),
                ),
                const SizedBox(height: 12),
                _PlanCard(
                  key: const Key('paywall_monthly_plan'),
                  highlighted: false,
                  title: l10n.paywallSectionMonthlyTitle,
                  priceLine: _priceLine(
                    l10n,
                    _products[MonetizationConfig.proMonthlySubscriptionId],
                    MonetizationConfig.monthlyReferenceUsd,
                    l10n.paywallPricePerMonth,
                  ),
                  buying: _buyingProductId == MonetizationConfig.proMonthlySubscriptionId,
                  available: _products.containsKey(MonetizationConfig.proMonthlySubscriptionId),
                  buyLabel: l10n.paywallBuySubscription,
                  onBuy: () => _buy(l10n, MonetizationConfig.proMonthlySubscriptionId),
                  color: AppColors.neutralAccent(Theme.of(context).brightness),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                _PlanCard(
                  key: const Key('paywall_lifetime_plan'),
                  highlighted: false,
                  title: l10n.paywallLifetimeTitle,
                  subLine: l10n.paywallLifetimeSubtitle,
                  priceLine: _priceLine(
                    l10n,
                    _products[MonetizationConfig.proLifetimePurchaseId],
                    MonetizationConfig.lifetimeReferenceUsd,
                    l10n.paywallPriceOneTime,
                  ),
                  buying: _buyingProductId == MonetizationConfig.proLifetimePurchaseId,
                  available: _products.containsKey(MonetizationConfig.proLifetimePurchaseId),
                  buyLabel: l10n.paywallBuyLifetime,
                  onBuy: () => _buy(l10n, MonetizationConfig.proLifetimePurchaseId),
                  color: AppColors.gold,
                ),
                const SizedBox(height: 12),
                _PlanCard(
                  key: const Key('paywall_support_plan'),
                  highlighted: false,
                  title: l10n.paywallSupportTitle,
                  subLine: l10n.paywallSupportSubtitle,
                  priceLine: _priceLine(
                    l10n,
                    _products[MonetizationConfig.supportDeveloperPurchaseId],
                    MonetizationConfig.supportReferenceUsd,
                    l10n.paywallPriceOneTime,
                  ),
                  buying: _buyingProductId == MonetizationConfig.supportDeveloperPurchaseId,
                  available: _products.containsKey(MonetizationConfig.supportDeveloperPurchaseId),
                  buyLabel: l10n.paywallBuySupport,
                  onBuy: () => _buy(l10n, MonetizationConfig.supportDeveloperPurchaseId),
                  color: Theme.of(context).colorScheme.outline,
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_error!, style: const TextStyle(color: AppColors.alertRed)),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.read<EntitlementService>().restore(),
                child: Text(l10n.paywallRestorePurchase),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Prefers the store's real, localized price when the product actually
  /// exists there; falls back to the app's own decided reference price
  /// (Decision 2) — never fabricated, just not yet confirmed by a real
  /// store listing.
  String _priceLine(
    AppLocalizations l10n,
    ProductDetails? product,
    double referenceUsd,
    String Function(String) format,
  ) {
    if (product != null) return format(product.price);
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    return format(fmt.format(referenceUsd));
  }

  String _perMonthEquivalent(ProductDetails? product, double referenceUsd) {
    final fmt = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    if (product == null) return fmt.format(referenceUsd / 12);
    // rawPrice is the store's numeric price in its own currency — safe to
    // divide directly, unlike the already-formatted display string.
    return NumberFormat.currency(symbol: product.currencySymbol, decimalDigits: 2)
        .format(product.rawPrice / 12);
  }
}

class _HeroCard extends StatelessWidget {
  final AppLocalizations l10n;
  const _HeroCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.navy,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.gold, size: 40),
            const SizedBox(height: 12),
            Text(
              l10n.paywallHeadline,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.paywallPitch,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final EntitlementState entitlement;
  final AppLocalizations l10n;
  const _StatusBanner({required this.entitlement, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = entitlementStatusCopy(l10n, entitlement.status);
    final active = entitlement.hasFullAccess;
    final activeColor = AppColors.positiveAction(Theme.of(context).brightness);
    return Card(
      color: (active ? activeColor : Theme.of(context).colorScheme.outline)
          .withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              active ? Icons.check_circle : Icons.info_outline,
              color: active ? activeColor : Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;
  const _InfoCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(text),
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  final AppLocalizations l10n;
  const _FeatureList({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final features = [
      l10n.paywallFeatureAllCountries,
      l10n.paywallFeatureUnlimitedComparisons,
      l10n.paywallFeatureInvoicePdf,
      l10n.paywallFeatureCompliancePack,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final f in features)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check,
                    size: 18,
                    color: AppColors.positiveAction(Theme.of(context).brightness)),
                const SizedBox(width: 8),
                Expanded(child: Text(f)),
              ],
            ),
          ),
      ],
    );
  }
}

/// One plan's card. [highlighted] makes the annual plan visually larger and
/// bordered, per Decision 2's "annual plan visually favored (larger card,
/// 'best value' label, per-month equivalent shown)".
class _PlanCard extends StatelessWidget {
  final bool highlighted;
  final String? badge;
  final String title;
  final String priceLine;
  final String? subLine;
  final bool buying;
  final bool available;
  final String buyLabel;
  final VoidCallback onBuy;
  final Color color;

  const _PlanCard({
    super.key,
    required this.highlighted,
    this.badge,
    required this.title,
    required this.priceLine,
    this.subLine,
    required this.buying,
    required this.available,
    required this.buyLabel,
    required this.onBuy,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      shape: highlighted
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: color, width: 2),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.all(highlighted ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: highlighted ? 18 : 16,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              priceLine,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: highlighted ? 22 : 18,
                color: color,
              ),
            ),
            if (subLine != null) ...[
              const SizedBox(height: 4),
              Text(subLine!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            if (!available)
              Text(
                l10n.paywallProductComingSoon,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontStyle: FontStyle.italic,
                    ),
              )
            else
              FilledButton(
                onPressed: buying ? null : onBuy,
                style: FilledButton.styleFrom(backgroundColor: color),
                child: Text(buying ? l10n.paywallProcessing : buyLabel),
              ),
          ],
        ),
      ),
    );
  }
}
