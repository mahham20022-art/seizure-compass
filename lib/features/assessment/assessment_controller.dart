import 'package:flutter/foundation.dart';
import '../../data/models/assessment_input.dart';
import '../../data/models/assessment_result.dart';
import '../../domain/scoring/seizure_scoring_engine.dart';

/// Owns the wizard's working [AssessmentInput] and produces the final
/// [AssessmentResult] on completion. Provided above the wizard via
/// `provider` so every step widget can read/mutate the same instance.
class AssessmentController extends ChangeNotifier {
  AssessmentController({this.engine = const SeizureScoringEngine()});

  final SeizureScoringEngine engine;

  final AssessmentInput input = AssessmentInput();

  void toggleSet(Set<String> set, String key) {
    if (set.contains(key)) {
      set.remove(key);
    } else {
      set.add(key);
    }
    notifyListeners();
  }

  void update(void Function(AssessmentInput input) mutate) {
    mutate(input);
    notifyListeners();
  }

  void startOver() {
    input.reset();
    notifyListeners();
  }

  AssessmentResult computeResult() => engine.score(input);
}
