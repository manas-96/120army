import '../exports.dart';
import '../global.dart';
import '../services/main_service.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';
import 'widget/toast.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({super.key, required this.user_id});

  final String user_id;

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool togglePassword = false;
  bool toggleConfirmPassword = false;

  void validationFun() {
    if (_formKey.currentState!.validate()) {
      MainService()
          .resetpasswordService(
            new_password: passwordController.text,
            confirm_new_password: confirmpasswordController.text,
            user_id: widget.user_id,
          )
          .then((value) {
            if (value.status == "success") {
              showGlobalSnackBar(message: value.msg);
              Navigator.of(
                context,
              ).pushNamed("/login", arguments: {"animationEnabled": false});
            } else {
              showGlobalSnackBar(message: value.msg);
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: SingleChildScrollView(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reset your password",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Gap(12),

                  // 🔒 New Password Field
                  CustomTextField(
                    labelText: "New password",
                    controller: passwordController,
                    obscureText: !togglePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          togglePassword = !togglePassword;
                        });
                      },
                      icon: Icon(
                        togglePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 26,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                        return 'At least one uppercase letter';
                      }
                      if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                        return 'At least one lowercase letter';
                      }
                      if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                        return 'At least one number';
                      }
                      if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(value)) {
                        return 'At least one special character';
                      }
                      if (value.length < 8 || value.length > 16) {
                        return 'Between 8-16 characters';
                      }
                      return null;
                    },
                  ),

                  Gap(6),

                  // 🔒 Confirm Password Field
                  CustomTextField(
                    labelText: "Confirm password",
                    controller: confirmpasswordController,
                    obscureText: !toggleConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          toggleConfirmPassword = !toggleConfirmPassword;
                        });
                      },
                      icon: Icon(
                        toggleConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 26,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Confirm password is required";
                      } else if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  Gap(15),
                  CustomButton(text: "Submit", onPressed: validationFun),
                  Gap(5),
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
