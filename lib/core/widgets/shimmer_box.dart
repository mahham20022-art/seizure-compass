import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// A minimal animated shimmer skeleton bar built with only core Flutter (no
/// extra dependency, keeping the offline-safe PWA philosophy) — used for
/// brief "working on it" loading placeholders.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, this.width, this.height = 12, this.radius = AppRadii.sm});

  final double? width;
  final double height;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

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
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.0 + _controller.value * 3, 0),
                  end: Alignment(_controller.value * 3, 0),
                  colors: const [AppColors.ink700, AppColors.ink600, AppColors.ink700],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
