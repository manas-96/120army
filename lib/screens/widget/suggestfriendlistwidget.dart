import '../../exports.dart';
import '../../global.dart';
import '../../model/suggest_friend_list_model.dart';
import '../widget/custom_elevated_button.dart';
import 'cached_image.dart';

class Mainfrieldlistwidgets extends StatelessWidget {
  final Suggestdatum data;
  final VoidCallback onRemove;
  final VoidCallback addFriend;
  final bool removeStatus;
  final bool searchlist;

  const Mainfrieldlistwidgets({
    super.key,
    required this.data,
    required this.onRemove,
    required this.addFriend,
    this.removeStatus = true,
    this.searchlist = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                "/otherprofile",
                arguments: {'userID': data.id.toString()},
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:
                  data.profileImage != ""
                      ? MyImageWidget(
                        imageUrl: data.profileImage,
                        profilePic: true,
                        width: searchlist == false ? 75 : 50,
                        height: searchlist == false ? 75 : 50,
                      )
                      : Image.asset(
                        "assets/images/user.png",
                        width: searchlist == false ? 75 : 50,
                        height: searchlist == false ? 75 : 50,
                        fit: BoxFit.cover,
                      ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                "/otherprofile",
                                arguments: {'userID': data.id.toString()},
                              );
                            },
                            child: Text(
                              '${data.firstName} ${data.lastName}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          if (searchlist) ...[
                            Column(
                              children: [
                                Text(
                                  maxLines: 1,
                                  data.bio != "" ? data.bio : "120 Army User",
                                  style: TextStyle(
                                    color: textGrayColor,
                                    fontSize: smallSize,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  spacing: 15,
                  children: [
                    if (removeStatus == true) ...[
                      Expanded(
                        child: CustomButton(
                          verticalPadding: 10,
                          fontsize: 12,
                          text: "Connect",
                          onPressed: addFriend,
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          verticalPadding: 10,
                          fontsize: 12,
                          isOutlined: true,
                          text: "Remove",
                          onPressed: onRemove,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
