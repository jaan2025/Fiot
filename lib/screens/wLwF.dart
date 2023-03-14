import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_iot_sensor/Packets.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/live_data_provider.dart';
import 'package:generic_iot_sensor/provider/widget_date_provider.dart';
import 'package:generic_iot_sensor/res/id.dart';

import 'package:generic_iot_sensor/screens/dashboard.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/shimmerprojectlist.dart';
import 'package:generic_iot_sensor/services/tcpclient.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../helper/applicationhelper.dart';
import '../../helper/helper.dart';
import '../../model/edgedevice/getsensorlist.dart';
import '../../provider/edgedevice_provider/addedgedevice_provider.dart';

import '../../provider/user_management_provider/loginnotifier.dart';
import '../../res/screensize.dart';
import '../../responsive/responsive.dart';
import '../../services/apiservices.dart';
import '../model/user_devicess/user_devies_model.dart';
import '../res/colors.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'edge_device_sensor_list.dart';


final ToggleButton = StateProvider<bool>((ref) => false);

class wLwF extends ConsumerStatefulWidget {

  String ? MacId;
  //Map? valueMap;

  wLwF({Key? key, this.MacId}) : super(key: key);

  @override
  _wLwF createState() => _wLwF();
}

class _wLwF extends ConsumerState<wLwF> {
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
  bool isRead = true;
  bool isMqtt = true;


  TextEditingController heightCont = TextEditingController();
  TextEditingController lowLevelCont = TextEditingController();
  TextEditingController highLevelCont = TextEditingController();

  final _client = MqttServerClient(
      "a1i25lg7rvcymv-ats.iot.us-east-1.amazonaws.com", "");

  var Mqtt = "";
  UserUnit ? MacId;
  UserEdDevice ? edDevice;



  List<String> ? MqttTopicList = [];
  int onceMqtt = 0;
  int oncesplit = 0;

  var writeStatus;
  var ReadStatus;
  var splittedRes ;
  var splittedreadRes ;

  bool isLoad = true;


