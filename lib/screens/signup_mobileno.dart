import 'dart:ui' as ui;

import '../exports.dart';
import '../global.dart';
import '../services/main_service.dart';
import '../statemanagment/signupdatatransfer/signup_bloc.dart';
import '../statemanagment/signupregistration/signupregistration_bloc.dart';
import 'widget/bottom_login.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';
import 'widget/toast.dart';

class Signupmobileno extends StatefulWidget {
  const Signupmobileno({super.key, this.forgotpass = false});

  final bool forgotpass;

  @override
  State<Signupmobileno> createState() => _SignupmobilenoState();
}

class _SignupmobilenoState extends State<Signupmobileno> {
  final TextEditingController mobilenoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool togglePassword = false;
  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('US');
  // bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  late bool _isEmailSignup;
  String type = "phone";

  void validationFun({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController mobilenoController,
    required TextEditingController passwordController,
  }) async {
    if (formKey.currentState!.validate()) {
      final data = context.read<SignupBloc>().state;
      context.read<SignupregistrationBloc>().add(
        SignupregistrationEventTrigger(
          data.firstName,
          data.lastName,
          _isEmailSignup ? emailController.text : "",
          _isEmailSignup ? "email" : "phone",
          _isEmailSignup ? "" : mobilenoController.text,
          _selectedCountry.phoneCode,
          data.gender,
          data.dob.toString(),
          passwordController.text,
          await FlutterTimezone.getLocalTimezone(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _isEmailSignup = false;

    final data = context.read<SignupBloc>().state;

    mobilenoController.text = data.mobile;
    emailController.text = data.email;

    // Dynamic country detect
    final locale = ui.PlatformDispatcher.instance.locale;
    final countryCode = locale.countryCode ?? "US";
    _selectedCountry = CountryPickerUtils.getCountryByIsoCode(
      countryCode.toUpperCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupregistrationBloc(),
      child: Scaffold(
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
                      _isEmailSignup
                          ? "What's your email address?"
                          : "What's your mobile number?",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Gap(2),
                    Text(
                      "Enter the ${_isEmailSignup ? "e-mail address" : "mobile number"} where you can be contacted. No one will see this on your profile.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Gap(15),
                    SizedBox(
                      child:
                          _isEmailSignup
                              ? CustomTextField(
                                labelText: "E-mail",
                                controller:
                                    emailController, // Use an email-specific controller
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "E-mail is required";
                                  } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                  ).hasMatch(value.trim())) {
                                    return "Enter a valid e-mail address";
                                  }
                                  return null;
                                },
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => Theme(
                                              data: Theme.of(context).copyWith(
                                                dialogTheme: DialogThemeData(
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                              child: CountryPickerDialog(
                                                searchCursorColor:
                                                    kPrimaryColor,
                                                title: Text(""),
                                                isSearchable: true,
                                                onValuePicked: (
                                                  Country country,
                                                ) {
                                                  setState(() {
                                                    _selectedCountry = country;
                                                  });
                                                },
                                                itemBuilder:
                                                    (Country country) => Row(
                                                      children: [
                                                        CountryPickerUtils.getDefaultFlagImage(
                                                          country,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          "${country.name} (+${country.phoneCode})",
                                                          style: TextStyle(
                                                            fontSize:
                                                                mediumsmallSize,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              ),
                                            ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: greyBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          radiusbox,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CountryPickerUtils.getDefaultFlagImage(
                                            _selectedCountry,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "+${_selectedCountry.phoneCode}",
                                          ),
                                          Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      labelText: "Mobile number",
                                      controller: mobilenoController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Mobile number is required";
                                        } else if (value.trim().length != 10) {
                                          return "Mobile number must be 10 digits";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                    ),

                    Text(
                      "You may receive SMS notifications from us.",
                      style: TextStyle(
                        color: textGrayColor,
                        fontSize: smallSize,
                      ),
                    ),

                    if (widget.forgotpass == false) ...[
                      Gap(6),
                      CustomTextField(
                        labelText: "Create a password",
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
                    ],

                    Gap(15),
                    BlocConsumer<
                      SignupregistrationBloc,
                      SignupregistrationState
                    >(
                      buildWhen: (old, next) => old != next,
                      listener: (context, state) {
                        if (state is SignupregistrationLoading) {
                        } else if (state is SignupregistrationLoaded) {
                          if (state.model.status == "failed") {
                            showGlobalSnackBar(
                              message: state.model.msg.toString(),
                            );
                          } else {
                            Navigator.of(context).pushNamed(
                              "/signupconfirmation",
                              arguments: {
                                "user_id": state.model.data!.userId,
                                "contact_details":
                                    _isEmailSignup
                                        ? emailController.text
                                        : mobilenoController.text,
                                "type": 'user_verify',
                              },
                            );
                          }
                        } else if (state is SignupregistrationError) {
                          showGlobalSnackBar(message: state.error);
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          text: "Next",
                          onPressed: () {
                            if (widget.forgotpass == false) {
                              validationFun(
                                context: context,
                                formKey: _formKey,
                                emailController: emailController,
                                mobilenoController: mobilenoController,
                                passwordController: passwordController,
                              );
                            } else {
                              MainService()
                                  .forgotpasswordService(
                                    username:
                                        _isEmailSignup
                                            ? emailController.text
                                            : mobilenoController.text,
                                  )
                                  .then((value) {
                                    if (value.status == "success") {
                                      showGlobalSnackBar(
                                        message: value.message,
                                      );
                                      Navigator.of(context).pushNamed(
                                        "/forgotpassword",
                                        arguments: {
                                          "contact_details":
                                              _isEmailSignup
                                                  ? emailController.text
                                                  : mobilenoController.text,
                                          "user_id": value.data!.userId,
                                        },
                                      );
                                    } else {
                                      showGlobalSnackBar(
                                        message: value.message,
                                      );
                                    }
                                  });
                            }
                          },
                        );
                      },
                    ),
                    Gap(5),
                    CustomButton(
                      text:
                          _isEmailSignup
                              ? widget.forgotpass
                                  ? "Mobile number"
                                  : "Sign up with mobile number"
                              : widget.forgotpass
                              ? "Email"
                              : "Sign up with email",
                      isOutlined: true,
                      onPressed: () {
                        setState(() {
                          _isEmailSignup = !_isEmailSignup;
                        });
                        context.read<SignupBloc>().add(
                          UpdateType(type = _isEmailSignup ? "email" : "phone"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Bottomlogin(),
      ),
    );
  }
}
