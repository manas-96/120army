import '../../exports.dart';
import '../../global.dart';
import '../../statemanagment/challenges/challenges_bloc.dart';
import '../../statemanagment/profillecoverchange/profillecoverchange_bloc.dart';
import '../../statemanagment/rewardslevel/rewardslevel_bloc.dart';
import '../model/other_profile_model.dart';
import '../services/main_service.dart';
import '../statemanagment/otherprofile/otherprofile_bloc.dart';

import '../statemanagment/photolist/photolist_bloc.dart';
import 'others/otherphotolist.dart';
import 'others/otherpostlist.dart';
import 'widget/border.dart';
import 'widget/cached_image.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/screenwidget/badge_widget.dart';
import 'widget/screenwidget/reward_levels_widget.dart';
import 'widget/toast.dart';

class Otherprofile extends StatefulWidget {
  const Otherprofile({super.key, required this.userID,});

  final String userID;


  @override
  State<Otherprofile> createState() => _OtherprofileState();
}

class _OtherprofileState extends State<Otherprofile> {
  int selectedIndex = 0;
  List subProfile = ['Posts', 'Badge', 'Photos', 'Levels', 'Videos'];

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _appBarOpacity = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<RewardslevelBloc>().add(
      RewardslevelEventTrigger(userId: widget.userID),
    );
    context.read<ChallengesBloc>().add(
      ChallengesTrigger(userId: widget.userID),
    );
    context.read<ProfillecoverchangeBloc>().add(LoadProfileCoverEvent());
    // ====================================================================
    context.read<OtherprofileBloc>().add(
      OtherprofileTrigger(userId: widget.userID),
    );
    context.read<PhotolistBloc>().add(PhotolistTrigger(userId: widget.userID));
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    double maxOffset = 150;
    double newOpacity = (offset / maxOffset).clamp(0.0, 1.0);

