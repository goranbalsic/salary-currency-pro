import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salary_currency_pro/l10n/app_localizations.dart';
import 'package:salary_currency_pro/models/fiscal_receipt_scan.dart';
import 'package:salary_currency_pro/screens/tools/fiscal_receipt_scanner_screen.dart';
import 'package:salary_currency_pro/services/fiscal_receipt_scan_service.dart';

/// A fully in-memory stand-in for mobile_scanner's platform channel, so
/// these widget tests never touch real camera hardware or a platform
/// implementation — following mobile_scanner's own `MobileScannerPlatform`
/// test-double pattern (the same `PlatformInterface` approach used by
/// packages like shared_preferences).
class FakeMobileScannerPlatform extends MobileScannerPlatform {
  /// When set, [start] throws this instead of succeeding — used to
  /// simulate permission-denied/unsupported camera states.
  MobileScannerException? startError;

  /// When true, [start] throws a plain (non-[MobileScannerException])
  /// error instead — simulates a missing platform implementation, exactly
  /// what happens in this flutter_test sandbox with no real plugin
  /// registered, and what this screen must treat as camera-unavailable.
  bool throwRawError = false;

  final _barcodes = StreamController<BarcodeCapture?>.broadcast();
  final _torch = StreamController<TorchState>.broadcast();
  final _zoom = StreamController<double>.broadcast();

  @override
  Stream<BarcodeCapture?> get barcodesStream => _barcodes.stream;

  @override
  Stream<TorchState> get torchStateStream => _torch.stream;

  @override
  Stream<double> get zoomScaleStateStream => _zoom.stream;

  @override
  Widget buildCameraView() => const SizedBox.shrink();

  @override
  Future<MobileScannerViewAttributes> start(StartOptions startOptions) async {
    if (throwRawError) {
      throw StateError('simulated missing platform implementation');
    }
    if (startError != null) {
      throw startError!;
    }
    return const MobileScannerViewAttributes(
      cameraDirection: CameraFacing.back,
      currentTorchMode: TorchState.off,
      size: Size(100, 100),
      numberOfCameras: 1,
    );
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}

  /// Simulates the camera detecting [rawValue] as a QR code's content.
  void emitBarcode(String rawValue) {
    _barcodes.add(BarcodeCapture(barcodes: [Barcode(rawValue: rawValue)]));
  }
}

Future<void> pumpScannerScreen(WidgetTester tester, FakeMobileScannerPlatform fake) async {
  MobileScannerPlatform.instance = fake;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const FiscalReceiptScannerScreen(),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    MobileScannerController.resetPlatformSessionOwner();
  });

  testWidgets('camera starts successfully: shows the live-scan hint '
      '(initial/running state)', (tester) async {
    final fake = FakeMobileScannerPlatform();
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    expect(find.text('Point your camera at a fiscal receipt QR code'), findsOneWidget);
    // The manual-entry fallback stays available even while the camera runs.
    expect(find.text('Enter manually'), findsOneWidget);
  });

  testWidgets('permission denied: shows a clear explanation and keeps '
      'manual entry reachable', (tester) async {
    final fake = FakeMobileScannerPlatform()
      ..startError = const MobileScannerException(errorCode: MobileScannerErrorCode.permissionDenied);
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    expect(find.text('Camera access needed'), findsOneWidget);
    expect(find.textContaining('system settings'), findsOneWidget);
    expect(find.text('Enter manually'), findsOneWidget);
  });

  testWidgets('camera unavailable (unexpected platform failure): shows a '
      'clear explanation and keeps manual entry reachable', (tester) async {
    final fake = FakeMobileScannerPlatform()..throwRawError = true;
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    expect(find.text('Camera unavailable'), findsOneWidget);
    expect(find.text('Enter manually'), findsOneWidget);
  });

  testWidgets('camera unsupported: shows camera-unavailable rather than '
      'crashing the rest of the screen', (tester) async {
    final fake = FakeMobileScannerPlatform()
      ..startError = const MobileScannerException(errorCode: MobileScannerErrorCode.unsupported);
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    expect(find.text('Camera unavailable'), findsOneWidget);
    expect(find.text('Enter manually'), findsOneWidget);
  });

  testWidgets('manual entry with a valid Serbian fiscal URL records a '
      'recognized scan and shows the recognized result', (tester) async {
    final fake = FakeMobileScannerPlatform()..throwRawError = true;
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enter manually'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'https://suf.purs.gov.rs/v/?vl=ABC123');
    await tester.tap(find.text('Add to queue'));
    await tester.pumpAndSettle();

    expect(find.text('Serbian fiscal receipt recognized'), findsOneWidget);

    final all = await FiscalReceiptScanService().loadAll();
    expect(all, hasLength(1));
    expect(all.first.outcome, ReceiptScanOutcome.recognized);
    expect(all.first.countryId, 'rs');
    expect(all.first.rawPayload, 'https://suf.purs.gov.rs/v/?vl=ABC123');
  });

  testWidgets('manual entry with a malformed near-match records it and '
      'shows the malformed result', (tester) async {
    final fake = FakeMobileScannerPlatform()..throwRawError = true;
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enter manually'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'https://suf.purs.gov.rs/v/');
    await tester.tap(find.text('Add to queue'));
    await tester.pumpAndSettle();

    expect(find.text("Doesn't look like a valid receipt code"), findsOneWidget);

    final all = await FiscalReceiptScanService().loadAll();
    expect(all.single.outcome, ReceiptScanOutcome.malformed);
  });

  testWidgets('manual entry with unrelated text records it as unknown '
      'format and shows that result', (tester) async {
    final fake = FakeMobileScannerPlatform()..throwRawError = true;
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enter manually'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'not a fiscal receipt at all');
    await tester.tap(find.text('Add to queue'));
    await tester.pumpAndSettle();

    expect(find.text('Not a recognized fiscal receipt'), findsOneWidget);

    final all = await FiscalReceiptScanService().loadAll();
    expect(all.single.outcome, ReceiptScanOutcome.unknownFormat);
    expect(all.single.countryId, isNull);
  });

  testWidgets('manual entry rejects empty input without recording '
      'anything', (tester) async {
    final fake = FakeMobileScannerPlatform()..throwRawError = true;
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enter manually'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to queue'));
    await tester.pumpAndSettle();

    expect(find.text('Enter some text first'), findsOneWidget);
    expect(await FiscalReceiptScanService().loadAll(), isEmpty);
  });

  testWidgets('a live camera detection records exactly one scan even if '
      'the same barcode fires twice in a row (duplicate-scan '
      'suppression)', (tester) async {
    final fake = FakeMobileScannerPlatform();
    await pumpScannerScreen(tester, fake);
    await tester.pumpAndSettle();

    fake.emitBarcode('https://suf.purs.gov.rs/v/?vl=ABC123');
    fake.emitBarcode('https://suf.purs.gov.rs/v/?vl=ABC123');
    await tester.pumpAndSettle();

    expect(find.text('Serbian fiscal receipt recognized'), findsOneWidget);

    final all = await FiscalReceiptScanService().loadAll();
    expect(all, hasLength(1));
  });

  testWidgets('leaving the scanner screen disposes the camera controller '
      'without throwing', (tester) async {
    final fake = FakeMobileScannerPlatform();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FiscalReceiptScannerScreen()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    MobileScannerPlatform.instance = fake;
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(FiscalReceiptScannerScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(FiscalReceiptScannerScreen), findsNothing);
  });
}
