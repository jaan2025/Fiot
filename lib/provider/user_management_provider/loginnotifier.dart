import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/model/login_model/login_model.dart';
import 'package:generic_iot_sensor/model/user.dart';

import '../../model/edgedevice/getsensorlist.dart';
import '../../model/response_data.dart';
import '../../model/user_devicess/live_data_model.dart';
import '../../model/user_devicess/user_devies_model.dart';
import '../../services/apiservices.dart';
import '../../state/adduserstate.dart';
import '../../state/login_state.dart';

//edited By silambu

final loginUserNotifier =
StateNotifierProvider<LoginUserProvider, LoginState>((ref) {
  return LoginUserProvider(ref);
});


final userDataNotifier =
FutureProvider.family<UserDeviceList, String>((ref, id) async {
  return await ref.read(apiProvider).getUserInfo(userId: id);
});

final getDevices =
FutureProvider<GetDevicesModel>((ref) async {
  return await ref.read(apiProvider).getEdgeDeviceList();
});


class LoginUserProvider extends StateNotifier<LoginState> {
  Ref ref;

  LoginUserProvider(this.ref)
      : super(LoginState(false, const AsyncLoading(), 'initial'));

  loginUser(var loginRequest) async {
    state = _loading();
    final apiResponse = await ref.read(apiProvider).Login(loginRequest);
    if (apiResponse.data!=null) {
      final Map<String, dynamic> convertedData = jsonDecode(jsonEncode(apiResponse.data));
      state = _dataState(LoginModel.fromJson(convertedData));
    } {
      state = _errorState('Timeout');
    }
    return state;
  }

  LoginState _dataState(LoginModel entity) {
    return LoginState(false, AsyncData(entity), '');
  }

  LoginState _loading() {
    return LoginState(true, state.id, '');
  }

  LoginState _errorState(String errMsg) {
    return LoginState(false, state.id, errMsg);
  }

}
