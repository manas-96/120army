import '../exports.dart';
import '../global.dart';
import '../model/weeklypc_model.dart';
import '../services/date_time_zone.dart';
import '../services/main_service.dart';
import '../statemanagment/weeklypc/weeklypc_bloc.dart';
import 'widget/congratulations_dialog_page.dart';
import 'widget/custom_elevated_button.dart';
import 'package:flutter_html/flutter_html.dart';

class Weeklyprayerchallengedetails extends StatefulWidget {
  const Weeklyprayerchallengedetails({
    super.key,
    required this.pcData,
    required this.badgeIcon,
    required this.titleText,
    required this.nextactivatedate,
  });

  final List<Challenge>? pcData;
  final String badgeIcon;
  final String titleText;
  final DateTime nextactivatedate;

  @override
  State<Weeklyprayerchallengedetails> createState() =>
      _WeeklyprayerchallengedetailsState();
}

class _WeeklyprayerchallengedetailsState
    extends State<Weeklyprayerchallengedetails> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<ScrollController> _scrollControllers;

  @override
  void initState() {
    super.initState();

    _scrollControllers = List.generate(
      widget.pcData!.length,
      (index) =>
          ScrollController()..addListener(() {
            final controller = _scrollControllers[index];
            if (controller.position.atEdge) {
              if (controller.position.pixels ==
                      controller.position.maxScrollExtent ||
                  controller.position.maxScrollExtent == 0) {
                _handleHelloWorld(index);
              }
            }
          }),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _scrollControllers.length; i++) {
        final controller = _scrollControllers[i];
        if (controller.hasClients && controller.position.maxScrollExtent == 0) {
          _handleHelloWorld(i);
        }
      }
    });
  }

  void _handleHelloWorld(int index) {
    if (widget.pcData![index].isCompleted == 0) {
      MainService()
          .successprayerchallengeService(
            prayer_id: widget.pcData![index].prayerId,
            challenge_id: widget.pcData![index].id,
          )
          .then((value) {
            context.read<WeeklypcBloc>().add(WeeklypcTrigger());
          });

      if (index + 1 == widget.pcData!.length) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CongratulationsPopup(
              logoImgUrl: widget.badgeIcon,

              message:
                  "You’ve successfully completed ${widget.titleText} Challenge and earned your badge. Keep growing in God’s Word! Visit your profile to see your new badge shining bright!",
              sharedText:
                  "🌟 I just earned a ${widget.titleText} Challenge Badge on 120 Army! 🌟 Join me in completing daily faith tasks, growing spiritually, and earning your own badges. 🙏✝️ 👉 Download the 120 Army app and start your journey today. 📲 https://120army.com/download",
            );
          },
        );
      }
    }
  }

  void _nextPage() {
    if (_currentPage < widget.pcData!.length - 1) {
      if (widget.pcData![_currentPage + 1].isActive == 1) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        DateTime utcTime = DateTime.parse(widget.nextactivatedate.toString());
        DateTime localTime = utcTime.toLocal();

        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: whiteBgColor,
                title: Icon(Icons.error_outline, size: 54, color: errorColor),
                content: Text(
                  "⚠️ Please come back at ${DateTimeHelper.formatToLocal(localTime.toString())} Your next Faith Challenge will be available. Each day unlocks after 24 hours to help you grow step by step in faith.",
                  // "Please come back in $formattedTime to access the next prayer challenge. Each day's prayer content unlocks every 24 hours to help you reflect and grow daily.",
                  style: TextStyle(fontSize: paraFont),
                ),
                actions: [
                  // TextButton(
                  //   onPressed: () => Navigator.of(context).pop(),
                  //   child: const Text('OK'),
                  // ),
                  CustomButton(
                    text: "OK",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String getRemainingTimeUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final difference = tomorrow.difference(now);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.pcData![_currentPage].title!,
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: kPrimaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Day ${_currentPage + 1} / ${widget.pcData!.length}",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ),
                      onPressed: _previousPage,
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_month, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.pcData!.length,
              physics:
                  (_currentPage == widget.pcData!.length - 1 ||
                          widget.pcData![_currentPage + 1].isActive == 1)
                      ? const ScrollPhysics()
                      : const NeverScrollableScrollPhysics(),

              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final controller = _scrollControllers[index];
                  if (controller.hasClients &&
                      controller.position.maxScrollExtent == 0) {
                    _handleHelloWorld(index);
                  }
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    controller: _scrollControllers[index],
                    child: Html(
                      data: widget.pcData![index].description!,
                      style: {
                        "ol": Style(padding: HtmlPaddings.only(left: 15)),
                      },
                    ),
                    // child: Text(
                    //   widget.pcData![index].description!,
                    //   style: TextStyle(fontSize: paraFont, height: 1.6),
                    // ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
