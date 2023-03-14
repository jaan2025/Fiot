import 'package:flutter/material.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../res/colors.dart';

class SensorItemScreen extends ConsumerStatefulWidget {

  UserSensor ? sensor;
   SensorItemScreen({this.sensor,Key? key}) : super(key: key);

  @override
  ConsumerState<SensorItemScreen> createState() => _SensorItemScreenState();
}

class _SensorItemScreenState extends ConsumerState<SensorItemScreen> {
  @override
  Widget build(BuildContext context) {
    print("dbject");
    return SafeArea(child: Scaffold(
      backgroundColor: AppColors.cream,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: Colors.black,
                      )),
                  Text(
                    widget.sensor!.parameters.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                        MediaQuery.of(context).size.width *
                            0.05),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children:  [
                              Expanded(
                                  child:Column(
                                    children: [
                                      const Text('Measurement Min ',style: TextStyle(fontWeight: FontWeight.bold),),
                                      Padding(
                                        padding: const EdgeInsets.only(top:  5.0),
                                        child: Text(widget.sensor!.measurementMin!,style: TextStyle(fontWeight: FontWeight.normal),),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      )
                    ),
                    Expanded(
                        child: Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children:  [
                                  Expanded(
                                      child:Column(
                                        children: [
                                          const Text('Measurement Max ',style: TextStyle(fontWeight: FontWeight.bold),),
                                          Padding(
                                            padding: const EdgeInsets.only(top:  5.0),
                                            child: Text(widget.sensor!.measurementMax!,style: TextStyle(fontWeight: FontWeight.normal),),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )
                        )
                    ),
                  ],
                )),
            Expanded(
                flex: 4,
                child:   Stack(
                  children: [
                    Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Refresh Interval',style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(widget.sensor!.refreshInterval.toString(),style: TextStyle(fontWeight: FontWeight.normal),),
                        Text(widget.sensor!.units.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: FractionalTranslation(
                        translation: Offset(0.0, 0.0),
                        child: new Container(

                          decoration: new BoxDecoration(
                            border: new Border.all(
                              color: Colors.orange,
                              width: 25.0, // it's my slider variable, to change the size of the circle
                            ),
                            shape: BoxShape.circle,
                          ),

                        ),
                      ),
                    ),
                  ],
                ),),
            Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children:  [
                                        Expanded(
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('S1 Value : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                     Text(widget.sensor!.s1Value!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Row(
                                                    children: [
                                                      const Text('Description : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(widget.sensor!.s1Description!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children:  [
                                        Expanded(
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('S1 Value : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(widget.sensor!.s1Value!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Row(
                                                    children: [
                                                      const Text('Description : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(widget.sensor!.s1Description!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children:  [
                                        Expanded(
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('S2 Value : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(widget.sensor!.s2Value!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Row(
                                                    children: [
                                                      const Text('Description : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Expanded(child: Text(widget.sensor!.s2Description!,style: const TextStyle(fontWeight: FontWeight.normal),)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children:  [
                                        Expanded(
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('S3 Value : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Expanded(child: Text(widget.sensor!.s1Value!,style: const TextStyle(fontWeight: FontWeight.normal),)),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Row(
                                                    children: [
                                                      const Text('Description : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Expanded(child: Text(widget.sensor!.s3Description!,style: const TextStyle(fontWeight: FontWeight.normal),)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children:  [
                                        Expanded(
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('S1 Value : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(widget.sensor!.s1Value!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Row(
                                                    children: [
                                                      const Text('Description : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(widget.sensor!.s1Description!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                              )
                          ),
                          Expanded(
                              child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children:  [
                                        Expanded(
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text('S1 Value : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(widget.sensor!.s1Value!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Row(
                                                    children: [
                                                      const Text('Description : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text(widget.sensor!.s1Description!,style: const TextStyle(fontWeight: FontWeight.normal),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
