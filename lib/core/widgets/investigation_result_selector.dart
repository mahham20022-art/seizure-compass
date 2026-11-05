import 'package:flutter/material.dart';
import '../../data/models/enums.dart';
import '../../data/models/finding_keys.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Segmented result selector for one investigation on step 5.
class InvestigationResultSelector extends StatelessWidget {
  const InvestigationResultSelector({
    super.key,
    required this.option,
    required this.value,
    required this.onChanged,
  });

  final InvestigationOption option;
  final InvestigationResult value;
  final ValueChanged<InvestigationResult> onChanged;

  static Color _color(InvestigationResult r) => switch (r) {
        InvestigationResult.notDone => AppColors.faint,
        InvestigationResult.normal => AppColors.ok,
        InvestigationResult.nonSpecific => AppColors.warn,
        InvestigationResult.abnormal => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(option.label, style: const TextStyle(color: AppColors.text2, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var k = 0; k < option.results.length; k++) ...[
                if (k > 0) const SizedBox(width: 8),
                _seg(option.labelFor(option.results[k]), option.results[k]),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _seg(String text, InvestigationResult r) {
    final active = value == r;
    final c = _color(r);
    return Expanded(
      child: Semantics(
        button: true,
        selected: active,
        label: '${option.label}: $text',
        child: InkWell(
          onTap: () => onChanged(r),
          borderRadius: BorderRadius.circular(AppRadii.sm),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? c.withValues(alpha: 0.16) : AppColors.ink800,
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: active ? c : AppColors.line),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: active ? c : AppColors.muted,
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
