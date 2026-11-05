import '../../data/models/enums.dart';

/// One finding's pull toward or away from each [EventCategory].
///
/// Units are natural-log relative likelihoods: +0.7 ≈ the finding is about
/// twice as common in that category, +1.6 ≈ five times, +2.3 ≈ ten times.
/// [SeizureScoringEngine] adds them to the log prior and applies a softmax,
/// i.e. a naive-Bayes model. Values are the editor's conservative reading
/// of the sensitivity/specificity reported in [source]; they are not fitted
/// to patient data.
///
/// Findings that tend to occur together share a [group]; within a group only
/// the strongest counts in full and the rest count half, so correlated signs
/// are not double-counted.
class EvidenceWeight {
  const EvidenceWeight(
    this.weights,
    this.rationale, {
    this.grade = EvidenceGrade.c,
    this.source,
    this.group,
  });
  final Map<EventCategory, double> weights;
  final String rationale;
  final EvidenceGrade grade;

  /// Key into [references].
  final String? source;
  final String? group;
}

const _e = EventCategory.epileptic;
const _p = EventCategory.pnes;
const _s = EventCategory.syncope;
const _o = EventCategory.otherMimic;
const _a = EvidenceGrade.a;
const _b = EvidenceGrade.b;

/// Short citation keys used by weights, the Calgary score and lateralizing
/// signs; the About screen lists them in full.
const Map<String, String> references = {
  'avbersek2010':
      'Avbersek A, Sisodiya S. Does the primary literature provide support for clinical signs used to distinguish '
          'psychogenic nonepileptic seizures from epileptic seizures? J Neurol Neurosurg Psychiatry 2010;81:719–25.',
  'chung2006':
      'Chung SS, Gerber P, Kirlin KA. Ictal eye closure is a reliable indicator for psychogenic nonepileptic seizures. '
          'Neurology 2006;66:1730–1.',
  'bergen1993': 'Bergen D, Ristanovic R. Weeping as a common element of pseudoseizures. Arch Neurol 1993;50:1059–60.',
  'benbadis1995':
      'Benbadis SR, Wolgamuth BR, Goren H, et al. Value of tongue biting in the diagnosis of seizures. '
          'Arch Intern Med 1995;155:2346–9.',
  'brigo2012':
      'Brigo F, Storti M, Lochner P, et al. Tongue biting in epileptic seizures and psychogenic events: an '
          'evidence-based perspective. Epilepsy Behav 2012;25:251–5.',
  'brigo2013eyes':
      'Brigo F, Ausserer H, Nardone R, et al. Clinical utility of ictal eyes closure in the differential diagnosis '
          'between epileptic seizures and psychogenic events. Epilepsy Res 2013;104:1–10.',
  'brigo2013':
      'Brigo F, Nardone R, Ausserer H, et al. The diagnostic value of urinary incontinence in the differential '
          'diagnosis of seizures. Seizure 2013;22:85–90.',
  'sen2007':
      'Sen A, Scott C, Sisodiya SM. Stertorous breathing is a reliably identified sign that helps in the '
          'differentiation of epileptic from psychogenic non-epileptic convulsions: an audit. '
          'J Neurol Neurosurg Psychiatry 2007;78:1310–1.',
  'chen2005':
      'Chen DK, So YT, Fisher RS. Use of serum prolactin in diagnosing epileptic seizures. Report of the '
          'Therapeutics and Technology Assessment Subcommittee of the AAN. Neurology 2005;65:668–75.',
  'sheldon2002':
      'Sheldon R, Rose S, Ritchie D, et al. Historical criteria that distinguish syncope from seizures. '
          'J Am Coll Cardiol 2002;40:142–8.',
  'lempert1994':
      'Lempert T, Bauer M, Schmidt D. Syncope: a videometric analysis of 56 episodes of transient cerebral hypoxia. '
          'Ann Neurol 1994;36:233–7.',
  'brignole2018':
      'Brignole M, Moya A, de Lange FJ, et al. 2018 ESC Guidelines for the diagnosis and management of syncope. '
          'Eur Heart J 2018;39:1883–948.',
  'lafrance2013':
      'LaFrance WC Jr, Baker GA, Duncan R, et al. Minimum requirements for the diagnosis of psychogenic nonepileptic '
          'seizures: a staged approach. Epilepsia 2013;54:2005–18.',
  'loddenkemper2005':
      'Loddenkemper T, Kotagal P. Lateralizing signs during seizures in focal epilepsy. Epilepsy Behav 2005;7:1–17.',
  'smith2005':
      'Smith SJM. EEG in the diagnosis, classification, and management of patients with epilepsy. '
          'J Neurol Neurosurg Psychiatry 2005;76(Suppl 2):ii2–7.',
  'blume2001':
      'Blume WT, Lüders HO, Mizrahi E, et al. Glossary of descriptive terminology for ictal semiology. '
          'Epilepsia 2001;42:1212–8.',
  'fisher2017':
      'Fisher RS, Cross JH, French JA, et al. Operational classification of seizure types by the ILAE. '
          'Epilepsia 2017;58:522–30.',
};

