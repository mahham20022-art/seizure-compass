import 'enums.dart';
import 'finding_keys.dart';

/// Mutable working state for the assessment wizard. A single instance is
/// carried through the flow and read by [SeizureScoringEngine] at the end.
class AssessmentInput {
  // Step 1 — Patient
  ClinicalSetting setting = ClinicalSetting.unspecified;
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

  /// Cardiac and neurological red flags (keys from [cardiacFlagOptions]
  /// and [neuroFlagOptions]).
  final Set<String> redFlags = {};

  // Step 2 — Circumstances, prodrome and aura
  final Set<String> prodromeFindings = {};
  final Set<String> auraFindings = {};

  // Step 3 — Semiology
  final Set<String> semiologyFindings = {};
  TongueBiteLocation tongueBite = TongueBiteLocation.none;
  SeizureDuration? duration;

  /// Lateralizing sign key → side on which it was observed.
  final Map<String, Side> lateralSigns = {};

  // Step 4 — Postictal
  final Set<String> postictalFindings = {};

  // Step 5 — Investigations
  final Map<String, InvestigationResult> investigations = {
    for (final o in investigationOptions) o.key: InvestigationResult.notDone,
  };

  bool has(String key) =>
      prodromeFindings.contains(key) ||
      auraFindings.contains(key) ||
      semiologyFindings.contains(key) ||
      postictalFindings.contains(key);

  /// Every checked finding key across steps 2–4.
  Iterable<String> get allFindings sync* {
    yield* prodromeFindings;
    yield* auraFindings;
    yield* semiologyFindings;
    yield* postictalFindings;
  }

  void reset() {
    setting = ClinicalSetting.unspecified;
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
    redFlags.clear();
    prodromeFindings.clear();
    auraFindings.clear();
    semiologyFindings.clear();
    tongueBite = TongueBiteLocation.none;
    duration = null;
    lateralSigns.clear();
    postictalFindings.clear();
    investigations.updateAll((key, value) => InvestigationResult.notDone);
  }
}
