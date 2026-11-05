import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Seizure Compass's own ambient radial-gradient backdrop — a faint copper
/// glow behind every screen.
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
          colors: [Color(0x1FB66C4E), AppColors.ink950],
          stops: [0.0, 0.6],
        ),
      ),
      child: child,
    );
  }
}
