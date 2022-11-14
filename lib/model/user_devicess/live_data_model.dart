class LiveDataSensors {
  LiveDataSensors({
    this.jsonId,
    this.userId,
    this.data,
  });

  String ?jsonId;
  String? userId;
  LiveDataSensorsData ?data;

  factory LiveDataSensors.fromJson(Map<String, dynamic> json) => LiveDataSensors(
    jsonId: json["JSON_ID"],
    userId: json["USER_ID"],
    data: LiveDataSensorsData.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson() => {
    "JSON_ID": jsonId,
    "USER_ID": userId,
    "DATA": data!.toJson(),
  };
}

class LiveDataSensorsData {
  LiveDataSensorsData({
    this.livedata,
  });

  List<Livedatum> ? livedata;

  factory LiveDataSensorsData.fromJson(Map<String, dynamic> json) => LiveDataSensorsData(
    livedata: json["LIVEDATA"]!=null ? List<Livedatum>.from(json["LIVEDATA"].map((x) => Livedatum.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "LIVEDATA": List<dynamic>.from(livedata!.map((x) => x.toJson())),
  };
}

class Livedatum {
  Livedatum({
    this.sensorId,
    this.sensorName,
    this.value,
    this.date,
    this.time,
    this.alerttype,
  });

  String? sensorId;
  String? sensorName;
  String? value;
  DateTime ?date;
  String ?time;
  String ?alerttype;

  factory Livedatum.fromJson(Map<String, dynamic> json) => Livedatum(
    sensorId: json["SENSOR_ID"],
    sensorName: json["SENSOR_NAME"],
    value: json["VALUE"],
    date: DateTime.parse(json["DATE"]),
    time: json["TIME"],
    alerttype: json["ALERTTYPE"],
  );

  Map<String, dynamic> toJson() => {
    "SENSOR_ID": sensorId,
    "SENSOR_NAME": sensorName,
    "VALUE": value,
    "DATE": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "TIME": time,
    "ALERTTYPE": alerttype,
  };
}
