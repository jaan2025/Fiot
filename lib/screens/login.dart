import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/loginnotifier.dart';
import 'package:generic_iot_sensor/screens/register.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/applicationhelper.dart';
import '../helper/helper.dart';
import '../model/response_data.dart';
import '../model/user.dart';
import '../res/colors.dart';
import '../res/id.dart';
import '../res/screensize.dart';
import '../responsive/responsive.dart';

final loginPasswordToggle = StateProvider<bool>((ref) => true);

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final mobilenoController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  bool canLogin = false;
  bool visibility = false;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();


  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return mobileUi(context);
  }

  sendData() {
    canLogin = true;
    Helper.logout = false;
  }

  bool validateLoginField() {
    if (mobilenoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mobile Number should not be empty')));
      return false;
    } else if (mobilenoController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter your 10 digit valid Mobile Number')));
      return false;
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password should not be empty')));
      return false;
    }
    return true;
  }

  saveUserDetails(String username, String password, String? userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Helper.mobile, username);
    prefs.setString(Helper.password, password);
    prefs.setString(Helper.userId, userId!);
  }


  String toastlabel="";

  mobileUi(BuildContext context) {

    final mediaQuery = MediaQuery.maybeOf(context)!.size;

    MediaQueryData deviceInfo = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(

            backgroundColor: AppColors.white,
            body: SingleChildScrollView(
              child: Consumer(builder: (context, ref, child) {
                return SizedBox(

                  height: ScreenSize.safeBlockVertical * 100,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Visibility(
                        visible: visibility,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                      Consumer(builder: (context, ref, child) {
                        var state = ref.watch(loginUserNotifier);
                        if (state.error == 'initial') {
                          visibility = false;
                        } else {
                          print('error');
                        }
                        if (state.isLoading) {
                          visibility = true;
                        }
                        state.id.when(
                            data: (data) async {
                              if(!Helper.logout){
                                if(data.data!=null){
                                  visibility = false;
                                  if (data.data!.msg == 'Login Failed') {
                                    if(toastlabel!="" || data.data!.msg=="")
                                    {
                                      toastlabel="";

                                    }
                                    else{
                                      toastlabel= data.data!.msg.toString();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(toastlabel)));
                                      data.data!.msg="";
                                    }
                                  } else {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    saveUserDetails(
                                        mobilenoController.text,
                                        passwordController.text,data.userId);

                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        AppId.DashboardID,
                                            (Route<dynamic> route) => false);

                                  }
                                }
                              }

                            },
                            error: (error, s) {

                            },
                            loading: () {

                            });


                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 100.0, left: 15.0, right: 15.0),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),),
                                  color: Colors.white,
                                  shadowColor: Colors.blueGrey,
                                  elevation: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text('User Login',
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
                                            controller: mobilenoController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(10)
                                            ],
                                            decoration: InputDecoration(
                                              suffixIcon: const Icon(Icons.phone),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(15.0),
                                              ),
                                              filled: true,
                                              labelText: 'Mobile Number',
                                              hintText: 'Enter your Mobile Number',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: TextField(
                                            controller: passwordController,
                                            textInputAction: TextInputAction.done,
                                            obscureText:
                                            ref.watch(loginPasswordToggle),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(15.0),
                                              ),
                                              filled: true,
                                              labelText: 'Password',
                                              hintText: 'Enter your password',
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(loginPasswordToggle
                                                      .notifier)
                                                      .state =
                                                  !ref.watch(
                                                      loginPasswordToggle);
                                                },
                                                child: Icon(
                                                  ref.watch(loginPasswordToggle) ==
                                                      true
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0, right: 5.0),
                                              child: Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                    fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.04),
                                              ),
                                            ),
                                          ],
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
                                                    if (validateLoginField()) {
                                                      canLogin = true;
                                                      Helper.logout = false;
                                                       loginUser();
                                                    }
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0,
                                                        right: 15.0,
                                                        top: 8.0,
                                                        bottom: 8.0),
                                                    child: Text(
                                                      'LOGIN',
                                                      style:
                                                      TextStyle(color: Colors.red),
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Don't have an account? ",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                        const Register(),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    " Sign Up",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      Positioned(
                        //top: ScreenSize.screenHeight * 0.525,
                        bottom: ScreenSize.screenHeight * 0.50,
                        right: ScreenSize.screenWidth * 0.16,
                        child: SizedBox(
                            width: ScreenSize.screenWidth * 0.68,
                            height: ScreenSize.screenHeight * 0.5,
                            child: Image(
                                width: ScreenSize.screenWidth * 0.65,
                                image: const AssetImage(
                                    'assets/images/rax_logo.png'))),
                      ),

                    ],
                  ),
                );
              }),
            )));
  }

  Future<void> requestLocationPermission() async {
    final serviceStatusLocation = await Permission.locationWhenInUse.isGranted;
    if (!serviceStatusLocation) {
      final status = await Permission.locationWhenInUse.request();
      if (status == PermissionStatus.granted) {
        requestStoragePermission();
      } else if (status == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      }
    } else {
      requestStoragePermission();
    }
  }

  Future<void> requestStoragePermission() async {
    final serviceStatusStorage = await Permission.storage.isGranted;
    if (!serviceStatusStorage) {
      final status = await Permission.storage.request();
      if (status == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  loginUser() async {
    visibility = true;
    String? token = await FirebaseMessaging.instance.getToken();
    ref.read(loginUserNotifier.notifier). loginUser({
      "JSON_ID": "05",
      "USER_ID": "",
      "DATA": {
        "MOBILE_NO": '91${mobilenoController.text}',
        "PASSWORD": passwordController.text,
        "MOBILE_KEY": token!
      }
    });
  }



}
