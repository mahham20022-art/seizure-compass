import 'package:flutter/material.dart';

/// Ink/brand palette carried over from the Najm ICUCalc design system so
/// Seizure Compass reads as part of the same product family.
class AppColors {
  AppColors._();

  static const ink950 = Color(0xFF03080F);
  static const ink900 = Color(0xFF060D19);
  static const ink800 = Color(0xFF0A1424);
  static const ink700 = Color(0xFF0F1E35);
  static const ink600 = Color(0xFF142A48);
  static const ink500 = Color(0xFF1C355A);

  static const line = Color(0xFF1A2942);
  static const line2 = Color(0xFF26406B);

  static const text = Color(0xFFEAF1FB);
  static const text2 = Color(0xFFB8C6DC);
  static const muted = Color(0xFF7F92AE);
  static const faint = Color(0xFF4D5F80);

  static const brand = Color(0xFF22D3EE);
  static const brand2 = Color(0xFF0EA5E9);
  static const brand3 = Color(0xFF38BDF8);
  static const brandInk = Color(0xFF001018);

  static const ok = Color(0xFF34D399);
  static const warn = Color(0xFFFBBF24);
  static const danger = Color(0xFFF87171);
  static const pulse = Color(0xFFF43F5E);

  /// Category colors used consistently across probability bars, chips and
  /// library tags so a category is always recognizable at a glance.
  static const epileptic = brand3;
  static const pnes = Color(0xFFA78BFA);
  static const syncope = ok;
  static const otherMimic = warn;

  static const List<Color> backgroundGradient = [ink900, ink950];
}
