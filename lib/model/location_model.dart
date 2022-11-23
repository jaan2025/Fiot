/*


class MyLocationModel {
  MyLocationModel({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.hourlyUnits,
    this.hourly,
  });

  dynamic latitude;
  dynamic longitude;
  dynamic generationtimeMs;
  dynamic utcOffsetSeconds;
  String? timezone;
  String ?timezoneAbbreviation;
  dynamic elevation;
  HourlyUnits ?hourlyUnits;
  Hourly? hourly;

  factory MyLocationModel.fromJson(Map<String, dynamic> json) => MyLocationModel(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    generationtimeMs: json["generationtime_ms"].toDouble(),
    utcOffsetSeconds: json["utc_offset_seconds"],
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    elevation: json["elevation"],
    hourlyUnits: HourlyUnits.fromJson(json["hourly_units"]),
    hourly: Hourly.fromJson(json["hourly"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "hourly_units": hourlyUnits!.toJson(),
    "hourly": hourly!.toJson(),
  };
}

class Hourly {
  Hourly({
    this.time,
    this.temperature2M,

  });

  List<String> ?time;
  List<dynamic> ?temperature2M;


  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: List<String>.from(json["time"].map((x) => x)),
    temperature2M: List<dynamic>.from(json["temperature_2m"].map((x) => x.toDouble())),

  );

  Map<String, dynamic> toJson() => {
    "time": List<dynamic>.from(time!.map((x) => x)),
    "temperature_2m": List<dynamic>.from(temperature2M!.map((x) => x)),
  };
}

class HourlyUnits {
  HourlyUnits({
    this.time,
    this.temperature2M,

  });
  String ?time;
  String ?temperature2M;


  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    temperature2M: json["temperature_2m"],

  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,

  };
}
*/
