import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Persistent medical-disclaimer strip. Shown on the home screen and at the
/// bottom of every result so the tool is never mistaken for a diagnostic
/// device.
class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key, this.compact = false});

  final bool compact;

  static const _text =
      'Seizure Compass is a clinical decision-support aid based on published '
      'seizure semiology literature. It estimates probabilities only — it '
      'does NOT diagnose epilepsy or any other condition. Always correlate '
      'with history, EEG, imaging and clinical judgement.';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.s3 : AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.warn.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warn, size: 18),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              _text,
              style: TextStyle(
                color: AppColors.text2,
                fontSize: compact ? 11.5 : 12.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
