import 'package:generic_iot_sensor/model/login_model/login_model.dart';
import 'package:riverpod/riverpod.dart';




class LoginState {
  bool isLoading;
  AsyncValue<LoginModel> id;
  String error;

  LoginState(this.isLoading,this.id, this.error);


}