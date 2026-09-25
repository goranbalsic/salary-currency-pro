import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/widgets/controls.dart';
import '../../../l10n/l10n.dart';

/// Searchable currency picker. [pinned] currencies are listed first.
Future<String?> showCurrencySheet(
  BuildContext context, {
  required String current,
  required Iterable<String> available,
  List<String> pinned = const [],
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _CurrencySheet(current: current, available: available.toSet(), pinned: pinned),
  );
}

class _CurrencySheet extends StatefulWidget {
  const _CurrencySheet({required this.current, required this.available, required this.pinned});

  final String current;
  final Set<String> available;
  final List<String> pinned;

  @override
  State<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<_CurrencySheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final pinned = widget.pinned.where(widget.available.contains).toList();
    final rest = (widget.available.toList()..sort()).where((c) => !pinned.contains(c)).toList();
    final all = [...pinned, ...rest];
    final q = _q.trim().toLowerCase();
    final filtered = q.isEmpty ? all : all.where((code) => code.toLowerCase().contains(q) || (l.currencyName(code) ?? '').toLowerCase().contains(q)).toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, 8),
            child: TextField(
              autofocus: false,
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: l.commonSearch,
                prefixIcon: Icon(Icons.search, color: c.ink2),
                fillColor: c.sunken,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.md), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scroll,
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final code = filtered[i];
                final name = l.currencyName(code);
                final selected = code == widget.current;
                return InkWell(
                  onTap: () => Navigator.of(context).pop(code),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 56),
                    padding: const EdgeInsets.symmetric(horizontal: Gap.page),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: c.line)),
                    ),
                    child: Row(
                      children: [
                        CodeTile(code, filled: selected, width: 44),
                        const SizedBox(width: 14),
                        Expanded(child: Text(name ?? code, style: t.titleMedium)),
                        if (selected) Icon(Icons.check, color: c.green),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
