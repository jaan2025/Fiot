

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';




import '../../model/WeatherApiModel.dart';
import '../../model/location_model.dart';




abstract class blocState extends Equatable {

  const blocState();

  @override
  List<Object> get props => [];

}

class weatherInitial  extends blocState {}

class weatherLoading extends blocState {}

class weatherLoaded extends blocState {
  final weatherModel  myLocationModel;
  const weatherLoaded( this.myLocationModel);

}
class weatherError extends blocState {
    final String ? message;
    const weatherError(this.message);
}
