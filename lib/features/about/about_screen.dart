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
import '../../domain/scoring/evidence_weights.dart';

const appVersion = '2.0.0';
const appLastReviewed = '5 November 2026';
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Bullet('Differential: a naive-Bayes model. Each category starts from a prior set by the '
                            'clinical setting (equal priors by default) and every finding adds a log-likelihood '
                            'weight; a softmax turns the totals into probabilities.'),
                        _Bullet('Weights are the editor\'s conservative reading of published sensitivity, specificity '
                            'and likelihood ratios (for example pooled LR+ ≈ 5 for ictal eye closure; lateral tongue '
                            'bite specificity ≈ 100% vs PNES; urinary incontinence LR+ ≈ 0.9). Each carries a grade: '
                            'A meta-analysis, systematic review or validated score; B cohort or video-EEG series; '
                            'C expert teaching.'),
                        _Bullet('Correlated findings are damped: within a group (automatisms, convulsive signs, '
                            'presyncope, PNES motor signs) only the strongest counts in full and the rest at half.'),
                        _Bullet('Calgary Syncope–Seizure Score is computed exactly as published (Sheldon 2002) and shown '
                            'separately: it is validated for seizure vs syncope, not PNES.'),
                        _Bullet('Cardiac and neurological red flags (ESC 2018 high-risk features and others) are never '
                            'averaged into the estimate; they are shown first.'),
                        _Bullet('Lateralization uses approximate positive predictive values of lateralizing signs '
                            '(Loddenkemper & Kotagal 2005), assuming left-hemisphere dominance.'),
                        _Bullet('Localization weights and some category weights (grade C) remain teaching-based.',
                            last: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Validation', title: 'Status and known limitations'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Bullet('Not yet validated on patients. The weights are taken from published studies but the combined model has not been tested against video-EEG-confirmed diagnoses.'),
                        _Bullet('Naive Bayes assumes findings are independent. They are not; damping reduces but does not remove overconfidence, so treat high percentages with caution.'),
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
                  const SectionHeader(kicker: 'Author', title: 'Who made it'),
                  const SizedBox(height: AppSpacing.s3),
                  const GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr Mohamed Najm',
                          style: TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'MBBS · FEBN · PGDip EM · MRCEM (Secondary)\nNeurologist in neurocritical care and neurological emergencies',
                          style: TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.45),
                        ),
                        SizedBox(height: AppSpacing.s3),
                        _LinkRow(label: 'Website', text: 'thetract.org', url: 'https://thetract.org/'),
                        _LinkRow(label: 'LinkedIn', text: 'linkedin.com/in/dr-mohamed-najm-aldeen', url: 'https://www.linkedin.com/in/dr-mohamed-najm-aldeen-aa6452135'),
                        _LinkRow(label: 'GitHub', text: 'github.com/mahham20022-art', url: 'https://github.com/mahham20022-art/seizure-compass'),
                        _LinkRow(label: 'Also', text: 'Najm ICUCalc', url: 'https://icucalc.thetract.org/', last: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'References', title: 'Further reading'),
                  const SizedBox(height: AppSpacing.s3),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Reference(
                          'Updated classification of epileptic seizures: position paper of the '
                          'International League Against Epilepsy. Epilepsia. 2025. '
                          'doi:10.1111/epi.18338',
                        ),
                        for (final r in references.values) _Reference(r),
                        const _Reference(
                          'Engel J Jr, Pedley TA, eds. Epilepsy: A Comprehensive Textbook. 2nd ed. '
                          'Lippincott Williams & Wilkins.',
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
                          version: '2.0.0',
                          date: '5 November 2026',
                          changes: [
                            'New engine: naive-Bayes log-likelihood model with setting priors and damping of correlated signs.',
                            'Weights re-derived from published data with an evidence grade and source for each.',
                            'Corrected: ictal crying now favours PNES; urinary incontinence and a normal EEG no longer move the estimate; '
                                'prolactin also rises after syncope; psychiatric history weighted down.',
                            'Added: eyes closed, waxing–waning course, ictal recall, stertorous breathing, presyncopal prodrome, '
                                'situational triggers, pallor, onset from sleep.',
                            'Calgary Syncope–Seizure Score, cardiac and neurological red flags.',
                            'Lateralizing signs with side, and a hemisphere estimate.',
                            'Video-EEG and ECG results; EEG split into epileptiform vs non-specific.',
                            'Weight-of-evidence chart, named patterns, worked examples, copyable summary.',
                            'The Tract palette and typography, faster load, shareable URLs for every screen.',
                          ],
                        ),
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

/// A labelled external link (opens in a new tab on the web).
class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, required this.text, required this.url, this.last = false});

  final String label;
  final String text;
  final String url;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: Text(label, style: const TextStyle(color: AppColors.faint, fontSize: 12)),
              ),
              Expanded(
                child: Text(text, style: const TextStyle(color: AppColors.brand3, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.faint),
            ],
          ),
        ),
      ),
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
