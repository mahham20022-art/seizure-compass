import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../fx/eeg.dart';
import '../fx/motion.dart';
import '../theme/app_colors.dart';

/// Seizure Compass's ambient backdrop, behind every screen: slow violet and
/// magenta light drifting over charcoal, and three faint EEG channels
/// running across the top. Still when the platform asks for reduced motion.
class AppBackground extends StatefulWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 66),
  );

  Timer? _start;

  // The backdrop sits behind every screen, so it repaints at a modest rate.
  late final FrameGate _gate = FrameGate(_controller, fps: 24);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _start?.cancel();
      _controller.stop();
    } else if (!_controller.isAnimating && _start == null) {
      // Let the screen arrive first; the backdrop starts moving a moment later.
      _start = Timer(const Duration(milliseconds: 1100), () {
        if (mounted) _controller.repeat();
      });
    }
  }

  @override
  void dispose() {
    _start?.cancel();
    _gate.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: CustomPaint(painter: _BackdropPainter(_controller, _gate)),
        ),
        widget.child,
      ],
    );
  }
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter(this.clock, Listenable gate) : super(repaint: gate);

  final Animation<double> clock;

  @override
  void paint(Canvas canvas, Size size) {
    // One loop is 66 s; every motion below completes whole cycles in that time, so the loop is seamless.
    final t = clock.value;
    final s = t * 66.0;
    const tau = 2 * math.pi;
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.ink950);

    void light(Color color, double alpha, double cx, double cy, double radius) {
      final center = Offset(cx * size.width, cy * size.height);
      final r = radius * math.max(size.width, size.height);
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );
    }

    light(AppColors.brand, 0.2, 0.62 + 0.16 * math.sin(t * tau * 2), -0.06 + 0.05 * math.cos(t * tau * 3), 0.62);
    light(AppColors.pulse, 0.085, 0.1 + 0.12 * math.cos(t * tau * 3), 0.3 + 0.1 * math.sin(t * tau * 2), 0.46);
    light(AppColors.brand2, 0.12, 0.9 + 0.08 * math.sin(t * tau * 4 + 1), 0.92 + 0.06 * math.cos(t * tau * 2), 0.5);

    // Three EEG channels across the top of the screen, newest on the right.
    final top = size.height * 0.07;
    final gap = math.min(46.0, size.height * 0.055);
    final amp = gap * 0.36;
    const window = 5.0; // seconds visible across the width
    final step = math.max(1.6, size.width / 420);
    for (var ch = 0; ch < 3; ch++) {
      final y0 = top + gap * ch;
      final path = Path();
      for (var x = 0.0; x <= size.width; x += step) {
        final y = y0 + eegSample(s + x / size.width * window, ch, period: 11.0) * amp;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..strokeJoin = StrokeJoin.round
          ..shader = LinearGradient(
            colors: [
              AppColors.brand.withValues(alpha: 0),
              (ch == 1 ? AppColors.pulse : AppColors.brand).withValues(alpha: 0.15),
              AppColors.brand.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) => oldDelegate.clock != clock;
}
