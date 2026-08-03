import '../../data/models/assessment_input.dart';
import '../../data/models/assessment_result.dart';
import '../../data/models/enums.dart';
import '../../data/models/finding_keys.dart';
import 'evidence_weights.dart';

/// Turns a completed [AssessmentInput] into an [AssessmentResult] using a
/// transparent weighted-evidence model (see `evidence_weights.dart`).
///
/// This is a heuristic teaching aid, not a validated clinical prediction
/// rule: weights are additive "nudges" derived from widely cited semiology
/// teaching points, floored above zero and normalized to sum to 100%. The
/// same design is reused for lobar localization.
class SeizureScoringEngine {
  const SeizureScoringEngine();

  static const double _baseline = 2.0;
  static const double _floor = 0.05;

  AssessmentResult score(AssessmentInput input) {
    final raw = <EventCategory, double>{
      for (final c in EventCategory.values) c: _baseline,
    };
    final supporting = <EventCategory, List<String>>{
      for (final c in EventCategory.values) c: [],
    };
    final against = <EventCategory, List<String>>{
      for (final c in EventCategory.values) c: [],
    };

    void apply(EvidenceWeight? weight) {
      if (weight == null || weight.weights.isEmpty) return;
      weight.weights.forEach((category, value) {
        raw[category] = raw[category]! + value;
        if (value > 0.25) {
          supporting[category]!.add(weight.rationale);
        } else if (value < -0.25) {
          against[category]!.add(weight.rationale);
        }
      });
    }

    for (final key in input.auraFindings) {
      apply(findingWeights[key]);
    }
    for (final key in input.semiologyFindings) {
      apply(findingWeights[key]);
    }
    for (final key in input.postictalFindings) {
      apply(findingWeights[key]);
    }

    apply(tongueBiteWeights[input.tongueBite]);
    if (input.duration != null) {
      apply(durationWeights[input.duration]);
    }

    void applyDemographic(String key, bool? value) {
      if (value == true) apply(demographicWeights[key]);
    }

    applyDemographic('known_epilepsy', input.knownEpilepsy);
    applyDemographic('psychiatric_disease', input.psychiatricDisease);
    applyDemographic('previous_similar_attacks', input.previousSimilarAttacks);
    applyDemographic('medication_nonadherence', input.medicationNonAdherence);
    applyDemographic('sleep_deprivation', input.sleepDeprivation);
    applyDemographic('alcohol', input.alcohol);
    applyDemographic('drug_use', input.drugUse);
    applyDemographic('fever', input.fever);

    input.investigations.forEach((testKey, result) {
      final weight = investigationWeights[testKey]?[result];
      apply(weight);
    });

    // Floor and normalize.
    for (final c in EventCategory.values) {
      if (raw[c]! < _floor) raw[c] = _floor;
    }
    final total = raw.values.fold<double>(0, (a, b) => a + b);
    final probabilities = {
      for (final c in EventCategory.values) c: raw[c]! / total,
    };

    // De-duplicate and cap the finding lists for a clean UI.
    for (final c in EventCategory.values) {
      supporting[c] = supporting[c]!.toSet().take(6).toList();
      against[c] = against[c]!.toSet().take(6).toList();
    }

    final localization = _scoreLocalization(input);
    final suggestions = _suggestInvestigations(input, probabilities);

    return AssessmentResult(
      probabilities: probabilities,
      supportingFindings: supporting,
      againstFindings: against,
      localizationScores: localization.$1,
      localizationRationale: localization.$2,
      suggestedInvestigations: suggestions,
    );
  }

  (List<MapEntry<LocalizationRegion, double>>, List<String>) _scoreLocalization(
    AssessmentInput input,
  ) {
    final raw = <LocalizationRegion, double>{
      for (final r in LocalizationRegion.values) r: 1.0,
    };
    final rationale = <String>[];

    void applyRegion(String key) {
      final regionWeights = localizationWeights[key];
      if (regionWeights == null) return;
      regionWeights.forEach((region, value) {
        raw[region] = raw[region]! + value;
      });
      final label = [...auraOptions, ...semiologyOptions]
          .where((o) => o.key == key)
          .map((o) => o.label)
          .firstOrNull;
      if (label != null) rationale.add(label);
    }

    for (final key in input.auraFindings) {
      applyRegion(key);
    }
    for (final key in input.semiologyFindings) {
      applyRegion(key);
    }

    for (final r in LocalizationRegion.values) {
      if (raw[r]! < _floor) raw[r] = _floor;
    }
    final total = raw.values.fold<double>(0, (a, b) => a + b);
    final entries = raw.entries
        .map((e) => MapEntry(e.key, e.value / total))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return (entries, rationale.take(6).toList());
  }

  List<String> _suggestInvestigations(
    AssessmentInput input,
    Map<EventCategory, double> probabilities,
  ) {
    final suggestions = <String>[];
    final sorted = probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted[0];
    final second = sorted[1];
    final closeCall = (top.value - second.value) < 0.15;

    for (final option in investigationOptions) {
      if (input.investigations[option.key] == InvestigationResult.notDone) {
        suggestions.add(option.label);
      }
    }

    if (closeCall &&
        input.investigations['eeg'] == InvestigationResult.notDone) {
      suggestions.insert(
        0,
        'Consider inpatient video-EEG monitoring to capture a typical event, '
        'given the close differential above',
      );
    } else if (input.investigations['eeg'] == InvestigationResult.normal &&
        (top.key == EventCategory.epileptic || second.key == EventCategory.epileptic)) {
      suggestions.add(
        'A normal routine EEG does not exclude epilepsy — consider a repeat '
        'or sleep-deprived EEG',
      );
    }

    final pnesLikely = probabilities[EventCategory.pnes]! >= 0.3;
    if (pnesLikely) {
      suggestions.add('Psychiatric assessment, given the PNES probability above');
    }

    if (closeCall) {
      suggestions.add(
        'Consider admission for diagnostic monitoring while the '
        'differential remains close',
      );
    }

    if (top.key == EventCategory.epileptic || second.key == EventCategory.epileptic) {
      suggestions.add('Referral to a neurologist/epilepsy specialist for confirmation and long-term management');
    } else if (pnesLikely) {
      suggestions.add('Referral to psychiatry or a neuropsychiatry/PNES clinic');
    }

    return suggestions;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
