import '../exports.dart';
import '../global.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';

class Signupcreatepassword extends StatefulWidget {
  const Signupcreatepassword({super.key});

  @override
  State<Signupcreatepassword> createState() => _SignupcreatepasswordState();
}

class _SignupcreatepasswordState extends State<Signupcreatepassword> {
  final TextEditingController createpassword = TextEditingController();
  bool togglePassword = false;

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
                  "Create a password",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Gap(2),
                Text(
                  "Create a password with at least 6 letters or numbers. It should be something others can't guess.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Gap(15),
                CustomTextField(
                  labelText: "Password",
                  controller: createpassword,
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
                ),

                Gap(15),
                CustomButton(text: "Next", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Bottomlogin(),
    );
  }
}
