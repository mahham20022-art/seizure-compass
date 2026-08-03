import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/evidence_badge.dart';
import '../../core/widgets/nav_card.dart';
import '../../core/widgets/pulse_glow.dart';
import '../../core/widgets/pulsing_logo.dart';
import '../about/about_screen.dart';
import '../assessment/assessment_wizard_screen.dart';
import '../library/library_screen.dart';
import '../localization/localization_screen.dart';
import '../pearls/pearls_screen.dart';
import '../search/search_screen.dart';
import 'widgets/eeg_pulse_backdrop.dart';
import 'widgets/home_ambient_backdrop.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const _AppDrawer(),
        body: SafeArea(
          child: HomeAmbientBackdrop(
            child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
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
                        Row(
                          children: [
                            const SearchAction(),
                            IconButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AboutScreen()),
                              ),
                              icon: const Icon(Icons.info_outline_rounded, color: AppColors.text2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                      children: [
                        const _HeroSection(),
                        const SizedBox(height: AppSpacing.s8),
                        const _ModulesHeader(),
                        const SizedBox(height: AppSpacing.s4),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth >= 760 ? 4 : 2;
                            return GridView.count(
                              crossAxisCount: columns,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: AppSpacing.s3,
                              crossAxisSpacing: AppSpacing.s3,
                              childAspectRatio: columns == 4 ? 0.85 : 0.92,
                              children: [
                                NavCard(
                                  icon: Icons.fact_check_rounded,
                                  title: 'Seizure Assessment',
                                  subtitle: 'Differentiate epilepsy from its mimics.',
                                  stat: '5-step wizard',
                                  accent: AppColors.brand3,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const AssessmentWizardScreen()),
                                  ),
                                ),
                                NavCard(
                                  icon: Icons.route_rounded,
                                  title: 'Localization',
                                  subtitle: 'Predict the seizure onset zone.',
                                  stat: '6 regions',
                                  accent: AppColors.pnes,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const LocalizationScreen()),
                                  ),
                                ),
                                NavCard(
                                  icon: Icons.menu_book_rounded,
                                  title: 'Seizure Atlas',
                                  subtitle: 'Explore every seizure syndrome.',
                                  stat: '29 syndromes',
                                  accent: AppColors.warn,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const LibraryScreen()),
                                  ),
                                ),
                                NavCard(
                                  icon: Icons.lightbulb_outline_rounded,
                                  title: 'Clinical Pearls',
                                  subtitle: 'High-yield neurological insights.',
                                  stat: '26 pearls',
                                  accent: AppColors.ok,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const PearlsScreen()),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.s6),
                        const _HomeDisclaimerCard(),
                        const SizedBox(height: AppSpacing.s5),
                        const Center(child: _VersionFooter()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: Stack(
            alignment: Alignment.center,
            children: const [
              EegPulseBackdrop(width: 260, height: 72),
              PulsingLogo(size: 116),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s5),
        const Center(child: EvidenceBadge()),
        const SizedBox(height: AppSpacing.s4),
        const Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Seizure ',
                  style: TextStyle(color: AppColors.text, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: 0.3),
                ),
                TextSpan(
                  text: 'Compass',
                  style: TextStyle(color: AppColors.brand3, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: 0.3),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Clinical Decision Support for Seizure Assessment',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.text2, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Navigate  •  Differentiate  •  Localize',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 13, letterSpacing: 0.3),
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 460;
            final primary = PulseGlow(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AssessmentWizardScreen()),
                ),
                icon: const Icon(Icons.fact_check_rounded, size: 18),
                label: const Text('Start Assessment'),
              ),
            );
            final secondary = OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LibraryScreen()),
              ),
              icon: const Icon(Icons.menu_book_rounded, size: 18),
              label: const Text('Explore Library'),
            );
            if (wide) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 210, child: primary),
                  const SizedBox(width: 12),
                  SizedBox(width: 210, child: secondary),
                ],
              );
            }
            return Column(
              children: [
                SizedBox(width: double.infinity, child: primary),
                const SizedBox(height: 10),
                SizedBox(width: double.infinity, child: secondary),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ModulesHeader extends StatelessWidget {
  const _ModulesHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'MODULES',
      style: TextStyle(color: AppColors.brand, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2),
    );
  }
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
            _drawerTile(context, Icons.fact_check_rounded, 'Seizure Assessment', const AssessmentWizardScreen()),
            _drawerTile(context, Icons.route_rounded, 'Localization', const LocalizationScreen()),
            _drawerTile(context, Icons.menu_book_rounded, 'Seizure Atlas', const LibraryScreen()),
            _drawerTile(context, Icons.lightbulb_outline_rounded, 'Clinical Pearls', const PearlsScreen()),
            _drawerTile(context, Icons.search_rounded, 'Search', const SearchScreen()),
            _drawerTile(context, Icons.info_outline_rounded, 'About & references', const AboutScreen()),
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
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded, color: AppColors.faint, size: 12),
            SizedBox(width: 6),
            Text('Based on ILAE 2017 Classification', style: TextStyle(color: AppColors.faint, fontSize: 11)),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology_outlined, color: AppColors.faint, size: 14),
            SizedBox(width: 6),
            Text('Version $appVersion', style: TextStyle(color: AppColors.faint, fontSize: 11.5)),
          ],
        ),
        SizedBox(height: 4),
        Text(
          '© 2026 Seizure Compass — Dr. Mohamed Najm',
          style: TextStyle(color: AppColors.faint, fontSize: 10.5),
        ),
      ],
    );
  }
}
