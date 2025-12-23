import 'package:flutter/cupertino.dart';

import '../screens/addalarm.dart';
import '../screens/alarm.dart';
import '../screens/content_screen/about_us.dart';
import '../screens/content_screen/community_standers.dart';
import '../screens/content_screen/help_center.dart';
import '../screens/content_screen/privacy_policy.dart';
import '../screens/content_screen/support_inbox.dart';
import '../screens/content_screen/terms_conditions.dart';
import '../screens/createpost.dart';
import '../screens/deleteaccount.dart';
import '../screens/donate.dart';
import '../screens/editprofile.dart';
import '../screens/editprofileform.dart';
import '../screens/forgot_pass_otp.dart';
import '../screens/home.dart';
import '../screens/intro.dart';
import '../screens/login.dart';
import '../screens/maplist.dart';
import '../screens/otherprofile.dart';
import '../screens/reelspost.dart';
import '../screens/resetpassword.dart';
import '../screens/rewards.dart';
import '../screens/searchlistfriend.dart';
import '../screens/separate_push_post.dart';
import '../screens/setting.dart';
import '../screens/signup_birthday.dart';
import '../screens/signup_confirmationcode.dart';
import '../screens/signup_createpassword.dart';
import '../screens/signup_gender.dart';
import '../screens/signup_mobileno.dart';
import '../screens/signup_name.dart';
import '../screens/splash.dart';
import '../screens/tabs/profiletab.dart';
import '../screens/tagfriends.dart';
import '../screens/weeklyprayerchallengedetails.dart';
import '../screens/widget/myfriendlistwidget.dart';
import '../screens/widget/suggestfriendlist.dart';
import '../screens/widget/webview.dart';

