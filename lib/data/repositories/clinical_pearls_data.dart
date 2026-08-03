import '../models/clinical_pearl.dart';

/// Reference content for Module 4 — Clinical Pearls.
const List<ClinicalPearl> clinicalPearls = [
  // Epilepsy vs PNES
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: 'Lateral tongue bite',
    text: 'Strongly favors a generalized tonic-clonic epileptic seizure over PNES.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: 'Forced eye closure',
    text: 'Forced or resisted eye closure during the event favors PNES — eyes are open in most epileptic seizures.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: "Todd's paralysis",
    text: 'Strongly supports a focal epileptic seizure and is rarely, if ever, seen in PNES.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: 'Asynchronous limb movements',
    text: 'Out-of-phase limb thrashing favors PNES; epileptic clonic activity is typically synchronous and rhythmic.',
    level: EvidenceLevel.supportive,
  ),
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: 'Immediate full recovery',
    text: 'Recovery without postictal confusion argues against a generalized epileptic seizure.',
    level: EvidenceLevel.supportive,
  ),
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: 'Post-ictal prolactin',
    text: 'A normal level after a witnessed convulsive event favors PNES; a rise at 10-20 minutes favors epilepsy.',
    level: EvidenceLevel.supportive,
  ),
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: 'Dual diagnosis is common',
    text: 'PNES and epilepsy frequently coexist in the same patient — diagnosing one does not exclude the other.',
    level: EvidenceLevel.expert,
  ),
  ClinicalPearl(
    category: 'Epilepsy vs PNES',
    title: 'Prolonged event duration',
    text: 'Events lasting many minutes with preserved oxygenation are more typical of PNES; most epileptic seizures self-terminate within 1-2 minutes.',
    level: EvidenceLevel.supportive,
  ),

  // Localization
  ClinicalPearl(
    category: 'Localization',
    title: 'Déjà vu & epigastric aura',
    text: 'Déjà vu, epigastric rising, and oroalimentary automatisms usually suggest temporal lobe onset.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Localization',
    title: 'Figure-of-4 & fencing posture',
    text: 'Both lateralize to a supplementary motor area (frontal) seizure, contralateral to the extended arm.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Localization',
    title: 'Clustered nocturnal seizures',
    text: 'Brief, frequent, clustered nocturnal seizures with rapid recovery point toward a frontal lobe origin.',
    level: EvidenceLevel.supportive,
  ),
  ClinicalPearl(
    category: 'Localization',
    title: 'Elementary visual hallucinations',
    text: 'Flashing lights suggest occipital onset; slower, spreading, colored scintillations suggest migraine instead.',
    level: EvidenceLevel.supportive,
  ),
  ClinicalPearl(
    category: 'Localization',
    title: 'Choking sensation & dysautonomia',
    text: 'Painful unilateral paresthesia with dysautonomia and a choking sensation should raise suspicion for insular onset.',
    level: EvidenceLevel.supportive,
  ),
  ClinicalPearl(
    category: 'Localization',
    title: 'MRI-negative frontal epilepsy',
    text: 'Frontal lobe seizures are frequently MRI-negative even when focal cortical dysplasia is the underlying cause.',
    level: EvidenceLevel.expert,
  ),

  // Syndromes / rare presentations
  ClinicalPearl(
    category: 'Syndromes',
    title: 'Gelastic seizures',
    text: 'Suggest a hypothalamic hamartoma, especially with precocious puberty in a child.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Syndromes',
    title: 'Early-morning myoclonus',
    text: 'Ask every adolescent with early-morning myoclonic jerks about juvenile myoclonic epilepsy before labeling episodes as clumsiness.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Syndromes',
    title: 'Infantile spasms',
    text: 'With developmental regression, a pediatric neurologic emergency requiring urgent EEG (hypsarrhythmia) and treatment.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Syndromes',
    title: 'Catamenial pattern',
    text: 'Best confirmed with a seizure diary correlated against a menstrual calendar, not by history alone.',
    level: EvidenceLevel.expert,
  ),
  ClinicalPearl(
    category: 'Syndromes',
    title: 'Reflex epilepsy triggers',
    text: 'Photosensitive, reading, musicogenic, hot water and startle epilepsies share a stereotyped trigger-to-seizure relationship — ask specifically.',
    level: EvidenceLevel.supportive,
  ),

  // Mimics
  ClinicalPearl(
    category: 'Mimics',
    title: 'Convulsive syncope',
    text: 'The single most commonly misdiagnosed seizure mimic in adults — look for a presyncopal prodrome and rapid full recovery.',
    level: EvidenceLevel.classic,
  ),
  ClinicalPearl(
    category: 'Mimics',
    title: 'Anoxic myoclonus',
    text: 'Brief myoclonic jerks during a faint do not make an event epileptic.',
    level: EvidenceLevel.supportive,
  ),
  ClinicalPearl(
    category: 'Mimics',
    title: 'Bedside glucose',
    text: 'Always check during the acute evaluation of any transient event — hypoglycemia is a readily reversible mimic.',
    level: EvidenceLevel.expert,
  ),
  ClinicalPearl(
    category: 'Mimics',
    title: 'Migraine aura tempo',
    text: 'Migraine with aura evolves more slowly (minutes) than an epileptic aura (seconds) and is usually followed by headache.',
    level: EvidenceLevel.supportive,
  ),

  // Investigations
  ClinicalPearl(
    category: 'Investigations',
    title: 'Normal EEG ≠ no epilepsy',
    text: 'A single normal interictal EEG does not exclude epilepsy — sensitivity rises with sleep-deprived and repeated recordings.',
    level: EvidenceLevel.expert,
  ),
  ClinicalPearl(
    category: 'Investigations',
    title: 'Video-EEG monitoring',
    text: 'Capturing a typical habitual event remains the diagnostic gold standard when the differential is unclear.',
    level: EvidenceLevel.expert,
  ),
  ClinicalPearl(
    category: 'Investigations',
    title: 'CK & lactate rise',
    text: 'Elevated CK and a transient venous lactate rise support a recent convulsive epileptic seizure.',
    level: EvidenceLevel.supportive,
  ),
];
