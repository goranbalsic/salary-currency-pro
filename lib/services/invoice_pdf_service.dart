import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../pdf/invoice_pdf_content.dart';

/// Builds and shares/prints a professional invoice PDF entirely offline —
/// no network, no external font/PDF/QR service (PROMPT-003 Stage C items
/// 12.2/12.3). Deliberately separate from [InvoicePdfContent] (the
/// content model): this file owns layout only, so content logic stays
/// testable without the `pdf`/`printing` dependency, and layout can
/// change without touching content rules. The NBS IPS QR itself
/// ([InvoicePdfContent.qrPayload], when set) is drawn as vector directly
/// into the page via `pdf`'s own `Barcode.qrCode()` (re-exported from
/// `package:barcode`, already a transitive dependency of `pdf` — no
/// separate raster round-trip, no extra dependency needed) — fully
/// offline, deterministic, and only ever drawn from an already-validated
/// payload (see `lib/logic/nbs_ips_payload_builder.dart`), never guessed.
class InvoicePdfService {
  /// Loaded once and reused — bundled Noto Sans Regular/Bold (see
  /// `pubspec.yaml` and `DECISIONS.md` for source/version/license/subset
  /// method), covering every glyph the app's 9 languages' free-text
  /// invoice fields (client names, descriptions, issuer/payer names) can
  /// contain, including Cyrillic and Latin-Extended diacritics that the
  /// `pdf` package's built-in base font cannot render at all.
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  static Future<void> _ensureFontsLoaded() async {
    if (_regularFont != null && _boldFont != null) return;
    final regularData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
    _regularFont = pw.Font.ttf(regularData);
    _boldFont = pw.Font.ttf(boldData);
  }

  /// Builds the PDF and returns its raw bytes. Pure/offline — never
  /// touches the stored invoice, never contacts a network. A caller that
  /// wants save/share/print should follow with [shareOrPrint].
  Future<Uint8List> generate(InvoicePdfContent content) async {
    await _ensureFontsLoaded();
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: _regularFont, bold: _boldFont),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(content),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
        build: (context) => [
          _buildParties(content),
          pw.SizedBox(height: 16),
          _buildLinesTable(content),
          pw.SizedBox(height: 12),
          _buildTotal(content),
          if (content.qrPayload != null) ...[
            pw.SizedBox(height: 20),
            _buildQrSection(content),
          ],
        ],
      ),
    );

    return doc.save();
  }

  /// Presents the OS-native save/share/print flow for [bytes] — the app's
  /// one reusable "existing platform abstraction" for exporting a file
  /// (nothing else in the app has ever needed a real one; the only prior
  /// "export" feature was a clipboard copy).
  Future<void> shareOrPrint(Uint8List bytes, {String filename = 'invoice.pdf'}) {
    return Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: filename,
    );
  }

  pw.Widget _buildHeader(InvoicePdfContent content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          content.issuerName.isEmpty ? ' ' : content.issuerName,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        for (final line in content.issuerAddressLines)
          pw.Text(line, style: const pw.TextStyle(fontSize: 10)),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildParties(InvoicePdfContent content) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(content.recipientName,
                style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            if (content.invoiceNumber.isNotEmpty)
              pw.Text(content.invoiceNumber, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(content.issueDate, style: const pw.TextStyle(fontSize: 10)),
            pw.Text(content.dueDate, style: const pw.TextStyle(fontSize: 10)),
            pw.Text(content.statusLabel,
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildLinesTable(InvoicePdfContent content) {
    final labels = content.tableLabels;
    return pw.TableHelper.fromTextArray(
      headers: [labels.description, labels.quantity, labels.unitPrice, labels.subtotal],
      data: [
        for (final line in content.lines)
          [line.description, line.quantity, line.unitPrice, line.subtotal],
      ],
      cellStyle: const pw.TextStyle(fontSize: 10),
      headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      cellAlignments: const {
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
    );
  }

  pw.Widget _buildQrSection(InvoicePdfContent content) {
    return pw.Center(
      child: pw.BarcodeWidget(
        data: content.qrPayload!,
        barcode: pw.Barcode.qrCode(),
        width: 120,
        height: 120,
        drawText: false,
      ),
    );
  }

  pw.Widget _buildTotal(InvoicePdfContent content) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        '${content.totalFormatted} ${content.currencyCode}',
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
    );
  }
}
