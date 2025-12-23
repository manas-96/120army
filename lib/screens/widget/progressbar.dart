import '../../exports.dart';
import '../../global.dart';

class Progressbar extends StatelessWidget {
  final int maxSteps;
  final int currentStep;

  const Progressbar({
    super.key,
    required this.maxSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressBar(
      maxSteps: maxSteps,
      progressType: LinearProgressBar.progressTypeLinear,
      minHeight: 6,
      currentStep: currentStep,
      progressColor: kPrimaryColor,
      backgroundColor: kLightPrimaryColor,
      borderRadius: BorderRadius.circular(10),
    );
  }
}
