import 'enums.dart';

/// A single selectable finding: a stable key (used by the scoring engine)
/// paired with the physician-facing label shown in the wizard.
class FindingOption {
  const FindingOption(this.key, this.label, {this.hint});
  final String key;
  final String label;

  /// Optional one-line clarification shown under the chip group.
  final String? hint;
}

/// Step 2a — Circumstances and prodrome (before the event). Several of these
/// are items of the Calgary Syncope–Seizure Score.
const prodromeOptions = [
  FindingOption('prolonged_standing', 'Prolonged standing or sitting, heat, crowd'),
  FindingOption('presyncope_lightheaded', 'Light-headed / about to faint'),
  FindingOption('presyncope_sweating', 'Sweating, pallor or nausea before'),
  FindingOption('situational_trigger', 'Micturition, cough, pain or blood/needle'),
  FindingOption('emotional_trigger', 'Emotional stress at onset'),
  FindingOption('from_sleep', 'Arose from sleep (witnessed)'),
];

/// Step 2b — Aura symptoms.
const auraOptions = [
  FindingOption('deja_vu', 'Déjà vu'),
  FindingOption('jamais_vu', 'Jamais vu'),
  FindingOption('fear', 'Fear / anxiety'),
  FindingOption('epigastric_rising', 'Epigastric rising sensation'),
  FindingOption('olfactory', 'Olfactory aura'),
  FindingOption('gustatory', 'Gustatory aura'),
  FindingOption('laryngeal_constriction', 'Throat constriction / perioral tingling'),
  FindingOption('visual', 'Visual aura'),
  FindingOption('auditory', 'Auditory aura'),
  FindingOption('somatosensory', 'Somatosensory aura'),
  FindingOption('vertigo', 'Vertigo'),
  FindingOption('autonomic', 'Autonomic symptoms'),
  FindingOption('speech_arrest', 'Speech arrest'),
];

/// Step 3 — Ictal semiology.
const semiologyOptions = [
  FindingOption('behavioral_arrest', 'Behavioral arrest'),
  FindingOption('automatisms', 'Automatisms (general)'),
  FindingOption('lip_smacking', 'Lip smacking'),
  FindingOption('hand_automatisms', 'Hand automatisms (fumbling/picking)'),
  FindingOption('head_deviation', 'Head turning'),
  FindingOption('eye_deviation', 'Eye deviation'),
  FindingOption('forced_eye_closure', 'Eyes closed throughout / resists opening'),
  FindingOption('fluctuating_course', 'Waxing–waning, stop–start course'),
  FindingOption('asynchronous_limb_movements', 'Asynchronous limb movements'),
  FindingOption('side_to_side_head_shaking', 'Side-to-side head or body movement'),
  FindingOption('pelvic_thrusting', 'Pelvic thrusting'),
  FindingOption('opisthotonus', 'Opisthotonus (arc de cercle)'),
  FindingOption('ictal_weeping', 'Crying or weeping during the event'),
  FindingOption('tonic_phase', 'Tonic phase'),
  FindingOption('clonic_phase', 'Clonic phase'),
  FindingOption('myoclonic_jerks', 'Brief myoclonic jerks'),
  FindingOption('atonic_drop', 'Atonic drop'),
  FindingOption('pallor', 'Marked pallor during the event'),
  FindingOption('cyanosis', 'Cyanosis'),
  FindingOption('urinary_incontinence', 'Urinary incontinence'),
  FindingOption('hypermotor_activity', 'Hypermotor activity'),
  FindingOption('bicycling_movements', 'Bicycling movements'),
  FindingOption('figure_of_four', 'Figure-of-4 posture'),
  FindingOption('fencing_posture', 'Fencing posture'),
  FindingOption('gelastic_laughter', 'Gelastic laughter (mirthless)'),
  FindingOption('dacrystic_crying', 'Stereotyped crying grimace (dacrystic)'),
  FindingOption('ictal_speech_preserved', 'Speaks intelligibly while unaware'),
  FindingOption('ictal_vomiting', 'Ictal vomiting or spitting'),
  FindingOption('catamenial_relation', 'Catamenial relation'),
];

/// Step 4 — Postictal features.
const postictalOptions = [
  FindingOption('confusion', 'Postictal confusion'),
  FindingOption('stertorous_breathing', 'Stertorous (snoring) breathing after'),
  FindingOption('todd_paralysis', "Todd's paralysis"),
  FindingOption('aphasia', 'Postictal aphasia'),
  FindingOption('sleepiness', 'Postictal sleepiness'),
  FindingOption('immediate_recovery', 'Immediate full recovery'),
  FindingOption('ictal_recall', 'Recalls the event (aware but unable to respond)'),
  FindingOption('memory_loss', 'No memory of the event'),
];

/// "Don't miss" features. They are not diagnostic of any one category, but
/// any one of them makes an arrhythmic or structural cardiac cause possible
/// and overrides the differential on the result screen (ESC 2018 syncope
/// guideline high-risk features).
const cardiacFlagOptions = [
  FindingOption('exertional_onset', 'Onset during exertion'),
  FindingOption('supine_onset', 'Onset while lying down (awake)'),
  FindingOption('palpitations', 'Palpitations just before'),
  FindingOption('chest_pain', 'Chest pain or breathlessness'),
  FindingOption('fhx_sudden_death', 'Family history of sudden death < 40 y'),
  FindingOption('structural_heart', 'Known structural heart disease or heart failure'),
  FindingOption('injury_no_prodrome', 'Injury from abrupt fall with no warning'),
];

