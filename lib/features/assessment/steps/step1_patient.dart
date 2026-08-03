import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/yes_no_toggle.dart';
import '../../../data/models/enums.dart';
import '../assessment_controller.dart';

class Step1Patient extends StatelessWidget {
  const Step1Patient({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssessmentController>();
    final input = controller.input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          kicker: 'Step 1',
          title: 'Patient background',
          subtitle: 'Demographics and history that shape the prior probability.',
        ),
        const SizedBox(height: AppSpacing.s5),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Age (years)', hintText: 'e.g. 34'),
                      onChanged: (v) => controller.update((i) => i.ageYears = int.tryParse(v)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: DropdownButtonFormField<Sex>(
                      initialValue: input.sex,
                      decoration: const InputDecoration(labelText: 'Sex'),
                      dropdownColor: AppColors.ink800,
                      items: const [
                        DropdownMenuItem(value: Sex.female, child: Text('Female')),
                        DropdownMenuItem(value: Sex.male, child: Text('Male')),
                      ],
                      onChanged: (v) => controller.update((i) => i.sex = v),
                    ),
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
              const Text('History', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
              const Divider(height: 20),
              YesNoToggle(
                label: 'Known epilepsy',
                value: input.knownEpilepsy,
                onChanged: (v) => controller.update((i) => i.knownEpilepsy = v),
              ),
              YesNoToggle(
                label: 'Psychiatric disease',
                value: input.psychiatricDisease,
                onChanged: (v) => controller.update((i) => i.psychiatricDisease = v),
              ),
              YesNoToggle(
                label: 'Previous similar attacks',
                value: input.previousSimilarAttacks,
                onChanged: (v) => controller.update((i) => i.previousSimilarAttacks = v),
              ),
              YesNoToggle(
                label: 'Medication non-adherence',
                value: input.medicationNonAdherence,
                onChanged: (v) => controller.update((i) => i.medicationNonAdherence = v),
              ),
              YesNoToggle(
                label: 'Sleep deprivation',
                value: input.sleepDeprivation,
                onChanged: (v) => controller.update((i) => i.sleepDeprivation = v),
              ),
              YesNoToggle(
                label: 'Alcohol use',
                value: input.alcohol,
                onChanged: (v) => controller.update((i) => i.alcohol = v),
              ),
              YesNoToggle(
                label: 'Illicit drug use',
                value: input.drugUse,
                onChanged: (v) => controller.update((i) => i.drugUse = v),
              ),
              YesNoToggle(
                label: 'Fever',
                value: input.fever,
                onChanged: (v) => controller.update((i) => i.fever = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
