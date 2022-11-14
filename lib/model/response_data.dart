import 'package:generic_iot_sensor/model/user.dart';

class ResponseData {

  String JSON_ID;
  String USER_ID;
  User DATA;

  ResponseData({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    JSON_ID: json["JSON_ID"],
    USER_ID: json["USER_ID"],
    DATA: User.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson() => {
    "JSON_ID": JSON_ID,
    "USER_ID": USER_ID,
    "DATA": DATA.toJson(),
  };
}