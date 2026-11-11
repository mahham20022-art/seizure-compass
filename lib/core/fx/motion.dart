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
    final ms = (_n * 40).clamp(0, 240);
    _n++;
    return Duration(milliseconds: ms);
  }
}

/// Passes on the ticks of [source] at no more than [fps] per second. Ambient
/// motion that sits behind a whole screen repaints through one of these, so
/// an otherwise still screen is not redrawn sixty times a second.
class FrameGate extends ChangeNotifier {
  FrameGate(this._source, {int fps = 24}) : _minMicros = 1000000 ~/ fps {
    _source.addListener(_onTick);
  }

  final Listenable _source;
  final int _minMicros;
  final Stopwatch _watch = Stopwatch()..start();
  int _last = -1000000;

  void _onTick() {
    final now = _watch.elapsedMicroseconds;
    if (now - _last >= _minMicros) {
      _last = now;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _source.removeListener(_onTick);
    super.dispose();
  }
}
