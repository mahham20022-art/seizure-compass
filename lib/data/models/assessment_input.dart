import 'enums.dart';

/// Mutable working state for the 5-step assessment wizard. A single instance
/// is carried through the flow and read by [SeizureScoringEngine] at the end.
class AssessmentInput {
  // Step 1 — Patient
  int? ageYears;
  Sex? sex;
  bool? knownEpilepsy;
  bool? psychiatricDisease;
  bool? previousSimilarAttacks;
  bool? medicationNonAdherence;
  bool? sleepDeprivation;
  bool? alcohol;
  bool? drugUse;
  bool? fever;

  // Step 2 — Aura (keys from [auraOptions])
  final Set<String> auraFindings = {};

  // Step 3 — Semiology (keys from [semiologyOptions])
  final Set<String> semiologyFindings = {};
  TongueBiteLocation tongueBite = TongueBiteLocation.none;
  SeizureDuration? duration;

  // Step 4 — Postictal (keys from [postictalOptions])
  final Set<String> postictalFindings = {};

  // Step 5 — Investigations (keys from [investigationOptions])
  final Map<String, InvestigationResult> investigations = {
    for (final k in ['eeg', 'mri', 'ct', 'glucose', 'electrolytes', 'ck', 'prolactin', 'lactate'])
      k: InvestigationResult.notDone,
  };

  bool has(String key) =>
      auraFindings.contains(key) ||
      semiologyFindings.contains(key) ||
      postictalFindings.contains(key);

  void reset() {
    ageYears = null;
    sex = null;
    knownEpilepsy = null;
    psychiatricDisease = null;
    previousSimilarAttacks = null;
    medicationNonAdherence = null;
    sleepDeprivation = null;
    alcohol = null;
    drugUse = null;
    fever = null;
    auraFindings.clear();
    semiologyFindings.clear();
    tongueBite = TongueBiteLocation.none;
    duration = null;
    postictalFindings.clear();
    investigations.updateAll((key, value) => InvestigationResult.notDone);
  }
}
