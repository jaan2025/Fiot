import 'package:equatable/equatable.dart';

class User extends Equatable{

  final int USER_ID;
  final String USER_NAME;
  final String PASSWORD;
  final String EMAIL_ID;
  final String MOBILE_NO;
  final String MOBILE_KEY;
  final String ISACTIVE;

  const User({
    required this.USER_ID,
    required this.USER_NAME,
    required this.PASSWORD,
    required this.EMAIL_ID,
    required this.MOBILE_NO,
    required this.MOBILE_KEY,
    required this.ISACTIVE,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    USER_ID: json["USER_ID"],
    USER_NAME: json["USER_NAME"],
    PASSWORD: json["PASSWORD"],
    EMAIL_ID: json["EMAIL_ID"],
    MOBILE_NO: json["MOBILE_NO"],
    MOBILE_KEY: json["MOBILE_KEY"],
    ISACTIVE: json["ISACTIVE"],
  );

  Map<String, dynamic> toJson() => {
    "USER_ID": USER_ID,
    "USER_NAME": USER_NAME,
    "PASSWORD": PASSWORD,
    "EMAIL_ID": EMAIL_ID,
    "MOBILE_NO": MOBILE_NO,
    "MOBILE_KEY": MOBILE_KEY,
    "ISACTIVE": ISACTIVE,
  };

  @override
  List<Object?> get props => [USER_ID, USER_NAME, PASSWORD, EMAIL_ID, MOBILE_NO, MOBILE_KEY, ISACTIVE];
}