import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../exports.dart';
import '../../global.dart';
import '../../model/other_profile_model.dart';
import '../../services/date_time_zone.dart';
import '../../services/main_service.dart';
import '../../shared_pref.dart';
import '../../statemanagment/homewalllist/homewalllist_bloc.dart';
import '../widget/cached_image.dart';
import '../widget/likecommentshare.dart';

class OthersPostswidget extends StatefulWidget {
  const OthersPostswidget({super.key, required this.postData});

  final List<PostDatum>? postData;

  @override
  State<OthersPostswidget> createState() => _OthersPostswidgetState();
}

class _OthersPostswidgetState extends State<OthersPostswidget> {
  void _showAllImagesModal(List<FileElement> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 1.0,
              minChildSize: 0.5,
              maxChildSize: 1.0,
              builder:
                  (_, controller) => Padding(
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
                                  imageUrl: item[index].fileUrls!,
                                  radiusVal: 0,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.postData!.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border:
                index >= 1
                    ? Border(top: BorderSide(width: 4, color: postBorderColor))
                    : null,
          ),
          child: Column(
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding - 5,
                  right: kDefaultPadding - 5,
                  bottom: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Profile Row ---
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  String? currentUserId =
                                      SharedPrefUtils.getCachedStr("user_id");
                                  currentUserId ??=
                                      await SharedPrefUtils.readPrefStr(
                                        "user_id",
                                      );

                                  final tappedUserId =
                                      widget.postData![index].userId.toString();

                                  if (currentUserId == tappedUserId) {
                                    // নিজের প্রোফাইলে যাবে
                                    Navigator.of(context).pushNamed("/profile");
                                  } else {
                                    // অন্যের প্রোফাইলে যাবে
                                    Navigator.of(context).pushNamed(
                                      "/otherprofile",
                                      arguments: {'userID': tappedUserId,},
                                    );
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
                                    child: MyImageWidget(
                                      imageUrl:
                                          widget.postData![index].profileImage!,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                      future: getFullName(),
                                      builder: (context, asyncSnapshot) {
                                        return RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: paraFont,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    widget
                                                        .postData![index]
                                                        .name,
                                                style: TextStyle(
                                                  fontSize: paraFont,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        String? currentUserId =
                                                            SharedPrefUtils.getCachedStr(
                                                              "user_id",
                                                            );
                                                        currentUserId ??=
                                                            await SharedPrefUtils.readPrefStr(
                                                              "user_id",
                                                            );

                                                        final tappedUserId =
                                                            widget
                                                                .postData![index]
                                                                .userId
                                                                .toString();

                                                        if (currentUserId ==
                                                            tappedUserId) {
                                                          // নিজের প্রোফাইলে যাবে
                                                          Navigator.of(
                                                            context,
                                                          ).pushNamed(
                                                            "/profile",
                                                          );
                                                        } else {
                                                          // অন্যের প্রোফাইলে যাবে
                                                          Navigator.of(
                                                            context,
                                                          ).pushNamed(
                                                            "/otherprofile",
                                                            arguments: {
                                                              'userID':
                                                                  tappedUserId,
                                                            },
                                                          );
                                                        }
                                                      },
                                              ),
                                              if (widget
                                                      .postData![index]
                                                      .location !=
                                                  "")
                                                TextSpan(
                                                  text:
                                                      " - in ${widget.postData![index].location}",
                                                  style: TextStyle(
                                                    fontSize: paraFont,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              if (widget
                                                  .postData![index]
                                                  .taggedUsers!
                                                  .isNotEmpty)
                                                TextSpan(
                                                  text: () {
                                                    final first =
                                                        widget
                                                            .postData![index]
                                                            .taggedUsers![0]
                                                            .name;
                                                    final others =
                                                        widget
                                                            .postData![index]
                                                            .taggedUsers!
                                                            .length -
                                                        1;
                                                    if (others == 0) {
                                                      return " - with $first";
                                                    } else if (others == 1) {
                                                      return " - with $first and 1 other";
                                                    } else {
                                                      return " - with $first and $others others";
                                                    }
                                                  }(),
                                                  style: TextStyle(
                                                    fontSize: paraFont,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          maxLines: null,
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.start,
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          DateTimeHelper.formatToLocal(
                                            widget.postData![index].createdAt
                                                .toString(),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: textGrayColor,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SvgPicture.asset(
                                          'assets/icons/world.svg',
                                          width: 16,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        FutureBuilder(
                          future: SharedPrefUtils.readPrefStr("user_id"),
                          builder: (context, snapshot) {
                            final currentUserId = snapshot.data;
                            final tappedUserId =
                                widget.postData![index].userId.toString();

                            if (currentUserId == tappedUserId) {
                              // ✅ শুধু নিজের পোস্ট হলে IconButton দেখাবে
                              return IconButton(
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
                                            onTap: () async {
                                              Navigator.pop(context);

                                              // ✅ ২️⃣ — তারপর ব্যাকএন্ডে delete API কল করো (background এ)
                                              await MainService()
                                                  .deletepostService(
                                                    id:
                                                        widget
                                                            .postData![index]
                                                            .id,
                                                  );
                                              // ✅ ১️⃣ — UI থেকে সাথে সাথে মুছে ফেলো
                                              setState(() {
                                                widget.postData!.removeAt(
                                                  index,
                                                );
                                              });
                                              context
                                                  .read<HomewalllistBloc>()
                                                  .add(
                                                    const HomewalllistFetch(1),
                                                  );
                                            },
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.delete,
                                                  color: kPrimaryColor,
                                                ),
                                                SizedBox(width: 5),
                                                Text("Delete Post"),
                                              ],
                                            ),
                                          ),
                                        ),
                                  );
                                },

                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              // 🔹 অন্য কারো পোস্ট হলে কিছুই দেখাবে না
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),

                    // --- Post Text ---
                    if (widget.postData![index].post!.isNotEmpty)
                      Column(
                        children: [
                          const Gap(15),
                          _buildText(widget.postData![index].post!, context),
                        ],
                      ),
                  ],
                ),
              ),

              if (widget.postData![index].files!.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    _showAllImagesModal(widget.postData![index].files!);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height:
                        widget.postData![index].files!.length == 1 ? 300 : 300,
                    child: Builder(
                      builder: (context) {
                        final extraCount =
                            widget.postData![index].files!.length > 3
                                ? widget.postData![index].files!.length - 3
                                : 0;

                        if (widget.postData![index].files!.length == 1) {
                          return _buildImageWithClose(
                            widget.postData![index].files![0].fileUrls!,
                            0,
                            width: double.infinity,
                            height: 300,
                          );
                        }

                        if (widget.postData![index].files!.length == 2) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildImageWithClose(
                                  widget.postData![index].files![0].fileUrls!,
                                  0,
                                  height: 200,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildImageWithClose(
                                  widget.postData![index].files![1].fileUrls!,
                                  1,
                                  height: 200,
                                ),
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
                                  child: _buildImageWithClose(
                                    widget.postData![index].files![0].fileUrls!,
                                    0,
                                    height: totalHeight,
                                  ),
                                ),
                                StaggeredGridTile.fit(
                                  crossAxisCellCount: 1,
                                  child: SizedBox(
                                    height: halfHeight,
                                    child: _buildImageWithClose(
                                      widget
                                          .postData![index]
                                          .files![1]
                                          .fileUrls!,
                                      1,
                                      width: double.infinity,
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
                                        _buildImageWithClose(
                                          widget
                                              .postData![index]
                                              .files![2]
                                              .fileUrls!,
                                          2,
                                          width: double.infinity,
                                        ),
                                        if (extraCount > 0)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
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

              const SizedBox(height: 16),

              // --- Like / Comment / Share ---
              Likecommentshare(
                postid: widget.postData![index].id.toString(),
                commentcount: widget.postData![index].commentCount!,
                likescount: widget.postData![index].likes!,
                author_id: widget.postData![index].userId.toString(),
                main_post_id: widget.postData![index].id.toString(),
                isLiked:
                    widget.postData![index].isLiked ?? 0, // int pass korchi
                onLikeToggle: () async {
                  if (isLiking) return; // rapid tap ignore
                  setState(() => isLiking = true);

                  final currentLiked = widget.postData![index].isLiked == 1;

                  try {
                    final response = await MainService().likeunlikeService(
                      id: widget.postData![index].id!,
                      isLiked: currentLiked,
                      author_id: widget.postData![index].userId.toString(),
                      type: "post",
                      author_name: widget.postData![index].name!,
                    );

                    if (response?.status == "success") {
                      setState(() {
                        widget.postData![index].isLiked = currentLiked ? 0 : 1;
                        widget.postData![index].likes =
                            currentLiked
                                ? (widget.postData![index].likes ?? 0) - 1
                                : (widget.postData![index].likes ?? 0) + 1;
                      });
                    }
                  } finally {
                    Future.delayed(const Duration(milliseconds: 400), () {
                      if (mounted) setState(() => isLiking = false);
                    });
                  }
                },
              ),

              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}

/// ------------------------
/// TEXT BUILD WITH EXPAND
/// ------------------------
Widget _buildText(String text, BuildContext context) {
  return _ExpandableText(text: text);
}

class _ExpandableText extends StatefulWidget {
  final String text;
  const _ExpandableText({required this.text});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final displayText =
        _expanded
            ? widget.text
            : (widget.text.length > 350
                ? "${widget.text.substring(0, 350)}...  "
                : widget.text);

    return RichText(
      text: TextSpan(
        children: [
          _buildSpans(displayText, context),
          if (widget.text.length > 350)
            TextSpan(
              text: _expanded ? " See less" : " See more",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
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

  TextSpan _buildSpans(String text, BuildContext context) {
    final RegExp urlRegex = RegExp(
      r'((https?:\/\/|www\.)[^\s]+)',
      caseSensitive: false,
    );
    final RegExp hashtagRegex = RegExp(r'#[\w]+');

    final List<InlineSpan> children = [];
    int lastIndex = 0;

    final matches = [
      ...urlRegex.allMatches(text).map((m) => _Match(m, kPrimaryColor)),
      ...hashtagRegex.allMatches(text).map((m) => _Match(m, Colors.blue)),
    ]..sort((a, b) => a.match.start.compareTo(b.match.start));

    for (final m in matches) {
      if (m.match.start > lastIndex) {
        children.add(
          TextSpan(
            text: text.substring(lastIndex, m.match.start),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }

      if (urlRegex.hasMatch(m.match.group(0)!)) {
        children.add(
          TextSpan(
            text: m.match.group(0),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: m.color),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () async {
                    String url = m.match.group(0)!;
                    if (!url.startsWith('http')) url = 'https://$url';
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
          ),
        );
      } else {
        children.add(
          TextSpan(
            text: m.match.group(0),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: m.color),
          ),
        );
      }

      lastIndex = m.match.end;
    }

    if (lastIndex < text.length) {
      children.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return TextSpan(children: children);
  }
}

class _Match {
  final RegExpMatch match;
  final Color color;
  _Match(this.match, this.color);
}

Widget _buildImageWithClose(
  String image,
  int index, {
  double? width,
  double? height,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(0),
    child: SizedBox(
      width: width,
      height: height,
      child: MyImageWidget(imageUrl: image, radiusVal: 0),
    ),
  );
}
