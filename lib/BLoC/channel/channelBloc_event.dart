import 'package:equatable/equatable.dart';
import 'package:generic_iot_sensor/model/user_devicess/channelModel.dart';

abstract class channelEvent extends Equatable {

  const channelEvent();

  @override
  List<Object> get  props => [];

}
class  LoadChannel extends channelEvent {

}
class  UpdateChannel extends channelEvent {

  final String value;

  const UpdateChannel({required this.value});


}