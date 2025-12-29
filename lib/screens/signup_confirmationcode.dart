import '../exports.dart';
import '../global.dart';
import '../statemanagment/confirmationcode/confirmationcode_bloc.dart';
import '../statemanagment/otpverify/otpverify_bloc.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';
import 'widget/toast.dart';

class Signupconfirmationcode extends StatelessWidget {
  final String user_id;
  final String contact_details;
  final String type;
  final bool resendOtp;

  const Signupconfirmationcode({
    super.key,
    required this.user_id,
    required this.contact_details,
    required this.type,
    this.resendOtp = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ConfirmationcodeBloc()),
        BlocProvider(create: (_) => OtpverifyBloc()),
      ],
      child: _SignupconfirmationcodeContent(
        user_id: user_id,
        contact_details: contact_details,
        type: type,
        resendOtp: resendOtp,
      ),
    );
  }
}

class _SignupconfirmationcodeContent extends StatefulWidget {
  final String user_id;
  final String contact_details;
  final String type;
  final bool resendOtp;

  const _SignupconfirmationcodeContent({
    required this.user_id,
    required this.contact_details,
    required this.type,
    this.resendOtp = false,
  });

  @override
  State<_SignupconfirmationcodeContent> createState() =>
      _SignupconfirmationcodeContentState();
}

class _SignupconfirmationcodeContentState
    extends State<_SignupconfirmationcodeContent> {
  final TextEditingController confirmationcodeController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void otp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfirmationcodeBloc>().add(
        ConfirmationcodeEventTrigger(widget.user_id),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.resendOtp) {
      otp();
    }
  }

  void validationFun() {
    if (_formKey.currentState!.validate()) {
      context.read<OtpverifyBloc>().add(
        OtpverifyEventTrigger(
          confirmationcodeController.text,
          widget.user_id,
          widget.type,
        ),
      );
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
                    "To confirm your account, enter the 4-digit code we sent via text message to ${widget.contact_details}.",
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
                  BlocListener<ConfirmationcodeBloc, ConfirmationcodeState>(
                    listener: (context, state) {
                      if (state is ConfirmationcodeLoaded) {
                        showGlobalSnackBar(
                          message: "OTP has been sent to your registered email.",
                        );
                      } else if (state is ConfirmationcodeError) {
                        showGlobalSnackBar(message: state.error.toString());
                      }
                    },
                    child: SizedBox.shrink(),
                  ),
                  BlocListener<OtpverifyBloc, OtpverifyState>(
                    listener: (context, state) {
                      if (state is OtpverifyLoaded) {
                        if (state.model.status == "failed") {
                          showGlobalSnackBar(
                            message: "Invalid OTP. Please try again.",
                          );
                        } else {
                          showGlobalSnackBar(
                            message: "OTP has been verified.",
                          );
                          Navigator.of(context).pushNamed(
                            "/login",
                            arguments: {"animationEnabled": false},
                          );
                        }
                      } else if (state is OtpverifyError) {
                        showGlobalSnackBar(
                          message: "Invalid OTP. Please try again.",
                        );
                      }
                    },
                    child: SizedBox.shrink(),
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
