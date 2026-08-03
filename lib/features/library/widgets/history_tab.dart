import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/repositories/epilepsy_history_data.dart';

/// Library > History tab: where the words "epilepsy" and "seizure" come
/// from, followed by a brief timeline of the disease's medical history.
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WHERE THE WORDS COME FROM',
                style: TextStyle(color: AppColors.brand, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 1.4),
              ),
              const SizedBox(height: 12),
              _wordBlock(
                'Epilepsy',
                'From the Greek epilēpsia, itself from epilambanein — epi- ("upon") + lambanein '
                '("to take or seize"). Literally "to be seized upon" or "to be taken hold of," '
                'reflecting the ancient sense of a seizure as something external overtaking the '
                'person.',
              ),
              const SizedBox(height: 14),
              _wordBlock(
                'Seizure',
                'From the Old French seisir and Anglo-Latin sacire, "to take possession of" — '
                'originally a legal term for taking possession of property (the root of "seisin" '
                'in property law), later adopted into medicine to describe the body being '
                'suddenly "taken hold of" by a disease process.',
              ),
              const SizedBox(height: 10),
              const Text(
                'Both roots converge on the same image, centuries and languages apart: '
                'something suddenly seizing hold of the body.',
                style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'A BRIEF HISTORY',
            style: TextStyle(color: AppColors.brand, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.6),
          ),
        ),
        for (final event in epilepsyHistory)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.era.toUpperCase(),
                    style: const TextStyle(color: AppColors.brand3, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(event.title, style: const TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(event.description, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.5)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _wordBlock(String word, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(word, style: const TextStyle(color: AppColors.text, fontSize: 14.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.5)),
      ],
    );
  }
}
