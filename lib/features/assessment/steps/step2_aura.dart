import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/findings_grid.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/finding_keys.dart';
import '../assessment_controller.dart';

class Step2Aura extends StatelessWidget {
  const Step2Aura({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssessmentController>();
    final input = controller.input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          kicker: 'Step 2',
          title: 'Aura symptoms',
          subtitle: 'Select any warning symptoms reported immediately before the event.',
        ),
        const SizedBox(height: AppSpacing.s5),
        GlassCard(
          child: FindingsGrid(
            options: auraOptions,
            selected: input.auraFindings,
            onToggle: (key) => controller.toggleSet(input.auraFindings, key),
          ),
        ),
      ],
    );
  }
}
