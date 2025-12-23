import '../../exports.dart';
import '../../global.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "About Us",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            /// 🔹 Title Section
            Text(
              "About 120 Army\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: paraFont,
                color: kPrimaryColor,
              ),
            ),

            /// 🔹 Intro Paragraph
            Text(
              "Welcome to 120 Army — a movement fueled by faith, prayer, and unity. "
              "This isn’t just another app—it’s a call to action. Every day at 1:20 PM, "
              "thousands join together in prayer, standing shoulder-to-shoulder across cities, states, and nations.\n\n"
              "Our mission is simple: to raise up an army of believers who won’t stand silent "
              "but will rise in prayer, strengthen one another, and see God move powerfully in our time.",
              style: TextStyle(fontSize: mediumsmallSize, height: 1.6),
            ),

            SizedBox(height: 16),

            /// 🔹 Section 1: Inside the App
            TermsSection(
              title: "Inside the App, You’ll Find:",
              bulletPoints: [
                "Daily Prayer Reminders – Never miss the moment. Unite with believers worldwide at the same time every day.",
                "Community Connection – You’re not alone. Join a growing network of prayer warriors ready to encourage, uplift, and stand with you.",
                "Resources & Inspiration – Access devotionals, teachings, and updates that fuel your spiritual walk and help you grow stronger.",
                "Global Impact – Your prayers don’t just echo—they multiply. Together, we’re covering nations, leaders, families, and churches in prayer. "
                    "Beyond prayer, we’re also on the ground—feeding the hungry, clothing those in need, and being the hands and feet of Jesus through causes and outreaches around the world.",
              ],
            ),

            /// 🔹 Section 2: Movement
            TermsSection(
              title: "Join the Movement",
              content:
                  "120 Army isn’t just about downloading an app—it’s about joining a family. "
                  "A family committed to prayer, revival, and seeing the Kingdom of God advance.\n\n"
                  "Be part of the movement. Be part of the Army.",
            ),
          ],
        ),
      ),
    );
  }
}

/// 🧩 Reusable Section Widget
class TermsSection extends StatelessWidget {
  final String title;
  final String? content;
  final List<String>? bulletPoints;
  final List<String>? numberedPoints;

  const TermsSection({
    required this.title,
    this.content,
    this.bulletPoints,
    this.numberedPoints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: paraFont,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          if (content != null)
            Text(
              content!,
              style: const TextStyle(fontSize: mediumsmallSize, height: 1.5),
            ),
          if (bulletPoints != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bulletPoints!.map((text) => BulletText(text)).toList(),
            ),
          if (numberedPoints != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  numberedPoints!
                      .asMap()
                      .entries
                      .map(
                        (e) => NumberedText(number: e.key + 1, text: e.value),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}

/// 🔵 Numbered list style
class NumberedText extends StatelessWidget {
  final int number;
  final String text;
  const NumberedText({required this.number, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. ",
            style: const TextStyle(fontSize: mediumsmallSize, height: 1.5),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: mediumsmallSize, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🟢 Bullet list style
class BulletText extends StatelessWidget {
  final String text;
  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•  ",
            style: TextStyle(fontSize: mediumsmallSize, height: 1.5),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: mediumsmallSize, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
