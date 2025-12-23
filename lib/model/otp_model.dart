class Otpmodel {
  String? status;
  String? msg;

  Otpmodel({this.status, this.msg});

  factory Otpmodel.fromJson(Map<String, dynamic> json) {
    String? parsedMsg;

    if (json['msg'] is List) {
      // Join list of strings into a single string
      parsedMsg = (json['msg'] as List).join(', ');
    } else if (json['msg'] is String) {
      parsedMsg = json['msg'];
    } else {
      parsedMsg = '';
    }

    return Otpmodel(status: json['status'] ?? '', msg: parsedMsg);
  }

  Map<String, dynamic> toJson() => {"status": status, "msg": msg};
}
