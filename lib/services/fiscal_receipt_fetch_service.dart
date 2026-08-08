import '../models/fiscal_receipt_scan.dart';

/// The single, deliberate service boundary for a future *online* fetch of
/// actual fiscal-receipt content from a tax authority (e.g. Serbia's
/// suf.purs.gov.rs). PROMPT-003H forbids implementing that network call
/// now — every implementation of this interface in this codebase today
/// must perform zero network I/O. See [UnavailableFiscalReceiptFetchService]
/// below and `DECISIONS.md` for the boundary record.
abstract class FiscalReceiptFetchService {
  Future<FiscalReceiptFetchResult> fetchReceiptContent(FiscalReceiptScan scan);
}

enum FiscalReceiptFetchStatus {
  /// The only status this app can produce today — no implementation of
  /// [FiscalReceiptFetchService] shipped in this app performs network I/O.
  unavailable,
}

class FiscalReceiptFetchResult {
  final FiscalReceiptFetchStatus status;

  const FiscalReceiptFetchResult({required this.status});

  bool get isAvailable => status != FiscalReceiptFetchStatus.unavailable;
}

/// The only implementation of [FiscalReceiptFetchService] in this app.
/// Always reports [FiscalReceiptFetchStatus.unavailable] and performs no
/// network call, no HTTP client construction, and no browser/webview
/// launch of any kind.
///
/// TODO(Phase 12 online review): implementing real network retrieval of
/// fiscal-receipt content here requires a separate, explicit Phase 12
/// online-review approval — do not add network I/O to this class without
/// it.
class UnavailableFiscalReceiptFetchService implements FiscalReceiptFetchService {
  const UnavailableFiscalReceiptFetchService();

  @override
  Future<FiscalReceiptFetchResult> fetchReceiptContent(FiscalReceiptScan scan) async {
    return const FiscalReceiptFetchResult(status: FiscalReceiptFetchStatus.unavailable);
  }
}
