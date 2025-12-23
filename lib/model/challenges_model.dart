import 'dart:convert';

Challengesmodel challengesmodelFromJson(String str) =>
    Challengesmodel.fromJson(json.decode(str));

String challengesmodelToJson(Challengesmodel data) =>
    json.encode(data.toJson());

class Challengesmodel {
  List<Datum>? data;
  String? status;
  dynamic msg; // Can be String or List<String>

  Challengesmodel({this.data, this.status, this.msg});

  factory Challengesmodel.fromJson(Map<String, dynamic> json) =>
      Challengesmodel(
        data:
            json["data"] != null
                ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
                : [],
        status: json["status"] ?? "",
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList() ?? [],
    "status": status ?? "",
    "msg": msg,
  };

  /// Utility to get a single message as string
  String getSingleMessage() {
    if (msg is String) {
      return msg;
    } else if (msg is List && msg.isNotEmpty) {
      return msg[0];
    } else {
      return "";
    }
  }
}

class Datum {
  String? id;
  String? title;
  String? description;
  String? image;
  int? days;
  int? isTotalCompleted;

  Datum({
    this.id,
    this.title,
    this.description,
    this.image,
    this.days,
    this.isTotalCompleted,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    image: json["image"] ?? "",
    days: json["days"] ?? 0,
    isTotalCompleted: json["is_total_completed"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? "",
    "title": title ?? "",
    "description": description ?? "",
    "image": image ?? "",
    "days": days ?? 0,
    "is_total_completed": isTotalCompleted ?? 0,
  };
}
