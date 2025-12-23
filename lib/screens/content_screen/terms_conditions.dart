import '../../exports.dart';
import '../../global.dart';

class Termsconditions extends StatefulWidget {
  const Termsconditions({super.key});

  @override
  State<Termsconditions> createState() => _TermsconditionsState();
}

class _TermsconditionsState extends State<Termsconditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Terms and Conditions",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "120 Army — Terms of Service & Community Guidelines (v1.0)\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: paraFont,
                color: kPrimaryColor,
              ),
            ),
            Text(
              "Last updated: September 30, 2025\n\n"
              "Plain-English overview (not a contract): 120 Army is a Christian community built for prayer, testimony, and encouragement—“a church without walls.” "
              "We welcome all people and have zero tolerance for harassment, hate, vulgarity, nudity, and exploitation. Below are the legally binding Terms of Service "
              "(the “Terms”) and Community Guidelines (the “Guidelines”). If anything here conflicts with local law, the law controls.\n",
              style: TextStyle(fontSize: mediumsmallSize, height: 1.5),
            ),

            /// 1
            TermsSection(
              title: "1) Acceptance of Terms",
              content:
                  "By creating an account, accessing, or using the 120 Army app, websites, or services (collectively, the “Service”), you agree to these Terms and to our "
                  "Community Guidelines below, as well as any policies we reference (e.g., Privacy Policy, Copyright Policy). If you do not agree, do not use the Service.",
            ),

            /// 2
            TermsSection(
              title: "2) Who May Use the Service",
              bulletPoints: [
                "Age: You must be 13+ to use the Service. If you are under the age of majority where you live, you must have your parent or legal guardian’s consent. We do not knowingly collect personal information from children under 13.",
                "Account: Keep your password secure and your account information current. You are responsible for all activity on your account.",
                "Organization use: If you create an account or use the Service on behalf of a ministry, church, or organization, you represent that you have authority to bind that entity to these Terms.",
              ],
            ),

            /// 3
            TermsSection(
              title: "3) Our Mission & Values",
              content:
                  "120 Army’s purpose is to host a peaceful, prayer-centered space to ask for prayer, share testimonies, post videos/photos, and love one another. "
                  "This is not a venue for profanity, sexual content, harassment, self-promotion spam, or divisive attacks. We moderate to keep this space healthy and safe.",
            ),

            /// 4
            TermsSection(
              title: "4) Your Content & License to Us",
              content:
                  "You retain ownership of your posted content (text, images, audio, video, livestreams, and other materials).",
              bulletPoints: [
                "You grant 120 Army a non-exclusive, worldwide, royalty-free license to host, store, reproduce, adapt, publish, display, and distribute your content.",
                "This license ends when your content is deleted, except where copies remain in backups, logs, or shared by others.",
                "AI-generated or edited content must be labeled; do not impersonate or fabricate testimonies.",
                "Feedback: If you submit suggestions, we may use them without restriction or compensation.",
              ],
            ),

            /// 5
            TermsSection(
              title: "5) Prohibited Conduct & Content (high level)",
              content: "You may not use the Service to:",
              numberedPoints: [
                "Harass, bully, or threaten any person.",
                "Post or promote hate or dehumanizing speech toward people based on protected characteristics.",
                "Use vulgar, profane, or obscene language.",
                "Share nudity or sexual content.",
                "Glorify or incite violence, self-harm, or suicide.",
                "Promote criminal activity or illegal goods.",
                "Post misinformation that risks harm.",
                "Spam or scams.",
                "Infringe intellectual property rights.",
                "Collect data without consent or use unauthorized automation.",
                "Impersonate others.",
                "Interfere with worship or prayer spaces.",
              ],
            ),

            /// 6
            TermsSection(
              title: "6) Community Guidelines (details & examples)",
              content: "These examples guide community behavior:",
              bulletPoints: [
                "Prayer & Testimony Etiquette: Be respectful; don’t share others’ private info.",
                "Language & Tone: Use gracious language; avoid profanity.",
                "Safety & Well-Being: Encourage professional help if someone is in danger.",
                "Images, Video, and Music: No nudity, sexual, or violent content.",
                "Ministries & Fundraising: Disclose donation requests clearly.",
                "AI & Synthetic Media: Label synthetic content.",
                "Moderation: Violations may lead to suspension; appeals available.",
              ],
            ),

            /// 7
            TermsSection(
              title: "7) Intellectual Property & Copyright (DMCA)",
              content:
                  "Only post content you have rights to share.\nRepeat infringers may have accounts disabled.",
              bulletPoints: [
                "DMCA Notices: Dino Genito / Matt Williams",
                "Address: PO Box 74, Ridgefield, WA 98642, USA",
                "Email: info@120army.com",
                "Follow 17 U.S.C. §512(c)(3) requirements.",
              ],
            ),

            /// 8
            TermsSection(
              title: "8) Privacy & Data",
              content:
                  "See our Privacy Policy for details. We collect minimal data and do not sell personal prayer requests.\nDo not post others’ health, address, or financial information.",
            ),

            /// 9
            TermsSection(
              title: "9) Health, Legal, and Financial Disclaimers",
              content:
                  "120 Army does not provide medical, legal, financial, or counseling services. All content is for spiritual encouragement only. Seek professional help when needed.",
            ),

            /// 10
            TermsSection(
              title: "10) Safety Tools & Reporting",
              content:
                  "Use in-app tools for reporting, muting, blocking, and appeals. Crisis line links may be shown when needed.",
            ),

            /// 11
            TermsSection(
              title: "11) Enforcement; Account Actions",
              content:
                  "We may remove content, disable features, or terminate accounts for violations. We are not obligated to monitor all content but may do so for safety.",
            ),

            /// 12
            TermsSection(
              title: "12) Third-Party Links, Services, and Integrations",
              content:
                  "External services and links are not controlled by us and have their own terms and privacy policies.",
            ),

            /// 13
            TermsSection(
              title: "13) Changes to the Service",
              content:
                  "We may change, suspend, or discontinue features at any time. We will provide notice of material changes where feasible.",
            ),

            /// 14
            TermsSection(
              title: "14) Payments and Donations",
              bulletPoints: [
                "Donations: You authorize recurring charges until you cancel.",
                "Refunds: Payments are nonrefundable except as required by law.",
                "Chargebacks: Excessive chargebacks may lead to suspension.",
              ],
            ),

            /// 15
            TermsSection(
              title: "15) Legal Rights & Responsibilities",
              bulletPoints: [
                "Section 230: We are not the publisher of user content.",
                "Indemnity: You agree to hold 120 Army harmless from claims arising from your content.",
                "Disclaimers: The Service is provided “as is.”",
                "Limitation of Liability: Total liability will not exceed \$100 or the amount paid in the prior 12 months.",
              ],
            ),

            /// 16
            TermsSection(
              title: "16) Arbitration & Class Action Waiver (U.S. Users)",
              bulletPoints: [
                "Disputes will be resolved by binding arbitration individually.",
                "No class actions permitted.",
                "Opt out within 30 days by emailing info@120army.com.",
                "Venue: King County, Washington (JAMS Streamlined Rules).",
              ],
            ),

            /// 17
            TermsSection(
              title: "17) Governing Law & Venue",
              content:
                  "These Terms are governed by the laws of Washington State. Exclusive venue for non-arbitrated matters is King County, Washington.",
            ),

            /// 18
            TermsSection(
              title: "18) Termination",
              content:
                  "We may suspend or terminate accounts for violations or safety reasons. Certain provisions (e.g., licenses, disclaimers) survive termination.",
            ),

            /// 19
            TermsSection(
              title: "19) Changes to These Terms",
              content:
                  "We may update these Terms occasionally. Continued use after updates means acceptance of the revised Terms.",
            ),

            /// 20
            TermsSection(
              title: "20) Contact",
              bulletPoints: [
                "120 Army Legal",
                "PO Box 74, Ridgefield, WA 98642, USA",
                "Email: info@120army.com",
              ],
            ),

            TermsSection(
              title: "Community Guidelines (Detailed)",
              numberedPoints: [
                "Be Prayerful, Respectful, and Kind.",
                "No Hate or Harassment.",
                "Clean Language.",
                "No Nudity or Sexual Content.",
                "Safety & Self-Harm.",
                "Violence & Gore.",
                "Misleading or Harmful Claims.",
                "Spam, Scams, & Impersonation.",
                "Intellectual Property.",
                "Teen Safety & Privacy.",
                "Reporting & Appeals.",
              ],
              content:
                  "Transparency & Enforcement Notes:\nWe may publish transparency reports and use both automated and human review to ensure fairness.",
            ),

            TermsSection(
              title: "Versioning & Ownership",
              content:
                  "© 120 Army. This document is licensed for use by 120 Army and its affiliates. Do not reuse without permission.",
            ),
          ],
        ),
      ),
    );
  }
}

/// 🧩 Reusable Section
class TermsSection extends StatelessWidget {
  final String title;
  final String content;
  final List<String>? bulletPoints;
  final List<String>? numberedPoints;

  const TermsSection({
    required this.title,
    this.content = "",
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
          if (content.isNotEmpty)
            Text(
              content,
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

/// 🟢 Bullet Style
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

/// 🔵 Numbered List Style
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
