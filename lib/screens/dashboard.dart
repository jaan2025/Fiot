import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:bloc/bloc.dart';
import 'package:circle_card/circle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:generic_iot_sensor/BLoC/Geolocation/geolocation_bloc.dart';
import 'package:generic_iot_sensor/BLoC/ambientTemp/Bloc_state.dart';
import 'package:generic_iot_sensor/BLoC/channel/ChannelBloc.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import 'package:generic_iot_sensor/provider/edgedevice_provider/addedgedevice_provider.dart';
import 'package:generic_iot_sensor/repository/channelRepository/channel_repository.dart';
import 'package:generic_iot_sensor/res/id.dart';
import 'package:generic_iot_sensor/screens/dashboard_main.dart';
import 'package:generic_iot_sensor/screens/shimmerprojectlist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toggle_switch/toggle_switch.dart';


import '../BLoC/ambientTemp/Bloc_event.dart';
import '../BLoC/ambientTemp/weatherBloc.dart';
import '../BLoC/channel/channelBloc_event.dart';
import '../customPainterClass.dart';
import '../helper/applicationhelper.dart';
import '../helper/helper.dart';

import '../model/threeChannel.dart';
import '../model/user_devicess/live_data_model.dart';
import '../provider/location_management_provider/addlocationprovider.dart';
import '../provider/navigation_provider.dart';
import '../provider/user_management_provider/device_status_provider.dart';
import '../provider/user_management_provider/live_data_provider.dart';
import '../provider/user_management_provider/loginnotifier.dart';

import '../provider/user_management_provider/userprofileprovider.dart';
import '../repository/ambientTemp/location_repository.dart';
import '../repository/geolocation/geolocation_repository.dart';
import '../res/colors.dart';
import '../res/screensize.dart';
import '../services/apiservices.dart';
import '../sqflite/sqDatabase.dart';
import 'about.dart';
import 'edge_device_sensor_list.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'location_list_devices.dart';
import 'package:intl/intl.dart';
import 'package:auto_reload/auto_reload.dart';
//Provider<Dashboard> apiProvider = Provider<Dashboard>((ref) => Dashboard());


final statusToggleButton = StateProvider<bool>((ref) => false);
final nameNotifier = StateProvider<bool>((ref) => false);
final MqttResult = StateProvider<bool>((ref) => false);
List<bool> status = [false,false,false];
List<bool> status1 = [false];
String toastlabel="";
int i=0;

List<ListEdMac> newList=[];
List<ListEdMac> newList1=[];

// edited by silambarasan

class Dashboard extends ConsumerStatefulWidget {



  Map? valueMap;
  Dashboard({Key? key,this.valueMap}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();


}

class _DashboardState extends ConsumerState<Dashboard> {
  var permissionLocation = false,
      permissionStorage = false;
  bool? isActiveLocation = true;
   TextEditingController _locationnamecontroller = TextEditingController();
  TextEditingController _edittextcontroller = TextEditingController();
  String userName = "test",
      emailAddress = "test";
  List<UserEdDevice> edDevice = [];
  List<UserEdDevice> ? edDeviceList = [];
  List<UserLocation> ? loc = [];
  UserDeviceList ? DEVlIST;
  List<String> ? MqttTopicList = [];
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 20);
  bool ChangedToggle = false;

bool isShow = true;
bool isEye = true;
bool positive = true;
  final isSelected = <bool>[false, false];

int value = 0;

  @override
  void initState() {

    print("user" + Helper.userIDValue);

    initializeMQTTClient();

    DBase().initializedDB();

      Helper.classes = "Dashboard";

    if(Helper.classes == "Dashboard")
    {
      Timer.periodic(const Duration(seconds: 10), (timer) {
        WidgetsBinding.instance.addPostFrameCallback((timer) async {
          ref
              .read(statusToggleButton
              .notifier)
              .state =
          !ref.watch(
              statusToggleButton);
          print("Refreshing...");
        });
      });
    }

    super.initState();


  }

  @override
  void deactivate() {
    super.deactivate();
  }

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  var currentDate = "";
  bool THAP = false;
  bool SINGLETHREE = false;
  List<String> numbers = ["1","2","3"];


