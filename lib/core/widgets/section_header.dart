import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Small kicker + title heading used to open a page section, e.g.
/// "STEP 2 OF 5 — Aura Symptoms".
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.kicker,
    this.subtitle,
  });

  final String title;
  final String? kicker;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kicker != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              kicker!.toUpperCase(),
              style: const TextStyle(
                color: AppColors.brand,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              subtitle!,
              style: const TextStyle(color: AppColors.muted, fontSize: 14, height: 1.4),
            ),
          ),
      ],
    );
  }
}
