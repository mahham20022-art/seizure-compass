import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The Seizure Compass mark: a compass dial with tick marks and a
/// true-north marker, a stylized brain at its center, an ECG trace running
/// through it, and a gradient needle swinging from white to cyan.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ink700, AppColors.ink900],
        ),
        border: Border.all(color: AppColors.line2),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand3.withValues(alpha: 0.25),
            blurRadius: 32,
            spreadRadius: -6,
          ),
        ],
      ),
      child: CustomPaint(painter: _CompassPainter(), size: Size.square(size)),
    );
  }
}

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.5;

    _paintEcg(canvas, size);
    _paintBrain(canvas, center, r);
    _paintDialAndTicks(canvas, center, r);
    _paintNorthMarker(canvas, center, r);
    _paintNeedle(canvas, center, r);
  }

  void _paintEcg(Canvas canvas, Size size) {
    final w = size.width;
    final midY = size.height / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.028
      ..strokeCap = StrokeCap.round
      ..color = AppColors.brand3.withValues(alpha: 0.55);

    final path = Path()
      ..moveTo(0, midY)
      ..lineTo(w * 0.12, midY)
      ..lineTo(w * 0.22, midY - w * 0.11)
      ..lineTo(w * 0.30, midY + w * 0.14)
      ..lineTo(w * 0.38, midY)
      ..lineTo(w * 0.62, midY)
      ..lineTo(w * 0.70, midY - w * 0.14)
      ..lineTo(w * 0.78, midY + w * 0.11)
      ..lineTo(w * 0.88, midY)
      ..lineTo(w, midY);

    canvas.drawPath(path, paint);
  }

  void _paintBrain(Canvas canvas, Offset center, double r) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.035
      ..strokeCap = StrokeCap.round
      ..color = AppColors.text2.withValues(alpha: 0.5);

    final bw = r * 0.62;
    final bh = r * 0.66;
    final outline = Path()
      ..addOval(Rect.fromCenter(center: center, width: bw * 2, height: bh * 2));
    canvas.drawPath(outline, paint);

    // Central divide (corpus callosum line).
    canvas.drawLine(
      Offset(center.dx, center.dy - bh * 0.85),
      Offset(center.dx, center.dy + bh * 0.85),
      paint,
    );

    // A few gyri folds on each hemisphere.
    for (final side in [-1.0, 1.0]) {
      for (final t in [-0.45, 0.0, 0.45]) {
        final foldCenter = Offset(center.dx + side * bw * 0.45, center.dy + bh * t);
        final rect = Rect.fromCenter(center: foldCenter, width: bw * 0.55, height: bh * 0.4);
        canvas.drawArc(rect, math.pi * 0.15, math.pi * 0.7, false, paint);
      }
    }
  }

  void _paintDialAndTicks(Canvas canvas, Offset center, double r) {
    final ringR = r * 0.86;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.02
      ..color = AppColors.line2;
    canvas.drawCircle(center, ringR, ringPaint);

    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.018
      ..color = AppColors.faint;

    for (var i = 0; i < 24; i++) {
      final angle = (i * 15) * math.pi / 180;
      final outer = Offset(
        center.dx + ringR * math.cos(angle),
        center.dy + ringR * math.sin(angle),
      );
      final tickLen = i % 6 == 0 ? ringR * 0.14 : ringR * 0.07;
      final inner = Offset(
        center.dx + (ringR - tickLen) * math.cos(angle),
        center.dy + (ringR - tickLen) * math.sin(angle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }
  }

  void _paintNorthMarker(Canvas canvas, Offset center, double r) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.brand3;

    final tipY = center.dy - r * 0.98;
    final baseY = center.dy - r * 0.86;
    final path = Path()
      ..moveTo(center.dx, tipY)
      ..lineTo(center.dx - r * 0.05, baseY)
      ..lineTo(center.dx + r * 0.05, baseY)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _paintNeedle(Canvas canvas, Offset center, double r) {
    const tiltDeg = 40.0;
    final theta = -tiltDeg * math.pi / 180;
    final axis = Offset(math.cos(theta), math.sin(theta));
    final perp = Offset(-axis.dy, axis.dx);

    final tipNorth = center + axis * (r * 0.72);
    final tipSouth = center - axis * (r * 0.8);
    final width = r * 0.075;

    final northPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(colors: [Colors.white, AppColors.brand3])
          .createShader(Rect.fromPoints(center, tipNorth));
    final northHalf = Path()
      ..moveTo(center.dx + perp.dx * width, center.dy + perp.dy * width)
      ..lineTo(tipNorth.dx, tipNorth.dy)
      ..lineTo(center.dx - perp.dx * width, center.dy - perp.dy * width)
      ..close();
    canvas.drawPath(northHalf, northPaint);

    final southPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.line2;
    final southHalf = Path()
      ..moveTo(center.dx + perp.dx * width, center.dy + perp.dy * width)
      ..lineTo(tipSouth.dx, tipSouth.dy)
      ..lineTo(center.dx - perp.dx * width, center.dy - perp.dy * width)
      ..close();
    canvas.drawPath(southHalf, southPaint);

    // Glow at the bright (north/cyan) tip.
    final glowPaint = Paint()
      ..color = AppColors.brand3.withValues(alpha: 0.55)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(tipNorth, r * 0.12, glowPaint);

    // Pivot.
    canvas.drawCircle(center, r * 0.07, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      r * 0.07,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.015
        ..color = AppColors.ink900,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
