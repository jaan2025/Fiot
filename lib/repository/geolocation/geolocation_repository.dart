
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter_geocoder/geocoder.dart';

import 'package:generic_iot_sensor/repository/geolocation/base_geolocation_repository.dart';

import 'package:geolocator/geolocator.dart';

class GeoLocationRepository extends BaseGeolocationRepository {
  GeoLocationRepository();

  @override
  Future<Address> getCurrentLocation() async {
    LocationData ? locationData;
    String error;
    Location location = Location();
    try {
      locationData = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      locationData = null;
    }

    final coordinates = Coordinates(
        locationData!.latitude, locationData.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var live = addresses.first;
    return live;
  }
}