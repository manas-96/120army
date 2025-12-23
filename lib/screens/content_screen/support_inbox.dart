import '../../exports.dart';
import '../../global.dart';

class Supportinbox extends StatefulWidget {
  const Supportinbox({super.key});

  @override
  State<Supportinbox> createState() => _SupportinboxState();
}

class _SupportinboxState extends State<Supportinbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Support Inbox",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Support Inbox\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: paraFont,
                color: kPrimaryColor,
              ),
            ),
            Text(
              "Welcome to the Support Inbox. This page will guide you on how to get help if you face any issues with the 120 Army app.\n",
              style: TextStyle(fontSize: mediumsmallSize, height: 1.6),
            ),

            // 🔹 Section 1: How to Report a Problem
            TermsSection(
              title: "How to Report a Problem",
              numberedPoints: [
                "Open Settings and select ‘Report a Problem’.",
                "Choose a Category (e.g., App Bug, Account Issue, Payment, Other).",
                "Add a clear Subject so our team knows what the issue is about.",
                "Write a short Description of the problem, including any steps to reproduce the issue if possible.",
                "(Optional) Upload a Screenshot to show us exactly what you are seeing.",
                "Tap ‘Send Report’ to submit your issue.",
              ],
            ),

            // 🔹 Section 2: What Happens After Submission
            TermsSection(
              title: "What Happens After Submission",
              bulletPoints: [
                "Confirmation: Once submitted, you’ll see a success message confirming your report.",
                "Review: Our support team will carefully review your message and any screenshot you provided.",
                "Email Response: Within 48 hours, you’ll receive an email from us with either a solution or follow-up questions.",
              ],
            ),

            // 🔹 Section 3: Tips for Faster Help
            TermsSection(
              title: "Tips for Faster Help",
              bulletPoints: [
                "Make sure your email address on your account is correct. That’s where we’ll send our response.",
                "Be as specific as possible in the description (e.g., what screen the error happened on, what button you tapped).",
                "If you can, attach a screenshot—it often helps us solve issues more quickly.",
                "Check your spam or junk folder in case our reply ends up there.",
              ],
            ),

            // 🔹 Section 4: Important Notes
            TermsSection(
              title: "Important Notes",
              bulletPoints: [
                "You won’t see your submitted issues here in the app. All updates will come by email.",
                "If you don’t hear back within 48 hours, please email us directly at info@120army.com.",
              ],
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
