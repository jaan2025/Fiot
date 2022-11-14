


import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:generic_iot_sensor/model/user_devicess/channelModel.dart';
import 'package:generic_iot_sensor/repository/channelRepository/baseChannel_repository.dart';

import '../../services/dioexception.dart';

class ChannelRepo extends BaseChannel {

  final _dio = Dio();

  Future<String> deviceStatus(var value) async {
    print("addUnit");
    try {
      final response = await _dio.post(
        'http://192.168.1.47/MonogoDB_Connection/api/Device/DeviceDataUpdate',
        data:jsonEncode(value),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      print(response);
      return response.data.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }
}