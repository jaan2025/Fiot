import 'dart:convert';


class LoginResponse {

  String JSON_ID;
  String USER_ID;
  LoginVerifyResponse DATA;

  LoginResponse({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });


  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    JSON_ID : json["JSON_ID"],
    USER_ID: json["USER_ID"],
    DATA: LoginVerifyResponse.fromJson(json["DATA"]),
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

class LoginVerifyResponse {
  String MSG;

  LoginVerifyResponse({
    required this.MSG,
  });

  factory LoginVerifyResponse.fromJson(Map<String, dynamic> json) => LoginVerifyResponse(
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