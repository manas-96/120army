import 'package:onetwentyarmyprayer2/global.dart';
import '../../exports.dart';
import '../../model/commentlist_model.dart';
import '../../services/main_service.dart';
import '../../statemanagment/commentlist/commentlist_bloc.dart';

class Likecommentshare extends StatefulWidget {
  const Likecommentshare({
    super.key,
    required this.postid,
    required this.commentcount,
    required this.likescount,
    required this.isLiked,
    required this.onLikeToggle,
    this.reels = false,
    required this.main_post_id,
    // required this.parent_type,
    required this.author_id,
  });

  final String postid;
  final int commentcount;
  final int likescount;
  final int isLiked;
  final VoidCallback onLikeToggle;
  final bool reels;
  final String main_post_id;
  // final String parent_type;
  final String author_id;

  @override
  State<Likecommentshare> createState() => _LikecommentshareState();
}

class _LikecommentshareState extends State<Likecommentshare> {
  bool isLiked = false;
  bool isPosting = false;

  @override
  Widget build(BuildContext context) {
    // If reels is true, show vertical layout on right side
    if (widget.reels) {
      return Container(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Like for reels
            Column(
              children: [
                InkWell(
                  onTap: widget.onLikeToggle,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          widget.isLiked == 1
                              ? 'assets/icons/pray_filled.svg'
                              : 'assets/icons/pray_outline.svg',
                          width: 28,
                          colorFilter: ColorFilter.mode(
                            widget.isLiked == 1 ? kPrimaryColor : Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.likescount > 0 ? "${widget.likescount}" : "0",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Comment for reels
            Column(
              children: [
                InkWell(
                  onTap: () {
                    _showCommentBottomSheet(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/chat.svg',
                          width: 28,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.commentcount > 0
                              ? "${widget.commentcount}"
                              : "0",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Share for reels
            Column(
              children: [
                InkWell(
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            'Someone just shared a prayer post on 120 Army! ✝️ Be a part of the praying movement—download the app today.📲 https://120army.com/download',
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/share.svg',
                          width: 26,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Spread",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Original horizontal layout for non-reels
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Like
          InkWell(
            onTap: widget.onLikeToggle,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.isLiked == 1
                        ? 'assets/icons/pray_filled.svg'
                        : 'assets/icons/pray_outline.svg',
                    width: 22,
                    colorFilter: ColorFilter.mode(
                      widget.isLiked == 1 ? kPrimaryColor : Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 3),
                  widget.likescount > 0
                      ? Text("${widget.likescount} Amen")
                      : const Text("Amen"),
                ],
              ),
            ),
          ),

          // Comment
          InkWell(
            onTap: () {
              _showCommentBottomSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/chat.svg',
                    width: 25,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 3),
                  widget.commentcount > 0
                      ? Text("${widget.commentcount} Comment")
                      : const Text("Comment"),
                ],
              ),
            ),
          ),

          // Share
          InkWell(
            onTap: () {
              SharePlus.instance.share(
                ShareParams(
                  text:
                      'Someone just shared a prayer post on 120 Army! ✝️ Be a part of the praying movement—download the app today.📲 https://120army.com/download',
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/share.svg',
                    width: 22,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text("Spread"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    // 🔹 API call trigger
    context.read<CommentlistBloc>().add(
      CommentlistTrigger(postid: widget.postid),
    );

    final FocusNode focusNode = FocusNode();
    final TextEditingController commentController = TextEditingController();

    // ✅ reply state declare outside StatefulBuilder so it won't reset
    String replyToUsername = '';
    String currentParentId = widget.postid;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              // Function to handle reply
              void handleReply(String username, String parentId) {
                setModalState(() {
                  replyToUsername = username;
                  currentParentId = parentId;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  focusNode.requestFocus();
                });
              }

              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                minChildSize: 0.4,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Column(
                    children: [
                      // 🔹 Comment tree list
                      Expanded(
                        child: BlocBuilder<CommentlistBloc, CommentlistState>(
                          builder: (context, state) {
                            if (state is CommentlistLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                              );
                            } else if (state is CommentlistLoaded) {
                              final comments = state.model.data;

                              return ListView(
                                controller: scrollController,
                                children:
                                    comments
                                        .map(
                                          (c) => buildComment(
                                            c,
                                            onReply: (username, parentId) {
                                              handleReply(username, parentId);
                                            },
                                          ),
                                        )
                                        .toList(),
                              );
                            } else if (state is CommentlistError) {
                              return Center(child: Text(state.error));
                            } else {
                              return const Center(
                                child: Text("Something went wrong"),
                              );
                            }
                          },
                        ),
                      ),

                      // Input field with mention display
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              if (replyToUsername.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Replying to ",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        replyToUsername,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.close, size: 16),
                                        onPressed: () {
                                          setModalState(() {
                                            replyToUsername = '';
                                            currentParentId = widget.postid;
                                            commentController.clear();
                                            focusNode.unfocus();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: commentController,
                                      focusNode: focusNode,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: "Write a comment...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed:
                                        isPosting
                                            ? null
                                            : () async {
                                              if (commentController
                                                  .text
                                                  .isNotEmpty) {
                                                setModalState(() {
                                                  isPosting =
                                                      true; // loader শুরু
                                                });

                                                final service = MainService();
                                                final value = await service
                                                    .commentpostService(
                                                      post:
                                                          commentController
                                                              .text,
                                                      parent_post_id:
                                                          currentParentId,
                                                      author_id:
                                                          widget.author_id,
                                                      main_post_id:
                                                          widget.main_post_id,
                                                      parent_type:
                                                          widget.reels == false
                                                              ? "post"
                                                              : "reels",
                                                      notification_type:
                                                          widget.reels == false
                                                              ? "post"
                                                              : "reels",
                                                    );

                                                if (value != null &&
                                                    value.status == "success") {
                                                  setModalState(() {
                                                    replyToUsername = '';
                                                    currentParentId =
                                                        widget.postid;
                                                    commentController.clear();
                                                    focusNode.unfocus();
                                                  });

                                                  context
                                                      .read<CommentlistBloc>()
                                                      .add(
                                                        CommentlistTrigger(
                                                          postid: widget.postid,
                                                          showLoading: false,
                                                        ),
                                                      );
                                                }

                                                // ✅ শেষে loader বন্ধ
                                                setModalState(() {
                                                  isPosting = false;
                                                });
                                              }
                                            },
                                    icon:
                                        isPosting
                                            ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: kPrimaryColor,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Icon(
                                              Icons.send,
                                              color: kPrimaryColor,
                                            ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  // 🔹 Recursive builder with parentName
  Widget buildComment(
    Commentlist comment, {
    int level = 0,
    Function(String, String)? onReply,
    String? parentName,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: level > 1 && level <= 3 ? 20.0 : 0,
        top: 5,
        bottom: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  comment.profileImage != ""
                      ? NetworkImage(comment.profileImage!)
                      : null,
              child:
                  comment.profileImage == "" ? const Icon(Icons.person) : null,
            ),
            title: Text(comment.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.post),
                if (parentName != null)
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Replying to: ",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        TextSpan(
                          text: parentName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Gap(10),

                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ), // 👈 এখানে পরিবর্তন
                    minimumSize: Size.zero, // 👈 default min size বাদ দিতে
                    tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap, // 👈 ripple area ছোট করার জন্য
                  ),
                  onPressed: () {
                    if (onReply != null) {
                      // print(comment.id);
                      onReply(comment.name, comment.id.toString());
                    }
                  },
                  child: const Text("Reply"),
                ),
              ],
            ),
          ),

          if (comment.replies.isNotEmpty)
            Column(
              children:
                  comment.replies
                      .map(
                        (reply) => buildComment(
                          reply,
                          level: level + 1,
                          onReply: onReply,
                          parentName: comment.name,
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}
