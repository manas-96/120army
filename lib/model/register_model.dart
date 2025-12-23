import 'dart:convert';

Registermodel registermodelFromJson(String str) =>
    Registermodel.fromJson(json.decode(str));

String registermodelToJson(Registermodel data) => json.encode(data.toJson());

class Registermodel {
  Data? data;
  String? status;
  List<String> msg;

  Registermodel({this.data, this.status, required this.msg});

  factory Registermodel.fromJson(Map<String, dynamic> json) => Registermodel(
    data:
        json["data"] != null
            ? Data.fromJson(json["data"])
            : json["date"] != null
            ? Data.fromJson(json["date"])
            : null,

    status: json["status"] ?? "",
    msg: _parseMsg(json["msg"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "status": status,
    "msg": msg,
  };

  static List<String> _parseMsg(dynamic msg) {
    if (msg is String) {
      return [msg];
    } else if (msg is List) {
      return msg.map((e) => e.toString()).toList();
    } else {
      return [];
    }
  }
}

class Data {
  String? userId;

  Data({this.userId});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(userId: json["user_id"] ?? "");

  Map<String, dynamic> toJson() => {"user_id": userId};
}
