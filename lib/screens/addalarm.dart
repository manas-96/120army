import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
import '../exports.dart';
import '../global.dart';
import '../main.dart';
// import '../services/local_notification_service.dart';
import '../services/main_service.dart';
import 'widget/custom_elevated_button.dart';

class Addalarm extends StatefulWidget {
  const Addalarm({super.key});

  @override
  State<Addalarm> createState() => _AddalarmState();
}

class _AddalarmState extends State<Addalarm> {
  int selectedHour = 1;
  int selectedMinute = 20;
  String selectedPeriod = 'PM';
  String selectedRepeatOption = "Once";
  List<String> selectedDays = [];

  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => (index + 1) % 60);

  final List<String> periods = ['AM', 'PM'];
  List<AlarmPostPayload> allAlarms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Add Alarm",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              CupertinoTheme(
                data: const CupertinoThemeData(brightness: Brightness.light),
                child: SizedBox(
                  height: 300,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 50,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedHour - 1,
                          ),
                          selectionOverlay: _buildOverlay(),
                          onSelectedItemChanged: (index) {
                            setState(() => selectedHour = hours[index]);
                          },
                          children: List.generate(hours.length, (index) {
                            final isSelected = (selectedHour - 1) == index;
                            return Center(
                              child: Text(
                                hours[index].toString(),
                                style: TextStyle(
                                  color:
                                      isSelected ? kPrimaryColor : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: semilargeheading,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const Text(":", style: TextStyle(fontSize: 24)),
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 50,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedMinute - 1,
                          ),
                          selectionOverlay: _buildOverlay(),
                          onSelectedItemChanged: (index) {
                            setState(() => selectedMinute = minutes[index]);
                          },
                          children: List.generate(minutes.length, (index) {
                            final isSelected = (selectedMinute - 1) == index;
                            return Center(
                              child: Text(
                                minutes[index] == 0
                                    ? "00"
                                    : minutes[index].toString(),
                                style: TextStyle(
                                  color:
                                      isSelected ? kPrimaryColor : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: semilargeheading,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 50,
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedPeriod == 'AM' ? 0 : 1,
                          ),
                          selectionOverlay: _buildOverlay(),
                          onSelectedItemChanged: (index) {
                            setState(() => selectedPeriod = periods[index]);
                          },
                          children: List.generate(periods.length, (index) {
                            final isSelected = selectedPeriod == periods[index];
                            return Center(
                              child: Text(
                                periods[index],
                                style: TextStyle(
                                  color:
                                      isSelected ? kPrimaryColor : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: semilargeheading,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Repeat",
                    style: TextStyle(
                      fontSize: paraFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showRepeatOptions(context),
                    child: Row(
                      children: [
                        Text(
                          selectedRepeatOption,
                          style: TextStyle(
                            fontSize: paraFont,
                            color: textGrayColor,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: textGrayColor),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(40),
              CustomButton(
                text: "Add",
                onPressed: () async {
                  final newPayload = buildAlarmPayload();

                  allAlarms.clear();
                  allAlarms.add(newPayload);

                  // ✅ Send only the single map (not a list)
                  final jsonMap = newPayload.toJson();
                  MainService().alarmpostService(jsonMap);
                  Future.delayed(Duration(milliseconds: 500), () {
                    navigatorKey.currentState?.pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false, // Clears all previous routes
                    );

                    // Then push profile on top of home
                    Future.delayed(Duration(milliseconds: 1), () {
                      navigatorKey.currentState?.pushNamed('/alarm');
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRepeatOptions(BuildContext context) {
    List<String> options = ["Once", "Daily", "Mon to Fri", "Custom"];
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  options.map((option) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                      ),
                      color:
                          selectedRepeatOption == option
                              ? kLightPrimaryColor
                              : whiteBgColor,
                      child: ListTile(
                        title: Text(
                          option,
                          style: TextStyle(
                            color:
                                selectedRepeatOption == option
                                    ? kPrimaryColorLight
                                    : textGrayColor,
                          ),
                        ),
                        trailing:
                            selectedRepeatOption == option
                                ? Icon(Icons.check, color: kPrimaryColor)
                                : null,
                        onTap: () {
                          setState(() => selectedRepeatOption = option);
                          Navigator.pop(context);
                          if (option == "Custom") {
                            _showCustomRepeatSheet(context);
                          }
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showCustomRepeatSheet(BuildContext context) {
    final List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteBgColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Custom",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...days.map((day) {
                    bool isSelected = selectedDays.contains(day);
                    return ListTile(
                      title: Text(day),
                      trailing: Checkbox(
                        shape: const CircleBorder(),
                        value: isSelected,
                        onChanged: (value) {
                          setModalState(() {
                            isSelected
                                ? selectedDays.remove(day)
                                : selectedDays.add(day);
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        child: CustomButton(
                          verticalPadding: 10,
                          text: "Cancel",
                          isOutlined: true,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: CustomButton(
                          verticalPadding: 10,
                          text: "OK",
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOverlay() {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kPrimaryColorLight.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  AlarmPostPayload buildAlarmPayload() {
    List<String> dayKeys = [];
    final allDays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
    final weekMap = {
      "Sunday": "sun",
      "Monday": "mon",
      "Tuesday": "tue",
      "Wednesday": "wed",
      "Thursday": "thu",
      "Friday": "fri",
      "Saturday": "sat",
    };

    int type = 1; // Default to Once

    switch (selectedRepeatOption) {
      case "Once":
        int weekday = DateTime.now().weekday % 7;
        dayKeys = [allDays[weekday]];
        type = 1;
        break;
      case "Daily":
        dayKeys = allDays;
        type = 2;
        break;
      case "Mon to Fri":
        dayKeys = ["mon", "tue", "wed", "thu", "fri"];
        type = 3;
        break;
      case "Custom":
        dayKeys =
            selectedDays
                .map((d) => weekMap[d] ?? "")
                .where((d) => d.isNotEmpty)
                .toList();
        type = 4;
        break;
    }

    int hour24 =
        selectedPeriod == "PM" && selectedHour != 12
            ? selectedHour + 12
            : selectedPeriod == "AM" && selectedHour == 12
            ? 0
            : selectedHour;

    String formattedTime =
        "${hour24.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}:00";

    List<AlarmData> alarmList =
        dayKeys
            .map((d) => AlarmData(day: d, alarmTime: formattedTime))
            .toList();

    return AlarmPostPayload(type: type, data: alarmList);
  }
}

class AlarmData {
  final String day;
  final String alarmTime;
  final bool isShow;

  AlarmData({required this.day, required this.alarmTime, this.isShow = true});

  Map<String, dynamic> toJson() => {
    "day": day,
    "alarm_time": alarmTime,
    "is_show": isShow,
  };
}

class AlarmPostPayload {
  final int type;
  final List<AlarmData> data;

  AlarmPostPayload({required this.type, required this.data});

  Map<String, dynamic> toJson() => {
    "type": type,
    "data": data.map((x) => x.toJson()).toList(),
  };
}
