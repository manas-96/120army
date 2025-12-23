import 'dart:convert';

Otherprofilemodel otherprofilemodelFromJson(String str) =>
    Otherprofilemodel.fromJson(json.decode(str));

String otherprofilemodelToJson(Otherprofilemodel data) =>
    json.encode(data.toJson());

class Otherprofilemodel {
  List<PostDatum>? postData;
  ProfileData? profileData;
  int? total;
  String? status;
  String? msg;

  Otherprofilemodel({
    this.postData,
    this.profileData,
    this.total,
    this.status,
    this.msg,
  });

  factory Otherprofilemodel.fromJson(Map<String, dynamic> json) =>
      Otherprofilemodel(
        postData:
            json["postData"] == null
                ? []
                : List<PostDatum>.from(
                  json["postData"].map((x) => PostDatum.fromJson(x)),
                ),
        profileData:
            json["profileData"] == null
                ? null
                : ProfileData.fromJson(json["profileData"]),
        total: json["total"] ?? 0,
        status: json["status"] ?? "",
        msg: json["msg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "postData":
        postData == null
            ? []
            : List<dynamic>.from(postData!.map((x) => x.toJson())),
    "profileData": profileData?.toJson(),
    "total": total ?? 0,
    "status": status ?? "",
    "msg": msg ?? "",
  };
}

class PostDatum {
  int? id;
  int? userId;
  String? post;
  String? type;
  String? privacy;
  String? location;
  int? likes;
  int? shares;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? profileImage;
  int? isLiked;
  int? commentCount;
  List<FileElement>? files;
  List<TaggedUser>? taggedUsers;
  List<dynamic>? comments;
  bool ownPost;

  PostDatum({
    this.id,
    this.userId,
    this.post,
    this.type,
    this.privacy,
    this.location,
    this.likes,
    this.shares,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.profileImage,
    this.isLiked,
    this.commentCount,
    this.files,
    this.taggedUsers,
    this.comments,
    required this.ownPost,
  });

  factory PostDatum.fromJson(Map<String, dynamic> json) => PostDatum(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    post: json["post"] ?? "",
    type: json["type"] ?? "",
    privacy: json["privacy"] ?? "",
    location: json["location"] ?? "",
    likes: json["likes"] ?? 0,
    shares: json["shares"] ?? 0,
    isDeleted: json["is_deleted"] ?? 0,
    createdAt:
        json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"]),
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
    comments: json["comments"] ?? [],
    ownPost: json["own_post"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? 0,
    "user_id": userId ?? 0,
    "post": post ?? "",
    "type": type ?? "",
    "privacy": privacy ?? "",
    "location": location ?? "",
    "likes": likes ?? 0,
    "shares": shares ?? 0,
    "is_deleted": isDeleted ?? 0,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "name": name ?? "",
    "profile_image": profileImage ?? "",
    "is_liked": isLiked,
    "comment_count": commentCount,
    "files":
        files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
    "tagged_users":
        taggedUsers == null
            ? []
            : List<dynamic>.from(taggedUsers!.map((x) => x.toJson())),
    "comments": comments ?? [],
    "own_post": ownPost,
  };
}

class FileElement {
  int? id;
  int? userId;
  int? postId;
  String? fileType;
  String? fileFor;
  String? fileUrls;
  DateTime? createdAt;
  DateTime? updatedAt;

  FileElement({
    this.id,
    this.userId,
    this.postId,
    this.fileType,
    this.fileFor,
    this.fileUrls,
    this.createdAt,
    this.updatedAt,
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
            ? null
            : DateTime.tryParse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? 0,
    "user_id": userId ?? 0,
    "post_id": postId ?? 0,
    "file_type": fileType ?? "",
    "file_for": fileFor ?? "",
    "file_urls": fileUrls ?? "",
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ProfileData {
  String? firstName;
  String? lastName;
  String? bio;
  String? email;
  String? emailPrivacy;
  String? gender;
  DateTime? dateOfBirth;
  String? bithdayPrivacy;
  String? language;
  String? placesLived;
  String? languagePrivacy;
  String? profileImage;
  String? coverImage;
  int? phoneNo;
  String? phoneNoPrivacy;
  int? isVerified;
  int? isActive;
  int? isOnline;
  String? timezone;
  DateTime? createdAt;
  int? friendCount;
  FriendStatus? friendStatus;

  ProfileData({
    this.firstName,
    this.lastName,
    this.bio,
    this.email,
    this.emailPrivacy,
    this.gender,
    this.dateOfBirth,
    this.bithdayPrivacy,
    this.language,
    this.placesLived,
    this.languagePrivacy,
    this.profileImage,
    this.coverImage,
    this.phoneNo,
    this.phoneNoPrivacy,
    this.isVerified,
    this.isActive,
    this.isOnline,
    this.timezone,
    this.createdAt,
    this.friendCount,
    this.friendStatus,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    bio: json["bio"] ?? "",
    email: json["email"] ?? "",
    emailPrivacy: json["email_privacy"] ?? "",
    gender: json["gender"] ?? "",
    dateOfBirth:
        json["date_of_birth"] == null
            ? null
            : DateTime.tryParse(json["date_of_birth"]),
    bithdayPrivacy: json["bithday_privacy"] ?? "",
    language: json["language"] ?? "",
    placesLived: json["places_lived"] ?? "",
    languagePrivacy: json["language_privacy"] ?? "",
    profileImage: json["profile_image"] ?? "",
    coverImage: json["cover_image"] ?? "",
    phoneNo: json["phone_no"] ?? 0,
    phoneNoPrivacy: json["phone_no_privacy"] ?? "",
    isVerified: json["is_verified"] ?? 0,
    isActive: json["is_active"] ?? 0,
    isOnline: json["is_online"] ?? 0,
    timezone: json["timezone"] ?? "",
    createdAt:
        json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
    friendCount: json["friendCount"] ?? 0,
    friendStatus:
        json["friendStatus"] == null
            ? null
            : FriendStatus.fromJson(json["friendStatus"]),
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName ?? "",
    "last_name": lastName ?? "",
    "bio": bio ?? "",
    "email": email ?? "",
    "email_privacy": emailPrivacy ?? "",
    "gender": gender ?? "",
    "date_of_birth":
        dateOfBirth == null
            ? null
            : "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "bithday_privacy": bithdayPrivacy ?? "",
    "language": language ?? "",
    "places_lived": placesLived ?? "",
    "language_privacy": languagePrivacy ?? "",
    "profile_image": profileImage ?? "",
    "cover_image": coverImage ?? "",
    "phone_no": phoneNo ?? 0,
    "phone_no_privacy": phoneNoPrivacy ?? "",
    "is_verified": isVerified ?? 0,
    "is_active": isActive ?? 0,
    "is_online": isOnline ?? 0,
    "timezone": timezone ?? "",
    "created_at": createdAt?.toIso8601String(),
    "friendCount": friendCount ?? 0,
    "friendStatus": friendStatus?.toJson(),
  };
}

class FriendStatus {
  bool? isFriend;
  String? status;

  FriendStatus({this.isFriend, this.status});

  factory FriendStatus.fromJson(Map<String, dynamic> json) => FriendStatus(
    isFriend: json["isFriend"] ?? false,
    status: json["status"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "isFriend": isFriend ?? false,
    "status": status ?? "",
  };
}

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
