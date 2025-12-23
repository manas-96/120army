import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global.dart';
import '../../model/listpost_model.dart';
import '../../services/date_time_zone.dart';
import '../../services/main_service.dart';
import '../../shared_pref.dart';
import 'cached_image.dart';

class Postdetailstext extends StatelessWidget {
  final int index;
  final PostlistDatum item;
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
