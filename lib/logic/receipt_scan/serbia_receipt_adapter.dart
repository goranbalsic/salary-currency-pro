import '../../models/fiscal_receipt_scan.dart';
import 'receipt_country_adapter.dart';

/// Recognizes Serbia's documented fiscal-receipt QR URL format
/// (`https://suf.purs.gov.rs/v/?vl=<payload>`) purely by shape. This is
/// local string/URL pattern-matching only — it never makes a request to
/// that host, and a "recognized" result is not fiscal verification, only
/// a local format match. See `DECISIONS.md` for the offline-boundary
/// decision this adapter is part of.
class SerbiaReceiptAdapter implements ReceiptCountryAdapter {
  const SerbiaReceiptAdapter();

  static const _host = 'suf.purs.gov.rs';

  @override
  String get countryId => 'rs';

  @override
  ReceiptScanOutcome? classify(String payload) {
    final trimmed = payload.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.host.isEmpty) {
      // Not a parseable URL — only treat it as a near-match (malformed)
      // if the raw text still mentions the host, so unrelated plain text
      // stays unknown rather than being misclassified as a broken
      // Serbian receipt.
      return trimmed.toLowerCase().contains(_host) ? ReceiptScanOutcome.malformed : null;
    }
    if (uri.host.toLowerCase() != _host) return null;

    final isWellFormed = uri.scheme == 'https' &&
        uri.path == '/v/' &&
        (uri.queryParameters['vl']?.isNotEmpty ?? false);

    return isWellFormed ? ReceiptScanOutcome.recognized : ReceiptScanOutcome.malformed;
  }
}
