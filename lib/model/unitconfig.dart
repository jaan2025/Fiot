class UnitData {

  String JSON_ID;
  String USER_ID;
  Unit DATA;

  UnitData({
    required this.JSON_ID,
    required this.USER_ID,
    required this.DATA,
  });

  factory UnitData.fromJson(Map<String, dynamic> json) => UnitData(
    JSON_ID: json["JSON_ID"],
    USER_ID: json["USER_ID"],
    DATA: Unit.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson() => {
    "JSON_ID": JSON_ID,
    "USER_ID": USER_ID,
    "DATA": DATA.toJson(),
  };

}

class Unit {
  String IP;
  String PORT;
  String MAC_ID;
  String KEEPALIVE_TIME;
  String COMMUNICATION_ID;
  String VERSION;
  String LOCATION;

  Unit({
    required this.IP,
    required this.PORT,
    required this.MAC_ID,
    required this.KEEPALIVE_TIME,
    required this.COMMUNICATION_ID,
    required this.VERSION,
    required this.LOCATION,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    IP: json["IP"],
    PORT: json["PORT"],
    MAC_ID: json["MAC_ID"],
    KEEPALIVE_TIME: json["KEEPALIVE_TIME"],
    COMMUNICATION_ID: json["COMMUNICATION_ID"],
    VERSION: json["VERSION"],
    LOCATION: json["LOCATION"],
  );

  Map<String, dynamic> toJson() => {
    "IP": IP,
    "PORT": PORT,
    "MAC_ID": MAC_ID,
    "KEEPALIVE_TIME": KEEPALIVE_TIME,
    "COMMUNICATION_ID": COMMUNICATION_ID,
    "VERSION": VERSION,
    "LOCATION": LOCATION,
  };
}