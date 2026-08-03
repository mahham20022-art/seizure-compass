import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/notable_figure.dart';
import '../../../data/repositories/notable_figures_data.dart';

/// Library > Notable Figures tab: people historically or publicly
/// associated with epilepsy/seizures, split into documented/self-disclosed
/// cases and historical figures whose diagnosis is a debated hypothesis.
class NotableFiguresTab extends StatelessWidget {
  const NotableFiguresTab({super.key});

  @override
  Widget build(BuildContext context) {
    final documented = notableFigures.where((f) => f.confidence == FigureConfidence.documented).toList();
    final historical = notableFigures.where((f) => f.confidence == FigureConfidence.historical).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        const Text(
          'DOCUMENTED / SELF-DISCLOSED',
          style: TextStyle(color: AppColors.brand, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.4),
        ),
        const SizedBox(height: 10),
        for (final figure in documented)
          Padding(padding: const EdgeInsets.only(bottom: 10), child: _FigureCard(figure: figure)),
        const SizedBox(height: AppSpacing.s6),
        const Text(
          'HISTORICAL FIGURES — DEBATED DIAGNOSES',
          style: TextStyle(color: AppColors.warn, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.4),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(AppSpacing.s3),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.warn.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(color: AppColors.warn.withValues(alpha: 0.3)),
          ),
          child: const Text(
            'These are retrospective hypotheses proposed by historians or clinicians long '
            'after the fact, not confirmed diagnoses — they remain genuinely debated.',
            style: TextStyle(color: AppColors.text2, fontSize: 12, height: 1.45),
          ),
        ),
        for (final figure in historical)
          Padding(padding: const EdgeInsets.only(bottom: 10), child: _FigureCard(figure: figure)),
      ],
    );
  }
}

class _FigureCard extends StatelessWidget {
  const _FigureCard({required this.figure});

  final NotableFigure figure;

  @override
  Widget build(BuildContext context) {
    final color = figure.confidence == FigureConfidence.documented ? AppColors.ok : AppColors.warn;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(figure.name, style: const TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Text(figure.years, style: const TextStyle(color: AppColors.faint, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(figure.description, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.5)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadii.sm)),
            child: Text(figure.confidence.label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
