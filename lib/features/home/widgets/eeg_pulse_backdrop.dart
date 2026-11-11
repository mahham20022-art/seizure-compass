import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/fx/eeg.dart';
import '../../../core/fx/motion.dart';
import '../../../core/theme/app_colors.dart';

/// A live EEG trace running behind the hero logo: background rhythm, then a
/// short spike-and-wave burst every few seconds. Fades out at both ends.
class EegPulseBackdrop extends StatefulWidget {
  const EegPulseBackdrop({super.key, this.width = 260, this.height = 72});

  final double width;
  final double height;

  @override
  State<EegPulseBackdrop> createState() => _EegPulseBackdropState();
}

class _EegPulseBackdropState extends State<EegPulseBackdrop> with SingleTickerProviderStateMixin {
  // 14 s holds two whole bursts (period 7 s), so the loop is seamless.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _controller.value = 0.47;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RepaintBoundary(child: CustomPaint(painter: _EegPainter(_controller))),
    );
  }
}

class _EegPainter extends CustomPainter {
  _EegPainter(this.clock) : super(repaint: clock);

  final Animation<double> clock;

  @override
  void paint(Canvas canvas, Size size) {
    final s = clock.value * 14.0;
    const window = 3.2;
    final midY = size.height / 2;
    final amp = size.height * 0.3;
    final path = Path();
    final step = math.max(1.4, size.width / 300);
    for (var x = 0.0; x <= size.width; x += step) {
      final y = midY + eegSample(s + x / size.width * window, 0, period: 7.0) * amp;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Shader fade(double alpha) => LinearGradient(
          colors: [
            AppColors.pulse.withValues(alpha: 0),
            AppColors.pulse.withValues(alpha: alpha),
            AppColors.brand.withValues(alpha: alpha),
            AppColors.brand.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ).createShader(rect);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
        ..shader = fade(0.4),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeJoin = StrokeJoin.round
        ..shader = fade(0.95),
    );
  }

  @override
  bool shouldRepaint(covariant _EegPainter oldDelegate) => oldDelegate.clock != clock;
}
