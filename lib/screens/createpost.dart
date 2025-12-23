import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../exports.dart';
import '../global.dart';
import '../globalprogress.dart';
import '../services/main_service.dart';
import '../statemanagment/locationtagfriends/locationtagfriends_bloc.dart';
import 'widget/screenwidget/fullname_widget.dart';
import 'widget/screenwidget/privacydropdown_widget.dart';
import 'widget/screenwidget/profilepic_widget.dart';

class Createpost extends StatefulWidget {
  const Createpost({super.key});

  @override
  State<Createpost> createState() => _CreatepostState();
}

class _CreatepostState extends State<Createpost> {
  late TextEditingController _postController = TextEditingController();
  final List<File> _selectedImages = [];

  Future<File?> _compressImage(String path) async {
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      path,
      "${path}_compressed.jpg",
      quality: 75,
      minWidth: 800,
      minHeight: 800,
    );
    return compressedImage != null ? File(compressedImage.path) : null;
  }

  Future<void> _pickFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      final compressed = await _compressImage(pickedFile.path);
      if (compressed != null) {
        setState(() {
          _selectedImages.add(compressed);
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        final compressed = await _compressImage(file.path);
        if (compressed != null) {
          setState(() {
            _selectedImages.add(compressed);
          });
        }
      }
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder:
          (_) => SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                top: kDefaultPadding,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _pickFromCamera();
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const Text('Camera'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _pickFromGallery();
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  size: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const Text('Gallery'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildImageWithClose(
    File image,
    int index, {
    double? width,
    double? height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: _showAllImagesModal,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: FileImage(image), fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImages.removeAt(index);
                });
              },
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAllImagesModal() {
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
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _selectedImages[index],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.removeAt(index);
                                          });
                                          modalSetState(() {
                                            if (_selectedImages.isEmpty) {
                                              Navigator.of(context).pop();
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

  @override
  void initState() {
    super.initState();
    context.read<LocationtagfriendsBloc>().add(UpdateUserLocation(''));
    context.read<LocationtagfriendsBloc>().add(UpdateTargetFriends([]));
    _postController = HighlightController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Create Prayer Post",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final state = context.read<LocationtagfriendsBloc>().state;
              if (state is LocationtagfriendsLoaded) {
                final imagePaths =
                    _selectedImages.map((file) => file.path).toList();

                MainService()
                    .createpostService(
                      type: "post",
                      filePaths: imagePaths,
                      tagged_user_ids: state.targetFriends
                          .map((f) => f['id'])
                          .join(', '),
                      privacy: state.privacy.toLowerCase(),
                      location: state.userLocation.toString(),
                      post: _postController.text,
                      onProgress: (progress) {
                        uploadProgress.value = progress;
                        // print(
                        //   "Upload progress: ${(progress).toStringAsFixed(0)}%",
                        // );
                      },
                      notification_type: "post",
                    )
                    .then((value) {
                      uploadProgress.value = 101;
                    });
              }

              Navigator.of(context).pop();
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ProfileImageWidget(size: 60),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<
                              LocationtagfriendsBloc,
                              LocationtagfriendsState
                            >(
                              builder: (context, state) {
                                return RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: paraFont,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      WidgetSpan(
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.alphabetic,
                                        child: FullNameWidget(
                                          style: TextStyle(
                                            fontSize: paraFont,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (state
                                          is LocationtagfriendsLoaded) ...[
                                        if (state.userLocation != null &&
                                            state.userLocation != "")
                                          TextSpan(
                                            text:
                                                " - in ${state.userLocation!}",
                                            style: TextStyle(
                                              fontSize: paraFont,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        if (state.targetFriends.isNotEmpty)
                                          TextSpan(
                                            text: () {
                                              final first =
                                                  state
                                                      .targetFriends
                                                      .first["name"] ??
                                                  "";
                                              final others =
                                                  state.targetFriends.length -
                                                  1;
                                              if (others == 0) {
                                                return " - with $first";
                                              } else if (others == 1) {
                                                return " - with $first and 1 others";
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
                                    ],
                                  ),
                                  maxLines: null,
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.start,
                                );
                              },
                            ),
                            Gap(10),
                            PrivacyDropdown(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _postController,
                    minLines: 1,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                    ),
                  ),

                  if (_selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: Builder(
                        builder: (context) {
                          final extraCount =
                              _selectedImages.length > 3
                                  ? _selectedImages.length - 3
                                  : 0;

                          if (_selectedImages.length == 1) {
                            return _buildImageWithClose(
                              _selectedImages[0],
                              0,
                              width: double.infinity,
                              height: 300,
                            );
                          }

                          if (_selectedImages.length == 2) {
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildImageWithClose(
                                    _selectedImages[0],
                                    0,
                                    height: 300,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildImageWithClose(
                                    _selectedImages[1],
                                    1,
                                    height: 300,
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
                                      _selectedImages[0],
                                      0,
                                      height: totalHeight,
                                    ),
                                  ),
                                  StaggeredGridTile.fit(
                                    crossAxisCellCount: 1,
                                    child: SizedBox(
                                      height: halfHeight,
                                      child: _buildImageWithClose(
                                        _selectedImages[1],
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
                                            _selectedImages[2],
                                            2,
                                            width: double.infinity,
                                          ),
                                          if (extraCount > 0)
                                            GestureDetector(
                                              onTap: _showAllImagesModal,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "+$extraCount",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
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
                  ],
                ],
              ),
            ),
          ),

          // Gap(100),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: postBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomIcon(Icons.image, 'Photos'),
                  _bottomIcon(Icons.person_add_alt_1, 'Tag people'),
                  _bottomIcon(Icons.location_on, 'Location'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Location") {
          Navigator.of(context).pushNamed("/maplist");
        } else if (label == "Tag people") {
          final state = context.read<LocationtagfriendsBloc>().state;
          if (state is LocationtagfriendsLoaded) {
            Navigator.of(context).pushNamed(
              "/tagfriends",
              arguments: {"realDataList": state.targetFriends},
            );
          }
          // Navigator.of(context).pushNamed("/tagfriends");
        } else {
          _showPickerOptions();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kPrimaryColor),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class HighlightController extends TextEditingController {
  final RegExp urlRegex = RegExp(
    r'((https?:\/\/|www\.)[^\s]+)',
    caseSensitive: false,
  );
  final RegExp hashtagRegex = RegExp(r'#[\w]+');

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<InlineSpan> children = [];
    final text = value.text;

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
            style: style,
          ),
        );
      }
      children.add(
        TextSpan(
          text: m.match.group(0),
          style: style?.copyWith(color: m.color),
        ),
      );
      lastIndex = m.match.end;
    }

    if (lastIndex < text.length) {
      children.add(TextSpan(text: text.substring(lastIndex), style: style));
    }

    return TextSpan(style: style, children: children);
  }
}

class _Match {
  final RegExpMatch match;
  final Color color;
  _Match(this.match, this.color);
}
