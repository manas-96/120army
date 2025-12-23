import 'dart:convert';

Rewardlevelmodel rewardtasklistFromJson(String str) =>
    Rewardlevelmodel.fromJson(json.decode(str));

String rewardtasklistToJson(Rewardlevelmodel data) =>
    json.encode(data.toJson());

class Rewardlevelmodel {
  List<Rewardsleveldatum> data;
  String status;
  String msg;

  Rewardlevelmodel({
    required this.data,
    required this.status,
    required this.msg,
  });

  factory Rewardlevelmodel.fromJson(Map<String, dynamic> json) =>
      Rewardlevelmodel(
        data:
            json["data"] == null
                ? []
                : List<Rewardsleveldatum>.from(
                  json["data"].map((x) => Rewardsleveldatum.fromJson(x)),
                ),
        status: json["status"] ?? '',
        msg: json["msg"] ?? '',
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "msg": msg,
  };
}

class Rewardsleveldatum {
  String id;
  String title;
  String description;
  String image;
  int isTotalCompleted;

  Rewardsleveldatum({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.isTotalCompleted,
  });

  factory Rewardsleveldatum.fromJson(Map<String, dynamic> json) =>
      Rewardsleveldatum(
        id: json["id"] ?? '',
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        image: json["image"] ?? '',
        isTotalCompleted: json["is_total_completed"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "is_total_completed": isTotalCompleted,
  };
}