  //select for date
  Future<DateTime> selectDate(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030));
    if (selected != null && selected != _selectedDate) {
      if (this.mounted) {
        setState(() {
          currentDate = selected as String;
        });
      }
    }
    return _selectedDate;
  }

  //select for time
  Future<TimeOfDay> selectTime(BuildContext context) async {
    final selected =
    await showTimePicker(context: context, initialTime: _selectedTime);
    if (selected != null && selected != _selectedTime) {
      if (this.mounted) {
        setState(() {
          _selectedTime = selected;
        });
      }
    }
    return _selectedTime;
  }

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

  List<dynamic> splitData = ["0", "0", "0"];
  List<dynamic> SingleData = ["0",];
  String selectedDevice = "9";

  Map<String, dynamic> tempMap = {};
  Map<String, dynamic> mainMap = {};

  var Name;
  var MobileNo;


  String? edgeDeviceName = '',
      mac = '',
      edgeId = '',
      productCode = '',
      serialNo = '',
      locationId = '';
  List<Livedatum>? livedata = [];

  String statusText = "";
  bool isConnected = false;

  final _client = MqttServerClient(
      "a1i25lg7rvcymv-ats.iot.us-east-1.amazonaws.com", "");
  TextEditingController uniqueIdController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var Mqtt = "";
  int onceMqtt = 0;


  @override
  Widget build(BuildContext context) {


    print("westblue");
   // ref.refresh(userDataNotifier(Helper.userIDValue));
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GeoLocationRepository>(
            create: (_) => GeoLocationRepository(),
          ),
          RepositoryProvider<LocationRep>(
            create: (context) => LocationRep(),
          ),
          RepositoryProvider<ChannelRepo>(create: (context) => ChannelRepo())
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<GeolocatioBloc>(
                create: (BuildContext context) =>
                GeolocatioBloc(
                    geoLocationRepository:
                    context.read<GeoLocationRepository>())
                  ..add(LoadGeolocation()),
              ),
              BlocProvider<weatherBloc>(
                  create: (BuildContext context) =>
                  weatherBloc(locationRep: context.read<LocationRep>())
                    ..add(LoadTemp())),
              BlocProvider<ChannelBloc>(
                  create: (BuildContext context) =>
                  ChannelBloc(channelRepo: context.read<ChannelRepo>())
                    ..add(LoadChannel()))
            ],
            child: SafeArea(
                child: Scaffold(
                  drawer:  SizedBox(
                    width: 200,
                    child: Drawer(
                      child: ListView(
                        // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: [
                           SizedBox(
                             height: 100,
                             child: DrawerHeader(
                              decoration: const BoxDecoration(
                                color: Color(0xfffE2F3FD)
                              ),
                              child: Column(
                                children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                      child: Text(Name.toString().substring(0,1).toUpperCase()),
                                    ),
                                    Text("${Name.toString().toUpperCase()}\n${"+"+MobileNo.toString()}")
                                  ],
                                ),
                                ],
                              )
                          ),
                           ),
                          ListTile(
                            trailing: const Icon(Icons.home),
                            title: const Text('HOME',style: TextStyle(
                              fontSize: 12
                            ),),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  DashBoardScreen()));
                            },
                          ),
                          ListTile(
                            trailing: const Icon(Icons.device_hub),
                            title: const Text('EML CONFIG',style: TextStyle(
                                fontSize: 12
                            ),),
                            onTap: () {
                              // Update the state of the app.
                              // ...
                            },
                          ),
                          ListTile(
                            trailing: const Icon(Icons.notifications_active),
                            title: const Text('NOTIFICATIONS',style: TextStyle(
                                fontSize: 12
                            ),),
                            onTap: () {
                              // Update the state of the app.
                              // ...
                            },
                          ),
                          ListTile(
                            trailing: const Icon(Icons.event),
                            title: const Text('EVENTS',style: TextStyle(
                                fontSize: 12
                            ),),
                            onTap: () {
                              // Update the state of the app.
                              // ...
                            },
                          ),
                          ListTile(
                            trailing: Icon(Icons.details),
                            title: const Text('ABOUT',style: TextStyle(
                                fontSize: 12
                            ),),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  AboutApp()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                    key: _scaffoldKey,
                    resizeToAvoidBottomInset: false,
                    backgroundColor: AppColors.white,
                    body: ref.watch(userDataNotifier(Helper.userIDValue)).when(
                        data: (data) {
                          if(data.data == null){
                            return null;
                              /*Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator()
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text("No data found"),


                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [

                                        Text("Please check your network"),

                                      ],
                                    )
                                  ],
                                ),
                              );*/
                          }


                          print("User====>${Helper.userIDValue}");

                          print("DATA==============> ${data.data}");

                          Name = data.data!.userName;
                          MobileNo = data.data!.mobileNo;



                          // connect();
                          print(
                              "IN DASHBOARD ====== >${Helper.location.length}");
                          if(onceMqtt == 0){
                            MqttTopics(data.data!.units!);
                            onceMqtt++;
                          }


                          print(
                              "UNITS =========== ${data.data!.units?.length}");
                          var unitsdata = data.data!.units!;
                          print("unitsdata =========== ${unitsdata.length}");
                          Helper.listOfMac.clear();
                          Helper.location.clear();
                          // Helper.mUnit.clear();
                          edDevice.clear();
                          edDeviceList!.clear();

                          if (data.data != null) {

                            //  DBase().insertPlanets(data.data!);
                            Helper.profileUserName = data.data!.userName!;
                            Helper.profileMobileNo = data.data!.mobileNo!;
                            Helper.profilePassword = data.data!.password!;
                            Helper.profileEmail = data.data!.emailId!;
                            Helper.isActive =
                            data.data!.isactive! == '1' ? true : false;

                            for (var loc in data.data!.locations!) {
                              Helper.location
                                  .add(
                                  '${loc.locationId!}-${loc.locationName}');
                            }
                            for (var mac in data.data!.units!) {
                              for (var ed in mac.edDevice!) {
                                edDevice.add(ed);
                              }
                              Helper.listOfMac.add(mac.macId!);
                            }
                            Helper.mUnit = data.data!.units!;

                          }

                         if(Helper.classes == "Dashboard")
                           {
                             ref.refresh(userDataNotifier(Helper.userIDValue));
                           }
                          return data.data == null ? const Center(
                              child: CircularProgressIndicator()
                          ):SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Hello,${data.data!.userName!.toUpperCase()} !',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.05),
                                      ),
                                      /*  Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: SizedBox(
                                          width: 150,
                                          height: 80,
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/images/logo.png")),
                                        ),
                                      ),*/
                                      InkWell(
                                        onTap: () {
                                          locationPopUp();
                                        },
                                        child: const SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image(
                                                image: AssetImage(
                                                    'assets/images/location.gif'))),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      children: [
                                        Consumer(
                                            builder: (context, ref, child) {
                                              return Expanded(
                                                child: SizedBox(
                                                  height:150,

                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            50.0)),
                                                    elevation: 10.0,
                                                    child: Container(
                                                      width: 300.0,
                                                      height: 400.0,
                                                      child: Stack(
                                                        alignment:
                                                        Alignment.bottomCenter,
                                                        children: [
                                                          // This will hold the Image in the back ground:
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    50.0),
                                                                color:
                                                                const Color(
                                                                    0xfffE2F3FD)),
                                                          ),
                                                          Positioned(
                                                              width: 100,
                                                              height: 100,
                                                              bottom: 30,
                                                              right: 20,
                                                              child: Image(

                                                                  image: getTime(
                                                                      _selectedTime)
                                                                      .contains(
                                                                      "AM")
                                                                      ? const AssetImage(
                                                                      "assets/images/robot.png")
                                                                      : const AssetImage(
                                                                      "assets/images/could.png"))),
                                                          // This is the Custom Shape Container


                                                          const Positioned(
                                                              bottom: 100,
                                                              left: 40,
                                                              child: Icon(
                                                                  Icons
                                                                      .location_on)),
                                                          // This Holds the Widgets Inside the the custom Container;
                                                          Positioned(
                                                              bottom: 100,
                                                              left: 70,
                                                              child: BlocBuilder<
                                                                  GeolocatioBloc,
                                                                  GeolocationState>(
                                                                  builder:
                                                                      (context,
                                                                      state) {
                                                                    if (state
                                                                    is GeolocationLoading) {
                                                                      return const Text(
                                                                          "Please wait.....");
                                                                    } else
                                                                    if (state
                                                                    is GeolocationLoaded) {
                                                                      print(
                                                                          state
                                                                              .address
                                                                              .subLocality
                                                                              .toString());
                                                                      return Text(
                                                                        state
                                                                            .address
                                                                            .subLocality
                                                                            .toString(),
                                                                        style:
                                                                        const TextStyle(
                                                                            fontSize:
                                                                            12),
                                                                      );
                                                                    } else {
                                                                      print(
                                                                          "stupid");
                                                                    }
                                                                    return CircularProgressIndicator();
                                                                  })),

                                                          Positioned(
                                                              bottom: 10,
                                                              left: 50,
                                                              child: BlocBuilder<
                                                                  weatherBloc,
                                                                  blocState>(
                                                                  builder:
                                                                      (context,
                                                                      state) {
                                                                    if (state
                                                                    is weatherLoading) {
                                                                      return SizedBox(
                                                                        width:100,
                                                                        height:50,
                                                                        child: Image.asset("assets/images/thermometer-unscreen.gif"),
                                                                      );
                                                                    } else
                                                                    if (state
                                                                    is weatherLoaded) {
                                                                      return Text(
                                                                        state
                                                                            .myLocationModel
                                                                            .currently!.temperature != null

                                                                            ? " ${state
                                                                            .myLocationModel
                                                                            .currently!.temperature!
                                                                            .round().toString()}"
                                                                            : "NO DATA",
                                                                        style: const TextStyle(
                                                                            fontSize: 50,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                      );
                                                                    }
                                                                    return const CircularProgressIndicator();
                                                                  })),
                                                          const Positioned(
                                                              bottom: 50,
                                                              left: 130,
                                                              child: Text(
                                                                  "\u{00B0}C")),

                                                          /*   Positioned(
                                                              bottom: 20,
                                                              right: 30,
                                                              child: Text(
                                                                  getDate())),
                                                          const Positioned(
                                                              bottom: 50,
                                                              right: 60,
                                                              child: Icon(

                                                                Icons
                                                                    .calendar_month,
                                                                size: 15,)),
                                                          const Positioned(
                                                              bottom: 50,
                                                              left: 60,
                                                              child: Icon(Icons
                                                                  .access_time_outlined,
                                                                size: 15,)),
                                                          Positioned(
                                                              bottom: 20,
                                                              left: 50,
                                                              child: Text(
                                                                  getTime(
                                                                      _selectedTime))),*/
                                                          /*       Positioned(
                                                              child: BlocBuilder<ChannelBloc,channelState>(builder: (context,state){
                                                            if(state is channelLoading){
                                                              print("object");
                                                            }else if(state is channelLoaded){
                                                              print(state.channel.toString());
                                                            }
                                                            return CircularProgressIndicator();
                                                          }))

*/
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                               /* Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("DEVICES",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      height: 110,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: edDevice.length ,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return itemBuildEdgeDevice(index,edDevice[index]);
                                        },
                                      ),
                                    ),
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: ScrollPhysics(),
                                      itemCount: data.data!.locations!
                                          .isNotEmpty
                                          ? data.data!.locations!.length
                                          : 0,
                                      itemBuilder: (context, index) {
                                        print("Location Index -----${data.data!
                                            .locations![index].locationId}");
                                        print("uNITS LENGTH -----${unitsdata
                                            .length}");

                                        return itemBuilderLocation(
                                            index,
                                            data.data!.locations![index],
                                            data.data!.units!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, error: (error, e) {
                      return Center(
                        child: Text(e.toString()),
                      );
                    }, loading: () {
                      return  ShimmerForProjectList();/*SplashScreen(
                        seconds: 6,
                        navigateAfterSeconds: AppId.DashboardID,
                        image: new Image.asset("assets/images/logo.png"),
                        loadingText: Text("Loading"),
                        photoSize: 100.0,
                        loaderColor: Colors.blue,
                      );*/
                    })))));
  }

  MqttTopics(List<UserUnit> list) {
    for (var unit in list) {
      for (var ed in unit.edDevice!) {
        if (ed.edgeDeviceId == "9" || ed.edgeDeviceId == "10") {
          MqttTopicList!.add(ed.macId.toString());
          print(ed.macId.toString());
        }
      }
    }
    disconnect();
    connect(MqttTopicList!);
  }

  itemBuilderEdgeDevice(int index, UserEdDevice edDevice,) {
    TextEditingController _labelController = TextEditingController(
        text: edDevice.name.toString());
    selectedDevice = edDevice.edgeDeviceId!;

    // if(edDevice.edgeDeviceId == "10" || edDevice.edgeDeviceId == "9"){

    ListEdMac ss = new ListEdMac();
    ss.edMac = edDevice.macId!.toUpperCase();
    ss.channel1 = false;
    ss.channel2 = false;
    ss.channel3 = false;
    ss.Name = edDevice.name;
    newList.add(ss);

    var Listed1 = newList.indexWhere((ListEdMac) =>
    ListEdMac.edMac == edDevice.macId.toString());


    Duration diff = DateTime.now().difference(DateTime.now());

    if (edDevice.sensors![0].date != "") {
      diff = DateTime.parse(
          edDevice.sensors![0].date + " " + edDevice.sensors![0].time)
          .difference(DateTime.now());
    }


    return Visibility(
        visible: edDevice.isactive != null && isShow == true ? true : false,
        child: InkWell(
          onTap: () {
            var Listed1 = newList.indexWhere((ListEdMac) =>
            ListEdMac.edMac == edDevice.macId.toString());
            ref.refresh(liveDataNotifier.notifier);


            ref.read(liveDataNotifier.notifier).getLiveData({
              "JSON_ID": "12",
              "USER_ID": Helper.userIDValue,
              "DATA": {
                "MAC_ID": edDevice.macId!.toUpperCase(),
                "SERIAL_NO": edDevice.serialNo,
                "EDGE_DEVICE_ID": edDevice.edgeDeviceId
              }
            });


            if (edDevice.edgeDeviceId != "9" && edDevice.edgeDeviceId != "10" && edDevice.edgeDeviceId != "11") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EdgeDeviceSensorList(edDevice: edDevice)),
              );
            }
          },
          child: Column(
            children: [
              SizedBox(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 25,
                  child: Column(

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color:  diff.inMinutes > -6 && edDevice.sensors![0].date!.isNotEmpty
                                    ? Colors.green
                                        : Colors.red,

                                  shape: BoxShape.circle),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Text("Date : ${edDevice.sensors![0].date
                                .toString()} ", style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(" , ${edDevice.sensors![0].time
                                .toString()}", style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold

                            ),),
                          )
                        ],),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              edDevice.sensorUnit.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          Text(newList[Listed1].Name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(onPressed: () {
                                setEditPopup(edDevice);
                              }, icon: Icon(Icons.edit, color: AppColors.secondary,
                                size: ScreenSize.screenWidth * 0.05,)
                              ),

                            ],
                          )

                        ],
                      ),

                      const SizedBox(
                        child: Divider(
                          color: Colors.black,
                          indent: 10,
                          endIndent: 10,
                        ),
                      ),

                     edDevice.edgeDeviceId == "10" || edDevice.edgeDeviceId == "7" ?  Padding(
                       padding: edDevice.edgeDeviceId == "10" ?  const EdgeInsets.only(left: 35,top: 5):  const EdgeInsets.only(right: 15),
                       child:  GridView.builder(
                         physics: ScrollPhysics(),

                         shrinkWrap: true,
                         itemCount: 3,
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), itemBuilder:(context, index) {
                         print(index.toString());
                         return Column(
                           children: [
                             Visibility(
                               visible: edDevice.sensors![index].parameters! ==
                                   'Motion Detection' ||
                                   edDevice.sensors![index].parameters! ==
                                       'Light Status'
                                   ? false
                                   : true,
                               child: Column(
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment
                                         .spaceAround,
                                     children: [
                                      /* Expanded(
                                           flex: 6,
                                           child: Padding(
                                             padding: const EdgeInsets.only(
                                                 left: 10.0),
                                             child: Text(
                                               "${edDevice.sensors![index]
                                                   .parameters}   : ",
                                               textAlign: TextAlign.left,
                                               style: const TextStyle(
                                                   fontWeight: FontWeight.bold),
                                             ),
                                           )),*/
                                      /* edDevice.edgeDeviceId == "9"
                                           ? getDataForDevices(edDevice, index)
                                           : edDevice.edgeDeviceId == "10"
                                           ? getDataForDevices(edDevice, index)
                                           : Padding(
                                         padding: const EdgeInsets.only(
                                             right: 10.0),
                                         child: edDevice.edgeDeviceId == "7" ? Row(
                                           children: [
                                             Text(
                                               edDevice.sensors![index].liveData
                                                   .toString(),
                                               textAlign: TextAlign.right,
                                             ),
                                           ],
                                         ):Text(
                                           edDevice.sensors![index].liveData
                                               .toString(),
                                           textAlign: TextAlign.right,
                                         ),
                                       ),*/
                                       Expanded(
                                           flex: 2,
                                           child: Padding(
                                             padding: const EdgeInsets.only(
                                                 left: 10.0),
                                             child: edDevice.edgeDeviceId == "7" ? SizedBox(
                                               width: 15,
                                               height: 47,
                                               child: Image.network(edDevice.sensors![index].image!),
                                             ):Text(
                                               edDevice.sensors![index].units
                                                   .toString(),
                                               textAlign: TextAlign.left,
                                               style: const TextStyle(
                                                   color: Colors.redAccent),
                                             ),
                                           )),

                                     ],
                                   ),
                                  edDevice.edgeDeviceId == "7" ? Padding(
                                     padding: const EdgeInsets.only(left: 10),
                                     child: Text(
                                       edDevice.sensors![index].liveData
                                           .toString(),
                                       textAlign: TextAlign.right,
                                     ),
                                   ):getDataForDevices(edDevice, index),
                                  edDevice.edgeDeviceId == "10" ? Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: [
                                         Text(numbers[index],style: TextStyle(fontSize: 12),)
                                       ],),
                                    ),
                                  ):Text("")
                                 ],
                               ),
                             )
                           ],
                         );
                       }, )
                     ) : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: edDevice.sensors!.length,
                          itemBuilder: (context, index) {
                            print(index.toString());
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:  Column(
                                children: [
                                  Visibility(
                                    visible: edDevice.sensors![index].parameters! ==
                                        'Motion Detection' ||
                                        edDevice.sensors![index].parameters! ==
                                            'Light Status'
                                        ? false
                                        : true,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                "${edDevice.sensors![index]
                                                    .parameters}   : ",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )),
                                        edDevice.edgeDeviceId == "9"
                                            ? getDataForDevices(edDevice, index)
                                            : edDevice.edgeDeviceId == "10"
                                            ? getDataForDevices(edDevice, index)
                                            : Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Text(
                                            edDevice.sensors![index].liveData
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.right,

                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: edDevice.edgeDeviceId == "7" ? SizedBox(
                                                child: Image.network(edDevice.sensors![index].image!),
                                              ):Text(
                                                edDevice.sensors![index].units
                                                    .toString(),
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: Colors.redAccent),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*  Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Text(
              edDevice.sensorUnit.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),*/
            ],
          ),
        ));
  }

  getDataForDevices(UserEdDevice edDevice, int index) {


    return Consumer(builder: (context, ref, child) {
      var Listed = newList.firstWhere((ListEdMac) =>
      ListEdMac.edMac == edDevice.macId.toString());
      //print("FILTER ========== ${Listed.edMac}");

      var Listed11 = newList.indexWhere((ListEdMac) =>
      ListEdMac.edMac == edDevice.macId.toString());

      ref
          .watch(deviceStatusNotifier)
          .id
          .when(
          data: (data) {
            if (data.sTATUS!.isNotEmpty) {
              try {
                if (data.sTATUS == "STATUS FAILED") {} else
                if (edDevice.edgeDeviceId == "10") {
                  splitData = data.sTATUS!.split(',');
                } else {
                  SingleData = data.sTATUS!.split(',');
                }
              } catch (e) {
                print(e);
              }
              Future.delayed(Duration(milliseconds: 200), () {
                ApplicationHelper.dismissProgressDialog();
              });
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (toastlabel != "" || data.sTATUS == "") {
                toastlabel = "";
              }
              else {
                toastlabel = data.sTATUS.toString();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(toastlabel)));
                data.sTATUS = "";
              }
            });
          },
          error: (e, s) {},
          loading: () {});
      return Padding(
        padding: edDevice.edgeDeviceId == "10" ? const EdgeInsets.only(right: 28): EdgeInsets.only(left: 0,),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 10, color:
            ((edDevice.edgeDeviceId.toString() == "10") ? (index == 0
                ? (newList[Listed11].channel1 == true ? Colors.green : Colors
                .red)
                : (index == 1 ? (newList[Listed11].channel2 == true ? Colors
                .green : Colors.red) : (newList[Listed11].channel3 == true
                ? Colors.green
                : Colors.red))) : (newList[Listed11].channel1 == true ? Colors
                .green : Colors.red)), spreadRadius: 5)
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.power_settings_new),
                // color: (edDevice.edgeDeviceId.toString()=="10")? (status[index] ==
                //     true ?  Colors.red: Colors.green):(status1[index] ==
                //     true ?  Colors.red: Colors.green),
                color: (edDevice.edgeDeviceId.toString() == "10"  ) ? (index == 0
                    ? (newList[Listed11].channel1 == true ? Colors.red : Colors
                    .green)
                    : (index == 1 ? (newList[Listed11].channel2 == true ? Colors
                    .red : Colors.green) : (newList[Listed11].channel3 == true
                    ? Colors.red
                    : Colors.green))) : (newList[Listed11].channel1 == true
                    ? Colors.red
                    : Colors.green),
                onPressed: () {
                  //ApplicationHelper.showProgressDialog(context);
                  bool sensorstatus = false;

                  String message;

                  if (edDevice.edgeDeviceId.toString() == "10") {
                    // if(status[index] == false){
                    //   status[index] = true;
                    // }else{
                    //   status[index] = false;
                    // }

                    var Listed1 = newList.indexWhere((ListEdMac) =>
                    ListEdMac.edMac == edDevice.macId.toString());

                    if (index == 0) {
                      if (newList[Listed1].channel1 == false) {
                        newList[Listed1].channel1 = true;
                        sensorstatus = true;
                        message = "RRCSP#2#1#1#RCEP";
                        publish(message, edDevice.macId.toString());
                      } else {
                        newList[Listed1].channel1 = false;
                        sensorstatus = false;
                        message = "RRCSP#2#1#0#RCEP";
                        publish(message, edDevice.macId.toString());
                      }
                    }
                    else if (index == 1) {
                      if (newList[Listed1].channel2 == false) {
                        newList[Listed1].channel2 = true;
                        sensorstatus = true;
                        message = "RRCSP#2#2#1#RCEP";
                        publish(message, edDevice.macId.toString());
                      } else {
                        newList[Listed1].channel2 = false;
                        sensorstatus = false;
                        message = "RRCSP#2#2#0#RCEP";
                        publish(message, edDevice.macId.toString());
                      }
                    }
                    else {
                      if (newList[Listed1].channel3 == false) {
                        newList[Listed1].channel3 = true;
                        sensorstatus = true;
                        message = "RRCSP#2#3#1#RCEP";
                        publish(message, edDevice.macId.toString());
                      } else {
                        newList[Listed1].channel3 = false;
                        sensorstatus = false;
                        message = "RRCSP#2#3#0#RCEP";
                        publish(message, edDevice.macId.toString());
                      }
                    }
                    ref
                        .read(statusToggleButton
                        .notifier)
                         .state =
                    !ref.watch(
                        statusToggleButton);


                    // ref
                    //     .read(MqttResult
                    //     .notifier)
                    //     .state =
                    // !ref.watch(
                    //     MqttResult);

                    /* if(ss!=""){
                      print(Mqtt);
                      ApplicationHelper.dismissProgressDialog();
                      Mqtt = "";
                    }
*/

                    /* ref.read(deviceStatusNotifier.notifier).getStatus({
                      "JSON_ID": "12",
                      "USER_ID": "4",
                      "DATA": {
                        "MAC_ID": edDevice.macId.toString(),
                        "SERIAL_NO": "33333",
                        "EDGE_DEVICE_ID": edDevice.edgeDeviceId,
                        "SENSOR_ID": (index + 1).toString(),
                        "STATUS": sensorstatus == true ? 1 : 0,
                      }
                    });*/
                    print(edDevice.macId);
                    print(sensorstatus);
                    //  print("LISTED1 --------- $Listed1");

                  }
                  if (edDevice.edgeDeviceId.toString() == "9") {
                    var Listed1 = newList.indexWhere((ListEdMac) =>
                    ListEdMac.edMac == edDevice.macId.toString());
                    print("LISTED1 =========> $Listed1");
                    if (index == 0) {
                      if (newList[Listed11].channel1 == false) {
                        newList[Listed11].channel1 = true;
                        sensorstatus = true;
                        message = "RCSP#2#1#RCEP";
                        publish(message, edDevice.macId.toString());
                      } else  {
                        newList[Listed11].channel1 = false;
                        sensorstatus = false;
                        message = "RCSP#2#0#RCEP";
                        publish(message, edDevice.macId.toString());
                      }
                    }


                    ref
                        .read(statusToggleButton
                        .notifier)
                        .state =
                    !ref.watch(
                        statusToggleButton);

                    /*   ref.read(deviceStatusNotifier.notifier).getStatus({
                      "JSON_ID": "12",
                      "USER_ID": "4",
                      "DATA": {
                        "MAC_ID": edDevice.macId.toString(),
                        "SERIAL_NO": "33333",
                        "EDGE_DEVICE_ID": edDevice.edgeDeviceId,
                        "SENSOR_ID": (index + 1).toString(),
                        "STATUS": sensorstatus == true ? 1 : 0,
                      }
                    });*/
                    print(edDevice.macId);
                    print("verify =======> ${newList[Listed1].channel1}");
                    print("sensor status ----->$sensorstatus");


                    /*  print(status[index]);
                print(edDevice.edgeDeviceId.toString() + "-" + index.toString());*/
                  }
                }

            ),
          ),
        ),
      );

      /*   return Consumer(
         builder: (context, ref, child) {

           return Stack(
             children: [
               FractionalTranslation(
                 translation: Offset(0.0, 0.0),
                 child:  GestureDetector(
                   onTap: (){

                   },
                   child: Container(
                     decoration:  BoxDecoration(
                       border:  Border.all(
                         color: AppColors.red,
                         width: 5.0, // it's my slider variable, to change the size of the circle
                       ),
                       shape: BoxShape.circle,
                     ),
                       child: GestureDetector(
                         onTap: (){


                         },
                         child: Container(
                           decoration: new BoxDecoration(
                             border: new Border.all(
                               color: Colors.white,
                               width: 4.0, // it's my slider variable, to change the size of the circle
                             ),
                             shape: BoxShape.circle,
                           ),
                           child: Text(
                               "ON"),
                         ),
                       )

                   ),
                 ),
               )

             ],
           );
         }
       );*/

      /* return Expanded(
          flex: 5,
          child: ToggleSwitch(
            minWidth: 53.3,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.red[800]!],
              [Colors.green[800]!]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex: selectedDevice == "9"
                ? int.parse(SingleData[index])
                : int.parse(splitData[index]),
            totalSwitches: 2,
            labels: const ['OFF', 'ON'],
            radiusStyle: true,
            onToggle: (ind) {
              if(ind == 1){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Your device is ON")));

              }else if(ind == 0){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Your device is OFF")));
              }
              print("IND ========== $ind");
              selectedDevice = edDevice.edgeDeviceId!;

              ApplicationHelper.showProgressDialog(context);
              ref.read(deviceStatusNotifier.notifier).getStatus({
                "JSON_ID": "12",
                "USER_ID": "4",
                "DATA": {
                  "MAC_ID": edDevice.macId.toString(),
                  "SERIAL_NO": "33333",
                  "EDGE_DEVICE_ID": edDevice.edgeDeviceId,
                  "SENSOR_ID": index.toString(),
                  "STATUS": ind.toString()
                }
              });
            },
          ));*/
    });
  }

  itemBuilderLocation(int index, UserLocation location, List<UserUnit> list) {
    print("locID ========== ${location.locationId}");
    print("list ========== ${list.length}");
    for (var unit in list) {
      for (var ed in unit.edDevice!) {
        if (ed.locationId == location.locationId) {

          edDeviceList!.add(ed);

        } else {
          // edDeviceList!.remove(ed);
        }
      }
    }

    return Visibility(
        visible: location.isactive != null ? true : false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LocationListDevices(location: location, list: list)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(location.locationName.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold)),

                          SizedBox(
                              width: 30,
                              height: 30,
                              child: Image(
                                  image: AssetImage(location.locationName
                                      .toString()
                                      .contains('office')
                                      ? "assets/images/office-building.png"
                                      : "assets/images/house.png"))),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                //itemCount: edDeviceList.where(x=>)?.length ?? 0,
                                itemCount: edDeviceList
                                    ?.where((x) =>
                                x.locationId == location.locationId.toString())
                                    .toList()
                                    .length ?? 0,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  print("INDEX  -  $index" + "--" +
                                      edDeviceList!.where((x) => x.locationId ==
                                          location.locationId.toString())
                                          .toList()[index].edgeDeviceId.toString());
                                  return    itemBuilderEdgeDevice(
                                      index,
                                      edDeviceList!.where((x) => x.locationId ==
                                          location.locationId.toString())
                                          .toList()[index]);
                                }),
                          )),
