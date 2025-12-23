import '../exports.dart';
import '../main.dart';
import '../screens/home.dart';
import '../screens/separate_push_post.dart';
import '../screens/tabs/profiletab.dart';

class NotificationHandler {
  static Future<void> init() async {
    // 🔥 FOREGROUND MESSAGE
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("================= 🔥 FOREGROUND MESSAGE =================");
    //   print("Title: ${message.notification?.title}");
    //   print("Body: ${message.notification?.body}");
    //   print("Data: ${message.toMap()}");
    //   print("Full Message: $message");

    //   // ✅ Check condition
    //   if (message.data["type"] == "FRIEND_REQ_RECV") {
    //     navigatorKey.currentState?.push(
    //       MaterialPageRoute(builder: (_) => Home(initialTabIndex: 2)),
    //     );
    //   } else if (message.data["type"] == "FRIEND_REQ_ACCEPT") {
    //     navigatorKey.currentState?.push(
    //       MaterialPageRoute(builder: (_) => Profiletab()),
    //     );
    //   } else {
    //     navigatorKey.currentState?.push(
    //       MaterialPageRoute(
    //         builder:
    //             (_) => Separatepushpost(
    //               post_id: message.data["reference_table_id"],
    //             ),
    //       ),
    //     );
    //   }

    //   // print("=======================================================");
    // });

    // 📌 WHEN USER CLICKS ON NOTIFICATION (background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("================= 📌 NOTIFICATION CLICKED =================");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Data: ${message.toMap()}");
      print("Full Message: $message");

      // ✅ Check condition
      if (message.data["type"] == "FRIEND_REQ_RECV") {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => Home(initialTabIndex: 2)),
        );
      } else if (message.data["type"] == "FRIEND_REQ_ACCEPT") {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => Profiletab()),
        );
      } else {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder:
                (_) => Separatepushpost(
                  post_id: message.data["reference_table_id"],
                ),
          ),
        );
      }

      // print("=========================================================");
    });

    // 🚀 APP OPENED FROM TERMINATED STATE
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(
        "================= 🚀 APP OPENED FROM TERMINATED =================",
      );
      print("Title: ${initialMessage.notification?.title}");
      print("Body: ${initialMessage.notification?.body}");
      print("Data: ${initialMessage.toMap()}");
      print("Full Message: $initialMessage");

      // ✅ Check condition
      if (initialMessage.data["type"] == "FRIEND_REQ_RECV") {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => Home(initialTabIndex: 2)),
        );
      } else if (initialMessage.data["type"] == "FRIEND_REQ_ACCEPT") {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => Profiletab()),
        );
      } else {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder:
                (_) => Separatepushpost(
                  post_id: initialMessage.data["reference_table_id"],
                ),
          ),
        );
      }

      // print("================================================================");
    }
  }
}
