

import 'package:dio/dio.dart';

import 'base_Temp.dart';

class LocationRep extends baseTemp {


final client = Dio();

Future<dynamic> getWeatherApi(var lat,var long) async {
  String formUrl = 'https://api.darksky.net/forecast/8f05b9be093e0cbfcd6d645a5eb8a0af/$lat,$long?units=si&callback=?';
  final url = formUrl.toString();
  try{
    final response = await client.get(url);
    print("WEATHER ==== > ${response.data}");
    //final response2 = [response.data];
   var merry =  response.data.toString().replaceAll("/**/ typeof  === 'function' && (", "");
   var robin = merry.replaceAll(")", "");
   var res = robin.replaceAll(";", "");


    print("RES --------- $res");
    if (res != null) {
      return res;

    } else {
      return res;
    }
  }catch(e){
    print(e);
  }


}


}