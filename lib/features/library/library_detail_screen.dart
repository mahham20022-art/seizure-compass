import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/models/seizure_library_entry.dart';

class LibraryDetailScreen extends StatelessWidget {
  const LibraryDetailScreen({super.key, required this.entry});

  final SeizureLibraryEntry entry;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(entry.name)),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.brand.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: Text(entry.category, style: const TextStyle(color: AppColors.brand, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(entry.summary, style: const TextStyle(color: AppColors.text, fontSize: 15, height: 1.5)),
                  const SizedBox(height: AppSpacing.s5),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Key features', style: TextStyle(color: AppColors.brand, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 10),
                        for (final f in entry.keyFeatures)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.circle, size: 6, color: AppColors.brand3),
                                const SizedBox(width: 10),
                                Expanded(child: Text(f, style: const TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.4))),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('EEG', style: TextStyle(color: AppColors.brand, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Text(entry.eeg, style: const TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.4)),
                      ],
                    ),
                  ),
                  if (entry.pearl != null) ...[
                    const SizedBox(height: AppSpacing.s4),
                    GlassCard(
                      borderColor: AppColors.warn.withValues(alpha: 0.4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded, color: AppColors.warn, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(entry.pearl!, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.5)),
                          ),
                        ],
                      ),
                    ),
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
