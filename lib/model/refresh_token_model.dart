class Refreshtokenmodel {
  Data data;
  String status;
  String msg;

  Refreshtokenmodel({
    required this.data,
    required this.status,
    required this.msg,
  });

  factory Refreshtokenmodel.fromJson(Map<String, dynamic> json) =>
      Refreshtokenmodel(
        data: Data.fromJson(json["data"] ?? {}),
        status: json["status"] ?? "N/A",
        msg: json["msg"] ?? "N/A",
      );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
    "msg": msg,
  };
}

class Data {
  String accessToken;
  String refreshToken;

  Data({required this.accessToken, required this.refreshToken});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["access_token"] ?? "N/A", // Handle null access_token
    refreshToken: json["refresh_token"] ?? "N/A", // Handle null refresh_token
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };
}
