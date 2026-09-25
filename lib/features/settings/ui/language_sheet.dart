import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../l10n/l10n.dart';
import '../settings_controller.dart';

class LanguageChoice {
  const LanguageChoice(this.language);

  /// Null means "follow the device language".
  final AppLanguage? language;
}

Future<LanguageChoice?> showLanguageSheet(BuildContext context, {required AppLanguage? current}) {
  return showModalBottomSheet<LanguageChoice>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      final c = context.colors;
      final t = Theme.of(context).textTheme;
      final l = context.l10n;
      Widget row(String label, bool selected, LanguageChoice value) => ListTile(
        title: Text(label, style: t.titleMedium),
        trailing: selected ? Icon(Icons.check, color: c.green) : null,
        selected: selected,
        onTap: () => Navigator.of(context).pop(value),
      );
      return SafeArea(
        top: false,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: Gap.lg),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.sm),
              child: Text(l.onbLanguage, style: t.titleLarge),
            ),
            row(l.onbLanguageDevice, current == null, const LanguageChoice(null)),
            for (final lang in AppLanguage.values) row(lang.nativeName, current == lang, LanguageChoice(lang)),
          ],
        ),
      );
    },
  );
}
