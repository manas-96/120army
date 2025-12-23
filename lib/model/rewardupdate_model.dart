import 'dart:convert';

Rewardupdate rewardupdateFromJson(String str) =>
    Rewardupdate.fromJson(json.decode(str));

String rewardupdateToJson(Rewardupdate data) => json.encode(data.toJson());

class Rewardupdate {
  RewardCompletedData? rewardCompletedData;
  bool? rewardCompleted;
  String? status;
  dynamic msg; // can be String or List<String>

  Rewardupdate({
    this.rewardCompletedData,
    this.rewardCompleted,
    this.status,
    this.msg,
  });

  factory Rewardupdate.fromJson(Map<String, dynamic> json) => Rewardupdate(
    rewardCompletedData:
        json["rewardCompletedData"] != null
            ? RewardCompletedData.fromJson(json["rewardCompletedData"])
            : null,
    rewardCompleted: json["rewardCompleted"] ?? false,
    status: json["status"] ?? '',
    msg: json["msg"], // we don't parse yet, just store
  );

  Map<String, dynamic> toJson() => {
    "rewardCompletedData": rewardCompletedData?.toJson(),
    "rewardCompleted": rewardCompleted,
    "status": status,
    "msg": msg,
  };

  /// Helper to get msg as string
  String get firstMsg {
    if (msg is String) return msg;
    if (msg is List && msg.isNotEmpty) return msg.first.toString();
    return '';
  }

  /// Helper to get msg as list of strings
  List<String> get msgList {
    if (msg is List) {
      return msg.cast<String>();
    } else if (msg is String) {
      return [msg];
    }
    return [];
  }
}

class RewardCompletedData {
  String? title;
  String? description;
  String? image;

  RewardCompletedData({this.title, this.description, this.image});

  factory RewardCompletedData.fromJson(Map<String, dynamic> json) =>
      RewardCompletedData(
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "image": image,
  };
}
