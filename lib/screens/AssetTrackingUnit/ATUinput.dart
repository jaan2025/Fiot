import 'dart:io';
import 'package:generic_iot_sensor/Packets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/helper/helper.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/loginnotifier.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../model/user_devicess/user_devies_model.dart';
import '../../res/colors.dart';



final ATUButton = StateProvider<bool>((ref) => false);

class ATUinputPage extends ConsumerStatefulWidget {
  String ? MacId;
   ATUinputPage({Key? key, this.MacId}) : super(key: key);

  @override
  ConsumerState<ATUinputPage> createState() => _ATUinputPageState();
}

class _ATUinputPageState extends ConsumerState<ATUinputPage> {


  final _client = MqttServerClient(
      "a1i25lg7rvcymv-ats.iot.us-east-1.amazonaws.com", "");
  List<String> ? MqttTopicList = [];
  int onceMqtt = 0;
  int oncesplit = 0;
  var Mqtt = "";

  bool isLoad = false;
  bool isLow = false;

  TextEditingController Current = TextEditingController();


  @override
  void initState() {
    initializeMQTTClient();
     Helper.classes = "ASSET";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body:ref.watch(assetDataNotifier(Helper.userIDValue)).when(data: (data){
        if(onceMqtt == 0){
          MqttTopics(data.data!.units!);
          onceMqtt++;
        }

        if(isLow == false||isLoad == true){
          Future.delayed(Duration(seconds: 5),(){
               ATU_Read();
          });
        }

        if(Mqtt.isNotEmpty & Mqtt.contains("12")==true){
          var outPut =  Mqtt.split("\$");
          print("OUT ==> $outPut");
          var semiOutPut = outPut[3].split("&");
          print("SEMIOUT ==> $semiOutPut");
          Current.text = semiOutPut[0];
        }


        if(Current.text.isEmpty){
          return good();
        }


       Future.delayed(Duration(seconds: 25),(){
         if(isLoad == true)
         {
           setState(() {
             isLoad = false;
           });

         }
       });


        return SafeArea(
          child: SingleChildScrollView(
            child: isLoad == false ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 55,
                        child: Card(
                          elevation: 10,
                          child: IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.arrow_back)),
                        )
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                     height: 300,

                      child: Image.asset("assets/images/ATU.png"),
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text('TRACK YOUR ASSETS',
                        style: TextStyle(
                            fontSize:20,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 25,
                      child: Image.asset("assets/images/juicy-bulb.gif"),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,left: 10,right: 15),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller:Current,
                    keyboardType: TextInputType.number,
                    //   inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),),
                      filled: true,
                      labelText: 'CURRENT IN mA',
                      hintText: 'Enter your tank height',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 10.0),
                  child: Consumer(
                      builder: (context, ref, child) {
                        return SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shadowColor:
                                MaterialStateProperty.all(
                                    Colors.black),
                                backgroundColor:
                                MaterialStateProperty.all(
                                    Colors.black),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(7.0),
                                    ))),
                            onPressed: () async {
                              setState(() {
                                ATU_Write();
                                  isLoad = true;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                'SAVE',
                                style:
                                TextStyle(color: Colors.white),
                              ),
                            ),
                            /* style: ElevatedButton.styleFrom(
                                                          minimumSize: Size.fromHeight(ScreenSize
                                                              .screenHeight *
                                                              0.07), // fromHeight use double.infinity as width and 40 is the height
                                                        ),*/
                          ),
                        );
                      }),
                ),

              ],
            ):Column(

              children: [
                const SizedBox(
                    height: 300,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                    ),
                  ],
                ),const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                   const Text("OVERWRITING INPUTS...."),
                    SizedBox(
                      width: 25,
                      child: Image.asset("assets/images/juicy-bulb.gif"),
                    )

                  ],
                ),
              ],
            )
          ),
        );

      }, error: (error,s){


      }, loading: (){})
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
  MqttTopics(List<UserUnit> list) {
    for (var unit in list) {
      for (var ed in unit.edDevice!) {

          MqttTopicList!.add(ed.macId.toString());
          print("bettest");
          print(ed.macId.toString());

      }
    }
    disconnect();
    connect(MqttTopicList!);
    print("wlwfConnected");

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
        ref
            .read(ATUButton
            .notifier)
            .state =
        !ref.watch(
            ATUButton);
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
  ATU_Write(){
    String pck =  wlwfPackets.startPck
        +wlwfPackets.symbol
        +"14"
        +wlwfPackets.symbol
        +"00${Current.text}"
        +wlwfPackets.symbol
        +wlwfPackets.edPck;

    String pckone =  wlwfPackets.startPck
        +wlwfPackets.symbol
        +"14"
        +wlwfPackets.symbol
        +"0${Current.text}"
        +wlwfPackets.symbol
        +wlwfPackets.edPck;

    String pcktwo =  wlwfPackets.startPck
        +wlwfPackets.symbol
        +"14"
        +wlwfPackets.symbol
        +"000${Current.text}"
        +wlwfPackets.symbol
        +wlwfPackets.edPck;
    print(pck);

    if(Current.text.length == 1){
      publish(pcktwo, widget.MacId!);
    }else if(Current.text.length == 2){
      publish(pck, widget.MacId!);
    }else if(Current.text.length == 3){
      publish(pckone, widget.MacId!);
    }

  }
  ATU_Read(){
    String pck =  wlwfPackets.startPck
        +wlwfPackets.symbol
        +"12"
        +wlwfPackets.symbol
        +"01"
        +wlwfPackets.symbol
        +wlwfPackets.edPck;
    print(pck);
    publish(pck, widget.MacId!);
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
}