/// Checkbox findings from steps 2–4, keyed by `finding_keys.dart`.
const Map<String, EvidenceWeight> findingWeights = {
  // ---- Circumstances and prodrome ----
  'prolonged_standing': EvidenceWeight({_s: 1.4, _e: -0.3},
      'Prolonged standing or sitting, heat or crowds are classic orthostatic/vasovagal triggers (Calgary item −2).',
      grade: _a, source: 'sheldon2002', group: 'presyncope'),
  'presyncope_lightheaded': EvidenceWeight({_s: 1.6, _e: -0.4},
      'A light-headed, about-to-faint prodrome favours syncope (Calgary item −2).',
      grade: _a, source: 'sheldon2002', group: 'presyncope'),
  'presyncope_sweating': EvidenceWeight({_s: 1.6, _e: -0.4},
      'Sweating, pallor or nausea beforehand is an autonomic presyncopal prodrome (Calgary item −2).',
      grade: _a, source: 'sheldon2002', group: 'presyncope'),
  'situational_trigger': EvidenceWeight({_s: 1.6},
      'Micturition, cough, pain or blood/needle exposure are situational reflex-syncope triggers.',
      grade: _b, source: 'brignole2018', group: 'presyncope'),
  'emotional_trigger': EvidenceWeight({_p: 0.6, _e: 0.3},
      'Emotional stress at onset counts toward seizure over syncope in the Calgary score, and is common before PNES.',
      grade: _b, source: 'sheldon2002'),
  'from_sleep': EvidenceWeight({_e: 1.0, _p: -0.7, _s: -0.4},
      'Events arising from witnessed sleep favour epilepsy; PNES arise from apparent sleep with an awake EEG.',
      grade: _a, source: 'avbersek2010'),

  // ---- Aura ----
  'deja_vu': EvidenceWeight({_e: 0.9}, 'Déjà vu is a classic mesial temporal aura (Calgary item +1).',
      source: 'sheldon2002', group: 'temporal_aura'),
  'jamais_vu': EvidenceWeight({_e: 0.8}, 'Jamais vu suggests temporal lobe onset (Calgary item +1).',
      source: 'sheldon2002', group: 'temporal_aura'),
  'fear': EvidenceWeight({_e: 0.5, _p: 0.5},
      'Ictal fear points to amygdala involvement, but panic symptoms are equally common in PNES and panic attacks.',
      group: 'temporal_aura'),
  'epigastric_rising': EvidenceWeight({_e: 1.0}, 'Epigastric rising is a hallmark mesial temporal aura.',
      source: 'blume2001', group: 'temporal_aura'),
  'olfactory': EvidenceWeight({_e: 0.9}, 'Olfactory (uncinate) aura suggests mesial temporal onset.',
      group: 'temporal_aura'),
  'gustatory': EvidenceWeight({_e: 0.8}, 'Gustatory aura suggests insular or temporal onset.'),
  'laryngeal_constriction': EvidenceWeight({_e: 0.8},
      'Throat constriction or perioral paraesthesia suggests an insulo-opercular onset.'),
  'visual': EvidenceWeight({_e: 0.5, _o: 0.8},
      'Visual aura suggests occipital onset, but elementary visual phenomena are more often migraine aura.'),
  'auditory': EvidenceWeight({_e: 0.7}, 'Auditory aura suggests lateral temporal onset.'),
  'somatosensory': EvidenceWeight({_e: 0.6, _o: 0.3},
      'Somatosensory aura suggests parietal onset; slow spreading tingling is more typical of migraine or TIA.'),
  'vertigo': EvidenceWeight({_e: 0.2, _o: 0.8},
      'Epileptic vertigo is rare; vertigo more often reflects a vestibular or migraine cause.'),
  'autonomic': EvidenceWeight({_e: 0.4, _s: 0.5},
      'Autonomic aura overlaps with the presyncopal prodrome of reflex syncope.'),
  'speech_arrest': EvidenceWeight({_e: 0.7}, 'Speech arrest suggests dominant-hemisphere involvement.'),

  // ---- Semiology ----
  'behavioral_arrest': EvidenceWeight({_e: 0.7}, 'Behavioural arrest with unresponsiveness fits a focal impaired-awareness seizure.'),
  'automatisms': EvidenceWeight({_e: 1.0, _s: 0.2},
      'Automatisms are classic for focal impaired-awareness seizures; brief oral automatisms also occur in syncope.',
      source: 'lempert1994', group: 'automatisms'),
  'lip_smacking': EvidenceWeight({_e: 1.2}, 'Oroalimentary automatisms strongly suggest temporal lobe seizure.',
      group: 'automatisms'),
  'hand_automatisms': EvidenceWeight({_e: 1.0}, 'Hand automatisms (fumbling, picking) are typical temporal lobe semiology.',
      group: 'automatisms'),
  'head_deviation': EvidenceWeight({_e: 0.6, _s: 0.2},
      'Head turning counts toward seizure in the Calgary score; brief head turns also occur in syncope.',
      grade: _a, source: 'sheldon2002'),
  'eye_deviation': EvidenceWeight({_e: 0.6, _s: 0.4},
      'Lateral eye deviation supports an epileptic mechanism; upward deviation is common in syncope.',
      source: 'lempert1994'),
  'forced_eye_closure': EvidenceWeight({_p: 1.7, _e: -0.4},
      'Eyes closed during the event favours PNES (pooled LR+ about 5; lower in blinded studies). '
          'Eyes are open in most epileptic seizures.',
      grade: _a, source: 'brigo2013eyes'),
  'fluctuating_course': EvidenceWeight({_p: 1.8, _e: -0.5},
      'A waxing–waning, stop–start course favours PNES; epileptic seizures evolve and end.',
      grade: _a, source: 'avbersek2010'),
  'asynchronous_limb_movements': EvidenceWeight({_p: 1.6, _e: -0.5},
      'Out-of-phase limb movements favour PNES, but also occur in frontal hypermotor seizures.',
      grade: _a, source: 'avbersek2010', group: 'pnes_motor'),
  'side_to_side_head_shaking': EvidenceWeight({_p: 1.6, _e: -0.3},
      'Side-to-side head or body movement favours PNES (frontal seizures are the main exception).',
      grade: _a, source: 'avbersek2010', group: 'pnes_motor'),
  'pelvic_thrusting': EvidenceWeight({_p: 1.0},
      'Pelvic thrusting favours PNES, but is well described in frontal lobe seizures; weigh it against sleep onset and stereotypy.',
      grade: _a, source: 'avbersek2010', group: 'pnes_motor'),
  'opisthotonus': EvidenceWeight({_p: 0.6},
      'Arc-de-cercle is a traditional PNES sign with little supporting data; treat it as weak.',
      group: 'pnes_motor'),
  'ictal_weeping': EvidenceWeight({_p: 2.0, _e: -0.4},
      'Crying or weeping during or just after the event strongly favours PNES.',
      grade: _a, source: 'bergen1993'),
  'tonic_phase': EvidenceWeight({_e: 0.9, _s: 0.2},
      'A sustained tonic phase supports a convulsive epileptic seizure; brief tonic stiffening also occurs in syncope.',
      group: 'convulsive'),
  'clonic_phase': EvidenceWeight({_e: 1.0, _p: -0.2},
      'Rhythmic clonic jerking that slows before stopping supports an epileptic convulsion.',
      group: 'convulsive'),
  'myoclonic_jerks': EvidenceWeight({_s: 1.0, _e: 0.5},
      'Brief arrhythmic myoclonic jerks occur in about 90% of video-recorded syncope; they are not evidence of epilepsy.',
      grade: _b, source: 'lempert1994'),
  'atonic_drop': EvidenceWeight({_e: 0.7, _s: 0.5}, 'An atonic drop occurs in generalized epilepsies, but limp collapse is also syncope.'),
  'pallor': EvidenceWeight({_s: 1.0, _e: -0.2}, 'Marked pallor during the event points to cerebral hypoperfusion.',
      group: 'presyncope'),
  'cyanosis': EvidenceWeight({_e: 1.0, _p: -0.4}, 'Ictal cyanosis reflects apnoea during a convulsive epileptic seizure.',
      group: 'convulsive'),
  'urinary_incontinence': EvidenceWeight({},
      'Urinary incontinence does not discriminate between epileptic seizures, syncope and PNES (pooled LR+ 0.9).',
      grade: _a, source: 'brigo2013'),
  'hypermotor_activity': EvidenceWeight({_e: 0.8, _p: 0.5},
      'Hypermotor activity is classic for frontal or insular seizures, with a recognized overlap with PNES.'),
  'bicycling_movements': EvidenceWeight({_e: 0.6, _p: 0.4},
      'Bicycling leg movements are typical of frontal hypermotor seizures, with overlap in PNES.'),
  'figure_of_four': EvidenceWeight({_e: 1.4},
      'Figure-of-4 posturing is a lateralizing sign of focal-to-bilateral seizures.',
      grade: _b, source: 'loddenkemper2005', group: 'posturing'),
  'fencing_posture': EvidenceWeight({_e: 1.4},
      'Asymmetric tonic (fencing) posture indicates supplementary motor area involvement.',
      source: 'blume2001', group: 'posturing'),
  'gelastic_laughter': EvidenceWeight({_e: 1.4},
      'Mirthless stereotyped laughter is gelastic epilepsy, classically a hypothalamic hamartoma.'),
  'dacrystic_crying': EvidenceWeight({_e: 0.6},
      'A stereotyped crying grimace without sadness is rare dacrystic epilepsy; ordinary weeping favours PNES.'),
  'ictal_speech_preserved': EvidenceWeight({_e: 0.5, _p: 0.3},
      'Intelligible speech during an impaired-awareness seizure lateralizes to the non-dominant hemisphere.',
      grade: _b, source: 'loddenkemper2005'),
  'ictal_vomiting': EvidenceWeight({_e: 0.6, _o: 0.3},
      'Ictal vomiting or spitting is a non-dominant temporal sign.', grade: _b, source: 'loddenkemper2005'),
  'catamenial_relation': EvidenceWeight({_e: 0.3}, 'A menstrual relationship suggests catamenial epilepsy, but is weak alone.'),

  // ---- Postictal ----
  'confusion': EvidenceWeight({_e: 1.3, _p: -0.8, _s: -1.0},
      'Postictal confusion lasting minutes favours an epileptic seizure; its absence favours PNES (Calgary item +1).',
      grade: _a, source: 'avbersek2010'),
  'stertorous_breathing': EvidenceWeight({_e: 1.8, _p: -1.4},
      'Postictal stertorous breathing separates generalized tonic-clonic seizures from convulsive PNES.',
      grade: _a, source: 'sen2007'),
  'todd_paralysis': EvidenceWeight({_e: 2.0}, "Todd's paresis is highly specific for a focal epileptic seizure.",
      grade: _b, source: 'loddenkemper2005'),
  'aphasia': EvidenceWeight({_e: 1.2}, 'Postictal aphasia lateralizes to the dominant hemisphere.',
      grade: _b, source: 'loddenkemper2005'),
  'sleepiness': EvidenceWeight({_e: 0.5}, 'Prolonged postictal sleepiness supports an epileptic seizure.'),
  'immediate_recovery': EvidenceWeight({_p: 0.8, _s: 1.0, _e: -1.2},
      'Immediate return to full alertness favours syncope or PNES over a convulsive seizure.',
      grade: _a, source: 'avbersek2010'),
  'ictal_recall': EvidenceWeight({_p: 1.6, _e: -0.6},
      'Recalling the event, being aware but unable to respond, favours PNES after a bilateral convulsive event.',
      grade: _a, source: 'avbersek2010'),
  'memory_loss': EvidenceWeight({_e: 0.3},
      'Amnesia for the event is typical of epilepsy, but many patients with PNES or syncope also report it.'),
};

