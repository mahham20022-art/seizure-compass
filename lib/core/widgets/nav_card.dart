import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'glass_card.dart';

/// One of the home screen's 2x2 navigation grid cards (Assessment,
/// Localization, Atlas, Pearls): an icon badge, title, subtitle, and a
/// circular "go" button anchored to the bottom-right corner.
class NavCard extends StatelessWidget {
  const NavCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      hoverable: true,
      borderColor: accent.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: accent, size: 24),
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 11.5, height: 1.3),
          ),
          const SizedBox(height: AppSpacing.s3),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.4)),
              ),
              child: Icon(Icons.chevron_right_rounded, color: accent, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
