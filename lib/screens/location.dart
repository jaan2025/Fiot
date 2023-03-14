import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_iot_sensor/provider/location_management_provider/updatelocation_provider.dart';

import 'package:generic_iot_sensor/res/screensize.dart';
import 'package:generic_iot_sensor/screens/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helper/applicationhelper.dart';
import '../helper/helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/getuserinformation_response.dart';
import '../model/locationrequest.dart';
import '../provider/location_management_provider/addlocationprovider.dart';
import '../provider/user_management_provider/userprofileprovider.dart';

class LocationManagement extends ConsumerStatefulWidget {
  const LocationManagement({Key? key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends ConsumerState<LocationManagement> {

  TextEditingController _locationnamecontroller = TextEditingController();
  List<Location> locationList = [];
  bool? isActiveLocation = true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLocationList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Location Management',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>  Dashboard(),
              ),
            );
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: locationList.length,
                itemBuilder: (context, index) {
                  return getLocation(index, locationList);
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locationPopUp(-1);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  getLocation(var index, List<Location> locations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                locations[index].LOCATION_NAME.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
                onPressed: () {
                  locationPopUp(index);
                },
                icon: Icon(Icons.edit))
          ],
        ),
      ),
    );
  }

  locationPopUp(int position) {
    if(position != -1) {
      _locationnamecontroller.text = locationList[position].LOCATION_NAME;
    } else {
      _locationnamecontroller.text = "";
    }
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Location Name should not be empty')));
                } else {
    if(position != -1) {
      updateLocation(locationList[position].LOCATION_ID, isActiveLocation!);
    } else {
      addLocation();
    }
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
    ApplicationHelper.showProgressDialog(context);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Helper.userId);
    ref.read(addLocationNotifier.notifier)
        .addLocation(
        LocationData(
            JSON_ID: "07",
            USER_ID: userId!,
            DATA: LocationDataResponse(
              LOCATION_ID:"0",
              LOCATION_NAME: _locationnamecontroller.text,
              LOCATION_SUBNAME: '',
              ISACTIVE: "1",
            ))
    );
    Future.delayed(
        const Duration(seconds: 1), () {
      ApplicationHelper.dismissProgressDialog();
      print("addLocation_respose");
      var state = ref.watch(addLocationNotifier);
      state.id.when(data: (data) {
        try {
          var response = json.decode(data);
          Future.delayed(
            const Duration(milliseconds: 200),
                () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(response['DATA']['MSG'])));
                  if(response['DATA']['MSG'] != "Location Already Exsist"){
                    Navigator.pop(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      getLocationList();
                    });
                  }
            },
          );
        } catch(e){
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

  Future<void> getLocationList() async {
    ApplicationHelper.showProgressDialog(context);
    ref.read(getUserNotifier.notifier).getUserInfo();
    Future.delayed(
        const Duration(seconds: 1), () {
      ApplicationHelper.dismissProgressDialog();
      var state = ref.watch(getUserNotifier);
      state.id.when(data: (data) {
        try {
          var response = json.decode(data);
          Future.delayed(
            const Duration(milliseconds: 200),
                () {
              locationList = (response['DATA']['LOCATIONS'])
                  .map<Location>((f) => Location.fromJson(f))
                  .toList();
             setState(() {

             });
            },
          );
        }
        catch(e){
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

  Future<void> updateLocation(String locationID, bool isActiveLocation) async {
    ApplicationHelper.showProgressDialog(context);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Helper.userId);
    ref.read(updateLocationNotifier.notifier)
        .updateLocation(
        LocationData(
            JSON_ID: "08",
            USER_ID: userId!,
            DATA: LocationDataResponse(
              LOCATION_ID: locationID,
              LOCATION_NAME: _locationnamecontroller.text,
              LOCATION_SUBNAME: '',
              ISACTIVE: isActiveLocation ==  true ? "1" : "0",
            ))
    );
    Future.delayed(
        const Duration(seconds: 1), () {
      ApplicationHelper.dismissProgressDialog();
      print("updateLocation_respose");
      var state = ref.watch(updateLocationNotifier);
      state.id.when(data: (data) {
        try {
          var response = json.decode(data);
          Future.delayed(
            const Duration(milliseconds: 200),
                () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(response['DATA']['MSG'])));
              if(response['DATA']['MSG'] != "Location Already Exsist"){
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  getLocationList();
                });
              }
            },
          );
        } catch(e){
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
