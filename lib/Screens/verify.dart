import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:tiffiny/Screens/Information.dart';
import 'package:tiffiny/Screens/phone.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/sharedpref.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  late String phone = "";
  List user = [];
  late String usr = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> fetchUser() async {
    phone = await SharedPrefUtils.readPrefStr('phone');
    // print("phone" + phone);
    var data = {"phone_no": phone};
    var url = "https://mytiffiny.000webhostapp.com/Check_user.php";

    // var response = await http.get(Uri.parse(url));
    var response = await http.post(Uri.parse(url), body: data);
    // var message = jsonDecode(response.body);
    // print(message);
    var items = [];
    if (response.statusCode == 200) {
      // if (response.body.isEmpty) {
      //   items = "";
      // } else {
      //   items = jsonDecode(response.body);
      // }
      try {
        items = jsonDecode(response.body);
      } catch (e) {
        print(e);
      }

      // if (items['Name'] == "") {
      //   user = "";
      // }
      if (items.isNotEmpty) {
        setState(() {
          usr = items[0]['Name'];
          print(usr);
        });
      }

      return "Loaded";
    } else {
      throw Exception("Failed to load data");
    }
    // print(User_detail);
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code = "";
    String phone = "";
    @override
    void dispose() {
      // TODO: implement dispose
      // code.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: Colors.amber,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Login_Food.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                onChanged: (value) {
                  code = value;
                  phone += value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      print(code);
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: MyPhone.verify, smsCode: code);

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                        usr != ""
                            ? Navigator.pushNamed(
                                context,
                                'home',
                              )
                            : Navigator.pushNamed(
                                context,
                                'information',
                              );
                        print("Success");
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
