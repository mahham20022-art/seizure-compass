import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/card_title.dart';
import '../../../core/widgets/finding_chip.dart';
import '../../../core/widgets/findings_grid.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/yes_no_toggle.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/finding_keys.dart';
import '../assessment_controller.dart';

class Step1Patient extends StatelessWidget {
  const Step1Patient({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssessmentController>();
    final input = controller.input;

    YesNoToggle toggle(String label, bool? value, void Function(bool?) set) =>
        YesNoToggle(label: label, value: value, onChanged: (v) => controller.update((_) => set(v)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          kicker: 'Step 1',
          title: 'Patient and setting',
          subtitle: 'Setting sets the starting probabilities; red flags are checked before anything else.',
        ),
        const SizedBox(height: AppSpacing.s5),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle('Setting',
                  note: 'Changes only the prior. Choose "No prior" to see what the features alone say.'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final s in ClinicalSetting.values)
                    FindingChip(
                      label: s.label,
                      selected: input.setting == s,
                      onTap: () => controller.update((i) => i.setting = s),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.s5),
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
          borderColor: AppColors.danger.withValues(alpha: 0.45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle('Cardiac red flags',
                  color: AppColors.danger,
                  note: 'Any one of these makes arrhythmic syncope possible (ESC 2018).'),
              FindingsGrid(
                options: cardiacFlagOptions,
                selected: input.redFlags,
                onToggle: (k) => controller.toggleSet(input.redFlags, k),
              ),
              const SizedBox(height: AppSpacing.s5),
              const CardTitle('Neurological red flags', color: AppColors.danger),
              FindingsGrid(
                options: neuroFlagOptions,
                selected: input.redFlags,
                onToggle: (k) => controller.toggleSet(input.redFlags, k),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardTitle('History'),
              toggle('Known epilepsy', input.knownEpilepsy, (v) => input.knownEpilepsy = v),
              toggle('Psychiatric comorbidity', input.psychiatricDisease, (v) => input.psychiatricDisease = v),
              toggle('Previous similar attacks', input.previousSimilarAttacks, (v) => input.previousSimilarAttacks = v),
              toggle('Missed antiseizure medication', input.medicationNonAdherence, (v) => input.medicationNonAdherence = v),
              toggle('Sleep deprivation', input.sleepDeprivation, (v) => input.sleepDeprivation = v),
              toggle('Alcohol intoxication or withdrawal', input.alcohol, (v) => input.alcohol = v),
              toggle('Drug use or withdrawal', input.drugUse, (v) => input.drugUse = v),
              toggle('Fever', input.fever, (v) => input.fever = v),
            ],
          ),
        ),
      ],
    );
  }
}
