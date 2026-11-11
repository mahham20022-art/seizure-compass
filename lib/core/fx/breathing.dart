import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'motion.dart';

/// Idle life for a small element: it swells very slightly and a soft halo
/// in [color] comes and goes. [phase] (0..1) offsets neighbours so a row of
/// them does not pulse in step.
class Breathing extends StatefulWidget {
  const Breathing({super.key, required this.child, required this.color, this.phase = 0, this.radius = 12});

  final Widget child;
  final Color color;
  final double phase;
  final double radius;

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _controller.stop();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = 0.5 + 0.5 * math.sin((_controller.value + widget.phase) * 2 * math.pi);
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(color: widget.color.withValues(alpha: 0.1 + 0.26 * t), blurRadius: 10 + 14 * t, spreadRadius: -2),
            ],
          ),
          child: Transform.scale(scale: 1 + 0.035 * t, child: child),
        );
      },
      child: widget.child,
    );
  }
}
