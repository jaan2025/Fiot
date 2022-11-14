import 'dart:convert';

import 'package:generic_iot_sensor/model/user.dart';

class RegisterResponseData {

  String JSON_ID;
  String USER_ID;
  RegisterUserResponse DATA;

  RegisterResponseData({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });


  factory RegisterResponseData.fromJson(Map<String, dynamic> json) => RegisterResponseData(
    JSON_ID : json["JSON_ID"],
    USER_ID: json["USER_ID"],
    DATA: RegisterUserResponse.fromJson(json["DATA"]),
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

class RegisterUserResponse {
  String OTP;
  String MSG;

  RegisterUserResponse({
    required this.OTP,
    required this.MSG,
  });

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) => RegisterUserResponse(
    OTP: json["OTP"],
    MSG: json["MSG"],
  );

  /*Map<String, dynamic> toJson() => {
    "OTP": OTP,
    "MSG": MSG,
  };*/

  Map<String, dynamic> toJson() {
    return {
      jsonEncode("OTP"): jsonEncode(OTP),
      jsonEncode("MSG"): jsonEncode(MSG),
    };
  }
  @override
  String toString() {
    return '{"OTP":"$OTP","MSG":"$MSG"}';
  }
}