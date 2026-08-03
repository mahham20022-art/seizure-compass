import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/wizard_scaffold.dart';
import 'assessment_controller.dart';
import 'result/result_screen.dart';
import 'steps/step1_patient.dart';
import 'steps/step2_aura.dart';
import 'steps/step3_semiology.dart';
import 'steps/step4_postictal.dart';
import 'steps/step5_investigations.dart';

/// Hosts the 5-step assessment wizard behind a single [AssessmentController]
/// instance, advancing through steps and finally pushing the result
/// dashboard.
class AssessmentWizardScreen extends StatefulWidget {
  const AssessmentWizardScreen({super.key});

  @override
  State<AssessmentWizardScreen> createState() => _AssessmentWizardScreenState();
}

class _AssessmentWizardScreenState extends State<AssessmentWizardScreen> {
  late final AssessmentController _controller = AssessmentController();
  int _step = 1;

  static const _titles = {
    1: 'Patient',
    2: 'Aura',
    3: 'Semiology',
    4: 'Postictal',
    5: 'Investigations',
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 5) {
      setState(() => _step++);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: _controller,
          child: ResultScreen(result: _controller.computeResult()),
        ),
      ),
    );
  }

  void _back() {
    if (_step > 1) {
      setState(() => _step--);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: PopScope(
        // Steps 2-5 are just internal state, not separate routes, so the
        // system/browser back gesture must step back one section instead
        // of leaving the wizard entirely.
        canPop: _step == 1,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _back();
        },
        child: WizardScaffold(
          step: _step,
          totalSteps: 5,
          stepLabel: _titles[_step]!,
          onBack: _back,
          onNext: _next,
          nextLabel: _step == 5 ? 'See results' : 'Continue',
          child: switch (_step) {
            1 => const Step1Patient(),
            2 => const Step2Aura(),
            3 => const Step3Semiology(),
            4 => const Step4Postictal(),
            _ => const Step5Investigations(),
          },
        ),
      ),
    );
  }
}
