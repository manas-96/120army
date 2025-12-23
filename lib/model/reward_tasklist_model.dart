import 'dart:convert';

// Usage:
// final rewardtasklist = rewardtasklistFromJson(jsonString);

Rewardtasklist rewardtasklistFromJson(String str) =>
    Rewardtasklist.fromJson(json.decode(str));

String rewardtasklistToJson(Rewardtasklist data) => json.encode(data.toJson());

class Rewardtasklist {
  List<RewardslistDatum>? data;
  int? totalTask;
  int? totalPendingTask;
  String? status;
  String? msg;

  Rewardtasklist({
    this.data,
    this.totalTask,
    this.totalPendingTask,
    this.status,
    this.msg,
  });

  factory Rewardtasklist.fromJson(Map<String, dynamic> json) => Rewardtasklist(
    data:
        json["data"] != null
            ? List<RewardslistDatum>.from(
              (json["data"] as List).map((x) => RewardslistDatum.fromJson(x)),
            )
            : [],
    totalTask: json["totalTask"] ?? 0,
    totalPendingTask: json["totalPendingTask"] ?? 0,
    status: json["status"] ?? '',
    msg: json["msg"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "data": data?.map((x) => x.toJson()).toList() ?? [],
    "totalTask": totalTask,
    "totalPendingTask": totalPendingTask,
    "status": status,
    "msg": msg,
  };
}

class RewardslistDatum {
  String? id;
  String? title;
  String? description;
  String? image;
  int? isTotalCompleted;
  List<Task>? task;

  RewardslistDatum({
    this.id,
    this.title,
    this.description,
    this.image,
    this.isTotalCompleted,
    this.task,
  });

  factory RewardslistDatum.fromJson(Map<String, dynamic> json) =>
      RewardslistDatum(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        image: json["image"] ?? '',
        isTotalCompleted: json["is_total_completed"] ?? 0,
        task:
            json["task"] != null
                ? List<Task>.from(
                  (json["task"] as List).map((x) => Task.fromJson(x)),
                )
                : [],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "is_total_completed": isTotalCompleted,
    "task": task?.map((x) => x.toJson()).toList() ?? [],
  };
}

class Task {
  String? id;
  String? rewardId;
  String? title;
  int? isCompleted;

  Task({this.id, this.rewardId, this.title, this.isCompleted});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"] ?? 0,
    rewardId: json["reward_id"] ?? 0,
    title: json["title"] ?? '',
    isCompleted: json["is_completed"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reward_id": rewardId,
    "title": title,
    "is_completed": isCompleted,
  };
}
