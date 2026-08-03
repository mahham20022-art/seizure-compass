import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/investigation_result_selector.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/finding_keys.dart';
import '../assessment_controller.dart';

class Step5Investigations extends StatelessWidget {
  const Step5Investigations({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssessmentController>();
    final input = controller.input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          kicker: 'Step 5',
          title: 'Investigations',
          subtitle: 'Enter any results already available. Leave as "Not done" otherwise.',
        ),
        const SizedBox(height: AppSpacing.s5),
        GlassCard(
          child: Column(
            children: [
              for (final option in investigationOptions)
                InvestigationResultSelector(
                  label: option.label,
                  value: input.investigations[option.key]!,
                  onChanged: (v) => controller.update((i) => i.investigations[option.key] = v),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
