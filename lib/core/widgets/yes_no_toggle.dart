import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Compact Yes / No / Unknown segmented control used for the Patient step's
/// tri-state history questions.
class YesNoToggle extends StatelessWidget {
  const YesNoToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;

  /// null = unknown/unset
  final bool? value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.text2, fontSize: 14),
            ),
          ),
          _segment('No', value == false, () => onChanged(false)),
          const SizedBox(width: 6),
          _segment('Yes', value == true, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _segment(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: Container(
        width: 56,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.brand3 : AppColors.ink700,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          border: Border.all(color: active ? AppColors.brand3 : AppColors.line),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? AppColors.brandInk : AppColors.text2,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
