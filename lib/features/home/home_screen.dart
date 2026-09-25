import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/design/tokens.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/controls.dart';
import '../../core/widgets/ledger.dart';
import '../../l10n/l10n.dart';
import '../fx/data/rates_controller.dart';
import '../fx/domain/rates.dart';
import '../history/history_screen.dart';
import '../history/history_store.dart';
import '../history/open_saved.dart';
import '../history/recent_summary.dart';
import '../pro/pro_controller.dart';
import '../settings/settings_controller.dart';
import '../settings/ui/settings_screen.dart';
import 'catalog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _normalize(String s) {
    const map = {'č': 'c', 'ć': 'c', 'š': 's', 'ž': 'z', 'đ': 'dj', 'ș': 's', 'ş': 's', 'ț': 't', 'ţ': 't', 'ă': 'a', 'â': 'a', 'î': 'i', 'ë': 'e'};
    final lower = s.toLowerCase();
    final b = StringBuffer();
    for (final ch in lower.split('')) {
      b.write(map[ch] ?? ch);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final settings = context.watch<SettingsController>();
    final pro = context.watch<ProController>();
    final country = settings.country.code;
    final q = _normalize(_query.trim());
    final tools = Tool.values.where((tool) {
      if (!tool.availableIn(country)) return false;
      if (q.isEmpty) return true;
      return _normalize('${tool.title(l)} ${tool.description(l, country)}').contains(q);
    }).toList();

    var number = 0;
    final sections = <Widget>[];
    for (final section in CatalogSection.values) {
      final inSection = tools.where((tl) => tl.section == section).toList();
      if (inSection.isEmpty) continue;
      sections.add(Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.ink))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    const ['I', 'II', 'III', 'IV'][section.index],
                    style: t.bodySmall!.copyWith(fontFamily: Fonts.serif, fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(sectionTitle(l, section), style: t.headlineSmall)),
                ],
              ),
            ),
            for (final tool in inSection)
              _IndexRow(
                number: ++number,
                title: tool.title(l),
                subtitle: tool.description(l, country),
                locked: tool.pro != null && !pro.can(tool.pro!),
                onTap: () => openTool(context, tool),
              ),
          ],
        ),
      ));
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Gap.page, 16, Gap.page, 32),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Wordmark(size: 30),
                            const SizedBox(height: 2),
                            Text(l.appTagline, style: t.bodySmall),
                          ],
                        ),
                      ),
                      IconButton.outlined(
                        tooltip: l.homeSettings,
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen())),
                        style: IconButton.styleFrom(
                          backgroundColor: c.surface,
                          side: BorderSide(color: c.line),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
                        ),
                        icon: const Icon(Icons.tune),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SearchField(controller: _search, hint: l.homeSearchHint, onChanged: (v) => setState(() => _query = v)),
                  if (q.isEmpty) ...[
                    const SizedBox(height: 18),
                    const _RatesCard(),
                    const _RecentStrip(),
                  ],
                  ...sections,
                  if (tools.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(l.homeNoResults(_query.trim()), textAlign: TextAlign.center, style: t.bodyMedium!.copyWith(color: c.ink2)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.hint, required this.onChanged});

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: t.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: t.bodyLarge!.copyWith(color: c.ink2),
        prefixIcon: Icon(Icons.search, color: c.ink2),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: context.l10n.actionClear,
                  icon: Icon(Icons.close, color: c.ink2),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
        filled: true,
        fillColor: c.sunken,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide(color: c.green, width: 1.4)),
      ),
    );
  }
}

class _IndexRow extends StatelessWidget {
  const _IndexRow({required this.number, required this.title, required this.subtitle, required this.locked, required this.onTap});

  final int number;
  final String title;
  final String subtitle;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 64),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c.line))),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                number.toString().padLeft(2, '0'),
                style: t.bodySmall!.copyWith(fontFamily: Fonts.serif, fontFeatures: Fonts.tabular),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t.titleMedium),
                    const SizedBox(height: 2),
                    Text(subtitle, style: t.bodySmall),
                  ],
                ),
              ),
            ),
            if (locked) ...[const SizedBox(width: 8), const ProBadge()],
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, size: 20, color: c.ink3),
          ],
        ),
      ),
    );
  }
}

class _RatesCard extends StatelessWidget {
  const _RatesCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final f = context.fmt;
    final rates = context.watch<RatesController>();
    final home = context.select<SettingsController, String>((s) => s.homeCurrency);
    final book = rates.book;
    final euroHome = home == 'EUR';
    final foreign = euroHome ? const ['USD', 'GBP', 'CHF'] : const ['EUR', 'USD', 'CHF'];
    final cells = <(String, double, RateSource?, DateTime?)>[];
    for (final code in foreign) {
      final r = euroHome ? book.rate('EUR', code) : book.rate(code, home);
      if (r != null) cells.add((code, r.rate, r.source, r.date));
    }
    final source = cells.map((e) => e.$3).whereType<RateSource>().firstOrNull;
    final date = cells.map((e) => e.$4).whereType<DateTime>().firstOrNull;
    return Panel(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Overline(l.homeRatesTitle)),
              if (source != null && date != null)
                Flexible(
                  child: Text(
                    source == RateSource.nbs ? l.homeRatesNbs(f.shortDate(date)) : l.homeRatesEcb(f.shortDate(date)),
                    style: t.bodySmall,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (cells.isEmpty)
            Text(l.homeRatesEmpty, style: t.bodyMedium!.copyWith(color: c.ink2))
          else
            IntrinsicHeight(
              child: Row(
                children: [
                  for (var i = 0; i < cells.length; i++) ...[
                    if (i > 0) VerticalDivider(color: c.line, width: 24, thickness: 1),
                    Expanded(
                      child: Semantics(
                        label: euroHome ? '1 EUR = ${f.rate(cells[i].$2)} ${cells[i].$1}' : '1 ${cells[i].$1} = ${f.rate(cells[i].$2)} $home',
                        excludeSemantics: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cells[i].$1, style: t.bodySmall!.copyWith(fontFamily: Fonts.mono, color: c.ink2)),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(f.rate(cells[i].$2), style: t.titleLarge!.copyWith(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RecentStrip extends StatelessWidget {
  const _RecentStrip();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final history = context.watch<HistoryStore>();
    final settings = context.watch<SettingsController>();
    final items = history.recent.where((e) => RecentSummary.supports(e.tool)).take(2).toList();
    if (items.isEmpty && history.savedCount == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Overline(l.homeRecent)),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const HistoryScreen())),
                style: TextButton.styleFrom(minimumSize: const Size(48, 36), padding: const EdgeInsets.symmetric(horizontal: 8)),
                child: Text(l.homeSeeAll),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (items.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 2; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(
                    child: i < items.length
                        ? _RecentCard(summary: RecentSummary.of(context, items[i], settings), onTap: () => openSavedCalc(context, items[i]))
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({required this.summary, required this.onTap});

  final RecentSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: c.line)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(summary.title, style: t.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(summary.figure, style: t.titleLarge!.copyWith(fontSize: 19)),
              ),
              const SizedBox(height: 4),
              Text(summary.subtitle, style: t.bodySmall!.copyWith(color: c.ink2), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
