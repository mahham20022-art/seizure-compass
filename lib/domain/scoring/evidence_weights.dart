import '../../data/models/enums.dart';

/// A single piece of evidence's pull toward/away from each [EventCategory],
/// plus the short clinical rationale shown on the result dashboard.
///
/// Weights are unitless log-odds-style nudges (roughly -4..+4) summed by
/// [SeizureScoringEngine] — not a validated diagnostic score. Directions are
/// drawn from widely taught seizure-semiology teaching points (e.g. Benbadis
/// & Tatum on lateral tongue bite; Avbersek & Sisodiya's systematic review of
/// clinical signs distinguishing epilepsy from PNES; Chung, Reuber and
/// Syed on eye state during events; consensus reviews of convulsive
/// syncope).
class EvidenceWeight {
  const EvidenceWeight(this.weights, this.rationale);
  final Map<EventCategory, double> weights;
  final String rationale;
}

const _e = EventCategory.epileptic;
const _p = EventCategory.pnes;
const _s = EventCategory.syncope;
const _o = EventCategory.otherMimic;

/// Step 2 + Step 3 + Step 4 checkbox findings, keyed by the `key` in
/// `finding_keys.dart`.
const Map<String, EvidenceWeight> findingWeights = {
  // ---- Aura ----
  'deja_vu': EvidenceWeight({_e: 1.5}, 'Déjà vu is a classic mesial temporal aura.'),
  'jamais_vu': EvidenceWeight({_e: 1.3}, 'Jamais vu suggests temporal lobe onset.'),
  'fear': EvidenceWeight(
    {_e: 1.4, _p: 0.6},
    'Ictal fear points to amygdala/mesial temporal involvement, though panic '
    'symptoms also occur in PNES and panic attacks.',
  ),
  'epigastric_rising': EvidenceWeight(
    {_e: 1.6},
    'Epigastric rising is a hallmark mesial temporal (often insular) aura.',
  ),
  'olfactory': EvidenceWeight({_e: 1.4}, 'Olfactory (uncinate) aura suggests mesial temporal onset.'),
  'gustatory': EvidenceWeight({_e: 1.2}, 'Gustatory aura suggests temporal/insular onset.'),
  'visual': EvidenceWeight(
    {_e: 1.1, _o: 0.9},
    'Visual aura suggests occipital onset, but elementary/complex visual '
    'phenomena also occur in migraine with aura.',
  ),
  'auditory': EvidenceWeight({_e: 1.1}, 'Auditory aura suggests lateral temporal onset.'),
  'somatosensory': EvidenceWeight({_e: 1.1}, 'Somatosensory aura suggests parietal onset.'),
  'vertigo': EvidenceWeight(
    {_e: 0.6, _o: 1.0},
    'Vestibular (epileptic vertigo) is rare; vertigo more often reflects '
    'vestibular migraine or BPPV.',
  ),
  'autonomic': EvidenceWeight(
    {_e: 1.1, _s: 0.6},
    'Autonomic aura fits epileptic onset but overlaps with the '
    'presyncopal prodrome of vasovagal syncope.',
  ),
  'speech_arrest': EvidenceWeight({_e: 1.2}, 'Speech arrest suggests dominant-hemisphere involvement.'),

  // ---- Semiology ----
  'behavioral_arrest': EvidenceWeight({_e: 1.5}, 'Behavioral arrest with unresponsiveness fits focal impaired-awareness seizure.'),
  'automatisms': EvidenceWeight({_e: 1.8}, 'Automatisms are classic for focal impaired-awareness (usually temporal) seizures.'),
  'lip_smacking': EvidenceWeight({_e: 1.8}, 'Oroalimentary automatisms (lip smacking) strongly suggest temporal lobe seizure.'),
  'hand_automatisms': EvidenceWeight({_e: 1.7}, 'Hand automatisms (fumbling/picking) are typical temporal lobe semiology.'),
  'head_deviation': EvidenceWeight({_e: 1.5}, 'Sustained versive head deviation is a lateralizing sign, often frontal.'),
  'eye_deviation': EvidenceWeight({_e: 1.2}, 'Tonic eye deviation supports an epileptic, often frontal, mechanism.'),
  'forced_eye_closure': EvidenceWeight(
    {_p: 3.8, _e: -1.8},
    'Forced/resisted eye closure during the event is one of the most reliable '
    'signs favoring PNES — eyes are open in the great majority of epileptic seizures.',
  ),
  'asynchronous_limb_movements': EvidenceWeight(
    {_p: 3.2, _e: -1.2},
    'Out-of-phase, asynchronous limb thrashing is characteristic of PNES; '
    'epileptic clonic activity is typically synchronous and rhythmic.',
  ),
  'pelvic_thrusting': EvidenceWeight({_p: 2.6}, 'Pelvic thrusting is classically described in PNES, though rarely reported in frontal lobe seizures.'),
  'side_to_side_head_shaking': EvidenceWeight({_p: 3.0}, "Side-to-side ('no-no') head shaking is a well-described PNES sign."),
  'tonic_phase': EvidenceWeight({_e: 1.8, _p: -0.4}, 'A true sustained tonic phase supports generalized or focal-to-bilateral epileptic seizure.'),
  'clonic_phase': EvidenceWeight({_e: 1.8, _p: -0.4}, 'Rhythmic clonic jerking supports an epileptic convulsive mechanism.'),
  'myoclonic_jerks': EvidenceWeight(
    {_e: 1.4, _s: 1.3},
    'Brief myoclonic jerks occur in generalized epilepsy but are also very '
    'common in convulsive (anoxic) syncope.',
  ),
  'atonic_drop': EvidenceWeight({_e: 2.0}, 'Sudden atonic drop is a specific generalized-epilepsy semiology.'),
  'gelastic_laughter': EvidenceWeight({_e: 2.2}, 'Gelastic (laughing) seizures classically suggest a hypothalamic hamartoma.'),
  'dacrystic_crying': EvidenceWeight({_e: 1.6}, 'Dacrystic (crying) seizures are a rarer variant of gelastic epilepsy.'),
  'catamenial_relation': EvidenceWeight({_e: 1.0, _p: 0.3}, 'A strict menstrual-cycle relationship suggests catamenial epilepsy, though stress-related PNES can also cluster perimenstrually.'),
  'nocturnal_seizure': EvidenceWeight({_e: 1.4}, 'Exclusively sleep-related events favor epilepsy (e.g. frontal lobe/hypermotor) over PNES, which rarely arises from confirmed sleep.'),
  'hypermotor_activity': EvidenceWeight(
    {_e: 1.8, _p: 1.0},
    'Vigorous hypermotor (thrashing, kicking, pedaling) activity is classic '
    'for frontal lobe seizures but is a recognized semiologic overlap with PNES.',
  ),
  'figure_of_four': EvidenceWeight({_e: 2.6}, 'The figure-of-4 sign is a validated lateralizing sign of frontal lobe (often supplementary motor area) seizure.'),
  'fencing_posture': EvidenceWeight({_e: 2.6}, 'The fencing (M2e) posture indicates supplementary motor area seizure, lateralizing contralateral to the extended arm.'),
  'bicycling_movements': EvidenceWeight({_e: 1.5, _p: 0.8}, 'Bicycling leg movements are typical of frontal lobe hypermotor seizure, with recognized overlap in PNES.'),
  'opisthotonus': EvidenceWeight({_p: 2.8}, "Arc-de-cercle opisthotonic posturing is a classically taught PNES sign."),
  'urinary_incontinence': EvidenceWeight({_e: 1.2, _s: 0.5}, 'Incontinence is common with convulsive epileptic seizures and occurs in a minority of syncope episodes; it does not reliably exclude PNES.'),
  'cyanosis': EvidenceWeight({_e: 1.6}, 'Ictal cyanosis reflects impaired respiration during a convulsive epileptic seizure.'),

  // ---- Postictal ----
  'confusion': EvidenceWeight({_e: 2.0, _p: -0.8, _s: -1.5}, 'Postictal confusion lasting minutes is typical of epileptic seizures and atypical for syncope, which resolves rapidly.'),
  'todd_paralysis': EvidenceWeight({_e: 3.6}, "Todd's (postictal) paralysis is highly specific for a focal epileptic seizure."),
  'sleepiness': EvidenceWeight({_e: 1.4}, 'Prolonged postictal sleepiness supports an epileptic seizure.'),
  'immediate_recovery': EvidenceWeight({_p: 1.8, _s: 1.8, _e: -1.5}, 'Immediate return to full alertness without postictal confusion favors PNES or syncope over epilepsy.'),
  'memory_loss': EvidenceWeight({_e: 1.0, _p: 0.4}, 'Amnesia for the event is typical of epilepsy but is also reported by many patients with PNES.'),
  'aphasia': EvidenceWeight({_e: 1.8}, 'Postictal (Todd-type) aphasia lateralizes to the dominant hemisphere.'),
};

