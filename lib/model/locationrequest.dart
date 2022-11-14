import 'dart:convert';


class LocationData {

  String JSON_ID;
  String USER_ID;
  LocationDataResponse DATA;

  LocationData({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });


  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    JSON_ID : json["JSON_ID"],
    USER_ID: json["USER_ID"],
    DATA: LocationDataResponse.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson() => {
    "JSON_ID": JSON_ID,
    "USER_ID": USER_ID,
    "DATA": DATA.toJson(),
  };

  @override
  String toString() {
    return '{"JSON_ID":"$JSON_ID","USER_ID":"$USER_ID","DATA":$DATA}';
  }
}

class LocationDataResponse {
  String LOCATION_ID;
  String LOCATION_NAME;
  String LOCATION_SUBNAME;
  String ISACTIVE;

  LocationDataResponse({
    required this.LOCATION_ID,
    required this.LOCATION_NAME,
    required this.LOCATION_SUBNAME,
    required this.ISACTIVE,
  });

  factory LocationDataResponse.fromJson(Map<String, dynamic> json) => LocationDataResponse(
    LOCATION_ID: json["LOCATION_ID"],
    LOCATION_NAME: json["LOCATION_NAME"],
    LOCATION_SUBNAME: json["LOCATION_SUBNAME"],
    ISACTIVE: json["ISACTIVE"],
  );

  Map<String, dynamic> toJson() => {
    "LOCATION_ID": LOCATION_ID,
    "LOCATION_NAME": LOCATION_NAME,
    "LOCATION_SUBNAME": LOCATION_SUBNAME,
    "ISACTIVE": ISACTIVE,
  };

  @override
  String toString() {
    return '{"LOCATION_ID":"$LOCATION_ID","LOCATION_NAME":"$LOCATION_NAME","LOCATION_SUBNAME":"$LOCATION_SUBNAME","ISACTIVE":"$ISACTIVE"}';
  }
}