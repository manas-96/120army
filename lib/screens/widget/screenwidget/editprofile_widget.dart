import 'package:intl/intl.dart';
import '../../../exports.dart';
import '../../../global.dart';
import '../../../model/profile_model.dart';
import '../../../services/main_service.dart';
import '../../../shared_pref.dart';
import '../../../statemanagment/profile/profile_bloc.dart';
import '../../../statemanagment/profiledatashare/profiledatashare_bloc.dart';
import '../../../statemanagment/profillecoverchange/profillecoverchange_bloc.dart';
import '../border.dart';
import '../cached_image.dart';
import '../toast.dart';

class Editprofilewidget extends StatefulWidget {
  const Editprofilewidget({super.key});

  @override
  State<Editprofilewidget> createState() => _EditprofilewidgetState();
}

class _EditprofilewidgetState extends State<Editprofilewidget> {
  File? _coverImage;
  File? _profileImage;
  bool _isCoverImageRemoved = false;
  bool _isProfileImageRemoved = false;

  Future<void> _pickImage(ImageSource source, bool isCover) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio:
            isCover
                ? CropAspectRatio(ratioX: 3.0, ratioY: 2.0)
                : CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        uiSettings: [
          AndroidUiSettings(
            cropFrameStrokeWidth: 0,
            cropFrameColor: Colors.transparent,
            showCropGrid: false,
            toolbarTitle: isCover ? "Cover photo" : "Profile photo",
            cropStyle: isCover ? CropStyle.rectangle : CropStyle.circle,
          ),
          IOSUiSettings(
            title: isCover ? "Cover photo" : "Profile photo",
            cropStyle: isCover ? CropStyle.rectangle : CropStyle.circle,
          ),
        ],
      );

      if (croppedFile != null) {
        final imageFile = File(croppedFile.path);

        setState(() {
          if (isCover) {
            _coverImage = imageFile;
            _isCoverImageRemoved = false;
          } else {
            _profileImage = imageFile;
            _isProfileImageRemoved = false;
          }
        });

        imageFun(formnum: isCover ? 1 : 2, image: imageFile.path);
      }
    }
  }

  void imageFun({required int formnum, required String image}) {
    MainService().profileupdateService(formnum: formnum, image: image).then((
      value,
    ) {
      SharedPrefUtils.saveStr("profilepic", value!.data.profileImage);
      SharedPrefUtils.saveStr("coverpic", value.data.coverImage);
      context.read<ProfillecoverchangeBloc>().add(
        UpdateProfilePicEvent(value.data.profileImage),
      );
      context.read<ProfillecoverchangeBloc>().add(
        UpdateCoverPicEvent(value.data.coverImage),
      );

      showGlobalSnackBar(message: value.msg);
      context.read<ProfileBloc>().add(ProfileLoadedEventnonload());
    });
  }

  void removeImg(bool isCover) {
    if (isCover == true) {
      imageFun(formnum: 1, image: '');
      setState(() {
        _coverImage = null;
        _isCoverImageRemoved = true;
      });
    } else {
      imageFun(formnum: 2, image: '');
      setState(() {
        _profileImage = null;
        _isProfileImageRemoved = true;
      });
    }
  }

  void _showPickerOptions(bool isCover) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder:
          (_) => SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                top: kDefaultPadding,
              ),
              child: Column(
                children: [
                  Text(
                    isCover == true ? "Cover photo" : "Profile photo",
                    style: TextStyle(fontSize: titlesize),
                  ),
                  Gap(25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera, isCover);
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Text('Camera'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery, isCover);
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Text('Gallery'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          removeImg(isCover);
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.delete,
                                  size: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Text('Remove'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ProfiledatashareBloc, ProfiledatashareState>(
      builder: (context, state) {
        if (state is ProfiledatashareLoaded) {
          Profiledata finalData = state.model;
          return Column(
            spacing: 12,
            children: [
              Column(
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cover photo",
                        style: TextStyle(
                          fontSize: titlesize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showPickerOptions(true),
                        child: SvgPicture.asset(
                          "assets/icons/edit.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showPickerOptions(true),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: size.width,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLightPrimaryColor,
                      ),

                      child:
                          !_isCoverImageRemoved
                              ? (_coverImage != null
                                  ? Image.file(_coverImage!, fit: BoxFit.cover)
                                  : finalData.coverImage != ""
                                  ? MyImageWidget(
                                    imageUrl: finalData.coverImage,
                                  )
                                  : SizedBox.shrink())
                              : SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
              Borderdevider(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
              ),
              Column(
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile picture",
                        style: TextStyle(
                          fontSize: titlesize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showPickerOptions(false),
                        child: SvgPicture.asset(
                          "assets/icons/edit.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showPickerOptions(false),
                    child: Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kLightPrimaryColor,
                      ),
                      child:
                          !_isProfileImageRemoved
                              ? (_profileImage != null
                                  ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                  )
                                  : finalData.profileImage != ""
                                  ? MyImageWidget(
                                    imageUrl: finalData.profileImage,
                                  )
                                  : Image.asset("assets/images/user.png"))
                              : Image.asset("assets/images/user.png"),
                    ),
                  ),
                ],
              ),
              Borderdevider(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          fontSize: titlesize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pushNamed(
                              "/editprofileform",
                              arguments: {'formnum': 3},
                            ),
                        child: SvgPicture.asset(
                          "assets/icons/edit.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(finalData.bio),
                ],
              ),
              Borderdevider(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
              ),
              Column(
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Full name",
                        style: TextStyle(
                          fontSize: titlesize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pushNamed(
                              "/editprofileform",
                              arguments: {'formnum': 4},
                            ),
                        child: SvgPicture.asset(
                          "assets/icons/edit.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Circleicon(icon: false),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                finalData.firstName,
                                style: TextStyle(fontSize: paraFont),
                              ),
                              Text(
                                "First name",
                                style: TextStyle(
                                  fontSize: smallSize,
                                  color: textGrayColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Circleicon(icon: false),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                finalData.lastName,
                                style: TextStyle(fontSize: paraFont),
                              ),
                              Text(
                                "Last name",
                                style: TextStyle(
                                  fontSize: smallSize,
                                  color: textGrayColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Borderdevider(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
              ),
              Column(
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Basic info",
                        style: TextStyle(
                          fontSize: titlesize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pushNamed(
                              "/editprofileform",
                              arguments: {'formnum': 5},
                            ),
                        child: SvgPicture.asset(
                          "assets/icons/edit.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    spacing: 10,
                    children: [
                      Column(
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Circleicon(iconpath: "assets/icons/user.svg"),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    finalData.gender,
                                    style: TextStyle(fontSize: paraFont),
                                  ),
                                  Text(
                                    "Gender",
                                    style: TextStyle(
                                      fontSize: smallSize,
                                      color: textGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Circleicon(
                                iconpath: "assets/icons/birthday-cake.svg",
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat(
                                      'MM-dd-yyyy',
                                    ).format(finalData.dateOfBirth),
                                    style: TextStyle(fontSize: paraFont),
                                  ),
                                  Text(
                                    "Birthday",
                                    style: TextStyle(
                                      fontSize: smallSize,
                                      color: textGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Circleicon(
                                iconpath: "assets/icons/chat_fill.svg",
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    finalData.language,
                                    style: TextStyle(fontSize: paraFont),
                                  ),
                                  Text(
                                    "Languages",
                                    style: TextStyle(
                                      fontSize: smallSize,
                                      color: textGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Borderdevider(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
              ),
              Column(
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Places lived",
                        style: TextStyle(
                          fontSize: titlesize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pushNamed(
                              "/editprofileform",
                              arguments: {'formnum': 6},
                            ),
                        child: SvgPicture.asset(
                          "assets/icons/edit.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Circleicon(iconpath: "assets/icons/location-pin.svg"),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  finalData.placesLived,
                                  style: TextStyle(fontSize: paraFont),
                                ),
                                Text(
                                  "Current city",
                                  style: TextStyle(
                                    fontSize: smallSize,
                                    color: textGrayColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Borderdevider(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
              ),
              Column(
                spacing: 15,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contact info",
                        style: TextStyle(
                          fontSize: titlesize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.of(context).pushNamed(
                              "/editprofileform",
                              arguments: {'formnum': 7},
                            ),
                        child: SvgPicture.asset(
                          "assets/icons/edit.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            kPrimaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),

                  FutureBuilder<String?>(
                    future: SharedPrefUtils.readPrefStr(
                      "emailLogin",
                    ).then((value) => value as String?),
                    builder: (context, snapshot) {
                      String flag = snapshot.data ?? "0"; // default to mobile
                      return Column(
                        spacing: 10,
                        children: [
                          if (flag == "0") // Mobile
                            Row(
                              spacing: 10,
                              children: [
                                Circleicon(
                                  iconpath: "assets/icons/phone-call.svg",
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      finalData.phoneNo.toString(),
                                      style: TextStyle(fontSize: paraFont),
                                    ),
                                    Text(
                                      "Mobile",
                                      style: TextStyle(
                                        fontSize: smallSize,
                                        color: textGrayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else // Email
                            Row(
                              spacing: 10,
                              children: [
                                Circleicon(iconpath: "assets/icons/arroba.svg"),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      finalData.email,
                                      style: TextStyle(fontSize: paraFont),
                                    ),
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: smallSize,
                                        color: textGrayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        } else {
          return Text("Something went wrong");
        }
      },
    );
  }
}

class Circleicon extends StatelessWidget {
  final bool icon;
  final String iconpath;
  const Circleicon({super.key, this.icon = true, this.iconpath = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: kLightPrimaryColor,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Center(
        child:
            icon == true
                ? SvgPicture.asset(
                  iconpath,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
                )
                : Text(
                  "Aa",
                  style: TextStyle(
                    fontSize: paraFont,
                    fontWeight: FontWeight.w700,
                  ),
                ),
      ),
    );
  }
}
