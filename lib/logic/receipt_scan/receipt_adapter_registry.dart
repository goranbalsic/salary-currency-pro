import '../../models/fiscal_receipt_scan.dart';
import 'receipt_country_adapter.dart';
import 'serbia_receipt_adapter.dart';

/// Result of running a payload through [ReceiptAdapterRegistry.classify].
class ReceiptClassification {
  final ReceiptScanOutcome outcome;
  final String? countryId;

  const ReceiptClassification({required this.outcome, this.countryId});
}

/// Deterministic, single point of country-adapter registration and
/// selection, isolated from UI and persistence code. Adding a country
/// later is: implement [ReceiptCountryAdapter], add it to [_adapters] —
/// nothing else changes.
class ReceiptAdapterRegistry {
  static const List<ReceiptCountryAdapter> _adapters = [
    SerbiaReceiptAdapter(),
  ];

  /// Tries each adapter in registration order and returns the first one
  /// that claims the payload as its own country's format (recognized or
  /// malformed). Falls back to [ReceiptScanOutcome.unknownFormat] with no
  /// country id if no adapter claims it.
  ReceiptClassification classify(String payload) {
    for (final adapter in _adapters) {
      final outcome = adapter.classify(payload);
      if (outcome != null) {
        return ReceiptClassification(outcome: outcome, countryId: adapter.countryId);
      }
    }
    return const ReceiptClassification(outcome: ReceiptScanOutcome.unknownFormat);
  }
}
