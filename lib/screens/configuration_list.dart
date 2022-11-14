import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/shimmerprojectlist.dart';
import 'package:generic_iot_sensor/services/apiservices.dart';
import 'package:generic_iot_sensor/services/tcpclient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/applicationhelper.dart';
import '../helper/helper.dart';
import '../model/getuserinformation_response.dart';
import '../provider/tcp_provider/tcp_provider_receive_data.dart';
import '../provider/user_management_provider/loginnotifier.dart';
import '../provider/user_management_provider/userprofileprovider.dart';
import '../res/id.dart';
import 'dashboard.dart';
import 'edgedevice/add_edgedevice.dart';

class ConfigurationList extends ConsumerStatefulWidget {
  const ConfigurationList({Key? key}) : super(key: key);

  @override
  _ConfigurationListState createState() => _ConfigurationListState();
}

class _ConfigurationListState extends ConsumerState<ConfigurationList> {
  late List<Unit> configList = [];
  String prevIP = "";
  int increCounter = 0;
  Socket? clientSocket;
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
        body:
            ref.watch(userDataNotifier(Helper.userIDValue)).when(data: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(
                        'Configured devices',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: ElevatedButton(

                              onPressed: () {
                                String qrResult = '';
                                Future<String> scanValue = scanQR();
                                scanValue.then((value) {
                                  Map valueMap = json.decode(value);

                                  for (var mac in Helper.listOfMac) {
                                    if (mac == valueMap['MacAddress']){
                                      //goBack = false;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddEdgeDevice(valueMap: valueMap))

                                      );
                                    }
                                    else {
                                      print("MAC NOT MATCHED");
                                    }
                                    /*if (goBack) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Invalid Qr')));
                                        }*/
                                  }});
                              },
                              child: Text('SCAN QR '),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: data.data!.units!.isEmpty ? true : false,
                    child: Expanded(
                        child: Center(
                            child: const Text(
                      'No Unit, Found Please the Unit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: ScrollPhysics( ),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: data.data!.units!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 20,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Text(data.data!.units![index].ip.toString()),
                                title:
                                    Text(data.data!.units![index].macId.toString()),
                                trailing:
                                    Text(data.data!.units![index].port.toString()),
                                onTap: () async {
                                 /* ApplicationHelper.showProgressDialog(context);
                                  for (int i = 0; i < 5; i++) {
                                    var value = await connectToServer(
                                        data.data!.units![index].ip.toString(),
                                        5000);
                                    if (value == false && increCounter > 2) {
                                      print("smartConfig");
                                      ApplicationHelper.dismissProgressDialog();
                                      Navigator.of(context).pushNamed(
                                          AppId.SmartConfigID);
                                      break;
                                    }
                                    if (value == false && increCounter < 3) {
                                      print("repeat");
                                    } else if (value == true) {
                                      print("Configuration");

                                     Helper.Ipaddress = data.data!.units![index].ip.toString();
                                      ApplicationHelper.dismissProgressDialog();
                                      Navigator.of(context).pushNamed(
                                          AppId.Configuration);
                                      break;
                                    }
                                  }*/
                                  Helper.Ipaddress = data.data!.units![index].ip.toString();
                                  Helper.Macaddress = data.data!.units![index].macId.toString();

                                  Helper.qrScan = false;
                                  Navigator.of(context).pushNamed(
                                      AppId.Configuration);
                                },
                              ),
                            ],
                          ),
                        );
                        // return getConfigList(index, config);
                      }),
                ),
              ],
            ),
          );
        }, error: (error, s) {
          return Center(
            child: Text(error.toString()),
          );
        }, loading: () {
          return ShimmerForProjectList();
        }),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppId.SmartConfigID);
            }),floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,);
    }

  Future<bool> connectToServer(String ipaddress, int port) async {
    if (prevIP.isNotEmpty && prevIP == ipaddress) {
      increCounter++;
    } else {
      increCounter = 0;
    }
    prevIP = ipaddress;
    return Future.delayed(
        const Duration(milliseconds: 500),
        () => Socket.connect(ipaddress, 5000,
            timeout: const Duration(seconds: 10))).then((socket) {
      clientSocket = socket;
      return true;
    }).catchError((e) {
      print(e.toString());
      return false;
    });
  }
}
