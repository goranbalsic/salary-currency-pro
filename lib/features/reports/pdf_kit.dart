import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/format/formats.dart';
import '../../l10n/l10n.dart';

/// The bundled faces, loaded once per app run.
class ReportFonts {
  ReportFonts._(this.sans, this.medium, this.semibold, this.serif, this.serifSemibold, this.serifItalic, this.mono);

  final pw.Font sans;
  final pw.Font medium;
  final pw.Font semibold;
  final pw.Font serif;
  final pw.Font serifSemibold;
  final pw.Font serifItalic;
  final pw.Font mono;

  static ReportFonts? _cache;

  static Future<ReportFonts> load([AssetBundle? bundle]) async {
    final cached = _cache;
    if (cached != null) return cached;
    final b = bundle ?? rootBundle;
    Future<pw.Font> ttf(String name) async => pw.Font.ttf(await b.load('assets/fonts/$name.ttf'));
    final fonts = ReportFonts._(
      await ttf('IBMPlexSans-Regular'),
      await ttf('IBMPlexSans-Medium'),
      await ttf('IBMPlexSans-SemiBold'),
      await ttf('SourceSerif4-Regular'),
      await ttf('SourceSerif4-SemiBold'),
      await ttf('SourceSerif4-Italic'),
      await ttf('IBMPlexMono-Medium'),
    );
    return _cache = fonts;
  }
}

/// Print palette: the light "Ledger" colours.
abstract final class PdfInk {
  static const ink = PdfColor.fromInt(0xFF16211C);
  static const ink2 = PdfColor.fromInt(0xFF4A5751);
  static const ink3 = PdfColor.fromInt(0xFF626D67);
  static const line = PdfColor.fromInt(0xFFD9D3C6);
  static const green = PdfColor.fromInt(0xFF0E5A43);
  static const brass = PdfColor.fromInt(0xFFD9B96E);
  static const tint = PdfColor.fromInt(0xFFF3F0E8);
  static const chart1 = PdfColor.fromInt(0xFF3A9371);
  static const chart2 = PdfColor.fromInt(0xFF8A3915);
  static const chart3 = PdfColor.fromInt(0xFFB08926);
  static const chart4 = PdfColor.fromInt(0xFF2677B2);
}

/// Shared building blocks for every report, in the app's visual language.
class ReportKit {
  ReportKit({required this.fonts, required this.l, required this.f, this.issuer, this.branded = true});

  final ReportFonts fonts;
  final AppLocalizations l;
  final Formats f;

  /// "Business name · PIB …" printed under the title, when enabled.
  final String? issuer;

  /// Print the "Calculated with Bilans" line in the footer.
  final bool branded;

  static const margin = pw.EdgeInsets.fromLTRB(40, 36, 40, 36);

  pw.ThemeData get theme => pw.ThemeData.withFont(
    base: fonts.sans,
    bold: fonts.semibold,
    italic: fonts.serifItalic,
    boldItalic: fonts.serifItalic,
  );

  pw.Document document(String title) => pw.Document(theme: theme, title: title, author: issuer, creator: 'Bilans', producer: 'Bilans');

  pw.TextStyle get body => pw.TextStyle(font: fonts.sans, fontSize: 9.5, color: PdfInk.ink, lineSpacing: 1.5);
  pw.TextStyle get small => pw.TextStyle(font: fonts.sans, fontSize: 8, color: PdfInk.ink2, lineSpacing: 1.4);
  pw.TextStyle get strong => pw.TextStyle(font: fonts.semibold, fontSize: 9.5, color: PdfInk.ink);
  pw.TextStyle get label => pw.TextStyle(font: fonts.medium, fontSize: 7, color: PdfInk.ink2, letterSpacing: 0.9);
  pw.TextStyle serif(double size, {bool semibold = false, PdfColor color = PdfInk.ink}) =>
      pw.TextStyle(font: semibold ? fonts.serifSemibold : fonts.serif, fontSize: size, color: color);

