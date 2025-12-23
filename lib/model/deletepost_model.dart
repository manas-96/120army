// To parse this JSON data, do
//
//     final deletepost = deletepostFromJson(jsonString);

import 'dart:convert';

Deletepost deletepostFromJson(String str) =>
    Deletepost.fromJson(json.decode(str));

String deletepostToJson(Deletepost data) => json.encode(data.toJson());

class Deletepost {
  String status;
  String msg;

  Deletepost({required this.status, required this.msg});

  factory Deletepost.fromJson(Map<String, dynamic> json) =>
      Deletepost(status: json["status"] ?? "", msg: json["msg"] ?? "");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
