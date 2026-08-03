import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/clinical_pearl.dart';
import '../../data/repositories/clinical_pearls_data.dart';
import '../search/search_screen.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Epilepsy vs PNES':
      return Icons.compare_arrows_rounded;
    case 'Localization':
      return Icons.route_rounded;
    case 'Syndromes':
      return Icons.account_tree_rounded;
    case 'Mimics':
      return Icons.warning_amber_rounded;
    case 'Investigations':
      return Icons.science_rounded;
    default:
      return Icons.lightbulb_outline_rounded;
  }
}

Color _levelColor(EvidenceLevel level) {
  switch (level) {
    case EvidenceLevel.classic:
      return AppColors.brand3;
    case EvidenceLevel.supportive:
      return AppColors.ok;
    case EvidenceLevel.expert:
      return AppColors.pnes;
  }
}

class PearlsScreen extends StatelessWidget {
  const PearlsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final byCategory = <String, List<ClinicalPearl>>{};
    for (final pearl in clinicalPearls) {
      byCategory.putIfAbsent(pearl.category, () => []).add(pearl);
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Clinical pearls'),
          actions: [SearchAction()],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  const SectionHeader(
                    kicker: 'Module 4',
                    title: 'Short, evidence-based teaching notes',
                    subtitle: 'Tap a card for its clinical context and category.',
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  for (final category in byCategory.keys) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 6),
                      child: Row(
                        children: [
                          Icon(categoryIcon(category), color: AppColors.brand, size: 15),
                          const SizedBox(width: 6),
                          Text(
                            category.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.brand,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 620 ? 2 : 1;
                        return GridView.count(
                          crossAxisCount: columns,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: AppSpacing.s3,
                          crossAxisSpacing: AppSpacing.s3,
                          childAspectRatio: columns == 2 ? 2.5 : 3.1,
                          children: [
                            for (final pearl in byCategory[category]!) _PearlFlashCard(pearl: pearl),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.s2),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown from both the pearls flashcard grid and global search results.
void showPearlReference(BuildContext context, ClinicalPearl pearl) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.ink800,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(color: AppColors.line2, borderRadius: BorderRadius.circular(AppRadii.pill)),
          ),
          Row(
            children: [
              Icon(categoryIcon(pearl.category), color: AppColors.brand3, size: 18),
              const SizedBox(width: 8),
              Text(pearl.category, style: const TextStyle(color: AppColors.brand3, fontSize: 12.5, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Text(pearl.title, style: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(pearl.text, style: const TextStyle(color: AppColors.text2, fontSize: 14, height: 1.5)),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Clinical context: derived from widely taught seizure-semiology '
            'teaching literature and used here as a heuristic aid, not a '
            'graded systematic-review recommendation. Always correlate with '
            'the full clinical picture.',
            style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    ),
  );
}

class _PearlFlashCard extends StatelessWidget {
  const _PearlFlashCard({required this.pearl});

  final ClinicalPearl pearl;

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(pearl.level);
    return GlassCard(
      hoverable: true,
      onTap: () => showPearlReference(context, pearl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(categoryIcon(pearl.category), color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pearl.title, style: const TextStyle(color: AppColors.text, fontSize: 14.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  pearl.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.text2, fontSize: 12.5, height: 1.4),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Text(pearl.level.label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
