import 'package:flutter/material.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/dashboard.dart';
import 'package:generic_iot_sensor/screens/dashboard_main.dart';
import '../helper/helper.dart';
import '../model/unitconfig.dart';
import '../provider/unit_management_provider/unitprovider.dart';
import '../provider/user_management_provider/live_data_provider.dart';
import '../provider/user_management_provider/loginnotifier.dart';
import '../res/colors.dart';
import 'dart:math' as math;
import '../res/id.dart';
import '../services/apiservices.dart';
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
  void initState() {


    super.initState();
  }
  Map<String, dynamic> tempMap = {};
  Map<String, dynamic> mainMap = {};

  @override
  Widget build(BuildContext context) {

    print("MUNIT ===========>${ widget.list?.length}");
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,

      backgroundColor: AppColors.cream,
      body: ref.watch(userDataNotifier(Helper.userIDValue)).when(data: (data){
   return Padding(
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
    itemCount: data.data!.units!.length,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
    return itemBuilderUnitList(data.data!.units![index],index);
    },),
    ),
    )
    ],
    ),
    ),
    );
    }, error: (error,e){}, loading: (){}
    )
    ));
  }

  itemBuilderEdgeDevice(int index, UserEdDevice edDevice) {

    return Visibility(
        //visible: edDevice.isactive == "1" ? true : false,
        child: Padding(
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
            Expanded(
              child: SizedBox(
                width: 70,
                height: 60,
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
            ),

            Row(
              children: [
                Text(edDevice.sensorUnit.toString(),style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xff808080)),),
                IconButton(onPressed: (){
                  ConfirmPopup(edDevice);

                }, icon: Icon(Icons.delete)),],
            )

          ],
        ),
      ),
    ));
  }


  itemBuilderUnitList(UserUnit unit,int index){
    return Visibility(
      visible: unit.edDevice!.length > 0 ? true : false,
        child: Card(
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
          /*  Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: (){
                  deleteLocation(unit.edDevice![index]);


                }, icon: Icon(Icons.delete)),
              ],
            )*/
          ],
        ),
      ),
    ));
  }

   ConfirmPopup( UserEdDevice edDevice){
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
                    tempMap['LOCATION_ID'] = edDevice.locationId;
                    tempMap['PRODUCT_CODE'] = edDevice.productCode;
                    tempMap['NAME'] =edDevice.name;
                    tempMap['MAC_ID'] = edDevice.macId;
                    tempMap['SERIAL_NO'] = edDevice.serialNo;
                    tempMap['EDGE_DEVICE_ID'] = edDevice.edgeDeviceId;
                    mainMap["JSON_ID"] = "09";
                    mainMap["USER_ID"] = Helper.userIDValue;
                    mainMap["DATA"] = tempMap;
                    tempMap["ISACTIVE"] = "0";
                    ref
                        .read(apiProvider)
                        .addEdDevices(mainMap);

                    Future.delayed(
                      const Duration(milliseconds: 100),
                          () {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Deleted Successfully")));

                        Navigator.pop(context);
                       //ref.read(liveDataNotifier);
                        ref.refresh(userDataNotifier(Helper.userIDValue));
                       // ref.read(userDataNotifier(Helper.userIDValue));


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
