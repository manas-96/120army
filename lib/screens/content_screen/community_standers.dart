import '../../exports.dart';
import '../../global.dart';

class Communitystanders extends StatefulWidget {
  const Communitystanders({super.key});

  @override
  State<Communitystanders> createState() => _CommunitystandersState();
}

class _CommunitystandersState extends State<Communitystanders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Community Standards",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "120 Army — Community Standards\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: paraFont,
                color: kPrimaryColor,
              ),
            ),
            Text(
              "Last updated: October 2025\n\n"
              "At 120 Army, we are more than an app — we are a family of believers united in daily prayer at 1:20 PM across every time zone. "
              "These Community Standards reflect our mission to create a safe, encouraging, Christ-centered environment where all are welcome, "
              "and where faith, prayer, and love guide every interaction.\n",
              style: TextStyle(fontSize: mediumsmallSize, height: 1.6),
            ),

            // 1️⃣ Our Core Values
            TermsSection(
              title: "1. Our Core Values",
              bulletPoints: [
                "Prayer First – Everything we do begins with prayer and unity in Christ.",
                "Respect & Kindness – Treat others with dignity, grace, and encouragement.",
                "Safety & Trust – Protecting our community from harm, harassment, and exploitation.",
                "Integrity & Truth – No deceptive, harmful, or misleading content.",
                "Family-Friendly – Language, media, and interactions should reflect a community safe for all ages.",
              ],
            ),

            // 2️⃣ What’s Welcome
            TermsSection(
              title: "2. What’s Welcome",
              bulletPoints: [
                "Prayer Requests & Testimonies – Share your needs, experiences, and faith journeys.",
                "Encouragement – Speak life, hope, and love into the lives of others.",
                "Clips & Faith Challenges – Participate in daily challenges, post uplifting content, and celebrate milestones.",
                "Community Connection – Build genuine friendships by connecting, spreading encouragement, and supporting causes.",
                "Global Mission – Unite in prayer for nations, leaders, churches, families, and join in outreach to feed the hungry, shelter the vulnerable, and care for the broken.",
              ],
            ),

            // 3️⃣ What’s Not Allowed
            TermsSection(
              title: "3. What’s Not Allowed",
              content:
                  "To protect the community, the following are strictly prohibited:",
              bulletPoints: [
                "Harassment or Hate – No bullying, threats, or attacks based on race, ethnicity, nationality, religion, gender, disability, or any protected characteristic.",
                "Profanity, Vulgarity, or Blasphemy – Keep language clean, honoring God and others.",
                "Sexual Content or Exploitation – Absolutely no nudity, sexualized imagery, or content involving minors.",
                "Violence or Self-Harm – No glorification of violence, gore, suicide, or encouragement of self-harm.",
                "Scams, Spam, or Deception – No misleading fundraising, miracle-selling, chain messages, or impersonation of ministries or leaders.",
                "False or Harmful Claims – Testimonies are welcome, but medical, financial, or legal claims must not mislead or discourage professional care.",
                "Unauthorized Content Use – Only share music, images, or videos you own or have permission to use.",
              ],
            ),

            // 4️⃣ Community Etiquette
            TermsSection(
              title: "4. Community Etiquette",
              bulletPoints: [
                "Connect Respectfully – Use the “Connect” feature to build authentic relationships.",
                "Celebrate Others – Respond with “Amen” to prayers and testimonies, share encouragement (“Spread”), and uplift one another.",
                "Faith Challenges & Rewards – Grow step by step in God’s Word, earn badges, and share your progress with joy.",
                "Donations & Causes – Support only verified 120 Army missions (India, Kenya, Global Movement). No unauthorized fundraising.",
              ],
            ),

            // 5️⃣ Safety & Reporting
            TermsSection(
              title: "5. Safety & Reporting",
              bulletPoints: [
                "If someone is in immediate danger, encourage them to seek local emergency help.",
                "Use in-app reporting tools to flag harmful or inappropriate content.",
                "Our moderation team may remove content, restrict accounts, or suspend users to maintain a safe environment.",
                "You may appeal moderation decisions within the app where available.",
              ],
            ),

            // 6️⃣ Your Privacy & Security
            TermsSection(
              title: "6. Your Privacy & Security",
              bulletPoints: [
                "Your personal data is protected under our Privacy Policy.",
                "We use OTP verification for secure access.",
                "We never sell prayer requests or personal data.",
              ],
            ),

            // 7️⃣ Living the Mission Together
            TermsSection(
              title: "7. Living the Mission Together",
              content:
                  "120 Army is a church without walls, uniting believers daily in prayer and action. "
                  "Together, we lift up the broken, feed the hungry, care for widows, and advance the Kingdom of God through both digital and real-world ministry.\n\n"
                  "Be prayerful. Be respectful. Be part of the Army.\n\n"
                  "📩 Questions? Contact us at info@120army.com\n📬 Mailing Address: PO Box 74, Ridgefield, WA 98642, USA",
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
