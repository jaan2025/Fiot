import 'package:flutter/material.dart';
import 'package:generic_iot_sensor/res/colors.dart';
import 'package:generic_iot_sensor/res/id.dart';
import 'package:generic_iot_sensor/screens/communicationtype.dart';
import 'package:generic_iot_sensor/screens/configuration.dart';
import 'package:generic_iot_sensor/screens/configuration_list.dart';
import 'package:generic_iot_sensor/screens/dashboard_main.dart';
import 'package:generic_iot_sensor/screens/edgedevice/add_edgedevice.dart';
import 'package:generic_iot_sensor/screens/location.dart';
import 'package:generic_iot_sensor/screens/login.dart';
import 'package:generic_iot_sensor/screens/myprofile.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/dashboard.dart';
import '../screens/register.dart';
import '../smartconfig/smartconfig.dart';


class AppTheme extends StatelessWidget {
  const AppTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: AppColors.primarySwatch,
              accentColor: Colors.red,
              backgroundColor: Colors.pink,
              primaryColorDark: Colors.orange),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          )),
      initialRoute: AppId.initialRoute,
      routes: <String, WidgetBuilder>{
        AppId.LoginID: (context) => const Login(),
        AppId.RegisterID: (context) => const Register(),
        AppId.MyProfile: (context) => const Profile(),
        AppId.DashboardID: (context) => const DashBoardScreen(),
        AppId.SmartConfigID: (context) => const SmartConfig(),
        AppId.CommunicationType: (context) => const CommunicationType(),
        AppId.Configuration: (context) =>  Configuration(),
        AppId.ConfigurationList: (context) => const ConfigurationList(),
        AppId.Location: (context) => const LocationManagement(),
        AppId.AddEdgeDevice: (context) =>  AddEdgeDevice(),
      },
    );
  }
}

