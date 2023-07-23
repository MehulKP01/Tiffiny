import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffiny/Screens/phone.dart';
import 'package:tiffiny/Screens/splash.dart';
import 'package:tiffiny/utils/sharedpref.dart';
import 'package:tiffiny/widgets/big_text.dart';
import 'package:tiffiny/widgets/small_text.dart';
import 'package:restart_app/restart_app.dart';
import 'home_body.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class MyHome extends StatefulWidget {
  String phone = "";
  MyHome({required this.phone});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late String phone = "";
  // void load() async {
  //   phone = SharedPrefUtils.readPrefStr('phone').toString();
  // }
  String currentVal = "";
  late Future myFuture;
  final auth = FirebaseAuth.instance;
  List User_detail = [];
  int i = 0;
  SharedPrefUtils prefs = SharedPrefUtils();
  Future<String> fetchUser() async {
    phone = await SharedPrefUtils.readPrefStr('phone');
    print("phone" + phone);
    var data = {"phone_no": phone};
    var url = "https://mytiffiny.000webhostapp.com/Display_User.php";

    // var response = await http.get(Uri.parse(url));
    var response = await http.post(Uri.parse(url), body: data);
    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);

      setState(() {
        User_detail = items;
      });
      currentVal = User_detail[0]['HouseName'];
      return "Loaded";
    } else {
      throw Exception("Failed to load data");
    }
    // print(User_detail);
  }

  Future<void> logout() async {
    // await auth.signOut().then((value) => Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const SplashScreen())));
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushReplacement(
            MaterialPageRoute(builder: (context) => const SplashScreen())));
  }

  @override
  void initState() {
    // TODO: implement initState
    myFuture = fetchUser();
    // load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          child: Container(
            margin: EdgeInsets.only(top: 45, bottom: 15),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column(
                //   children: [
                //     BigText(text: "India", color: Colors.amber),
                //     Row(
                //       children: [
                //         SmallText(text: "Gujarat"),
                //         Icon(Icons.arrow_drop_down_rounded)
                //       ],
                //     )
                //   ],
                // ),
                FutureBuilder<dynamic>(
                    future: myFuture,
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          DropdownButton(
                            iconEnabledColor: Colors.amber,
                            iconSize: 40,
                            isExpanded: false,
                            dropdownColor: Colors.amber,
                            items: User_detail.map((item) {
                              return DropdownMenuItem(
                                child: Row(
                                  children: [
                                    BigText(text: item['HouseName'] + " "),
                                    SmallText(text: item['Street'])
                                  ],
                                ),
                                value: item['HouseName'],
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                currentVal = newVal.toString();
                              });
                            },
                            value: currentVal,
                          )
                        ],
                      );
                    })),
                Center(
                  child: Container(
                    width: 45,
                    height: 45,
                    // ignore: sort_child_properties_last
                    child: IconButton(
                      onPressed: () async {
                        await auth.signOut().then((value) {
                          Navigator.pushNamed(context, 'splash');
                        });
                      },
                      // onPressed: () {
                      //   logout();
                      // },
                      icon: Icon(Icons.logout),
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.amber),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: HomeBody(),
        )),
      ],
    ));
  }
}
