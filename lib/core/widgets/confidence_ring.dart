import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// An animated circular "confidence ring" — sweeps from 0 to [value] (0..1)
/// with an eased fill, showing the percentage in the center.
class ConfidenceRing extends StatelessWidget {
  const ConfidenceRing({
    super.key,
    required this.value,
    required this.color,
    this.size = 104,
    this.strokeWidth = 10,
    this.label,
  });

  final double value;
  final Color color;
  final double size;
  final double strokeWidth;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animated, _) {
          return CustomPaint(
            painter: _RingPainter(value: animated, color: color, strokeWidth: strokeWidth),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(animated * 100).round()}%',
                    style: TextStyle(color: color, fontSize: size * 0.22, fontWeight: FontWeight.w800),
                  ),
                  if (label != null)
                    Text(
                      label!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.color, required this.strokeWidth});

  final double value;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.15);
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * value;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}
