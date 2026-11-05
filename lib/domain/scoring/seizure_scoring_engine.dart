import 'dart:math' as math;

import '../../data/models/assessment_input.dart';
import '../../data/models/assessment_result.dart';
import '../../data/models/enums.dart';
import '../../data/models/finding_keys.dart';
import 'evidence_weights.dart';

/// Turns a completed [AssessmentInput] into an [AssessmentResult].
///
/// Differential: naive-Bayes in log space. Each category starts at the log
/// of its setting prior; every finding adds its log-likelihood weight
/// (`evidence_weights.dart`); a softmax turns the totals into probabilities.
/// Correlated findings sharing a group are damped (strongest in full, the
/// rest at half weight) so that, for example, three kinds of automatism do
/// not count as three independent pieces of evidence.
///
/// Alongside it the engine computes the validated Calgary Syncope–Seizure
/// Score, cardiac and neurological red flags, a hemisphere estimate from
/// lateralizing signs and named semiology patterns.
///
/// It remains decision support: the weights are the editor's reading of the
/// cited studies, not a model fitted to and validated on patient data.
class SeizureScoringEngine {
  const SeizureScoringEngine();

  static const double _dampFactor = 0.5;

  AssessmentResult score(AssessmentInput input) {
    final priors = settingPriors[input.setting]!;
    final logit = <EventCategory, double>{
      for (final c in EventCategory.values) c: math.log(priors[c]!),
    };

    // ---- gather evidence -------------------------------------------------
    final items = <(String, EvidenceWeight)>[];
    for (final key in input.allFindings) {
      final w = findingWeights[key];
      if (w != null) items.add((findingLabels[key] ?? key, w));
    }
    for (final sign in lateralizingSigns) {
      if (input.lateralSigns.containsKey(sign.key)) {
        items.add((
          sign.label,
          const EvidenceWeight({EventCategory.epileptic: 1.0},
              'A lateralizing motor sign is itself evidence of a focal epileptic seizure.',
              grade: EvidenceGrade.b, source: 'loddenkemper2005', group: 'lateralizing'),
        ));
      }
    }
    if (input.tongueBite != TongueBiteLocation.none) {
      items.add(('${input.tongueBite.label} tongue bite', tongueBiteWeights[input.tongueBite]!));
    }
    if (input.duration != null) {
      items.add(('Duration ${input.duration!.label}', durationWeights[input.duration]!));
    }
    void demo(String key, String label, bool? v) {
      if (v == true) items.add((label, demographicWeights[key]!));
    }

    demo('known_epilepsy', 'Known epilepsy', input.knownEpilepsy);
    demo('psychiatric_disease', 'Psychiatric comorbidity', input.psychiatricDisease);
    demo('previous_similar_attacks', 'Previous similar attacks', input.previousSimilarAttacks);
    demo('medication_nonadherence', 'Medication non-adherence', input.medicationNonAdherence);
    demo('sleep_deprivation', 'Sleep deprivation', input.sleepDeprivation);
    demo('alcohol', 'Alcohol', input.alcohol);
    demo('drug_use', 'Drug use', input.drugUse);
    demo('fever', 'Fever', input.fever);

    for (final option in investigationOptions) {
      final r = input.investigations[option.key] ?? InvestigationResult.notDone;
      final w = investigationWeights[option.key]?[r];
      if (w != null) items.add(('${option.label}: ${option.labelFor(r).toLowerCase()}', w));
    }

    // ---- damping within correlated groups -------------------------------
    double strength(EvidenceWeight w) => w.weights.values.fold<double>(0, (a, b) => math.max(a, b.abs()));
    final factor = <int, double>{};
    final byGroup = <String, List<int>>{};
    for (var i = 0; i < items.length; i++) {
      final g = items[i].$2.group;
      if (g == null) {
        factor[i] = 1;
      } else {
        byGroup.putIfAbsent(g, () => []).add(i);
      }
    }
    for (final idx in byGroup.values) {
      idx.sort((a, b) => strength(items[b].$2).compareTo(strength(items[a].$2)));
      for (var k = 0; k < idx.length; k++) {
        factor[idx[k]] = k == 0 ? 1 : _dampFactor;
      }
    }

    // ---- apply ------------------------------------------------------------
    final contributions = <Contribution>[];
    final supporting = {for (final c in EventCategory.values) c: <String>[]};
    final against = {for (final c in EventCategory.values) c: <String>[]};
    for (var i = 0; i < items.length; i++) {
      final (label, w) = items[i];
      final f = factor[i]!;
      final deltas = <EventCategory, double>{};
      w.weights.forEach((c, v) {
        deltas[c] = v * f;
        logit[c] = logit[c]! + v * f;
        if (v * f > 0.25) supporting[c]!.add(w.rationale);
        if (v * f < -0.25) against[c]!.add(w.rationale);
      });
      contributions.add(Contribution(
        label: label,
        rationale: w.rationale,
        deltas: deltas,
        grade: w.grade,
        source: w.source,
        damped: f < 1,
      ));
    }
    contributions.sort((a, b) => _maxAbs(b).compareTo(_maxAbs(a)));

    final probabilities = _softmax(logit);
    for (final c in EventCategory.values) {
      supporting[c] = supporting[c]!.toSet().take(6).toList();
      against[c] = against[c]!.toSet().take(6).toList();
    }

    final localization = _scoreLocalization(input);
    final redFlags = _redFlags(input);
    final calgary = calgaryScore(input);
    final lateralization = _lateralize(input);

    return AssessmentResult(
      probabilities: probabilities,
      priors: priors,
      setting: input.setting,
      supportingFindings: supporting,
      againstFindings: against,
      contributions: contributions,
      localizationScores: localization.$1,
      localizationRationale: localization.$2,
      suggestedInvestigations: _suggest(input, probabilities, redFlags),
      redFlags: redFlags,
      calgary: calgary,
      lateralization: lateralization,
      patternNotes: _patterns(input),
    );
  }

