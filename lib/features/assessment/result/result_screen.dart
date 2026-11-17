import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/brain_diagram.dart';
import '../../../core/widgets/confidence_ring.dart';
import '../../../core/widgets/disclaimer_banner.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/probability_bar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/assessment_result.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/example_cases.dart';
import '../../../domain/scoring/evidence_weights.dart';
import '../../about/about_screen.dart';

Color categoryColor(EventCategory c) => switch (c) {
      EventCategory.epileptic => AppColors.epileptic,
      EventCategory.pnes => AppColors.pnes,
      EventCategory.syncope => AppColors.syncope,
      EventCategory.otherMimic => AppColors.otherMimic,
    };

/// Category colour for text: the purple fill is too dark to read as text.
Color categoryTextColor(EventCategory c) => c == EventCategory.epileptic ? AppColors.brandText : categoryColor(c);

String _pct(double v) => v < 0.01 ? '<1%' : '${(v * 100).round()}%';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result, this.example});

  final AssessmentResult result;

  /// Set when showing a worked example rather than the user's own input.
  final ExampleCase? example;

  @override
  Widget build(BuildContext context) {
    final ordered = result.probabilities.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top = result.topCategory;
    final topColor = categoryColor(top);

    // A still background here: nothing should move behind the result.
    return ColoredBox(
      color: AppColors.ink950,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(example == null ? 'Assessment result' : 'Worked example'),
          actions: [
            IconButton(
              tooltip: 'Copy summary',
              icon: const Icon(Icons.copy_rounded),
              onPressed: () => _copy(context),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.brandText),
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Done'),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  if (example != null) ...[
                    GlassCard(
                      borderColor: AppColors.brand.withValues(alpha: 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EXAMPLE · ${example!.title.toUpperCase()}',
                              style: const TextStyle(color: AppColors.brandText, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
                          const SizedBox(height: 6),
                          Text(example!.summary, style: const TextStyle(color: AppColors.text2, fontSize: 13.5, height: 1.45)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                  ],
                  if (result.redFlags.isNotEmpty) ...[
                    _RedFlagCard(flags: result.redFlags),
                    const SizedBox(height: AppSpacing.s5),
                  ],
                  GlassCard(
                    borderColor: topColor.withValues(alpha: 0.6),
                    child: Row(
                      children: [
                        ConfidenceRing(value: result.probabilities[top]!, color: topColor, label: 'MODEL'),
                        const SizedBox(width: AppSpacing.s5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('LEADING CONSIDERATION',
                                  style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.4)),
                              const SizedBox(height: 6),
                              Text(top == EventCategory.syncope && result.hasCardiacFlag ? 'Syncope — cardiac?' : top.label,
                                  style: TextStyle(
                                      color: categoryTextColor(top), fontSize: 26, fontWeight: FontWeight.w600, fontFamily: 'Newsreader')),
                              const SizedBox(height: 6),
                              Text(
                                result.hasCardiacFlag
                                    ? 'Cardiac red flags present: exclude arrhythmic syncope before accepting this.'
                                    : _strength(result.probabilities[top]!),
                                style: TextStyle(
                                    color: result.hasCardiacFlag ? AppColors.danger : AppColors.text2,
                                    fontSize: 13,
                                    height: 1.4,
                                    fontWeight: result.hasCardiacFlag ? FontWeight.w700 : FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Differential', title: 'Estimated probabilities'),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    'Naive-Bayes estimate from the features entered, starting from '
                    '${result.setting == ClinicalSetting.unspecified ? 'equal priors' : 'priors for "${result.setting.label}"'}. '
                    'Weights come from the cited studies but the model is not validated on patients: use it to structure '
                    'reasoning, not to decide.',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.45),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final entry in ordered)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: ProbabilityBar(
                              label: entry.key.label,
                              value: entry.value,
                              color: categoryColor(entry.key),
                              textColor: categoryTextColor(entry.key),
                              highlight: entry.key == top,
                            ),
                          ),
                        Text(
                          'Prior ${ordered.map((e) => '${e.key.label} ${_pct(result.priors[e.key]!)}').join(' · ')}',
                          style: const TextStyle(color: AppColors.muted, fontSize: 11.5, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  const SectionHeader(kicker: 'Rationale', title: 'Weight of evidence'),
                  const SizedBox(height: AppSpacing.s2),
                  const Text(
                    'Each bar shows how strongly a finding pushed the estimate and toward what. ×5 means the finding is '
                    'about five times as likely in that category. Letters grade the evidence: A meta-analysis or validated '
                    'score, B cohort data, C expert teaching.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.45),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _EvidenceChart(contributions: result.contributions),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Validated score', title: 'Calgary Syncope–Seizure Score'),
                  const SizedBox(height: AppSpacing.s4),
                  _CalgaryCard(score: result.calgary, cardiac: result.hasCardiacFlag),
                  if (result.lateralization.side != null || result.lateralization.conflict) ...[
                    const SizedBox(height: AppSpacing.s6),
                    const SectionHeader(kicker: 'Lateralization', title: 'Hemisphere of onset'),
                    const SizedBox(height: AppSpacing.s4),
                    _LateralCard(l: result.lateralization),
                  ],
                  if (result.patternNotes.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s6),
                    const SectionHeader(kicker: 'Patterns', title: 'Worth naming'),
                    const SizedBox(height: AppSpacing.s4),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final n in result.patternNotes)
                            _Bullet(n, icon: Icons.lightbulb_outline_rounded, color: AppColors.brand),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Localization', title: 'Suggested onset region'),
                  const SizedBox(height: AppSpacing.s4),
                  _LocalizationCard(result: result),
                  const SizedBox(height: AppSpacing.s6),
                  const SectionHeader(kicker: 'Next steps', title: 'What would help most'),
                  const SizedBox(height: AppSpacing.s4),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result.suggestedInvestigations.isEmpty)
                          const Text('Nothing further suggested from the data entered.',
                              style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
                        for (var k = 0; k < result.suggestedInvestigations.length; k++)
                          _Bullet(result.suggestedInvestigations[k],
                              icon: k == 0 ? Icons.arrow_forward_rounded : Icons.science_outlined,
                              color: k == 0 ? AppColors.brandText : AppColors.muted,
                              strong: k == 0),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _copy(context),
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: const Text('Copy summary for notes'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.about),
                        icon: const Icon(Icons.menu_book_outlined, size: 18),
                        label: const Text('Methods and references'),
                      ),
                    ],
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

  static String _strength(double p) {
    if (p >= 0.85) return 'Strongly favoured by the features entered.';
    if (p >= 0.65) return 'Favoured, but the alternatives below remain open.';
    if (p >= 0.45) return 'Leading, with a close differential.';
    return 'No category clearly leads: more information is needed.';
  }

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: summaryText(result)));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summary copied. Nothing was sent anywhere.')),
    );
  }
}

/// Plain-text summary for a clinical note or referral letter.
String summaryText(AssessmentResult r) {
  final b = StringBuffer();
  final ordered = r.probabilities.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  b.writeln('Seizure Compass v$appVersion — decision support, not a diagnosis');
  b.writeln();
  if (r.redFlags.isNotEmpty) {
    b.writeln('RED FLAGS');
    for (final f in r.redFlags) {
      b.writeln('- ${f.title}: ${f.action}');
    }
    b.writeln();
  }
  b.writeln('Differential (${r.setting.label}):');
  for (final e in ordered) {
    b.writeln('- ${e.key.label}: ${_pct(e.value)}');
  }
  final key = r.contributions.where((c) => !c.isNeutral).take(6).toList();
  if (key.isNotEmpty) {
    b.writeln();
    b.writeln('Key findings:');
    for (final c in key) {
      final cat = _pushes(c);
      b.writeln('- ${c.label} → ${cat.label} (${c.grade.letter})');
    }
  }
  if (r.calgary.answered) {
    b.writeln();
    b.writeln('Calgary Syncope–Seizure Score: ${r.calgary.score} (${r.calgary.favoursSeizure ? 'favours seizure' : 'favours syncope'})');
  }
  if (r.lateralization.side != null) {
    b.writeln('Lateralization: ${r.lateralization.side!.label.toLowerCase()} hemisphere favoured (~${_pct(r.lateralization.probability)})'
        '${r.lateralization.conflict ? ', with conflicting signs' : ''}');
  }
  if (r.topLocalization != null) {
    b.writeln('Localization: ${r.topLocalization!.label} (${_pct(r.localizationScores.first.value)} relative weight)');
  }
  if (r.suggestedInvestigations.isNotEmpty) {
    b.writeln();
    b.writeln('Suggested next steps:');
    for (final s in r.suggestedInvestigations) {
      b.writeln('- $s');
    }
  }
  b.writeln();
  b.writeln('compass.thetract.org');
  return b.toString();
}

EventCategory _pushes(Contribution c) {
  var best = EventCategory.epileptic;
  var bestV = -double.infinity;
  for (final cat in EventCategory.values) {
    final v = c.netToward(cat);
    if (v > bestV) {
      best = cat;
      bestV = v;
    }
  }
  return best;
}

class _RedFlagCard extends StatelessWidget {
  const _RedFlagCard({required this.flags});
  final List<RedFlag> flags;

  @override
  Widget build(BuildContext context) {
    // Cardiac flags share one set of next steps, shown once under the group.
    final cardiac = flags.where((f) => f.cardiac && f.title != 'Abnormal ECG').toList();
    final others = flags.where((f) => !cardiac.contains(f)).toList();
    return Semantics(
      container: true,
      label: 'Red flags, act on these first',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1418), // opaque: no backdrop shows through
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.danger, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_rounded, color: _RedFlagCard.red, size: 22),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Red flags: act on these first',
                      style: TextStyle(color: _RedFlagCard.red, fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            if (cardiac.isNotEmpty)
              _FlagItem(
                title: cardiac.length == 1 ? cardiac.first.title : 'Cardiac high-risk features',
                whys: [for (final f in cardiac) (cardiac.length == 1 ? null : f.title, f.why)],
                steps: cardiac.first.steps,
              ),
            for (final f in others) _FlagItem(title: f.title, whys: [(null, f.why)], steps: f.steps),
          ],
        ),
      ),
    );
  }

  /// Lighter red for text on the dark card (contrast ≈ 6.9:1).
  static const red = Color(0xFFFF8A8A);
}

