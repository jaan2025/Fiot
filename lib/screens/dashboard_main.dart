import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/Edit_Location.dart';
import 'package:generic_iot_sensor/screens/unit_view_all_edge_devices.dart';

import '../helper/helper.dart';
import '../provider/navigation_provider.dart';
import '../res/colors.dart';
import '../res/screensize.dart';
import 'AssetTrackingUnit/ATUinput.dart';
import 'bottom_bar/bottom_bar.dart';
import 'configuration.dart';
import 'configuration_list.dart';
import 'dashboard.dart';
import 'location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'myprofile.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  final screen = [
     Dashboard(),
    const ConfigurationList(),
    UnitViewAllEdgeDeviceScreen(),
    const EditLocation(),
    const Profile(),
  ];



  @override
  void initState() {
    getUserId();
    super.initState();
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    Helper.userIDValue = prefs.getString(Helper.userId)!;
    print("user"+Helper.userIDValue);
  }


  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Consumer(builder: (context, ref, child) {
      var currentIndex = ref.watch(navNotifier);
      if(Helper.logout == false){
        currentIndex =0;
      }
      print("CURRENT INDEX $currentIndex");
      return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.cream,
            body: screen[currentIndex],
            bottomNavigationBar: const BottomBar()),
      );
    });

  }



}
