import 'package:flutter/material.dart';

/// The Tract palette (ink #1B2636, copper #B66C4E, paper #F4F0E7) adapted
/// for a dark clinical UI. Compass lives at compass.thetract.org and should
/// read as part of the same press.
class AppColors {
  AppColors._();

  static const ink950 = Color(0xFF10171F); // background
  static const ink900 = Color(0xFF151E29); // surface / drawer
  static const ink800 = Color(0xFF1B2636); // cards (The Tract ink)
  static const ink700 = Color(0xFF223044); // tracks / secondary surface
  static const ink600 = Color(0xFF2A3A50); // hover surface
  static const ink500 = Color(0xFF34465E);

  static const line = Color(0xFF29364A);
  static const line2 = Color(0xFF3B4A5F);

  static const text = Color(0xFFF4F0E7); // paper
  static const text2 = Color(0xFFD9D3C7);
  static const muted = Color(0xFFA0A8B2);
  static const faint = Color(0xFF76808C);

  static const brand = Color(0xFFD08A6C); // copper, lightened for dark ground
  static const brand2 = Color(0xFF9A5A40); // deep copper
  static const brand3 = Color(0xFFB66C4E); // The Tract copper — primary buttons
  static const brandInk = Color(0xFFFFFFFF);

  static const ok = Color(0xFF6FBF8E);
  static const warn = Color(0xFFE2A84B);
  static const danger = Color(0xFFE8685A);
  static const pulse = brand;

  /// Category colours, kept distinct from each other and from red flags.
  static const epileptic = Color(0xFFD9946F); // copper
  static const pnes = Color(0xFF7FB2D6); // steel blue
  static const syncope = Color(0xFFE2C062); // gold
  static const otherMimic = Color(0xFFA0A8B2); // slate

  static const List<Color> backgroundGradient = [ink900, ink950];
}
