import '../../exports.dart';
import '../../global.dart';
import '../../model/other_profile_model.dart';
import '../../statemanagment/challenges/challenges_bloc.dart';
import '../../statemanagment/otherprofile/otherprofile_bloc.dart';
import '../../statemanagment/photolist/photolist_bloc.dart';
import '../../statemanagment/profillecoverchange/profillecoverchange_bloc.dart';
import '../../statemanagment/rewardslevel/rewardslevel_bloc.dart';
import '../others/otherphotolist.dart';
import '../others/otherpostlist.dart';
import '../widget/border.dart';
import '../widget/custom_elevated_button.dart';
import '../widget/friendslistwidget.dart';
import '../widget/screenwidget/badge_widget.dart';
import '../widget/screenwidget/fullname_widget.dart';
import '../widget/screenwidget/profilepic_widget.dart';
import '../widget/screenwidget/reward_levels_widget.dart';

class Profiletab extends StatefulWidget {
  const Profiletab({super.key});

  @override
  State<Profiletab> createState() => _ProfiletabState();
}

class _ProfiletabState extends State<Profiletab> {
  int selectedIndex = 0;
  List subProfile = ['Posts', 'Badge', 'Photos', 'Levels', 'Videos'];

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _appBarOpacity = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    context.read<RewardslevelBloc>().add(RewardslevelEventTrigger());
    context.read<ChallengesBloc>().add(ChallengesTrigger());
    context.read<ProfillecoverchangeBloc>().add(LoadProfileCoverEvent());
    context.read<PhotolistBloc>().add(PhotolistTrigger());
    context.read<OtherprofileBloc>().add(OtherprofileTrigger());

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
    return Scaffold(
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
              title: Opacity(
                opacity: opacity,
                child: Text(
                  "My profile",
                  style: TextStyle(color: kPrimaryColor, fontSize: appbarTitle),
                ),
              ),
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
                            child: CoverImageWidget(),
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
                                          child: ProfileImageWidget(size: 140),
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
                                        FullNameWidget(
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.displayMedium,
                                        ),

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
                                // Text(
                                //   "The words of Jesus Christ are life changing and timeless. When Jesus spoke, lives were transformed and the trajectory of life forever altered.",
                                //   textAlign: TextAlign.center,
                                // ),
                                BioWidget(
                                  style:
                                  Theme.of(
                                    context,
                                  ).textTheme.displayMedium,
                                ),
                                Gap(8),
                                Row(
                                  spacing: 15,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      height: 45,
                                      child: CustomButton(
                                        verticalPadding: 0,
                                        text: "Edit profile",
                                        icon: Icons.edit,
                                        iconSize: 24,
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pushNamed("/editprofile");
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      height: 45,
                                      child: CustomButton(
                                        verticalPadding: 0,
                                        text: "Settings",
                                        icon: Icons.settings,
                                        iconSize: 26,
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pushNamed("/setting");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Friendslistwidget(),

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
                                        borderRadius: BorderRadius.circular(20),
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
          } else if (state is OtherprofileError) {
            return Center(child: Text(state.error));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget getSelectedWidget(int index, postData) {
    switch (index) {
      case 0:
        return OthersPostswidget(postData: postData);
      case 1:
        return const Badgewidget();
      case 2:
        // return Photoswidgets(photoslist: photoslist);
        return OtherPhotoswidgets();
      case 3:
        return const Levelwidget();
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

class Photoswidgets extends StatelessWidget {
  const Photoswidgets({super.key, required this.photoslist});

  final List<String> photoslist;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(kDefaultPadding),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      itemCount: photoslist.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(photoslist[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
