import '../../exports.dart';
import '../../global.dart';

class Helpcenter extends StatefulWidget {
  const Helpcenter({super.key});

  @override
  State<Helpcenter> createState() => _HelpcenterState();
}

class _HelpcenterState extends State<Helpcenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Help Center",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Title
            Text(
              "120 Army Help Center\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: paraFont,
                color: kPrimaryColor,
              ),
            ),

            // Intro paragraph
            Text(
              "Welcome to the 120 Army Help Center. Here you’ll find answers to common questions about our app, our community, and how we protect your safety and privacy. "
              "If you don’t see your question here, feel free to reach out to us at info@120army.com.\n",
              style: TextStyle(fontSize: mediumsmallSize, height: 1.6),
            ),

            // Section: General Questions
            TermsSection(
              title: "General Questions",
              bulletPoints: [
                "What is 120 Army? — 120 Army is a global prayer community where believers unite daily at 1:20 PM local time for prayer, encouragement, and testimonies.",
                "Is the app free? — Yes. The app is free to download and use. Some features may include optional donations, but prayer and community connection are always free.",
                "Who can join? — Anyone 13 years or older can join. If you are under 18, we recommend having parental or guardian consent.",
              ],
            ),

            // Section: Featured FAQs
            TermsSection(
              title: "Featured FAQs",
              numberedPoints: [
                "How do I create an account? — Simply sign up with your email or phone number. We use a secure One-Time Password (OTP) system for verification.",
                "What type of content is allowed? — You can share prayer requests, testimonies, encouragement, and uplifting messages. "
                    "Content that includes hate, harassment, profanity, sexual material, violence, or scams is not permitted.",
                "How do prayer reminders work? — You’ll get a daily notification at 1:20 PM (your time zone) reminding you to pray with believers around the world.",
                "Can I delete my account? — Yes. You can request deletion anytime in the app or by contacting info@120army.com.",
                "How do I report harmful or unsafe content? — Use the in-app reporting tools to flag content or users. "
                    "If there’s an immediate safety concern, encourage the person to contact local emergency services.",
              ],
            ),

            // Section: Contact
            TermsSection(
              title: "Need More Help?",
              bulletPoints: ["Contact us anytime at info@120army.com."],
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
