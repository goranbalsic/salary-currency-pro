import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';

/// A QR code drawn dark-on-white with a quiet zone, whatever the theme —
/// banking apps scan it reliably only that way round.
class QrView extends StatelessWidget {
  const QrView({super.key, required this.data, this.size = 180, this.semanticLabel});

  final String data;
  final double size;
  final String? semanticLabel;

  /// NBS IPS requires error-correction level M.
  static final _qr = Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.06),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: CustomPaint(painter: _QrPainter(data)),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.data);
  final String data;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..isAntiAlias = false;
    final side = size.shortestSide;
    for (final e in QrView._qr.make(data, width: side, height: side)) {
      if (e is BarcodeBar && e.black) {
        // Slight overlap hides hairline seams between adjacent modules.
        canvas.drawRect(Rect.fromLTWH(e.left, e.top, e.width + 0.5, e.height + 0.5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.data != data;
}
