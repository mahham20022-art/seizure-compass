import 'enums.dart';

/// Output of [SeizureScoringEngine.score] — everything the result dashboard
/// needs to render.
class AssessmentResult {
  const AssessmentResult({
    required this.probabilities,
    required this.supportingFindings,
    required this.againstFindings,
    required this.localizationScores,
    required this.localizationRationale,
    required this.suggestedInvestigations,
  });

  /// Normalized 0..1 probability per category, summing to ~1.0.
  final Map<EventCategory, double> probabilities;

  /// Human-readable findings that pushed toward each category.
  final Map<EventCategory, List<String>> supportingFindings;

  /// Human-readable findings that argue against each category.
  final Map<EventCategory, List<String>> againstFindings;

  /// Normalized 0..1 localization likelihood, sorted descending.
  final List<MapEntry<LocalizationRegion, double>> localizationScores;

  final List<String> localizationRationale;

  /// Investigations not yet obtained that would sharpen the estimate.
  final List<String> suggestedInvestigations;

  EventCategory get topCategory =>
      probabilities.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  LocalizationRegion? get topLocalization =>
      localizationScores.isEmpty ? null : localizationScores.first.key;
}