/// Step 1 history items (nullable booleans on [AssessmentInput]).
const Map<String, EvidenceWeight> demographicWeights = {
  'known_epilepsy': EvidenceWeight({_e: 1.2, _p: 0.3},
      'An established epilepsy diagnosis raises the chance of another epileptic seizure, but 10–30% of people '
          'with PNES also carry an epilepsy label.',
      grade: _b, source: 'lafrance2013'),
  'psychiatric_disease': EvidenceWeight({_p: 0.8},
      'Psychiatric comorbidity is common in PNES but also in epilepsy; do not let it anchor the diagnosis.',
      grade: _b, source: 'lafrance2013'),
  'previous_similar_attacks': EvidenceWeight({}, 'Stereotyped recurrence occurs in epilepsy, PNES and syncope alike.'),
  'medication_nonadherence': EvidenceWeight({_e: 1.0}, 'Missed antiseizure medication is a common cause of breakthrough seizures.'),
  'sleep_deprivation': EvidenceWeight({_e: 0.6}, 'Sleep deprivation lowers seizure threshold.'),
  'alcohol': EvidenceWeight({_e: 0.6, _o: 0.3}, 'Alcohol intoxication or withdrawal provokes seizures and metabolic mimics.'),
  'drug_use': EvidenceWeight({_e: 0.5, _o: 0.4}, 'Drug use or withdrawal can provoke seizures or toxic mimics.'),
  'fever': EvidenceWeight({_e: 0.4, _o: 0.6}, 'Fever raises concern for an acute symptomatic seizure or a febrile mimic.'),
};

