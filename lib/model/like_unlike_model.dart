// To parse this JSON data, do
//
//     final likepostmodel = likepostmodelFromJson(jsonString);

import 'dart:convert';

Likeunlikepostmodel likepostmodelFromJson(String str) =>
    Likeunlikepostmodel.fromJson(json.decode(str));

String likepostmodelToJson(Likeunlikepostmodel data) =>
    json.encode(data.toJson());

class Likeunlikepostmodel {
  final String id;
  final String name;
  final String status;

  Likeunlikepostmodel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory Likeunlikepostmodel.fromJson(Map<String, dynamic> json) =>
      Likeunlikepostmodel(
        id: json["id"]?.toString() ?? "", // if null → empty string
        name: json["name"]?.toString() ?? "",
        status: json["status"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "status": status};
}
