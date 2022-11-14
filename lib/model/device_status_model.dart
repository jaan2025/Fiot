class DeviceStatus {
  String ? sTATUS;

  DeviceStatus({this.sTATUS});

  DeviceStatus.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['STATUS'] = sTATUS;
    return data;
  }
}