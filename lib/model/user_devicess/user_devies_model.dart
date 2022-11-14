class UserDeviceList {
  UserDeviceList({
    this.jsonId,
    this.userId,
    this.data,
  });

  String? jsonId;
  String? userId;
  UserData? data;

  factory UserDeviceList.fromJson(Map<String, dynamic> json) => UserDeviceList(
    jsonId: json["JSON_ID"] ??"",
    userId: json["USER_ID"]??"",
    data:json["DATA"]!=null? UserData.fromJson(json["DATA"]):UserData(),
  );

  Map<String, dynamic> toJson() => {
    "JSON_ID": jsonId,
    "USER_ID": userId,
    "DATA": data!.toJson(),
  };
}

class UserData {
  UserData({
    this.id,
    this.userId,
    this.userName,
    this.password,
    this.mobileNo,
    this.emailId,
    this.mobileKey,
    this.isactive,
    this.units,
    this.locations,
  });

  String ?id;
  int? userId;
  String?userName;
  String?password;
  String?mobileNo;
  String?emailId;
  String?mobileKey;
  String?isactive;
  List<UserUnit> ?units;
  List<UserLocation> ?locations;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"] ??"",
    userId: json["USER_ID"]??"",
    userName: json["USER_NAME"]??"",
    password: json["PASSWORD"]??"",
    mobileNo: json["MOBILE_NO"]??"",
    emailId: json["EMAIL_ID"]??"",
    mobileKey: json["MOBILE_KEY"]??"",
    isactive: json["ISACTIVE"]??"",
    units: json["UNITS"]!=null? List<UserUnit>.from(json["UNITS"].map((x) => UserUnit.fromJson(x))):[],
    locations:json["LOCATIONS"]!=null? List<UserLocation>.from(json["LOCATIONS"].map((x) => UserLocation.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "USER_ID": userId,
    "USER_NAME": userName,
    "PASSWORD": password,
    "MOBILE_NO": mobileNo,
    "EMAIL_ID": emailId,
    "MOBILE_KEY": mobileKey,
    "ISACTIVE": isactive,
    "UNITS": List<dynamic>.from(units!.map((x) => x.toJson())),
    "LOCATIONS": List<dynamic>.from(locations!.map((x) => x.toJson())),
  };
}

class UserLocation {
  UserLocation({
    this.locationId,
    this.locationName,
    this.locationSubname,
    this.isactive,
  });

  String? locationId;
  String? locationName;
  String? locationSubname;
  String? isactive;

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
    locationId: json["LOCATION_ID"]??"",
    locationName: json["LOCATION_NAME"]??"",
    locationSubname: json["LOCATION_SUBNAME"]??"",
    isactive: json["ISACTIVE"]??"",
  );

  Map<String, dynamic> toJson() => {
    "LOCATION_ID": locationId,
    "LOCATION_NAME": locationName,
    "LOCATION_SUBNAME": locationSubname,
    "ISACTIVE": isactive,
  };
}

class UserUnit {
  UserUnit({
    this.unitId,
    this.ip,
    this.port,
    this.macId,
    this.keepaliveTime,
    this.communicationId,
    this.version,
    this.location,
    this.isactive,
    this.edDevice,
  });

  String ? unitId;
  String ? ip;
  String ? port;
  String ? macId;
  String ? keepaliveTime;
  String ? communicationId;
  String ? version;
  String ? location;
  String ? isactive;
  List<UserEdDevice> ?  edDevice;

