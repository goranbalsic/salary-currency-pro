import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/tokens.dart';

class ChartSegment {
  const ChartSegment({required this.label, required this.value, required this.color, this.valueLabel});

  final String label;
  final double value;
  final Color color;

  /// Text shown in the legend next to the swatch (e.g. "62,9%").
  final String? valueLabel;
}

/// A single horizontal 100% bar split into segments, with a legend grid.
/// Segments are separated by a 2px surface gap; the outer ends are rounded.
class CompositionBar extends StatelessWidget {
  const CompositionBar({super.key, required this.segments, this.height = 14, this.semanticLabel});

  final List<ChartSegment> segments;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final visible = segments.where((s) => s.value > 0).toList();
    final total = visible.fold<double>(0, (a, s) => a + s.value);
    return Semantics(
      label: semanticLabel ?? visible.map((s) => '${s.label} ${s.valueLabel ?? ''}').join(', '),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (total > 0)
            SizedBox(
              height: height,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const gap = 2.0;
                  final available = constraints.maxWidth - gap * (visible.length - 1);
                  return Row(
                    children: [
                      for (var i = 0; i < visible.length; i++) ...[
                        if (i > 0) const SizedBox(width: gap),
                        Container(
                          width: math.max(2, available * visible[i].value / total),
                          decoration: BoxDecoration(
                            color: visible[i].color,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(i == 0 ? 4 : 1),
                              right: Radius.circular(i == visible.length - 1 ? 4 : 1),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: Gap.md),
          Wrap(
            runSpacing: 8,
            children: [
              for (final s in segments)
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(right: Gap.md),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(2)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(s.label, style: t.bodySmall!.copyWith(color: c.ink), overflow: TextOverflow.ellipsis),
                        ),
                        if (s.valueLabel != null)
                          Text(s.valueLabel!, style: t.bodySmall!.copyWith(color: c.ink2, fontFeatures: Fonts.tabular)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class StackedColumn {
  const StackedColumn({required this.label, required this.bottom, required this.top});
  final String label;
  final double bottom;
  final double top;
}

/// Stacked columns (e.g. principal below interest per loan year). Tap a
/// column to see its values.
class StackedColumns extends StatefulWidget {
  const StackedColumns({
    super.key,
    required this.columns,
    required this.bottomColor,
    required this.topColor,
    required this.bottomLabel,
    required this.topLabel,
    required this.format,
    this.height = 170,
  });

  final List<StackedColumn> columns;
  final Color bottomColor;
  final Color topColor;
  final String bottomLabel;
  final String topLabel;
  final String Function(double) format;
  final double height;

  @override
  State<StackedColumns> createState() => _StackedColumnsState();
}

class _StackedColumnsState extends State<StackedColumns> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final maxTotal = widget.columns.fold<double>(0, (m, col) => math.max(m, col.bottom + col.top));
    final sel = _selected != null && _selected! < widget.columns.length ? widget.columns[_selected!] : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: Gap.lg,
          runSpacing: 4,
          children: [
            _LegendKey(color: widget.bottomColor, label: widget.bottomLabel),
            _LegendKey(color: widget.topColor, label: widget.topLabel),
          ],
        ),
        const SizedBox(height: Gap.md),
        SizedBox(
          height: widget.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final n = widget.columns.length;
              if (n == 0 || maxTotal <= 0) return const SizedBox.shrink();
              final slot = constraints.maxWidth / n;
              final barWidth = math.min(24.0, slot * 0.62);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) {
                  final i = (d.localPosition.dx / slot).floor().clamp(0, n - 1);
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _selected = _selected == i ? null : i);
                },
                child: CustomPaint(
                  size: Size(constraints.maxWidth, widget.height),
                  painter: _ColumnsPainter(
                    columns: widget.columns,
                    maxTotal: maxTotal,
                    barWidth: barWidth,
                    bottomColor: widget.bottomColor,
                    topColor: widget.topColor,
                    baseline: c.ink,
                    surface: c.paper,
                    selected: _selected,
                    dimColor: c.paper.withValues(alpha: 0.55),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (var i = 0; i < widget.columns.length; i++)
              Expanded(
                child: Text(
                  widget.columns[i].label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: t.bodySmall!.copyWith(
                    fontSize: widget.columns.length > 12 ? 9 : 11.5,
                    color: _selected == i ? c.ink : c.ink3,
                    fontWeight: _selected == i ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 160),
          child: sel == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: Gap.sm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(Radii.md), border: Border.all(color: c.line)),
                    child: Wrap(
                      spacing: Gap.md,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(sel.label, style: t.labelMedium),
                        _LegendKey(color: widget.bottomColor, label: widget.format(sel.bottom)),
                        _LegendKey(color: widget.topColor, label: widget.format(sel.top)),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _LegendKey extends StatelessWidget {
  const _LegendKey({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: t.bodySmall!.copyWith(color: context.colors.ink, fontFeatures: Fonts.tabular)),
      ],
    );
  }
}

class _ColumnsPainter extends CustomPainter {
  _ColumnsPainter({
    required this.columns,
    required this.maxTotal,
    required this.barWidth,
    required this.bottomColor,
    required this.topColor,
    required this.baseline,
    required this.surface,
    required this.selected,
    required this.dimColor,
  });

  final List<StackedColumn> columns;
  final double maxTotal;
  final double barWidth;
  final Color bottomColor;
  final Color topColor;
  final Color baseline;
  final Color surface;
  final int? selected;
  final Color dimColor;

  @override
  void paint(Canvas canvas, Size size) {
    final n = columns.length;
    final slot = size.width / n;
    final usable = size.height - 2;
    for (var i = 0; i < n; i++) {
      final col = columns[i];
      final cx = slot * i + slot / 2;
      final left = cx - barWidth / 2;
      final hBottom = usable * col.bottom / maxTotal;
      final hTop = usable * col.top / maxTotal;
      final baseY = size.height - 1;
      // Bottom segment: square at the baseline.
      final bottomRect = Rect.fromLTWH(left, baseY - hBottom, barWidth, hBottom);
      canvas.drawRRect(
        RRect.fromRectAndCorners(bottomRect, topLeft: Radius.circular(hTop > 0 ? 1 : 4), topRight: Radius.circular(hTop > 0 ? 1 : 4)),
        Paint()..color = bottomColor,
      );
      if (hTop > 0) {
        // 2px surface gap, then the top segment with a 4px rounded data end.
        final topRect = Rect.fromLTWH(left, baseY - hBottom - 2 - hTop, barWidth, math.max(0, hTop));
        canvas.drawRRect(
          RRect.fromRectAndCorners(topRect, topLeft: const Radius.circular(4), topRight: const Radius.circular(4), bottomLeft: const Radius.circular(1), bottomRight: const Radius.circular(1)),
          Paint()..color = topColor,
        );
      }
      if (selected != null && selected != i) {
        canvas.drawRect(Rect.fromLTWH(left - 1, 0, barWidth + 2, size.height - 1), Paint()..color = dimColor);
      }
    }
    canvas.drawLine(Offset(0, size.height - 0.5), Offset(size.width, size.height - 0.5), Paint()
      ..color = baseline
      ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant _ColumnsPainter old) =>
      old.columns != columns || old.selected != selected || old.bottomColor != bottomColor || old.maxTotal != maxTotal;
}

class LinePoint {
  const LinePoint(this.x, this.y, this.label);
  final double x;
  final double y;
  final String label;
}

/// Single-series line with a 10% area wash, end dot, and touch scrubbing.
class LineChart extends StatefulWidget {
  const LineChart({
    super.key,
    required this.points,
    required this.color,
    required this.formatY,
    this.height = 150,
    this.semanticLabel,
    this.baseline,
  });

  final List<LinePoint> points;
  final Color color;
  final String Function(double) formatY;
  final double height;
  final String? semanticLabel;

  /// Draws a reference line at this value (e.g. zero) when in range.
  final double? baseline;

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  int? _index;
  Timer? _clear;

  @override
  void dispose() {
    _clear?.cancel();
    super.dispose();
  }

  void _scrub(Offset p, double width) {
    _clear?.cancel();
    final pts = widget.points;
    if (pts.length < 2) return;
    final i = ((p.dx / width) * (pts.length - 1)).round().clamp(0, pts.length - 1);
    if (i != _index) {
      unawaited(HapticFeedback.selectionClick());
      setState(() => _index = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = Theme.of(context).textTheme;
    final pts = widget.points;
    if (pts.length < 2) return SizedBox(height: widget.height);
    final active = _index == null ? null : pts[_index!];
    return Semantics(
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 22,
            child: active == null
                ? null
                : Text(
                    '${active.label} · ${widget.formatY(active.y)}',
                    style: t.labelMedium!.copyWith(fontFeatures: Fonts.tabular),
                  ),
          ),
          SizedBox(
            height: widget.height,
            child: LayoutBuilder(
              builder: (context, constraints) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (d) => _scrub(d.localPosition, constraints.maxWidth),
                onHorizontalDragUpdate: (d) => _scrub(d.localPosition, constraints.maxWidth),
                onHorizontalDragEnd: (_) => setState(() => _index = null),
                onTapDown: (d) => _scrub(d.localPosition, constraints.maxWidth),
                onTapUp: (_) {
                  _clear?.cancel();
                  _clear = Timer(const Duration(seconds: 2), () {
                    if (mounted) setState(() => _index = null);
                  });
                },
                child: CustomPaint(
                  size: Size(constraints.maxWidth, widget.height),
                  painter: _LinePainter(
                    points: pts,
                    color: widget.color,
                    grid: c.line,
                    surface: c.paper,
                    active: _index,
                    ink: c.ink2,
                    baseline: widget.baseline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.points,
    required this.color,
    required this.grid,
    required this.surface,
    required this.active,
    required this.ink,
    this.baseline,
  });

  final List<LinePoint> points;
  final Color color;
  final Color grid;
  final Color surface;
  final int? active;
  final Color ink;
  final double? baseline;

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 6.0;
    var minY = points.first.y;
    var maxY = points.first.y;
    for (final p in points) {
      minY = math.min(minY, p.y);
      maxY = math.max(maxY, p.y);
    }
    if (maxY - minY < 1e-12) {
      minY -= 1;
      maxY += 1;
    }
    Offset pos(int i) {
      final x = size.width * i / (points.length - 1);
      final y = pad + (size.height - 2 * pad) * (1 - (points[i].y - minY) / (maxY - minY));
      return Offset(x, y);
    }

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(0, pad), Offset(size.width, pad), gridPaint);
    canvas.drawLine(Offset(0, size.height - pad), Offset(size.width, size.height - pad), gridPaint);
    final b = baseline;
    if (b != null && b > minY && b < maxY) {
      final y = pad + (size.height - 2 * pad) * (1 - (b - minY) / (maxY - minY));
      final dash = Paint()
        ..color = ink.withValues(alpha: 0.6)
        ..strokeWidth = 1;
      for (var x = 0.0; x < size.width; x += 8) {
        canvas.drawLine(Offset(x, y), Offset(math.min(x + 4, size.width), y), dash);
      }
    }

    final line = Path()..moveTo(pos(0).dx, pos(0).dy);
    for (var i = 1; i < points.length; i++) {
      line.lineTo(pos(i).dx, pos(i).dy);
    }
    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = color.withValues(alpha: 0.10));
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    final idx = active ?? points.length - 1;
    final p = pos(idx);
    if (active != null) {
      canvas.drawLine(Offset(p.dx, 0), Offset(p.dx, size.height), Paint()
        ..color = ink.withValues(alpha: 0.5)
        ..strokeWidth = 1);
    }
    canvas.drawCircle(p, 6, Paint()..color = surface);
    canvas.drawCircle(p, 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.points != points || old.active != active || old.color != color || old.baseline != baseline;
}
