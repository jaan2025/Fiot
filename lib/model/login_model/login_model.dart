class LoginModel {
  LoginModel({
    this.jsonId,
    this.userId,
    this.data,
  });

  String ?jsonId;
  String ? userId;
  Data ?data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    jsonId: json["JSON_ID"],
    userId: json["USER_ID"],
    data: Data.fromJson(json["DATA"]),
  );

  Map<String, dynamic> toJson() => {
    "JSON_ID": jsonId,
    "USER_ID": userId,
    "DATA": data!.toJson(),
  };
}

class Data {
  Data({
    this.msg,
  });

  String ? msg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    msg: json["MSG"],
  );

  Map<String, dynamic> toJson() => {
    "MSG": msg,
  };
}
