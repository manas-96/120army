// ignore_for_file: use_build_context_synchronously

import 'package:better_player_plus/better_player_plus.dart'; // ✅ added
import 'package:intl/intl.dart';
import '../exports.dart';
import '../global.dart';
import '../globalprogress.dart';
import '../services/main_service.dart';
import '../statemanagment/locationtagfriends/locationtagfriends_bloc.dart';

import 'widget/screenwidget/fullname_widget.dart';
import 'widget/screenwidget/privacydropdown_widget.dart';
import 'widget/screenwidget/profilepic_widget.dart';
import 'widget/toast.dart';

class Reelspost extends StatefulWidget {
  const Reelspost({super.key});

  @override
  State<Reelspost> createState() => _ReelspostState();
}

class _ReelspostState extends State<Reelspost> {
  late TextEditingController _postController = TextEditingController();
  File? _selectedVideo;
  BetterPlayerController? _betterController; // ✅ changed

  Future<void> _pickFromCamera() async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 2),
    );
    if (pickedFile != null) {
      await _initializeVideoController(File(pickedFile.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );
    if (pickedFile != null) {
      await _initializeVideoController(File(pickedFile.path));
    }
  }

  // ✅ replaced video_player controller with better_player_plus
  Future<void> _initializeVideoController(File file) async {
    try {
      _betterController?.dispose();

      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        file.path,
      );

      final controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          looping: false,
          aspectRatio: 9 / 16,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableFullscreen: true,
            enableSkips: false,
            enableOverflowMenu: false,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );

      setState(() {
        _selectedVideo = file;
        _betterController = controller;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading video: $e')));
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
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.videocam,
                                  size: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
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
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.video_library,
                                  size: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
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

  // ✅ replaced with BetterPlayer version
  Widget _buildVideoWithClose(File video, {double? width, double? height}) {
    if (_betterController == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: BetterPlayer(controller: _betterController!),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedVideo = null;
                  _betterController?.dispose();
                  _betterController = null;
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _betterController?.dispose(); // ✅ updated
    super.dispose();
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
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Create Clips",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_selectedVideo == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a video first')),
                );
                return;
              }

              final state = context.read<LocationtagfriendsBloc>().state;
              if (state is LocationtagfriendsLoaded) {
                final videoPath = _selectedVideo?.path;
                final renamedPath = await renameVideoFile(videoPath!);
                MainService()
                    .createpostService(
                      type: "reels",
                      filePaths: [renamedPath],
                      tagged_user_ids: state.targetFriends
                          .map((f) => f['id'])
                          .join(', '),
                      privacy: state.privacy.toLowerCase(),
                      location: state.userLocation.toString(),
                      post: _postController.text,
                      onProgress: (progress) {
                        reelsuploadProgress.value = progress;
                      },
                      notification_type: "reels",
                    )
                    .then((value) {
                      reelsuploadProgress.value = 101;
                    });
              }

              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          AlertDialog(
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  ValueListenableBuilder<double>(
                                    valueListenable: reelsuploadProgress,
                                    builder: (context, value, child) {
                                      if (value > 0 && value < 100) {
                                        return Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.7,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 80,
                                                      height: 80,
                                                      child:
                                                          CircularProgressIndicator(
                                                            value: value / 100,
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[300],
                                                            color:
                                                                kPrimaryColor,
                                                            strokeWidth: 6,
                                                          ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Image.asset(
                                                        "assets/images/square-logo.png",
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  "Posting...",
                                                  style: TextStyle(
                                                    fontSize: smallSize + 2,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "Keep 120 Army open.",
                                                  style: TextStyle(
                                                    fontSize: smallSize - 2,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if (value >= 100) {
                                        Navigator.of(context).pop();
                                        Future.delayed(Duration.zero, () {
                                          Navigator.of(
                                            context,
                                          ).pushNamed("/home?tab=1");
                                          showGlobalSnackBar(
                                            message: "Your post was shared.",
                                          );
                                          reelsuploadProgress.value = 0;
                                        });
                                        return const SizedBox.shrink();
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
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
              );
            },
            icon: const Icon(Icons.send),
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
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const ProfileImageWidget(size: 60),
                      ),
                      const SizedBox(width: 12),
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
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            const PrivacyDropdown(),
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
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                    ),
                  ),
                  if (_selectedVideo != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: _buildVideoWithClose(
                        _selectedVideo!,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: postBorderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomIcon(Icons.videocam, 'Videos'),
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

Future<String> renameVideoFile(String originalPath) async {
  final file = File(originalPath);
  final timestamp = DateFormat('yyyyMMdd_HHmmssSSS').format(DateTime.now());
  final newName = "reels_$timestamp.mp4";
  final dir = file.parent.path;
  final newPath = "$dir/$newName";
  final newFile = await file.copy(newPath);
  return newFile.path;
}
