import 'dart:convert';

ForgotpasswordModel forgotpasswordModelFromJson(String str) =>
    ForgotpasswordModel.fromJson(json.decode(str));

String forgotpasswordModelToJson(ForgotpasswordModel data) =>
    json.encode(data.toJson());

class ForgotpasswordModel {
  final Data? data;
  final String? status;
  final dynamic msg; // Can be String or List<String>

  ForgotpasswordModel({this.data, this.status, this.msg});

  factory ForgotpasswordModel.fromJson(Map<String, dynamic> json) =>
      ForgotpasswordModel(
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
        status: json["status"],
        msg: json["msg"], // can be String or List
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "status": status,
    "msg": msg,
  };

  /// Helper getter for msg (always returns readable string)
  String get message {
    if (msg is String) return msg;
    if (msg is List) return (msg as List).join(', ');
    return '';
  }
}

class Data {
  final String? userId;

  Data({this.userId});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(userId: json["user_id"]);

  Map<String, dynamic> toJson() => {"user_id": userId};
}
