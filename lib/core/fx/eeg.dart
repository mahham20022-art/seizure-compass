import 'dart:math' as math;

/// A synthetic scalp-EEG sample for channel [ch] at time [s] (seconds),
/// roughly in the range -1..1. Background is a waxing and waning alpha rhythm
/// with a little beta and slow activity. Every [period] seconds a short
/// generalised 3 Hz spike-and-wave burst appears at the same moment in every
/// channel. It is an illustration, not a recording.
double eegSample(double s, int ch, {double period = 11.0}) {
  const tau = 2 * math.pi;
  final alpha = math.sin(s * tau * 9.5 + ch * 1.7) * 0.34;
  final beta = math.sin(s * tau * 21.0 + ch * 0.9) * 0.09;
  final slow = math.sin(s * tau * 2.3 + ch * 2.4) * 0.2;
  final wax = 0.55 + 0.45 * math.sin(s * tau * 0.31 + ch);
  var v = alpha * wax + beta + slow;

  final cyc = s % period;
  const start = 6.0;
  const length = 2.4;
  if (cyc > start && cyc < start + length) {
    final u = (cyc - start) / length;
    final env = math.sin(u * math.pi);
    final ph = ((cyc - start) * 3.0) % 1.0;
    final d = (ph - 0.12) / 0.05;
    final spike = math.exp(-d * d) * 1.5;
    final wave = math.sin(ph * tau - 1.3) * 0.75;
    v = v * (1 - 0.75 * env) + env * (wave - spike);
  }
  return v;
}
