import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Home-only ambient backdrop: a slowly drifting soft glow plus a sparse
/// field of gently rising, pulsing particles — layered behind the hero
/// content so the home page reads as "alive" without distracting from it.
/// Deliberately scoped to Home; every other screen stays calmer for
/// clinical readability.
class HomeAmbientBackdrop extends StatefulWidget {
  const HomeAmbientBackdrop({super.key, required this.child});

  final Widget child;

  @override
  State<HomeAmbientBackdrop> createState() => _HomeAmbientBackdropState();
}

class _HomeAmbientBackdropState extends State<HomeAmbientBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value * 2 * math.pi;
              final dx = 0.55 + math.sin(t) * 0.18;
              final dy = -0.9 + math.cos(t * 0.8) * 0.12;
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(dx, dy),
                    radius: 1.3,
                    colors: const [Color(0x2E8B5CF6), Colors.transparent],
                    stops: const [0.0, 0.7],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(painter: _ParticlePainter(_controller.value)),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  _Particle({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.phase,
    required this.speed,
    required this.color,
  });

  final double dx;
  final double dy;
  final double radius;
  final double phase;
  final double speed;
  final Color color;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.t);

  final double t;

  static final List<_Particle> _particles = List.generate(20, (i) {
    final rnd = math.Random(i * 97 + 13);
    const colors = [AppColors.brand, AppColors.pnes, AppColors.warn];
    return _Particle(
      dx: rnd.nextDouble(),
      dy: rnd.nextDouble(),
      radius: 1.0 + rnd.nextDouble() * 1.8,
      phase: rnd.nextDouble() * 2 * math.pi,
      speed: 0.4 + rnd.nextDouble() * 0.6,
      color: colors[i % colors.length],
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final wobble = math.sin(t * 2 * math.pi * p.speed + p.phase);
      final x = (p.dx * size.width + wobble * 10).clamp(0.0, size.width);
      final y = (p.dy * size.height + t * size.height * 0.05 * p.speed) % size.height;
      final opacity = (0.25 + 0.35 * (0.5 + 0.5 * math.sin(t * 2 * math.pi * p.speed + p.phase))).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => oldDelegate.t != t;
}
