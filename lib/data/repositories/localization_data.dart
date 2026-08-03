import '../models/enums.dart';
import '../models/localization_region_info.dart';

/// Reference content for Module 2 — Localization Explorer.
const List<LocalizationRegionInfo> localizationRegions = [
  LocalizationRegionInfo(
    region: LocalizationRegion.temporal,
    typicalAura: [
      'Déjà vu / jamais vu',
      'Epigastric rising sensation',
      'Fear or anxiety',
      'Olfactory or gustatory hallucination',
    ],
    semiology: [
      'Behavioral arrest with impaired awareness',
      'Oroalimentary automatisms (lip smacking, chewing)',
      'Hand automatisms (fumbling, picking)',
      'Dystonic posturing of the contralateral hand',
      'Postictal confusion; aphasia if dominant hemisphere',
    ],
    eeg: 'Anterior/mid-temporal interictal spikes or sharp waves; ictal rhythmic theta over the temporal region.',
    mri: 'Mesial temporal sclerosis (hippocampal atrophy/T2-FLAIR signal change), low-grade tumor (DNET, ganglioglioma), or focal cortical dysplasia.',
    differentials: [
      'Frontal lobe seizure (briefer, more often nocturnal, rapid secondary generalization)',
      'Psychogenic non-epileptic seizure',
      'Transient global amnesia',
      'Panic attack',
    ],
  ),
  LocalizationRegionInfo(
    region: LocalizationRegion.frontal,
    typicalAura: [
      'Often none, or brief non-specific somatosensory aura',
      'Sense of urge to move',
    ],
    semiology: [
      'Hypermotor/hyperkinetic activity (thrashing, kicking)',
      'Bicycling leg movements',
      'Figure-of-4 sign and fencing (M2e) posture',
      'Asymmetric tonic limb posturing',
      'Vocalization or screaming',
      'Brief, frequent, clustered, often nocturnal events with rapid recovery',
    ],
    eeg: 'Frequently normal or non-localizing on scalp interictal recording due to deep/rapidly propagating onset; ictal frontal fast activity when captured.',
    mri: 'Often MRI-negative; focal cortical dysplasia is the leading identifiable substrate.',
    differentials: [
      'NREM parasomnia / arousal disorder',
      'Psychogenic non-epileptic seizure (hypermotor overlap is a recognized pitfall)',
      'Paroxysmal kinesigenic dyskinesia',
    ],
  ),
  LocalizationRegionInfo(
    region: LocalizationRegion.parietal,
    typicalAura: [
      'Contralateral tingling, numbness, or pain',
      'Disturbed body image / asomatognosia',
      'Illusion of movement',
    ],
    semiology: [
      'Sensory Jacksonian march',
      'Rapid spread to adjacent frontal or temporal cortex, producing motor or automatism semiology that can mask the parietal onset',
    ],
    eeg: 'Interictal parietal spikes are often subtle or absent on scalp EEG.',
    mri: 'Parietal cortical lesion or focal cortical dysplasia.',
    differentials: [
      'Sensory transient ischemic attack',
      'Migraine with sensory aura',
    ],
  ),
  LocalizationRegionInfo(
    region: LocalizationRegion.occipital,
    typicalAura: [
      'Elementary visual hallucinations (flashing lights, colored circles/spots)',
      'Transient visual field deficit or blindness',
    ],
    semiology: [
      'Eye deviation and/or nystagmus',
      'Forced eyelid closure or blinking',
      'May spread to temporal or frontal cortex with secondary semiology',
    ],
    eeg: 'Occipital spikes; photoparoxysmal response may be seen.',
    mri: 'Occipital lesion or cortical dysplasia; consider self-limited occipital epilepsies (Panayiotopoulos, Gastaut type) in children.',
    differentials: [
      'Migraine with visual aura (typically a slower-evolving, spreading scintillating scotoma over 15-30 minutes)',
      'Occipital stroke / TIA',
    ],
  ),
  LocalizationRegionInfo(
    region: LocalizationRegion.insular,
    typicalAura: [
      'Laryngeal discomfort or constriction, choking sensation',
      'Epigastric rising sensation',
      'Perioral or facial paresthesia',
    ],
    semiology: [
      'Dysautonomia (tachycardia, flushing)',
      'Dysphagia or a sensation of throat tightness',
      'Painful unilateral somatosensory sensation',
    ],
    eeg: 'Often silent or non-localizing on scalp EEG owing to the deep insular location.',
    mri: 'Insular lesion or focal cortical dysplasia.',
    differentials: [
      'Temporal lobe seizure (frequently confused given overlapping aura)',
      'Panic attack',
    ],
  ),
  LocalizationRegionInfo(
    region: LocalizationRegion.generalized,
    typicalAura: [
      'Usually none',
      'Occasionally a non-localizing prodrome (irritability, mood change) hours beforehand',
    ],
    semiology: [
      'Bilateral tonic-clonic activity from onset',
      'Absence: abrupt onset/offset staring with impaired awareness',
      'Myoclonic jerks, typically on awakening',
      'Atonic drop attacks',
    ],
    eeg: 'Generalized spike-wave discharges (classically ~3 Hz in absence seizures; polyspike-wave in juvenile myoclonic epilepsy).',
    mri: 'Usually normal — most genetic generalized epilepsies are not associated with a structural lesion.',
    differentials: [
      'Convulsive syncope',
      'Psychogenic non-epileptic seizure',
      'Cardiac arrhythmia (for drop attacks / atonic-like collapse)',
    ],
  ),
];
