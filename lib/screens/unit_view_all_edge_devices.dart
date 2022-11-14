import 'package:flutter/material.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/dashboard.dart';
import 'package:generic_iot_sensor/screens/dashboard_main.dart';
import '../helper/helper.dart';
import '../provider/user_management_provider/live_data_provider.dart';
import '../res/colors.dart';
import 'dart:math' as math;
import '../res/id.dart';
import 'edge_device_sensor_list.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
class UnitViewAllEdgeDeviceScreen extends ConsumerStatefulWidget {

  List<UserUnit> ? list ;
   UnitViewAllEdgeDeviceScreen( {this.list,Key? key}) : super(key: key);

  @override
  ConsumerState<UnitViewAllEdgeDeviceScreen> createState() => _UnitViewAllEdgeDeviceScreenState();
}

class _UnitViewAllEdgeDeviceScreenState extends ConsumerState<UnitViewAllEdgeDeviceScreen> {
  @override
  Widget build(BuildContext context) {

    print("MUNIT ===========>${ widget.list?.length}");
    return SafeArea(child: Scaffold(
      backgroundColor: AppColors.cream,
      body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*IconButton(
                      onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()));
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: Colors.black,
                      )),*/
                  Text(
                    'Edge Devices List',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                        MediaQuery.of(context).size.width *
                            0.05),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: Helper.mUnit.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                  return itemBuilderUnitList(Helper.mUnit[index]);
                },),
              ),
            )
          ],
        ),
      ),
    ),));
  }

  itemBuilderEdgeDevice(int index, UserEdDevice edDevice) {

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: (){
          ref.refresh(liveDataNotifier.notifier);
          Future.delayed(Duration(milliseconds: 100),(){ref.read(liveDataNotifier.notifier).getLiveData({
            "JSON_ID": "12",
            "USER_ID": Helper.userIDValue,
            "DATA": {
              "MAC_ID": edDevice.macId!.toUpperCase(),
              "SERIAL_NO": edDevice.serialNo,
              "EDGE_DEVICE_ID": edDevice.edgeId
            }
          });
            });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  EdgeDeviceSensorList(edDevice : edDevice)),
          );
        },
        child: Column(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Card(
                elevation: 10,
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0),
                child: const Padding(
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


  itemBuilderUnitList(UserUnit unit){

    return Card(
      elevation: 30,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Ip  : ',style: TextStyle(fontWeight: FontWeight.bold),)  ,
                    Text(unit.ip!,style: const TextStyle(fontWeight: FontWeight.normal),)  ,
                  ],
                ),
                 Row(
                children: [
                  const Text('Mac  : ',style: TextStyle(fontWeight: FontWeight.bold),)  ,
                  Text(unit.macId!,style: const TextStyle(fontWeight: FontWeight.normal),)  ,
                ],
              )

              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 110,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:  unit.edDevice!.length ,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return itemBuilderEdgeDevice(index,unit.edDevice![index]);
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
