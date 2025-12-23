class Createpostmodel {
  String? status;
  String? msg;

  Createpostmodel({this.status, this.msg});

  factory Createpostmodel.fromJson(Map<String, dynamic> json) =>
      Createpostmodel(status: json["status"] ?? "", msg: json["msg"] ?? "");

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
