import '../../exports.dart';
import '../../global.dart';
import '../../model/weeklypc_model.dart';
import '../../services/date_time_zone.dart';
import '../../shimmerloader/edit_profile_loader.dart';
import '../../statemanagment/weeklypc/weeklypc_bloc.dart';
import '../widget/custom_elevated_button.dart';

class Weeklypc extends StatefulWidget {
  const Weeklypc({super.key});

  @override
  State<Weeklypc> createState() => _WeeklypcState();
}

class _WeeklypcState extends State<Weeklypc> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: tabTopPadding),
                  child: BlocBuilder<WeeklypcBloc, WeeklypcState>(
                    builder: (context, state) {
                      if (state is WeeklypcLoading) {
                        return Editprofileloader();
                      } else if (state is WeeklypcLoaded) {
                        List<Weeklydatum>? data = state.model.data;
                        return Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.83,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Text(
                                        "Faith Challenge",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.displayMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Complete the daily challenge to unlock the next Badge!",

                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.headlineSmall,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            data!.isEmpty
                                ? Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Text("Data Not found"),
                                )
                                : Column(
                                  children: List.generate(data.length, (index) {
                                    return _buildChallengeTile(
                                      data[index],
                                      index,
                                      data.length,
                                    );
                                  }),
                                ),
                          ],
                        );
                      } else if (state is WeeklypcError) {
                        return Center(child: Text(state.error));
                      } else {
                        return Center(child: Text("Something went wrong"));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeTile(Weeklydatum data, int index, int length) {
    int total = data.challenge!.length;
    int completed = data.challenge!.where((c) => c.isCompleted == 1).length;
    double percent = total == 0 ? 0.0 : completed / total;
    String percentText = "${(percent * 100).toStringAsFixed(0)}%";
    return GestureDetector(
      onTap: () async {
        if (data.challenge!.every((c) => c.isActive == 0)) {
          if (data.nextActivateDate != null) {
            DateTime utcTime = DateTime.parse(
              data.nextActivateDate!.toString(),
            );
            DateTime localTime = utcTime.toLocal();
            // String formattedTime = DateFormat(
            //   'dd-MM-yyyy hh:mm:ss a',
            // ).format(localTime);
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: whiteBgColor,
                    title: Icon(
                      Icons.error_outline,
                      size: 54,
                      color: errorColor,
                    ),
                    content: Text(
                      "⚠️ Please come back at ${DateTimeHelper.formatToLocal(localTime.toString())} Your next Faith Challenge will be available. Each day unlocks after 24 hours to help you grow step by step in faith.",
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
        } else {
          Navigator.of(context).pushNamed(
            "/weeklyprayerchallengedetails",
            arguments: {
              'pcData': data.challenge,
              'badgeIcon': data.image,
              'titleText': data.title,
              'nextactivatedate': data.nextActivateDate,
            },
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 15,
          bottom: index == length - 1 ? hometabbottomgap : 0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors:
                data.isTotalCompleted == 1
                    ? [Color(0xffd6bb4c), Color(0xfffff4cc), Color(0xffd6bb4c)]
                    : [Color(0xff880E1F), Color(0xffF1687D), Color(0xff880E1F)],
            stops: [0, 0.5, 1],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    if (data.challenge!.every((c) => c.isActive == 0)) ...[
                      Icon(
                        Icons.lock,
                        color: kLightDarkPrimaryColor.withValues(alpha: 0.7),
                        size: 28,
                      ),
                      SizedBox(width: 5),
                    ],
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title!,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Text("${data.days} day prayer Challenge"),
                  ],
                ),
              ],
            ),
            data.isTotalCompleted == 1
                ? SvgPicture.asset('assets/icons/check.svg', width: 40)
                : CircularPercentIndicator(
                  radius: 20.0,
                  lineWidth: 3.0,
                  percent: percent,
                  center: Text(
                    percentText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: smallSize,
                    ),
                  ),
                  progressColor: Colors.yellow,
                  backgroundColor: Colors.white,
                ),
          ],
        ),
      ),
    );
  }
}