/// Step 1 demographic/history factors (nullable booleans on
/// [AssessmentInput]) keyed by a synthetic identifier.
const Map<String, EvidenceWeight> demographicWeights = {
  'known_epilepsy': EvidenceWeight({_e: 3.2}, 'A pre-existing epilepsy diagnosis substantially raises prior probability of a further epileptic seizure.'),
  'psychiatric_disease': EvidenceWeight({_p: 2.6}, 'Comorbid psychiatric disease (depression, anxiety, PTSD, prior trauma) is strongly associated with PNES.'),
  'previous_similar_attacks': EvidenceWeight({_e: 0.8, _p: 0.8}, 'Stereotyped recurrence occurs in both epilepsy and PNES and is only weakly discriminating alone.'),
  'medication_nonadherence': EvidenceWeight({_e: 1.6}, 'Antiseizure medication non-adherence is a common precipitant of breakthrough epileptic seizures.'),
  'sleep_deprivation': EvidenceWeight({_e: 1.2}, 'Sleep deprivation lowers seizure threshold.'),
  'alcohol': EvidenceWeight({_e: 1.2}, 'Alcohol (intoxication or withdrawal) is a recognized seizure precipitant.'),
  'drug_use': EvidenceWeight({_e: 1.1, _o: 0.4}, 'Illicit drug use/withdrawal can precipitate epileptic seizures or toxic/metabolic mimics.'),
  'fever': EvidenceWeight({_e: 0.9, _o: 0.6}, 'Fever raises suspicion for a seizure with an acute infectious/inflammatory trigger, or a non-epileptic febrile mimic.'),
};

