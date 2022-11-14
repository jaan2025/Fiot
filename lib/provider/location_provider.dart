/*import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/services/apiservices.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../model/location_model.dart';
import '../state/location_sate.dart';

final myLocationNotifier =
    StateNotifierProvider<MyLocation, LocationState>((ref) {
  return MyLocation(ref);
});

class MyLocation extends StateNotifier<LocationState> {
  LocationPermission? permission;
  Ref ref;

  var lat, long;
  static String? latlong;

  MyLocation(this.ref)
      : super(LocationState(false, const AsyncLoading(), 'initial'));

  void requestPermission() async {
    permission = await Geolocator.requestPermission();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _getGeolocationAddress(position);
  }

  _getGeolocationAddress(Position position) async {
    final response =
        await ref.read(apiProvider).getWeather(position.latitude, position.longitude);
    state = _dataState(MyLocationModel.fromJson(response));
    var places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    return places;
  }*//*


  LocationState _dataState(MyLocationModel entity) {
    return LocationState(false, AsyncData(entity), '');
  }

  LocationState _loading() {
    print(state);
    //print(LocationState.id);
    return LocationState(true, state.id, '');
  }

  LocationState _errorState(String errMsg) {
    return LocationState(false, state.id, errMsg);
  }
}
*/
