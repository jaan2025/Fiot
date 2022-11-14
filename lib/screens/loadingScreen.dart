import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../helper/helper.dart';
import '../helper/packet_control.dart';
import '../model/unitconfig.dart';
import '../provider/tcp_provider/tcp_provider_receive_data.dart';
import '../provider/unit_management_provider/unitprovider.dart';
import '../provider/user_management_provider/loginnotifier.dart';
import '../services/tcpclient.dart';
import 'edgedevice/add_edgedevice.dart';

class LoadingAnimationScreen extends ConsumerStatefulWidget {
  const LoadingAnimationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoadingAnimationScreen> createState() =>
      _LoadingAnimationScreenState();
}

class _LoadingAnimationScreenState
    extends ConsumerState<LoadingAnimationScreen> {
  int tempInt = 0;
  var finalResults, packId;

  String _scanBarcode = 'Unknown';

  bool goBack = true;

  @override
  void initState() {
    ReadCommunicationData();
  }

  ReadCommunicationData() {
    tempInt = 0;
    String pck =
        "${PacketControl.startPacket}${PacketControl.splitChar}07${PacketControl.splitChar}${PacketControl.readPacket}${PacketControl.splitChar}${PacketControl.iotModeWifi}${PacketControl.splitChar}${PacketControl.endPacket}";
    ref.read(tcpProvider).sendPackets(pck);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Consumer(builder: (context, ref, child) {
        var data = ref.watch(tcpReceiveDataNotifier);
        data.id.when(
            data: (data) {
              var finalResult = data.toString().split('\$');
              Future.delayed(const Duration(milliseconds: 15), () {
                if (finalResult.isNotEmpty &&
                    finalResult.toString() != '[Connected]' &&
                    finalResult.toString() != '[NotConnected]' &&
                    finalResult.toString() != '[]' &&
                    finalResult.toString() != "[TimeOut]" &&
                    packId == finalResult[1]) {
                  tempInt++;
                  if (tempInt == 1) {
                    try {
                      print("try");
                      if (finalResult[1] == "01") {
                      } else if (finalResult[1] == "03") {
                      } else if (finalResult[1] == "05") {}
                    } catch (e) {
                      if (finalResult[1] == "02") {
                      } else if (finalResult[1] == "04") {
                      } else if (finalResult[1] == "06") {}
                    }
                  }
                } else if (finalResult.isNotEmpty &&
                    finalResult.toString() == "[TimeOut]") {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Timeout")));
                } else if (finalResult.isNotEmpty &&
                    finalResult.toString() != '[]' &&
                    finalResult.toString() != "[TimeOut]" &&
                    finalResult.toString() != '[Connected]' &&
                    finalResult.toString() != '[NotConnected]' &&
                    finalResult[1] == "07") {
                  addUnit(finalResult);
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    if (finalResult[4] == "01") {
                    } else if (finalResult[4] == "02") {
                    } else if (finalResult[4] == "03") {}
                  });
                }
              });
            },
            error: (error, s) {},
            loading: () {});
        return Center(
          child: Column(
            children: [
              SizedBox(
                  width: 300,
                  height: 300,
                  child: Lottie.asset('assets/smat_load.json')),
              const Text(
                'Please wait.......',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        );
      }),
    ));
  }

  Future<void> addUnit(List<String> finalResult) async {
    ref.read(addUnitNotifier.notifier).addUnit(UnitData(
        JSON_ID: "05",
        USER_ID: Helper.userIDValue,
        DATA: Unit(
          PORT: '5000',
          IP: Helper.Ipaddress,
          COMMUNICATION_ID: finalResult[4],
          LOCATION: finalResult[8],
          KEEPALIVE_TIME: finalResult[7],
          MAC_ID: Helper.Macaddress.toUpperCase(),
          VERSION: finalResult[6],
        )));
    Future.delayed(const Duration(seconds: 1), () {
      print("addunit_response");
      var state = ref.watch(addUnitNotifier);

      state.id.when(data: (data) {
        var response = json.decode(data);
        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(response['DATA']['MSG'])));
          },
        );

        Future.delayed(
          const Duration(milliseconds: 400),
          () {
            ref.refresh(userDataNotifier(Helper.userIDValue));
          },
        );

        Future.delayed(
          const Duration(milliseconds: 2000),
          () {
            ref.watch(userDataNotifier(Helper.userIDValue)).when(
                data: (data) {
                  Helper.listOfMac.clear();
                  Helper.location.clear();
                  if (data.data != null) {
                    Helper.profileUserName = data.data!.userName!;
                    Helper.profileMobileNo = data.data!.mobileNo!;
                    Helper.profilePassword = data.data!.password!;
                    Helper.profileEmail = data.data!.emailId!;
                    Helper.isActive =
                        data.data!.isactive! == '1' ? true : false;
                    for (var mac in data.data!.units!) {
                      Helper.listOfMac.add(mac.macId!);
                    }
                    for (var loc in data.data!.locations!) {
                      Helper.location
                          .add('${loc.locationId!}-${loc.locationName}');
                    }
                  }
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    String qrResult = '';
                    Future<String> scanValue = scanQR();
                    scanValue.then((value) {
                      Map valueMap = json.decode(value);
                      for (var mac in Helper.listOfMac) {
                        if (mac == valueMap['MacAddress']) {
                          //goBack = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddEdgeDevice(valueMap: valueMap)),
                          );
                        }
                      }
                     /* if (goBack) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid Qr')));
                      }*/
                      Future.delayed(Duration(milliseconds: 200),(){
                        ref.refresh(addUnitNotifier);
                      });

                    });
                  });
                },
                error: (error, s) {},
                loading: () {});
          },
        );
      }, error: (error, s) {
        //visibility = false;
      }, loading: () {
        //visibility = false;
      });
      if (state.isLoading) {
        //visibility = true;
      }
    });
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
}
