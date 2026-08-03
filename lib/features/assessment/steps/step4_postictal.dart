import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/findings_grid.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/finding_keys.dart';
import '../assessment_controller.dart';

class Step4Postictal extends StatelessWidget {
  const Step4Postictal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssessmentController>();
    final input = controller.input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          kicker: 'Step 4',
          title: 'Postictal features',
          subtitle: 'What happened in the minutes immediately after the event?',
        ),
        const SizedBox(height: AppSpacing.s5),
        GlassCard(
          child: FindingsGrid(
            options: postictalOptions,
            selected: input.postictalFindings,
            onToggle: (key) => controller.toggleSet(input.postictalFindings, key),
          ),
        ),
      ],
    );
  }
}
