import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../exports.dart';
import '../global.dart';
import '../main.dart';
import '../model/profile_model.dart';
import '../shared_pref.dart';
import '../statemanagment/profile/profile_bloc.dart';
import '../statemanagment/profiledatashare/profiledatashare_bloc.dart';
import '../statemanagment/profileupdate/profileupdate_bloc.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/custom_text_field.dart';
import 'widget/toast.dart';

class Editprofileform extends StatefulWidget {
  // final Profiledata user_data;
  final int formnum;
  const Editprofileform({
    super.key,
    required this.formnum,
    // required this.user_data,
  });

  @override
  State<Editprofileform> createState() => _EditprofileformState();
}

class _EditprofileformState extends State<Editprofileform> {
  String? gender;
  final TextEditingController bioController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController currentcityController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  DateTime selectedDate = DateTime.now().subtract(Duration(days: 365 * 5));
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfiledatashareBloc>().state;
    if (state is ProfiledatashareLoaded) {
      Profiledata finalData = state.model;
      bioController.text = finalData.bio == "N/A" ? "" : finalData.bio;
      firstnameController.text =
          finalData.firstName == "N/A" ? "" : finalData.firstName;
      lastnameController.text =
          finalData.lastName == "N/A" ? "" : finalData.lastName;
      birthdayController.text = DateFormat(
        'MM-dd-yyyy',
      ).format(finalData.dateOfBirth);

      selectedDate = finalData.dateOfBirth;

      languageController.text =
          finalData.language == "N/A" ? "" : finalData.language;
      currentcityController.text =
          finalData.placesLived == "N/A" ? "" : finalData.placesLived;
      mobileController.text =
          finalData.phoneNo.toString() == "N/A"
              ? ""
              : finalData.phoneNo.toString();
      emailController.text = finalData.email == "N/A" ? "" : finalData.email;
      gender = finalData.gender == "male" ? "Male" : "Female";
    }
  }

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
            initialDateTime: selectedDate,
            maximumDate: DateTime.now().subtract(Duration(days: 365 * 5)),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
                birthdayController.text =
                    "${newDate.month.toString()}-${newDate.day.toString().padLeft(2, '0')}-${newDate.year.toString().padLeft(2, '0')}";
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileupdateBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                "Edit profile",
                style: TextStyle(fontSize: appbarTitle, color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: 20,
                        children: [
                          if (widget.formnum == 3) ...[
                            CustomTextField(
                              labelText: "Bio",
                              controller: bioController,
                              maxLines: 3,
                            ),
                          ] else if (widget.formnum == 4) ...[
                            Column(
                              spacing: 20,
                              children: [
                                CustomTextField(
                                  labelText: "First name",
                                  controller: firstnameController,
                                ),
                                CustomTextField(
                                  labelText: "Last name",
                                  controller: lastnameController,
                                ),
                              ],
                            ),
                          ] else if (widget.formnum == 5) ...[
                            Column(
                              spacing: 20,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(kDefaultPadding),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: greyBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      radiusbox,
                                    ),
                                  ),
                                  child: Column(
                                    spacing: 15,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gender = "Female";
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Female",
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                            ),
                                            Transform.scale(
                                              scale:
                                                  1.2, // Increase radio button size
                                              child: Radio<String>(
                                                value: "Female",
                                                groupValue: gender,
                                                onChanged: (value) {
                                                  setState(() {
                                                    gender = value;
                                                  });
                                                },
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gender = "Male";
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Male",
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                            ),
                                            Transform.scale(
                                              scale:
                                                  1.2, // Increase radio button size
                                              child: Radio<String>(
                                                value: "Male",
                                                groupValue: gender,
                                                onChanged: (value) {
                                                  setState(() {
                                                    gender = value;
                                                  });
                                                },
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _showDatePicker(context),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: CustomTextField(
                                      labelText: "Your birthday",
                                      controller: birthdayController,
                                    ),
                                  ),
                                ),
                                CustomTextField(
                                  labelText: "Language",
                                  controller: languageController,
                                ),
                              ],
                            ),
                          ] else if (widget.formnum == 6) ...[
                            CustomTextField(
                              labelText: "Current city",
                              controller: currentcityController,
                            ),
                          ] else if (widget.formnum == 7) ...[
                            FutureBuilder<String?>(
                              future: SharedPrefUtils.readPrefStr(
                                "emailLogin",
                              ).then((value) => value as String?),
                              builder: (context, snapshot) {
                                String flag = snapshot.data ?? "0";
                                return Column(
                                  spacing: 20,
                                  children: [
                                    flag == "0"
                                        ? CustomTextField(
                                          labelText: "Mobile",
                                          controller: mobileController,
                                        )
                                        : CustomTextField(
                                          labelText: "E-mail",
                                          controller: emailController,
                                        ),
                                  ],
                                );
                              },
                            ),
                          ],
                          CustomButton(
                            text: "Update",
                            onPressed: () {
                              if (widget.formnum == 3 &&
                                  bioController.text.trim().isEmpty) {
                                showGlobalSnackBar(
                                    message: "Bio cannot be empty");
                                return;
                              }
                              if (widget.formnum == 6 &&
                                  currentcityController.text.trim().isEmpty) {
                                showGlobalSnackBar(
                                    message: "Current city cannot be empty");
                                return;
                              }
                              context.read<ProfileupdateBloc>().add(
                                SubmitProfileUpdateevent(
                                  formnum: widget.formnum,
                                  firstName: firstnameController.text,
                                  lastName: lastnameController.text,
                                  bio: bioController.text,
                                  phoneNo: mobileController.text,
                                  email: emailController.text,
                                  gender: gender ?? '',
                                  dateOfBirth: birthdayController.text,
                                  language: languageController.text,
                                  placesLived: currentcityController.text,
                                ),
                              );
                            },
                          ),
                          BlocListener<ProfileupdateBloc, ProfileupdateState>(
                            listener: (context, state) {
                              context.read<ProfileBloc>().add(
                                ProfileLoadedEvent(),
                              );

                              if (state is ProfileUpdateSuccess) {
                                if (state.model.status == "failed") {
                                  showGlobalSnackBar(
                                    message: state.model.msg.toString(),
                                  );
                                } else {
                                  context.read<ProfileBloc>().add(
                                    ProfileLoadedEvent(),
                                  );
                                  showGlobalSnackBar(
                                    message: state.model.msg.toString(),
                                  );

                                  SharedPrefUtils.saveStr(
                                    "fullname",
                                    '${firstnameController.text.trim()} ${lastnameController.text.trim()}'
                                        .trim(),
                                  );

                                  Future.delayed(Duration(seconds: 2), () {
                                    navigatorKey.currentState
                                        ?.pushNamedAndRemoveUntil(
                                          '/home',
                                          (route) =>
                                              false, // Clears all previous routes
                                        );

                                    // Then push profile on top of home
                                    Future.delayed(
                                      Duration(milliseconds: 1),
                                      () {
                                        navigatorKey.currentState?.pushNamed(
                                          '/profile',
                                        );
                                      },
                                    );
                                  });
                                }
                              } else if (state is ProfileUpdateFailure) {
                                showGlobalSnackBar(
                                  message: state.error.toString(),
                                );
                              }
                            },
                            child: SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
