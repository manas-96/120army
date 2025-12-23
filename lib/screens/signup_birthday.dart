import 'package:flutter/cupertino.dart';

import '../exports.dart';
import '../global.dart';
import '../statemanagment/signupdatatransfer/signup_bloc.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';

class Signupbirthday extends StatefulWidget {
  const Signupbirthday({super.key});

  @override
  State<Signupbirthday> createState() => _SignupbirthdayState();
}

class _SignupbirthdayState extends State<Signupbirthday> {
  final TextEditingController birthdayController = TextEditingController();
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 365 * 5));
  final _formKey = GlobalKey<FormState>();

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime(1990, 1, 1),
            maximumDate: DateTime.now().subtract(
              Duration(days: 365 * 5),
            ), // Maximum date is 10 years ago
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
                birthdayController.text =
                    "${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}-${newDate.year}";
              });
            },
          ),
        );
      },
    );
  }

  void validationFun() {
    if (_formKey.currentState!.validate()) {
      context.read<SignupBloc>().add(UpdateDob(selectedDate));
      Navigator.of(context).pushNamed("/signupmobileno");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      if (mounted) {
        _showDatePicker(context);
      }
    });
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
                  "What's your birthday?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  "Choose your date of birth.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Gap(20),
                InkWell(
                  onTap: () => _showDatePicker(context),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: CustomTextField(
                        labelText: "Your birthday",
                        controller: birthdayController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Your Birthday is required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                Gap(15),
                CustomButton(text: "Next", onPressed: validationFun),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Bottomlogin(),
    );
  }
}