  static double _maxAbs(Contribution c) => c.deltas.values.fold<double>(0, (a, b) => math.max(a, b.abs()));

  static Map<EventCategory, double> _softmax(Map<EventCategory, double> logit) {
    final m = logit.values.reduce(math.max);
    final exp = {for (final e in logit.entries) e.key: math.exp(e.value - m)};
    final total = exp.values.fold<double>(0, (a, b) => a + b);
    return {for (final e in exp.entries) e.key: e.value / total};
  }

  // ---- Calgary Syncope–Seizure Score ---------------------------------------

  /// Sheldon et al., JACC 2002. A score ≥ 1 favours seizure over syncope
  /// (sensitivity 94%, specificity 94% in the derivation cohort). It was not
  /// derived to separate PNES.
  static CalgaryScore calgaryScore(AssessmentInput i) {
    final items = <MapEntry<String, int>>[];
    void add(bool cond, String label, int pts) {
      if (cond) items.add(MapEntry(label, pts));
    }

    add(i.tongueBite != TongueBiteLocation.none, 'Tongue cut after the spell', 2);
    add(i.has('deja_vu') || i.has('jamais_vu'), 'Déjà vu or jamais vu before', 1);
    add(i.has('emotional_trigger'), 'Emotional stress with the loss of consciousness', 1);
    add(i.has('head_deviation'), 'Head turning during the spell', 1);
    add(
      const ['behavioral_arrest', 'tonic_phase', 'clonic_phase', 'myoclonic_jerks', 'memory_loss', 'fencing_posture',
        'figure_of_four', 'automatisms', 'hypermotor_activity'].any(i.has),
      'Unresponsive, unusual posturing, jerking limbs or no memory',
      1,
    );
    add(i.has('confusion'), 'Confused after the spell', 1);
    add(i.has('presyncope_lightheaded'), 'Light-headed spells', -2);
    add(i.has('presyncope_sweating'), 'Sweating before the spell', -2);
    add(i.has('prolonged_standing'), 'Prolonged sitting or standing before the spell', -2);

    final score = items.fold<int>(0, (a, e) => a + e.value);
    return CalgaryScore(score: score, items: items, answered: items.isNotEmpty);
  }

  // ---- Red flags -----------------------------------------------------------

  static const _cardiacAction =
      'High-risk feature for cardiac syncope: 12-lead ECG, cardiac monitoring, consider echocardiography '
      'and admission before attributing the event to seizure or PNES.';