/// Tongue bite location — a single field rather than a checkbox set.
const Map<TongueBiteLocation, EvidenceWeight> tongueBiteWeights = {
  TongueBiteLocation.lateral: EvidenceWeight(
    {_e: 3.8, _p: -1.5},
    'Lateral tongue biting has high specificity for a generalized tonic-clonic epileptic seizure.',
  ),
  TongueBiteLocation.tip: EvidenceWeight(
    {_e: 0.3, _s: 0.3},
    'Tip-of-tongue biting is non-specific and occurs across seizure types and syncope.',
  ),
  TongueBiteLocation.none: EvidenceWeight({}, ''),
};

/// Duration category.
const Map<SeizureDuration, EvidenceWeight> durationWeights = {
  SeizureDuration.brief: EvidenceWeight(
    {_s: 2.0, _e: -0.6},
    'Very brief events (under 30 seconds) are typical of convulsive syncope.',
  ),
  SeizureDuration.typical: EvidenceWeight(
    {_e: 1.0},
    'A 30 second to 2 minute duration is typical for a generalized tonic-clonic epileptic seizure.',
  ),
  SeizureDuration.prolonged: EvidenceWeight(
    {_p: 2.2, _e: -0.5},
    'Events lasting over 2 minutes (especially many minutes) with preserved oxygenation are more typical of PNES than epileptic seizures, which are usually self-limited.',
  ),
};

