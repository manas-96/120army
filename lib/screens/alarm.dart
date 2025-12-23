import 'package:flutter/cupertino.dart';
import '../exports.dart';
import '../global.dart';
import '../model/alarmlist_model.dart';
import '../services/main_service.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  bool defaultalarmValue = true;
  List<AlarmPayload> alarmGroups = [];

  @override
  void initState() {
    super.initState();
    loadAlarmsFromHive();
  }

  void loadAlarmsFromHive() {
    final box = Hive.box('alarmBox');
    final rawList = box.get('alarmList', defaultValue: []);
    final List<AlarmPayload> loadedAlarms = [];

    for (var group in rawList) {
      final groupMap = Map<String, dynamic>.from(group);
      final List rawData = groupMap['data'] ?? [];
      groupMap['data'] =
          rawData.map((item) => Map<String, dynamic>.from(item)).toList();
      loadedAlarms.add(AlarmPayload.fromJson(groupMap));
    }

    setState(() {
      alarmGroups = loadedAlarms;
    });
  }

  void deleteAlarm(int groupIndex, int alarmIndex) async {
    final box = Hive.box('alarmBox');

    setState(() {
      alarmGroups[groupIndex].data.removeAt(alarmIndex);
      if (alarmGroups[groupIndex].data.isEmpty) {
        alarmGroups.removeAt(groupIndex);
      }
    });

    final updatedJsonList = alarmGroups.map((e) => e.toJson()).toList();
    await box.put('alarmList', updatedJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Alarm",
          style: TextStyle(fontSize: appbarTitle, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              // Alarm List from Hive
              ...alarmGroups.asMap().entries.map((groupEntry) {
                final groupIndex = groupEntry.key;
                final group = groupEntry.value;
                final int displayCount =
                    (group.type == 2 || group.type == 3 || group.type == 4)
                        ? (group.data.isNotEmpty ? 1 : 0)
                        : group.data.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(displayCount, (alarmIndex) {
                    final alarm = group.data[alarmIndex];
                    final timeParts = alarm.alarmTime.split(':');
                    final hour = int.tryParse(timeParts[0]) ?? 0;
                    final minute = int.tryParse(timeParts[1]) ?? 0;
                    final ampm = hour >= 12 ? 'PM' : 'AM';
                    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: groupIndex >= 1 ? 15 : 0),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color:
                            groupIndex >= 1 ? whiteBgColor : kPrimaryColorLight,
                        borderRadius: BorderRadius.circular(radiusbox),
                        border: Border.all(color: greyBorderColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 3,
                        children: [
                          if (groupIndex == 0) ...[
                            Column(
                              children: [
                                Text(
                                  "Our standard prayer alarm time is set to default.",
                                  style: TextStyle(
                                    color: whiteTextColor,
                                    fontSize: smallSize,
                                  ),
                                ),
                                Gap(5),
                              ],
                            ),
                          ],

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "$displayHour:${minute.toString().padLeft(2, '0')} ",
                                      style: TextStyle(
                                        fontSize: largeheading,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            groupIndex >= 1
                                                ? Colors.black
                                                : whiteTextColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ampm,
                                      style: TextStyle(
                                        fontSize: titlesize,
                                        color:
                                            groupIndex >= 1
                                                ? Colors.black
                                                : whiteTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  CupertinoSwitch(
                                    value: alarm.isShow == true,
                                    activeTrackColor:
                                        groupIndex >= 1
                                            ? kPrimaryColor
                                            : Color(0xFF9f4350),
                                    inactiveTrackColor:
                                        groupIndex >= 1
                                            ? kLightDarkPrimaryColor
                                            : kLightDarkPrimaryColor,
                                    onChanged: (bool? value) async {
                                      final newValue = value ?? false;

                                      setState(() {
                                        for (
                                          int i = 0;
                                          i <
                                              alarmGroups[groupIndex]
                                                  .data
                                                  .length;
                                          i++
                                        ) {
                                          final alarmData =
                                              alarmGroups[groupIndex].data[i];
                                          alarmGroups[groupIndex]
                                              .data[i] = AlarmData(
                                            day: alarmData.day,
                                            alarmTime: alarmData.alarmTime,
                                            isShow: newValue,
                                          );
                                        }
                                      });

                                      final box = Hive.box('alarmBox');
                                      final updatedJsonList =
                                          alarmGroups
                                              .map((e) => e.toJson())
                                              .toList();
                                      await box.put(
                                        'alarmList',
                                        updatedJsonList,
                                      );
                                      MainService().scheduleAlarmsFromHive();
                                    },
                                  ),
                                  SizedBox(width: 10),

                                  if (groupIndex >= 1) ...[
                                    GestureDetector(
                                      onTap: () async {
                                        if (group.type == 2 ||
                                            group.type == 3 ||
                                            group.type == 4) {
                                          setState(() {
                                            alarmGroups.removeAt(groupIndex);
                                          });
                                          final box = Hive.box('alarmBox');
                                          await box.put(
                                            'alarmList',
                                            alarmGroups
                                                .map((e) => e.toJson())
                                                .toList(),
                                          );
                                        } else {
                                          deleteAlarm(groupIndex, alarmIndex);
                                        }
                                        MainService().scheduleAlarmsFromHive();
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 36,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          if (group.type == 1) ...[
                            Text(
                              "Alarm,  ${getFullDayName(alarm.day)}",
                              style: TextStyle(color: textGrayColor),
                            ),
                          ] else if (group.type == 2) ...[
                            Text(
                              "Alarm,  Everyday",
                              style: TextStyle(
                                color:
                                    groupIndex >= 1
                                        ? textGrayColor
                                        : whiteTextColor,
                              ),
                            ),
                          ] else if (group.type == 3) ...[
                            Text(
                              "Alarm,  Monday to Friday",
                              style: TextStyle(color: textGrayColor),
                            ),
                          ] else if (group.type == 4) ...[
                            Text(
                              "Alarm, ${group.data.map((item) => getFullDayName(item.day)).join(', ')}",
                              style: TextStyle(color: textGrayColor),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                );
              }),

              Gap(70),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed("/addalarm");
        },
        child: Center(child: Icon(Icons.add, size: 36, color: whiteTextColor)),
      ),
    );
  }
}

String getFullDayName(String shortDay) {
  const dayMap = {
    'sun': 'Sunday',
    'mon': 'Monday',
    'tue': 'Tuesday',
    'wed': 'Wednesday',
    'thu': 'Thursday',
    'fri': 'Friday',
    'sat': 'Saturday',
  };

  return dayMap[shortDay.toLowerCase()] ?? shortDay;
}
