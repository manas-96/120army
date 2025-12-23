import '../exports.dart';
import '../global.dart';
import '../statemanagment/signupdatatransfer/signup_bloc.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';

class Signupgender extends StatefulWidget {
  const Signupgender({super.key});

  @override
  State<Signupgender> createState() => _SignupgenderState();
}

class _SignupgenderState extends State<Signupgender> {
  final _formKey = GlobalKey<FormState>();
  String? gender;
  String? genderError;

  void _validateAndProceed() {
    setState(() {
      genderError = gender == null ? "Please select your gender." : null;
    });

    if (gender != null) {
      context.read<SignupBloc>().add(UpdateGender(gender.toString()));
      Navigator.of(context).pushNamed("/signupbirthday");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  "What's your gender?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  "You can change who sees your gender on your profile later.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Gap(20),
                // gender
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(kDefaultPadding),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: greyBorderColor),
                      borderRadius: BorderRadius.circular(radiusbox),
                    ),
                    child: Column(
                      spacing: 15,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = "Female";
                              genderError = null;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Female",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Transform.scale(
                                scale: 1.2, // Increase radio button size
                                child: Radio<String>(
                                  value: "Female",
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value;
                                      genderError = null;
                                    });
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = "Male";
                              genderError = null;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Male",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Transform.scale(
                                scale: 1.2, // Increase radio button size
                                child: Radio<String>(
                                  value: "Male",
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value;
                                      genderError = null;
                                    });
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (genderError != null) // Show error if exists
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      genderError!,
                      style: TextStyle(color: errorColor, fontSize: smallSize),
                    ),
                  ),
                Gap(15),

                CustomButton(text: "Next", onPressed: _validateAndProceed),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Bottomlogin(),
    );
  }
}
