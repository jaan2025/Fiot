// To parse this JSON data, do
//
//     final myLocationModel = myLocationModelFromMap(jsonString);

import 'dart:convert';

class weatherModel {
  weatherModel({
    this.latitude,
    this.longitude,
    this.timezone,
    this.currently,
    this.hourly,
    this.daily,
    this.flags,
    this.offset,
  });

  double ? latitude;
  double ?longitude;
  String ?timezone;
  Currently? currently;
  Hourly? hourly;
  Daily ?daily;
  Flags ?flags;
  double ? offset;

  factory weatherModel.fromJson(String str) => weatherModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory weatherModel.fromMap(Map<String, dynamic> json) => weatherModel(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    timezone: json["timezone"],
    currently: Currently.fromMap(json["currently"]),
    hourly: Hourly.fromMap(json["hourly"]),
    daily: Daily.fromMap(json["daily"]),
    flags: Flags.fromMap(json["flags"]),
    offset: json["offset"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "latitude": latitude,
    "longitude": longitude,
    "timezone": timezone,
    "currently": currently!.toMap(),
    "hourly": hourly!.toMap(),
    "daily": daily!.toMap(),
    "flags": flags!.toMap(),
    "offset": offset,
  };
}

class Currently {
  Currently({
    this.time,
    this.summary,
    this.icon,
    this.precipIntensity,
    this.precipProbability,
    this.temperature,
    this.apparentTemperature,
    this.dewPoint,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.windGust,
    this.windBearing,
    this.cloudCover,
    this.uvIndex,
    this.visibility,
    this.ozone,
  });

  int ?time;
  Summary ?summary;
  Icon ?icon;
  dynamic precipIntensity;
  dynamic precipProbability;
  double ?temperature;
  double ?apparentTemperature;
  double ?dewPoint;
  double ?humidity;
  double ?pressure;
  double ?windSpeed;
  double ?windGust;
  int ?windBearing;
  double ?cloudCover;
  int ?uvIndex;
  double ?visibility;
  double ?ozone;

  factory Currently.fromJson(String str) => Currently.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Currently.fromMap(Map<String, dynamic> json) => Currently(
    time: json["time"],
    summary: summaryValues.map![json["summary"]],
    icon: iconValues.map![json["icon"]],
    precipIntensity: json["precipIntensity"],
    precipProbability: json["precipProbability"],
    temperature: json["temperature"].toDouble(),
    apparentTemperature: json["apparentTemperature"].toDouble(),
    dewPoint: json["dewPoint"].toDouble(),
    humidity: json["humidity"].toDouble(),
    pressure: json["pressure"].toDouble(),
    windSpeed: json["windSpeed"].toDouble(),
    windGust: json["windGust"].toDouble(),
    windBearing: json["windBearing"],
    cloudCover: json["cloudCover"].toDouble(),
    uvIndex: json["uvIndex"],
    visibility: json["visibility"].toDouble(),
    ozone: json["ozone"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "time": time,
    "summary": summaryValues.reverse![summary],
    "icon": iconValues.reverse![icon],
    "precipIntensity": precipIntensity,
    "precipProbability": precipProbability,
    "temperature": temperature,
    "apparentTemperature": apparentTemperature,
    "dewPoint": dewPoint,
    "humidity": humidity,
    "pressure": pressure,
    "windSpeed": windSpeed,
    "windGust": windGust,
    "windBearing": windBearing,
    "cloudCover": cloudCover,
    "uvIndex": uvIndex,
    "visibility": visibility,
    "ozone": ozone,
  };
}

enum Icon { PARTLY_CLOUDY_DAY, CLEAR_DAY, PARTLY_CLOUDY_NIGHT, CLEAR_NIGHT, CLOUDY }

final iconValues = EnumValues({
  "clear-day": Icon.CLEAR_DAY,
  "clear-night": Icon.CLEAR_NIGHT,
  "cloudy": Icon.CLOUDY,
  "partly-cloudy-day": Icon.PARTLY_CLOUDY_DAY,
  "partly-cloudy-night": Icon.PARTLY_CLOUDY_NIGHT
});

enum Summary { PARTLY_CLOUDY, CLEAR, MOSTLY_CLOUDY, OVERCAST }

final summaryValues = EnumValues({
  "Clear": Summary.CLEAR,
  "Mostly Cloudy": Summary.MOSTLY_CLOUDY,
  "Overcast": Summary.OVERCAST,
  "Partly Cloudy": Summary.PARTLY_CLOUDY
});

class Daily {
  Daily({
    this.summary,
    this.icon,
    this.data,
  });

