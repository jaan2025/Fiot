
class wifiPassword {
  dynamic id;
  dynamic ssid;
  dynamic wPassword;


  wifiPassword({
    this.id,
    this.ssid,
    this.wPassword
  });

  wifiPassword.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        ssid = result["ssid"],
        wPassword = result["wPassword"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': ssid,
      'age': wPassword,

    };
  }
}


class Alldata {
  dynamic id;
  dynamic data;

  Alldata({
    this.id,
    this.data,

  });

  Alldata.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        data = result["data"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'data': data,

    };
  }
}