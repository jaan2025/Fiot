import 'dart:convert';


class OTPResponse {

  String JSON_ID;
  String USER_ID;
  OTPVerifyResponse DATA;

  OTPResponse({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });


  factory OTPResponse.fromJson(Map<String, dynamic> json) => OTPResponse(
    JSON_ID : json["JSON_ID"],
    USER_ID: json["USER_ID"],
    DATA: OTPVerifyResponse.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson(data) {
    return {
      jsonEncode("JSON_ID"): jsonEncode(JSON_ID),
      jsonEncode("USER_ID"): jsonEncode(USER_ID),
      jsonEncode("DATA"): jsonEncode(DATA.toJson()),
    };
  }

  @override
  String toString() {
    return '{"JSON_ID":"$JSON_ID","USER_ID":"$USER_ID","DATA":$DATA}';
  }
}

class OTPVerifyResponse {
  String MSG;

  OTPVerifyResponse({
    required this.MSG,
  });

  factory OTPVerifyResponse.fromJson(Map<String, dynamic> json) => OTPVerifyResponse(
    MSG: json["MSG"],
  );

  Map<String, dynamic> toJson() {
    return {
      jsonEncode("MSG"): jsonEncode(MSG),
    };
  }
  @override
  String toString() {
    return '{"MSG":"$MSG"}';
  }
}