  static const _neuroActions = {
    'persistent_deficit': 'Urgent CT and CT angiography: do not call a persisting deficit Todd’s paresis before stroke and haemorrhage are excluded.',
    'thunderclap': 'Exclude subarachnoid haemorrhage, RCVS and venous thrombosis: urgent CT, then CTA/CTV or LP as indicated.',
    'fever_meningism': 'Treat as meningitis or encephalitis until proven otherwise: cultures, empirical antimicrobials and aciclovir without delay.',
    'head_injury': 'CT head: intracranial haemorrhage can both cause and follow a seizure.',
    'pregnancy': 'Think eclampsia (blood pressure, urine protein, magnesium sulfate) and cerebral venous thrombosis.',
    'not_back_to_baseline': 'Consider non-convulsive status epilepticus (urgent EEG), as well as stroke, toxins and metabolic encephalopathy.',
  };

  static List<RedFlag> _redFlags(AssessmentInput i) {
    final flags = <RedFlag>[];
    for (final o in cardiacFlagOptions) {
      if (i.redFlags.contains(o.key)) flags.add(RedFlag(o.label, _cardiacAction));
    }
    if (i.investigations['ecg'] == InvestigationResult.abnormal) {
      flags.add(const RedFlag('Abnormal ECG',
          'Look for long or short QT, Brugada pattern, pre-excitation, high-grade block or ischaemia; '
          'arrange cardiology review and monitoring.'));
    }
    for (final o in neuroFlagOptions) {
      if (i.redFlags.contains(o.key)) flags.add(RedFlag(o.label, _neuroActions[o.key]!, cardiac: false));
    }
    if (i.investigations['glucose'] == InvestigationResult.abnormal) {
      flags.add(const RedFlag('Abnormal glucose', 'Correct glucose and reassess before interpreting the event.', cardiac: false));
    }
    return flags;
  }

  // ---- Lateralization ------------------------------------------------------

  static LateralizationResult _lateralize(AssessmentInput i) {
    // Positive log-odds = left hemisphere.
    final left = <(String, double)>[];
    final right = <(String, double)>[];
    double llr(double ppv) => math.log(ppv / (1 - ppv));

    for (final sign in lateralizingSigns) {
      final seen = i.lateralSigns[sign.key];
      if (seen == null) continue;
      final hemi = sign.contralateral ? seen.opposite : seen;
      final text = '${sign.label} (${seen.label.toLowerCase()}) → ${hemi.label.toLowerCase()} hemisphere, ~${(sign.ppv * 100).round()}%';
      (hemi == Side.left ? left : right).add((text, llr(sign.ppv)));
    }
    if (i.has('aphasia')) left.add(('Postictal aphasia → dominant (usually left) hemisphere', llr(0.9)));
    if (i.has('ictal_speech_preserved')) {
      right.add(('Intelligible ictal speech → non-dominant (usually right) hemisphere', llr(0.83)));
    }
    if (i.has('ictal_vomiting')) right.add(('Ictal vomiting or spitting → non-dominant (usually right) temporal', llr(0.8)));

    double damped(List<(String, double)> xs) {
      final v = xs.map((e) => e.$2).toList()..sort((a, b) => b.compareTo(a));
      var t = 0.0;
      for (var k = 0; k < v.length; k++) {
        t += k == 0 ? v[k] : v[k] * _dampFactor;
      }
      return t;
    }

    if (left.isEmpty && right.isEmpty) {
      return const LateralizationResult(side: null, probability: 0.5, forLeft: [], forRight: [], conflict: false);
    }
    final l = damped(left) - damped(right);
    final pLeft = 1 / (1 + math.exp(-l));
    final side = l.abs() < 0.05 ? null : (l > 0 ? Side.left : Side.right);
    return LateralizationResult(
      side: side,
      probability: side == Side.right ? 1 - pLeft : pLeft,
      forLeft: left.map((e) => e.$1).toList(),
      forRight: right.map((e) => e.$1).toList(),
      conflict: left.isNotEmpty && right.isNotEmpty,
    );
  }

  // ---- Named patterns ------------------------------------------------------

