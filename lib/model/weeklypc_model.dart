import 'dart:convert';

Weeklypcmodel weeklypcFromJson(String str) =>
    Weeklypcmodel.fromJson(json.decode(str));
String weeklypcToJson(Weeklypcmodel data) => json.encode(data.toJson());

class Weeklypcmodel {
  List<Weeklydatum>? data;
  int? totalChallenge;
  int? totalPendingChallenge;
  String? status;
  dynamic msg; // can be String or List<String>

  Weeklypcmodel({
    this.data,
    this.totalChallenge,
    this.totalPendingChallenge,
    this.status,
    this.msg,
  });

  factory Weeklypcmodel.fromJson(Map<String, dynamic> json) => Weeklypcmodel(
    data:
        (json["data"] as List?)?.map((x) => Weeklydatum.fromJson(x)).toList() ??
        [],
    totalChallenge: json["totalChallenge"] ?? 0,
    totalPendingChallenge: json["totalPendingChallenge"] ?? 0,
    status: json["status"] ?? '',
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList() ?? [],
    "totalChallenge": totalChallenge ?? 0,
    "totalPendingChallenge": totalPendingChallenge ?? 0,
    "status": status ?? '',
    "msg": msg,
  };
}

class Weeklydatum {
  int? id;
  String? title;
  String? description;
  int? days;
  String? image;
  int? isTotalCompleted;
  DateTime? nextActivateDate;
  List<Challenge>? challenge;

  Weeklydatum({
    this.id,
    this.title,
    this.description,
    this.days,
    this.image,
    this.isTotalCompleted,
    this.nextActivateDate,
    this.challenge,
  });

  factory Weeklydatum.fromJson(Map<String, dynamic> json) => Weeklydatum(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    days: json["days"] ?? 0,
    image: json["image"] ?? '',
    isTotalCompleted: json["is_total_completed"] ?? 0,
    nextActivateDate:
        json["next_activate_date"] == null
            ? null
            : DateTime.parse(json["next_activate_date"]),
    challenge:
        (json["challenge"] as List?)
            ?.map((x) => Challenge.fromJson(x))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "title": title ?? '',
    "description": description ?? '',
    "days": days ?? 0,
    "image": image ?? '',
    "is_total_completed": isTotalCompleted ?? 0,
    "next_activate_date": nextActivateDate?.toIso8601String(),
    "challenge": challenge?.map((x) => x.toJson()).toList() ?? [],
  };
}

class Challenge {
  int? id;
  int? prayerId;
  String? title;
  String? description;
  int? isActive;
  int? isCompleted;

  Challenge({
    this.id,
    this.prayerId,
    this.title,
    this.description,
    this.isActive,
    this.isCompleted,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    id: json["id"] ?? 0,
    prayerId: json["prayer_id"] ?? 0,
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    isActive: json["is_active"] ?? 0,
    isCompleted: json["is_completed"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? '',
    "prayer_id": prayerId ?? '',
    "title": title ?? '',
    "description": description ?? '',
    "is_active": isActive ?? 0,
    "is_completed": isCompleted ?? 0,
  };
}
