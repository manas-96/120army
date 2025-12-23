class Notificationlistmodel {
  List<Notificationdata>? data;
  String? status;
  String? msg;

  Notificationlistmodel({this.data, this.status, this.msg});

  factory Notificationlistmodel.fromJson(Map<String, dynamic>? json) =>
      Notificationlistmodel(
        data:
            json?["data"] == null
                ? []
                : List<Notificationdata>.from(
                  json!["data"].map((x) => Notificationdata.fromJson(x)),
                ),
        status: json?["status"] ?? "",
        msg: json?["msg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status ?? "",
    "msg": msg ?? "",
  };
}

class Notificationdata {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImage;
  int? id;
  int? senderUserId;
  int? receiverUserId;
  int? referenceTableId;
  String? notificationType;
  String? type;
  String? msg;
  int? isRead;

  Notificationdata({
    this.userId,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.id,
    this.senderUserId,
    this.receiverUserId,
    this.referenceTableId,
    this.notificationType,
    this.type,
    this.msg,
    this.isRead,
  });

  factory Notificationdata.fromJson(Map<String, dynamic>? json) =>
      Notificationdata(
        userId: json?["user_id"] ?? 0,
        firstName: json?["first_name"] ?? "",
        lastName: json?["last_name"] ?? "",
        profileImage: json?["profile_image"] ?? "",
        id: json?["id"] ?? 0,
        senderUserId: json?["sender_user_id"] ?? 0,
        receiverUserId: json?["receiver_user_id"] ?? 0,
        referenceTableId: json?["reference_table_id"] ?? 0,
        notificationType: json?["notification_type"] ?? "",
        type: json?["type"] ?? "",
        msg: json?["msg"] ?? "",
        isRead: json?["is_read"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId ?? 0,
    "first_name": firstName ?? "",
    "last_name": lastName ?? "",
    "profile_image": profileImage ?? "",
    "id": id ?? 0,
    "sender_user_id": senderUserId ?? 0,
    "receiver_user_id": receiverUserId ?? 0,
    "reference_table_id": referenceTableId ?? 0,
    "notification_type": notificationType ?? "",
    "type": type ?? "",
    "msg": msg ?? "",
    "is_read": isRead ?? 0,
  };
}
