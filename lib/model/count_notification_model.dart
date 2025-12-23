// To parse this JSON data, do
//
//     final countnotificationmodel = countnotificationmodelFromJson(jsonString);

import 'dart:convert';

Countnotificationmodel countnotificationmodelFromJson(String str) =>
    Countnotificationmodel.fromJson(json.decode(str));

String countnotificationmodelToJson(Countnotificationmodel data) =>
    json.encode(data.toJson());

class Countnotificationmodel {
  int total;
  String status;
  String msg;

  Countnotificationmodel({
    required this.total,
    required this.status,
    required this.msg,
  });

  factory Countnotificationmodel.fromJson(Map<String, dynamic> json) =>
      Countnotificationmodel(
        total: json["total"] ?? 0,
        status: json["status"] ?? "",
        msg: json["msg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "total": total,
    "status": status,
    "msg": msg,
  };
}