  String ?summary;
  String ?icon;
  List<Datum> ?data;

  factory Daily.fromJson(String str) => Daily.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Daily.fromMap(Map<String, dynamic> json) => Daily(
    summary: json["summary"],
    icon: json["icon"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "summary": summary,
    "icon": icon,
    "data": List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  Datum({
    this.time,
    this.summary,
    this.icon,
    this.sunriseTime,
    this.sunsetTime,
    this.moonPhase,
    this.precipIntensity,
    this.precipIntensityMax,
    this.precipIntensityMaxTime,
    this.precipProbability,
    this.precipType,
    this.temperatureHigh,
    this.temperatureHighTime,
    this.temperatureLow,
    this.temperatureLowTime,
    this.apparentTemperatureHigh,
    this.apparentTemperatureHighTime,
    this.apparentTemperatureLow,
    this.apparentTemperatureLowTime,
    this.dewPoint,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.windGust,
    this.windGustTime,
    this.windBearing,
    this.cloudCover,
    this.uvIndex,
    this.uvIndexTime,
    this.visibility,
    this.ozone,
    this.temperatureMin,
    this.temperatureMinTime,
    this.temperatureMax,
    this.temperatureMaxTime,
    this.apparentTemperatureMin,
    this.apparentTemperatureMinTime,
    this.apparentTemperatureMax,
    this.apparentTemperatureMaxTime,
  });

  int ?time;
  String ?summary;
  String ?icon;
  int ?sunriseTime;
  int ?sunsetTime;
  double?moonPhase;
  double?precipIntensity;
  double?precipIntensityMax;
  int ?precipIntensityMaxTime;
  double ?precipProbability;
  String ?precipType;
  double ?temperatureHigh;
  int? temperatureHighTime;
  double ?temperatureLow;
  int? temperatureLowTime;
  double? apparentTemperatureHigh;
  int? apparentTemperatureHighTime;
  double? apparentTemperatureLow;
  int ?apparentTemperatureLowTime;
  double?dewPoint;
  double?humidity;
  double?pressure;
  double?windSpeed;
  double?windGust;
  int? windGustTime;
  int? windBearing;
  double? cloudCover;
  int ?uvIndex;
  int? uvIndexTime;
  double?visibility;
  double?ozone;
  double?temperatureMin;
  int ?temperatureMinTime;
  double? temperatureMax;
  int ?temperatureMaxTime;
  double ?apparentTemperatureMin;
  int ?apparentTemperatureMinTime;
  double ?apparentTemperatureMax;
  int ?apparentTemperatureMaxTime;

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    time: json["time"],
    summary: json["summary"],
    icon: json["icon"],
    sunriseTime: json["sunriseTime"],
    sunsetTime: json["sunsetTime"],
    moonPhase: json["moonPhase"].toDouble(),
    precipIntensity: json["precipIntensity"].toDouble(),
    precipIntensityMax: json["precipIntensityMax"].toDouble(),
    precipIntensityMaxTime: json["precipIntensityMaxTime"],
    precipProbability: json["precipProbability"].toDouble(),
    precipType: json["precipType"] == null ? null : json["precipType"],
    temperatureHigh: json["temperatureHigh"].toDouble(),
    temperatureHighTime: json["temperatureHighTime"],
    temperatureLow: json["temperatureLow"].toDouble(),
    temperatureLowTime: json["temperatureLowTime"],
    apparentTemperatureHigh: json["apparentTemperatureHigh"].toDouble(),
    apparentTemperatureHighTime: json["apparentTemperatureHighTime"],
    apparentTemperatureLow: json["apparentTemperatureLow"].toDouble(),
    apparentTemperatureLowTime: json["apparentTemperatureLowTime"],
    dewPoint: json["dewPoint"].toDouble(),
    humidity: json["humidity"].toDouble(),
    pressure: json["pressure"].toDouble(),
    windSpeed: json["windSpeed"].toDouble(),
    windGust: json["windGust"].toDouble(),
    windGustTime: json["windGustTime"],
    windBearing: json["windBearing"],
    cloudCover: json["cloudCover"].toDouble(),
    uvIndex: json["uvIndex"],
    uvIndexTime: json["uvIndexTime"],
    visibility: json["visibility"].toDouble(),
    ozone: json["ozone"].toDouble(),
    temperatureMin: json["temperatureMin"].toDouble(),
    temperatureMinTime: json["temperatureMinTime"],
    temperatureMax: json["temperatureMax"].toDouble(),
    temperatureMaxTime: json["temperatureMaxTime"],
    apparentTemperatureMin: json["apparentTemperatureMin"].toDouble(),
    apparentTemperatureMinTime: json["apparentTemperatureMinTime"],
    apparentTemperatureMax: json["apparentTemperatureMax"].toDouble(),
    apparentTemperatureMaxTime: json["apparentTemperatureMaxTime"],
  );

  Map<String, dynamic> toMap() => {
    "time": time,
    "summary": summary,
    "icon": icon,
    "sunriseTime": sunriseTime,
    "sunsetTime": sunsetTime,
    "moonPhase": moonPhase,
    "precipIntensity": precipIntensity,
    "precipIntensityMax": precipIntensityMax,
    "precipIntensityMaxTime": precipIntensityMaxTime,
    "precipProbability": precipProbability,
    "precipType": precipType == null ? null : precipType,
    "temperatureHigh": temperatureHigh,
    "temperatureHighTime": temperatureHighTime,
    "temperatureLow": temperatureLow,
    "temperatureLowTime": temperatureLowTime,
    "apparentTemperatureHigh": apparentTemperatureHigh,
    "apparentTemperatureHighTime": apparentTemperatureHighTime,
    "apparentTemperatureLow": apparentTemperatureLow,
    "apparentTemperatureLowTime": apparentTemperatureLowTime,
    "dewPoint": dewPoint,
    "humidity": humidity,
    "pressure": pressure,
    "windSpeed": windSpeed,
    "windGust": windGust,
    "windGustTime": windGustTime,
    "windBearing": windBearing,
    "cloudCover": cloudCover,
    "uvIndex": uvIndex,
    "uvIndexTime": uvIndexTime,
    "visibility": visibility,
    "ozone": ozone,
    "temperatureMin": temperatureMin,
    "temperatureMinTime": temperatureMinTime,
    "temperatureMax": temperatureMax,
    "temperatureMaxTime": temperatureMaxTime,
    "apparentTemperatureMin": apparentTemperatureMin,
    "apparentTemperatureMinTime": apparentTemperatureMinTime,
    "apparentTemperatureMax": apparentTemperatureMax,
    "apparentTemperatureMaxTime": apparentTemperatureMaxTime,
  };
}

class Flags {
  Flags({
    this.sources,
    this.nearestStation,
    this.units,
  });

  List<String>? sources;
  double? nearestStation;
  String? units;

  factory Flags.fromJson(String str) => Flags.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Flags.fromMap(Map<String, dynamic> json) => Flags(
    sources: List<String>.from(json["sources"].map((x) => x)),
    nearestStation: json["nearest-station"].toDouble(),
    units: json["units"],
  );

  Map<String, dynamic> toMap() => {
    "sources": List<dynamic>.from(sources!.map((x) => x)),
    "nearest-station": nearestStation,
    "units": units,
  };
}

class Hourly {
  Hourly({
    this.summary,
    this.icon,
    this.data,
  });

  String ?summary;
  Icon? icon;
  List<Currently>? data;

  factory Hourly.fromJson(String str) => Hourly.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hourly.fromMap(Map<String, dynamic> json) => Hourly(
    summary: json["summary"],
    icon: iconValues.map![json["icon"]],
    data: List<Currently>.from(json["data"].map((x) => Currently.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "summary": summary,
    "icon": iconValues.reverse![icon],
    "data": List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