/*
                Visibility(
                    visible: edDevice.sensors![index].parameters! == 'Motion Detection' ? false :true,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Card(
                                        elevation: 25,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20),
                                                    child: Text("SWITCHES",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 20),
                                                    child: Text("STATUS",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(child:Divider(
                                              color: Colors.black,
                                              indent: 10,
                                              endIndent: 10,
                                            ) ,),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ListView.builder(
                                                physics: ScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: 1,
                                                //edDevice.sensors!.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                                flex: 8,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(left: 20),
                                                                  child: Text(" Switch  : ",
                                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                                  ),
                                                                )),
                                                            ToggleSwitch(
                                                              minWidth: 50.0,
                                                              cornerRadius: 20.0,
                                                              activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                                                              activeFgColor: Colors.white,
                                                              inactiveBgColor: Colors.grey,
                                                              inactiveFgColor: Colors.white,
                                                              initialLabelIndex: 1,
                                                              totalSwitches: 2,
                                                              labels: const ['ON', 'OFF'],
                                                              radiusStyle: true,
                                                              onToggle: (index) {
                                                                print('switched to: $index');
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10.0,bottom: 10),
                                      child: Text(
                                        "Single Channel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child:  Column(
                                  children: [
                                    SizedBox(
                                      child: Card(
                                        elevation: 25,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 20),
                                                    child: Text("SWITCHES",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 20),
                                                    child: Text("STATUS",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(child:Divider(
                                              color: Colors.black,
                                              indent: 10,
                                              endIndent: 10,
                                            ) ,),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      const Expanded(
                                                          flex: 8,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: 20),
                                                            child: Text(" Switch 1 : ",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          )),
                                                      ToggleSwitch(
                                                        minWidth: 50.0,
                                                        cornerRadius: 20.0,
                                                        activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                                                        activeFgColor: Colors.white,
                                                        inactiveBgColor: Colors.grey,
                                                        inactiveFgColor: Colors.white,
                                                        initialLabelIndex: 1,
                                                        totalSwitches: 2,
                                                        labels: const ['ON', 'OFF'],
                                                        radiusStyle: true,
                                                        onToggle: (index) {
                                                          print('switched to: $index');
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                          flex: 8,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: 20),
                                                            child: Text(" Switch 2 : ",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          )),
                                                      ToggleSwitch(
                                                        minWidth: 50.0,
                                                        cornerRadius: 20.0,
                                                        activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                                                        activeFgColor: Colors.white,
                                                        inactiveBgColor: Colors.grey,
                                                        inactiveFgColor: Colors.white,
                                                        initialLabelIndex: 1,
                                                        totalSwitches: 2,
                                                        labels: const ['ON', 'OFF'],
                                                        radiusStyle: true,
                                                        onToggle: (index) {
                                                          print('switched to: $index');
                                                        },
                                                      ),

                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Expanded(
                                                          flex: 8,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: 20),
                                                            child: Text(" Switch 3 : ",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          )),
                                                      ToggleSwitch(
                                                        minWidth: 50.0,
                                                        cornerRadius: 20.0,
                                                        activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                                                        activeFgColor: Colors.white,
                                                        inactiveBgColor: Colors.grey,
                                                        inactiveFgColor: Colors.white,
                                                        initialLabelIndex: 1,
                                                        totalSwitches: 2,
                                                        labels: const ['ON', 'OFF'],
                                                        radiusStyle: true,
                                                        onToggle: (index) {
                                                          print('switched to: $index');
                                                        },
                                                      ),

                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10.0,bottom: 10),
                                      child: Text(
                                        "Three Channel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                            )),
                      ],
                    ),
                  ),*/
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }



  locationPopUp() {
    return showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            insetPadding: const EdgeInsets.only(left: 12.0, right: 12.0),
            titlePadding: const EdgeInsets.all(20.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Location"),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            content: Builder(builder: (context) {
              return SizedBox(
                width: ScreenSize.screenWidth * 400,
                //height:  ScreenSize.screenHeight * 1,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: _locationnamecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    //labelText: 'Number',
                    hintText: 'Enter your Location',
                  ),
                ),
              );
            }),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Checkbox(
                              value: isActiveLocation,
                              onChanged: (value) {
                                setState(() {
                                  isActiveLocation = value;
                                });
                              });
                        },
                      ),
                      const Text(
                        'isActive',
                        style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (_locationnamecontroller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Location Name should not be empty')));
                      } else {
                        addLocation();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: const Text("OK"),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Future<void> addLocation() async {
    Map<dynamic, dynamic> mainMap = {};
    Map<dynamic, String> tempMap = {};
    tempMap['LOCATION_NAME'] = _locationnamecontroller.text;
    tempMap['LOCATION_SUBNAME'] = '';
    mainMap['JSON_ID'] = '07';
    mainMap['USER_ID'] = Helper.userIDValue.toString();
    mainMap['DATA'] = tempMap;
    ref.read(addLocationNotifier.notifier).addLocation(mainMap);
    Future.delayed(const Duration(seconds: 1), () {
      ApplicationHelper.dismissProgressDialog();
      var state = ref.watch(addLocationNotifier);
      state.id.when(data: (data) {
        try {
          var response = json.decode(data);
          Future.delayed(
            const Duration(milliseconds: 200),
                () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response['DATA']['MSG'])));

              if (response['DATA']['MSG'] != "Location Already Exsist") {
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.refresh(userDataNotifier(Helper.userIDValue));
                });
              } else {
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.refresh(userDataNotifier(Helper.userIDValue));
                });
              }
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
  }

  setEditPopup(UserEdDevice edDevice) {
    var Listed1 = newList.indexWhere((ListEdMac) =>
    ListEdMac.edMac == edDevice.macId.toString());
    print(edDevice.macId);
    print(newList.length);
    print(Listed1);
    //newList[Listed1].Name= edDevice.name;
    TextEditingController _labelController = TextEditingController(
        text: newList[Listed1].Name);
    return showDialog(
      context: context,
      builder: (txt) =>
          AlertDialog(
            insetPadding: const EdgeInsets.only(left: 12.0, right: 12.0),
            titlePadding: const EdgeInsets.all(20.0),

            content: Builder(builder: (context) {
              return SizedBox(
                width: ScreenSize.screenWidth * 400,
                //height:  ScreenSize.screenHeight * 1,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: _labelController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    //labelText: 'Number',
                    hintText: 'Enter your Text',
                  ),
                ),
              );
            }),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: const Text("Cancel"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_labelController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Textfield should not be empty')));
                      } else {
                        var Listed1 = newList.indexWhere((ListEdMac) =>
                        ListEdMac.edMac == edDevice.macId.toString());
                        newList[Listed1].Name = _labelController.text;
                        tempMap['LOCATION_ID'] = edDevice.locationId;
                        tempMap['PRODUCT_CODE'] = edDevice.productCode;
                        tempMap['NAME'] = _labelController.text;
                        tempMap['MAC_ID'] = edDevice.macId;
                        tempMap['SERIAL_NO'] = edDevice.serialNo;
                        tempMap['EDGE_DEVICE_ID'] = edDevice.edgeDeviceId;
                        mainMap["JSON_ID"] = "09";
                        mainMap["USER_ID"] = Helper.userIDValue;
                        mainMap["DATA"] = tempMap;
                        mainMap["ISACTIVE"] = "1";

                        ref
                            .read(apiProvider)
                            .addEdDevices(mainMap);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                            content:
                            Text('Updated SuccessFully')));

                        Navigator.pop(context);
                        ref
                            .read(nameNotifier
                            .notifier)
                            .state =
                        !ref.watch(
                            nameNotifier);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: const Text("OK"),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }



  void initializeMQTTClient() async {
    //_client = MqttServerClient(_host, _identifier);
    _client.port = 8883;
    _client.keepAlivePeriod = 20;
    // _client.onDisconnected = onDisconnected;
    _client.secure = true;
    _client.logging(on: true);


    /* ref.watch(userDataNotifier(Helper.userIDValue)).when(data: (data){
      print("Data Length===>"+data.data!.units!.length.toString());
      if(data.data!=null)
      {
        mqttMac(data);
      }

    }, error: (error,e){

    }, loading: (){});*/

    /// Add the successful connection callback
    _client.onConnected = onConnected;
    // _client.onSubscribed = onSubscribed;

    //for the security, load secrity credentials file
    //final currDir = '${path.current}lib${path.separator}pem${path.separator}';
    final context = SecurityContext.defaultContext;
    String clientAuth = await rootBundle.loadString(
        "assets/mqtt_certificates/AmazonRootCA1.pem");
    context.setClientAuthoritiesBytes(clientAuth.codeUnits);
    String trustedCer =
    await rootBundle.loadString(
        "assets/mqtt_certificates/efa947d54b673e8d0c9a2b88566efdfee1dbc0427d720ebcda7c65db4bac7a8a-certificate.pem.crt");
    context.useCertificateChainBytes(trustedCer.codeUnits);
    String privateKey =
    await rootBundle.loadString(
        "assets/mqtt_certificates/efa947d54b673e8d0c9a2b88566efdfee1dbc0427d720ebcda7c65db4bac7a8a-private.pem.key");
    context.usePrivateKeyBytes(privateKey.codeUnits);


    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier("")
    //.withWillTopic('test') // If you set this you must set a will message
    //.withWillMessage('')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::AWS client connecting....');
    _client.connectionMessage = connMess;
    //connect();


  }

  // Connect to the host
  void connect(List<String> edDevice) async {
    assert(_client != null);
    try {
      print('EXAMPLE::AWS start client connecting....');
      //_currentState.setAppConnectionState(MQTTAppConnectionState.connecting);


      await _client.connect();

      for (int i = 0; i < edDevice.length; i++) {
        _client.subscribe(
            "topic/" + edDevice[i] + "/irc2app", MqttQos.atMostOnce);
        print("SUBS MAC" + i.toString() + "_topic/" + edDevice[i] + "/irc2app");
      }
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
  }

  void onConnected() {
    print("connected");
    _client.updates?.listen((
        List<MqttReceivedMessage<MqttMessage>> connection) {
      final MqttPublishMessage recMess = connection[0]
          .payload as MqttPublishMessage;
      final String pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      //_currentState.setReceivedText(pt);

      // ApplicationHelper.dismissProgressDialog();
      Mqtt = pt;
      print('EXAMPLE::Change notification:: topic is <${connection[0]
          .topic}>, payload is <-- $pt -->');
      //datas = "RCSP#94E686617EB8#10#0#0#0#RCEP";


      var splitted = pt.split("#");
      print(splitted[0]);
      print(splitted[1]);
      print(splitted[2]);

      if (splitted[1].length > 1) {
        var macindex = newList.indexWhere((ListEdMac) =>
        ListEdMac.edMac == splitted[1].toString());
        print(macindex);

        if (splitted[2] == "10") {
          if (splitted[3] == "0") {
            newList[macindex].channel1 = false;
          }
          else {
            newList[macindex].channel1 = true;
          }

          if (splitted[4] == "0") {
            newList[macindex].channel2 = false;
          }
          else {
            newList[macindex].channel2 = true;
          }
          if (splitted[5] == "0") {
            newList[macindex].channel3 = false;
          }
          else {
            newList[macindex].channel3 = true;
          }
        }
        else {
          if (splitted[3] == "0") {
            newList[macindex].channel1 = false;
          }
          else {
            newList[macindex].channel1 = true;
          }
        }
        ref
            .read(statusToggleButton
            .notifier)
            .state =
        !ref.watch(
            statusToggleButton);
      }

      print(
          'EXAMPLE::Change notification:: topic is <${connection[0]
              .topic}>, payload is <-- $pt -->');
      print('');

      //ref.read(userDataNotifier(Helper.userIDValue));

      // ApplicationHelper.dismissProgressDialog();
    });
  }

  void publish(String message, String Mac) {
    print("Publish====>" + message + "-" + Mac);
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(
        "topic/" + Mac + "/app2irc", MqttQos.atLeastOnce, builder.payload!);
  }

  void subscribe() async {
    _client.subscribe("test", MqttQos.atLeastOnce);
  }

  void mqttMac(UserDeviceList userDeviceList){
    print("UNIT LENGTH ========== ${userDeviceList.data!.units!.length}");
    if(userDeviceList.data!.units != null){
      MqttTopics(userDeviceList.data!.units!);
    }

  }

  itemBuildEdgeDevice(int index, UserEdDevice edDevice) {

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
                  child: CircleAvatar(
                    radius: 30.0,

                    backgroundColor:(){
                      if(edDevice.edgeDeviceId == "1"){
                        return Colors.blueGrey;
                      }else if(edDevice.edgeDeviceId == "2"){
                        return Colors.blue.shade100;
                      }else if(edDevice.edgeDeviceId == "3"){
                        return Colors.pinkAccent.shade700;
                      }else if(edDevice.edgeDeviceId == "4"){
                        return Colors.amber.shade100;
                      }else if(edDevice.edgeDeviceId == "5"){
                        return Colors.redAccent.shade100;
                      }else if(edDevice.edgeDeviceId == "6"){
                        return Colors.cyan.shade100;
                      }else if(edDevice.edgeDeviceId == "7"){
                        return Color(0xfff1cbff);
                      }else if(edDevice.edgeDeviceId == "8"){
                        return Color(0xffffe4e1);
                      }else if(edDevice.edgeDeviceId == "9"){
                        return Color(0xffeedd82);
                      }else if(edDevice.edgeDeviceId == "10"){
                        return Color(0xffFF7276);
                      }else if(edDevice.edgeDeviceId == "11"){
                        return Color(0xffE5FFCC);
                      }else if(edDevice.edgeDeviceId == "12"){
                        return Color(0xff99CCFF);
                      }else
                      {
                        return Colors.blueGrey;
                      }
                    }(),

                    child:  Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                          width: 50,

                     height: 60,
                          child:(){
                            if(edDevice.edgeDeviceId == "1"){
                              return  Image(
                                  image: AssetImage('assets/images/hot.png'));
                            }else if(edDevice.edgeDeviceId == "2"){
                              return Image(
                                  image: AssetImage('assets/images/idea.png'));
                            }else if(edDevice.edgeDeviceId == "3"){
                              return  Image(
                                  image: AssetImage('assets/images/phorp-removebg-preview.png'));
                            }else if(edDevice.edgeDeviceId == "4"){
                              return  Image(
                                  image: AssetImage('assets/images/waterlevelA.png'));
                            }else if(edDevice.edgeDeviceId == "5"){
                              return  Image(
                                  image: AssetImage('assets/images/WLD.png'));
                            }else if(edDevice.edgeDeviceId == "6"){
                              return  Image(
                                  image: AssetImage('assets/images/hot.png'));
                            }else if(edDevice.edgeDeviceId == "7"){
                              return  Image(
                                  image: AssetImage('assets/images/SMILE.png'));
                            }else if(edDevice.edgeDeviceId == "8"){
                              return  Image(
                                  image: AssetImage('assets/images/cardlight.png'));
                            }else if(edDevice.edgeDeviceId == "9"){
                              return Center(child: Text("1-C",style: TextStyle(fontWeight: FontWeight.bold),));
                            }else if(edDevice.edgeDeviceId == "10"){
                              return   Center(child: Text("3-C",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),));
                            }else if(edDevice.edgeDeviceId == "11"){
                              return  Center(child: Text("8-C",style: TextStyle(fontWeight: FontWeight.bold),));
                            }else if(edDevice.edgeDeviceId == "12"){
                              return Image(
                              image: AssetImage('assets/images/energy.png'));
                            }else
                            {
                              return  Image(
                              image: AssetImage('assets/images/hot.png'));
                            }
                          }()


                             ),
                    ),
                  ),


                   /* child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                          width: 20,
                          height: 10,
                          child: Image(
                              image: AssetImage('assets/images/thermometer.png'))),
                    ),*/
                  ),


                Row(
                  children: [
                    Text(edDevice.sensorUnit.toString(),style: const TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: Color(0xff808080)),),
                   /* IconButton(onPressed: (){
                      ConfirmPopup(edDevice);

                    }, icon: Icon(Icons.delete)),*/],
                )

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
