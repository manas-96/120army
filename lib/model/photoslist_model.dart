import 'dart:convert';

Photoslist photoslistFromJson(String str) =>
    Photoslist.fromJson(json.decode(str));

String photoslistToJson(Photoslist data) => json.encode(data.toJson());

class Photoslist {
  List<PhotolistDatum>? data;
  String? status;
  String? msg;

  Photoslist({this.data, this.status, this.msg});

  factory Photoslist.fromJson(Map<String, dynamic> json) => Photoslist(
    data:
        json["data"] == null
            ? []
            : List<PhotolistDatum>.from(
              (json["data"] as List).map((x) => PhotolistDatum.fromJson(x)),
            ),
    status: json["status"] ?? "",
    msg: json["msg"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status ?? "",
    "msg": msg ?? "",
  };
}

class PhotolistDatum {
  String? fileUrls;
  String? fileType;

  PhotolistDatum({this.fileUrls, this.fileType});

  factory PhotolistDatum.fromJson(Map<String, dynamic> json) => PhotolistDatum(
    fileUrls: json["file_urls"] ?? "",
    fileType: json["file_type"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "file_urls": fileUrls ?? "",
    "file_type": fileType ?? "",
  };
}
