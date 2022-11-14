import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/live_data_provider.dart';
import 'package:generic_iot_sensor/provider/widget_date_provider.dart';
import 'package:generic_iot_sensor/res/id.dart';

import 'package:generic_iot_sensor/screens/dashboard.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/shimmerprojectlist.dart';

import '../../helper/applicationhelper.dart';
import '../../helper/helper.dart';
import '../../model/edgedevice/getsensorlist.dart';
import '../../provider/edgedevice_provider/addedgedevice_provider.dart';

import '../../provider/user_management_provider/loginnotifier.dart';
import '../../res/screensize.dart';
import '../../responsive/responsive.dart';
import '../../services/apiservices.dart';

class AddEdgeDevice extends ConsumerStatefulWidget {
  Map? valueMap;

  AddEdgeDevice({this.valueMap, Key? key}) : super(key: key);

  @override
  _AddEdgeDeviceState createState() => _AddEdgeDeviceState();
}

class _AddEdgeDeviceState extends ConsumerState<AddEdgeDevice> {
  //EdgeDeviceData ?  edgeDeviceList;
  String? edgeDeviceName = '',
      mac = '',
      edgeId = '',
      productCode = '',
      serialNo = '',
      locationId='';
  Map<String, dynamic> tempMap = {};
  Map<String, dynamic> mainMap = {};
  int index = 0;


  TextEditingController NameController = TextEditingController();

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mac = widget.valueMap!['MacAddress'];
      edgeId = widget.valueMap!['EdgeDeviceID'];
      productCode = widget.valueMap!['ProductCode'];
      serialNo = widget.valueMap!['SerialNo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ref.watch(getDevices).when(data: (data) {
            for (int i = 0; i < data.edgeDevices!.length; i++) {
              if (widget.valueMap!['EdgeDeviceID'] == data.edgeDevices![i].edgeId) {
                index = i;
              }
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
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
                        'Add Edge Devices',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 4,
                  child: SizedBox(
                      height: 150,
                      child: Image(
                          image: AssetImage('assets/images/smart_things.png'))),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Card(
                                      elevation: 20,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Sensor Name :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                data.edgeDevices![index]
                                                    .sensorUnit
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 100,
                              child:ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                data.edgeDevices![index].sensors!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, count) {
                                  return itemBuilderSensor(
                                    index,
                                    data.edgeDevices![index].sensors![count],
                                  );
                                },
                              ),
                            ),
                             TextField(
                              controller: NameController,
                              decoration: InputDecoration(
                              hintText:" Name your device"
                            ),),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const [
                                  Text(
                                    'Select Your Location',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                height: 110,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: Helper.location.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return itemBuilderLocation(
                                              index, Helper.location[index]);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {

                                        tempMap['LOCATION_ID'] = locationId;
                                        tempMap['PRODUCT_CODE'] = widget.valueMap!['ProductCode'];
                                        tempMap['NAME'] = NameController.text;
                                        tempMap['MAC_ID'] = widget.valueMap!['MacAddress'];
                                        tempMap['SERIAL_NO'] = widget.valueMap!['SerialNo'];
                                        tempMap['EDGE_DEVICE_ID'] = widget.valueMap!['EdgeDeviceID'];
                                        mainMap["JSON_ID"] = "09";
                                        mainMap["USER_ID"] = Helper.userIDValue;
                                        mainMap["DATA"] = tempMap;
                                        mainMap["ISACTIVE"] = "1";

                                        ref
                                            .read(apiProvider)
                                            .addEdDevices(mainMap);


                                        Future.delayed(
                                          const Duration(milliseconds: 200),
                                              () {
                                            ref.refresh(userDataNotifier(Helper.userIDValue));
                                          },
                                        );
                                       /* Future.delayed(
                                          const Duration(milliseconds: 400),
                                              () {
                                          Navigator.pushNamed(context, AppId.DashboardID);
                                          },
                                        );*/
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content:
                                            Text('Add SuccessFully')));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size.fromHeight(ScreenSize
                                            .screenHeight *
                                            0.07), // fromHeight use double.infinity as width and 40 is the height
                                      ),
                                      child: const Text('Save'),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ],
            );
          }, error: (error, s) {
            return Center(
              child: Text(error.toString()),
            );
          }, loading: () {
            return ShimmerForProjectList();
          })),
    );
  }

  itemBuilderLocation(int index, String value) {
    locationId = value[0];
    List split = value.split('-');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () {
              locationId = value[0];
              ref.read(widgetDateNotifier.notifier).currentIndex(index);
            },
            child: SizedBox(
              height: 100,
              child: Consumer(builder: (context, ref, child) {
                int selected = ref.watch(widgetDateNotifier);
                return Card(
                  color: selected == index ? Colors.orangeAccent : Colors.white,
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                            width: 30,
                            height: 30,
                            child: Image(
                                image: AssetImage(
                                    "assets/images/office-building.png"))),
                        Text(split[1].toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  itemBuilderSensor(int index, SensorDevices sensor) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              child: Card(
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(sensor.units.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(sensor.parameters.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

/* windowsUi(BuildContext context) {}

  mobileUi(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Edge Device',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 400,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              width: 1, color: Colors.black54)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(width: 2, color: Colors.blue))),
                  value: edgeDeviceName,
                  onChanged: (value) {
                    setState(() {
                      edgeDeviceName = value.toString();
                      edgedeviceselectedPos = edgeDeviceList.indexWhere(
                          (item) => item.SENSOR_UNIT == edgeDeviceName);
                    });
                  },
                  items: edgeDeviceList.map((EdgeDeviceData map) {
                    return DropdownMenuItem<String>(
                      value: map.SENSOR_UNIT,
                      child: Text(map.SENSOR_UNIT,
                          style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ),
            ),
            Card(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Sensor Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Unit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: edgedeviceselectedPos != -1
                  ? ListView.builder(
                      itemCount:
                          edgeDeviceList[edgedeviceselectedPos].SENSORS.length,
                      itemBuilder: (context, index) {
                        return getValue(edgedeviceselectedPos, index);
                      })
                  : const Text(""),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () async {},
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getValue(int edgeDevicePos, int sensorPos) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              edgeDeviceList[edgeDevicePos].SENSORS[sensorPos].PARAMETERS,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              edgeDeviceList[edgeDevicePos].SENSORS[sensorPos].UNITS,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getEdgeDeviceList() async {
    ApplicationHelper.showProgressDialog(context);
    ref.read(getEdgeDeviceNotifier.notifier).getEdgeDevicenfo();

    Future.delayed(const Duration(seconds: 1), () {
      ApplicationHelper.dismissProgressDialog();
      var state = ref.watch(getEdgeDeviceNotifier);
      state.id.when(data: (data) {
        try {
          var response = json.decode(data);
          Future.delayed(
            const Duration(milliseconds: 200),
            () {
              edgeDeviceList = (response['EdgeDevices'])
                  .map<EdgeDeviceData>((f) => EdgeDeviceData.fromJson(f))
                  .toList();
              edgeDeviceName = edgeDeviceList[0].SENSOR_UNIT;
              edgedeviceselectedPos = 0;
              setState(() {});
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data)));
        }
      }, error: (error, s) {
        // visibility = false;
      }, loading: () {
        // visibility = false;
      });
    });
  }*/
}