class _FlagItem extends StatelessWidget {
  const _FlagItem({required this.title, required this.whys, required this.steps});
  final String title;
  /// (finding, why): the finding is named when several share one item.
  final List<(String?, String)> whys;
  final List<String> steps;

  static const _label = TextStyle(
      color: _RedFlagCard.red, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1);
  static const _body = TextStyle(color: AppColors.text, fontSize: 14, height: 1.45);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF5A2A30)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(Icons.flag_rounded, color: _RedFlagCard.red, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w800, height: 1.3)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('WHY IT MATTERS', style: _label),
          const SizedBox(height: 3),
          for (final (name, why) in whys)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text.rich(
                TextSpan(children: [
                  if (name != null) TextSpan(text: '$name. ', style: const TextStyle(fontWeight: FontWeight.w800)),
                  TextSpan(text: why),
                ]),
                style: _body,
              ),
            ),
          const SizedBox(height: 6),
          const Text('NEXT', style: _label),
          const SizedBox(height: 3),
          for (final step in steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.arrow_right_rounded, color: AppColors.text, size: 18),
                  ),
                  const SizedBox(width: 2),
                  Expanded(child: Text(step, style: _body)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EvidenceChart extends StatelessWidget {
  const _EvidenceChart({required this.contributions});
  final List<Contribution> contributions;

  @override
  Widget build(BuildContext context) {
    final active = contributions.where((c) => !c.isNeutral).toList()
      ..sort((a, b) => b.netToward(_pushes(b)).compareTo(a.netToward(_pushes(a))));
    if (active.length > 12) active.removeRange(12, active.length);
    final neutral = contributions.where((c) => c.isNeutral).toList();
    if (active.isEmpty && neutral.isEmpty) {
      return const GlassCard(
        child: Text('No findings entered yet — the estimate equals the prior.',
            style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
      );
    }
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final c in active) _EvidenceRow(c: c),
          if (neutral.isNotEmpty) ...[
            const Divider(height: 24),
            const Text('Entered but non-discriminating',
                style: TextStyle(color: AppColors.text2, fontSize: 12.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final c in neutral)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('${c.label} — ${c.rationale}',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4)),
              ),
          ],
        ],
      ),
    );
  }
}

