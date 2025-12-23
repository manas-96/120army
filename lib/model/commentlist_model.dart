import 'dart:convert';

Commentlistmodel commentlistmodelFromJson(String str) =>
    Commentlistmodel.fromJson(json.decode(str));

String commentlistmodelToJson(Commentlistmodel data) =>
    json.encode(data.toJson());

class Commentlistmodel {
  List<Commentlist> data;
  String status;
  String msg;

  Commentlistmodel({
    required this.data,
    required this.status,
    required this.msg,
  });

  factory Commentlistmodel.fromJson(Map<String, dynamic> json) =>
      Commentlistmodel(
        data:
            json["data"] == null
                ? []
                : List<Commentlist>.from(
                  json["data"].map((x) => Commentlist.fromJson(x ?? {})),
                ),
        status: json["status"] ?? "",
        msg: json["msg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "msg": msg,
  };
}

class Commentlist {
  int id;
  int userId;
  int postId;
  String post;
  String type;
  String privacy;
  dynamic location;
  int likes;
  int shares;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String? profileImage;
  List<Commentlist> replies;

  Commentlist({
    required this.id,
    required this.userId,
    required this.postId,
    required this.post,
    required this.type,
    required this.privacy,
    required this.location,
    required this.likes,
    required this.shares,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.profileImage,
    required this.replies,
  });

  factory Commentlist.fromJson(Map<String, dynamic> json) => Commentlist(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    postId: json["post_id"] ?? 0,
    post: json["post"] ?? "",
    type: json["type"] ?? "",
    privacy: json["privacy"] ?? "",
    location: json["location"],
    likes: json["likes"] ?? 0,
    shares: json["shares"] ?? 0,
    isDeleted: json["is_deleted"] ?? 0,
    createdAt:
        json["created_at"] != null
            ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
            : DateTime.now(),
    updatedAt:
        json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"]) ?? DateTime.now()
            : DateTime.now(),
    name: json["name"] ?? "",
    profileImage: json["profile_image"] ?? "",
    replies:
        json["replies"] == null
            ? []
            : List<Commentlist>.from(
              json["replies"].map((x) => Commentlist.fromJson(x ?? {})),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "post_id": postId,
    "post": post,
    "type": type,
    "privacy": privacy,
    "location": location,
    "likes": likes,
    "shares": shares,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "name": name,
    "profile_image": profileImage,
    "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
  };
}
