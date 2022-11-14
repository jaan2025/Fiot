

import 'package:dio/dio.dart';

import 'base_Temp.dart';

class LocationRep extends baseTemp {


final client = Dio();

  Future<dynamic> getWeather(var lat, var loc) async {
    String formUrl = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$loc&hourly=temperature_2m';
    final url = formUrl.toString();

    try {
      final response = await client.get(
          url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response.data;
      }
    } catch (error) {
      print(error);
    }
  }


}