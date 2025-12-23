import '../exports.dart';
import '../global.dart';
import 'widget/custom_elevated_button.dart';

class Settingpage extends StatefulWidget {
  const Settingpage({super.key});

  @override
  State<Settingpage> createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  List settingList = [
    {"heading": "Terms & Conditions", "routes": "/termsandconditions"},
    {"heading": "Support Inbox", "routes": "/supportinbox"},
    {"heading": "Help Center", "routes": "/helpcenter"},
    {"heading": "Community Standards", "routes": "/communitystanders"},
    {"heading": "Privacy Policy", "routes": "/privacypolicy"},
    {"heading": "About Us", "routes": "/aboutus"},
  ];

  void logoutFun() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacementNamed("/login", arguments: {"animationEnabled": false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Setting",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          spacing: 15,
          children: [
            Column(
              children: List.generate(settingList.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(settingList[index]["routes"]);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: index >= 1 ? 15 : 0),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          settingList[index]["heading"],
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: kPrimaryColor),
                      ],
                    ),
                  ),
                );
              }),
            ),

            Divider(),

            CustomButton(
              isOutlined: true,
              text: "Delete Account",
              onPressed: () {
                Navigator.of(context).pushNamed("/deleteaccount");
              },
            ),
            CustomButton(text: "Logout", onPressed: logoutFun),
          ],
        ),
      ),
    );
  }
}
