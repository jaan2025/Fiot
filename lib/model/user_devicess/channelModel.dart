class Channel {
  Channel({
    this.jsonId,
    this.userId,
    this.data,
  });

  String ?jsonId;
  String? userId;
  ChannelData ?data;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    jsonId: json["JSON_ID"],
    userId: json["USER_ID"],
    data: ChannelData.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson() => {
    "JSON_ID": jsonId,
    "USER_ID": userId,
    "DATA": data!.toJson(),
  };
}

class ChannelData {
  ChannelData({
    this.livedata,
  });

  List<Channeldatum> ? livedata;

  factory ChannelData.fromJson(Map<String, dynamic> json) => ChannelData(
    livedata: json["LIVEDATA"]!=null ? List<Channeldatum>.from(json["LIVEDATA"].map((x) => Channeldatum.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "LIVEDATA": List<dynamic>.from(livedata!.map((x) => x.toJson())),
  };
}

class Channeldatum {
  Channeldatum({
    this.macId,
    this.serialNo,
    this.edgeDeviceId,
    this.sensorId,
    this.status,

  });

  dynamic macId;
  dynamic serialNo;
  int ? edgeDeviceId;
  int ? sensorId;
  dynamic status;




  factory Channeldatum.fromJson(Map<String, dynamic> json) => Channeldatum(
    macId: json["MAC_ID"],
    serialNo: json["SERIAL_NO"],
    sensorId: json["SENSOR_ID"],
    edgeDeviceId: json["EDGE_DEVICE_ID"],
    status: json["STATUS"]


  );

  Map<String, dynamic> toJson() => {
    "MAC_ID": macId,
    "SERIAL_NO":serialNo,
    "SENSOR_ID":sensorId,
    "EDGE_DEVICE_ID":edgeDeviceId,
    "STATUS":status

  };
}
