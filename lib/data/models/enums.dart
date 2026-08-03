/// Differential categories Seizure Compass estimates a probability for.
/// Order is used consistently for display (most to least "seizure-like").
enum EventCategory { epileptic, pnes, syncope, otherMimic }

extension EventCategoryX on EventCategory {
  String get label {
    switch (this) {
      case EventCategory.epileptic:
        return 'Epileptic seizure';
      case EventCategory.pnes:
        return 'PNES';
      case EventCategory.syncope:
        return 'Syncope';
      case EventCategory.otherMimic:
        return 'Other mimic';
    }
  }

  String get description {
    switch (this) {
      case EventCategory.epileptic:
        return 'A clinical event caused by abnormal, excessive synchronous '
            'cortical neuronal activity.';
      case EventCategory.pnes:
        return 'Psychogenic Non-Epileptic Seizure — episodes resembling '
            'seizures without an epileptic electrographic correlate.';
      case EventCategory.syncope:
        return 'Transient loss of consciousness from cerebral '
            'hypoperfusion, occasionally with brief convulsive jerking.';
      case EventCategory.otherMimic:
        return 'Other paroxysmal mimics: TIA, migraine with aura, cardiac '
            'arrhythmia, sleep phenomena, metabolic derangement, '
            'movement disorder.';
    }
  }
}

enum Sex { male, female }

enum TongueBiteLocation { none, lateral, tip }

extension TongueBiteLocationX on TongueBiteLocation {
  String get label {
    switch (this) {
      case TongueBiteLocation.none:
        return 'None';
      case TongueBiteLocation.lateral:
        return 'Lateral';
      case TongueBiteLocation.tip:
        return 'Tip';
    }
  }
}

enum SeizureDuration { brief, typical, prolonged }

extension SeizureDurationX on SeizureDuration {
  String get label {
    switch (this) {
      case SeizureDuration.brief:
        return '< 30 seconds';
      case SeizureDuration.typical:
        return '30 seconds – 2 minutes';
      case SeizureDuration.prolonged:
        return '> 2 minutes';
    }
  }
}

/// Tri-state result for an investigation: not yet obtained, normal, or
/// abnormal/positive.
enum InvestigationResult { notDone, normal, abnormal }

enum LocalizationRegion { temporal, frontal, parietal, occipital, insular, generalized }

extension LocalizationRegionX on LocalizationRegion {
  String get label {
    switch (this) {
      case LocalizationRegion.temporal:
        return 'Temporal lobe';
      case LocalizationRegion.frontal:
        return 'Frontal lobe';
      case LocalizationRegion.parietal:
        return 'Parietal lobe';
      case LocalizationRegion.occipital:
        return 'Occipital lobe';
      case LocalizationRegion.insular:
        return 'Insular / opercular';
      case LocalizationRegion.generalized:
        return 'Generalized onset';
    }
  }
}
