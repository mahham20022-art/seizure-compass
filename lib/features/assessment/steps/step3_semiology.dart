import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/card_title.dart';
import '../../../core/widgets/finding_chip.dart';
import '../../../core/widgets/findings_grid.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/finding_keys.dart';
import '../assessment_controller.dart';

class Step3Semiology extends StatelessWidget {
  const Step3Semiology({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssessmentController>();
    final input = controller.input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'The event itself',
          subtitle: 'What did the witness or video show?',
        ),
        const SizedBox(height: AppSpacing.s5),
        GlassCard(
          child: FindingsGrid(
            options: semiologyOptions,
            selected: input.semiologyFindings,
            onToggle: (key) => controller.toggleSet(input.semiologyFindings, key),
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle('Tongue bite'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final loc in TongueBiteLocation.values)
                    FindingChip(
                      label: loc.label,
                      selected: input.tongueBite == loc,
                      onTap: () => controller.update((i) => i.tongueBite = loc),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const CardTitle('Duration'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final d in SeizureDuration.values)
                    FindingChip(
                      label: d.label,
                      selected: input.duration == d,
                      onTap: () => controller.update((i) => i.duration = input.duration == d ? null : d),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle('Lateralizing signs',
                  note: 'Record the side on which you saw the sign; the app works out the hemisphere.'),
              for (final sign in lateralizingSigns)
                _SideRow(
                  sign: sign,
                  value: input.lateralSigns[sign.key],
                  onChanged: (side) => controller.update((i) {
                    if (side == null) {
                      i.lateralSigns.remove(sign.key);
                    } else {
                      i.lateralSigns[sign.key] = side;
                    }
                  }),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SideRow extends StatelessWidget {
  const _SideRow({required this.sign, required this.value, required this.onChanged});

  final LateralizingSign sign;
  final Side? value;
  final ValueChanged<Side?> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget seg(String text, Side? side) {
      final active = value == side;
      return Semantics(
        button: true,
        selected: active,
        label: '${sign.label}: $text',
        child: InkWell(
          onTap: () => onChanged(side),
          borderRadius: BorderRadius.circular(AppRadii.sm),
          child: Container(
            width: 58,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active && side != null ? AppColors.brand.withValues(alpha: 0.18) : AppColors.ink800,
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: active && side != null ? AppColors.brand : AppColors.line),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: active && side != null ? AppColors.brand : AppColors.muted,
                fontSize: 12.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sign.label, style: const TextStyle(color: AppColors.text2, fontSize: 13.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(sign.sideLabel, style: const TextStyle(color: AppColors.faint, fontSize: 11.5)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          seg('—', null),
          const SizedBox(width: 6),
          seg('L', Side.left),
          const SizedBox(width: 6),
          seg('R', Side.right),
        ],
      ),
    );
  }
}
