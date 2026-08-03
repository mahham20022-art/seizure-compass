import 'package:flutter/material.dart';

/// A hand-drawn "compare / exchange" glyph (two opposite-facing arrows) —
/// drawn as pure vector strokes instead of relying on the
/// `compare_arrows_rounded` font glyph, which does not rasterize cleanly
/// at the small sizes this app uses it at.
class CompareArrowsIcon extends StatelessWidget {
  const CompareArrowsIcon({super.key, required this.color, this.size = 18});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CompareArrowsPainter(color)),
    );
  }
}

class _CompareArrowsPainter extends CustomPainter {
  _CompareArrowsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final headLen = w * 0.22;

    final topY = h * 0.32;
    canvas.drawLine(Offset(w * 0.12, topY), Offset(w * 0.85, topY), paint);
    final topHead = Path()
      ..moveTo(w * 0.85 - headLen * 0.7, topY - headLen * 0.6)
      ..lineTo(w * 0.85, topY)
      ..lineTo(w * 0.85 - headLen * 0.7, topY + headLen * 0.6);
    canvas.drawPath(topHead, paint);

    final botY = h * 0.68;
    canvas.drawLine(Offset(w * 0.88, botY), Offset(w * 0.15, botY), paint);
    final botHead = Path()
      ..moveTo(w * 0.15 + headLen * 0.7, botY - headLen * 0.6)
      ..lineTo(w * 0.15, botY)
      ..lineTo(w * 0.15 + headLen * 0.7, botY + headLen * 0.6);
    canvas.drawPath(botHead, paint);
  }

  @override
  bool shouldRepaint(covariant _CompareArrowsPainter oldDelegate) => oldDelegate.color != color;
}
