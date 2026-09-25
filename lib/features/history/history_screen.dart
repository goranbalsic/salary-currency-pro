import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_config.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/forms.dart';
import '../../core/widgets/ledger.dart';
import '../../l10n/l10n.dart';
import '../pro/pro_controller.dart';
import '../settings/settings_controller.dart';
import 'history_store.dart';
import 'open_saved.dart';
import 'recent_summary.dart';
import 'save_dialog.dart';

enum _ItemAction { rename, delete }

/// Saved calculations and the automatic recent list.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final history = context.watch<HistoryStore>();
    final pro = context.watch<ProController>();
    final saved = history.saved;
    final recent = history.recent.where((e) => RecentSummary.supports(e.tool)).toList();
    final free = !pro.can(ProFeature.unlimitedSaves);

    return Scaffold(
      appBar: AppBar(title: Text(l.historyTitle)),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(Gap.page, 8, Gap.page, 40),
        children: [
          SectionTitle(
            l.historySaved,
            trailing: free ? Text('${saved.length}/${AppConfig.freeSavedLimit}', style: t.bodySmall) : null,
          ),
          if (saved.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(l.historySavedEmpty, style: t.bodyMedium!.copyWith(color: c.ink2)),
            )
          else
            for (final item in saved) _HistoryRow(item: item, saved: true),
          const SizedBox(height: 26),
          SectionTitle(
            l.homeRecent,
            trailing: recent.isEmpty
                ? null
                : TextButton(
                    onPressed: () async {
                      final ok = await confirmDestructive(context, title: l.historyClearTitle, action: l.actionClear);
                      if (ok) await history.clearRecent();
                    },
                    child: Text(l.actionClear),
                  ),
          ),
          if (recent.isEmpty)
            Text(l.historyRecentEmpty, style: t.bodyMedium!.copyWith(color: c.ink2))
          else
            for (final item in recent) _HistoryRow(item: item, saved: false),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item, required this.saved});

  final SavedCalc item;
  final bool saved;

  Future<void> _rename(BuildContext context) async {
    final l = context.l10n;
    final history = context.read<HistoryStore>();
    final name = await askName(context, title: l.actionRename, initial: item.name);
    if (name != null) await history.rename(item.id, name);
  }

  Future<void> _delete(BuildContext context) async {
    final l = context.l10n;
    final history = context.read<HistoryStore>();
    await history.remove(item.id);
    if (!context.mounted) return;
    showSnack(
      context,
      l.snackDeleted,
      action: SnackBarAction(
        label: l.actionUndo,
        onPressed: () => item.pinned ? history.saveNamed(item.tool, item.inputs, item.name) : history.recordRecent(item.tool, item.inputs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final f = context.fmt;
    final t = Theme.of(context).textTheme;
    final c = context.colors;
    final summary = RecentSummary.of(context, item, context.read<SettingsController>());
    final title = saved && item.name.isNotEmpty ? item.name : summary.title;
    final today = DateTime.now();
    final sameDay = item.at.year == today.year && item.at.month == today.month && item.at.day == today.day;
    final when = sameDay ? l.commonToday : f.date(item.at);
    return InkWell(
      onTap: () => openSavedCalc(context, item),
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.line)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    [if (saved && item.name.isNotEmpty) summary.title, summary.subtitle, when].where((s) => s.isNotEmpty).join(' · '),
                    style: t.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(summary.figure, style: t.titleLarge!.copyWith(fontSize: 17)),
                ),
              ),
            ),
            PopupMenuButton<_ItemAction>(
              tooltip: l.commonMore,
              icon: Icon(Icons.more_vert, color: c.ink2, size: 20),
              onSelected: (a) => switch (a) {
                _ItemAction.rename => _rename(context),
                _ItemAction.delete => _delete(context),
              },
              itemBuilder: (context) => [
                if (saved) PopupMenuItem(value: _ItemAction.rename, child: Text(l.actionRename)),
                PopupMenuItem(value: _ItemAction.delete, child: Text(l.actionDelete)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
