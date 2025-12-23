import 'dart:convert';

Suggestfriendremovemodel suggestfriendremovemodelFromJson(String str) =>
    Suggestfriendremovemodel.fromJson(json.decode(str));

String suggestfriendremovemodelToJson(Suggestfriendremovemodel data) =>
    json.encode(data.toJson());

class Suggestfriendremovemodel {
  final String status;
  final String msg;

  Suggestfriendremovemodel({required this.status, required this.msg});

  factory Suggestfriendremovemodel.fromJson(Map<String, dynamic> json) =>
      Suggestfriendremovemodel(
        status: json["status"]?.toString() ?? '',
        msg: json["msg"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
