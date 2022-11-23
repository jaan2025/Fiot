import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import 'package:generic_iot_sensor/screens/shimmerprojectlist.dart';
import 'package:generic_iot_sensor/services/apiservices.dart';
import 'package:generic_iot_sensor/services/tcpclient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/applicationhelper.dart';
import '../helper/helper.dart';

import '../model/unitconfig.dart';
import '../provider/tcp_provider/tcp_provider_receive_data.dart';
import '../provider/unit_management_provider/unitprovider.dart';
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

  List<UserUnit> laughTale = [];
  late List<Unit> configList = [];
  String prevIP = "";
  int increCounter = 0;
  Socket? clientSocket;
  String _scanBarcode = 'Unknown';
  int _selectedIndex = -1;
  List<String> str = [];

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
        body: ref.watch(userDataNotifier(Helper.userIDValue)).when(data: (data) {
          return SingleChildScrollView(
            child: SizedBox(
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

                         /* Row(
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
                                        *//*if (goBack) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Invalid Qr')));
                                            }*//*
                                      }});
                                  },
                                  child: Text(' SCAN QR '),
                                ),
                              ),

                            ],
                          ),*/
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
                    ListView.builder(
                      physics: ScrollPhysics(),
                       //scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data.data!.units!.length,
                        itemBuilder: (context, index) {
                          return Visibility(
                              child:   InkWell(
                                onTap: (){
                                  PopUp(index,data.data!.units![index]);

                                },
                                child: Card(
                            elevation: 20,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child:Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("IP : "),
                                        Text(data.data!.units![index].ip.toString())
                                      ],
                                    ),SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Text("MAC : "),
                                        Text(data.data!.units![index].macId.toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("PORT: ${data.data!.units![index].port.toString()}"),
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 200),
                                              child: IconButton(onPressed: (){

                                                ConfirmPopup(data.data!.units![index]);

                                              }, icon: Icon(Icons.delete)),
                                            )
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                            ),
                          ),
                              ));
                          // return getConfigList(index, config);
                        }),
                  ],
                ),
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
            }),floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,);
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

  void PopUp(int index,UserUnit device){
     showDialog(
      context: context,
      builder: (ctx) => SizedBox(
        height: 20,
       width: 40,

       child: AlertDialog(
         title: Text("MACID: ${device.macId.toString()}",style: TextStyle(
           fontSize: 16
         ),),
          content:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(

                    onPressed: () {
                      String qrResult = '';
                      Future<String> scanValue = scanQR();
                      scanValue.then((value) {
                        Map valueMap = json.decode(value);

                        for (var mac in Helper.listOfMac) {
                          print(Helper.listOfMac);
                          if (mac == valueMap['MacAddress']){
                            // goBack = false;
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
                  ElevatedButton(

                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          AppId.Configuration);
                    },
                    child: Text('CONFIG'),
                  ),
                ],
              ),



        ),
      )
    );


  }

  void ConfirmPopup( UserUnit finalResult){
    print("confirm");

        showDialog(
            context: context,
            builder: (ctx) => SizedBox(
              height: 20,
              width: 40,
              child: AlertDialog(
                title: Text("CONFIRM ??",style: TextStyle(fontSize: 16),),
                content:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.read(addUnitNotifier.notifier).addUnit(UnitData(
                            JSON_ID: "05",
                            USER_ID: Helper.userIDValue,
                            DATA: Unit(
                                PORT: '5000',
                                IP: finalResult.ip!,
                                COMMUNICATION_ID: finalResult.communicationId!,
                                LOCATION: finalResult.location!,
                                KEEPALIVE_TIME: finalResult.keepaliveTime!,
                                MAC_ID: finalResult.macId.toString().toUpperCase(),
                                VERSION: finalResult.version!,
                                ISACTIVE: "0"

                            )));
                        Future.delayed(
                          const Duration(milliseconds: 200),
                              () {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Deleted Successfully")));

                            Navigator.pop(context);
                            ref.refresh(userDataNotifier(Helper.userIDValue));
                          },
                        );

                      },
                      child: Text('YES'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        /* Navigator.of(context).pushNamed(
                        AppId.Configuration);*/
                      },
                      child: Text('NO'),
                    ),
                  ],
                ),


              ),
            )
        );





  }
}