const Map<TongueBiteLocation, EvidenceWeight> tongueBiteWeights = {
  TongueBiteLocation.lateral: EvidenceWeight({_e: 2.0, _p: -0.8, _s: -0.6},
      'Lateral tongue biting is highly specific for an epileptic seizure (specificity ~100% vs PNES, sensitivity 22%; '
          'Calgary item +2).',
      grade: _a, source: 'brigo2012'),
  TongueBiteLocation.tip: EvidenceWeight({_e: 0.3},
      'Tip-of-tongue biting is non-specific and occurs after falls, syncope and PNES.',
      grade: _b, source: 'benbadis1995'),
  TongueBiteLocation.none: EvidenceWeight({}, ''),
};

const Map<SeizureDuration, EvidenceWeight> durationWeights = {
  SeizureDuration.brief: EvidenceWeight({_s: 1.2, _e: -0.2, _p: -0.6},
      'Events under 30 seconds are typical of syncope, including convulsive syncope.',
      grade: _b, source: 'lempert1994'),
  SeizureDuration.typical: EvidenceWeight({_e: 0.6},
      'Thirty seconds to two minutes is typical of a generalized tonic-clonic seizure.'),
  SeizureDuration.prolonged: EvidenceWeight({_p: 1.4, _e: -0.4, _s: -1.0},
      'Long duration favours PNES; prolonged convulsing with good colour is rarely epileptic.',
      grade: _a, source: 'avbersek2010'),
};

