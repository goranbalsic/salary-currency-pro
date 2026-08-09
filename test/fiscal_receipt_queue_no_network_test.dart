import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regression guard for PROMPT-003H's hard network boundary: neither the
/// queue screen nor the manual-expense handoff sheet may call out to
/// `suf.purs.gov.rs` or any network client — that fetch point stays behind
/// the single documented `FiscalReceiptFetchService` TODO
/// (`lib/services/fiscal_receipt_fetch_service.dart`), which this
/// checkpoint's UI never references at all. A static source scan is used
/// (rather than mocking a network layer) because the point being verified
/// is the *absence* of any network-capable import or host reference in
/// these files, not the behavior of one.
void main() {
  test('queue screen module never references a network client or the '
      'fiscal-receipt host', () {
    final source = File('lib/screens/tools/fiscal_receipt_queue_screen.dart')
        .readAsStringSync();
    expect(source.contains('suf.purs.gov.rs'), isFalse);
    expect(source.contains('dart:io'), isFalse);
    expect(source.contains("package:http"), isFalse);
    expect(source.contains('HttpClient'), isFalse);
    expect(source.contains('FiscalReceiptFetchService'), isFalse);
  });
}
