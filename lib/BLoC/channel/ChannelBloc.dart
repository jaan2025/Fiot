import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:generic_iot_sensor/BLoC/ambientTemp/Bloc_state.dart';
import 'package:generic_iot_sensor/model/user_devicess/channelModel.dart';
import 'channelBloc_event.dart';
import 'channelBloc_state.dart';
import '../../repository/channelRepository/channel_repository.dart';

class ChannelBloc extends Bloc<channelEvent, channelState> {
  final ChannelRepo ? channelRepo;

  ChannelBloc({this.channelRepo})
      :
        super(channelLoading()) {
    on<LoadChannel>((event, emit) async {
      emit(channelLoading());
      await Future.delayed(Duration(seconds: 1));
      try {
       var status = await channelRepo?.deviceStatus({
          "JSON_ID": "12",
          "USER_ID": "4",
          "DATA": {
            "MAC_ID": "AC67B264A75C",
            "SERIAL_NO": "33333",
            "EDGE_DEVICE_ID": "10",
            "SENSOR_ID": "1",
            "STATUS": "0"
          }
        });

        print("second state");
        emit(channelLoaded(status!));
      } catch (error) {
        throw error;
      }
    });
  }
}
