class AlarmPayload {
  final int type;
  final List<AlarmData> data;

  AlarmPayload({required this.type, required this.data});

  factory AlarmPayload.fromJson(Map<String, dynamic> json) {
    return AlarmPayload(
      type: json['type'] ?? 0,
      data:
          (json['data'] as List?)
              ?.map((item) => AlarmData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'data': data.map((item) => item.toJson()).toList(),
  };
}

class AlarmData {
  final String day;
  final String alarmTime;
  final bool isShow;

  AlarmData({required this.day, required this.alarmTime, required this.isShow});

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    return AlarmData(
      day: json['day'] ?? '',
      alarmTime: json['alarm_time'] ?? '',
      isShow: json['is_show'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'alarm_time': alarmTime,
    'is_show': isShow,
  };
}
