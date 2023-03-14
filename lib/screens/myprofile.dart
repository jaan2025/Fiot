import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_iot_sensor/helper/helper.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/myprofileprovider.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/userprofileprovider.dart';
import 'package:generic_iot_sensor/res/id.dart';
import 'package:generic_iot_sensor/screens/dashboard.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../helper/applicationhelper.dart';
import '../model/response_data.dart';
import '../model/user.dart';
import '../model/user_devicess/user_devies_model.dart';
import '../provider/user_management_provider/loginnotifier.dart';
import '../res/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/screensize.dart';
import '../responsive/responsive.dart';
import 'about.dart';

final loginPasswordToggle = StateProvider<bool>((ref) => true);

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {

  final usernameController = TextEditingController(text: Helper.profileUserName);
  final mobileController = TextEditingController(text: Helper.profileMobileNo);
  final passwordController = TextEditingController(text: Helper.profilePassword);
  final mailController = TextEditingController(text: Helper.profileEmail);
  bool isActive = Helper.isActive;



  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return mobileUi(context);
  }


  mobileUi(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.white,
            body: SingleChildScrollView(
              child: Consumer(builder: (context, ref, child) {
                return SizedBox(
                  height: ScreenSize.safeBlockVertical * 100,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 15.0, right: 15.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("MY PROFILE"),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.account_circle_rounded),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0),
                                    ),
                                    filled: true,
                                    labelText: 'Username',
                                    hintText: 'Enter your Username',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  controller: mobileController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.phone),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0),
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
                                  textInputAction: TextInputAction.next,
                                  obscureText:
                                  ref.watch(loginPasswordToggle),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0),
                                    ),
                                    filled: true,
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    prefixIcon: InkWell(
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
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  controller: mailController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.mail),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0),
                                    ),
                                    filled: true,
                                    labelText: 'Email',
                                    hintText: 'Enter your Email',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: isActive,
                                        onChanged: (isChecked) {
                                          setState(() {
                                            isActive = isChecked!;
                                          });
                                        }),
                                    Text(
                                      'IsActive',
                                      style: TextStyle(
                                          fontSize:
                                          ScreenSize.screenWidth *
                                              0.04,
                                          fontWeight: FontWeight.bold),
                                    ),

                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 10.0),
                                    child: Consumer(
                                        builder: (context, ref, child) {
                                          return ElevatedButton(
                                            style: ButtonStyle(
                                                shadowColor: MaterialStateProperty
                                                    .all(Colors.red),
                                                backgroundColor: MaterialStateProperty
                                                    .all(Colors.white),
                                                shape: MaterialStateProperty
                                                    .all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(18.0),
                                                    )
                                                )
                                            ),
                                            onPressed: () async {
                                              if (validateProfileField()) {
                                                updateUserInfo();
                                              }
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 8.0,
                                                  bottom: 8.0),
                                              child: Text('UPDATE',
                                                style: TextStyle(
                                                    color: Colors.red),),
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
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 10.0),
                                    child: Consumer(
                                        builder: (context, ref, child) {
                                          return ElevatedButton(
                                            style: ButtonStyle(
                                                shadowColor: MaterialStateProperty
                                                    .all(Colors.red),
                                                backgroundColor: MaterialStateProperty
                                                    .all(Colors.white),
                                                shape: MaterialStateProperty
                                                    .all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(18.0),
                                                    )
                                                )
                                            ),
                                            onPressed: () async {

                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.remove(Helper.mobile);
                                              await prefs.remove(Helper.password);

                                              Navigator.of(context).pushNamedAndRemoveUntil(
                                                  AppId.LoginID,
                                                      (Route<dynamic> route) => false);

                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 8.0,
                                                  bottom: 8.0),
                                              child: Text('Logout',
                                                style: TextStyle(
                                                    color: Colors.red),),
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
                              ),




                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                );
              }),
            )));
  }

  bool validateProfileField() {
    if (usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the valid Username')));
      return false;
    }  else if (mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mobile Number should not be empty')));
      return false;
    } else if (mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter your 10 digit valid Mobile Number')));
      return false;
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password should not be empty')));
      return false;
    } else if (mailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email address should not be empty')));
      return false;
    }  else if (!validator.email(mailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter your valid Email')));
      return false;
    }
    return true;
  }

  updateUserInfo() async {
    ApplicationHelper.showProgressDialog(context);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Helper.userId);
    String? token = await FirebaseMessaging.instance.getToken();
    ref
        .read(updateUserNotifier.notifier)
        .updateUser(
        ResponseData(
            JSON_ID: "02",
            USER_ID: userId!,
            DATA: User(
              USER_NAME: usernameController
                  .text,
              PASSWORD: passwordController
                  .text,
              EMAIL_ID: mailController
                  .text,
              MOBILE_NO: mobileController
                  .text,
              MOBILE_KEY: token!,
              USER_ID: int.parse(prefs.getString(Helper.userId)!),
              ISACTIVE: isActive == true ? "1" : "0",
            ))
    );
    Future.delayed(
        const Duration(seconds: 1), () {
      ApplicationHelper.dismissProgressDialog();
      print("profileupdate_respose");
      var state = ref.watch(updateUserNotifier);
      state.id.when(data: (data) {
        try {
          var response = json.decode(data);
          Future.delayed(
            const Duration(milliseconds: 200),
                () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(response['DATA']['MSG'])));
            },
          );
        } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(data)));
        }

      }, error: (error, s) {
       // visibility = false;
      }, loading: () {
       // visibility = false;
      });
    });
  }


}
