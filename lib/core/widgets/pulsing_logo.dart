import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../fx/motion.dart';
import '../theme/app_colors.dart';
import 'app_logo.dart';

/// The compass mark, alive: a slow breathing glow, and a needle that is
/// nudged every few seconds, swings and settles back on its heading like a
/// real compass. Used on the home hero.
class PulsingLogo extends StatefulWidget {
  const PulsingLogo({super.key, required this.size});

  final double size;

  @override
  State<PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<PulsingLogo> with TickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );
  late final AnimationController _swing = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _breath.stop();
      _swing.stop();
    } else if (!_breath.isAnimating) {
      _breath.repeat(reverse: true);
      _swing.repeat();
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    _swing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breath, _swing]),
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_breath.value);
        // A damped oscillation that starts and ends at rest, so the loop has no jump.
        final u = _swing.value;
        final turn = 0.55 * math.sin(u * 2 * math.pi * 4.0) * math.exp(-5.5 * u) * math.sin(math.min(1.0, u * 12) * math.pi / 2);
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.brand3.withValues(alpha: 0.18 + t * 0.16),
                blurRadius: 40 + t * 20,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Transform.scale(
            scale: 1.0 + t * 0.03,
            child: AppLogo(size: widget.size, needleTurn: turn),
          ),
        );
      },
    );
  }
}