class RouteGenerator {
  static CupertinoPageRoute? generateRoute(RouteSettings settings) {
    Map<String, dynamic>? valuePassed;
    if (settings.arguments != null) {
      valuePassed = settings.arguments as Map<String, dynamic>;
    }

    final uri = Uri.parse(settings.name.toString());

    if (uri.path == '/splash') {
      return CupertinoPageRoute(builder: (_) => const Splash());
    } else if (uri.path == '/login') {
      return CupertinoPageRoute(
        builder:
            (_) => Login(
              animationEnabled: valuePassed?['animationEnabled'] ?? true,
            ),
      );
    } else if (uri.path == '/intro') {
      return CupertinoPageRoute(builder: (_) => const Intro());
    } else if (uri.path == '/signupname') {
      return CupertinoPageRoute(builder: (_) => const Signupname());
    } else if (uri.path == '/signupgender') {
      return CupertinoPageRoute(builder: (_) => const Signupgender());
    } else if (uri.path == '/signupbirthday') {
      return CupertinoPageRoute(builder: (_) => const Signupbirthday());
    } else if (uri.path == '/signupmobileno') {
      final forgotpass =
          (valuePassed != null &&
                  valuePassed['forgotpass'] != null &&
                  valuePassed['forgotpass'] == true)
              ? true
              : false;

      return CupertinoPageRoute(
        builder: (_) => Signupmobileno(forgotpass: forgotpass),
      );
    } else if (uri.path == '/signupconfirmation') {
      return CupertinoPageRoute(
        builder:
            (_) => Signupconfirmationcode(
              user_id: valuePassed!['user_id'],
              contact_details: valuePassed['contact_details'],
              type: valuePassed['type'],
              resendOtp: valuePassed['resendOtp'] ?? false,
            ),
      );
    } else if (uri.path == '/signupcreatepassword') {
      return CupertinoPageRoute(builder: (_) => const Signupcreatepassword());
    } else if (uri.path == '/home') {
      final tabIndex =
          uri.queryParameters['tab'] != null
              ? int.tryParse(uri.queryParameters['tab']!) ?? 0
              : 0;
      return CupertinoPageRoute(
        builder: (_) => Home(initialTabIndex: tabIndex),
      );
    } else if (uri.path == '/weeklyprayerchallengedetails') {
      return CupertinoPageRoute(
        builder:
            (_) => Weeklyprayerchallengedetails(
              pcData: valuePassed!['pcData'],
              badgeIcon: valuePassed['badgeIcon'],
              titleText: valuePassed['titleText'],
              nextactivatedate: valuePassed['nextactivatedate'],
            ),
      );
    } else if (uri.path == '/profile') {
      return CupertinoPageRoute(builder: (_) => const Profiletab());
    } else if (uri.path == '/donate') {
      return CupertinoPageRoute(builder: (_) => const Donate());
    } else if (uri.path == '/editprofile') {
      return CupertinoPageRoute(builder: (_) => const Editprofile());
    } else if (uri.path == '/setting') {
      return CupertinoPageRoute(builder: (_) => const Settingpage());
    } else if (uri.path == '/editprofileform') {
      return CupertinoPageRoute(
        builder: (_) => Editprofileform(formnum: valuePassed!['formnum']),
      );
    } else if (uri.path == '/rewards') {
      return CupertinoPageRoute(builder: (_) => Rewards());
    } else if (uri.path == '/alarm') {
      return CupertinoPageRoute(builder: (_) => Alarm());
    } else if (uri.path == '/addalarm') {
      return CupertinoPageRoute(builder: (_) => Addalarm());
    } else if (uri.path == '/webview') {
      return CupertinoPageRoute(
        builder:
            (_) => Webviewurl(
              webUrl: valuePassed!['webUrl'],
              title: valuePassed['title'],
            ),
      );
    } else if (uri.path == '/suggestfriendswidget') {
      return CupertinoPageRoute(
        builder:
            (_) => Suggestfriendswidget(
              dataList: valuePassed!["dataList"],
              fullpage: valuePassed["fullpage"] ?? false,
            ),
      );
    } else if (uri.path == '/searchfriend') {
      return CupertinoPageRoute(builder: (_) => Searchfriendlist());
    } else if (uri.path == '/myfriendlist') {
      return CupertinoPageRoute(
        builder:
            (_) => Myfriendlist(
              data: valuePassed!["data"],
              fullscreen: valuePassed["fullscreen"],
            ),
      );
    } else if (uri.path == '/createpost') {
      return CupertinoPageRoute(builder: (_) => Createpost());
    } else if (uri.path == '/reelspost') {
      return CupertinoPageRoute(builder: (_) => Reelspost());
    } else if (uri.path == '/maplist') {
      return CupertinoPageRoute(builder: (_) => Maplist());
    } else if (uri.path == '/tagfriends') {
      return CupertinoPageRoute(
        builder: (_) => Tagfriends(realDataList: valuePassed!["realDataList"]),
      );
    } else if (uri.path == '/otherprofile') {
      return CupertinoPageRoute(
        builder: (_) => Otherprofile(userID: valuePassed!["userID"]),
      );
    } else if (uri.path == '/deleteaccount') {
      return CupertinoPageRoute(builder: (_) => Deleteaccount());
    } else if (uri.path == '/termsandconditions') {
      return CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => Termsconditions(),
      );
    } else if (uri.path == '/supportinbox') {
      return CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => Supportinbox(),
      );
    } else if (uri.path == '/helpcenter') {
      return CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => Helpcenter(),
      );
    } else if (uri.path == '/communitystanders') {
      return CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => Communitystanders(),
      );
    } else if (uri.path == '/privacypolicy') {
      return CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => Privacypolicy(),
      );
    } else if (uri.path == '/aboutus') {
      return CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => Aboutus(),
      );
    } else if (uri.path == '/forgotpassword') {
      return CupertinoPageRoute(
        builder:
            (_) => Forgotpassotp(
              contact_details: valuePassed!['contact_details'],
              user_id: valuePassed['user_id'],
            ),
      );
    } else if (uri.path == '/resetpassword') {
      return CupertinoPageRoute(
        builder: (_) => Resetpassword(user_id: valuePassed!['user_id']),
      );
    } else if (uri.path == '/separate-push-post') {
      return CupertinoPageRoute(
        builder: (_) => Separatepushpost(post_id: valuePassed!['post_id']),
      );
    }

    return null;
  }
}
