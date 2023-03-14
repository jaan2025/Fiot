import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/provider/location_management_provider/updatelocation_provider.dart';
import 'package:generic_iot_sensor/screens/shimmerprojectlist.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../helper/helper.dart';
import '../model/locationrequest.dart';
import '../model/user_devicess/user_devies_model.dart';
import '../provider/location_management_provider/addlocationprovider.dart';
import '../provider/user_management_provider/loginnotifier.dart';

class EditLocation extends ConsumerStatefulWidget {
  const EditLocation({Key? key}) : super(key: key);

  @override
  _EditLocationState createState() => _EditLocationState();
}




class _EditLocationState extends ConsumerState<EditLocation> {
  TextEditingController _locationnamecontroller = TextEditingController();
  List<UserEdDevice> ? edDeviceList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.read(userDataNotifier(Helper.userIDValue)).when(data: (data){
        return  data.data == null  ? Center(
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
        ) : SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                child: Row(
                  children: [
                    Text("Added Locations", style: TextStyle(
          fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.05),)
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                  itemCount: Helper.location.length,
                  itemBuilder: (context,index){
                return location(index, data.data!.locations![index],data.data!.units!);
              })
            ],
          ),
        );
        
      }, error: (error,e){
        return Center(
          child: Text(e.toString()),
        );
      }, loading: (){
        return ShimmerForProjectList();
      })
      
    );
  }

  location(int index, UserLocation location,List<UserUnit> list){
    return  Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Image(
                      image: AssetImage(location.locationName
                          .toString()
                          .contains('office')
                          ? "assets/images/office-building.png"
                          : "assets/images/house.png"))),
              Text(location.locationName.toString()),
              IconButton(onPressed: (){
                //deleteLocation(location, list);
                ref.refresh(userDataNotifier(Helper.userIDValue));

              }, icon: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );

  }

  void deleteLocation(UserLocation location,List<UserUnit> list) async {
    print("Entering...");
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(Helper.userId);
    ref.read(updateLocationNotifier.notifier)
        .updateLocation(
        LocationData(
            JSON_ID: "07",
            USER_ID: userId!,
            DATA: LocationDataResponse(
              LOCATION_ID:location.locationId!,
              LOCATION_NAME: location.locationName!,
              LOCATION_SUBNAME: '',
              ISACTIVE: "0",
            )));

  }

}
