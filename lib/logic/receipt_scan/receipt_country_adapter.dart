import '../../models/fiscal_receipt_scan.dart';

/// One country's local recognizer for a scanned fiscal-receipt QR payload.
/// Implementations must only inspect the payload string itself — no
/// network I/O, ever (see `FiscalReceiptFetchService` for the one
/// deliberate future-fetch boundary in this feature).
abstract class ReceiptCountryAdapter {
  /// Matches `Country.id` in `models/country.dart` (e.g. 'rs').
  String get countryId;

  /// Returns null when [payload] doesn't resemble this country's format at
  /// all, so the registry can try the next adapter. Returns
  /// [ReceiptScanOutcome.recognized] or [ReceiptScanOutcome.malformed] when
  /// this adapter claims the payload as its own country's format.
  ReceiptScanOutcome? classify(String payload);
}
