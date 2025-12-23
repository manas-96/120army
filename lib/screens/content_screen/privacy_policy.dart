import '../../exports.dart';
import '../../global.dart';

class Privacypolicy extends StatefulWidget {
  const Privacypolicy({super.key});

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Privacy Policy",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Title & Intro
            Text(
              "120 Army — Privacy Policy (v1.0)\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: paraFont,
                color: kPrimaryColor,
              ),
            ),
            Text(
              "Last updated: September 30, 2025\n\n"
              "Welcome to the 120 Army Prayer Application. We are committed to protecting your privacy and ensuring the security of your personal information. "
              "This Privacy Policy outlines our practices regarding the collection, use, and disclosure of your information when you use our application and services.\n",
              style: TextStyle(fontSize: mediumsmallSize, height: 1.6),
            ),

            // 1️⃣ Information We Collect
            TermsSection(
              title: "1) Information We Collect",
              content:
                  "We collect the following types of information to provide and improve our services:",
              bulletPoints: [
                "Personal Information:",
                "Name – Used to personalize your experience.",
                "Email Address – Used for account creation, communication, and notifications.",
                "Phone Number – Used for account verification and authentication via One-Time Password (OTP).",
                "Location (if provided) – Helps adjust notifications based on your time zone for accurate prayer reminders.",
                "Usage Data:",
                "App Activity – Tracks interactions with the application to improve user experience.",
                "Customization Settings – Saves preferences and configurations made within the app.",
              ],
            ),

            // 2️⃣ OTP Verification
            TermsSection(
              title: "2) One-Time Password (OTP) Verification",
              bulletPoints: [
                "To ensure secure access and account verification, we use OTP authentication.",
                "When you sign up or log in, you may receive an OTP via SMS or email.",
                "By using our services, you agree to:",
                "• Receive OTP messages for verification and security purposes.",
                "• Provide accurate phone numbers or email addresses for OTP delivery.",
                "• Not share OTPs with others for security reasons.",
                "We use trusted third-party service providers (such as Twilio) for OTP delivery. We do not store OTPs after authentication is complete.",
              ],
            ),

            // 3️⃣ How We Use Your Information
            TermsSection(
              title: "3) How We Use Your Information",
              bulletPoints: [
                "To Provide and Maintain Services – Ensuring accurate prayer reminders and user authentication.",
                "To Improve User Experience – Analyzing user behavior and preferences to enhance app features.",
                "To Ensure Security – Implementing OTP verification to prevent unauthorized access.",
                "To Communicate with You – Sending notifications, updates, and security alerts.",
              ],
            ),

            // 4️⃣ Sharing and Disclosure
            TermsSection(
              title: "4) Sharing and Disclosure of Information",
              bulletPoints: [
                "We do not sell or share your personal information with third parties, except in the following cases:",
                "Service Providers – We share data with trusted vendors (e.g., Twilio) to facilitate OTP authentication.",
                "Legal Compliance – If required by law, we may disclose your information to comply with legal obligations or protect against fraud.",
                "Business Transfers – In the case of a merger, acquisition, or asset sale, your information may be transferred to the new entity.",
              ],
            ),

            // 5️⃣ Data Security
            TermsSection(
              title: "5) Data Security",
              content:
                  "We take reasonable measures to protect your personal information from unauthorized access, use, or disclosure. "
                  "However, no system is 100% secure, and we cannot guarantee absolute security.",
            ),

            // 6️⃣ Data Retention
            TermsSection(
              title: "6) Data Retention",
              content:
                  "We retain your personal information only as long as necessary to fulfill the purposes outlined in this policy. "
                  "You may request deletion of your data at any time by contacting us at 120army@gmail.com.",
            ),

            // 7️⃣ Children's Privacy
            TermsSection(
              title: "7) Children’s Privacy",
              bulletPoints: [
                "120 Army is not directed to children under 13. We do not knowingly collect personal data from children under 13.",
                "If we become aware that we have collected personal information from a child under 13 without parental consent, we will delete it immediately.",
                "If you are a parent/guardian and believe your child has provided us with personal data, please contact us.",
              ],
            ),

            // 8️⃣ International Users
            TermsSection(
              title: "8) International Users",
              content:
                  "Our servers and data processing are primarily located in the United States. "
                  "If you access the Service from outside the U.S., you consent to the transfer, storage, and processing of your information in the U.S. and other jurisdictions.",
            ),

            // 9️⃣ Changes to Policy
            TermsSection(
              title: "9) Changes to this Privacy Policy",
              content:
                  "We may update this Privacy Policy from time to time. Any changes will be posted on this page, and where appropriate, we will notify you by email or in-app notifications.",
            ),

            // 🔟 Contact Us
            TermsSection(
              title: "10) Contact Us",
              bulletPoints: [
                "If you have any questions or concerns about this Privacy Policy, please contact us:",
                "120 Army Privacy Team",
                "Email: info@120army.com",
                "Mailing Address: PO Box 74, Ridgefield, WA 98642, USA",
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
