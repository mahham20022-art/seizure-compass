import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/pulsing_logo.dart';
import '../home/home_screen.dart';

/// First screen shown on launch: the logo, a sonar-style pulse effect and
/// the tagline, held for a few seconds before handing off to the Home
/// screen. Deliberately minimal — no title, buttons or navigation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  bool _showTagline = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 550), () {
      if (mounted) setState(() => _showTagline = true);
    });
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entranceCurve = CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack);
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _entrance,
                child: ScaleTransition(
                  scale: Tween(begin: 0.8, end: 1.0).animate(entranceCurve),
                  child: const _SplashRipple(child: PulsingLogo(size: 132)),
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              AnimatedOpacity(
                opacity: _showTagline ? 1 : 0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _showTagline ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOut,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'Seizure ', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 22)),
                          TextSpan(text: 'Compass', style: TextStyle(color: AppColors.brand3, fontWeight: FontWeight.w800, fontSize: 22)),
                        ]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Navigate  •  Differentiate  •  Localize',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 13.5, letterSpacing: 0.4, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A slow sonar-style pulse: 2 rings expand outward from behind the logo
/// and fade, looping continuously while the splash screen is shown.
class _SplashRipple extends StatefulWidget {
  const _SplashRipple({required this.child});

  final Widget child;

  @override
  State<_SplashRipple> createState() => _SplashRippleState();
}

class _SplashRippleState extends State<_SplashRipple> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
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
      builder: (context, child) => CustomPaint(painter: _RipplePainter(_controller.value), child: child),
      child: widget.child,
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius = size.shortestSide * 0.52;
    final spread = size.shortestSide * 0.85;

    for (final phase in [0.0, 0.5]) {
      final t = (progress + phase) % 1.0;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.brand3.withValues(alpha: (1 - t) * 0.35);
      canvas.drawCircle(center, baseRadius + spread * t, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) => oldDelegate.progress != progress;
}
