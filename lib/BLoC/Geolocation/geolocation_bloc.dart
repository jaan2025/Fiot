import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:generic_iot_sensor/BLoC/ambientTemp/Bloc_state.dart';
import 'package:generic_iot_sensor/repository/geolocation/geolocation_repository.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocatioBloc extends Bloc<GeolocationEvent,GeolocationState>{
  final GeoLocationRepository _geoLocationRepository;
  StreamSubscription ? _geolocationSubscription;

  GeolocatioBloc({required GeoLocationRepository geoLocationRepository})
      : _geoLocationRepository = geoLocationRepository, super(GeolocationLoading()){
    on<LoadGeolocation>((event, emit) async {
      emit(GeolocationLoading());
      print("loading state");
      final location = await _geoLocationRepository.getCurrentLocation();
      emit(GeolocationLoaded(location));

    });
  }
  }

