import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/live_data_provider.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/loginnotifier.dart';
import 'package:generic_iot_sensor/screens/edgedevice/SingleChannel.dart';
import 'package:generic_iot_sensor/screens/edgedevice/Single_three_channel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../helper/helper.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/unit_management_provider/unitprovider.dart';
import '../../res/colors.dart';
import 'dart:convert';

import '../../res/id.dart';
import '../edgedevice/add_edgedevice.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  String _scanBarcode = 'Unknown';

  bool goBack = true;

  Future<String> scanQR() async {
    String barcodeScanRes = '';
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    setState(() {
      _scanBarcode = '';
      _scanBarcode = barcodeScanRes;
    });

    return _scanBarcode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentIndex = ref.watch(navNotifier);
      return Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: Container(
              margin:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 23),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.09,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              ref.read(liveDataNotifier);
                              ref.read(userDataNotifier(Helper.userIDValue));
                              ref.refresh(userDataNotifier(Helper.userIDValue));
                              ref.read(navNotifier.notifier).currentIndex(0);
                            },
                            icon: Icon(
                              Icons.home_rounded,
                              color: currentIndex == 0
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.read(userDataNotifier(Helper.userIDValue));
                              ref.refresh(userDataNotifier(Helper.userIDValue));
                              ref.read(navNotifier.notifier).currentIndex(1);
                            },
                            icon: Icon(
                              Icons.search,
                              color: currentIndex == 1
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                       /* Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.refresh(userDataNotifier(Helper.userIDValue));
                              Future.delayed(const Duration(milliseconds: 50), () {
                                String qrResult = '';
                                Future<String> scanValue = scanQR();
                                scanValue.then((value) {
                                  Map valueMap = json.decode(value);
                                  for (var mac in Helper.listOfMac) {
                                    if (mac == valueMap['MacAddress'] ){
                                      goBack = false;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddEdgeDevice(valueMap: valueMap)));
                                  }
                                  if (goBack) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Invalid Qr')));
                                  }
                                  Future.delayed(const Duration(milliseconds: 200),(){
                                    ref.refresh(addUnitNotifier);
                                  });

                                }});
                              });
                             *//* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SingleChannel()),
                              );*//*
                            },
                            icon: Icon(
                              Icons.qr_code_scanner,
                              color: currentIndex == 5
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),*/
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.refresh(userDataNotifier(Helper.userIDValue));
                              //Helper.qrScan = false;
                              ref.read(navNotifier.notifier).currentIndex(2);
                              ref.read(userDataNotifier(Helper.userIDValue));
                            },
                            icon: Icon(
                              Icons.list_alt,
                              color: currentIndex == 2
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),

                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.read(userDataNotifier(Helper.userIDValue));
                              ref.refresh(userDataNotifier(Helper.userIDValue));
                              ref.read(navNotifier.notifier).currentIndex(3);
                            },
                            icon: Icon(
                              Icons.location_on,
                              color: currentIndex == 3
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.read(navNotifier.notifier).currentIndex(4);
                            },
                            icon: Icon(
                              Icons.person,
                              color: currentIndex == 4
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        /*  Positioned(
            left: 150,
            child: FloatingActionButton(
              elevation: 0.0,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AppId.SmartConfigID);
              }),)*/
        ],
      );
    });
  }
}
