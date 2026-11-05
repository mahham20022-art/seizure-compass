import '../models/assessment_input.dart';
import '../models/enums.dart';

/// Worked examples reachable at `/example/<id>`. Teaching vignettes, not
/// real patients.
class ExampleCase {
  const ExampleCase(this.id, this.title, this.summary, this.build);
  final String id;
  final String title;
  final String summary;
  final AssessmentInput Function() build;
}

final exampleCases = <ExampleCase>[
  ExampleCase('convulsive-seizure', 'Convulsion from sleep',
      '34-year-old found convulsing in bed; lateral tongue bite, snoring breathing, confused for 20 minutes.', () {
    final i = AssessmentInput()..setting = ClinicalSetting.emergency;
    i.ageYears = 34;
    i.sleepDeprivation = true;
    i.prodromeFindings.add('from_sleep');
    i.auraFindings.add('deja_vu');
    i.semiologyFindings.addAll(['tonic_phase', 'clonic_phase', 'cyanosis', 'urinary_incontinence']);
    i.tongueBite = TongueBiteLocation.lateral;
    i.duration = SeizureDuration.typical;
    i.lateralSigns['forced_version'] = Side.right;
    i.lateralSigns['unilateral_clonic'] = Side.right;
    i.postictalFindings.addAll(['confusion', 'stertorous_breathing', 'aphasia', 'memory_loss']);
    return i;
  }),
  ExampleCase('pnes', 'Prolonged event, eyes shut',
      '27-year-old with "refractory epilepsy"; 15-minute events with eyes closed, side-to-side movements and weeping.', () {
    final i = AssessmentInput()..setting = ClinicalSetting.epilepsyClinic;
    i.ageYears = 27;
    i.knownEpilepsy = true;
    i.psychiatricDisease = true;
    i.prodromeFindings.add('emotional_trigger');
    i.semiologyFindings.addAll([
      'forced_eye_closure', 'fluctuating_course', 'asynchronous_limb_movements', 'side_to_side_head_shaking',
      'ictal_weeping',
    ]);
    i.duration = SeizureDuration.prolonged;
    i.postictalFindings.addAll(['ictal_recall', 'immediate_recovery']);
    i.investigations['eeg'] = InvestigationResult.normal;
    return i;
  }),
  ExampleCase('convulsive-syncope', 'Faint with jerks',
      '19-year-old standing in a hot queue, felt light-headed and sweaty, fell and jerked for 10 seconds.', () {
    final i = AssessmentInput()..setting = ClinicalSetting.emergency;
    i.ageYears = 19;
    i.prodromeFindings.addAll(['prolonged_standing', 'presyncope_lightheaded', 'presyncope_sweating']);
    i.semiologyFindings.addAll(['pallor', 'myoclonic_jerks', 'urinary_incontinence']);
    i.duration = SeizureDuration.brief;
    i.postictalFindings.add('immediate_recovery');
    return i;
  }),
  ExampleCase('cardiac-red-flag', 'Collapse while running',
      '16-year-old collapsed mid-race with a few jerks; cousin died suddenly at 22. Looks like "a seizure".', () {
    final i = AssessmentInput()..setting = ClinicalSetting.emergency;
    i.ageYears = 16;
    i.redFlags.addAll(['exertional_onset', 'fhx_sudden_death', 'injury_no_prodrome']);
    i.semiologyFindings.addAll(['myoclonic_jerks', 'tonic_phase']);
    i.duration = SeizureDuration.brief;
    i.postictalFindings.add('immediate_recovery');
    i.investigations['ecg'] = InvestigationResult.abnormal;
    return i;
  }),
];
