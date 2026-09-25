import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../design/tokens.dart';
import 'controls.dart';

void showSnack(BuildContext context, String text, {SnackBarAction? action}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  messenger?.hideCurrentSnackBar();
  messenger?.showSnackBar(SnackBar(content: Text(text), action: action, duration: const Duration(seconds: 3)));
}

/// Opens the system share sheet with plain text. Returns false on failure.
Future<bool> shareText(String text, {String? subject}) async {
  try {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
    return true;
  } catch (_) {
    return false;
  }
}

/// Large serif page title with an optional trailing widget, used at the
/// top of each tab.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.trailing, this.leading});

  final String title;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 4)],
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: Gap.md),
            // At most half the row, so a long status or country name never
            // squeezes the title away at large text sizes.
            ConstrainedBox(constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2), child: trailing!),
          ],
        ],
      ),
    );
  }
}

/// Small informational line with an icon.
class InfoNote extends StatelessWidget {
  const InfoNote(this.text, {super.key, this.icon = Icons.info_outline, this.warning = false});

  final String text;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: warning ? c.warningTint : c.sunken,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(warning ? Icons.warning_amber_rounded : icon, size: 18, color: warning ? c.warning : c.ink2),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: t.bodySmall!.copyWith(color: warning ? c.ink : c.ink2))),
        ],
      ),
    );
  }
}

/// Save / Share row plus the primary PDF action with a Pro tag.
class ResultActions extends StatelessWidget {
  const ResultActions({
    super.key,
    required this.saveLabel,
    required this.shareLabel,
    required this.pdfLabel,
    required this.onSave,
    required this.onShare,
    required this.onPdf,
    required this.pdfLocked,
  });

  final String saveLabel;
  final String shareLabel;
  final String pdfLabel;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onPdf;
  final bool pdfLocked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.bookmark_border, size: 20),
                label: Text(saveLabel, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.ios_share, size: 20),
                label: Text(shareLabel, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        PdfButton(label: pdfLabel, locked: pdfLocked, onPressed: onPdf),
      ],
    );
  }
}

/// The primary "PDF" action, tagged PRO when locked.
class PdfButton extends StatelessWidget {
  const PdfButton({super.key, required this.label, required this.locked, required this.onPressed, this.busy = false});

  final String label;
  final bool locked;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: busy ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (busy)
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          else
            const Icon(Icons.picture_as_pdf_outlined, size: 20),
          const SizedBox(width: 10),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          if (locked) ...[const SizedBox(width: 10), const ProBadge(strong: true)],
        ],
      ),
    );
  }
}

/// A tappable row that opens a picker or sheet.
class SelectRow extends StatelessWidget {
  const SelectRow({super.key, required this.label, required this.value, required this.onTap, this.leading, this.divider = true});

  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? leading;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        decoration: BoxDecoration(border: divider ? Border(bottom: BorderSide(color: c.line)) : null),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(child: Text(label, style: t.bodyMedium!.copyWith(color: c.ink2))),
            Flexible(
              child: Text(value, style: t.titleSmall, textAlign: TextAlign.right, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: c.ink3),
          ],
        ),
      ),
    );
  }
}

/// Standard scrollable page body with consistent side padding.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.padding, this.controller});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: padding ?? const EdgeInsets.fromLTRB(Gap.page, 12, Gap.page, 40),
      children: children,
    );
  }
}

/// Muted fine print.
class FinePrint extends StatelessWidget {
  const FinePrint(this.text, {super.key, this.align = TextAlign.start});
  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Text(text, textAlign: align, style: t.bodySmall!.copyWith(height: 1.5));
  }
}

/// Switch row with label and optional hint.
class SwitchRow extends StatelessWidget {
  const SwitchRow({super.key, required this.label, required this.value, required this.onChanged, this.hint, this.divider = true});

  final String label;
  final String? hint;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(border: divider ? Border(bottom: BorderSide(color: c.line)) : null),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: t.bodyMedium),
                    if (hint != null) ...[const SizedBox(height: 2), Text(hint!, style: t.bodySmall)],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

/// Save + Share buttons for calculators without a PDF report.
class SaveShareRow extends StatelessWidget {
  const SaveShareRow({super.key, required this.saveLabel, required this.shareLabel, required this.onSave, required this.onShare});

  final String saveLabel;
  final String shareLabel;
  final VoidCallback? onSave;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.bookmark_border, size: 20),
            label: Text(saveLabel, overflow: TextOverflow.ellipsis),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share, size: 20),
            label: Text(shareLabel, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}

/// Builds the plain-text share body: a title, "label: value" lines and
/// the footer.
String shareBody(String title, List<(String, String)> lines, String footer) {
  final b = StringBuffer(title)..writeln();
  for (final (label, value) in lines) {
    b.writeln('$label: $value');
  }
  b
    ..writeln()
    ..write('— $footer');
  return b.toString();
}
