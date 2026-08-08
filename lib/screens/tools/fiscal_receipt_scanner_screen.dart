import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../l10n/app_localizations.dart';
import '../../models/fiscal_receipt_scan.dart';
import '../../services/fiscal_receipt_scan_service.dart';
import '../../theme/app_theme.dart';

/// Offline QR entry point for PROMPT-003H (Stage C item 10). Captures a
/// fiscal-receipt QR payload — via the device camera or, always available,
/// manual text entry — classifies it locally through
/// [FiscalReceiptScanService], and stores it. Never performs network I/O:
/// see `FiscalReceiptFetchService` for the one deliberate future boundary
/// this feature deliberately stops short of.
///
/// Camera permission is only requested when this screen starts the
/// controller (i.e. when the user has already navigated here to scan),
/// never proactively — same policy as [NotificationService]'s permission
/// timing elsewhere in this app.
class FiscalReceiptScannerScreen extends StatefulWidget {
  const FiscalReceiptScannerScreen({super.key});

  @override
  State<FiscalReceiptScannerScreen> createState() => _FiscalReceiptScannerScreenState();
}

class _FiscalReceiptScannerScreenState extends State<FiscalReceiptScannerScreen> {
  final _service = FiscalReceiptScanService();
  late final MobileScannerController _controller;