    if (_appBarOpacity.value != newOpacity) {
      _appBarOpacity.value = newOpacity;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create:
          (_) =>
              OtherprofileBloc()
                ..add(OtherprofileTrigger(userId: widget.userID)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ValueListenableBuilder<double>(
            valueListenable: _appBarOpacity,
            builder: (context, opacity, child) {
              return AppBar(
                // elevation: 0,
                backgroundColor: Colors.white.withValues(alpha: opacity),
                scrolledUnderElevation: 0,
                iconTheme: IconThemeData(color: kPrimaryColor),
                // title: Opacity(
                //   opacity: opacity,
                //   child: Text(
                //     "My profile",
                //     style: TextStyle(color: kPrimaryColor, fontSize: appbarTitle),
                //   ),
                // ),
              );
            },
          ),
        ),
        body: BlocBuilder<OtherprofileBloc, OtherprofileState>(
          builder: (context, state) {
            if (state is OtherprofileLoading) {
              return Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              );
            } else if (state is OtherprofileLoaded) {
              ProfileData? profileData = state.model.profileData!;
              List<PostDatum>? postData = state.model.postData;
              return SizedBox(
                width: size.width,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: SizedBox(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: size.width,
                              height: 260,
                              child: MyImageWidget(
                                imageUrl: profileData.coverImage!,
                                coverStatus: true,
                                radius: false,
                                radiusVal: 0,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: -77,
                              child: Center(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: circularAvatarGradient,
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 140,
                                          height: 140,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors
                                                    .white, // optional background behind image
                                          ),
                                          child: ClipOval(
                                            child: MyImageWidget(
                                              imageUrl:
                                                  profileData.profileImage!,
                                              profileStatus: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Positioned(
                                    //   right: 5,
                                    //   bottom: 5,
                                    //   child: SvgPicture.asset(
                                    //     "assets/icons/verify.svg",
                                    //     width: 40,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(80),
                        Column(
                          spacing: 10,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                              ),
                              child: Column(
                                spacing: 8,
                                children: [
                                  Gap(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        spacing: 5,
                                        children: [
                                          Text(
                                            '${profileData.firstName} ${profileData.lastName}',
                                          ),
                                          // FullNameWidget(
                                          //   style:
                                          //       Theme.of(
                                          //         context,
                                          //       ).textTheme.displayMedium,
                                          // ),

                                          // Icon(
                                          //   Icons.share,
                                          //   color: kPrimaryColor,
                                          //   size: 22,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   "3.4K Friends",
                                  //   style: Theme.of(context).textTheme.displaySmall,
                                  // ),
                                  if (profileData.bio != "") ...[
                                    Column(
                                      children: [
                                        Text(
                                          profileData.bio!,
                                          textAlign: TextAlign.center,
                                        ),
                                        Gap(8),
                                      ],
                                    ),
                                  ],

                                  if (profileData.friendStatus!.status ==
                                      "active_friend") ...[
                                    SizedBox(
                                      width: 140,
                                      height: 45,
                                      child: CustomButton(
                                        verticalPadding: 0,
                                        text: "Friend",
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],

                                  if (profileData.friendStatus!.status ==
                                      "requested") ...[
                                    SizedBox(
                                      width: 150,
                                      height: 45,
                                      child: CustomButton(
                                        verticalPadding: 0,
                                        text: "Cancel Request",
                                        onPressed: () async {
                                          try {
                                            final value = await MainService()
                                                .cancelfriendService(
                                                  friend_id: widget.userID,
                                                );
                                            if (value != null &&
                                                value.status == "success") {
                                              showGlobalSnackBar(
                                                message: value.msg,
                                              );

                                              // 🔹 Update UI to show "Request sent"
                                              setState(() {
                                                profileData
                                                    .friendStatus!
                                                    .status = "";
                                              });
                                            } else {
                                              showGlobalSnackBar(
                                                message:
                                                    value?.msg ??
                                                    "Something went wrong.",
                                              );
                                            }
                                          } catch (e) {
                                            showGlobalSnackBar(
                                              message: "Error: ${e.toString()}",
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],

                                  if (profileData.friendStatus!.status ==
                                      "") ...[
                                    SizedBox(
                                      width: 140,
                                      height: 45,
                                      child: CustomButton(
                                        verticalPadding: 0,
                                        text: "Connect",
                                        onPressed: () async {
                                          try {
                                            final value = await MainService()
                                                .addfriendService(
                                                  friend_id: widget.userID,
                                                );
                                            if (value != null &&
                                                value.status == "success") {
                                              showGlobalSnackBar(
                                                message: value.msg,
                                              );

                                              // 🔹 Update UI to show "Request sent"
                                              setState(() {
                                                profileData
                                                    .friendStatus!
                                                    .status = "requested";
                                              });
                                            } else {
                                              showGlobalSnackBar(
                                                message:
                                                    value?.msg ??
                                                    "Something went wrong.",
                                              );
                                            }
                                          } catch (e) {
                                            showGlobalSnackBar(
                                              message: "Error: ${e.toString()}",
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Friendslistwidget(),
                            Gap(2),
                            Borderdevider(
                              borderWidth: 4,
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                            ),
                            Gap(2),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kDefaultPadding,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  spacing: 8,
                                  children: List.generate(subProfile.length, (
                                    index,
                                  ) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right:
                                              index == subProfile.length - 1
                                                  ? kDefaultPadding
                                                  : 0,
                                        ),

                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              index == selectedIndex
                                                  ? kLightPrimaryColor
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        child: Text(
                                          subProfile[index],
                                          style: TextStyle(
                                            fontSize: formLabelFontSize,
                                            color:
                                                selectedIndex == index
                                                    ? kPrimaryColor
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),

                            Borderdevider(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                            ),
                          ],
                        ),

                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: getSelectedWidget(selectedIndex, postData),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget getSelectedWidget(int index, postData) {
    switch (index) {
      case 0:
        return OthersPostswidget(postData: postData);
      case 1:
        return Badgewidget(own: false);
      case 2:
        return OtherPhotoswidgets();
      case 3:
        return const Levelwidget(own: false);
      case 4:
        return Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Text("No data found"), // Placeholder
        );
      default:
        return SizedBox.shrink();
    }
  }
}
