class Otpverifymodel {
  String? status;
  String? msg;

  Otpverifymodel({this.status, this.msg});

  factory Otpverifymodel.fromJson(Map<String, dynamic> json) {
    String? parsedMsg;

    if (json['msg'] is List) {
      // Join list of strings into a single string
      parsedMsg = (json['msg'] as List).join(', ');
    } else if (json['msg'] is String) {
      parsedMsg = json['msg'];
    } else {
      parsedMsg = '';
    }

    return Otpverifymodel(status: json['status'] ?? '', msg: parsedMsg);
  }

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