  /// Brand line, title, subtitle and date — repeated on every page.
  pw.Widget header(pw.Context ctx, {required String title, String? subtitle, required DateTime date}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 18),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Bilans', style: serif(15, semibold: true, color: PdfInk.green)),
                  pw.SizedBox(height: 2),
                  pw.Container(width: 38, height: 0.9, color: PdfInk.brass),
                  pw.SizedBox(height: 1.4),
                  pw.Container(width: 38, height: 0.9, color: PdfInk.brass),
                ],
              ),
              pw.Spacer(),
              pw.Text(f.date(date), style: small),
            ],
          ),
          pw.SizedBox(height: 14),
          pw.Text(title, style: serif(ctx.pageNumber == 1 ? 22 : 14, semibold: true)),
          if (subtitle != null && ctx.pageNumber == 1) ...[
            pw.SizedBox(height: 3),
            pw.Text(subtitle, style: body.copyWith(color: PdfInk.ink2)),
          ],
          if (issuer != null && ctx.pageNumber == 1) ...[
            pw.SizedBox(height: 3),
            pw.Text(issuer!, style: small),
          ],
        ],
      ),
    );
  }

  pw.Widget footer(pw.Context ctx, {String? note}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 14),
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfInk.line, width: 0.6)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(child: pw.Text(note ?? (branded ? l.shareFooter : ''), style: small)),
          pw.SizedBox(width: 12),
          pw.Text('${ctx.pageNumber} / ${ctx.pagesCount}', style: small),
        ],
      ),
    );
  }

  pw.Widget overline(String text, {double top = 14}) => pw.Padding(
    padding: pw.EdgeInsets.only(top: top, bottom: 4),
    child: pw.Text(text.toUpperCase(), style: label),
  );

  /// A statement line: label (with optional muted hint and note), amount.
  pw.Widget row(String labelText, String value, {String? hint, String? note, bool bold = false, bool divider = true}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.5),
      decoration: divider
          ? const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfInk.line, width: 0.5)),
            )
          : null,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                    text: labelText,
                    style: bold ? strong : body,
                    children: [
                      if (hint != null && hint.isNotEmpty)
                        pw.TextSpan(
                          text: '  $hint',
                          style: body.copyWith(color: PdfInk.ink3),
                        ),
                    ],
                  ),
                ),
                if (note != null) pw.Text(note, style: small),
              ],
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Text(value, style: bold ? strong : body),
        ],
      ),
    );
  }

  /// A total closed by the accountant's double rule.
  pw.Widget total(String labelText, String value, {double size = 13}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.SizedBox(height: 2),
        pw.Container(height: 0.9, color: PdfInk.ink),
        pw.SizedBox(height: 1.6),
        pw.Container(height: 0.9, color: PdfInk.ink),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 5, bottom: 6),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Expanded(child: pw.Text(labelText, style: strong)),
              pw.Text(value, style: serif(size, semibold: true)),
            ],
          ),
        ),
      ],
    );
  }

  /// Up to four headline figures in tinted boxes.
  pw.Widget keyFigures(List<(String, String)> items) {
    return pw.Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 9),
              decoration: pw.BoxDecoration(color: PdfInk.tint, borderRadius: pw.BorderRadius.circular(4)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(items[i].$1, style: small, maxLines: 2),
                  pw.SizedBox(height: 3),
                  pw.Text(items[i].$2, style: serif(items.length > 3 ? 12 : 14, semibold: true)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// A plain table with an underlined header; [right] marks numeric columns.
  pw.Widget table({
    required List<String> headers,
    required List<List<String>> rows,
    required List<double> flex,
    Set<int> right = const {},
    List<String>? footer,
  }) {
    pw.Widget cell(String text, int col, pw.TextStyle style) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 3),
      alignment: right.contains(col) ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
      child: pw.Text(text, style: style),
    );
    return pw.Table(
      columnWidths: {for (var i = 0; i < flex.length; i++) i: pw.FlexColumnWidth(flex[i])},
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: PdfInk.ink, width: 0.8)),
          ),
          repeat: true,
          children: [for (var i = 0; i < headers.length; i++) cell(headers[i].toUpperCase(), i, label)],
        ),
        for (final r in rows)
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfInk.line, width: 0.4)),
            ),
            children: [for (var i = 0; i < r.length; i++) cell(r[i], i, body.copyWith(fontSize: 8.5))],
          ),
        if (footer != null)
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: PdfInk.ink, width: 0.8)),
            ),
            children: [for (var i = 0; i < footer.length; i++) cell(footer[i], i, strong.copyWith(fontSize: 8.5))],
          ),
      ],
    );
  }

  /// Horizontal stacked bar with a legend underneath.
  pw.Widget composition(List<(String, double, PdfColor, String)> parts) {
    final total = parts.fold<double>(0, (a, p) => a + (p.$2 > 0 ? p.$2 : 0));
    if (total <= 0) return pw.SizedBox();
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.ClipRRect(
          horizontalRadius: 3,
          verticalRadius: 3,
          child: pw.SizedBox(
            height: 10,
            child: pw.Row(
              children: [
                for (var i = 0; i < parts.length; i++)
                  if (parts[i].$2 > 0)
                    pw.Expanded(
                      flex: (parts[i].$2 / total * 1000).round().clamp(1, 1000),
                      child: pw.Container(
                        margin: pw.EdgeInsets.only(right: i < parts.length - 1 ? 1.2 : 0),
                        color: parts[i].$3,
                      ),
                    ),
              ],
            ),
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            for (final p in parts)
              if (p.$2 > 0)
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Container(
                      width: 7,
                      height: 7,
                      decoration: pw.BoxDecoration(color: p.$3, borderRadius: pw.BorderRadius.circular(1.5)),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text('${p.$1} ${p.$4}', style: small),
                  ],
                ),
          ],
        ),
      ],
    );
  }

  pw.Widget paragraph(String text, {bool muted = true}) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 4),
    child: pw.Text(text, style: muted ? small : body),
  );
}
