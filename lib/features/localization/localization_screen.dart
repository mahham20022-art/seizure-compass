import 'package:flutter/material.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/section_header.dart';
import '../../data/repositories/localization_data.dart';
import 'widgets/region_card.dart';

class LocalizationScreen extends StatelessWidget {
  const LocalizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Localization explorer')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  const SectionHeader(
                    kicker: 'Module 2',
                    title: 'Seizure localization by lobe',
                    subtitle: 'Tap a region to review its typical aura, semiology, EEG and MRI findings.',
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  for (final region in localizationRegions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RegionCard(info: region),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