class _EvidenceRow extends StatefulWidget {
  const _EvidenceRow({required this.c});
  final Contribution c;

  @override
  State<_EvidenceRow> createState() => _EvidenceRowState();
}

class _EvidenceRowState extends State<_EvidenceRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final cat = _pushes(c);
    final net = c.netToward(cat);
    final color = categoryColor(cat);
    final factor = math.exp(net);
    final fraction = (net / 2.5).clamp(0.06, 1.0);
    return InkWell(
      onTap: () => setState(() => _open = !_open),
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(c.label + (c.damped ? '  ·  half weight (correlated)' : ''),
                      style: const TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                _GradeChip(c.grade),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, cons) => Stack(
                      children: [
                        Container(height: 8, decoration: BoxDecoration(color: AppColors.ink700, borderRadius: BorderRadius.circular(4))),
                        Container(
                          height: 8,
                          width: cons.maxWidth * fraction,
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 118,
                  child: Text('${cat.label} ×${factor < 10 ? factor.toStringAsFixed(1) : factor.round()}',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            if (_open) ...[
              const SizedBox(height: 6),
              Text(c.rationale, style: const TextStyle(color: AppColors.text2, fontSize: 12.5, height: 1.45)),
              if (c.source != null && references[c.source] != null) ...[
                const SizedBox(height: 4),
                Text(references[c.source]!, style: const TextStyle(color: AppColors.muted, fontSize: 11.5, height: 1.4)),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _GradeChip extends StatelessWidget {
  const _GradeChip(this.grade);
  final EvidenceGrade grade;

  @override
  Widget build(BuildContext context) {
    final color = switch (grade) {
      EvidenceGrade.a => AppColors.ok,
      EvidenceGrade.b => AppColors.syncope,
      EvidenceGrade.c => AppColors.muted,
    };
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(grade.letter, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}

class _CalgaryCard extends StatelessWidget {
  const _CalgaryCard({required this.score, required this.cardiac});
  final CalgaryScore score;
  final bool cardiac;

  @override
  Widget build(BuildContext context) {
    final color = !score.answered ? AppColors.muted : (score.favoursSeizure ? AppColors.brandText : AppColors.syncope);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Text(score.answered ? '${score.score > 0 ? '+' : ''}${score.score}' : '—',
                    style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: Text(
                  !score.answered
                      ? 'No Calgary items entered.'
                      : score.favoursSeizure
                          ? 'Score ≥ 1: favours seizure over syncope.'
                          : 'Score < 1: favours syncope over seizure.',
                  style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          if (score.items.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final e in score.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 34,
                      child: Text('${e.value > 0 ? '+' : ''}${e.value}',
                          style: TextStyle(
                              color: e.value > 0 ? AppColors.epileptic : AppColors.syncope,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5)),
                    ),
                    Expanded(child: Text(e.key, style: const TextStyle(color: AppColors.text2, fontSize: 12.5))),
                  ],
                ),
              ),
          ],
          if (cardiac)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Red flags present: arrhythmic syncope often causes jerks and injury, so a seizure-range score '
                'does not exclude a cardiac cause.',
                style: TextStyle(color: AppColors.danger, fontSize: 12.5, height: 1.4, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: 10),
          const Text(
            'Sheldon et al., JACC 2002: 94% sensitivity and 94% specificity for seizure vs syncope in the derivation '
            'cohort. It answers seizure vs syncope only — it was not built to detect PNES.',
            style: TextStyle(color: AppColors.muted, fontSize: 11.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _LateralCard extends StatelessWidget {
  const _LateralCard({required this.l});
  final LateralizationResult l;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Hemi(label: 'L', active: l.side == Side.left),
              const SizedBox(width: 6),
              _Hemi(label: 'R', active: l.side == Side.right),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: Text(
                  l.side == null
                      ? 'Signs point both ways — no side favoured.'
                      : '${l.side!.label} hemisphere favoured (~${_pct(l.probability)})',
                  style: const TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final s in [...l.forLeft, ...l.forRight]) _Bullet(s, icon: Icons.chevron_right_rounded, color: AppColors.muted),
          if (l.conflict)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Conflicting signs: early signs lateralize better than late ones, and spread can mislead. '
                'Video review of the onset is worth more than any count.',
                style: TextStyle(color: AppColors.warn, fontSize: 12, height: 1.4),
              ),
            ),
          const SizedBox(height: 6),
          const Text(
            'Dominance assumed left (true in ~95% of right-handers, ~70% of left-handers). '
            'Approximate PPVs from Loddenkemper & Kotagal, Epilepsy Behav 2005.',
            style: TextStyle(color: AppColors.muted, fontSize: 11.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _Hemi extends StatelessWidget {
  const _Hemi({required this.label, required this.active});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.brand.withValues(alpha: 0.25) : AppColors.ink700,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(label == 'L' ? 22 : 6),
          right: Radius.circular(label == 'R' ? 22 : 6),
        ),
        border: Border.all(color: active ? AppColors.brand : AppColors.line),
      ),
      child: Text(label, style: TextStyle(color: active ? AppColors.brandText : AppColors.muted, fontWeight: FontWeight.w800)),
    );
  }
}

class _LocalizationCard extends StatelessWidget {
  const _LocalizationCard({required this.result});
  final AssessmentResult result;

  @override
  Widget build(BuildContext context) {
    final top = result.topLocalization;
    if (top == null) {
      return const GlassCard(
        child: Text(
          'No localizing aura or semiology entered. Localization is only meaningful once a focal epileptic mechanism is suspected.',
          style: TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.4),
        ),
      );
    }
    final topScore = result.localizationScores.first.value;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrainDiagram(selected: top, interactive: false, confidences: {top: topScore}),
          const SizedBox(height: AppSpacing.s4),
          for (final entry in result.localizationScores.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ProbabilityBar(
                label: entry.key.label,
                value: entry.value,
                color: AppColors.brand,
                highlight: entry == result.localizationScores.first,
              ),
            ),
          const Divider(),
          const SizedBox(height: 6),
          Text('Based on: ${result.localizationRationale.join(', ')}.',
              style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4)),
          const SizedBox(height: AppSpacing.s4),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.localizationFor(top)),
              icon: const Icon(Icons.route_rounded, size: 16),
              label: const Text('View lobe details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, {required this.icon, required this.color, this.strong = false});
  final String text;
  final IconData icon;
  final Color color;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: strong ? AppColors.text : AppColors.text2,
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: strong ? FontWeight.w600 : FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
