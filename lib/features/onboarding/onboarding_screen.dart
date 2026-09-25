import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/controls.dart';
import '../../core/widgets/ledger.dart';
import '../../l10n/l10n.dart';
import '../settings/settings_controller.dart';
import '../settings/ui/language_sheet.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? _country;
  AppLanguage? _language;
  bool _languageTouched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_country == null) {
      // The first preferred locale whose region the app supports, else the
      // home country of the first supported language.
      final device = WidgetsBinding.instance.platformDispatcher.locales;
      final fromRegion = device
          .map((l) => HomeCountry.all.where((c) => c.code == l.countryCode).firstOrNull)
          .nonNulls
          .firstOrNull;
      _country = fromRegion?.code ?? AppLanguage.fromLocales(device).defaultCountry;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final settings = context.read<SettingsController>();
    final effectiveLanguage = _languageTouched ? _language : settings.language;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Gap.page, 28, Gap.page, 0),
              sliver: SliverList.list(
                children: [
                  const Row(children: [BrandMark(size: 36), SizedBox(width: 10), Wordmark(size: 22)]),
                  const SizedBox(height: 28),
                  Text(l.onbHeadline, style: t.displayMedium),
                  const SizedBox(height: 12),
                  Text(l.onbBody, style: t.bodyLarge!.copyWith(color: c.ink2)),
                  const SizedBox(height: 28),
                  Overline(l.onbCountry, padding: const EdgeInsets.only(bottom: 8)),
                  Container(height: 1, color: c.ink),
                  for (final country in HomeCountry.all)
                    _CountryRow(
                      code: country.code,
                      name: l.countryName(country.code),
                      subtitle: country.code == 'BA' ? l.onbBihEntities : null,
                      currency: country.currency,
                      selected: _country == country.code,
                      onTap: () => setState(() => _country = country.code),
                    ),
                  const SizedBox(height: 20),
                  Material(
                    color: c.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md), side: BorderSide(color: c.line)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Radii.md),
                      onTap: () async {
                        final picked = await showLanguageSheet(context, current: effectiveLanguage);
                        if (picked == null || !mounted) return;
                        setState(() {
                          _languageTouched = true;
                          _language = picked.language;
                        });
                        await settings.setLanguage(picked.language);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l.onbLanguage, style: t.bodySmall),
                                  const SizedBox(height: 2),
                                  Text(effectiveLanguage?.nativeName ?? l.onbLanguageDevice, style: t.titleMedium),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: c.ink2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                      onPressed: _country == null
                          ? null
                          : () => settings.completeOnboarding(country: _country!, language: effectiveLanguage),
                      child: Text(l.actionContinue),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 16, color: c.ink2),
                        const SizedBox(width: 8),
                        Flexible(child: Text(l.onbPrivacy, style: t.bodySmall!.copyWith(color: c.ink2))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.code,
    required this.name,
    required this.currency,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String code;
  final String name;
  final String? subtitle;
  final String currency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
          child: Row(
            children: [
              CodeTile(code, filled: selected),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: t.titleMedium!.copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                      if (subtitle != null) Text(subtitle!, style: t.bodySmall),
                    ],
                  ),
                ),
              ),
              Text(currency, style: t.bodySmall!.copyWith(color: c.ink2)),
              SizedBox(
                width: 36,
                child: selected ? Icon(Icons.check, color: c.green, size: 22) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
