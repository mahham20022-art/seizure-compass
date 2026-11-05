import 'enums.dart';

/// One finding's effect on the differential, for the "weight of evidence"
/// chart and the copyable summary.
class Contribution {
  const Contribution({
    required this.label,
    required this.rationale,
    required this.deltas,
    required this.grade,
    this.source,
    this.damped = false,
  });

  final String label;
  final String rationale;

  /// Log-likelihood shift actually applied per category (after damping).
  final Map<EventCategory, double> deltas;
  final EvidenceGrade grade;
  final String? source;

  /// True when this finding was counted at half weight because a stronger
  /// correlated finding was already present.
  final bool damped;

  /// Net pull toward [c] relative to the mean of the other categories.
  double netToward(EventCategory c) {
    final own = deltas[c] ?? 0;
    final others = EventCategory.values.where((x) => x != c).map((x) => deltas[x] ?? 0);
    return own - others.fold<double>(0, (a, b) => a + b) / 3;
  }

  bool get isNeutral => deltas.values.every((v) => v.abs() < 0.05);
}

/// Calgary Syncope–Seizure Score (Sheldon et al., JACC 2002).
class CalgaryScore {
  const CalgaryScore({required this.score, required this.items, required this.answered});

  final int score;

  /// Items that scored, as label → points.
  final List<MapEntry<String, int>> items;

  /// False when nothing relevant was entered, so the score means little.
  final bool answered;

  bool get favoursSeizure => score >= 1;
}

class RedFlag {
  const RedFlag(this.title, this.action, {this.cardiac = true});
  final String title;
  final String action;
  final bool cardiac;
}

class LateralizationResult {
  const LateralizationResult({
    required this.side,
    required this.probability,
    required this.forLeft,
    required this.forRight,
    required this.conflict,
  });

  /// Favoured hemisphere of onset, or null when nothing lateralizing was entered.
  final Side? side;
  final double probability;
  final List<String> forLeft;
  final List<String> forRight;
  final bool conflict;
}

/// Output of [SeizureScoringEngine.score] — everything the result dashboard
/// needs to render.
class AssessmentResult {
  const AssessmentResult({
    required this.probabilities,
    required this.priors,
    required this.supportingFindings,
    required this.againstFindings,
    required this.contributions,
    required this.localizationScores,
    required this.localizationRationale,
    required this.suggestedInvestigations,
    required this.redFlags,
    required this.calgary,
    required this.lateralization,
    required this.patternNotes,
    required this.setting,
  });

  /// Posterior probability per category, summing to 1.0.
  final Map<EventCategory, double> probabilities;
  final Map<EventCategory, double> priors;
  final ClinicalSetting setting;

  final Map<EventCategory, List<String>> supportingFindings;
  final Map<EventCategory, List<String>> againstFindings;
  final List<Contribution> contributions;

  /// Normalized 0..1 localization likelihood, sorted descending.
  final List<MapEntry<LocalizationRegion, double>> localizationScores;
  final List<String> localizationRationale;

  final List<String> suggestedInvestigations;
  final List<RedFlag> redFlags;
  final CalgaryScore calgary;
  final LateralizationResult lateralization;

  /// Specific semiology patterns worth naming (e.g. gelastic → hypothalamic
  /// hamartoma).
  final List<String> patternNotes;

  EventCategory get topCategory =>
      probabilities.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  bool get hasCardiacFlag => redFlags.any((f) => f.cardiac);

  /// True when no localizing feature was entered.
  bool get localizationUninformative => localizationRationale.isEmpty;

  LocalizationRegion? get topLocalization =>
      localizationScores.isEmpty || localizationUninformative ? null : localizationScores.first.key;
}
