import 'package:flutter/material.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/pulsing_logo.dart';
import '../home/home_screen.dart';

/// First screen shown on launch: just the logo, briefly, before handing off
/// to the Home screen. No title, tagline or navigation — a calm, minimal
/// entry point rather than the full hero.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
            child: const PulsingLogo(size: 128),
          ),
        ),
      ),
    );
  }
}
