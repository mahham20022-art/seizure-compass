import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/clinical_pearl.dart';
import '../../data/repositories/clinical_pearls_data.dart';

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
        appBar: AppBar(title: const Text('Clinical pearls')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  const SectionHeader(
                    kicker: 'Module 4',
                    title: 'Short, evidence-based teaching notes',
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  for (final category in byCategory.keys) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 6),
                      child: Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.brand,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    for (final pearl in byCategory[category]!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline_rounded, color: AppColors.warn, size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(pearl.text, style: const TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.5)),
                              ),
                            ],
                          ),
                        ),
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
