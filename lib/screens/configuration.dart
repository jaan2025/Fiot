import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/helper/packet_control.dart';
import 'package:generic_iot_sensor/screens/edgedevice/SingleChannel.dart';
import 'package:generic_iot_sensor/screens/edgedevice/Single_three_channel.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/applicationhelper.dart';
import '../helper/helper.dart';
import '../model/unitconfig.dart';
import '../provider/tcp_provider/tcp_provider_receive_data.dart';
import '../provider/unit_management_provider/unitprovider.dart';
import '../provider/user_management_provider/loginnotifier.dart';
import '../res/screensize.dart';
import '../responsive/responsive.dart';
import '../services/tcpclient.dart';
import 'communicationtype.dart';
import 'edgedevice/add_edgedevice.dart';

class Configuration extends ConsumerStatefulWidget {
  String? IPADDRESS;
  dynamic MAC;
  dynamic unitID;

  Configuration({Key? key, this.IPADDRESS,this.MAC,this.unitID}) : super(key: key);

  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends ConsumerState<Configuration> {

  bool tcp = true, http = false, mqtt = false, heart_account = false;
  bool postMethod = true, getMethod = false, putMethod = false;
  bool publishOption = false, subscribeOption = false;

  List<String> communicationTypes = ['TCP', 'HTTP', 'MQTT'];
  String selectedCommunicationType = 'TCP';

  List<String> tcpsiapropselection = ['SIA', 'PROPERATORY'];
  String selectedSIAPROPValues = 'SIA';

  List<String> httpMethodList =['HTTP POST','HTTP PUT','HTTP GET','HTTP POST & HTTP GET','HTTP PUT & HTTP GET'];
  String selectedHttpMethod = 'HTTP POST';
  String selectionHttpType = '01';
  String selectionMQTTType = '01';

  TextEditingController targetipController = TextEditingController();
  TextEditingController targetportController = TextEditingController();
  TextEditingController deviceipController = TextEditingController();
  TextEditingController deviceportController = TextEditingController();
  TextEditingController heartbeatController = TextEditingController();
  TextEditingController accountnoController = TextEditingController();
  TextEditingController posturlController = TextEditingController();
  TextEditingController puturlController = TextEditingController();
  TextEditingController geturlController = TextEditingController();
  TextEditingController publishtopicController = TextEditingController();
  TextEditingController subscribetopicController = TextEditingController();

  String cType = "", cHearBeat = "", vAccNo = "";

  var typeTcp = "01", tcpRead = "01", tcpWrite = "02";
  var typeHttp = "02", httpRead = "03", httpWrite = "04";
  var typeMqqt = "03", mqqtRead = "05", mqqtWrite = "06";

  var SIA = "01", PROP = "02";

  var httppost = "01",
      httpput = "02",
      httpget = "03",
      postget = "04",
      putget = "05";

  var mqttpublish = "01", mqttsubscribe = "02", mqttpublishsubscribe = "03";

  var finalResults, packId;
  int tempInt = 0;
  ProgressDialog ? pr;

  String _scanBarcode = 'Unknown';

  bool goBack = true;
  bool isLoading = false;

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
  void initState() {
    targetipController.text = "";
    targetportController.text = "";
    deviceipController.text = "";
    deviceportController.text = "";
    posturlController.text = "";
    puturlController.text = "";
    geturlController.text = "";
    publishtopicController.text = "";
    subscribetopicController.text = "";
    heartbeatController.text = "";
    accountnoController.text = "";
    tempInt = 0;
    ReadCommunicationData();

    Helper.classes = "CONFIGURATION";

  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return Responsive.isDesktop(context)
        ? windowsUi(context)
        : Responsive.isMobile(context)
        ? mobileUi(context)
        : windowsUi(context);
  }

  mobileUi(BuildContext context) {
    print("MAAAAC --- > ${widget.MAC}");
    print("IPADDRESS --- > ${widget.IPADDRESS}");
    return WillPopScope(
      onWillPop: () async => true,
      child: SafeArea(
        child: Scaffold(body: Consumer(builder: (context, ref, child) {
          var data = ref.watch(tcpReceiveDataNotifier);
          return () {
            return data.id.when(data: (data) {
              print("DATA---${data.toString()}");
              var finalResult = data.toString().split('\$');
              Future.delayed(const Duration(milliseconds: 15), () {
                print("finalResult");
                print(finalResult.toString());

                if (finalResult.isNotEmpty &&
                    finalResult.toString() != '[Connected]' &&
                    finalResult.toString() != '[NotConnected]' &&
                    finalResult.toString() != '[]' &&
                    finalResult.toString() != "[TimeOut]" &&
                    packId == finalResult[1]) {
                 // dismissProgressDialog();
                  tempInt++;
                  if (tempInt == 1) {
                    try {
                      print("try");
                      int typePos = int.parse(finalResult[4]);
                      selectedCommunicationType =
                          communicationTypes[typePos - 1].toString();
                      print(selectedCommunicationType);
                      if (finalResult[1] == "01") {
                        cType = getCommunicationType(
                            finalResult[finalResult.length - 2]);
                        selectedSIAPROPValues =
                            finalResult[5] == "01" ? "SIA" : "PROPERATORY";
                        targetipController.text = finalResult[7];
                        targetipController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: targetipController.text.length));
                        targetportController.text = finalResult[8];
                        targetportController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: targetportController.text.length));
                        deviceipController.text = finalResult[9];
                        deviceipController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: deviceipController.text.length));
                        deviceportController.text = finalResult[10];
                        deviceportController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: deviceportController.text.length));
                        heartbeatController.text = finalResult[12];
                        heartbeatController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: heartbeatController.text.length));
                        accountnoController.text = finalResult[11];
                        accountnoController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: accountnoController.text.length));
                        cHearBeat = heartbeatController.text;
                        vAccNo = accountnoController.text;
                        setState(() {});
                      } else if (finalResult[1] == "03") {
                        cType = getCommunicationType(
                            finalResult[finalResult.length - 2]);
                        int methodPos = int.parse(finalResult[5]);
                        selectedHttpMethod =
                            httpMethodList[methodPos - 1].toString();
                        selectionHttpType = finalResult[5];
                        setState(() {
                          setHttpVisibility();
                        });
                        posturlController.text = finalResult[7];
                        posturlController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: posturlController.text.length));
                        puturlController.text = finalResult[8];
                        puturlController.selection = TextSelection.fromPosition(
                            TextPosition(offset: puturlController.text.length));
                        geturlController.text = finalResult[9];
                        geturlController.selection = TextSelection.fromPosition(
                            TextPosition(offset: geturlController.text.length));
                        heartbeatController.text = finalResult[10];
                        heartbeatController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: heartbeatController.text.length));
                        accountnoController.text = finalResult[11];
                        accountnoController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: accountnoController.text.length));
                        cHearBeat = heartbeatController.text;
                        vAccNo = accountnoController.text;
                      } else if (finalResult[1] == "05") {
                        cType = getCommunicationType(
                            finalResult[finalResult.length - 2]);
                        selectionMQTTType = finalResult[5];
                        setState(() {
                          setMQTTVisibility();
                        });
                        publishtopicController.text = finalResult[7];
                        publishtopicController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: publishtopicController.text.length));
                        subscribetopicController.text = finalResult[8];
                        subscribetopicController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: subscribetopicController.text.length));
                        heartbeatController.text = finalResult[9];
                        heartbeatController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: heartbeatController.text.length));
                        accountnoController.text = finalResult[10];
                        accountnoController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: accountnoController.text.length));
                        cHearBeat = heartbeatController.text;
                        vAccNo = accountnoController.text;
                      }
                      /*if (finalResult[1] == "02") {
                              ReadTCPData();
                            } else if (finalResult[1] == "04") {
                              ReadHttpData(selectionHttpType);
                            } else if (finalResult[1] == "06") {
                              ReadMqqtData();
                            }*/
                    } catch (e) {
                      print("catch");
                      if (finalResult[1] == "02") {
                        ReadTCPData();
                      } else if (finalResult[1] == "04") {
                        ReadHttpData();
                      } else if (finalResult[1] == "06") {
                        ReadMqqtData();
                      }
                    }
                  }
                } else if (finalResult.isNotEmpty &&
                    finalResult.toString() == "[TimeOut]") {
                  dismissProgressDialog();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Timeout")));
                } else if (finalResult.isNotEmpty &&
                    finalResult.toString() != '[]' &&
                    finalResult.toString() != "[TimeOut]" &&
                    finalResult.toString() != '[Connected]' &&
                    finalResult.toString() != '[NotConnected]' &&
                    finalResult[1] == "07") {
                  print("communicationtype");
                  dismissProgressDialog();
                  addUnit(finalResult);
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    if (finalResult[4] == "01") {
                      ReadTCPData();
                    } else if (finalResult[4] == "02") {
                      ReadHttpData();
                    } else if (finalResult[4] == "03") {
                      ReadMqqtData();
                    }
                  });
                }
              });

              Future.delayed(Duration(seconds: 10),(){
                if(isLoading == true){
                  setState(() {
                    isLoading = false;
                  });
                }
              });
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_sharp,
                                    color: Colors.black,
                                  )),
                              Text(
                                'Configuration Screen ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04      ),
                              ),
                            ],
                          ),

                          InkWell(
                            onTap: (){

                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(

                                    onPressed: () {
                                      String qrResult = '';
                                      Future<String> scanValue = scanQR();
                                      scanValue.then((value) {
                                        Map valueMap = json.decode(value);

                                        for (var mac in Helper.listOfMac) {
                                          print(Helper.listOfMac);
                                          if (mac == valueMap['MacAddress']){
                                            goBack = false;
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Communication Type : ",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    cType,
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CommunicationType(),
                                          ),
                                        );
                                      },
                                      child: const Text(" >>CHANGE",style: TextStyle(
                                        color: Colors.blue
                                      ),)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Heart Beat : ",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    cHearBeat,
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Account Number : ",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    vAccNo,
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  isLoading == false ?   Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 30,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 8.0),
                              child: SizedBox(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              width: 3, color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              width: 3, color: Colors.black))),
                                  value: selectedCommunicationType,
                                  onChanged: (item) {
                                    setState(() {
                                      selectedCommunicationType =
                                          item.toString();
                                      clearText();
                                      switch (selectedCommunicationType) {
                                        case "HTTP":
                                          ReadHttpData();
                                          break;
                                        case "MQTT":
                                          ReadMqqtData();
                                          break;
                                         case "TCP":
                                        default:
                                          ReadTCPData();
                                          break;
                                      }
                                    });
                                  },
                                  items: communicationTypes
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: tcp,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 8,
                                        right: 8,
                                        bottom: 8),
                                    child: Container(
                                      child: SizedBox(
                                        width: 400,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.black54)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      width: 2,
                                                      color: Colors.blue))),
                                          value: selectedSIAPROPValues,
                                          onChanged: (a) {
                                            setState(() {
                                              selectedSIAPROPValues =
                                                  a.toString();
                                            });
                                          },
                                          items: tcpsiapropselection
                                              .map<DropdownMenuItem<String>>(
                                                  (String val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(val),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //TCP
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: targetipController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Target IP',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(25)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: targetportController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Target Port',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(4)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: deviceipController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Device IP',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(25)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: deviceportController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Device Port',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(4)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Visibility(
                              visible: http,
                              child: Column(
                                children: [
                                  //HTTP
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: SizedBox(
                                        width: 400,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      width: 1,
                                                      color: Colors.black54)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      width: 2,
                                                      color: Colors.blue))),
                                          value: selectedHttpMethod,
                                          onChanged: (changemethod) {
                                            setState(() {
                                              selectedHttpMethod =
                                                  changemethod.toString();
                                              var httpType =
                                                  httpMethodList.indexOf(
                                                          selectedHttpMethod) +
                                                      1;
                                              selectionHttpType =
                                                  ApplicationHelper.formDigits(
                                                      2, httpType.toString())!;
                                              setHttpVisibility();
                                            });
                                          },
                                          items: httpMethodList
                                              .map<DropdownMenuItem<String>>(
                                                  (String sample) {
                                            return DropdownMenuItem<String>(
                                                value: sample,
                                                child: Text(sample));
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: postMethod,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: posturlController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            //labelText: 'User Name',
                                            hintText: 'Post URL',
                                          ),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      )),
                                  Visibility(
                                      visible: putMethod,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: puturlController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            //labelText: 'User Name',
                                            hintText: 'Put URL',
                                          ),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      )),
                                  Visibility(
                                      visible: getMethod,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          controller: geturlController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            // labelText: 'User Name',
                                            hintText: 'Get URL',
                                          ),
                                          textInputAction: TextInputAction.next,
                                        ),
                                      )),
                                ],
                              ),
                            ),

                            Visibility(
                                visible: mqtt,
                                child: Column(
                                  children: [
                                    //MQTT
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: publishOption,
                                            onChanged: (click1) {
                                              setState(() {
                                                publishOption = click1!;
                                              });
                                            }),
                                        const Text(
                                          "Publish",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: subscribeOption,
                                            onChanged: (click2) {
                                              setState(() {
                                                subscribeOption = click2!;
                                              });
                                            }),
                                        const Text(
                                          "Subscribe",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800),
                                        )
                                      ],
                                    ),
                                    Visibility(
                                        visible: publishOption,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: publishtopicController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Publish Topic',
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                          ),
                                        )),
                                    Visibility(
                                        visible: subscribeOption,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller:
                                                subscribetopicController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Subscribe Topic',
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                          ),
                                        )),
                                  ],
                                ) //MQTT

                                ),

                            //heart beat & accountnumber
                            Visibility(
                              visible: heart_account,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: heartbeatController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Heart Beat',
                                          ),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(4)
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.0, left: 5.0),
                                          child: Text("in Second"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: accountnoController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Account Number',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(5)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: accountnoController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Account Number',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                    ),
                                  ),*/
                            //submit button
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      Helper.Macaddress = widget.MAC!;
                                      final DateTime now = DateTime.now();
                                      final DateFormat dayformatter =
                                          DateFormat('dd:MM:yy');
                                      final DateFormat timeformatter =
                                          DateFormat('hh:mm:ss');
                                      final String dayToday =
                                          dayformatter.format(now);
                                      final String timeNow =
                                          timeformatter.format(now);
                                      switch (selectedCommunicationType) {
                                        case "TCP":
                                          {
                                            if (validate_Tcp()) {
                                             // showProgressDialog(context);
                                              print("write");
                                              var selectionsiapropType =
                                                  selectedSIAPROPValues == "SIA"
                                                      ? "01"
                                                      : "02";
                                              String pck = PacketControl
                                                      .startPacket +
                                                  PacketControl.splitChar +
                                                  tcpWrite +
                                                  PacketControl.splitChar +
                                                  PacketControl.writePacket +
                                                  PacketControl.splitChar +
                                                  PacketControl.iotModeWifi +
                                                  PacketControl.splitChar +
                                                  typeTcp +
                                                  PacketControl.splitChar +
                                                  selectionsiapropType +
                                                  PacketControl.splitChar +
                                                  Helper.Macaddress
                                                      .toUpperCase() +
                                                  PacketControl.splitChar +
                                                  targetipController.text +
                                                  PacketControl.splitChar +
                                                  targetportController.text +
                                                  PacketControl.splitChar +
                                                  deviceipController.text +
                                                  PacketControl.splitChar +
                                                  deviceportController.text +
                                                  PacketControl.splitChar +
                                                  heartbeatController.text +
                                                  PacketControl.splitChar +
                                                  accountnoController.text +
                                                  PacketControl.splitChar +
                                                  timeNow +
                                                  PacketControl.splitChar +
                                                  dayToday +
                                                  PacketControl.splitChar +
                                                  PacketControl.endPacket;
                                              packId = tcpWrite;
                                              ref
                                                  .read(tcpProvider)
                                                  .sendPackets(pck);
                                              var writeResponse = ref.watch(
                                                  tcpReceiveDataNotifier);
                                              print("writeResponse");
                                              print(writeResponse);
                                            }
                                          }
                                          break;
                                        case "HTTP":
                                          {
                                            if (validate_http()) {
                                              print("http write");
                                            //  showProgressDialog(context);
                                              var httpType =
                                                  httpMethodList.indexOf(
                                                          selectedHttpMethod) +
                                                      1;
                                              selectionHttpType =
                                                  ApplicationHelper.formDigits(
                                                      2, httpType.toString())!;

                                              String pck = PacketControl
                                                      .startPacket +
                                                  PacketControl.splitChar +
                                                  httpWrite +
                                                  PacketControl.splitChar +
                                                  PacketControl.writePacket +
                                                  PacketControl.splitChar +
                                                  PacketControl.iotModeWifi +
                                                  PacketControl.splitChar +
                                                  typeHttp +
                                                  PacketControl.splitChar +
                                                  selectionHttpType +
                                                  PacketControl.splitChar +
                                                  Helper.Macaddress
                                                      .toUpperCase() +
                                                  PacketControl.splitChar +
                                                  posturlController.text +
                                                  PacketControl.splitChar +
                                                  puturlController.text +
                                                  PacketControl.splitChar +
                                                  geturlController.text +
                                                  PacketControl.splitChar +
                                                  heartbeatController.text +
                                                  PacketControl.splitChar +
                                                  accountnoController.text +
                                                  PacketControl.splitChar +
                                                  timeNow +
                                                  PacketControl.splitChar +
                                                  dayToday +
                                                  PacketControl.splitChar +
                                                  PacketControl.endPacket;
                                              packId = httpWrite;
                                              Helper.Ipaddress = widget.IPADDRESS!;
                                              print("MAINpACKET ===> $pck");
                                              ref
                                                  .read(tcpProvider)
                                                  .sendPackets(pck);
                                            }
                                          }
                                          break;

                                        case "MQTT":
                                          {
                                            if (validate_mqtt()) {
                                              print("mqtt write");
                                            //  showProgressDialog(context);
                                              if (publishOption &&
                                                  subscribeOption) {
                                                selectionMQTTType = '03';
                                              } else if (subscribeOption) {
                                                selectionMQTTType = '02';
                                              } else {
                                                selectionMQTTType = '01';
                                              }
                                              String pck = PacketControl
                                                      .startPacket +
                                                  PacketControl.splitChar +
                                                  mqqtWrite +
                                                  PacketControl.splitChar +
                                                  PacketControl.writePacket +
                                                  PacketControl.splitChar +
                                                  PacketControl.iotModeWifi +
                                                  PacketControl.splitChar +
                                                  typeMqqt +
                                                  PacketControl.splitChar +
                                                  selectionMQTTType +
                                                  PacketControl.splitChar +
                                                  Helper.Macaddress
                                                      .toUpperCase() +
                                                  PacketControl.splitChar +
                                                  publishtopicController.text +
                                                  PacketControl.splitChar +
                                                  subscribetopicController
                                                      .text +
                                                  PacketControl.splitChar +
                                                  heartbeatController.text +
                                                  PacketControl.splitChar +
                                                  accountnoController.text +
                                                  PacketControl.splitChar +
                                                  timeNow +
                                                  PacketControl.splitChar +
                                                  dayToday +
                                                  PacketControl.splitChar +
                                                  PacketControl.endPacket;
                                              packId = mqqtWrite;
                                              ref
                                                  .read(tcpProvider)
                                                  .sendPackets(pck);
                                            }
                                          }
                                          break;
                                      }
                                    },
                                    child: const Text("SUBMIT")),
                              ),
                            )
                          ],
                        ),
                      ),
                    ): Center(child: CircularProgressIndicator(),)
                  ],
                ),
              );
            }, error: (error, txt) {
              return Text(txt.toString());
            }, loading: () {
              return Center(child: const CircularProgressIndicator(
              ));
            });
          }();
        })),
      ),
    );
  }

  windowsUi(BuildContext context) {

  }

  bool validatePopup(String message){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:  const Text("Validation Failed"),
        content:  Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
    return false;
  }

  bool validate_Tcp(){
    if(targetipController.text.isEmpty){
      return validatePopup("Target IP should not be empty");
    }
    else if(!validator.ip(targetipController.text)){
      return validatePopup("Kindly enter the valid Target IP");
    }
    else if(targetportController.text.isEmpty){
      return validatePopup("Target Port should not be empty");
    }
    else if(targetportController.text.length != 4){
      return validatePopup("Kindly enter the 5 digit valid Target Port number");
    }
    else if(deviceipController.text.isEmpty){
      return validatePopup("Device IP should not be empty");
    }
    else if(!validator.ip(deviceipController.text)){
      return validatePopup("Kindly enter the valid Device IP");
    }
    else if(deviceportController.text.isEmpty){
      return validatePopup("Device Port should not be empty");
    }
    else if(deviceportController.text.length != 4){
      return validatePopup("Kindly enter the 5 digit valid Device Port number");
    }
    else if(heartbeatController.text.isEmpty){
      return validatePopup("Heart beat should not be empty");
    }
    else if(heartbeatController.text.length != 4){
      return validatePopup("Heart beat should be less than 9999 seconds");
    }
    else if(accountnoController.text.isEmpty){
      return validatePopup("Account Number should not be empty");
    }
    else if(accountnoController.text.length != 5){
      return validatePopup("Kindly enter the 5 digit valid Account Number");
    }
    return true;
  }

  bool validate_http(){
    if(posturlController.text.isEmpty){
      return validatePopup("Post Url should not be empty");
    }
    return true;
  }

  bool validate_mqtt(){
    if(publishOption == false && subscribeOption == false){
      return validatePopup("Select atleast one items");
    }
    else if(publishtopicController.text.isEmpty){
      return validatePopup("Publish Topic should not be empty");
    }
    else if(subscribetopicController.text.isEmpty){
      return validatePopup("Subscribe Topic should not be empty");
    }
    else if(heartbeatController.text.isEmpty){
      return validatePopup("Heart beat should not be empty");
    }
    else if(heartbeatController.text.length != 4){
      return validatePopup("Heart beat should be less than 9999 seconds");
    }
    else if(accountnoController.text.isEmpty){
      return validatePopup("Account Number should not be empty");
    }
    else if(accountnoController.text.length != 5){
      return validatePopup("Kindly enter the 5 digit valid Account Number");
    }
    return true;
  }

  clearText(){
    targetipController.clear();
    targetportController.clear();
    deviceipController.clear();
    deviceportController.clear();
    accountnoController.clear();
    posturlController.clear();
    puturlController.clear();
    geturlController.clear();
    publishtopicController.clear();
    subscribetopicController.clear();
    heartbeatController.clear();
    accountnoController.clear();
    publishOption = false;
    subscribeOption = false;
    postMethod = false; getMethod = false; putMethod = false;
  }

  ReadCommunicationData(){
    tempInt = 0;
    String pck = PacketControl.startPacket +
        PacketControl.splitChar +
        "07" +
        PacketControl.splitChar +
        PacketControl.readPacket +
        PacketControl.splitChar +
        PacketControl.iotModeWifi +
        PacketControl.splitChar +
        PacketControl.endPacket;
    print("PACKET --- > $pck");
    Helper.Ipaddress = widget.IPADDRESS!;
    ref.read(tcpProvider).sendPackets(pck);
  }

  ReadTCPData(){
    tcp = true;
    http = false;
    mqtt = false;
   // showProgressDialog(context);
    tempInt = 0;
    packId = tcpRead;
    String pck = PacketControl.startPacket +
        PacketControl.splitChar +
        tcpRead +
        PacketControl.splitChar +
        PacketControl.readPacket +
        PacketControl.splitChar +
        PacketControl.iotModeWifi +
        PacketControl.splitChar +
        typeTcp +
        PacketControl.splitChar +
        PacketControl.endPacket;
    ref.read(tcpProvider).sendPackets(pck);
  }

  ReadHttpData(){
    tcp = false;
    http = true;
    mqtt = false;
   // showProgressDialog(context);
    tempInt = 0;
    packId = httpRead;
    String pck = PacketControl.startPacket +
        PacketControl.splitChar +
        httpRead +
        PacketControl.splitChar +
        PacketControl.readPacket +
        PacketControl.splitChar +
        PacketControl.iotModeWifi +
        PacketControl.splitChar +
        typeHttp +
        PacketControl.splitChar +
        PacketControl.endPacket;
    ref.read(tcpProvider).sendPackets(pck);
  }

  ReadMqqtData(){
    tcp = false;
    http = false;
    mqtt = true;
   // showProgressDialog(context);
    tempInt = 0;
    packId = mqqtRead;
    String pck = PacketControl.startPacket +
        PacketControl.splitChar +
        mqqtRead +
        PacketControl.splitChar +
        PacketControl.readPacket +
        PacketControl.splitChar +
        PacketControl.iotModeWifi +
        PacketControl.splitChar +
        typeMqqt +
        PacketControl.splitChar +
        PacketControl.endPacket;
    ref.read(tcpProvider).sendPackets(pck);
  }

  void setHttpVisibility() {
    switch(selectionHttpType){
      case '01':
        postMethod = true;
        getMethod = false;
        putMethod = false;
        break;
      case '02':
        postMethod = false;
        getMethod = false;
        putMethod = true;
        break;
      case '03':
        postMethod = false;
        getMethod = true;
        putMethod = false;
        break;
      case '04':
        postMethod = true;
        getMethod = true;
        putMethod = false;
        break;
      case '05':
        postMethod = false;
        getMethod = true;
        putMethod = true;
        break;
    }
  }

  void setMQTTVisibility() {
    switch(selectionMQTTType){
      case "01":
        publishOption = true;
        subscribeOption = false;
        break;
      case "02":
        publishOption = false;
        subscribeOption = true;
        break;
      case "03":
        publishOption = true;
        subscribeOption = true;
        break;
    }
  }

  String getCommunicationType(cType){
    switch(cType){
      case "02":
        cType = "HTTP";
        break;
      case "03":
        cType = "MQTT";
        break;
      case "01":
      default:
        cType = "TCP";
        break;
    }
    return cType;
  }
  showProgressDialog(BuildContext context) async {
    /* Timer(
         const Duration(seconds: 60),
             () => dismissProgressDialog());*/
    pr = ProgressDialog(context, type: ProgressDialogType.normal,
        isDismissible: false,
        showLogs: false);
    pr!.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr!.show();

  }
  dismissProgressDialog() async {
    if(pr!.isShowing()) {
      pr!.hide();
    }
  }

  Future<void> addUnit(List<String> finalResult)  async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Helper.userId);
    ref
        .read(
        addUnitNotifier.notifier)
        .addUnit(
        UnitData(
            JSON_ID: "06",
            USER_ID: Helper.userIDValue,
            DATA: Unit(
              PORT: '5000',
              IP: Helper.Ipaddress,
              COMMUNICATION_ID: finalResult[4],
              LOCATION: finalResult[8],
              KEEPALIVE_TIME: finalResult[7],
              MAC_ID: Helper.Macaddress.toUpperCase(),
              VERSION: finalResult[6],
              ISACTIVE: "1",
              UNIT_ID:widget.unitID
            ))
    );
    Future.delayed(
        const Duration(seconds: 1), () {
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
}