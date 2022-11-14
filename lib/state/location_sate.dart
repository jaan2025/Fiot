import 'package:generic_iot_sensor/model/location_model.dart';
import 'package:generic_iot_sensor/provider/location_provider.dart';
import 'package:riverpod/riverpod.dart';




class LocationState {
  bool isLoading;
  AsyncValue<MyLocationModel> id;
  String error;

  LocationState(this.isLoading,this.id, this.error);


}