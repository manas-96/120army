import '../exports.dart';
import '../global.dart';
import 'widget/custom_elevated_button.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int _currentIndex = 0;

  final List<String> imageList = [
    "assets/images/intro-fig-01.jpg",
    "assets/images/intro-fig-02.jpg",
    "assets/images/intro-fig-03.jpg",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  void _precacheImages() {
    for (String imagePath in imageList) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Join 120 Army",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 200.0,
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 1),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemCount: imageList.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imageList[index],
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      imageList.asMap().entries.map((entry) {
                        return Container(
                          width: _currentIndex == entry.key ? 20 : 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: kPrimaryColor),

                            color:
                                _currentIndex == entry.key
                                    ? kPrimaryColor
                                    : Colors.transparent,
                          ),
                        );
                      }).toList(),
                ),

                Text(
                  "Create an account to connect with friends, family and communities of people who share your interests.",
                ),
                CustomButton(
                  text: "Get started",
                  onPressed: () {
                    Navigator.of(context).pushNamed("/signupname");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