/// Neurological red flags that call for urgent imaging or treatment
/// whatever the event turns out to be.
const neuroFlagOptions = [
  FindingOption('persistent_deficit', 'Focal deficit that has not resolved'),
  FindingOption('thunderclap', 'Sudden severe headache'),
  FindingOption('fever_meningism', 'Fever with neck stiffness or rash'),
  FindingOption('head_injury', 'Head injury or anticoagulation'),
  FindingOption('pregnancy', 'Pregnant or within 6 weeks postpartum'),
  FindingOption('not_back_to_baseline', 'Not back to baseline after 30 min'),
];

/// Lateralizing signs. The user records the side on which the sign was
/// seen; [contralateral] says whether the sign points to the hemisphere
/// opposite that side. [ppv] is the approximate positive predictive value
/// for the side of onset (Loddenkemper & Kotagal, Epilepsy Behav 2005).
class LateralizingSign {
  const LateralizingSign(this.key, this.label, this.sideLabel,
      {required this.contralateral, required this.ppv});
  final String key;
  final String label;
  final String sideLabel;
  final bool contralateral;
  final double ppv;
}

const lateralizingSigns = [
  LateralizingSign('dystonic_posturing', 'Unilateral dystonic limb posturing', 'Side of the dystonic limb',
      contralateral: true, ppv: 0.90),
  LateralizingSign('forced_version', 'Forced head/eye version just before generalizing', 'Side the head turned to',
      contralateral: true, ppv: 0.90),
  LateralizingSign('unilateral_clonic', 'Unilateral clonic jerking', 'Side of the jerking limbs',
      contralateral: true, ppv: 0.90),
  LateralizingSign('figure4_extended', 'Figure-of-4: extended arm', 'Side of the extended arm',
      contralateral: true, ppv: 0.89),
  LateralizingSign('todd_side', "Todd's paresis", 'Side of the weak limbs',
      contralateral: true, ppv: 0.93),
  LateralizingSign('unilateral_automatisms', 'Unilateral limb automatisms (tone preserved)', 'Side of the moving hand',
      contralateral: false, ppv: 0.85),
  LateralizingSign('nose_wiping', 'Postictal nose-wiping', 'Hand used to wipe',
      contralateral: false, ppv: 0.85),
  LateralizingSign('unilateral_blink', 'Unilateral eye blinking', 'Side of the blinking eye',
      contralateral: false, ppv: 0.80),
];

/// Step 5 — Investigations. [resultLabels] override the default
/// Not done / Normal / Abnormal wording (in [InvestigationResult] order,
/// only for the results the test offers).
class InvestigationOption {
  const InvestigationOption(this.key, this.label, {this.results = _std, this.resultLabels = const {}});
  final String key;
  final String label;
  final List<InvestigationResult> results;
  final Map<InvestigationResult, String> resultLabels;

  static const _std = [InvestigationResult.notDone, InvestigationResult.normal, InvestigationResult.abnormal];

  String labelFor(InvestigationResult r) =>
      resultLabels[r] ??
      switch (r) {
        InvestigationResult.notDone => 'Not done',
        InvestigationResult.normal => 'Normal',
        InvestigationResult.nonSpecific => 'Non-specific',
        InvestigationResult.abnormal => 'Abnormal',
      };
}

const investigationOptions = [
  InvestigationOption('ecg', '12-lead ECG',
      resultLabels: {InvestigationResult.abnormal: 'Abnormal / long QT'}),
  InvestigationOption('glucose', 'Blood glucose'),
  InvestigationOption('electrolytes', 'Electrolytes (Na, Ca, Mg)'),
  InvestigationOption('eeg', 'Routine / sleep-deprived EEG',
      results: [InvestigationResult.notDone, InvestigationResult.normal, InvestigationResult.nonSpecific, InvestigationResult.abnormal],
      resultLabels: {InvestigationResult.nonSpecific: 'Slowing only', InvestigationResult.abnormal: 'Epileptiform'}),
  InvestigationOption('video_eeg', 'Video-EEG with a typical event',
      resultLabels: {InvestigationResult.normal: 'No ictal change', InvestigationResult.abnormal: 'Ictal correlate'}),
  InvestigationOption('mri', 'MRI brain', resultLabels: {InvestigationResult.abnormal: 'Epileptogenic lesion'}),
  InvestigationOption('ct', 'CT head', resultLabels: {InvestigationResult.abnormal: 'Acute lesion'}),
  InvestigationOption('prolactin', 'Prolactin 10–20 min after', resultLabels: {InvestigationResult.abnormal: 'Raised'}),
  InvestigationOption('ck', 'Creatine kinase (24–48 h)', resultLabels: {InvestigationResult.abnormal: 'Raised'}),
  InvestigationOption('lactate', 'Venous lactate (< 2 h)', resultLabels: {InvestigationResult.abnormal: 'Raised'}),
];

/// Every finding label by key, for rationale text.
final Map<String, String> findingLabels = {
  for (final o in [...prodromeOptions, ...auraOptions, ...semiologyOptions, ...postictalOptions, ...cardiacFlagOptions, ...neuroFlagOptions])
    o.key: o.label,
  for (final s in lateralizingSigns) s.key: s.label,
};
