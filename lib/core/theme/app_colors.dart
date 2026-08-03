import 'package:flutter/material.dart';

/// Seizure Compass's own neuro-violet palette — a deliberate, complete
/// departure from Najm ICUCalc's cyan "monitor-blue" identity. Built around
/// deep violet, electric purple and neon magenta on a rich charcoal ground,
/// evoking neural activity, EEG traces and electric impulses rather than an
/// ICU monitor.
class AppColors {
  AppColors._();

  static const ink950 = Color(0xFF111827); // background
  static const ink900 = Color(0xFF161F2C); // surface / drawer
  static const ink800 = Color(0xFF1B2433); // cards
  static const ink700 = Color(0xFF1F2937); // secondary background / tracks
  static const ink600 = Color(0xFF2A3648); // hover surface
  static const ink500 = Color(0xFF34435C); // lightest ink surface

  static const line = Color(0xFF2A3348);
  static const line2 = Color(0xFF4C3E73);

  static const text = Color(0xFFF8FAFC);
  static const text2 = Color(0xFFCBD5E1);
  static const muted = Color(0xFF94A3B8);
  static const faint = Color(0xFF64748B);

  static const brand = Color(0xFF8B5CF6); // Electric Purple
  static const brand2 = Color(0xFF6D28D9); // Deep Violet
  static const brand3 = Color(0xFF7C3AED); // vivid violet — primary interactive
  static const brandInk = Color(0xFFFFFFFF);

  static const ok = Color(0xFF10B981); // Emerald
  static const warn = Color(0xFFF59E0B); // Amber
  static const danger = Color(0xFFEF4444); // Rose red
  static const pulse = Color(0xFFEC4899); // Neon magenta

  /// Category colors used consistently across probability bars, chips and
  /// library tags so a category is always recognizable at a glance.
  static const epileptic = brand3; // Purple
  static const pnes = Color(0xFFEC4899); // Neon Magenta
  static const syncope = warn; // Amber
  static const otherMimic = muted; // Slate gray

  static const List<Color> backgroundGradient = [ink900, ink950];
}
