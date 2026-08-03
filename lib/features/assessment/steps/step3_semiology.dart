import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
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
          kicker: 'Step 3',
          title: 'Ictal semiology',
          subtitle: 'What did the event itself look like?',
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
              const Text('Tongue bite', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: TongueBiteLocation.values.map((loc) {
                  return FindingChip(
                    label: loc.label,
                    selected: input.tongueBite == loc,
                    onTap: () => controller.update((i) => i.tongueBite = loc),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Duration', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: SeizureDuration.values.map((d) {
                  return FindingChip(
                    label: d.label,
                    selected: input.duration == d,
                    onTap: () => controller.update((i) => i.duration = d),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
