import 'package:generic_iot_sensor/model/location_model.dart';
import 'package:generic_iot_sensor/model/user_devicess/channelModel.dart';
import 'package:generic_iot_sensor/provider/location_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../model/device_status_model.dart';




class DeviceState {
  bool isLoading;
  AsyncValue<DeviceStatus> id;
  String error;

  DeviceState(this.isLoading,this.id, this.error);

}