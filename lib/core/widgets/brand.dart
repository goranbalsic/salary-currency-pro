import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// The Bilans mark: a serif B over an accountant's double rule.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? const Color(0xFF1E2925) : const Color(0xFF0E5A43);
    final fg = dark ? const Color(0xFF6CC6A1) : const Color(0xFFF3F0E8);
    const rule = Color(0xFFD9B96E);
    final s = size / 108;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(26 * s)),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 10 * s,
              child: Text(
                'B',
                textAlign: TextAlign.center,
                textScaler: TextScaler.noScaling,
                style: TextStyle(fontFamily: Fonts.serif, fontWeight: FontWeight.w600, fontSize: 60 * s, color: fg, height: 1.0),
              ),
            ),
            Positioned(left: 31 * s, right: 31 * s, top: 80 * s, child: _bar(4 * s, rule)),
            Positioned(left: 31 * s, right: 31 * s, top: 88 * s, child: _bar(4 * s, rule)),
          ],
        ),
      ),
    );
  }

  static Widget _bar(double h, Color c) => Container(height: h, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(h / 2)));
}

/// "Bilans" set in the serif face.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 30});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bilans',
      style: TextStyle(
        fontFamily: Fonts.serif,
        fontWeight: FontWeight.w600,
        fontSize: size,
        letterSpacing: -0.01 * size,
        color: context.colors.ink,
        height: 1.1,
      ),
    );
  }
}