  /// Guards against duplicate detections firing for the same code while
  /// the previous one is still being recorded, and against reacting to any
  /// detection stream event that arrives after the controller was stopped.
  bool _processingDetection = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      autoStart: false,
      formats: const [BarcodeFormat.qrCode],
    );
    unawaited(_startCamera());
  }

  Future<void> _startCamera() async {
    try {
      await _controller.start();
    } catch (error) {
      // MobileScannerController.start() only resets its own isStarting/
      // error state for a MobileScannerException; any other thrown object
      // (no platform implementation registered, an unexpected
      // platform-channel failure) would otherwise leave the controller
      // stuck reporting isStarting=true forever — an endless spinner that
      // never resolves into the camera-unavailable message below. Force a
      // definite errored state instead so that message stays reachable.
      if (!mounted) return;
      _controller.value = _controller.value.copyWith(
        isInitialized: true,
        isStarting: false,
        isRunning: false,
        error: MobileScannerException(
          errorCode: MobileScannerErrorCode.genericError,
          errorDetails: MobileScannerErrorDetails(message: error.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Deliberately not awaited: State.dispose() must be synchronous, and
    // this still tears down the platform camera session promptly so no
    // camera stays active after leaving this screen.
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_processingDetection) return;
    final raw = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
    if (raw == null || raw.trim().isEmpty) return;

    _processingDetection = true;
    await _controller.stop();
    await _recordAndShowResult(raw);
    _processingDetection = false;
  }

  Future<void> _recordAndShowResult(String rawPayload) async {
    final scan = await _service.recordScan(rawPayload);
    if (!mounted) return;
    final scanAnother = await _showResultSheet(scan);
    if (!mounted) return;
    if (scanAnother) {
      await _startCamera();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _showResultSheet(FiscalReceiptScan scan) async {
    final l10n = AppLocalizations.of(context)!;
    final (IconData icon, Color color, String title, String body) = switch (scan.outcome) {
      ReceiptScanOutcome.recognized => (
          Icons.check_circle_outline,
          AppColors.moneyGreen,
          l10n.receiptScannerResultRecognizedTitle,
          l10n.receiptScannerResultRecognizedBody(l10n.receiptScanStatusAwaitingFetch),
        ),
      ReceiptScanOutcome.malformed => (
          Icons.error_outline,
          AppColors.gold,
          l10n.receiptScannerResultMalformedTitle,
          l10n.receiptScannerResultMalformedBody,
        ),
      ReceiptScanOutcome.unknownFormat => (
          Icons.help_outline,
          AppColors.navy,
          l10n.receiptScannerResultUnknownTitle,
          l10n.receiptScannerResultUnknownBody,
        ),
    };

    final scanAnother = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.of(sheetContext).pop(true),
                child: Text(l10n.receiptScannerResultScanAnother),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => Navigator.of(sheetContext).pop(false),
                child: Text(l10n.receiptScannerResultDone),
              ),
            ],
          ),
        ),
      ),
    );
    return scanAnother ?? false;
  }

  Future<void> _openManualEntry() async {
    final l10n = AppLocalizations.of(context)!;
    final raw = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: _ManualEntrySheet(l10n: l10n),
      ),
    );
    if (!mounted || raw == null || raw.trim().isEmpty) return;
    await _recordAndShowResult(raw.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.receiptScannerScreenTitle)),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<MobileScannerState>(
              valueListenable: _controller,
              builder: (context, state, _) => _CameraBody(
                state: state,
                controller: _controller,
                onDetect: _handleDetection,
                l10n: l10n,
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: _openManualEntry,
                icon: const Icon(Icons.keyboard_alt_outlined),
                label: Text(l10n.receiptScannerManualEntryButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the camera preview and, layered on top of it, whatever the
/// current [MobileScannerController] state calls for: nothing (running),
/// a starting spinner, or a permission/unavailable message.
///
/// [MobileScanner] is always kept in the widget tree — even before the
/// camera has started — because its own `initState` is what calls
/// `controller.attach()`. `MobileScannerController.start()` waits (with a
/// timeout) for that attachment; starting it before this widget is ever
/// built would always fail with `controllerNotAttached`. This mirrors
/// mobile_scanner's own recommended usage pattern.
class _CameraBody extends StatelessWidget {
  final MobileScannerState state;
  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;
  final AppLocalizations l10n;

  const _CameraBody({
    required this.state,
    required this.controller,
    required this.onDetect,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: controller,
          onDetect: onDetect,
          // This screen owns all error/placeholder presentation below, so
          // the plugin's own default black-box error/placeholder widgets
          // are suppressed to avoid showing two conflicting messages.
          errorBuilder: (context, error) => const SizedBox.shrink(),
          placeholderBuilder: (context) => const SizedBox.shrink(),
        ),
        if (state.isRunning)
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Center(
              child: Semantics(
                liveRegion: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.receiptScannerHint,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        else if (state.error?.errorCode == MobileScannerErrorCode.permissionDenied)
          _StateMessage(
            icon: Icons.videocam_off_outlined,
            color: AppColors.alertRed,
            title: l10n.receiptScannerPermissionDeniedTitle,
            body: l10n.receiptScannerPermissionDeniedBody,
          )
        else if (state.isStarting)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(l10n.receiptScannerStarting),
              ],
            ),
          )
        else
          // Every other non-running case — an unsupported/generic camera
          // error (state.error with a code other than permissionDenied),
          // or a raw exception that wasn't a MobileScannerException at all
          // (e.g. no platform implementation available on this platform/
          // environment) — is shown as camera-unavailable. The
          // manual-entry fallback below the camera area stays reachable in
          // every one of these states.
          _StateMessage(
            icon: Icons.videocam_off_outlined,
            color: AppColors.alertRed,
            title: l10n.receiptScannerUnavailableTitle,
            body: l10n.receiptScannerUnavailableBody,
          ),
      ],
    );
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;

  const _StateMessage({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        container: true,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualEntrySheet extends StatefulWidget {
  final AppLocalizations l10n;

  const _ManualEntrySheet({required this.l10n});

  @override
  State<_ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<_ManualEntrySheet> {
  // Owned and disposed by this State (rather than the caller) so it stays
  // valid for as long as the TextField above is actually in the tree,
  // including during the bottom sheet's own close/exit animation.
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = widget.l10n.receiptScannerManualEntryEmptyError);
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.l10n.receiptScannerManualEntryTitle,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          minLines: 2,
          maxLines: 4,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.l10n.receiptScannerManualEntryHint,
            errorText: _error,
          ),
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.l10n.receiptScannerManualEntrySubmit),
        ),
      ],
    );
  }
}
