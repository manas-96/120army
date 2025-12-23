import 'dart:convert';

Alarmpost alarmpostFromJson(String str) => Alarmpost.fromJson(json.decode(str));

String alarmpostToJson(Alarmpost data) => json.encode(data.toJson());

class Alarmpost {
  final String status;
  final String msg;

  Alarmpost({required this.status, required this.msg});

  factory Alarmpost.fromJson(Map<String, dynamic> json) =>
      Alarmpost(status: json["status"] ?? "", msg: json["msg"] ?? "");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
