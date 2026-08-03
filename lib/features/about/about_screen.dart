import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/disclaimer_banner.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';

const appVersion = '1.0.0';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('About & references')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  const Center(child: AppLogo(size: 72)),
                  const SizedBox(height: AppSpacing.s4),
                  const Center(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'Seizure ', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 20)),
                        TextSpan(text: 'Compass', style: TextStyle(color: AppColors.brand3, fontWeight: FontWeight.w800, fontSize: 20)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text('Version $appVersion', style: TextStyle(color: AppColors.faint, fontSize: 12)),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'About', title: 'What Seizure Compass is'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Text(
                      'Seizure Compass is a clinical decision-support aid that estimates '
                      'the relative probability of an epileptic seizure, PNES, syncope or '
                      'another paroxysmal mimic from witnessed clinical features, and '
                      'suggests a probable lobe of onset when a focal epileptic mechanism '
                      'is likely. It is a teaching and clinical-reasoning aid, not a '
                      'diagnostic device.',
                      style: TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.55),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Evidence basis', title: 'How the estimates are derived'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Text(
                      'Probability weights and localization heuristics are built from '
                      'widely taught seizure-semiology teaching points — features such as '
                      "lateral tongue bite, forced eye closure, Todd's paralysis, "
                      'post-ictal prolactin behavior, and lobe-specific aura/semiology '
                      'patterns commonly referenced in neurology and emergency-medicine '
                      'teaching (e.g. ILAE seizure classification and semiology glossary, '
                      'and standard epilepsy/EEG textbooks). This is a transparent '
                      'heuristic scoring model, not a validated, published clinical '
                      'prediction rule — every weight and its rationale is visible in the '
                      'source and on the result screen.',
                      style: TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.55),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Disclaimer', title: 'Medical disclaimer'),
                  const SizedBox(height: AppSpacing.s3),
                  const DisclaimerBanner(),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Credits', title: 'Prepared by'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr. Mohamed Najm', style: TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text(
                          'MBBS · FEBN · PGDip EM · MRCEM (Secondary)',
                          style: TextStyle(color: AppColors.text2, fontSize: 13, height: 1.5),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'MSc Neurology, Buckingham (in progress)',
                          style: TextStyle(color: AppColors.text2, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
