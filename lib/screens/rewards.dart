import '../exports.dart';
import '../global.dart';
import '../model/reward_tasklist_model.dart';
import '../shimmerloader/edit_profile_loader.dart';
import '../statemanagment/rewardlist/rewardlist_bloc.dart';
import '../statemanagment/rewardslevel/rewardslevel_bloc.dart';
import '../statemanagment/rewardupdate/rewardupdate_bloc.dart';
import 'widget/cached_image.dart';
import 'widget/congratulations_dialog_page.dart';
import 'widget/progressbar.dart';

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  int _pendingTaskCount = 0;

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

                  return state.model.data!.isNotEmpty
                      ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: kLightPrimaryColor,
                                    borderRadius: BorderRadius.circular(
                                      radiusbox,
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: greyBorderColor,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    borderRadius: BorderRadius.circular(
                                      radiusbox,
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: greyBorderColor,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CongratulationsPopup(
                                            logoImgUrl: reward.image.toString(),
                                            // message:
                                            //     "You've completed ${reward.task?.length ?? 0} ${reward.title} Challenges and unlocked the \"${reward.title}\" badge!",
                                            message:
                                                "You’ve successfully completed level ${reward.task?.length ?? 0} and earned your badge. Keep growing in God’s Word! Visit your profile to see your new badge shining bright!",
                                            sharedText:
                                                "🏅 I just earned a Rewards Badge on 120 Army! 🎉 Join the movement—complete tasks, grow in faith, and earn yours too. 🙏✝️ 👉 Download the 120 Army app and start your journey today. 📲 https://120army.com/download",
                                          );
                                        },
                                      );

                                      Future.delayed(
                                        const Duration(seconds: 1),
                                        () {
                                          context.read<RewardslevelBloc>().add(
                                            RewardslevelEventTrigger(),
                                          );
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
                      : Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Text("Data Not found"),
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
