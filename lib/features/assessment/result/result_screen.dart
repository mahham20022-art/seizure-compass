import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/brain_diagram.dart';
import '../../../core/widgets/disclaimer_banner.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/probability_bar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/assessment_result.dart';
import '../../../data/models/enums.dart';
import '../../localization/localization_screen.dart';
import 'widgets/finding_list.dart';
import 'widgets/probability_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final AssessmentResult result;

  static const _categoryColors = {
    EventCategory.epileptic: AppColors.epileptic,
    EventCategory.pnes: AppColors.pnes,
    EventCategory.syncope: AppColors.syncope,
    EventCategory.otherMimic: AppColors.otherMimic,
  };

  @override
  Widget build(BuildContext context) {
    final ordered = result.probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = result.topCategory;
    final topLocalization = result.topLocalization;
    final topLocalizationScore = result.localizationScores.isEmpty ? 0.0 : result.localizationScores.first.value;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Assessment result'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Done'),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  GlassCard(
                    glow: true,
                    borderColor: _categoryColors[top]!.withValues(alpha: 0.6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MOST LIKELY',
                          style: TextStyle(color: AppColors.brand, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          top.label,
                          style: TextStyle(
                            color: _categoryColors[top],
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(result.probabilities[top]! * 100).round()}% estimated probability',
                          style: const TextStyle(color: AppColors.text2, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Differential', title: 'Probability breakdown'),
                  const SizedBox(height: AppSpacing.s4),
                  for (final entry in ordered) ...[
                    ProbabilityCard(
                      category: entry.key,
                      probability: entry.value,
                      color: _categoryColors[entry.key]!,
                      supporting: result.supportingFindings[entry.key] ?? const [],
                      against: result.againstFindings[entry.key] ?? const [],
                      highlight: entry.key == top,
                    ),
                    const SizedBox(height: AppSpacing.s3),
                  ],
                  const SizedBox(height: AppSpacing.s4),
                  const SectionHeader(kicker: 'Rationale', title: 'Why this result?'),
                  const SizedBox(height: AppSpacing.s4),
                  _WhyThisResult(result: result, ordered: ordered, categoryColors: _categoryColors),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Localization', title: 'Suggested onset region'),
                  const SizedBox(height: AppSpacing.s4),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (topLocalization != null) ...[
                          BrainDiagram(
                            selected: topLocalization,
                            interactive: false,
                            confidences: {topLocalization: topLocalizationScore},
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          Center(
                            child: Text(
                              '${topLocalization.label} — ${(topLocalizationScore * 100).round()}% confidence',
                              style: const TextStyle(color: AppColors.text, fontSize: 14.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          const Divider(),
                          const SizedBox(height: AppSpacing.s2),
                        ],
                        for (final entry in result.localizationScores.take(3))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: ProbabilityBar(
                              label: entry.key.label,
                              value: entry.value,
                              color: AppColors.brand3,
                              highlight: entry == result.localizationScores.first,
                            ),
                          ),
                        if (result.localizationRationale.isNotEmpty) ...[
                          const Divider(),
                          const SizedBox(height: 6),
                          Text(
                            'Based on: ${result.localizationRationale.join(', ')}.',
                            style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                          ),
                        ] else
                          const Text(
                            'No localizing aura or semiology recorded — localization is most meaningful once a focal epileptic mechanism is suspected.',
                            style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                          ),
                        if (topLocalization != null) ...[
                          const SizedBox(height: AppSpacing.s4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LocalizationScreen(initialRegion: topLocalization),
                                ),
                              ),
                              icon: const Icon(Icons.route_outlined, size: 16),
                              label: const Text('View lobe details'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Next steps', title: 'Suggested investigations'),
                  const SizedBox(height: AppSpacing.s4),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final s in result.suggestedInvestigations)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.science_outlined, size: 16, color: AppColors.brand3),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(s, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.4)),
                                ),
                              ],
                            ),
                          ),
                        if (result.suggestedInvestigations.isEmpty)
                          const Text(
                            'All listed investigations have already been recorded.',
                            style: TextStyle(color: AppColors.muted, fontSize: 12.5),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const DisclaimerBanner(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A compact, side-by-side "why" summary comparing the top two categories'
/// supporting findings at a glance, above the full expandable breakdown.
class _WhyThisResult extends StatelessWidget {
  const _WhyThisResult({required this.result, required this.ordered, required this.categoryColors});

  final AssessmentResult result;
  final List<MapEntry<EventCategory, double>> ordered;
  final Map<EventCategory, Color> categoryColors;

  @override
  Widget build(BuildContext context) {
    final leaders = ordered.take(2).toList();
    final cards = <Widget>[
      for (final entry in leaders)
        GlassCard(
          borderColor: categoryColors[entry.key]!.withValues(alpha: 0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supporting ${entry.key.label}',
                style: TextStyle(color: categoryColors[entry.key], fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              FindingList(items: result.supportingFindings[entry.key] ?? const [], supporting: true),
            ],
          ),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.s3),
                SizedBox(width: double.infinity, child: cards[i]),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.s3),
              Expanded(child: cards[i]),
            ],
          ],
        );
      },
    );
  }
}
