import 'dart:convert';

Accountdelete addfriendmodelFromJson(String str) =>
    Accountdelete.fromJson(json.decode(str));

String addfriendmodelToJson(Accountdelete data) => json.encode(data.toJson());

class Accountdelete {
  String status;
  String msg;

  Accountdelete({required this.status, required this.msg});

  factory Accountdelete.fromJson(Map<String, dynamic> json) =>
      Accountdelete(status: json["status"] ?? "", msg: json["msg"] ?? "");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
