
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/helper/applicationhelper.dart';
import 'package:generic_iot_sensor/provider/user_management_provider/otpprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/helper.dart';
import '../model/otp.dart';
import '../model/response_data.dart';
import '../model/user.dart';
import '../provider/user_management_provider/userprovider.dart';
import '../res/colors.dart';
import '../res/id.dart';
import '../res/screensize.dart';
import '../responsive/responsive.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final loginPasswordToggle = StateProvider<bool>((ref) => true);

class Register extends ConsumerStatefulWidget {
  const Register( {Key? key}) : super(key: key);


  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends ConsumerState<Register> {
  final usernameController = TextEditingController(text: '');
  final mobileController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final mailController = TextEditingController(text: '');

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  bool canLogin = false;


  @override
  initState()  {
    super.initState();
  }



  String? verificationCode;

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Responsive.isDesktop(context)
        ? windowsUi(context)
        : Responsive.isMobile(context)
        ? mobileUi(context)
        : windowsUi(context);
  }


  bool validateRegisterField() {
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
    } else if (mobileController.text == Helper.mobile) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mobile Number Already exist!!')));
      return false;
    }

    else if (passwordController.text.isEmpty) {
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

  saveUserDetails(String username, String mobileno,String password,String mail, ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Helper.userName, username);
    prefs.setString(Helper.mobile, mobileno);
    prefs.setString(Helper.password, password);
    prefs.setString(Helper.email, mail);

  }

  windowsUi(BuildContext context) {
    return Consumer(builder: (context, ref, child)
    {
      return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.primary,
            body: Consumer(builder: (context, ref, child) {
              return Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/logo.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Rax - Tech International',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.009),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            SizedBox(
                                              width: 160,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () async {},
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      3.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            height: 25.0,
                                                            decoration:
                                                            const BoxDecoration(
                                                              image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/android-logo.png'),
                                                                fit: BoxFit
                                                                    .fill,
                                                              ),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 8,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                                child: Text(
                                                                  'Download on the\nPlay Store',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .width *
                                                                          0.006),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                // fromHeight use double.infinity as width and 40 is the height
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 60.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            SizedBox(
                                              width: 160,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () async {},
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      3.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            height: 25.0,
                                                            decoration:
                                                            const BoxDecoration(
                                                              image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/apple.png'),
                                                                fit: BoxFit
                                                                    .fill,
                                                              ),
                                                            ),
                                                          )),
                                                      Expanded(
                                                          flex: 8,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                                child: Text(
                                                                  'Download on the\n App Store',
                                                                  style: TextStyle(
                                                                      fontSize: MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .width *
                                                                          0.006),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                // fromHeight use double.infinity as width and 40 is the height
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.33,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    boxShadow: Helper.boxShadow),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0, top: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('Login Now',
                                              style: TextStyle(
                                                  fontSize:
                                                  ScreenSize.screenWidth * 0.03,
                                                  color: AppColors.secondary,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0),
                                        child: TextField(
                                          textInputAction: TextInputAction.next,
                                          controller: usernameController,
                                          decoration: const InputDecoration(
                                            suffixIcon:
                                            Icon(Icons.account_circle_rounded),
                                            border: OutlineInputBorder(),
                                            labelText: 'Username',
                                            hintText: 'Enter your Username',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0),
                                        child: TextField(
                                          controller: passwordController,
                                          textInputAction: TextInputAction.next,
                                          obscureText: ref.watch(
                                              loginPasswordToggle),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: 'Password',
                                            hintText: 'Enter your password',
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                ref
                                                    .read(loginPasswordToggle
                                                    .notifier)
                                                    .state =
                                                !ref.watch(loginPasswordToggle);
                                              },
                                              child: Icon(
                                                ref.watch(
                                                    loginPasswordToggle) ==
                                                    true
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0),
                                        child: Text(
                                          'Having trouble while login ?',
                                          style: TextStyle(
                                              fontSize:
                                              ScreenSize.screenWidth * 0.01),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: [
                                            Checkbox(
                                                value: true,
                                                onChanged: (isChecked) {}),
                                            Text(
                                              'Keep me signed in',
                                              style: TextStyle(
                                                  fontSize:
                                                  ScreenSize.screenWidth * 0.01,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0),
                                        child:
                                        Consumer(
                                            builder: (context, ref, child) {
                                              return Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (validateRegisterField()) {
                                                          canLogin = true;
                                                          registerNewUser();
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        minimumSize: Size
                                                            .fromHeight(
                                                            ScreenSize
                                                                .screenHeight *
                                                                0.06), // fromHeight use double.infinity as width and 40 is the height
                                                      ),
                                                      child: const Text(
                                                          'LOGIN '),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 10),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Terms & Conditions |  Privacy Policy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Text(
                                        '© Rax-Tech International',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ));
    });
  }

  mobileUi(BuildContext context) {
    return Consumer(builder: (context, ref, child)
    {
      Future.delayed(
          const Duration(seconds: 1), () {
        ApplicationHelper.dismissProgressDialog();
        var state = ref.watch(addUserNotifier);
        state.id.when(data: (data) {
          try {
            var response = json.decode(data);
            Future.delayed(
              const Duration(milliseconds: 500),
                  () {
                String userID = response['USER_ID'];
                print("popup $userID");
                var otpReceived = response['DATA']['OTP'];
                showDialog(
                  context: context,
                  builder: (ctx) =>
                      AlertDialog(
                        insetPadding: const EdgeInsets.only(
                            left: 12.0, right: 12.0),
                        titlePadding: const EdgeInsets.all(20.0),
                        title: const Text("Please enter your OTP"),
                        content: Builder(
                            builder: (context) {
                              return Container(
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
                              );
                            }
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
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
                                  .isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                        'OTP fields should not be empty ')));
                              } else if (otpGiven != otpReceived) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Enter valid OTP')));
                              } else {
                                print("otp $userID");
                                verifyOTP(userID);
                              }
                              print(_fieldOne.text + _fieldTwo.text +
                                  _fieldThree.text + _fieldFour.text +
                                  _fieldFive.text + _fieldSix.text);

                              _fieldOne.clear();
                              _fieldTwo.clear();
                              _fieldThree.clear();
                              _fieldFour.clear();
                              _fieldFive.clear();
                              _fieldSix.clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: const Text("OK"),
                            ),
                          ),
                        ],
                      ),
                );
              },
            );
          } catch(e){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(data.toString())));
          }
        }, error: (error, s) {

        }, loading: () {

        });
      });
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15.0, left: 4.0, right: 4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Text("Lets get Started!",
                                                  style: TextStyle(
                                                      fontSize:
                                                      ScreenSize.screenWidth *
                                                          0.07,
                                                      color: AppColors.secondary,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
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
                                                    if (validateRegisterField()) {
                                                      canLogin = true;
                                                      registerNewUser();

                                                    }
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15.0,
                                                        right: 15.0,
                                                        top: 8.0,
                                                        bottom: 8.0),
                                                    child: Text('CREATE',
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
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          //top: ScreenSize.screenHeight * 0.525,
                          bottom: ScreenSize.screenHeight * 0.55,
                          right: ScreenSize.screenWidth * 0.13,
                          child: SizedBox(
                              width: ScreenSize.screenWidth * 0.68,
                              height: ScreenSize.screenHeight * 0.5,
                              child: Image(
                                  width: ScreenSize.screenWidth * 0.65,
                                  image: const AssetImage(
                                      'assets/images/rax_logo.png'))),
                        ),
                        /*Positioned(
                        top: ScreenSize.screenHeight * 0.01,
                        left: ScreenSize.screenWidth * 0.01,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: RichText(
                            text: TextSpan(
                                text: 'RAX\n',
                               */
                        /* style: GoogleFonts.montserrat(
                                  color: Colors.red,
                                  fontSize: ScreenSize.screenWidth * 0.1,
                                  fontWeight: FontWeight.bold,
                                ),*/
                        /*
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Process\n',
                                      style: TextStyle(
                                          fontSize:
                                              ScreenSize.screenWidth * 0.07,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200)),
                                  TextSpan(
                                      text: 'Management\n',
                                      style: TextStyle(
                                          fontSize:
                                              ScreenSize.screenWidth * 0.07,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200)),
                                  TextSpan(
                                      text: 'Project',
                                      style: TextStyle(
                                          fontSize:
                                              ScreenSize.screenWidth * 0.07,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200)),
                                ]),
                          ),
                        ),
                      ),
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
                      )*/
                      ],
                    ),
                  );
                }),
              )));
    });
  }

  registerNewUser() async {
    ApplicationHelper.showProgressDialog(context);
    String? token = await FirebaseMessaging.instance.getToken();
    ref
        .read(
        addUserNotifier.notifier)
        .addUser(
        ResponseData(
            JSON_ID: "01",
            USER_ID: "",
            DATA: User(
              USER_NAME: usernameController
                  .text,
              PASSWORD: passwordController
                  .text,
              EMAIL_ID: mailController
                  .text,
              MOBILE_NO:'91${mobileController
                  .text}',
              MOBILE_KEY: token!,
              USER_ID: 0,
              ISACTIVE: '1',
            ))
    );

  }

  verifyOTP(String userID){
    ApplicationHelper.showProgressDialog(context);
    print("verifyotp $userID");
    ref.read(
        otpNotifier.notifier)
        .otpVerify(OTPVerify(JSON_ID: "03", USER_ID: userID, DATA: OTPDataResponse(OTP_VERIFY: "1"))
    );

    Future.delayed(
        const Duration(seconds: 1), ()
    {
      ApplicationHelper.dismissProgressDialog();
      print("otprespose");
      var state = ref.watch(otpNotifier);
      state.id.when(data: (data) {
        try {
          var response = json.decode(data);
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(response['DATA']['MSG'])));
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                    AppId.LoginID,
                        (Route<dynamic>
                    route) =>
                    false);
              }
            },
          );
        } catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(data)));
        }
      },error: (error, s) {

      }, loading: () {

      });

    });
  }

}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 40,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
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

}

