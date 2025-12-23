import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../exports.dart';
import '../../global.dart';
import '../../services/main_service.dart';
import '../model/pushpost_model.dart';
import '../services/date_time_zone.dart';
import '../shared_pref.dart';
import 'widget/cached_image.dart';
import 'widget/likecommentshare.dart';

class Separatepushpost extends StatefulWidget {
  const Separatepushpost({super.key, required this.post_id});

  final String post_id;

  @override
  State<Separatepushpost> createState() => _SeparatepushpostState();
}

class _SeparatepushpostState extends State<Separatepushpost> {
  Pushdata? post; // ❌ old: Pushdata postList = {};  ✔️ new: nullable object

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final res = await MainService().viewpostService(post_id: widget.post_id);

    if (mounted) {
      setState(() {
        post = res.data; // ✔️ single object
      });
    }
  }

  /// DELETE POST
  void _deletePost() {
    setState(() {
      post = null; // ✔️ Removing the single object
    });
  }

  /// SHOW ALL IMAGES BOTTOM SHEET
  void _showAllImagesModal(item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(-15, 0),
                    child: BackButton(color: kPrimaryColor),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MyImageWidget(
                            imageUrl: item[index].fileUrls,
                            radiusVal: 0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool isLiking = false;

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    if (post == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final item = post!; // ✔ single item

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: EdgeInsets.only(
                top: kDefaultPadding,
                left: kDefaultPadding - 5,
                right: kDefaultPadding - 5,
                bottom: 15,
              ),
              child: Postdetailstext(
                index: 0,
                item: item,
                onDelete: () => _deletePost(),
              ),
            ),

            if (item.type != "reels") ...[
              if (item.files.isNotEmpty)
                GestureDetector(
                  onTap: () => _showAllImagesModal(item.files),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 300,
                    child: Builder(
                      builder: (_) {
                        final extraCount =
                            item.files.length > 3 ? item.files.length - 3 : 0;

                        if (item.files.length == 1) {
                          return _buildImage(item.files[0].fileUrls, 300);
                        }

                        if (item.files.length == 2) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildImage(item.files[0].fileUrls, 200),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: _buildImage(item.files[1].fileUrls, 200),
                              ),
                            ],
                          );
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final totalHeight = constraints.maxHeight;
                            final halfHeight = (totalHeight - 4) / 2;

                            return StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              children: [
                                StaggeredGridTile.fit(
                                  crossAxisCellCount: 1,
                                  child: _buildImage(
                                    item.files[0].fileUrls,
                                    totalHeight,
                                  ),
                                ),
                                StaggeredGridTile.fit(
                                  crossAxisCellCount: 1,
                                  child: SizedBox(
                                    height: halfHeight,
                                    child: _buildImage(
                                      item.files[1].fileUrls,
                                      halfHeight,
                                    ),
                                  ),
                                ),
                                StaggeredGridTile.fit(
                                  crossAxisCellCount: 1,
                                  child: SizedBox(
                                    height: halfHeight,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        _buildImage(
                                          item.files[2].fileUrls,
                                          halfHeight,
                                        ),
                                        if (extraCount > 0)
                                          Container(
                                            color: Colors.black54,
                                            child: Center(
                                              child: Text(
                                                "+$extraCount",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
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
                  ),
                ),
            ],

            if (item.type == "reels" && item.files.isNotEmpty) ...[
              Container(
                height: 400,
                width: double.infinity,
                color: Colors.black,
                child: BetterPlayer.network(
                  item.files[0].fileUrls,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                    autoPlay: true,
                    looping: true,
                    aspectRatio: 9 / 16,
                    allowedScreenSleep: false,
                    controlsConfiguration:
                        const BetterPlayerControlsConfiguration(
                          showControls: true,
                          enableSkips: false,
                          enableFullscreen: true,
                        ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // LIKE & COMMENT
            Likecommentshare(
              postid: item.id.toString(),
              commentcount: item.commentCount,
              likescount: item.likes,
              isLiked: item.isLiked,
              author_id: item.userId.toString(),
              main_post_id: item.id.toString(),
              onLikeToggle: () async {
                if (isLiking) return;
                setState(() => isLiking = true);

                final currentLiked = item.isLiked == 1;

                try {
                  final res = await MainService().likeunlikeService(
                    id: item.id,
                    isLiked: currentLiked,
                    author_id: item.userId.toString(),
                    type: item.type != "reels" ? "post" : "reels",
                    author_name: item.name,
                  );

                  if (res?.status == "success") {
                    setState(() {
                      item.isLiked = currentLiked ? 0 : 1;
                      item.likes += currentLiked ? -1 : 1;
                    });
                  }
                } finally {
                  if (mounted) setState(() => isLiking = false);
                }
              },
            ),

            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String image, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: MyImageWidget(imageUrl: image, radiusVal: 0),
      ),
    );
  }
}

class Postdetailstext extends StatelessWidget {
  final int index;
  final Pushdata item;
  final VoidCallback onDelete;
  final bool reele; // true হলে white text

  const Postdetailstext({
    super.key,
    required this.index,
    required this.item,
    required this.onDelete,
    this.reele = false,
  });

  Color get textColor => reele ? Colors.white : Colors.black;
  Color get subTextColor => reele ? Colors.white70 : Colors.grey[600]!;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          reele == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Profile Row ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.ownPost == false) {
                        Navigator.of(context).pushNamed(
                          "/otherprofile",
                          arguments: {'userID': item.userId.toString()},
                        );
                      } else {
                        Navigator.of(context).pushNamed("/profile");
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: MyImageWidget(imageUrl: item.profileImage),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: reele ? 25 : 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: getFullName(),
                            builder: (context, asyncSnapshot) {
                              final fullname = asyncSnapshot.data ?? "";
                              return RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          item.ownPost == true
                                              ? fullname
                                              : item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              if (item.ownPost == false) {
                                                Navigator.of(context).pushNamed(
                                                  "/otherprofile",
                                                  arguments: {
                                                    'userID':
                                                        item.userId.toString(),
                                                  },
                                                );
                                              } else {
                                                Navigator.of(
                                                  context,
                                                ).pushNamed("/profile");
                                              }
                                            },
                                    ),
                                    if (item.location.isNotEmpty)
                                      TextSpan(
                                        text: " - in ${item.location}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    if (item.taggedUsers.isNotEmpty)
                                      TextSpan(
                                        text: () {
                                          final first =
                                              item.taggedUsers[0].name;
                                          final others =
                                              item.taggedUsers.length - 1;
                                          if (others == 0) {
                                            return " - with $first";
                                          } else if (others == 1) {
                                            return " - with $first and 1 other";
                                          } else {
                                            return " - with $first and $others others";
                                          }
                                        }(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                DateTimeHelper.formatToLocal(
                                  item.createdAt.toString(),
                                ),
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // --- Post Text ---
              if (item.post.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 10, right: reele ? 40 : 0),
                  child: _buildExpandableText(item.post),
                ),
            ],
          ),
        ),
        if (item.ownPost == true)
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                context: context,
                builder:
                    (_) => Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 40,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onDelete();
                          MainService().deletepostService(id: item.id).then((
                            value,
                          ) {
                            print("Server delete: ${value?.msg}");
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.delete, color: kPrimaryColor),
                            SizedBox(width: 5),
                            Text("Delete Post"),
                          ],
                        ),
                      ),
                    ),
              );
            },
            icon: Icon(
              Icons.more_horiz,
              color: reele ? Colors.white : Colors.black,
            ),
          ),
      ],
    );
  }

  Widget _buildExpandableText(String text) {
    return _ExpandableText(text: text, reele: reele);
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  final bool reele;
  const _ExpandableText({required this.text, this.reele = false});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    final displayText =
        _expanded
            ? text
            : (text.length > 200 ? "${text.substring(0, 200)}...  " : text);

    final Color textColor = widget.reele ? Colors.white : Colors.black;
    final Color seeMoreColor = widget.reele ? Colors.white70 : Colors.grey;

    return RichText(
      text: TextSpan(
        style: TextStyle(color: textColor, fontSize: 16, height: 1.5),
        children: [
          ..._parseText(displayText, textColor, context),
          if (text.length > 200)
            TextSpan(
              text: _expanded ? " See less" : " See more",
              style: TextStyle(
                color: seeMoreColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
            ),
        ],
      ),
    );
  }

  List<TextSpan> _parseText(
    String text,
    Color textColor,
    BuildContext context,
  ) {
    final RegExp exp = RegExp(
      r"(https?:\/\/[^\s]+|#[\w]+)",
      caseSensitive: false,
    );
    final List<TextSpan> spans = [];
    int start = 0;

    exp.allMatches(text).forEach((match) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: TextStyle(color: textColor),
          ),
        );
      }

      final String matchText = match.group(0)!;

      if (matchText.startsWith("#")) {
        // Hashtag style
        spans.add(
          TextSpan(
            text: matchText,
            style: const TextStyle(color: Colors.blue),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    print("Tapped hashtag: $matchText");
                    // এখানে hashtag এ ক্লিক করলে অন্য স্ক্রিনে নিতে পারো
                  },
          ),
        );
      } else {
        // URL style
        spans.add(
          TextSpan(
            text: matchText,
            style: const TextStyle(color: Colors.blue),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () async {
                    final Uri url = Uri.parse(matchText);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
          ),
        );
      }

      start = match.end;
    });

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(color: textColor),
        ),
      );
    }

    return spans;
  }
}
