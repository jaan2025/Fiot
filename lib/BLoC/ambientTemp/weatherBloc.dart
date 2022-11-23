import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:generic_iot_sensor/model/WeatherApiModel.dart';






import '../../model/location_model.dart';
import '../../repository/ambientTemp/location_repository.dart';

import 'Bloc_event.dart';
import 'Bloc_state.dart';
import 'package:geolocator/geolocator.dart';





class weatherBloc extends Bloc<blocEvent,blocState> {


  final LocationRep _locationrep;

  weatherBloc({required LocationRep locationRep })
      : _locationrep = locationRep,
        super(weatherLoading()) {
    on<LoadTemp>((event, emit) async {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      emit(weatherLoading());
      dynamic location = await _locationrep.getWeatherApi(position.latitude,position.longitude);
      print("second state");
      emit(weatherLoaded(weatherModel.fromJson(location.toString())));
    });
  }


}

