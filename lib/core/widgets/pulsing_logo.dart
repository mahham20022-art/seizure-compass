import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_logo.dart';

/// Wraps [AppLogo] in a slow, subtle "breathing" scale + glow so the
/// compass/EEG mark feels alive without redrawing the mark itself. Used on
/// both the splash screen and the home hero.
class PulsingLogo extends StatefulWidget {
  const PulsingLogo({super.key, required this.size});

  final double size;

  @override
  State<PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<PulsingLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

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
        final t = Curves.easeInOut.transform(_controller.value);
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
          child: Transform.scale(scale: 1.0 + t * 0.03, child: child),
        );
      },
      child: AppLogo(size: widget.size),
    );
  }
}
