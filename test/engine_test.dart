import 'package:flutter_test/flutter_test.dart';
import 'package:seizure_compass/data/models/assessment_input.dart';
import 'package:seizure_compass/data/models/enums.dart';
import 'package:seizure_compass/data/repositories/example_cases.dart';
import 'package:seizure_compass/domain/scoring/seizure_scoring_engine.dart';

void main() {
  const engine = SeizureScoringEngine();
  ExampleCase ex(String id) => exampleCases.firstWhere((c) => c.id == id);

  test('probabilities sum to 1 and equal the prior with no findings', () {
    final r = engine.score(AssessmentInput());
    final total = r.probabilities.values.fold<double>(0, (a, b) => a + b);
    expect(total, closeTo(1, 1e-9));
    for (final p in r.probabilities.values) {
      expect(p, closeTo(0.25, 1e-9));
    }
  });

  test('convulsive seizure example favours epileptic, left hemisphere', () {
    final r = engine.score(ex('convulsive-seizure').build());
    expect(r.topCategory, EventCategory.epileptic);
    expect(r.probabilities[EventCategory.epileptic]!, greaterThan(0.8));
    expect(r.lateralization.side, Side.left);
    expect(r.calgary.favoursSeizure, isTrue);
  });

  test('PNES example favours PNES despite an epilepsy label', () {
    final r = engine.score(ex('pnes').build());
    expect(r.topCategory, EventCategory.pnes);
  });

  test('convulsive syncope example favours syncope; Calgary negative', () {
    final r = engine.score(ex('convulsive-syncope').build());
    expect(r.topCategory, EventCategory.syncope);
    expect(r.calgary.score, lessThan(1));
    expect(r.patternNotes.any((n) => n.contains('convulsive syncope')), isTrue);
  });

  test('cardiac red flags surface regardless of the differential', () {
    final r = engine.score(ex('cardiac-red-flag').build());
    expect(r.hasCardiacFlag, isTrue);
    expect(r.redFlags.length, greaterThanOrEqualTo(3));
  });

  test('urinary incontinence alone does not move the estimate', () {
    final i = AssessmentInput()..semiologyFindings.add('urinary_incontinence');
    final r = engine.score(i);
    for (final p in r.probabilities.values) {
      expect(p, closeTo(0.25, 1e-9));
    }
  });

  test('ictal weeping favours PNES', () {
    final i = AssessmentInput()..semiologyFindings.add('ictal_weeping');
    expect(engine.score(i).topCategory, EventCategory.pnes);
  });

  test('correlated automatisms are damped', () {
    final one = AssessmentInput()..semiologyFindings.add('lip_smacking');
    final three = AssessmentInput()..semiologyFindings.addAll(['lip_smacking', 'hand_automatisms', 'automatisms']);
    final c = engine.score(three).contributions.where((x) => x.damped).length;
    expect(c, 2);
    expect(engine.score(three).probabilities[EventCategory.epileptic]!,
        greaterThan(engine.score(one).probabilities[EventCategory.epileptic]!));
  });

  test('a raised prolactin also nudges syncope (AAN 2005)', () {
    final i = AssessmentInput()..investigations['prolactin'] = InvestigationResult.abnormal;
    final r = engine.score(i);
    expect(r.probabilities[EventCategory.syncope]!, greaterThan(r.probabilities[EventCategory.pnes]!));
  });
}
