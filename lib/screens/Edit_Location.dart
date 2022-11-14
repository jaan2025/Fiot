import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generic_iot_sensor/screens/shimmerprojectlist.dart';

import '../helper/helper.dart';
import '../model/user_devicess/user_devies_model.dart';
import '../provider/user_management_provider/loginnotifier.dart';

class EditLocation extends ConsumerStatefulWidget {
  const EditLocation({Key? key}) : super(key: key);

  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends ConsumerState<EditLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.read(userDataNotifier(Helper.userIDValue)).when(data: (data){
        return Column(
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
              return location(index, data.data!.locations![index]);
            })
          ],
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

  location(int index, UserLocation location){
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
              IconButton(onPressed: (){}, icon: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );

  }
}
