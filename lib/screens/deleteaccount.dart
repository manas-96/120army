import '../exports.dart';
import '../global.dart';
import '../main.dart';
import '../services/main_service.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';
import 'widget/toast.dart';

class Deleteaccount extends StatefulWidget {
  const Deleteaccount({super.key});

  @override
  State<Deleteaccount> createState() => _DeleteaccountState();
}

class _DeleteaccountState extends State<Deleteaccount> {
  final TextEditingController passwordController = TextEditingController();
  bool togglePassword = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Delete account",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              CustomTextField(
                labelText: "Password",
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
                  if (value == null || value.trim().isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
              ),
              CustomButton(
                text: "Permanently Delete Account",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    MainService()
                        .deleteaccountApiService(
                          password: passwordController.text,
                        )
                        .then((value) {
                          if (value!.status == "success") {
                            navigatorKey.currentState?.pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                            showGlobalSnackBar(message: value.msg);
                          } else {
                            showGlobalSnackBar(message: value.msg);
                          }
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
