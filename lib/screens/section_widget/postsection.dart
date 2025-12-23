import '../../exports.dart';
import '../../global.dart';
import '../../model/listpost_model.dart';
import '../../services/main_service.dart';

import '../widget/cached_image.dart';
import '../widget/likecommentshare.dart';
import '../widget/postdetailstext.dart';

class Postsection extends StatefulWidget {
  const Postsection({
    super.key,
    required this.index,
    required this.item,
    required this.onDelete,
  });

  final int index;
  final PostlistDatum item;
  final VoidCallback onDelete;

  @override
  State<Postsection> createState() => _PostsectionState();
}

class _PostsectionState extends State<Postsection> {
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
                                  imageUrl: item[index].fileUrls,
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
    return Container(
      decoration: BoxDecoration(
        border:
            widget.index >= 1
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
            child: Postdetailstext(
              index: widget.index,
              item: widget.item,
              onDelete: widget.onDelete,
            ),
          ),

          if (widget.item.files.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                _showAllImagesModal(widget.item.files);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: widget.item.files.length == 1 ? 300 : 300,
                child: Builder(
                  builder: (context) {
                    final extraCount =
                        widget.item.files.length > 3
                            ? widget.item.files.length - 3
                            : 0;

                    if (widget.item.files.length == 1) {
                      return _buildImageWithClose(
                        widget.item.files[0].fileUrls,
                        0,
                        width: double.infinity,
                        height: 300,
                      );
                    }

                    if (widget.item.files.length == 2) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildImageWithClose(
                              widget.item.files[0].fileUrls,
                              0,
                              height: 200,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildImageWithClose(
                              widget.item.files[1].fileUrls,
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
                                widget.item.files[0].fileUrls,
                                0,
                                height: totalHeight,
                              ),
                            ),
                            StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: SizedBox(
                                height: halfHeight,
                                child: _buildImageWithClose(
                                  widget.item.files[1].fileUrls,
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
                                      widget.item.files[2].fileUrls,
                                      2,
                                      width: double.infinity,
                                    ),
                                    if (extraCount > 0)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            0,
                                          ),
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
            postid: widget.item.id.toString(),
            commentcount: widget.item.commentCount,
            likescount: widget.item.likes,
            isLiked: widget.item.isLiked,
            author_id: widget.item.userId.toString(),
            main_post_id: widget.item.id.toString(),
            onLikeToggle: () async {
              if (isLiking) return; // যদি আগে tap হয়ে থাকে, ignore করো
              setState(() => isLiking = true); // lock

              final currentLiked = widget.item.isLiked == 1; // 1 = liked

              try {
                final response = await MainService().likeunlikeService(
                  id: widget.item.id,
                  isLiked: currentLiked,
                  author_id: widget.item.userId.toString(),
                  type: "post",
                  author_name: widget.item.name,
                );

                // API success হলে update করো
                if (response?.status == "success") {
                  setState(() {
                    widget.item.isLiked = currentLiked ? 0 : 1;
                    widget.item.likes += currentLiked ? -1 : 1;
                  });
                }
              } finally {
                // একদম শেষে unlock
                if (mounted) setState(() => isLiking = false);
              }
            },
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
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
