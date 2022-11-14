import 'dart:convert';


class  OTPVerify {

  String JSON_ID;
  String USER_ID;
  OTPDataResponse DATA;

  OTPVerify({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });


  factory OTPVerify.fromJson(Map<String, dynamic> json) => OTPVerify(
    JSON_ID : json["JSON_ID"],
    USER_ID: json["USER_ID"],
    DATA: OTPDataResponse.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson() {
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

class OTPDataResponse {
  String OTP_VERIFY;

  OTPDataResponse({
    required this.OTP_VERIFY,
  });

  factory OTPDataResponse.fromJson(Map<String, dynamic> json) => OTPDataResponse(
    OTP_VERIFY: json["OTP"],
  );

  Map<String, dynamic> toJson() {
    return {
      jsonEncode("OTP_VERIFY"): jsonEncode(OTP_VERIFY),
    };
  }
  @override
  String toString() {
    return '{"OTP_VERIFY":"$OTP_VERIFY"}';
  }
}