/// Investigation findings. Each test maps an [InvestigationResult] to an
/// [EvidenceWeight]; omitted combinations (usually [InvestigationResult.notDone])
/// contribute nothing.
const Map<String, Map<InvestigationResult, EvidenceWeight>> investigationWeights = {
  'eeg': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 4.0}, 'Epileptiform EEG abnormality strongly supports an epileptic mechanism.'),
    InvestigationResult.normal: EvidenceWeight({_p: 1.0}, 'A normal EEG does not exclude epilepsy but adds modest weight toward PNES when semiology is otherwise atypical.'),
  },
  'mri': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 2.2}, 'A structural lesion on MRI supports a focal epileptogenic substrate.'),
  },
  'ct': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 1.6, _o: 0.6}, 'An acute structural abnormality on CT (hemorrhage, mass, infarct) can both cause acute symptomatic seizures and mimic events (e.g. TIA).'),
  },
  'glucose': {
    InvestigationResult.abnormal: EvidenceWeight({_o: 3.4, _e: -0.8}, 'Hypo/hyperglycemia is a common metabolic mimic and should prompt consideration outside the seizure/PNES/syncope framework.'),
  },
  'electrolytes': {
    InvestigationResult.abnormal: EvidenceWeight({_o: 1.8, _e: 0.8}, 'Electrolyte derangement (e.g. hyponatremia) can precipitate an acute symptomatic seizure or an independent metabolic mimic.'),
  },
  'ck': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 2.0}, 'Elevated CK reflects muscle injury from a convulsive epileptic seizure.'),
  },
  'prolactin': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 2.2, _p: -1.4}, 'A prolactin rise 10-20 minutes after a convulsive event supports an epileptic seizure over PNES.'),
    InvestigationResult.normal: EvidenceWeight({_p: 1.6, _e: -0.6}, 'A normal post-ictal prolactin after a witnessed convulsive event favors PNES over a generalized epileptic seizure.'),
  },
  'lactate': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 1.6}, 'A transient venous lactate rise supports a recent convulsive epileptic seizure.'),
  },
};

/// Localization pull for each finding key toward each [LocalizationRegion].
const Map<String, Map<LocalizationRegion, double>> localizationWeights = {
  'deja_vu': {LocalizationRegion.temporal: 2.0},
  'jamais_vu': {LocalizationRegion.temporal: 1.8},
  'fear': {LocalizationRegion.temporal: 1.6},
  'epigastric_rising': {LocalizationRegion.temporal: 1.8, LocalizationRegion.insular: 1.0},
  'olfactory': {LocalizationRegion.temporal: 1.8},
  'gustatory': {LocalizationRegion.temporal: 1.2, LocalizationRegion.insular: 1.6},
  'visual': {LocalizationRegion.occipital: 2.2},
  'auditory': {LocalizationRegion.temporal: 1.8},
  'somatosensory': {LocalizationRegion.parietal: 2.2},
  'vertigo': {LocalizationRegion.insular: 1.2, LocalizationRegion.temporal: 0.6},
  'autonomic': {LocalizationRegion.insular: 1.2, LocalizationRegion.temporal: 0.8},
  'speech_arrest': {LocalizationRegion.frontal: 1.2, LocalizationRegion.temporal: 1.0},
  'behavioral_arrest': {LocalizationRegion.temporal: 1.4},
  'automatisms': {LocalizationRegion.temporal: 1.8},
  'lip_smacking': {LocalizationRegion.temporal: 2.0},
  'hand_automatisms': {LocalizationRegion.temporal: 1.8},
  'head_deviation': {LocalizationRegion.frontal: 1.8},
  'eye_deviation': {LocalizationRegion.frontal: 1.2, LocalizationRegion.occipital: 0.8},
  'nocturnal_seizure': {LocalizationRegion.frontal: 1.4},
  'hypermotor_activity': {LocalizationRegion.frontal: 2.2},
  'figure_of_four': {LocalizationRegion.frontal: 2.4},
  'fencing_posture': {LocalizationRegion.frontal: 2.4},
  'bicycling_movements': {LocalizationRegion.frontal: 1.8},
  'gelastic_laughter': {LocalizationRegion.temporal: 0.6},
  'dacrystic_crying': {LocalizationRegion.temporal: 0.6},
  'tonic_phase': {LocalizationRegion.generalized: 1.4},
  'clonic_phase': {LocalizationRegion.generalized: 1.2},
  'myoclonic_jerks': {LocalizationRegion.generalized: 2.0},
  'atonic_drop': {LocalizationRegion.generalized: 2.2},
};