  @override
 void initState() {
    print("1");

    initializeMQTTClient();

 Helper.classes = "WaterLevel";

   super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    print("pbject");



    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body:ref.watch(waterDataNotifier(Helper.userIDValue)).when(data: (data){
            if(onceMqtt == 0){
              MqttTopics(data.data!.units!);
              onceMqtt++;
            }

            for(int i =0;i<data.data!.units!.length;i++){
              print("LENGTH -- >  ${data.data!.units!.length} ");
              if(data.data!.units![i].macId!.isNotEmpty){

               MacId =  data.data!.units![i];

              }


            }



              if(index == 0 || isRead == false)
                {
                  Future.delayed(Duration(seconds: 5),(){
                     print("obct"
                     );
                    ReadTank(MacId!);

                  });

                }






            if(Mqtt.contains("RC11") == true){
              splittedRes = Mqtt.split("\$");
              print("writeData-->$splittedRes");
              if(splittedRes.isNotEmpty){
                writeStatus = splittedRes[3];
                ReadStatus = splittedRes[0];
              }
            }



            if(Mqtt.contains("RC10") == true){
              splittedreadRes = Mqtt.split("\$");
              print("SSSSSSSSSSs-->$splittedreadRes");
              if(splittedreadRes.isNotEmpty){
                ReadStatus = splittedreadRes[0];
              }
            }





            if(splittedreadRes != null && ReadStatus == "RC10"){
              print("ENTERED...");
              heightCont.text = splittedreadRes[3];
              lowLevelCont.text = splittedreadRes[4];
              highLevelCont.text = splittedreadRes[5];


            }


            if(heightCont.text.isEmpty){
             return good();
            }

            if(isRead == false)
            {
              Future.delayed(Duration(seconds: 10),(){

                setState(() {
                  isRead = true;
                });

              });
            //  isMqtt = false;


            }


            /*  if(isRead == false)
              {
                ref.refresh(waterDataNotifier(Helper.userIDValue));
              }
*/
            return SizedBox(
                height: 800,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 20),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);

                              },
                              child: Card(
                                child: Icon(Icons.arrow_back_ios),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:  (){
                        if(isRead == false){
                         return Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Center(
                                     child:SizedBox(
                                         width:300,
                                         height: 300,
                                         child: Image.asset("assets/images/loading-unscreen.gif"))
                                 ),
                               ],
                             ),
                             Text('OVERWRITTING TANK INPUTS...',style: TextStyle(

                             ),),

                           ],
                         );
                        }else{
                          if(isMqtt == false){
                          setState(() {
                            Future.delayed(Duration(seconds: 5),(){
                              print("obct"
                              );

                              ReadTank(MacId!);

                              ref
                                  .read(ToggleButton
                                  .notifier)
                                  .state =
                              !ref.watch(
                                  ToggleButton);

                            });
                          });
                          }
                         return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text('About Your Tank',
                                      style: TextStyle(
                                          fontSize:
                                          ScreenSize.screenWidth *
                                              0.07,
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  controller: heightCont,
                                  keyboardType: TextInputType.number,
                                  //   inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),),
                                    filled: true,
                                    labelText: 'Enter your tank height',
                                    hintText: 'Enter your tank height',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: TextField(
                                  controller: lowLevelCont,
                                  keyboardType: TextInputType.number,
                                  // textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    filled: true,
                                    labelText: 'Tank Low Level',
                                    hintText: 'Tank Low Level',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: TextField(
                                  controller: highLevelCont,
                                  keyboardType: TextInputType.number,
                                  // textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(25.0),
                                    ),
                                    filled: true,
                                    labelText: 'Tank High Level',
                                    hintText: 'Tank High Level',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 10.0),
                                child: Consumer(
                                    builder: (context, ref, child) {
                                      return ElevatedButton(
                                        style: ButtonStyle(
                                            shadowColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(18.0),
                                                ))),
                                        onPressed: () async {
                                          print("pressed");
                                          setState(() {
                                            writeTank(MacId!,index);
                                            isRead = false;
                                          //  ref.refresh(waterDataNotifier(Helper.userIDValue));
                                          });


                                        },

                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 8.0,
                                              bottom: 8.0),
                                          child: Text(
                                            'Submit',
                                            style:
                                            TextStyle(color: Colors.redAccent),
                                          ),
                                        ),
                                        /* style: ElevatedButton.styleFrom(
                                                        minimumSize: Size.fromHeight(ScreenSize
                                                            .screenHeight *
                                                            0.07), // fromHeight use double.infinity as width and 40 is the height
                                                      ),*/
                                      );
                                    }),
                              ),

                            ],
                          );
                        }
                      }(),

                    ),
                  ],
                ),
              ),
            );
          }, error: (error,s){
            return Center(
              child: Text(s.toString()),
            );
          }, loading: (){}) ),
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

  void onConnected() {
    print("connected");
    _client.updates?.listen((
        List<MqttReceivedMessage<MqttMessage>> connection) {
      final MqttPublishMessage recMess = connection[0]
          .payload as MqttPublishMessage;
      final String pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      Mqtt = pt;

      if(oncesplit == 0){
        print("better");
        ref
            .read(ToggleButton
            .notifier)
            .state =
        !ref.watch(
            ToggleButton);

        oncesplit++;
      }

      print('EXAMPLE::Change notification:: topic is <${connection[0]
          .topic}>, payload is <-- $pt -->');


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

  MqttTopics(List<UserUnit> list) {
    for (var unit in list) {
      for (var ed in unit.edDevice!) {
        if (ed.edgeDeviceId == "4" ||ed.edgeDeviceId == "5") {
          MqttTopicList!.add(ed.macId.toString());
          print(ed.macId.toString());
        }
      }
    }
    disconnect();
    connect(MqttTopicList!);
    print("wlwfConnected");

  }


  void disconnect() {
    print('Disconnected');
    _client.disconnect();
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

  writeTank(UserUnit edDevice,int index){
    String pck = wlwfPackets.startPck
        +"11"
        +wlwfPackets.symbol
        +wlwfPackets.write
        +wlwfPackets.symbol
        +wlwfPackets.DevId
        +wlwfPackets.symbol
        +heightCont.text
        +wlwfPackets.symbol
        +lowLevelCont.text
        +wlwfPackets.symbol
        +highLevelCont.text
        +wlwfPackets.symbol
        +wlwfPackets.edPck;
    print("pck=====> $pck");
    publish(pck,widget.MacId!);
    print("MAAAAAAC ==> ${widget.MacId}");
    print(" Write PUBLISHED");
    isLoad = false;

  }

  ReadTank(UserUnit edDevice){

    String pck =  wlwfPackets.startPck
        +"10"
        +wlwfPackets.symbol
        +wlwfPackets.read
        +wlwfPackets.symbol
        +wlwfPackets.DevId
        +wlwfPackets.symbol
        +wlwfPackets.edPck;

    print("Readpck=====> $pck");
    publish(pck,widget.MacId!);
    print("MAAAAAAC ==> ${widget.MacId}");

    print("Read PUBLISHED");


  }

  Widget good(){
    return  Column(
      children: [
        Row(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,top: 20),
              child: SizedBox(
                width: 50,
                height: 50,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);

                  },
                  child: Card(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 150,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child:SizedBox(
                    width:300,
                    height: 300,
                    child: Image.asset("assets/images/loading-unscreen.gif"))
            ),
          ],
        ),
      ],
    );
  }

  Widget Loading(){
    return CircularProgressIndicator();
  }



}