/// Investigation results. Omitted combinations contribute nothing.
const Map<String, Map<InvestigationResult, EvidenceWeight>> investigationWeights = {
  'ecg': {
    InvestigationResult.abnormal: EvidenceWeight({_s: 1.2},
        'An abnormal ECG makes arrhythmic syncope possible — see the red flags.',
        grade: _a, source: 'brignole2018'),
  },
  'eeg': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 2.3},
        'Interictal epileptiform discharges are found in under 1% of healthy adults, so they strongly support epilepsy.',
        grade: _b, source: 'smith2005'),
    InvestigationResult.nonSpecific: EvidenceWeight({_e: 0.2},
        'Non-specific slowing is common and does not establish epilepsy.', grade: _b, source: 'smith2005'),
    InvestigationResult.normal: EvidenceWeight({},
        'A normal routine EEG does not discriminate: about half of people with epilepsy have one.',
        grade: _b, source: 'smith2005'),
  },
  'video_eeg': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 4.0, _p: -2.0},
        'An ictal epileptiform correlate during the typical event confirms an epileptic seizure.',
        grade: _a, source: 'lafrance2013'),
    InvestigationResult.normal: EvidenceWeight({_p: 3.0, _e: -1.5},
        'A typical event on video-EEG without ictal change is the basis of a documented PNES diagnosis '
            '(focal aware seizures can lack a scalp correlate).',
        grade: _a, source: 'lafrance2013'),
  },
  'mri': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 1.4},
        'A potentially epileptogenic lesion on MRI supports a focal epilepsy, if it fits the semiology.'),
  },
  'ct': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 1.0, _o: 0.6},
        'An acute lesion on CT can cause an acute symptomatic seizure or mimic one (e.g. TIA).'),
  },
  'glucose': {
    InvestigationResult.abnormal: EvidenceWeight({_o: 2.0, _e: 0.2},
        'Hypo- or hyperglycaemia is a common metabolic mimic or provoking cause; correct it first.'),
  },
  'electrolytes': {
    InvestigationResult.abnormal: EvidenceWeight({_o: 1.0, _e: 0.6},
        'Hyponatraemia, hypocalcaemia or hypomagnesaemia can provoke seizures or mimic them.'),
  },
  'prolactin': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 1.4, _s: 0.6, _p: -1.0},
        'A prolactin rise 10–20 min after the event supports a seizure over PNES, but it also rises after syncope.',
        grade: _a, source: 'chen2005'),
    InvestigationResult.normal: EvidenceWeight({_p: 0.4, _e: -0.3},
        'A normal prolactin does not exclude an epileptic seizure; it only slightly favours PNES.',
        grade: _a, source: 'chen2005'),
  },
  'ck': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 0.8},
        'A delayed CK rise reflects muscle injury after a convulsion; sensitivity is low.'),
  },
  'lactate': {
    InvestigationResult.abnormal: EvidenceWeight({_e: 1.0},
        'An early lactate rise supports a recent generalized convulsion.'),
  },
};

