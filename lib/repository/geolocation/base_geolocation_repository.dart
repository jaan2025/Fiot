
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';



abstract class BaseGeolocationRepository {
  Future<Address?> getCurrentLocation() async {

  }
}