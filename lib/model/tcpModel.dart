class tcpModel {

  int ? id;
  String ? ip;
  String ? Mac;

  tcpModel({this.id,this.ip,this.Mac});

  factory tcpModel.fromMap(Map<String, dynamic> json) => tcpModel(
    id: json["id"],
    ip: json["ip"],
    Mac: json["Mac"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ip": ip,
    "Mac": Mac,

  };


}