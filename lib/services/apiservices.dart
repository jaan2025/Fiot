import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/model/locationrequest.dart';
import 'package:generic_iot_sensor/model/otp.dart';
import 'package:generic_iot_sensor/services/httpservices.dart';

import '../model/edgedevice/getsensorlist.dart';
import '../model/response_data.dart';
import '../model/unitconfig.dart';
import '../model/user_devicess/user_devies_model.dart';
import 'dioexception.dart';

Provider<DioClient> apiProvider = Provider<DioClient>((ref) => DioClient(ref));

class DioClient {


  final Ref ref;
  final client = Dio();

  DioClient(this.ref)
      : _dio = Dio(
          BaseOptions(
            baseUrl: HttpServices.baseUrl,
            connectTimeout: 10000,
            receiveTimeout: 1000000,
            responseType: ResponseType.json,

          ),
        );

  late final Dio _dio;

  Future<ResponseData?> getUser({required int id}) async {
    try {
      final response = await _dio.get('/users/$id');
      return ResponseData.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<String> createUser({required ResponseData user}) async {
    print("createUser");
    try {
      final response = await _dio.post(
        HttpServices.userRegister,
          data: jsonEncode(user),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      print(response);
      return response.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> verifyOTP({required OTPVerify otpVerify}) async {
    print("VerifyOTP");
    try {
      final response = await _dio.post(
        HttpServices.otpVerification,
        data: otpVerify.toString(),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      print(response);
      return response.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> Login(var user) async {
    print("loginUser");
    try {
      final response = await _dio.post(HttpServices.userLogin, data: jsonEncode(user),
        options: Options(headers: {HttpHeaders.contentTypeHeader: "application/json",}),);
      print(response);
      return response;
    } on DioError catch (err) {
      return err;
    } catch (e) {
      return e;
    }
  }

  Future<String> updateUser({required ResponseData user}) async {
    print("updateUser");
    try {
      final response = await _dio.post(
        HttpServices.userRegister,
        data: user.toJson(),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      print(response);
      return response.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deviceStatus(var value) async {
    print("addUnit");
    try {
      final response = await _dio.post(
        'http://183.82.35.93/MonogoDB_Connection/api/Device/DeviceDataUpdate',
        data:jsonEncode(value),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

      return response.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserDeviceList> getUserInfo({required String userId}) async {
    print("userId====>${userId}");
    try {
      final response = await _dio.get("${HttpServices.userRegister}/ByID?USER_ID=$userId", options : Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }));
      final Map<String, dynamic> convertedData = jsonDecode(jsonEncode(response.data));
      print(response.data.toString());
      return UserDeviceList.fromJson(convertedData);
    } on DioError catch (err) {
      print("Exception1 ${err.toString()}");
      return UserDeviceList();
    } catch (e) {
      print("Exception2 ${e.toString()}");
      return UserDeviceList();
    }
  }

  Future<dynamic> getLiveData(var value) async {
    print("loginUser");
    print("VALUE ----- $value");
    try {
      final response = await _dio.post(
        HttpServices.liveData,
        data: jsonEncode(value),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      return response;
    } catch (e) {
      return 'e';
    }
  }

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

  Future<String> addUnit({required UnitData unit}) async {
    print("addUnit");
    try {
      final response = await _dio.post(
        HttpServices.Unit,
        data: unit.toJson(),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      print(response);
      return response.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }



  Future<String> addLocation(var location) async {
    print("addLocation");
    try {
      final response = await _dio.post(
        HttpServices.Location,
          data: jsonEncode(location),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      print(response);
      return response.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateLocation({required LocationData location}) async {
    print("updateLocation");
    try {
      final response = await _dio.post(
        HttpServices.Location,
        data: location.toJson(),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );
      print(response);
      return response.toString();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }

  Future<GetDevicesModel> getEdgeDeviceList() async {
    print("getEdgeDeviceInfo");
    try {
      final response = await _dio.get(
          "${HttpServices.EdgeDevice}/${HttpServices.releaseProducts}",
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      final Map<String, dynamic> convertedData = jsonDecode(jsonEncode(response.data));
      return GetDevicesModel.fromJson(convertedData);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return GetDevicesModel();
    } catch (e) {
      return GetDevicesModel();
    }
  }

  Future<String> addEdDevices(var value) async {
    try {
      final response = await _dio.post(HttpServices.EdgeDevice, data: jsonEncode(value), options : Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }));
   print(response.data.toString());
      return response.data;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return errorMessage;
    } catch (e) {
      return e.toString();
    }
  }
}