  factory UserUnit.fromJson(Map<String, dynamic> json) => UserUnit(
    unitId: json["UNIT_ID"]??"",
    ip: json["IP"]??"",
    port: json["PORT"]??"",
    macId: json["MAC_ID"]??"",
    keepaliveTime: json["KEEPALIVE_TIME"],
    communicationId: json["COMMUNICATION_ID"]??"",
    version: json["VERSION"]??"",
    location: json["LOCATION"]??"",
    isactive: json["ISACTIVE"]??"",
    edDevice: json["ED_DEVICE"] == null ? [] : List<UserEdDevice>.from(json["ED_DEVICE"].map((x) => UserEdDevice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "UNIT_ID": unitId,
    "IP": ip,
    "PORT": port,
    "MAC_ID": macId,
    "KEEPALIVE_TIME": keepaliveTime,
    "COMMUNICATION_ID": communicationId,
    "VERSION": version,
    "LOCATION": location,
    "ISACTIVE": isactive,
    "ED_DEVICE": edDevice == null ? null : List<dynamic>.from(edDevice!.map((x) => x.toJson())),
  };
}

class UserEdDevice {
  UserEdDevice({
    this.edgeId,
    this.locationId,
    this.productCode,
    this.name,
    this.macId,
    this.serialNo,
    this.isactive,
    this.edgeDeviceId,
    this.sensorUnit,
    this.sensors,
  });

  String ?edgeId;
  String ?locationId;
  String ?productCode;
  dynamic name;
  String ?macId;
  String ?serialNo;

  String ?isactive;
  String ?edgeDeviceId;
  String ?sensorUnit;
  List<UserSensor>? sensors;

  factory UserEdDevice.fromJson(Map<String, dynamic> json) => UserEdDevice(
    edgeId: json["EDGE_ID"]??"",
    locationId: json["LOCATION_ID"]??"",
    productCode: json["PRODUCT_CODE"]??"",
    name: json["NAME"]??"",
    macId: json["MAC_ID"]??"",
    serialNo: json["SERIAL_NO"]??"",
    isactive: json["ISACTIVE"]??"",
    edgeDeviceId: json["EDGE_DEVICE_ID"]??"",
    sensorUnit: json["SENSOR_UNIT"]??"",
    sensors: json["SENSORS"]!=null ?List<UserSensor>.from(json["SENSORS"].map((x) => UserSensor.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "EDGE_ID": edgeId,
    "LOCATION_ID": locationId,
    "PRODUCT_CODE": productCode,
    "NAME": name,
    "MAC_ID": macId,
    "SERIAL_NO": serialNo,
    "ISACTIVE": isactive,
    "EDGE_DEVICE_ID": edgeDeviceId,
    "SENSOR_UNIT": sensorUnit,
    "SENSORS": List<dynamic>.from(sensors!.map((x) => x.toJson())),
  };
}

class UserSensor {
  UserSensor({
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
    this.liveData,
    this.date,
    this.time,
  });

  String ?sensorId;
  String ?parameters;
  String ?units;
  String ?image;
  String ?measurementMin;
  String ?measurementMax;
  String ?s1Value;
  String ?s1Description;
  String ?s2Value;
  String ?s2Description;
  String ?s3Value;
  String ?s3Description;
  String ?s4Value;
  String ?s4Description;
  String ?refreshInterval;
  String ?liveData;
  dynamic  date;
  dynamic time;


  factory UserSensor.fromJson(Map<String, dynamic> json) => UserSensor(
    sensorId: json["SENSOR_ID"],
    parameters: json["PARAMETERS"]??"",
    units: json["UNITS"]??"",
    image: json["IMAGE"]??"",
    measurementMin: json["MEASUREMENT_MIN"]??"",
    measurementMax: json["MEASUREMENT_MAX"]??"",
    s1Value: json["S1_VALUE"]??"",
    s1Description: json["S1_DESCRIPTION"]??"",
    s2Value: json["S2_VALUE"]??"",
    s2Description: json["S2_DESCRIPTION"]??"",
    s3Value: json["S3_VALUE"]??"",
    s3Description: json["S3_DESCRIPTION"]??"",
    s4Value: json["S4_VALUE"]??"",
    s4Description: json["S4_DESCRIPTION"]??"",
    refreshInterval: json["REFRESH_INTERVAL"]??"",
    liveData: json["LIVE_DATA"]??"",
    date: json["DATE"]??"",
    time: json["TIME"]??"",
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
    "DATE":date,
    "TIME":time
  };
}
