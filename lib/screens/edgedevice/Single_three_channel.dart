/*
import 'package:flutter/material.dart';

import '../../helper/helper.dart';
import '../../model/edgedevice/getsensorlist.dart';
import '../../model/user_devicess/user_devies_model.dart';
import '../../provider/user_management_provider/loginnotifier.dart';
import '../../provider/widget_date_provider.dart';
import '../../res/id.dart';
import '../../res/screensize.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/apiservices.dart';
import '../shimmerprojectlist.dart';

class SingleThreeChannel extends ConsumerStatefulWidget {

  Map ? valueMap;
  SingleThreeChannel({this.valueMap});

  @override
  _SingleThreeChannelState createState() => _SingleThreeChannelState();
}

class _SingleThreeChannelState extends ConsumerState<SingleThreeChannel> {
  TextEditingController channel1Controller = TextEditingController();
  TextEditingController channel2Controller = TextEditingController();
  TextEditingController channel3Controller = TextEditingController();

  bool channel1 =  false, channel2 =  false, channel3 =  false;

  String dropdownvalue = 'Channel-1';

  // List of items in our dropdown menu
  var items = [
    'Channel-1',
    'Channel-2',
    'Channel-3',
  ];

  String? edgeDeviceName = '',
      mac = '',
      edgeId = '',
      productCode = '',
      serialNo = '',
      locationId = '';
  Map<String, dynamic> tempMap = {};
  Map<String, dynamic> mainMap = {};
  int index = 0;

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ref.watch(getDevices).when(data: (data) {
            for (int i = 0; i < data.edgeDevices!.length; i++) {
              */
/* if (widget.valueMap!['EdgeDeviceID'] == data.edgeDevices![i].edgeId) {
                index = i;
              }*//*

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
                                                child:  Text(
                                                  data.edgeDevices![5]
                                                      .sensorUnit
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .normal),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField(
                              // Initial Value
                              value: dropdownvalue,

                              // Down Arrow Icon

                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: ( newValue) {
                                setState(() {
                                  dropdownvalue = newValue.toString();
                                  switch (dropdownvalue){
                                    case "Channel-1" :
                                      channel1 = true;
                                      channel2 = false;
                                      channel3 = false;
                                      break;
                                    case "Channel-2" :
                                      channel1 = false;
                                      channel2 = true;
                                      channel3 = false;
                                      break;
                                    case "Channel-3" :
                                      channel1 = false;
                                      channel2 = false;
                                      channel3 = true;
                                      break;

                                  }
                                });
                              },
                              hint: Text(""),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            */
/* SizedBox(
                              height: 100,
                              child:     ListView.builder(
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
                            ),*//*


                            Visibility(
                              visible: channel1,
                              child: TextField(
                                controller: channel1Controller,
                                decoration: InputDecoration(
                                    hintText: 'channel 1'


                                ),
                              ),
                            ),
                            Visibility(
                              visible: channel2,
                              child: TextField(
                                controller: channel2Controller,
                                decoration: InputDecoration(
                                    hintText: 'channel 2'


                                ),
                              ),
                            ),
                            Visibility(
                              visible: channel3,
                              child: TextField(
                                controller: channel2Controller,
                                decoration: InputDecoration(
                                    hintText: 'channel 3'


                                ),
                              ),
                            ),
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: Helper.location.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return itemBuilderLocation(
                                            index, Helper.location[index]);
                                      },
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
                                        tempMap['MAC_ID'] = widget.valueMap!['MacAddress'];
                                        tempMap['SERIAL_NO'] = widget.valueMap!['SerialNo'];
                                        tempMap['EDGE_DEVICE_ID'] = widget.valueMap!['EdgeDeviceID'];
                                        mainMap["JSON_ID"] = "09";
                                        mainMap["USER_ID"] = Helper.userIDValue;
                                        mainMap["DATA"] = tempMap;

                                        ref
                                            .read(apiProvider)
                                            .addEdDevices(mainMap);


                                        Future.delayed(
                                          const Duration(milliseconds: 200),
                                              () {
                                            ref.refresh(userDataNotifier(Helper.userIDValue));
                                          },
                                        );
                                        Future.delayed(
                                          const Duration(milliseconds: 400),
                                              () {
                                            Navigator.pushNamed(context, AppId.DashboardID);
                                          },
                                        );
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
    // locationId = value[0];
    List split = value.split('-');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () {},
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
}
*/
