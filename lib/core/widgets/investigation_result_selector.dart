import 'package:flutter/material.dart';
import '../../data/models/enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Three-way Not done / Normal / Abnormal selector used on the
/// Investigations step.
class InvestigationResultSelector extends StatelessWidget {
  const InvestigationResultSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final InvestigationResult value;
  final ValueChanged<InvestigationResult> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.text2, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              _seg('Not done', InvestigationResult.notDone, AppColors.faint),
              const SizedBox(width: 8),
              _seg('Normal', InvestigationResult.normal, AppColors.ok),
              const SizedBox(width: 8),
              _seg('Abnormal', InvestigationResult.abnormal, AppColors.danger),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seg(String text, InvestigationResult option, Color activeColor) {
    final active = value == option;
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(option),
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? activeColor.withValues(alpha: 0.16) : AppColors.ink800,
            borderRadius: BorderRadius.circular(AppRadii.sm),
            border: Border.all(color: active ? activeColor : AppColors.line),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: active ? activeColor : AppColors.muted,
              fontSize: 12,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
