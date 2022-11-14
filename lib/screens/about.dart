import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
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
                  'ABOUT THIS APP',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                )
              ],
            ),
            SizedBox(
              width: 320,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'App Version ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "1.0.0",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xfff808080)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: const [
                                Text(
                                  'Company Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "Rax-Tech International",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xfff808080)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: const [
                                Text(
                                  'Contact',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "+91 44-22771949",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xfff808080)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: const [
                                Text(
                                  'MAIL',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "sales@raxgbc.co.in",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xfff808080)),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  'ADDRESS ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.04),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  "5th Floor, Kaleesweri Tower, \n 5/391, Velachery Main Road,\n Medavakkam,Chennai – 600 100, India.",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xfff808080)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Text("")),

            Center(
              child: Row(
                children: [
                  SizedBox(
                      width: 50,
                      height: 50,
                      child:
                      Image(image: AssetImage('assets/images/rax_logo.png'))),
                  Text(
                    '© 2021 Rax-Tech International. ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
