import 'dart:convert';

Successprayerchallengesmodel successprayerchallengesmodelFromJson(String str) =>
    Successprayerchallengesmodel.fromJson(json.decode(str));

String successprayerchallengesmodelToJson(Successprayerchallengesmodel data) =>
    json.encode(data.toJson());

class Successprayerchallengesmodel {
  PrayerCompletedData? prayerCompletedData;
  bool? prayerCompleted;
  String? status;
  List<String>? msg;

  Successprayerchallengesmodel({
    this.prayerCompletedData,
    this.prayerCompleted,
    this.status,
    this.msg,
  });

  factory Successprayerchallengesmodel.fromJson(Map<String, dynamic> json) {
    List<String> parsedMsg = [];

    if (json["msg"] is String) {
      parsedMsg = [json["msg"]];
    } else if (json["msg"] is List) {
      parsedMsg = List<String>.from(json["msg"].map((x) => x.toString()));
    }

    return Successprayerchallengesmodel(
      prayerCompletedData:
          json["prayerCompletedData"] != null
              ? PrayerCompletedData.fromJson(json["prayerCompletedData"])
              : null,
      prayerCompleted: json["prayerCompleted"] ?? false,
      status: json["status"] ?? '',
      msg: parsedMsg,
    );
  }

  Map<String, dynamic> toJson() => {
    "prayerCompletedData": prayerCompletedData?.toJson(),
    "prayerCompleted": prayerCompleted ?? false,
    "status": status ?? '',
    "msg": msg ?? [],
  };
}

class PrayerCompletedData {
  String? title;
  String? description;
  int? days;
  String? image;

  PrayerCompletedData({this.title, this.description, this.days, this.image});

  factory PrayerCompletedData.fromJson(Map<String, dynamic> json) =>
      PrayerCompletedData(
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        days: json["days"] ?? 0,
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
    "title": title ?? '',
    "description": description ?? '',
    "days": days ?? 0,
    "image": image ?? '',
  };
}
