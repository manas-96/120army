import '../exports.dart';
import '../global.dart';
import '../services/main_service.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';
import 'widget/toast.dart';

class Forgotpassotp extends StatefulWidget {
  const Forgotpassotp({
    super.key,
    required this.contact_details,
    required this.user_id,
  });

  final String contact_details;
  final String user_id;

  @override
  State<Forgotpassotp> createState() => _ForgotpassotpState();
}

class _ForgotpassotpState extends State<Forgotpassotp> {
  final TextEditingController confirmationcodeController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void otp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MainService()
          .forgotpasswordService(username: widget.contact_details)
          .then((value) {
            if (value.status == "success") {
              showGlobalSnackBar(message: value.message);
            } else {
              showGlobalSnackBar(message: value.message);
            }
          });
    });
  }

  void validationFun() {
    if (_formKey.currentState!.validate()) {
      MainService()
          .otpverifyService(
            otp: confirmationcodeController.text,
            user_id: widget.user_id,
            type: "reset_password",
          )
          .then((value) {
            if (value!.status == "success") {
              showGlobalSnackBar(message: value.msg!);
              Navigator.of(context).pushNamed(
                "/resetpassword",
                arguments: {"user_id": widget.user_id},
              );
            } else {
              showGlobalSnackBar(message: value.msg!);
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
                    "Enter the confirmation code",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Gap(2),
                  Text(
                    "Enter the 4-digit code we sent via text message to ${widget.contact_details}.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Gap(15),
                  CustomTextField(
                    labelText: "Confirmation code",
                    controller: confirmationcodeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Confirmation code is required";
                      } else if (value.trim().length != 4) {
                        return "Confirmation code must be 4 digits";
                      }
                      return null;
                    },
                  ),
                  Gap(15),
                  CustomButton(text: "Next", onPressed: validationFun),
                  Gap(5),
                  CustomButton(
                    text: "I didn't get the code",
                    isOutlined: true,
                    onPressed: otp,
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
