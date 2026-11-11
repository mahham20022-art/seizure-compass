import 'package:flutter/widgets.dart';

/// True when the platform asks for reduced motion. Every ambient or entrance
/// animation in the app checks this and falls back to a still frame.
bool reduceMotion(BuildContext context) => MediaQuery.maybeOf(context)?.disableAnimations ?? false;

/// Hands out short, increasing delays to widgets that appear in the same
/// burst (a screen being built), so they enter one after another instead of
/// all at once. The sequence restarts after a quiet gap.
class Stagger {
  Stagger._();

  static DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);
  static int _n = 0;

  static Duration next() {
    final now = DateTime.now();
    if (now.difference(_last).inMilliseconds > 120) _n = 0;
    _last = now;
    final ms = (_n * 55).clamp(0, 440);
    _n++;
    return Duration(milliseconds: ms);
  }
}
