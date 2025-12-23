class Loginmodel {
  Data? data;
  String? status;
  String? msg;

  Loginmodel({this.data, this.status, this.msg});

  factory Loginmodel.fromJson(Map<String, dynamic> json) => Loginmodel(
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "status": status,
    "msg": msg,
  };
}

class Data {
  String? userId;
  String? name;
  String? email;
  int? phoneNo;
  String? gender;
  DateTime? dateOfBirth;
  int? isVerified;
  String? profileImage;
  String? coverImage;
  String? accessToken;
  String? refreshToken;
  int? isOfficial;

  Data({
    this.userId,
    this.name,
    this.email,
    this.phoneNo,
    this.gender,
    this.dateOfBirth,
    this.isVerified,
    this.profileImage,
    this.coverImage,
    this.accessToken,
    this.refreshToken,
    this.isOfficial,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"] ?? "",
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    phoneNo: json["phone_no"] ?? 0,
    gender: json["gender"] ?? "",
    dateOfBirth:
        json["date_of_birth"] != null
            ? DateTime.tryParse(json["date_of_birth"])
            : null,
    isVerified: json["is_verified"] ?? 0,
    profileImage: json["profile_image"] ?? "",
    coverImage: json["cover_image"] ?? "",
    accessToken: json["access_token"] ?? "",
    refreshToken: json["refresh_token"] ?? "",
    isOfficial: json["is_official"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "email": email,
    "phone_no": phoneNo,
    "gender": gender,
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "profile_image": profileImage,
    "cover_image": coverImage,
    "is_verified": isVerified,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "is_official": isOfficial,
  };
}
