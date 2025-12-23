import 'package:flutter/rendering.dart';
import '../../exports.dart';
import '../../global.dart';
import '../../globalprogress.dart';
import '../../platform_utils.dart';
import '../../statemanagment/homewalllist/homewalllist_bloc.dart';
import '../widget/screenwidget/wall_list.dart';
import '../widget/toast.dart';

class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> with AutomaticKeepAliveClientMixin {
  final ValueNotifier<bool> _isBottomBarVisible = ValueNotifier(true);

  @override
  bool get wantKeepAlive => true; // keeps state alive

  void _scrollListener(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        _isBottomBarVisible.value = false;
      } else if (notification.direction == ScrollDirection.forward) {
        _isBottomBarVisible.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              _scrollListener(scrollNotification);
              return true;
            },
            child: Column(
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: uploadProgress,
                  builder: (context, value, child) {
                    if (value > 0 && value < 100) {
                      return Column(
                        children: [
                          Gap(4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              width: size.width,
                              height: 43,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                // border: Border.all(color: greyBorderColor),
                                color: kLightPrimaryColor,
                              ),
                              child: Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 10,
                                    children: [
                                      Image.asset(
                                        "assets/images/square-logo.png",
                                        fit: BoxFit.fitHeight,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Posting...",
                                            style: TextStyle(
                                              fontSize: smallSize + 2,
                                            ),
                                          ),
                                          Text(
                                            "Keep 120 Army open.",
                                            style: TextStyle(
                                              fontSize: smallSize - 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      value: value / 100,
                                      backgroundColor: Colors.grey[300],
                                      color: kPrimaryColor,
                                      strokeWidth: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (value > 100) {
                      print("=================$value");
                      // progress complete

                      context.read<HomewalllistBloc>().add(
                        const HomewalllistFetch(1, showLoader: false),
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        showGlobalSnackBar(message: "Your post was shared.");
                      });

                      uploadProgress.value = 0;

                      return const SizedBox.shrink();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                Expanded(child: Walllist()),
              ],
            ),
          ),
          // Custom bottom tab
          ValueListenableBuilder<bool>(
            valueListenable: _isBottomBarVisible,
            builder: (context, isVisible, child) {
              return AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: isVisible ? 0 : -68,
                left: 0,
                right: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      color: Colors.white,
                      child: ClipPath(
                        clipper: RoundedRectNotchClipper(),
                        child: Container(
                          width: size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                isAndroid() ? kLightPrimaryColor : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 25,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/icons/donate.svg",
                                        width: 28,
                                        height: 28,
                                        colorFilter: ColorFilter.mode(
                                          kPrimaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed("/donate");
                                      },
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/icons/search.svg",
                                        width: 28,
                                        height: 28,
                                        colorFilter: ColorFilter.mode(
                                          kPrimaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed("/searchfriend");
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 25,
                                  children: [
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/icons/rewards.svg",
                                        width: 26,
                                        height: 26,
                                        colorFilter: ColorFilter.mode(
                                          kPrimaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed("/rewards");
                                      },
                                    ),

                                    IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/icons/terms-and-conditions.svg",
                                        width: 28,
                                        height: 28,
                                        colorFilter: ColorFilter.mode(
                                          kPrimaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pushNamed("/termsandconditions");
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/alarm");
                          },
                          child: SvgPicture.asset(
                            "assets/icons/clock.svg",
                            width: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for Rectangular Notch with Rounded Corners
class RoundedRectNotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double notchWidth = 62.0;
    double notchHeight = 42.0;
    double notchRadius = 12.0;
    double notchStartX = (size.width / 2) - (notchWidth / 2);

    Path path = Path();
    path.lineTo(notchStartX - notchRadius, 0);
    path.quadraticBezierTo(
      notchStartX,
      0,
      notchStartX,
      notchRadius,
    ); // Left rounded corner
    path.lineTo(notchStartX, notchHeight - notchRadius);
    path.quadraticBezierTo(
      notchStartX,
      notchHeight,
      notchStartX + notchRadius,
      notchHeight,
    ); // Bottom left curve
    path.lineTo(notchStartX + notchWidth - notchRadius, notchHeight);
    path.quadraticBezierTo(
      notchStartX + notchWidth,
      notchHeight,
      notchStartX + notchWidth,
      notchHeight - notchRadius,
    ); // Bottom right curve
    path.lineTo(notchStartX + notchWidth, notchRadius);
    path.quadraticBezierTo(
      notchStartX + notchWidth,
      0,
      notchStartX + notchWidth + notchRadius,
      0,
    ); // Right rounded corner
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
