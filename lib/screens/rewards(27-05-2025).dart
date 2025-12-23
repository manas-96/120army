import '../audio_service.dart';
import '../exports.dart';
import '../global.dart';
import '../model/reward_tasklist_model.dart';
import '../shimmerloader/edit_profile_loader.dart';
import '../statemanagment/rewardlist/rewardlist_bloc.dart';
import '../statemanagment/rewardslevel/rewardslevel_bloc.dart';
import '../statemanagment/rewardupdate/rewardupdate_bloc.dart';
import 'widget/cached_image.dart';
import 'widget/custom_elevated_button.dart';
import 'widget/progressbar.dart';
import 'package:http/http.dart' as http;

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  late AudioService _audioService;
  late ConfettiController _confettiController;
  bool animopacity = false;
  int _pendingTaskCount = 0;

  Future<void> shareImageAndText(String text, String imageUrl) async {
    try {
      // Step 1: Download the image
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Step 2: Convert the image to XFile
        final bytes = response.bodyBytes;
        final tempFile = await _writeToFile(bytes);
        final xFile = XFile(tempFile.path, mimeType: 'image/jpeg');

        // Step 3: Share text and the image
        await SharePlus.instance.share(ShareParams(text: text, files: [xFile]));
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<File> _writeToFile(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image.jpg');
    await file.writeAsBytes(data);
    return file;
  }

  Future<void> _showMyDialog(logoImg) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                AlertDialog(
                  title: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: animopacity == false ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                child: SizedBox(
                                  width: 80,
                                  child: MyImageWidget(imageUrl: logoImg),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: -30,
                            child: Center(
                              child: AnimatedOpacity(
                                opacity: animopacity == false ? 1 : 0,
                                duration: const Duration(seconds: 1),
                                child: Lottie.asset(
                                  'assets/images/congratulations.json',
                                  width: 145,
                                  repeat: false,
                                  fit: BoxFit.cover,
                                  onLoaded: (p0) {
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        setState(() {
                                          animopacity = true;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(15),
                      const Text(
                        'Congratulations!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: mediumheading,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          "You've completed 5 Prayer Challenges and unlocked the \"Belt of Truth\" badge!",
                          textAlign: TextAlign.center,
                        ),
                        Gap(15),
                        CustomButton(
                          text: "Spread",
                          onPressed: () {
                            String text =
                                "You've completed 5 Prayer Challenges and unlocked the \"Belt of Truth\" badge!\n \nCheck this out: https://120army.com/download";
                            String imageUrl = logoImg;

                            shareImageAndText(text, imageUrl);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: ConfettiWidget(
                    numberOfParticles: 50,
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: true,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void congratulationsPopup(logoImg) {
    setState(() {
      animopacity = false;
    });

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _showMyDialog(logoImg);
      _confettiController.play();
    });
  }

  void _playSwipeSound() {
    _audioService.play();
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController();
    _audioService = AudioService();
    _audioService.load('assets/images/success.mp3');
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context.read<RewardlistBloc>().add(RewardlistEventLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RewardupdateBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            "Rewards",
            style: TextStyle(fontSize: appbarTitle, color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: BlocBuilder<RewardlistBloc, RewardlistState>(
              builder: (context, state) {
                if (state is RewardlistLoading) {
                  return Editprofileloader();
                } else if (state is RewardlistError) {
                  return Text(state.error);
                } else if (state is RewardlistLoaded) {
                  final totalPending =
                      state.model.data!
                          .expand((e) => e.task ?? [])
                          .where((t) => t.isCompleted != 1)
                          .length;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 80,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(radiusbox),
                                border: Border.all(
                                  width: 1,
                                  color: greyBorderColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.model.totalTask.toString(),
                                    style: TextStyle(
                                      fontSize: mediumheading + 4,
                                      fontWeight: FontWeight.w700,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  const Text("Total Tasks"),
                                ],
                              ),
                            ),
                          ),
                          const Gap(20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 80,
                              decoration: BoxDecoration(
                                color: kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(radiusbox),
                                border: Border.all(
                                  width: 1,
                                  color: greyBorderColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _pendingTaskCount == 0
                                        ? totalPending.toString()
                                        : _pendingTaskCount.toString(),
                                    style: TextStyle(
                                      fontSize: mediumheading + 4,
                                      fontWeight: FontWeight.w700,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  const Text("Pending Tasks"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            top: 0,
                            bottom: kDefaultPadding,
                            left: 8,
                          ),
                          itemCount: state.model.data!.length,
                          itemBuilder: (context, index) {
                            final reward = state.model.data![index];
                            return TimelineTile(
                              rewarddata: reward,
                              index: index,
                              totalItems: state.model.data!.length,
                              onTaskStatusChanged: () {
                                final updatedCount =
                                    state.model.data!
                                        .expand((e) => e.task ?? [])
                                        .where((t) => t.isCompleted != 1)
                                        .length;

                                setState(() {
                                  _pendingTaskCount = updatedCount;
                                });
                              },
                              onAllTasksCompleted: () {
                                if (reward.isTotalCompleted != 1) {
                                  congratulationsPopup(reward.image);
                                  _playSwipeSound();
                                  Future.delayed(Duration(seconds: 1), () {
                                    context.read<RewardslevelBloc>().add(
                                      RewardslevelEventTrigger(),
                                    );
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Text("Something went wrong");
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineTile extends StatefulWidget {
  final RewardslistDatum rewarddata;
  final int index;
  final int totalItems;
  final VoidCallback onTaskStatusChanged;
  final VoidCallback? onAllTasksCompleted;

  const TimelineTile({
    required this.rewarddata,
    required this.index,
    required this.totalItems,
    required this.onTaskStatusChanged,
    this.onAllTasksCompleted,
    super.key,
  });

  @override
  State<TimelineTile> createState() => _TimelineTileState();
}

class _TimelineTileState extends State<TimelineTile> {
  bool _areAllCheckboxesChecked() {
    return widget.rewarddata.task?.every((t) => t.isCompleted == 1) ?? false;
  }

  int getCompletedSteps() {
    return widget.rewarddata.task
            ?.where((task) => task.isCompleted == 1)
            .length ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final taskList = widget.rewarddata.task ?? [];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VerticalTimelineLine(
                index: widget.index,
                totalItems: widget.totalItems,
                isCompleted: _areAllCheckboxesChecked(),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: kDefaultPadding * 1.4,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      // showTrailingIcon: widget.rewarddata.isTotalCompleted != 1,
                      minTileHeight: 115,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      title: Transform.translate(
                        offset: const Offset(0, -15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Level ${widget.index + 1}",
                                  style: TextStyle(
                                    fontSize: formLabelFontSize,
                                    color: textGrayColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 100,
                                  child: Progressbar(
                                    maxSteps: widget.rewarddata.task!.length,
                                    currentStep: getCompletedSteps(),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.rewarddata.title.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: formLabelFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Transform.translate(
                        offset: const Offset(0, -15),
                        child: Text(
                          widget.rewarddata.description.toString(),
                          style: TextStyle(fontSize: smallSize),
                        ),
                      ),
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Tasks',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        ...taskList.asMap().entries.map((entry) {
                          final task = entry.value;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: IgnorePointer(
                              ignoring:
                                  widget.rewarddata.isTotalCompleted == 1 ||
                                          _areAllCheckboxesChecked()
                                      ? true
                                      : false,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    task.isCompleted =
                                        task.isCompleted == 1 ? 0 : 1;
                                  });
                                  widget.onTaskStatusChanged();
                                  if (_areAllCheckboxesChecked() &&
                                      widget.rewarddata.isTotalCompleted != 1) {
                                    widget.onAllTasksCompleted?.call();
                                  }

                                  context.read<RewardupdateBloc>().add(
                                    RewardupdateEventTrigger(
                                      task.rewardId.toString(),
                                      task.id.toString(),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 3,
                                  children: [
                                    Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                      value: task.isCompleted == 1,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          task.isCompleted = newValue! ? 1 : 0;
                                        });
                                        widget.onTaskStatusChanged();
                                        if (_areAllCheckboxesChecked() &&
                                            widget
                                                    .rewarddata
                                                    .isTotalCompleted !=
                                                1) {
                                          widget.onAllTasksCompleted?.call();
                                        }
                                        context.read<RewardupdateBloc>().add(
                                          RewardupdateEventTrigger(
                                            task.rewardId.toString(),
                                            task.id.toString(),
                                          ),
                                        );
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        task.title.toString(),
                                        style: TextStyle(
                                          fontSize: mediumsmallSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: -7,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color:
                    _areAllCheckboxesChecked()
                        ? kPrimaryColor
                        : kLightDarkPrimaryColor,
                width: 3,
              ),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: MyImageWidget(
                imageUrl: widget.rewarddata.image.toString(),
              ),
            ),
          ),
        ),
        if (widget.rewarddata.isTotalCompleted == 1 ||
            _areAllCheckboxesChecked())
          Positioned(
            right: 0,
            top: 0,
            child: SvgPicture.asset("assets/icons/success.svg", width: 35),
          ),
      ],
    );
  }
}

class VerticalTimelineLine extends StatelessWidget {
  final int index;
  final int totalItems;
  final bool isCompleted;

  const VerticalTimelineLine({
    required this.index,
    required this.totalItems,
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      color:
          index == totalItems - 1
              ? Colors.transparent
              : isCompleted
              ? kPrimaryColor
              : kLightDarkPrimaryColor,
      margin: const EdgeInsets.only(left: 20),
    );
  }
}
