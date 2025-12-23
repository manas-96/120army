import 'dart:convert';

Profileupdatemodel profileupdatemodelFromJson(String str) =>
    Profileupdatemodel.fromJson(json.decode(str));

String profileupdatemodelToJson(Profileupdatemodel data) =>
    json.encode(data.toJson());

class Profileupdatemodel {
  Data data;
  String status;
  String msg;

  Profileupdatemodel({
    required this.data,
    required this.status,
    required this.msg,
  });

  factory Profileupdatemodel.fromJson(Map<String, dynamic> json) =>
      Profileupdatemodel(
        data: json["data"] != null ? Data.fromJson(json["data"]) : Data.empty(),
        status: json["status"] ?? "",
        msg: json["msg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
    "msg": msg,
  };
}

class Data {
  String firstName;
  String lastName;
  String bio;
  String email;
  String emailPrivacy;
  String gender;
  DateTime? dateOfBirth;
  String bithdayPrivacy;
  String language;
  String placesLived;
  String languagePrivacy;
  String profileImage;
  String coverImage;
  int phoneNo;
  dynamic countryCode;
  String phoneNoPrivacy;
  int isVerified;
  int isActive;
  int isOnline;
  String timezone;
  DateTime? createdAt;

  Data({
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.email,
    required this.emailPrivacy,
    required this.gender,
    required this.dateOfBirth,
    required this.bithdayPrivacy,
    required this.language,
    required this.placesLived,
    required this.languagePrivacy,
    required this.profileImage,
    required this.coverImage,
    required this.phoneNo,
    required this.countryCode,
    required this.phoneNoPrivacy,
    required this.isVerified,
    required this.isActive,
    required this.isOnline,
    required this.timezone,
    required this.createdAt,
  });

  /// Empty constructor (all defaults)
  factory Data.empty() => Data(
    firstName: "",
    lastName: "",
    bio: "",
    email: "",
    emailPrivacy: "",
    gender: "",
    dateOfBirth: null,
    bithdayPrivacy: "",
    language: "",
    placesLived: "",
    languagePrivacy: "",
    profileImage: "",
    coverImage: "",
    phoneNo: 0,
    countryCode: null,
    phoneNoPrivacy: "",
    isVerified: 0,
    isActive: 0,
    isOnline: 0,
    timezone: "",
    createdAt: null,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    bio: json["bio"] ?? "",
    email: json["email"] ?? "",
    emailPrivacy: json["email_privacy"] ?? "",
    gender: json["gender"] ?? "",
    dateOfBirth:
        json["date_of_birth"] != null
            ? DateTime.tryParse(json["date_of_birth"])
            : null,
    bithdayPrivacy: json["bithday_privacy"] ?? "",
    language: json["language"] ?? "",
    placesLived: json["places_lived"] ?? "",
    languagePrivacy: json["language_privacy"] ?? "",
    profileImage: json["profile_image"] ?? "",
    coverImage: json["cover_image"] ?? "",
    phoneNo: json["phone_no"] ?? 0,
    countryCode: json["country_code"],
    phoneNoPrivacy: json["phone_no_privacy"] ?? "",
    isVerified: json["is_verified"] ?? 0,
    isActive: json["is_active"] ?? 0,
    isOnline: json["is_online"] ?? 0,
    timezone: json["timezone"] ?? "",
    createdAt:
        json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "bio": bio,
    "email": email,
    "email_privacy": emailPrivacy,
    "gender": gender,
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "bithday_privacy": bithdayPrivacy,
    "language": language,
    "places_lived": placesLived,
    "language_privacy": languagePrivacy,
    "profile_image": profileImage,
    "cover_image": coverImage,
    "phone_no": phoneNo,
    "country_code": countryCode,
    "phone_no_privacy": phoneNoPrivacy,
    "is_verified": isVerified,
    "is_active": isActive,
    "is_online": isOnline,
    "timezone": timezone,
    "created_at": createdAt?.toIso8601String(),
  };
}
