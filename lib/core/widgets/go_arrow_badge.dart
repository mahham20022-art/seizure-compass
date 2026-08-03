import 'package:flutter/material.dart';

/// A small circular "go" button used at the bottom-right of nav cards —
/// drawn as pure vector strokes (not a font glyph), so it renders
/// identically everywhere regardless of icon-font tree-shaking/glyph
/// quirks.
class GoArrowBadge extends StatelessWidget {
  const GoArrowBadge({super.key, required this.color, this.size = 34});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.24),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.75), width: 1.4),
      ),
      child: CustomPaint(painter: _ArrowPainter(color)),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = size.width * 0.17;

    canvas.drawLine(Offset(cx - half, cy), Offset(cx + half * 0.9, cy), paint);

    final head = Path()
      ..moveTo(cx + half * 0.15, cy - half * 0.85)
      ..lineTo(cx + half, cy)
      ..lineTo(cx + half * 0.15, cy + half * 0.85);
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) => oldDelegate.color != color;
}
