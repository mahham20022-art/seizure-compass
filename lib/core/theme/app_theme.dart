import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radii.dart';

/// Material 3 dark theme tuned to match the Najm ICUCalc "monitor-blue"
/// design language: deep ink backgrounds, cyan brand accents, calm rounded
/// cards.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.ink950,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.ink900,
        primary: AppColors.brand3,
        secondary: AppColors.brand,
        error: AppColors.danger,
        onSurface: AppColors.text,
        onPrimary: AppColors.brandInk,
      ),
      fontFamily: 'Inter',
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.text,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.ink800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand3,
          foregroundColor: AppColors.brandInk,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text2,
          side: const BorderSide(color: AppColors.line2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.ink700,
        selectedColor: AppColors.brand3,
        labelStyle: const TextStyle(color: AppColors.text2, fontSize: 13),
        secondaryLabelStyle:
            const TextStyle(color: AppColors.brandInk, fontSize: 13, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          side: const BorderSide(color: AppColors.line2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.ink800,
        hintStyle: const TextStyle(color: AppColors.faint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.brand3, width: 1.5),
        ),
      ),
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values) platform: const _FadeScalePageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// A calmer, "premium" cross-fade + slight scale used for every push/pop
/// instead of the platform-default slide, on every platform (so the web
/// build feels consistent regardless of host OS).
class _FadeScalePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeScalePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween(begin: 0.98, end: 1.0).animate(curved),
        child: child,
      ),
    );
  }
}
