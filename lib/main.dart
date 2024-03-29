import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:generic_iot_sensor/helper/helper.dart';
import 'package:generic_iot_sensor/res/id.dart';
import 'package:generic_iot_sensor/res/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/dashboard.dart';
import 'package:generic_iot_sensor/services/apiservices.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  autoLogin();
}

autoLogin() async {

  SharedPreferences pref = await SharedPreferences.getInstance();
  var mobilno = pref.getString(Helper.mobile);
  var userIDValue = pref.getString(Helper.userIDValue);
  print("MOBILE NO ==========  > $mobilno");

  print("UserID autolog-->${userIDValue}");
  if(mobilno==null){
    AppId.initialRoute = AppId.LoginID;
  }else{
    print("flow----------");
   // Dashboard().createState().mqttMac();
    print("flow end");

      if(Helper.userIDValue=="")
      {
        Helper.userIDValue= userIDValue.toString();
      }

    print("UserID autolog 2 -->${Helper.userIDValue}");
    AppId.initialRoute = AppId.DashboardID;
  }
  runApp(const ProviderScope(child: AppTheme()));

}