  static List<String> _patterns(AssessmentInput i) {
    final notes = <String>[];
    if (i.has('gelastic_laughter')) {
      notes.add('Gelastic seizures: look first for a hypothalamic hamartoma (MRI with thin hypothalamic cuts); '
          'frontal and temporal origins also occur.');
    }
    if (i.has('dacrystic_crying')) {
      notes.add('Dacrystic seizures are rare (hypothalamic hamartoma or temporal onset). Ordinary tearful crying '
          'during an event favours PNES instead.');
    }
    if (i.has('fencing_posture') || i.has('figure_of_four')) {
      notes.add('Asymmetric tonic posturing points to the supplementary motor area or spread to it; the extended '
          'arm is usually contralateral to onset.');
    }
    if (i.has('laryngeal_constriction') && (i.has('hypermotor_activity') || i.has('somatosensory') || i.has('gustatory'))) {
      notes.add('Throat constriction or perioral tingling with hypermotor or sensory features: consider '
          'insulo-opercular epilepsy, which mimics frontal and temporal seizures.');
    }
    if (i.has('epigastric_rising') && (i.has('lip_smacking') || i.has('hand_automatisms') || i.has('automatisms'))) {
      notes.add('Epigastric aura followed by oroalimentary or manual automatisms is the classic mesial temporal sequence.');
    }
    final presyncope = i.has('presyncope_lightheaded') || i.has('presyncope_sweating') || i.has('prolonged_standing');
    if (i.has('myoclonic_jerks') && (presyncope || i.duration == SeizureDuration.brief)) {
      notes.add('Brief arrhythmic jerks after a presyncopal prodrome or lasting seconds is convulsive syncope: '
          'jerks occur in about 90% of video-recorded syncope.');
    }
    if (i.has('hypermotor_activity') && i.has('from_sleep')) {
      notes.add('Hypermotor events from sleep: sleep-related hypermotor epilepsy is the main alternative to a '
          'parasomnia or PNES; a home video of a typical event helps most.');
    }
    return notes;
  }

  // ---- Localization --------------------------------------------------------

  (List<MapEntry<LocalizationRegion, double>>, List<String>) _scoreLocalization(AssessmentInput input) {
    final raw = {for (final r in LocalizationRegion.values) r: 1.0};
    final rationale = <String>[];
    for (final key in input.allFindings) {
      final w = localizationWeights[key];
      if (w == null) continue;
      w.forEach((r, v) => raw[r] = raw[r]! + v);
      rationale.add(findingLabels[key] ?? key);
    }
    final total = raw.values.fold<double>(0, (a, b) => a + b);
    final entries = raw.entries.map((e) => MapEntry(e.key, e.value / total)).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return (entries, rationale.take(6).toList());
  }

  // ---- Next steps ----------------------------------------------------------

  static List<String> _suggest(AssessmentInput i, Map<EventCategory, double> p, List<RedFlag> flags) {
    final s = <String>[];
    bool notDone(String k) => i.investigations[k] == InvestigationResult.notDone;
    final sorted = p.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted[0].key;
    final second = sorted[1].key;
    final close = sorted[0].value - sorted[1].value < 0.15;
    bool inTop2(EventCategory c) => top == c || second == c;

    if (notDone('ecg')) {
      s.add('12-lead ECG — required after any transient loss of consciousness (QTc, Brugada, pre-excitation, conduction block).');
    }
    if (notDone('glucose')) s.add('Capillary blood glucose.');
    if (flags.any((f) => f.cardiac)) {
      s.add('Cardiac monitoring and cardiology review because of the red flags above.');
    }
    if (inTop2(EventCategory.epileptic)) {
      if (notDone('eeg')) s.add('Routine EEG, ideally within 24–48 h; sleep-deprived EEG if it is normal.');
      if (i.investigations['eeg'] == InvestigationResult.normal) {
        s.add('A normal routine EEG does not exclude epilepsy: repeat with sleep deprivation or prolonged recording.');
      }
      if (notDone('mri')) s.add('MRI brain with an epilepsy protocol.');
    }
    if (inTop2(EventCategory.pnes) || (close && inTop2(EventCategory.epileptic))) {
      if (notDone('video_eeg')) {
        s.add('Video-EEG capture of a typical event: the standard for a documented PNES diagnosis.');
      }
      s.add('Ask a witness for a smartphone video of the next typical event.');
    }
    if (inTop2(EventCategory.syncope)) {
      s.add('Lying and standing blood pressure; consider tilt testing or ambulatory ECG if events recur.');
    }
    if (notDone('prolactin') && inTop2(EventCategory.epileptic) && inTop2(EventCategory.pnes)) {
      s.add('Prolactin 10–20 min after any future event (helps seizure vs PNES, not seizure vs syncope).');
    }
    if (top == EventCategory.epileptic) {
      s.add('Neurology or first-seizure clinic review; advise on driving and safety.');
    } else if (top == EventCategory.pnes) {
      s.add('Explain the diagnosis positively and refer to a PNES pathway with psychological therapy once confirmed.');
    }
    return s.toSet().toList();
  }
}