/// Localization pull for each finding key toward each [LocalizationRegion]
/// (unitless, added to a baseline of 1 per region and normalized).
const Map<String, Map<LocalizationRegion, double>> localizationWeights = {
  'deja_vu': {LocalizationRegion.temporal: 2.0},
  'jamais_vu': {LocalizationRegion.temporal: 1.8},
  'fear': {LocalizationRegion.temporal: 1.6},
  'epigastric_rising': {LocalizationRegion.temporal: 1.8, LocalizationRegion.insular: 0.8},
  'olfactory': {LocalizationRegion.temporal: 1.8},
  'gustatory': {LocalizationRegion.insular: 1.6, LocalizationRegion.temporal: 1.0},
  'laryngeal_constriction': {LocalizationRegion.insular: 2.4},
  'visual': {LocalizationRegion.occipital: 2.2},
  'auditory': {LocalizationRegion.temporal: 1.8},
  'somatosensory': {LocalizationRegion.parietal: 2.0, LocalizationRegion.insular: 0.6},
  'vertigo': {LocalizationRegion.temporal: 0.8, LocalizationRegion.parietal: 0.6, LocalizationRegion.insular: 0.6},
  'autonomic': {LocalizationRegion.insular: 1.2, LocalizationRegion.temporal: 0.8},
  'speech_arrest': {LocalizationRegion.frontal: 1.2, LocalizationRegion.temporal: 1.0},
  'behavioral_arrest': {LocalizationRegion.temporal: 1.4},
  'automatisms': {LocalizationRegion.temporal: 1.8},
  'lip_smacking': {LocalizationRegion.temporal: 2.0},
  'hand_automatisms': {LocalizationRegion.temporal: 1.8},
  'head_deviation': {LocalizationRegion.frontal: 1.6},
  'eye_deviation': {LocalizationRegion.frontal: 1.2, LocalizationRegion.occipital: 0.8},
  'from_sleep': {LocalizationRegion.frontal: 1.0},
  'hypermotor_activity': {LocalizationRegion.frontal: 2.0, LocalizationRegion.insular: 0.9},
  'figure_of_four': {LocalizationRegion.frontal: 1.6, LocalizationRegion.temporal: 0.8},
  'fencing_posture': {LocalizationRegion.frontal: 2.4},
  'bicycling_movements': {LocalizationRegion.frontal: 1.8},
  'ictal_speech_preserved': {LocalizationRegion.temporal: 1.2},
  'ictal_vomiting': {LocalizationRegion.temporal: 1.4, LocalizationRegion.insular: 0.6},
  'tonic_phase': {LocalizationRegion.generalized: 1.2},
  'clonic_phase': {LocalizationRegion.generalized: 1.0},
  'myoclonic_jerks': {LocalizationRegion.generalized: 1.8},
  'atonic_drop': {LocalizationRegion.generalized: 2.0},
};

/// Approximate prior probabilities by setting. These are editorial
/// assumptions, shown to the user, not data from a single study.
const Map<ClinicalSetting, Map<EventCategory, double>> settingPriors = {
  ClinicalSetting.unspecified: {_e: 0.25, _p: 0.25, _s: 0.25, _o: 0.25},
  ClinicalSetting.emergency: {_e: 0.30, _p: 0.10, _s: 0.45, _o: 0.15},
  ClinicalSetting.epilepsyClinic: {_e: 0.60, _p: 0.25, _s: 0.08, _o: 0.07},
};
