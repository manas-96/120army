import '../exports.dart';
import '../global.dart';
import '../statemanagment/signupdatatransfer/signup_bloc.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';

class Signupname extends StatefulWidget {
  const Signupname({super.key});

  @override
  State<Signupname> createState() => _SignupnameState();
}

class _SignupnameState extends State<Signupname> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void validationFun() {
    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(
        UpdateName(firstnameController.text, lastnameController.text),
      );
      Navigator.of(context).pushNamed("/signupgender");
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
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    "What's your name?",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "Enter the name you use in real life.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Gap(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CustomTextField(
                                  labelText: "First name",
                                  controller: firstnameController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "First name is required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Gap(10),
                          Expanded(
                            child: Column(
                              children: [
                                CustomTextField(
                                  labelText: "Last name",
                                  controller: lastnameController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Last name is required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Gap(15),
                  CustomButton(
                    text: "Next",
                    onPressed: () {
                      validationFun();
                    },
                    // onPressed: () {
                    //   Navigator.of(context).pushNamed("/signupgender");
                    // },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Bottomlogin(),
    );
  }
}
