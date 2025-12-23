import 'package:flutter/gestures.dart';

import '../exports.dart';
import '../global.dart';
import '../services/pusher.dart';
import '../shared_pref.dart';
import '../statemanagment/login/login_bloc.dart';
import '../statemanagment/profillecoverchange/profillecoverchange_bloc.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';
import 'dart:math';

import 'widget/toast.dart';

class Login extends StatefulWidget {
  final bool animationEnabled;
  const Login({super.key, this.animationEnabled = true});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  DateTime? ctime;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _controller;
  bool togglePassword = false;
  bool isKeyboardOpen = false;
  bool moveLogo = false;
  bool showContent = false;
  bool moveLogotwo = false;
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (widget.animationEnabled) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..repeat();

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            moveLogo = true;
            showContent = true;
          });
        }
      });

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            moveLogotwo = true;
          });
        }
      });
    } else {
      moveLogo = true;
      moveLogotwo = true;
      showContent = true;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (widget.animationEnabled) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    setState(() {
      isKeyboardOpen = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            DateTime now = DateTime.now();
            if (ctime == null ||
                now.difference(ctime!) > const Duration(seconds: 2)) {
              ctime = now;
              showGlobalSnackBar(message: "Press Back Button Again to Exit");
            } else {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          },
          child: SafeArea(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(kDefaultPadding),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: max(moveLogo ? 65 : size.height / 2 - 40, 0),
                      ),
                      AnimatedOpacity(
                        opacity: moveLogotwo ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 400),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (widget.animationEnabled)
                              AnimatedOpacity(
                                opacity: moveLogo ? 0.0 : 1.0,
                                duration: Duration(milliseconds: 400),
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      size: const Size(100, 100),
                                      painter: ArcPainter(_controller.value),
                                    );
                                  },
                                ),
                              ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(45),
                      AnimatedOpacity(
                        opacity: showContent ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 400),
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: _formKey,
                          child: Column(
                            spacing: 15,
                            children: [
                              CustomTextField(
                                labelText: "Mobile number or email",
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Mobile number or email is required";
                                  }
                                  String input = value.trim();
                                  bool startsWithDigit = RegExp(
                                    r'^\d',
                                  ).hasMatch(input);

                                  if (startsWithDigit) {
                                    if (value.trim().length != 10) {
                                      return "Mobile number must be 10 digits";
                                    }
                                  } else {
                                    final emailRegex = RegExp(
                                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                    );
                                    if (!emailRegex.hasMatch(input)) {
                                      return "Enter a valid email address";
                                    }
                                  }
                                  return null;
                                },
                              ),
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
                              BlocConsumer<LoginBloc, LoginState>(
                                listener: (context, state) {
                                  if (state is LoginLoading) {
                                  } else if (state is LoginLoaded) {
                                    if (state.model.status == "failed") {
                                      showGlobalSnackBar(
                                        message: state.model.msg.toString(),
                                      );
                                    } else {
                                      if (state.model.data!.isVerified == 1) {
                                        if (state.model.data!.email == "") {
                                          SharedPrefUtils.saveStr(
                                            "emailLogin",
                                            "0".toString(),
                                          );
                                        } else {
                                          SharedPrefUtils.saveStr(
                                            "emailLogin",
                                            "1".toString(),
                                          );
                                        }

                                        SharedPrefUtils.saveStr(
                                          "accessToken",
                                          state.model.data!.accessToken
                                              .toString(),
                                        );
                                        SharedPrefUtils.saveStr(
                                          "refreshToken",
                                          state.model.data!.refreshToken
                                              .toString(),
                                        );
                                        SharedPrefUtils.saveStr(
                                          "profilepic",
                                          state.model.data!.profileImage
                                              .toString(),
                                        );
                                        SharedPrefUtils.saveStr(
                                          "coverpic",
                                          state.model.data!.coverImage
                                              .toString(),
                                        );
                                        SharedPrefUtils.saveStr(
                                          "fullname",
                                          state.model.data!.name.toString(),
                                        );
                                        SharedPrefUtils.saveStr(
                                          "user_id",
                                          state.model.data!.userId.toString(),
                                        );
                                        SharedPrefUtils.saveStr(
                                          "is_official",
                                          state.model.data!.isOfficial
                                              .toString(),
                                        );

                                        PusherService.instance.initPusher(
                                          userId: state.model.data!.userId,
                                        );

                                        context
                                            .read<ProfillecoverchangeBloc>()
                                            .add(LoadProfileCoverEvent());
                                        Navigator.of(
                                          context,
                                        ).pushReplacementNamed("/home");
                                      } else if (state.model.data!.isVerified ==
                                          0) {
                                        showGlobalSnackBar(
                                          message:
                                              "Kindly verify your account first.",
                                        );

                                        Navigator.of(context).pushNamed(
                                          "/signupconfirmation",
                                          arguments: {
                                            "user_id": state.model.data!.userId,
                                            "contact_details":
                                                emailController.text,
                                            "type": 'user_verify',
                                            "resendOtp": true,
                                          },
                                        );

                                        // Navigator.of(
                                        //   context,
                                        // ).pushNamed("/signupmobileno");
                                      }
                                    }
                                  } else if (state is LoginError) {
                                    showGlobalSnackBar(
                                      message: state.error.toString(),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return CustomButton(
                                    text: "Log in",
                                    onPressed: () async {
                                      String? token =
                                          await FirebaseMessaging.instance
                                              .getToken();

                                      print(token);

                                      if (_formKey.currentState!.validate()) {
                                        if (!_isChecked) {
                                          showGlobalSnackBar(
                                            message:
                                                "Please accept the Terms and Conditions to proceed.",
                                          );
                                          return;
                                        }
                                        context.read<LoginBloc>().add(
                                          LoginEventTrigger(
                                            username: emailController.text,
                                            password: passwordController.text,
                                            device_token: token!,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    "/signupmobileno",
                                    arguments: {"forgotpass": true},
                                  );
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    visualDensity: VisualDensity(
                                      horizontal: -4,
                                    ),
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: "Please accept the ",
                                            style: TextStyle(
                                              fontSize: smallSize,
                                            ),
                                          ),

                                          TextSpan(
                                            text: "Terms and Conditions ",
                                            style: TextStyle(
                                              fontSize: smallSize,
                                              color: kPrimaryColor,
                                            ),
                                            recognizer:
                                                TapGestureRecognizer()
                                                  ..onTap = () {
                                                    Navigator.of(
                                                      context,
                                                    ).pushNamed(
                                                      "/termsandconditions",
                                                    );
                                                  },
                                          ),
                                          TextSpan(
                                            text: "to proceed.",
                                            style: TextStyle(
                                              fontSize: smallSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: AnimatedOpacity(
          opacity: showContent ? 1.0 : 0.0,
          duration: Duration(milliseconds: 400),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: CustomButton(
              text: "Create new account",
              isOutlined: true,
              onPressed: () {
                Navigator.of(context).pushNamed("/intro");
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  ArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = kPrimaryColor
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final double startAngle1 = progress * 2 * pi;
    final double startAngle2 = (progress * 2 * pi) + pi;
    final double sweepAngle = pi / 3;

    canvas.drawArc(rect, startAngle1, sweepAngle, false, paint);
    canvas.drawArc(rect, startAngle2, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
