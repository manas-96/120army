import 'dart:convert';

Profilemodel profilemodelFromJson(String str) =>
    Profilemodel.fromJson(json.decode(str));

String profilemodelToJson(Profilemodel data) => json.encode(data.toJson());

class Profilemodel {
  final Profiledata data;
  final String status;
  final String msg;

  Profilemodel({required this.data, required this.status, required this.msg});

  factory Profilemodel.fromJson(Map<String, dynamic> json) => Profilemodel(
    data: Profiledata.fromJson(json["data"] ?? {}),
    status: json["status"] ?? "N/A",
    msg: json["msg"] ?? "N/A",
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
    "msg": msg,
  };
}

class Profiledata {
  final String firstName;
  final String lastName;
  final String bio;
  final String email;
  final int phoneNo;
  final String gender;
  final DateTime dateOfBirth;
  final int isVerified;
  final String emailPrivacy;
  final String bithdayPrivacy;
  final String language;
  final String placesLived;
  final String languagePrivacy;
  final String profileImage;
  final String coverImage;
  final String phoneNoPrivacy;
  final int isActive;
  final String createdAt;

  Profiledata({
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.email,
    required this.phoneNo,
    required this.gender,
    required this.dateOfBirth,
    required this.isVerified,
    required this.emailPrivacy,
    required this.bithdayPrivacy,
    required this.language,
    required this.placesLived,
    required this.languagePrivacy,
    required this.profileImage,
    required this.coverImage,
    required this.phoneNoPrivacy,
    required this.isActive,
    required this.createdAt,
  });

  factory Profiledata.fromJson(Map<String, dynamic> json) => Profiledata(
    firstName: json["first_name"] ?? "N/A",
    lastName: json["last_name"] ?? "N/A",
    bio: json["bio"] ?? "N/A",
    email: json["email"] ?? "N/A",
    phoneNo: json["phone_no"] ?? 0,
    gender: json["gender"] ?? "N/A",
    dateOfBirth:
        json["date_of_birth"] != null
            ? DateTime.tryParse(json["date_of_birth"]) ?? DateTime(2000, 1, 1)
            : DateTime(2000, 1, 1),
    isVerified: json["is_verified"] ?? 0,
    emailPrivacy: json["email_privacy"] ?? "N/A",
    bithdayPrivacy: json["bithday_privacy"] ?? "N/A",
    language: json["language"] ?? "N/A",
    placesLived: json["places_lived"] ?? "N/A",
    languagePrivacy: json["language_privacy"] ?? "N/A",
    profileImage: json["profile_image"] ?? "",
    coverImage: json["cover_image"] ?? "",
    phoneNoPrivacy: json["phone_no_privacy"] ?? "N/A",
    isActive: json["is_active"] ?? 0,
    createdAt: json["created_at"] ?? "N/A",
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "bio": bio,
    "email": email,
    "phone_no": phoneNo,
    "gender": gender,
    "date_of_birth": dateOfBirth.toIso8601String(),
    "is_verified": isVerified,
    "email_privacy": emailPrivacy,
    "bithday_privacy": bithdayPrivacy,
    "language": language,
    "places_lived": placesLived,
    "language_privacy": languagePrivacy,
    "profile_image": profileImage,
    "cover_image": coverImage,
    "phone_no_privacy": phoneNoPrivacy,
    "is_active": isActive,
    "created_at": createdAt,
  };
}
