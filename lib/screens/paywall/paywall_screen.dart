import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/pro_provider.dart';
import '../../services/purchase_service.dart';
import '../../theme/app_theme.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  ProductDetails? _product;
  bool _loading = true;
  bool _storeAvailable = true;
  bool _buying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final service = context.read<PurchaseService>();
    bool available;
    try {
      available = await service.isAvailable;
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
    final product = await service.loadProProduct();
    if (!mounted) return;
    setState(() {
      _product = product;
      _loading = false;
    });
  }

  Future<void> _buy(AppLocalizations l10n) async {
    final product = _product;
    if (product == null) return;
    setState(() {
      _buying = true;
      _error = null;
    });
    try {
      await context.read<PurchaseService>().buy(product);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = l10n.paywallPurchaseFailed('$e'));
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPro = context.watch<ProProvider>().isPro;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paywallTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
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
            ),
            const SizedBox(height: 20),
            if (isPro)
              Card(
                color: AppColors.moneyGreen.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.moneyGreen),
                      const SizedBox(width: 12),
                      Expanded(child: Text(l10n.paywallActiveMessage)),
                    ],
                  ),
                ),
              )
            else if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else if (!_storeAvailable)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(l10n.paywallStoreUnavailable),
                ),
              )
            else if (_product == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(l10n.paywallProductUnavailable),
                ),
              )
            else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(_product!.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(_product!.price,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.moneyGreen,
                              )),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _buying ? null : () => _buy(l10n),
                        child: Text(_buying ? l10n.paywallProcessing : l10n.paywallSubscribe),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: AppColors.alertRed)),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                await context.read<PurchaseService>().restore();
              },
              child: Text(l10n.paywallRestorePurchase),
            ),
          ],
        ),
      ),
    );
  }
}
