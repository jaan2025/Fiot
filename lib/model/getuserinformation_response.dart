import 'package:equatable/equatable.dart';

class GetUserResponseData {

  String JSON_ID;
  String USER_ID;
  User DATA;

  GetUserResponseData({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });

  factory GetUserResponseData.fromJson(Map<String, dynamic> json) => GetUserResponseData(
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

class User extends Equatable{

  final String id;
  final int USER_ID;
  final String USER_NAME;
  final String PASSWORD;
  final String EMAIL_ID;
  final String MOBILE_NO;
  final String MOBILE_KEY;
  final String ISACTIVE;
  final Unit UNITS;
  final Location LOCATIONS;

  const User({
    required this.id,
    required this.USER_ID,
    required this.USER_NAME,
    required this.PASSWORD,
    required this.EMAIL_ID,
    required this.MOBILE_NO,
    required this.MOBILE_KEY,
    required this.ISACTIVE,
    required this.UNITS,
    required this.LOCATIONS,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    USER_ID: json["USER_ID"],
    USER_NAME: json["USER_NAME"],
    PASSWORD: json["PASSWORD"],
    EMAIL_ID: json["EMAIL_ID"],
    MOBILE_NO: json["MOBILE_NO"],
    MOBILE_KEY: json["MOBILE_KEY"],
    ISACTIVE: json["ISACTIVE"],
    UNITS:  Unit.fromJson(json["UNITS"]),
    LOCATIONS:  Location.fromJson(json["LOCATIONS"]),
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "USER_ID": USER_ID,
    "USER_NAME": USER_NAME,
    "PASSWORD": PASSWORD,
    "EMAIL_ID": EMAIL_ID,
    "MOBILE_NO": MOBILE_NO,
    "MOBILE_KEY": MOBILE_KEY,
    "ISACTIVE": ISACTIVE,
    "UNITS": UNITS,
    "LOCATIONS": LOCATIONS,
  };

  @override
  List<Object?> get props => [id,USER_ID, USER_NAME, PASSWORD, EMAIL_ID, MOBILE_NO, MOBILE_KEY, ISACTIVE, UNITS, LOCATIONS];
}

class Unit {
  String UNIT_ID;
  String IP;
  String PORT;
  String MAC_ID;
  String KEEPALIVE_TIME;
  String COMMUNICATION_ID;
  String VERSION;
  String LOCATION;
  String ISACTIVE;

  Unit({
     required this.UNIT_ID,
     required this.IP,
     required this.PORT,
     required this.MAC_ID,
     required this.KEEPALIVE_TIME,
     required this.COMMUNICATION_ID,
     required this.VERSION,
     required this.LOCATION,
     required this.ISACTIVE,
  });



  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    UNIT_ID: json["UNIT_ID"],
    IP: json["IP"],
    PORT: json["PORT"],
    MAC_ID: json["MAC_ID"],
    KEEPALIVE_TIME: json["KEEPALIVE_TIME"],
    COMMUNICATION_ID: json["COMMUNICATION_ID"],
    VERSION: json["VERSION"],
    LOCATION: json["LOCATION"],
    ISACTIVE: json["ISACTIVE"],
  );

  Map<String, dynamic> toJson() => {
    "UNIT_ID": UNIT_ID,
    "IP": IP,
    "PORT": PORT,
    "MAC_ID": MAC_ID,
    "KEEPALIVE_TIME": KEEPALIVE_TIME,
    "COMMUNICATION_ID": COMMUNICATION_ID,
    "VERSION": VERSION,
    "LOCATION": LOCATION,
    "ISACTIVE": ISACTIVE,
  };
}

class Location {
  String LOCATION_ID;
  String LOCATION_NAME;
  String LOCATION_SUBNAME;
  String ISACTIVE;

  Location({
    required this.LOCATION_ID,
    required this.LOCATION_NAME,
    required this.LOCATION_SUBNAME,
    required this.ISACTIVE,
  });



  factory Location.fromJson(Map<String, dynamic> json) => Location(
    LOCATION_ID: json["LOCATION_ID"],
    LOCATION_NAME: json["LOCATION_NAME"] ?? "TestLoc",
    LOCATION_SUBNAME: json["LOCATION_SUBNAME"] ?? "Test",
    ISACTIVE: json["ISACTIVE"],
  );

  Map<String, dynamic> toJson() => {
    "LOCATION_ID": LOCATION_ID,
    "LOCATION_NAME": LOCATION_NAME,
    "LOCATION_SUBNAME": LOCATION_SUBNAME,
    "ISACTIVE": ISACTIVE,
  };
}