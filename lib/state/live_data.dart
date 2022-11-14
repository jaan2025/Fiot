

import 'package:generic_iot_sensor/model/user_devicess/live_data_model.dart';
import 'package:riverpod/riverpod.dart';

class LiveDataState {
  bool isLoading;
  AsyncValue<LiveDataSensors> id;
  String error;

  LiveDataState(this.isLoading,this.id, this.error);


}