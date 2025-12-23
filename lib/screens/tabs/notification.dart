import 'package:onetwentyarmyprayer2/global.dart';

import '../../exports.dart';
import '../../main.dart';
import '../../model/notification_list_model.dart';
import '../../services/main_service.dart';
import '../home.dart';
import '../widget/bgcolorprayicon.dart'; // Assuming this is used for 'amen'/'like'/'prayer' related icons
import '../widget/colorcommenticon.dart'; // Assuming this is used for 'comment'/'reply' related icons

class Notificationtab extends StatefulWidget {
  const Notificationtab({super.key});

  @override
  State<Notificationtab> createState() => _NotificationtabState();
}

class _NotificationtabState extends State<Notificationtab> {
  Notificationlistmodel? notificationModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotification();
  }

  Future<void> loadNotification() async {
    notificationModel = await MainService().notificationlistService();
    setState(() {
      isLoading = false;
    });
  }

  String _getNotificationMessage(Notificationdata item) {
    if (item.msg != null && item.msg!.isNotEmpty) {
      return item.msg!;
    }

    final senderName = '${item.firstName} ${item.lastName}';
    switch (item.type) {
      case "FRIEND_REQ_RECV":
        return '$senderName sent you a connection request.';
      case "FRIEND_REQ_ACCEPT":
        return '$senderName accepted your connection request.';
      case "AMEN_CREATED":
        return '$senderName sent amen to your post.';
      case "COMMENT_CREATED":
        return '$senderName commented on your post.';
      case "REPLY_CREATED":
        return '$senderName replied to your comment.';
      case "POST_CREATED":
        if (item.msg?.contains('updated profile picture') == true) {
          return '$senderName updated their profile picture.';
        } else if (item.msg?.contains('updated cover picture') == true) {
          return '$senderName updated their cover picture.';
        }
        return '$senderName added a new post.';
      case "REEL_CREATED":
        return '$senderName added a new clip.';
      case "LIKE_CREATED":
        return '$senderName liked your post.';
      default:
        return 'New activity from $senderName.';
    }
  }

  Widget _getNotificationIcon(String? type) {
    if (type == null) {
      return const SizedBox.shrink();
    }

    switch (type) {
      case "FRIEND_REQ_RECV":
      case "FRIEND_REQ_ACCEPT":
        return const Bgcolorprayicon(
          iconpath: "assets/icons/user.svg",
          padding: 5,
        );
      case "AMEN_CREATED":
        return const Bgcolorprayicon();

      case "POST_CREATED":
        return const Bgcolorprayicon(
          iconpath: "assets/icons/post.svg",
          padding: 6,
        );

      case "REEL_CREATED":
        return const Bgcolorprayicon(
          iconpath: "assets/icons/reels_filled.svg",
          padding: 5,
        );

      case "COMMENT_CREATED":
      case "REPLY_CREATED":
        return const Colorcommenticon();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final list = notificationModel?.data ?? [];

    if (list.isEmpty) {
      return const Center(child: Text("No notifications found"));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: tabTopPadding),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            // final shouldShowIcon =
            //     item.type == "AMEN_CREATED" ||
            //     item.type == "LIKE_CREATED" ||
            //     item.type == "COMMENT_CREATED" ||
            //     item.type == "REPLY_CREATED";

            return GestureDetector(
              onTap: () {
                setState(() {
                  item.isRead = 1;
                });
                MainService().updatenotificationService(id: item.id.toString());

                if (item.type == "FRIEND_REQ_ACCEPT") {
                  Navigator.of(context).pushNamed("/profile");
                } else if (item.type == "FRIEND_REQ_RECV") {
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(builder: (_) => Home(initialTabIndex: 2)),
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    "/separate-push-post",
                    arguments: {"post_id": item.referenceTableId.toString()},
                  );
                }
              },
              child: Container(
                color:
                    item.isRead == 0 ? kLightPrimaryColor : Colors.transparent,
                width: size.width,
                margin: EdgeInsets.only(
                  bottom: index == list.length - 1 ? hometabbottomgap - 20 : 0,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: kDefaultPadding - 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child:
                                (item.profileImage == null ||
                                        item.profileImage!.isEmpty)
                                    ? Image.asset(
                                      "assets/images/user.png",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.network(
                                      item.profileImage!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: _getNotificationIcon(item.type),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getNotificationMessage(item),
                            softWrap: true,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
