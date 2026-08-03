import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Small trust-signal pill — "Evidence-Based Clinical Decision Support" on
/// the home hero, reusable anywhere else a quick evidence badge is useful.
class EvidenceBadge extends StatelessWidget {
  const EvidenceBadge({super.key, this.label = 'Evidence-Based Clinical Decision Support'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.brand.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: AppColors.brand.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_outlined, color: AppColors.brand, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: AppColors.brand, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}
