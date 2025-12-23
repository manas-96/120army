import 'dart:convert';

// ---------- Root ----------
Postdatalist postdatalistFromJson(String str) =>
    Postdatalist.fromJson(json.decode(str));

String postdatalistToJson(Postdatalist data) => json.encode(data.toJson());

class Postdatalist {
  List<PostlistDatum> data;
  int total;
  String status;
  String msg;

  Postdatalist({
    required this.data,
    required this.total,
    required this.status,
    required this.msg,
  });

  factory Postdatalist.fromJson(Map<String, dynamic> json) => Postdatalist(
    data:
        json["data"] == null
            ? []
            : List<PostlistDatum>.from(
              json["data"].map((x) => PostlistDatum.fromJson(x)),
            ),
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

// ---------- Post List Item ----------
class PostlistDatum {
  int id;
  int userId;
  dynamic postId;
  String post;
  String type;
  String privacy;
  String location;
  int likes;
  int shares;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String profileImage;
  int isLiked;
  int commentCount;
  List<FileElement> files;
  List<TaggedUser> taggedUsers;
  List<dynamic> comments;
  bool ownPost;
  bool isHidden;

  PostlistDatum({
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
    required this.isLiked,
    required this.commentCount,
    required this.files,
    required this.taggedUsers,
    required this.comments,
    required this.ownPost,
    this.isHidden = false,
  });

  factory PostlistDatum.fromJson(Map<String, dynamic> json) => PostlistDatum(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    postId: json["post_id"],
    post: json["post"] ?? "",
    type: json["type"] ?? "",
    privacy: json["privacy"] ?? "",
    location: json["location"] ?? "",
    likes: json["likes"] ?? 0,
    shares: json["shares"] ?? 0,
    isDeleted: json["is_deleted"] ?? 0,
    createdAt:
        json["created_at"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["created_at"]) ?? DateTime.now(),
    updatedAt:
        json["updated_at"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["updated_at"]) ?? DateTime.now(),
    name: json["name"] ?? "",
    profileImage: json["profile_image"] ?? "",
    isLiked: json["is_liked"] ?? 0,
    commentCount: json["comment_count"] ?? 0,
    files:
        json["files"] == null
            ? []
            : List<FileElement>.from(
              json["files"].map((x) => FileElement.fromJson(x)),
            ),
    taggedUsers:
        json["tagged_users"] == null
            ? []
            : List<TaggedUser>.from(
              json["tagged_users"].map((x) => TaggedUser.fromJson(x)),
            ),
    comments:
        json["comments"] == null
            ? []
            : List<dynamic>.from(json["comments"].map((x) => x)),
    ownPost: json["own_post"] ?? false,
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
    "is_liked": isLiked,
    "comment_count": commentCount,
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
    "tagged_users": List<dynamic>.from(taggedUsers.map((x) => x.toJson())),
    "comments": List<dynamic>.from(comments.map((x) => x)),
    "own_post": ownPost,
  };
}

// ---------- Tagged User ----------
class TaggedUser {
  int postId;
  int taggedUserId;
  String firstName;
  String lastName;
  String name;

  TaggedUser({
    required this.postId,
    required this.taggedUserId,
    required this.firstName,
    required this.lastName,
    required this.name,
  });

  factory TaggedUser.fromJson(Map<String, dynamic> json) => TaggedUser(
    postId: json["post_id"] ?? 0,
    taggedUserId: json["tagged_user_id"] ?? 0,
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    name: json["name"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "post_id": postId,
    "tagged_user_id": taggedUserId,
    "first_name": firstName,
    "last_name": lastName,
    "name": name,
  };
}

// ---------- File Element ----------
class FileElement {
  int id;
  int userId;
  int postId;
  String fileType;
  String fileFor;
  String fileUrls;
  DateTime createdAt;
  DateTime updatedAt;

  FileElement({
    required this.id,
    required this.userId,
    required this.postId,
    required this.fileType,
    required this.fileFor,
    required this.fileUrls,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    postId: json["post_id"] ?? 0,
    fileType: json["file_type"] ?? "",
    fileFor: json["file_for"] ?? "",
    fileUrls: json["file_urls"] ?? "",
    createdAt:
        json["created_at"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["created_at"]) ?? DateTime.now(),
    updatedAt:
        json["updated_at"] == null
            ? DateTime.now()
            : DateTime.tryParse(json["updated_at"]) ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "post_id": postId,
    "file_type": fileType,
    "file_for": fileFor,
    "file_urls": fileUrls,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
