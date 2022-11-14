import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import '../helper/helper.dart';
import '../provider/user_management_provider/live_data_provider.dart';
import '../res/colors.dart';
import 'dart:math' as math;
import 'edge_device_sensor_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class LocationListDevices extends ConsumerStatefulWidget {

  UserLocation? location;
  List<UserUnit>? list;

  LocationListDevices({this.location, this.list});

  @override
  ConsumerState<LocationListDevices> createState() => _LocationListDevicesState();
}

class _LocationListDevicesState extends ConsumerState<LocationListDevices> {

  List<UserEdDevice> edDeviceList = [];
  @override
  void initState() {
    for(var unit in widget.list!){
      for(var ed in unit.edDevice!){
        if(ed.locationId == widget.location!.locationId){
          edDeviceList.add(ed);
        }
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.cream,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
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
                    'Location List',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'LOCATION NAME',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.location!.locationName!
                                      .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xfff808080)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: const [
                              Text(
                                'SUB NAME',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text(
                                widget.location!.locationSubname!
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xfff808080)),
                              )
                            ],
                          ),
                        ),

                      ],
                    )),
                const Expanded(
                  flex: 6,
                  child:   SizedBox(
                      width: 150,
                      height: 150,
                      child: Image(
                          image: AssetImage('assets/images/smart.png'))),),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: MasonryGridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    controller: ScrollController(),
                    crossAxisSpacing: 4,
                    itemCount: edDeviceList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return itemBuilderEdgeDevice(index,edDeviceList[index]);

                    }),
              ),
            )
          ],
        ),
      ),
    ));
  }

  itemBuilderEdgeDevice(int index, UserEdDevice edDevice) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: (){
          ref.refresh(liveDataNotifier.notifier);
          ref.read(liveDataNotifier.notifier).getLiveData({
            "JSON_ID": "12",
            "USER_ID": Helper.userIDValue,
            "DATA": {
              "MAC_ID": edDevice.macId!.toUpperCase(),
              "SERIAL_NO": edDevice.serialNo,
              "EDGE_DEVICE_ID": edDevice.edgeId
            }
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  EdgeDeviceSensorList(edDevice : edDevice)),
          );
        },
        child: Column(
          children: [
            const SizedBox(
              child: Card(
                elevation: 20,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Image(
                          image: AssetImage('assets/images/thermometer.png'))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(edDevice.sensorUnit.toString(),style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xff808080)),),
            )
          ],
        ),
      ),
    );
  }
}
