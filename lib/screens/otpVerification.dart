import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telephony/telephony.dart';
import '../helper/applicationhelper.dart';
import '../helper/helper.dart';
import '../model/otp.dart';
import '../provider/user_management_provider/otpprovider.dart';
import '../res/screensize.dart';
import 'login.dart';


class otpVerification extends ConsumerStatefulWidget {


   otpVerification({Key? key}) : super(key: key);

  @override
  ConsumerState<otpVerification> createState() => _otpVerificationState();
}

class _otpVerificationState extends ConsumerState<otpVerification> {

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  Telephony telephony = Telephony.instance;
  TextEditingController otpbox = TextEditingController();

  String otpControl = "";


  @override
  void initState() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print("message");
        print("ADDRESS ${message.address}"); //+977981******67, sender nubmer
        print(message.body); //Your OTP code is 34567
        print(message.date); //1659690242000, timestamp

        String sms = message.body.toString();
        print(sms);
        //get the message


        //verify SMS is sent for OTP with sender number
        String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'),'');
        print("FINAL OTP  ---- $otpcode");
        //prase code from the OTP sms
        if(otpcode != null){


          otpControl = otpcode[0] +otpcode[1] +otpcode[2] +otpcode[3] +otpcode[4] +otpcode[5] ;
          _fieldOne.text= otpcode[0];
          _fieldTwo.text= otpcode[1];
          _fieldThree.text= otpcode[2];
          _fieldFour.text= otpcode[3];
          _fieldFive.text= otpcode[4];
          _fieldSix.text= otpcode[5];

          otpbox.text = otpControl;
          print(otpcode[0]);
          print("OTP ===== ${otpbox.text.toString()}");
        }


        //split otp code to list of number
        //and populate to otb boxes




      },
      listenInBackground: false,
    );    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back)),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text("PINNED YOU BY OUR PIN!",style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  )
                ],
              ),
              SizedBox(
                height: 400,
                child: Image.asset("assets/images/otp.gif"),
              ),

            Column(
              children: [
                Text("Please Enter your 6-digit One Time Password"),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: ScreenSize.screenWidth * 400,
                  //height:  ScreenSize.screenHeight * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpInput(_fieldOne, true),
                      OtpInput(_fieldTwo, false),
                      OtpInput(_fieldThree, false),
                      OtpInput(_fieldFour, false),
                      OtpInput(_fieldFive, false),
                      OtpInput(_fieldSix, false)
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shadowColor: MaterialStateProperty
                                .all(Colors.black),
                            backgroundColor: MaterialStateProperty
                                .all(Colors.black),
                            shape: MaterialStateProperty
                                .all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius
                                      .circular(8.0),
                                )
                            )
                        ),
                        onPressed: (){

                      String firststOTP = _fieldOne.text;
                      String secondOTP = _fieldTwo.text;
                      String thirdOTP = _fieldThree.text;
                      String fourthOTP = _fieldFour.text;
                      String fifthOTP = _fieldFive.text;
                      String sixthOTP = _fieldSix.text;
                      String otpGiven = firststOTP + secondOTP + thirdOTP +
                          fourthOTP + fifthOTP + sixthOTP;
                      if (_fieldOne.text.isEmpty ||
                          _fieldTwo.text.isEmpty ||
                          _fieldThree.text.isEmpty || _fieldFour.text
                          .isEmpty ||  _fieldFive.text.isEmpty ||
                          _fieldSix.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(
                                'OTP fields should not be empty ')));
                      } else if (otpGiven != Helper.otpRecived) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Enter valid OTP')));
                      } else {
                        print("hello world");
                        verifyOTP(Helper.userId);
                        ref.read(otpNotifier.notifier)
                            .otpVerify(
                            OTPVerify(
                                JSON_ID: "03",
                                USER_ID: Helper.userId,
                                DATA:OTPDataResponse(OTP_VERIFY:"1" )));
                      }

                      print(_fieldOne.text + _fieldTwo.text +
                          _fieldThree.text + _fieldFour.text +
                          _fieldFive.text + _fieldSix.text);

                      /*  _fieldOne.clear();
                                     _fieldTwo.clear();
                                     _fieldThree.clear();
                                     _fieldFour.clear();
                                     _fieldFive.clear();
                                     _fieldSix.clear();*/
                    }, child: Text("SUBMIT",style: TextStyle(color: Colors.white),)),
                  ),
                )
              ],
            )
            ],
          ),
        ),
      ),

    );
  }

  OtpInput(TextEditingController controller,bool autoFocus){
    return SizedBox(
      height: 50,
      width: 40,
      child: TextField(
        style: TextStyle(fontSize: 11),
        autofocus: false,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller:controller,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))
            ),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );


  }

  verifyOTP(String userID){
    ApplicationHelper.showProgressDialog(context);
    print("verifyotp $userID");
    Future.delayed(
        const Duration(seconds: 1), ()
    {
      ApplicationHelper.dismissProgressDialog();
      print("otprespose");
      var state = ref.watch(otpNotifier);
      print("ERRRRROR");
      state.id.when(data: (data) {

        var response = json.decode(data);

        print(response['DATA']['MSG']);
        print("ERRRRROR");
        Future.delayed(
          const Duration(milliseconds: 200),
              () {
            if (response['DATA']['MSG'] ==
                'Mobile Number is Already Exsist') {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(response['DATA']['MSG'])));
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(response['DATA']['MSG'])));
            }
          },
        );

      },error: (error, s) {

      }, loading: () {

      });

    });
  }
}
