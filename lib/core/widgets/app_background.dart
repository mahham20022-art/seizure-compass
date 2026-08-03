import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Recreates the ambient radial-gradient backdrop used behind every screen
/// in ICUCalc so Seizure Compass shares the same "monitor glow" atmosphere.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.6, -1.0),
          radius: 1.4,
          colors: [Color(0x1A0EA5E9), AppColors.ink950],
          stops: [0.0, 0.6],
        ),
      ),
      child: child,
    );
  }
}
