import 'dart:convert';

Addfriendmodel addfriendmodelFromJson(String str) =>
    Addfriendmodel.fromJson(json.decode(str));

String addfriendmodelToJson(Addfriendmodel data) => json.encode(data.toJson());

class Addfriendmodel {
  String status;
  String msg;

  Addfriendmodel({required this.status, required this.msg});

  factory Addfriendmodel.fromJson(Map<String, dynamic> json) =>
      Addfriendmodel(status: json["status"] ?? "", msg: json["msg"] ?? "");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
