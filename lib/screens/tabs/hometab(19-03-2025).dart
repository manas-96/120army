import '../../exports.dart';
import '../../global.dart';
import '../widget/bgcolorprayicon.dart';

class Hometab extends StatefulWidget {
  const Hometab({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.all(0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            // margin: EdgeInsets.only(bottom: index >= 9 ? hometabbottomgap : 0),
            decoration: BoxDecoration(
              border:
                  index >= 1
                      ? Border(
                        top: BorderSide(width: 4, color: postBorderColor),
                      )
                      : null,
            ),
            child: Column(
              children: [
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                    top: kDefaultPadding,
                    left: kDefaultPadding - 5,
                    right: kDefaultPadding - 5,
                    bottom: 15,
                  ),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(48),
                              child: Image.asset(
                                "assets/images/avater.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            spacing: 3,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kevin pietersen",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    "1 d",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: textGrayColor,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/world.svg',
                                    width: 16,
                                    colorFilter: ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "The words of Jesus Christ are life changing and timeless. When Jesus spoke, lives were transformed and the trajectory of life forever altered.",
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  "assets/images/jesus.jpg",
                  width: size.width,
                  fit: BoxFit.cover,
                ),
                Gap(5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          Bgcolorprayicon(),
                          Text("10", style: TextStyle(color: textGrayColor)),
                        ],
                      ),
                      Text(
                        "5 comments",
                        style: TextStyle(color: textGrayColor),
                      ),
                    ],
                  ),
                ),
                Gap(16),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding - 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 3,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/post_pray.svg',
                            width: 25,
                            colorFilter: ColorFilter.mode(
                              likecommentshareColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "Like",
                            style: Theme.of(context).textTheme.displaySmall!
                                .copyWith(color: likecommentshareColor),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 3,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/chat.svg',
                            width: 25,
                            colorFilter: ColorFilter.mode(
                              likecommentshareColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "Comment",
                            style: Theme.of(context).textTheme.displaySmall!
                                .copyWith(color: likecommentshareColor),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/share.svg',
                            width: 22,
                            colorFilter: ColorFilter.mode(
                              likecommentshareColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "Share",
                            style: Theme.of(context).textTheme.displaySmall!
                                .copyWith(color: likecommentshareColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(15),
              ],
            ),
          );
        },
      ),
    );
  }
}
