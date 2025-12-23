import 'dart:convert';

Confirmmodel confirmFromJson(String str) =>
    Confirmmodel.fromJson(json.decode(str));

String confirmToJson(Confirmmodel data) => json.encode(data.toJson());

class Confirmmodel {
  final String status;
  final String msg;

  Confirmmodel({required this.status, required this.msg});

  factory Confirmmodel.fromJson(Map<String, dynamic> json) =>
      Confirmmodel(status: json["status"] ?? "", msg: json["msg"] ?? "");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
