import 'dart:convert';

Suggestfriendlistmodel suggestfriendlistmodelFromJson(String str) =>
    Suggestfriendlistmodel.fromJson(json.decode(str));

String suggestfriendlistmodelToJson(Suggestfriendlistmodel data) =>
    json.encode(data.toJson());

class Suggestfriendlistmodel {
  List<Suggestdatum> data;
  int total;
  String status;
  String msg;

  Suggestfriendlistmodel({
    required this.data,
    required this.total,
    required this.status,
    required this.msg,
  });

  factory Suggestfriendlistmodel.fromJson(Map<String, dynamic> json) =>
      Suggestfriendlistmodel(
        data:
            json["data"] != null
                ? List<Suggestdatum>.from(
                  json["data"].map((x) => Suggestdatum.fromJson(x)),
                )
                : [],
        total: json["total"] ?? 0,
        status: json["status"] ?? "",
        msg: json["msg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total": total,
    "status": status,
    "msg": msg,
  };
}

class Suggestdatum {
  int id;
  String firstName;
  String lastName;
  String bio;
  String profileImage;
  String timezone;

  Suggestdatum({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.profileImage,
    required this.timezone,
  });

  factory Suggestdatum.fromJson(Map<String, dynamic> json) => Suggestdatum(
    id: json["id"] ?? 0,
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    bio: json["bio"] ?? "",
    profileImage: json["profile_image"] ?? "",
    timezone: json["timezone"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "bio": bio,
    "profile_image": profileImage,
    "timezone": timezone,
  };
}
