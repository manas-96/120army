// To parse this JSON data, do
//
//     final updatenotification = updatenotificationFromJson(jsonString);

import 'dart:convert';

Updatenotification updatenotificationFromJson(String str) =>
    Updatenotification.fromJson(json.decode(str));

String updatenotificationToJson(Updatenotification data) =>
    json.encode(data.toJson());

class Updatenotification {
  String status;
  String msg;

  Updatenotification({required this.status, required this.msg});

  factory Updatenotification.fromJson(Map<String, dynamic> json) =>
      Updatenotification(status: json["status"] ?? "", msg: json["msg"] ?? "");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
