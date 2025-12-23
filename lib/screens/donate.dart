import 'package:url_launcher/url_launcher.dart';

import '../exports.dart';
import '../global.dart';
import 'widget/border.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/progressbar.dart';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  // final List<String> images = [
  //   'assets/images/donate-fig-01.jpg',
  //   'assets/images/donate-fig-02.jpg',
  //   'assets/images/donate-fig-03.jpg',
  // ];

  final List<Map<String, dynamic>> localData = [
    {
      'bold': 'India: ',
      'content':
          "Join Us to Shelter, Feed, Protect, and Empower Children in India.",
      'image': 'assets/images/donate-fig-01.jpg',
      'target': '\$100.00.00',
      'raised': '\$48.00.00',
      'parcent': 60,
    },
    {
      'bold': 'Kenya: ',
      'content':
          "Feeding and Educating Children in Kenya with Books, Meals, and Uniforms.",
      'image': 'assets/images/donate-fig-02.jpg',
      'target': '\$200.00.00',
      'raised': '\$28.00.00',
      'parcent': 50,
    },
    {
      'bold': 'Global Movement: ',
      'content':
          "Supporting the Church globally through daily prayer — uniting pastors, youth, and people of all ages in faith and purpose",
      'image': 'assets/images/donate-fig-03.jpg',
      'target': '\$300.00.00',
      'raised': '\$18.00.00',
      'parcent': 40,
    },
  ];

  final AudioPlayer _audioPlayer =
      AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  bool _isAudioLoaded = false;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _appBarOpacity = ValueNotifier(0.0);

  Future<void> _openInSafari(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Safari te open hobe
      );
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  void initState() {
    super.initState();
    _preloadAudio();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    double maxOffset =
        150; // Adjust the value as needed for a smoother transition
    double newOpacity = (offset / maxOffset).clamp(0.0, 1.0);

    if (_appBarOpacity.value != newOpacity) {
      _appBarOpacity.value = newOpacity; // Only update when there's a change
    }
  }

  Future<void> _preloadAudio() async {
    await _audioPlayer.setSource(AssetSource('images/swipe.mp3'));
    _isAudioLoaded = true;
  }

  void _playSwipeSound() {
    if (_isAudioLoaded) {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
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
              iconTheme: IconThemeData(
                color: Color.lerp(Colors.white, kPrimaryColor, opacity),
              ),
              title: Opacity(
                opacity: opacity,
                child: Text(
                  "Donation",
                  style: TextStyle(color: kPrimaryColor, fontSize: appbarTitle),
                ),
              ),
              systemOverlayStyle:
                  opacity < 0.5
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: ClipPath(
                clipper: CurvedBackgroundClipper(),
                child: Container(
                  width: size.width,
                  height: 350,
                  decoration: BoxDecoration(
                    // color: kPrimaryColor
                    image: DecorationImage(
                      image: AssetImage("assets/images/donate-fig-01.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        kPrimaryColor.withValues(
                          alpha: 0.9,
                        ), // Adjust opacity as needed
                        BlendMode
                            .darken, // Change blend mode as per your requirement
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Column(
              children: [
                Container(
                  // height: 535,
                  height: _getCardSwiperHeight(size),
                  margin: EdgeInsets.only(top: 100),
                  child: CardSwiper(
                    backCardOffset: Offset(0, 35),
                    allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                      horizontal: true,
                    ),
                    numberOfCardsDisplayed: 3,
                    cardsCount: localData.length,
                    onSwipe: (previousIndex, currentIndex, direction) {
                      _playSwipeSound();
                      return true;
                    },

                    cardBuilder: (
                      context,
                      index,
                      percentThresholdX,
                      percentThresholdY,
                    ) {
                      return Container(
                        padding: EdgeInsets.all(kDefaultPadding - 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                localData[index]['image'].toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              localData[index]['bold'] +
                                  localData[index]['content'],
                              style: TextStyle(
                                fontSize: pageHeading - 3,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                spacing: 20,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (int i = 0; i < 5; i++)
                                        Align(
                                          widthFactor: 0.6,
                                          child: SizedBox(
                                            width: 37,
                                            height: 37,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundImage: ExactAssetImage(
                                                'assets/images/avater.jpg',
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text("+ 150 Donated"),
                                ],
                              ),
                            ),

                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Progressbar(
                                  maxSteps: 100,
                                  currentStep: localData[index]["parcent"],
                                ),

                                Positioned(
                                  right: 0,
                                  top: -25,
                                  child: Text(
                                    "${localData[index]["parcent"].toString()} %",
                                    style: TextStyle(
                                      fontSize: paraFont,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(fontSize: smallSize),
                                    children: [
                                      TextSpan(
                                        text: 'Target :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: localData[index]['target'],
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(fontSize: smallSize),
                                    children: [
                                      TextSpan(
                                        text: 'Raised :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: localData[index]['raised'],
                                        style: TextStyle(color: textGrayColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Borderdevider(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              margin: EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 5,
                              ),
                            ),

                            Expanded(child: SizedBox()),

                            CustomButton(
                              text: "Donate Now",
                              isOutlined: true,
                              onPressed: () {
                                _openInSafari(
                                  "https://give.tithe.ly/?formId=45c3e779-06e7-4b1c-bd98-89f2a8d33cf1",
                                );
                                // Navigator.of(context).pushNamed(
                                //   "/webview",
                                //   arguments: {
                                //     "webUrl":
                                //         "https://give.tithe.ly/?formId=45c3e779-06e7-4b1c-bd98-89f2a8d33cf1",
                                //     "title": "Donate for hunger people",
                                //   },
                                // );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Gap(10),

                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding - 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 7,
                    children: [
                      Container(
                        width: size.width,
                        height: 60,
                        padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding - 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff000000).withValues(alpha: 0.3),
                              offset: Offset(0, 5),
                              blurRadius: 14,
                              spreadRadius: -2,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                Image.asset(
                                  "assets/images/logo.png",
                                  width: 45,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Organized by",
                                      style: TextStyle(fontSize: smallSize),
                                    ),
                                    Text(
                                      "120 Army ",
                                      style: TextStyle(
                                        fontSize: paraFont,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SvgPicture.asset(
                              "assets/icons/verify.svg",
                              width: 35,
                            ),
                          ],
                        ),
                      ),

                      Gap(5),

                      Text(
                        "Join the Mission – Make a Difference",
                        style: TextStyle(fontSize: titlesize),
                      ),
                      Text(
                        "120 Army is a church with no walls—uniting the Body of Christ in daily prayer across every time zone at 1:20 PM. Through the power of prayer and action, we lift up the broken, feed the hungry, care for widows, and strengthen believers to live boldly for Jesus. Together, we shine as one united Church, carrying God’s love to the world.",
                        style: TextStyle(color: textGrayColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: "Donate Now",
          onPressed: () {
            _openInSafari(
              "https://give.tithe.ly/?formId=45c3e779-06e7-4b1c-bd98-89f2a8d33cf1",
            );
            // Navigator.of(context).pushNamed(
            //   "/webview",
            //   arguments: {
            //     "webUrl":
            //         "https://give.tithe.ly/?formId=45c3e779-06e7-4b1c-bd98-89f2a8d33cf1",
            //     "title": "Donate for hunger people",
            //   },
            // );
          },
        ),
      ),
    );
  }
}

// Custom Clipper for the Curved Background
class CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

double _getCardSwiperHeight(Size size) {
  // You can adjust this logic as needed
  if (size.width > 700) {
    // Treat as iPad / large tablet
    return size.height * 0.75;
  } else {
    // Treat as iPhone / small device
    return 600;
  }
}
