import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';






import '../../model/location_model.dart';
import '../../repository/ambientTemp/location_repository.dart';

import 'Bloc_event.dart';
import 'Bloc_state.dart';


class weatherBloc extends Bloc<blocEvent,blocState> {
  final LocationRep _locationrep;

  weatherBloc({required LocationRep locationRep })
      : _locationrep = locationRep,
        super(weatherLoading()) {
    on<LoadTemp>((event, emit) async {
      emit(weatherLoading());
      var location = await _locationrep.getWeather(12.9171, 80.125);
      print("second state");
      emit(weatherLoaded(MyLocationModel.fromJson(location)));
    });
  }
}

