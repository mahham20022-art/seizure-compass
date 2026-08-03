import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/nav_card.dart';
import '../assessment/assessment_wizard_screen.dart';
import '../library/library_screen.dart';
import '../localization/localization_screen.dart';
import '../pearls/pearls_screen.dart';

const _appVersion = '1.0.0';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const _AppDrawer(),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: const Icon(Icons.menu_rounded, color: AppColors.brand3),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showAboutDialog(context),
                          icon: const Icon(Icons.info_outline_rounded, color: AppColors.text2),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      children: [
                        const Center(child: AppLogo(size: 104)),
                        const SizedBox(height: AppSpacing.s5),
                        const Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Seizure ',
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Compass',
                                  style: TextStyle(
                                    color: AppColors.brand3,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Navigate.  Differentiate.  Localize.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.muted, fontSize: 13.5, letterSpacing: 0.2),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: AppSpacing.s3,
                          crossAxisSpacing: AppSpacing.s3,
                          childAspectRatio: 0.92,
                          children: [
                            NavCard(
                              icon: Icons.fact_check_outlined,
                              title: 'Seizure Assessment',
                              subtitle: 'Evaluate features and estimate probabilities.',
                              accent: AppColors.brand3,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AssessmentWizardScreen()),
                              ),
                            ),
                            NavCard(
                              icon: Icons.route_outlined,
                              title: 'Localization',
                              subtitle: 'Identify probable seizure origin.',
                              accent: AppColors.pnes,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LocalizationScreen()),
                              ),
                            ),
                            NavCard(
                              icon: Icons.menu_book_outlined,
                              title: 'Seizure Atlas',
                              subtitle: 'Explore types, semiology and differential diagnosis.',
                              accent: AppColors.ok,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LibraryScreen()),
                              ),
                            ),
                            NavCard(
                              icon: Icons.lightbulb_outline_rounded,
                              title: 'Clinical Pearls',
                              subtitle: 'Evidence-based pearls and key points.',
                              accent: AppColors.warn,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const PearlsScreen()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s6),
                        const _HomeDisclaimerCard(),
                        const SizedBox(height: AppSpacing.s5),
                        const Center(
                          child: _VersionFooter(),
                        ),
                      ],
                    ),
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

void _showAboutDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.ink800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
      title: const Text.rich(
        TextSpan(children: [
          TextSpan(text: 'Seizure ', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800)),
          TextSpan(text: 'Compass', style: TextStyle(color: AppColors.brand3, fontWeight: FontWeight.w800)),
        ]),
      ),
      content: const Text(
        'Version $_appVersion\n\n'
        'Seizure Compass is a clinical decision-support aid based on '
        'published seizure semiology literature. It estimates probabilities '
        'only — it does NOT diagnose epilepsy or any other condition. '
        'Always correlate with the full clinical picture, EEG and imaging.',
        style: TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.ink900,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  AppLogo(size: 44),
                  SizedBox(width: AppSpacing.s3),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Seizure ', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 16)),
                      TextSpan(text: 'Compass', style: TextStyle(color: AppColors.brand3, fontWeight: FontWeight.w800, fontSize: 16)),
                    ]),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.line, height: 24),
            _drawerTile(context, Icons.fact_check_outlined, 'Seizure Assessment', const AssessmentWizardScreen()),
            _drawerTile(context, Icons.route_outlined, 'Localization', const LocalizationScreen()),
            _drawerTile(context, Icons.menu_book_outlined, 'Seizure Atlas', const LibraryScreen()),
            _drawerTile(context, Icons.lightbulb_outline_rounded, 'Clinical Pearls', const PearlsScreen()),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: _VersionFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String label, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.text2),
      title: Text(label, style: const TextStyle(color: AppColors.text, fontSize: 14.5)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}

class _HomeDisclaimerCard extends StatelessWidget {
  const _HomeDisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.ink800,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.line2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.brand3, size: 20),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Medical Disclaimer',
                  style: TextStyle(color: AppColors.brand3, fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Seizure Compass is a clinical decision support tool and '
                  'does not replace clinical judgment. Not for diagnostic use.',
                  style: TextStyle(color: AppColors.text2, fontSize: 12, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.psychology_outlined, color: AppColors.faint, size: 14),
        SizedBox(width: 6),
        Text('Version $_appVersion', style: TextStyle(color: AppColors.faint, fontSize: 11.5)),
      ],
    );
  }
}
