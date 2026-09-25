import 'package:flutter/material.dart';

/// The "Ledger" palette: warm paper, deep green ink, brass for Pro.
@immutable
class BilansColors extends ThemeExtension<BilansColors> {
  const BilansColors({
    required this.paper,
    required this.surface,
    required this.sunken,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.green,
    required this.onGreen,
    required this.greenTint,
    required this.brick,
    required this.ochre,
    required this.slate,
    required this.brass,
    required this.brassTint,
    required this.onBrass,
    required this.brassText,
    required this.inkCard,
    required this.onInkCard,
    required this.onInkCardMuted,
    required this.inkCardLine,
    required this.accentOnInk,
    required this.positive,
    required this.warning,
    required this.warningTint,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
  });

  final Color paper;
  final Color surface;
  final Color sunken;
  final Color ink;
  final Color ink2;
  final Color ink3;
  final Color line;
  final Color green;
  final Color onGreen;
  final Color greenTint;
  final Color brick;
  final Color ochre;
  final Color slate;
  final Color brass;
  final Color brassTint;
  final Color onBrass;
  final Color brassText;

  /// The dark "result" card used for loan outcomes.
  final Color inkCard;
  final Color onInkCard;
  final Color onInkCardMuted;
  final Color inkCardLine;
  final Color accentOnInk;
  final Color positive;
  final Color warning;
  final Color warningTint;

  /// Chart series slots, validated for colour-vision deficiency (adjacent
  /// ΔE ≥ 8 under protan/deutan simulation) and ≥ 3:1 on the surface.
  /// 1 = net / principal, 2 = tax / interest, 3 = employee contributions,
  /// 4 = employer contributions.
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;

  static const light = BilansColors(
    paper: Color(0xFFF3F0E8),
    surface: Color(0xFFFBF9F4),
    sunken: Color(0xFFEAE6DC),
    ink: Color(0xFF16211C),
    ink2: Color(0xFF4A5751),
    ink3: Color(0xFF626D67),
    line: Color(0xFFD9D3C6),
    green: Color(0xFF0E5A43),
    onGreen: Color(0xFFFBF9F4),
    greenTint: Color(0xFFDCEAE2),
    brick: Color(0xFFA5402B),
    ochre: Color(0xFFC9973A),
    slate: Color(0xFF5E6E77),
    brass: Color(0xFFD9B96E),
    brassTint: Color(0xFFF1E7D0),
    onBrass: Color(0xFF3D2E0B),
    brassText: Color(0xFF6E5214),
    inkCard: Color(0xFF16211C),
    onInkCard: Color(0xFFF3F0E8),
    onInkCardMuted: Color(0xFFA9B6AF),
    inkCardLine: Color(0xFF36443E),
    accentOnInk: Color(0xFFE9C77F),
    positive: Color(0xFF1F6B47),
    warning: Color(0xFF8A5A00),
    warningTint: Color(0xFFF6E7C8),
    chart1: Color(0xFF3A9371),
    chart2: Color(0xFF8A3915),
    chart3: Color(0xFFB08926),
    chart4: Color(0xFF2677B2),
  );

  static const dark = BilansColors(
    paper: Color(0xFF0E1311),
    surface: Color(0xFF161D1A),
    sunken: Color(0xFF1B2420),
    ink: Color(0xFFE9EDE7),
    ink2: Color(0xFFB0BAB4),
    ink3: Color(0xFF8C9791),
    line: Color(0xFF27312D),
    green: Color(0xFF6CC6A1),
    onGreen: Color(0xFF0B1A14),
    greenTint: Color(0xFF16322A),
    brick: Color(0xFFE7866C),
    ochre: Color(0xFFE1B25C),
    slate: Color(0xFF9FB0BA),
    brass: Color(0xFFD8B66B),
    brassTint: Color(0xFF2E2716),
    onBrass: Color(0xFF2A200A),
    brassText: Color(0xFFE2C585),
    inkCard: Color(0xFF1E2925),
    onInkCard: Color(0xFFE9EDE7),
    onInkCardMuted: Color(0xFFA3AFA9),
    inkCardLine: Color(0xFF34423C),
    accentOnInk: Color(0xFFE9C77F),
    positive: Color(0xFF6CC6A1),
    warning: Color(0xFFE8B55A),
    warningTint: Color(0xFF2F2614),
    chart1: Color(0xFF42A388),
    chart2: Color(0xFFB54B41),
    chart3: Color(0xFFB08926),
    chart4: Color(0xFF3786C3),
  );

  @override
  BilansColors copyWith() => this;

  @override
  BilansColors lerp(ThemeExtension<BilansColors>? other, double t) {
    if (other is! BilansColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return BilansColors(
      paper: l(paper, other.paper),
      surface: l(surface, other.surface),
      sunken: l(sunken, other.sunken),
      ink: l(ink, other.ink),
      ink2: l(ink2, other.ink2),
      ink3: l(ink3, other.ink3),
      line: l(line, other.line),
      green: l(green, other.green),
      onGreen: l(onGreen, other.onGreen),
      greenTint: l(greenTint, other.greenTint),
      brick: l(brick, other.brick),
      ochre: l(ochre, other.ochre),
      slate: l(slate, other.slate),
      brass: l(brass, other.brass),
      brassTint: l(brassTint, other.brassTint),
      onBrass: l(onBrass, other.onBrass),
      brassText: l(brassText, other.brassText),
      inkCard: l(inkCard, other.inkCard),
      onInkCard: l(onInkCard, other.onInkCard),
      onInkCardMuted: l(onInkCardMuted, other.onInkCardMuted),
      inkCardLine: l(inkCardLine, other.inkCardLine),
      accentOnInk: l(accentOnInk, other.accentOnInk),
      positive: l(positive, other.positive),
      warning: l(warning, other.warning),
      warningTint: l(warningTint, other.warningTint),
      chart1: l(chart1, other.chart1),
      chart2: l(chart2, other.chart2),
      chart3: l(chart3, other.chart3),
      chart4: l(chart4, other.chart4),
    );
  }
}

extension BilansContext on BuildContext {
  BilansColors get colors => Theme.of(this).extension<BilansColors>() ?? BilansColors.light;
}

abstract final class Gap {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const page = 20.0;
}

abstract final class Radii {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 18.0;
}

abstract final class Fonts {
  static const sans = 'Plex';
  static const serif = 'SourceSerif';
  static const mono = 'PlexMono';
  static const tabular = [FontFeature.tabularFigures(), FontFeature.liningFigures()];
}
