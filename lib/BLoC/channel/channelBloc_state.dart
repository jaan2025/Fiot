
import 'package:equatable/equatable.dart';
import 'package:generic_iot_sensor/model/user_devicess/channelModel.dart';

abstract class channelState extends Equatable {

  const channelState();

  @override
  List<Object> get props => [];

}

class channelInitial  extends channelState {

  @override
  List<Object> get props => [];
}

class channelLoading extends channelState {
  @override
  List<Object> get props => [];
}

class channelLoaded extends channelState {

  String channel;
  channelLoaded(this.channel);
  @override
  List<Object> get props => [];


}
class channelError extends channelState {
  final String  message;
  const channelError(this.message);
  @override
  List<String> get props => [message];

}
