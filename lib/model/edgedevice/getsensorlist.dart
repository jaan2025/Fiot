

class GetDevicesModel {
  GetDevicesModel({
    this.edgeDevices,
  });

  List<EdgeDeviceData> ? edgeDevices;

  factory GetDevicesModel.fromJson(Map<String, dynamic> json) => GetDevicesModel(
    edgeDevices: List<EdgeDeviceData>.from(json["EdgeDevices"].map((x) => EdgeDeviceData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "EdgeDevices": List<dynamic>.from(edgeDevices!.map((x) => x.toJson())),
  };
}

class EdgeDeviceData {
  EdgeDeviceData({
    this.id,
    this.edgeId,
    this.sensorUnit,
    this.sensors,
  });

  String ?id;
  String ?edgeId;
  String ?sensorUnit;
  List<SensorDevices> ? sensors;

  factory EdgeDeviceData.fromJson(Map<String, dynamic> json) => EdgeDeviceData(
    id: json["id"] ??"",
    edgeId: json["EDGE_ID"]??"",
    sensorUnit: json["SENSOR_UNIT"]??"",
    sensors: List<SensorDevices>.from(json["SENSORS"].map((x) => SensorDevices.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "EDGE_ID": edgeId,
    "SENSOR_UNIT": sensorUnit,
    "SENSORS": List<dynamic>.from(sensors!.map((x) => x.toJson())),
  };
}

class SensorDevices {
  SensorDevices({
    this.sensorId,
    this.parameters,
    this.units,
    this.image,
    this.measurementMin,
    this.measurementMax,
    this.s1Value,
    this.s1Description,
    this.s2Value,
    this.s2Description,
    this.s3Value,
    this.s3Description,
    this.s4Value,
    this.s4Description,
    this.refreshInterval,
  });

  String? sensorId;
  String? parameters;
  String? units;
  String? image;
  String? measurementMin;
  String? measurementMax;
  String? s1Value;
  String? s1Description;
  String? s2Value;
  String? s2Description;
  String? s3Value;
  String? s3Description;
  String? s4Value;
  String? s4Description;
  String? refreshInterval;

  factory SensorDevices.fromJson(Map<String, dynamic> json) => SensorDevices(
    sensorId: json["SENSOR_ID"],
    parameters: json["PARAMETERS"],
    units: json["UNITS"],
    image: json["IMAGE"],
    measurementMin: json["MEASUREMENT_MIN"],
    measurementMax: json["MEASUREMENT_MAX"],
    s1Value: json["S1_VALUE"],
    s1Description: json["S1_DESCRIPTION"],
    s2Value: json["S2_VALUE"],
    s2Description: json["S2_DESCRIPTION"],
    s3Value: json["S3_VALUE"],
    s3Description: json["S3_DESCRIPTION"],
    s4Value: json["S4_VALUE"],
    s4Description: json["S4_DESCRIPTION"],
    refreshInterval: json["REFRESH_INTERVAL"],
  );

  Map<String, dynamic> toJson() => {
    "SENSOR_ID": sensorId,
    "PARAMETERS": parameters,
    "UNITS": units,
    "IMAGE": image,
    "MEASUREMENT_MIN": measurementMin,
    "MEASUREMENT_MAX": measurementMax,
    "S1_VALUE": s1Value,
    "S1_DESCRIPTION": s1Description,
    "S2_VALUE": s2Value,
    "S2_DESCRIPTION": s2Description,
    "S3_VALUE": s3Value,
    "S3_DESCRIPTION": s3Description,
    "S4_VALUE": s4Value,
    "S4_DESCRIPTION": s4Description,
    "REFRESH_INTERVAL": refreshInterval,
  };
}
