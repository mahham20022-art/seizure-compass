import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/disclaimer_banner.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';

const appVersion = '1.1.1';
const appLastReviewed = '9 October 2026';
const appContactEmail = 'contact@thetract.org';
const appErrorReportSubject = 'Seizure Compass error report v$appVersion';
const _errorReportBody = 'Screen (assessment, localization, atlas, pearls):\n'
    'Features you selected:\n'
    'Result shown:\n'
    'What you expected, and the source:\n'
    'Device and browser:\n\n'
    '(Please leave out patient identifiers.)';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('About & evidence')),
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
                    child: Text('Version $appVersion · last reviewed $appLastReviewed', style: TextStyle(color: AppColors.faint, fontSize: 12)),
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
                  const SectionHeader(kicker: 'Scope', title: 'Who it is for, and its limits'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Text(
                      'For: clinicians and trainees reasoning through a witnessed paroxysmal event. '
                      'Not for patients or families to self-assess.\n\n'
                      'It does: weigh the features you enter, show which findings pushed the result '
                      'each way, and suggest a lobe of onset when a focal mechanism is likely.\n\n'
                      'It does not: read EEG or imaging, replace video-EEG, decide treatment, or give a '
                      'validated probability.\n\n'
                      'Your data: nothing you enter is stored or sent anywhere; it stays in this page '
                      'and is gone when you close it.',
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
                  const SectionHeader(kicker: 'Validation', title: 'Status and known limitations'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Bullet('Not prospectively or independently validated. The weights have not been tested against video-EEG-confirmed diagnoses.'),
                        _Bullet('Decision support only. It does not replace clinical judgement, a specialist opinion or video-EEG.'),
                        _Bullet('The output depends entirely on the quality of the witness account and the features you select.'),
                        _Bullet('Epileptic seizures and PNES can coexist; the tool cannot detect dual diagnosis.'),
                        _Bullet('Localization uses aura and semiology only. Rapid spread and non-localizing semiology can point to the wrong lobe.'),
                        _Bullet('Not a regulated medical device.', last: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Feedback', title: 'Report a suspected error'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'If a weight, a localization or a reference looks wrong, email what you selected, '
                          'what the app showed and what you expected, with a source if you have one. '
                          'Leave out patient identifiers.',
                          style: TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.55),
                        ),
                        SizedBox(height: AppSpacing.s4),
                        ReportErrorButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'References', title: 'Further reading'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Reference(
                          'Updated classification of epileptic seizures: position paper of the '
                          'International League Against Epilepsy. Epilepsia. 2025. '
                          'doi:10.1111/epi.18338',
                        ),
                        _Reference(
                          'Fisher RS, Cross JH, French JA, et al. Operational classification '
                          'of seizure types by the International League Against Epilepsy. '
                          'Epilepsia. 2017;58(4):522-530.',
                        ),
                        _Reference(
                          'Fisher RS, Cross JH, D\'Souza C, et al. Instruction manual for the '
                          'ILAE 2017 operational classification of seizure types. Epilepsia. '
                          '2017;58(4):531-542.',
                        ),
                        _Reference(
                          'Blume WT, Lüders HO, Mizrahi E, et al. Glossary of descriptive '
                          'terminology for ictal semiology: report of the ILAE task force on '
                          'classification and terminology. Epilepsia. 2001;42(9):1212-1218.',
                        ),
                        _Reference(
                          'LaFrance WC Jr, Baker GA, Duncan R, Goldstein LH, Reuber M. Minimum '
                          'requirements for the diagnosis of psychogenic nonepileptic seizures: '
                          'a staged approach. Epilepsia. 2013;54(11):2005-2018.',
                        ),
                        _Reference(
                          'Engel J Jr, Pedley TA, eds. Epilepsy: A Comprehensive Textbook. '
                          '2nd ed. Lippincott Williams & Wilkins.',
                        ),
                        _Reference(
                          'Panayiotopoulos CP. A Clinical Guide to Epileptic Syndromes and '
                          'their Treatment. Springer.',
                          last: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Changelog', title: 'What changed'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ChangelogEntry(
                          version: '1.1.1',
                          date: '9 October 2026',
                          changes: [
                            'Evidence and limits panel on the home screen.',
                            'Validation status, error reporting and this changelog added to About.',
                            'Basis and references shown under the result.',
                            '"Evidence-based" and "confidence" wording replaced with plainer terms.',
                          ],
                        ),
                        _ChangelogEntry(
                          version: '1.1.0',
                          date: '9 October 2026',
                          changes: [
                            'Results labelled as heuristic weights, not probabilities.',
                            '"Who it is for, and its limits" card.',
                            'ILAE 2025 updated classification added to references.',
                          ],
                        ),
                        _ChangelogEntry(
                          version: '1.0.0',
                          date: 'August 2026',
                          changes: [
                            'First release: assessment wizard, localization explorer, seizure atlas, clinical pearls.',
                            'N/A option on yes/no questions.',
                          ],
                          last: true,
                        ),
                      ],
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

/// Opens a prefilled error-report email; falls back to copying the address.
class ReportErrorButton extends StatelessWidget {
  const ReportErrorButton({super.key});

  Future<void> _open(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: appContactEmail,
      query: 'subject=${Uri.encodeComponent(appErrorReportSubject)}'
          '&body=${Uri.encodeComponent(_errorReportBody)}',
    );
    var opened = false;
    try {
      opened = await launchUrl(uri);
    } catch (_) {
      opened = false;
    }
    if (opened || !context.mounted) return;
    await Clipboard.setData(const ClipboardData(text: appContactEmail));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No mail app found. $appContactEmail copied; use the subject "$appErrorReportSubject".')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: () => _open(context),
          icon: const Icon(Icons.mail_outline_rounded, size: 18),
          label: const Text('Report an error'),
        ),
        const SizedBox(height: 8),
        const SelectableText(
          '$appContactEmail · subject "$appErrorReportSubject"',
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
        ),
      ],
    );
  }
}

/// A single bulleted line inside a card.
class _Bullet extends StatelessWidget {
  const _Bullet(this.text, {this.last = false});

  final String text;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 5, color: AppColors.muted),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

/// One version block in the changelog.
class _ChangelogEntry extends StatelessWidget {
  const _ChangelogEntry({
    required this.version,
    required this.date,
    required this.changes,
    this.last = false,
  });

  final String version;
  final String date;
  final List<String> changes;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: version,
                style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: '  ·  $date',
                style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
              ),
            ]),
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < changes.length; i++)
            _Bullet(changes[i], last: i == changes.length - 1),
        ],
      ),
    );
  }
}

/// One bibliographic entry in the "Further reading" list.
class _Reference extends StatelessWidget {
  const _Reference(this.citation, {this.last = false});

  final String citation;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.faint),
          const SizedBox(width: 10),
          Expanded(
            child: Text(citation, style: const TextStyle(color: AppColors.text2, fontSize: 12.5, height: 1.45)),
          ),
        ],
      ),
    );
  }
}
