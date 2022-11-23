
import 'package:equatable/equatable.dart';
import 'package:generic_iot_sensor/model/WeatherApiModel.dart';

import '../../model/location_model.dart';


abstract class blocEvent extends Equatable {

  const blocEvent();

  @override
  List<Object> get  props => [];

}
class  LoadTemp extends blocEvent {}
class  UpdateTemp extends blocEvent {

  final weatherModel myLocationModel;

  const UpdateTemp({required this.myLocationModel});

  @override
  List<Object> get props => [myLocationModel];

}