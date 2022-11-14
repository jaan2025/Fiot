
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/device_status_model.dart';
import '../../model/user_devicess/channelModel.dart';
import '../../model/user_devicess/live_data_model.dart';
import '../../services/apiservices.dart';
import '../../state/device_sate.dart';
import '../../state/live_data.dart';

final deviceStatusNotifier =
StateNotifierProvider<DeviceStatusProvider, DeviceState>((ref) {
  return DeviceStatusProvider(ref);
});

class DeviceStatusProvider extends StateNotifier<DeviceState> {

  Ref ref;

  DeviceStatusProvider(this.ref)
      : super(DeviceState(false, const AsyncLoading(), 'initial'));

  getStatus(var request) async {
    state = _loading();
    final apiResponse = await ref.read(apiProvider).deviceStatus(request);
    if (apiResponse!=null) {
      state = _dataState(DeviceStatus.fromJson(jsonDecode(apiResponse.toString())));
      print(apiResponse.toString());
    } {
      state = _errorState('Timeout');
    }
    return state;
  }

  DeviceState _dataState(DeviceStatus entity) {
    return DeviceState(false, AsyncData(entity), '');
  }

  DeviceState _loading() {
    return DeviceState(true, state.id, '');
  }

  DeviceState _errorState(String errMsg) {
    return DeviceState(false, state.id, errMsg);
  }

}
