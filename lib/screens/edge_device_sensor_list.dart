import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/loginnotifier.dart';
import 'package:generic_iot_sensor/screens/AssetTrackingUnit/ATUinput.dart';
import 'package:generic_iot_sensor/screens/dashboard.dart';
import 'package:generic_iot_sensor/screens/sensor_item_screen.dart';
import 'package:generic_iot_sensor/screens/wLwF.dart';
import '../helper/applicationhelper.dart';
import 'dart:math' as math;
import '../helper/helper.dart';
import '../model/user_devicess/live_data_model.dart';
import '../provider/user_management_provider/live_data_provider.dart';
import '../res/colors.dart';
import 'package:intl/intl.dart';

class EdgeDeviceSensorList extends ConsumerStatefulWidget {
  UserEdDevice? edDevice;


  EdgeDeviceSensorList({Key? key, this.edDevice}) : super(key: key);

  @override
  ConsumerState<EdgeDeviceSensorList> createState() =>
      _EdgeDeviceSensorListState();
}

class _EdgeDeviceSensorListState extends ConsumerState<EdgeDeviceSensorList> {
  List<Livedatum>? livedata = [];
  List<UserEdDevice>? edDev = [];
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 10 );
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String getDate() {
    // ignore: unnecessary_null_comparison
    if (_selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(_selectedDate);
    }
  }

  String getTime(TimeOfDay tod) {

    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }




  @override
  void initState() {
  /*  Timer.periodic(Duration(seconds: 10), (timer) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ref.refresh(userDataNotifier(Helper.userIDValue).future);
        print("Refreshing...");
      });
    });*/
    // connect();
    Helper.classes = "LIVE";
    super.initState();

  }

  @override
  void deactivate() {
    super.deactivate();
  }


  void stopTimer() {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
  }
  itemSensorLiveData(Livedatum livedata, List<UserSensor>? sensors, UserEdDevice? edDevice ) {

    String sensorId = '',sensorImage = '';

    int index = 0;
    for(int i=0; i<sensors!.length; i++){
      if(livedata.sensorId == sensors[i].sensorId!){
        index = i;
        sensorId = sensors[i].sensorId!;
        sensorImage =sensors[i].image!;
      }
    }



    Duration diff = DateTime.now().difference(DateTime.now());

    if(sensors[0].date != "")
    {
      diff = DateTime.parse(sensors[0].date +" "+sensors[0].time).difference(DateTime.now());
    }

    return InkWell(
      onTap: (){

        if(edDevice!.edgeDeviceId == "4" || edDevice.edgeDeviceId == "5"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  wLwF(MacId:edDevice.macId ,)),
          );
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SensorItemScreen(sensor :sensors[index])));
        }




      },
      child: SizedBox(
          child: Card(
            elevation: 20,
            child:
            Padding(
              padding: const EdgeInsets.all(4.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:  edDevice!.edgeDeviceId != "6" ? EdgeInsets.only(left: 85,bottom: 20):EdgeInsets.only(left: 5,bottom: 20),
                          child: Text(livedata.value.toString(),style:  TextStyle(
                              fontSize:  edDevice.edgeDeviceId != "6" ? 15 : 11,
                          )),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 5,bottom: 16),
                          child:
                          Text(sensors[index].units.toString(),style: TextStyle(
                              fontSize: 10,
                              color: Colors.redAccent
                          ),)
                      ),
                    ],
                  ),
                  Row(

                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: SizedBox(
                              width: 50,
                              height: 70,
                              child: Image(
                                  image: NetworkImage(sensorImage.isNotEmpty ? sensorImage:'https://cdn5.vectorstock.com/i/1000x1000/02/09/cmos-ccd-image-sensor-vector-21880209.jpg'))),
                        ),
                      ),





                    ],
                  ),




                ],
              )


            ),
          )),
    );
  }






  @override
  Widget build(BuildContext context) {

    print("Livedata page");
    Duration diff = DateTime.now().difference(DateTime.now());

    if(widget.edDevice!.sensors![0].date != "")
    {
      diff = DateTime.parse(widget.edDevice!.sensors![0].date +" "+widget.edDevice!.sensors![0].time).difference(DateTime.now());
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.cream,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer(builder: (context, ref, child) {
                print(widget.edDevice!.productCode);
                final data = ref.watch(liveDataNotifier);
                print(data);
                data.id.when(
                    data: (data) {
                      livedata!.clear();
                      livedata = data.data!.livedata;
                      print("LIVEDATAEDGEDEVICE ----> $livedata");
                    },
                    error: (error, e) {
                      return Center(
                        child: Text(e.toString()),
                      );
                    },
                    loading: () {
                      return const CircularProgressIndicator();
                    });
                return Column(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                     // ref.refresh(userDataNotifier(Helper.userIDValue));
                                      ref.refresh(liveDataNotifier.notifier);
                                      Navigator.pop(context);

                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_sharp,
                                      color: Colors.black,
                                    )),
                                 Text(
                                  widget.edDevice!.productName.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.04),
                                ),
                                 Expanded(
                                  child: SizedBox(
                                    width: 100,
                                    height: 70,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ATUinputPage(MacId: widget.edDevice!.macId,)));
                                      },
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/images/logo.png")),
                                    ),
                                  ),
                                ),
                              ],
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
                                          'PRODUCT CODE',
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
                                          Text(
                                            widget.edDevice!.productCode!
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xfff808080)),
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
                                            'MAC ID',
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
                                            widget.edDevice!.macId!
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xfff808080)),
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
                                            'SERIAL NO',
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
                                                 widget.edDevice!.productCode!.split('-')[2].split('_')[1].toString()   ,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xfff808080)),
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
                                            'ACCOUNT NO',
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
                                            widget.edDevice!.serialNo!
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xfff808080)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(

                                        children: [
                                          Text("Date & Time ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          Text("${widget.edDevice?.sensors![0].date}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xfff808080)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                     padding: const EdgeInsets.only(top: 5.0),
                                     child: Row(
                                       children: [
                                         Text("${widget.edDevice?.sensors![0].time}",
                                           style: const TextStyle(
                                               fontWeight: FontWeight.normal,
                                               color: Color(0xfff808080)),
                                         ),
                                       ],
                                     ),
                                   ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(

                                        children: [
                                          Text("LIVE DATA STATE ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            children: [

                                              diff.inMinutes > -6 ?
                                              Text("ACTIVE",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    color: Color(0xfff808080)),
                                              ): Text("INACTIVE",
                                                    style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    color: Color(0xfff808080)),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,bottom: 5),
                                              child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration:  BoxDecoration(
                                                      color:
                                                      diff.inMinutes > -6 && widget.edDevice!.sensors![0].date!.isNotEmpty?Colors.green:Colors.red,

                                                      shape: BoxShape.circle),
                                                ),
                                            ),
                                            ],
                                          ),


                                          /* Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Time :",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),


                                      ],
                                    ),*/
                                        ),

                                      ],
                                    )
                                  ],
                                )),
                                 Expanded(
                                  flex: 6,
                                  child:   Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      (){
                                      if(widget.edDevice!.productCode.toString().contains("RT-THAPS")){

                                        return SizedBox(
                                            width: 210,
                                            height: 190,
                                            child: Image(
                                                image: AssetImage('assets/images/Thaps.png')));

                                      }else if(widget.edDevice!.productCode.toString().contains("RT-AMP")){
                                        return SizedBox(
                                            width: 210,
                                            height: 190,
                                            child: Image(
                                                image: AssetImage('assets/images/Amp.png')));
                                      }else{
                                        return SizedBox(
                                            width: 210,
                                            height: 190,
                                            child: Image(
                                                image: AssetImage('assets/images/smart.png')));

                                      }
                                      }()
                ],
                                  ),),
                              ],
                            ),
                          /*  Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0, left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sensors ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.04),
                                    ),
                                   *//* Text(ApplicationHelper().dateFormatter4(livedata![0].date!))*//*

                                  ],
                                ),
                              ),
                            ),*/
                           /* Row(
                              children: [
                                Expanded(child: Text(livedata![0].time!))
                              ],
                            )*/
                          ],
                        )),
                    Expanded(
                      flex: 5,
                      child:GridView.builder(
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          controller: ScrollController(),
                         shrinkWrap: true,
                          itemCount: livedata!.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return itemSensorLiveData(
                                livedata![index], widget.edDevice!.sensors,widget.edDevice!);
                          }),
                    )
                  ],
                );
              }),
            )));
  }
  void startTimer() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 10),
          (_) {
            ref.refresh(liveDataNotifier);
            ref.read(liveDataNotifier.notifier).getLiveData({
              "JSON_ID": "12",
              "USER_ID":Helper.userIDValue,
              "DATA": {
                "MAC_ID": widget.edDevice!.macId!.toUpperCase(),
                "SERIAL_NO": widget.edDevice!.serialNo,
                "EDGE_DEVICE_ID": widget.edDevice!.edgeDeviceId
              }
            });
      },
    );
  }
}
