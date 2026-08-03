/// A single selectable finding: a stable key (used by the scoring engine)
/// paired with the physician-facing label shown in the wizard.
class FindingOption {
  const FindingOption(this.key, this.label);
  final String key;
  final String label;
}

/// Step 2 — Aura symptoms.
const auraOptions = [
  FindingOption('deja_vu', 'Déjà vu'),
  FindingOption('jamais_vu', 'Jamais vu'),
  FindingOption('fear', 'Fear / anxiety'),
  FindingOption('epigastric_rising', 'Epigastric rising sensation'),
  FindingOption('olfactory', 'Olfactory aura'),
  FindingOption('gustatory', 'Gustatory aura'),
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
  FindingOption('head_deviation', 'Head deviation'),
  FindingOption('eye_deviation', 'Eye deviation'),
  FindingOption('forced_eye_closure', 'Forced eye closure'),
  FindingOption('asynchronous_limb_movements', 'Asynchronous limb movements'),
  FindingOption('pelvic_thrusting', 'Pelvic thrusting'),
  FindingOption('side_to_side_head_shaking', 'Side-to-side head shaking'),
  FindingOption('tonic_phase', 'Tonic phase'),
  FindingOption('clonic_phase', 'Clonic phase'),
  FindingOption('myoclonic_jerks', 'Myoclonic jerks'),
  FindingOption('atonic_drop', 'Atonic drop'),
  FindingOption('gelastic_laughter', 'Gelastic laughter'),
  FindingOption('dacrystic_crying', 'Dacrystic crying'),
  FindingOption('catamenial_relation', 'Catamenial relation'),
  FindingOption('nocturnal_seizure', 'Nocturnal occurrence'),
  FindingOption('hypermotor_activity', 'Hypermotor activity'),
  FindingOption('figure_of_four', 'Figure-of-4 posture'),
  FindingOption('fencing_posture', 'Fencing posture'),
  FindingOption('bicycling_movements', 'Bicycling movements'),
  FindingOption('opisthotonus', 'Opisthotonus (arc de cercle)'),
  FindingOption('urinary_incontinence', 'Urinary incontinence'),
  FindingOption('cyanosis', 'Cyanosis'),
];

/// Step 4 — Postictal features.
const postictalOptions = [
  FindingOption('confusion', 'Postictal confusion'),
  FindingOption('todd_paralysis', "Todd's paralysis"),
  FindingOption('sleepiness', 'Postictal sleepiness'),
  FindingOption('immediate_recovery', 'Immediate full recovery'),
  FindingOption('memory_loss', 'Memory loss for the event'),
  FindingOption('aphasia', 'Postictal aphasia'),
];

/// Step 5 — Investigations considered.
const investigationOptions = [
  FindingOption('eeg', 'EEG'),
  FindingOption('mri', 'MRI brain'),
  FindingOption('ct', 'CT head'),
  FindingOption('glucose', 'Blood glucose'),
  FindingOption('electrolytes', 'Electrolytes'),
  FindingOption('ck', 'Creatine kinase (CK)'),
  FindingOption('prolactin', 'Serum prolactin (10–20 min post-event)'),
  FindingOption('lactate', 'Venous lactate'),
];
