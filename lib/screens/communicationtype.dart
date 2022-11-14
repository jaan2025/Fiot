import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../helper/helper.dart';
import '../helper/packet_control.dart';
import '../res/id.dart';
import '../services/tcpclient.dart';
import 'configuration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tcp_provider/tcp_provider_receive_data.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
class CommunicationType extends ConsumerStatefulWidget {
  const CommunicationType({Key? key}) : super(key: key);

  @override
  _CommunicationTypeState createState() => _CommunicationTypeState();
}



class _CommunicationTypeState extends ConsumerState<CommunicationType> {
  TextEditingController _heartbeatController = TextEditingController();
  TextEditingController _accountnoController = TextEditingController();


  late String radiotype = "01";
  int tempInt = 0;
  late ProgressDialog pr;
  @override
  void initState() {
    _heartbeatController.text = "";
    _accountnoController.text = "";
    tempInt = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ReadCommunicationData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Confirm your Communication Type',
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 500),
                    () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Configuration(),
                    ),
                  );
                });
          },),
      ),
      body:  Consumer(builder: (context, ref, child) {
        var data = ref.watch(tcpReceiveDataNotifier);
        return () {
    return data.id.when(data: (data)
    {
      var finalResult = data.toString().split('\$');
      Future.delayed(const Duration(milliseconds: 15), () {
        if(finalResult.isNotEmpty && finalResult.toString() != '[]' && finalResult.toString() != "[TimeOut]") {
          tempInt++;
          if (tempInt == 1) {
            dismissProgressDialog();
            if (finalResult[1] == "07") {
              radiotype = finalResult[4];
              _heartbeatController.text = finalResult[7];
              _heartbeatController.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: _heartbeatController.text.length));
              _accountnoController.text = finalResult[8];
              _accountnoController.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: _accountnoController.text.length));
            } else if(finalResult[1] == "08"){
              Future.delayed(const Duration(milliseconds: 500),
                      () {
                        Helper.qrScan = false;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  Configuration(),
                          ),
                        );
                      });

                /*Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Configuration(),
                  ),
                );*/
            }
          }
        }
      }());

      return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Communication Type", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700 ),),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text("Tcp"),
                    groupValue: radiotype,
                    value: "01",
                    onChanged: (value) {
                      setState((){
                        radiotype = value.toString();
                      });

                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Http"),
                    groupValue: radiotype,
                    value: "02",
                    onChanged: (value) {
                      setState((){
                        radiotype = value.toString();
                      });

                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text("Mqtt"),
                    groupValue: radiotype,
                    value: "03",
                    onChanged: (value) {
                      setState((){
                        radiotype = value.toString();
                      });

                    },
                  ),
                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: _heartbeatController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Heart Beat',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [LengthLimitingTextInputFormatter(4)],
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
                controller: _accountnoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Account Number',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [LengthLimitingTextInputFormatter(5)],
              ),
            ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                  final DateTime now = DateTime.now();
                  final DateFormat dayformatter = DateFormat(
                      'dd:MM:yy');
                  final DateFormat timeformatter = DateFormat(
                      'hh:mm:ss');
                  final String day_today = dayformatter
                      .format(now);
                  final String time_now = timeformatter
                      .format(now);
          if (validate()) {
           // showProgressDialog(context);
            tempInt = 0;
            String pck = PacketControl
              .startPacket +
              PacketControl.splitChar +
              "07" +
              PacketControl.splitChar +
              PacketControl.writePacket +
              PacketControl.splitChar +
              PacketControl.iotModeWifi +
              PacketControl.splitChar +
              radiotype +
              PacketControl.splitChar +
              Helper.Macaddress.toUpperCase() +
              PacketControl.splitChar +
              _heartbeatController.text +
              PacketControl.splitChar +
              _accountnoController.text +
              PacketControl.splitChar +
              time_now +
              PacketControl.splitChar +
              day_today +
              PacketControl.splitChar +
              PacketControl.endPacket;
          ref.read(tcpProvider)
              .sendPackets(pck);
          var writeResponse = ref.watch(
              tcpReceiveDataNotifier);

                }
          },
                child: const Text("SUBMIT")),

          ],
        ),
      );
    }, error: (error, txt) {
    return Text(txt.toString());
    }, loading: () {
    return const CircularProgressIndicator();
    });
    }();
    }
    ));
  }

  ReadCommunicationData(){
   //showProgressDialog(context);
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
    ref.read(tcpProvider).sendPackets(pck);
  }

  bool validate() {
    print(radiotype);
    if(radiotype.isEmpty){
      return validatePopup("Select communication type");
    } else if(_heartbeatController.text.isEmpty){
      return validatePopup("Heart beat should not be empty");
    }
    else if(_heartbeatController.text.length != 4){
      return validatePopup("Heart beat should be less than 9999 seconds");
    }
    else if(_accountnoController.text.isEmpty){
      return validatePopup("Account Number should not be empty");
    }
    else if(_accountnoController.text.length != 5){
      return validatePopup("Kindly enter the 5 digit valid Account Number");
    }
      return true;

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

  showProgressDialog(BuildContext context) async {
    pr = ProgressDialog(context, type: ProgressDialogType.normal,
        isDismissible: false,
        showLogs: false);
    pr.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    await pr.show();

  }
  dismissProgressDialog() async {
    if(pr.isShowing()) {
      pr.hide();
    }
  }
}
