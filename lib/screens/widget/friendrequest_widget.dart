import '../../exports.dart';
import '../../model/suggest_friend_list_model.dart';
import '../../services/main_service.dart';
import '../../statemanagment/friendlist/friendlist_bloc.dart';
import '../../statemanagment/friendrequestlist/friendrequestlist_bloc.dart';
import 'cached_image.dart';
import 'custom_elevated_button.dart';
import 'toast.dart';

class FriendRequestCard extends StatefulWidget {
  const FriendRequestCard({super.key, required this.data});

  final Suggestdatum data;

  @override
  State<FriendRequestCard> createState() => _FriendRequestCardState();
}

class _FriendRequestCardState extends State<FriendRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                "/otherprofile",
                arguments: {'userID': widget.data.id.toString()},
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:
                  widget.data.profileImage != ""
                      ? MyImageWidget(
                        imageUrl: widget.data.profileImage,
                        width: 75,
                        height: 75,
                        profilePic: true,
                      )
                      : Image.asset(
                        "assets/images/user.png",
                        width: 75,
                        height: 75,
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            "/otherprofile",
                            arguments: {'userID': widget.data.id.toString()},
                          );
                        },
                        child: Text(
                          '${widget.data.firstName} ${widget.data.lastName}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 5),
                    // SvgPicture.asset("assets/icons/verify.svg", width: 20),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        verticalPadding: 10,
                        fontsize: 12,
                        text: "Confirm",
                        onPressed: () async {
                          try {
                            final value = await MainService().confirmService(
                              friend_id: widget.data.id,
                              status: "accept",
                            );
                            if (value.status == "success") {
                              showGlobalSnackBar(message: value.msg);
                              context.read<FriendrequestlistBloc>().add(
                                FriendrequestlistTrigger(showLoading: false),
                              );
                              context.read<FriendlistBloc>().add(
                                FriendlistTrigger(),
                              );
                            } else {
                              showGlobalSnackBar(message: value.msg);
                            }
                          } catch (e) {
                            showGlobalSnackBar(
                              message: "Error: ${e.toString()}",
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        verticalPadding: 10,
                        fontsize: 12,
                        isOutlined: true,
                        text: "Delete",
                        onPressed: () async {
                          try {
                            // final value = await MainService()
                            //     .cancelfriendService(friend_id: widget.data.id);

                            final value = await MainService().confirmService(
                              friend_id: widget.data.id,
                              status: "reject",
                            );
                            if (value.status == "success") {
                              context.read<FriendrequestlistBloc>().add(
                                FriendrequestlistTrigger(showLoading: false),
                              );
                            } else {
                              showGlobalSnackBar(message: value.msg);
                            }
                          } catch (e) {
                            showGlobalSnackBar(
                              message: "Error: ${e.toString()}",
                            );
                          }
                        },
                      ),
                    ),
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
