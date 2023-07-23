import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tiffiny/Screens/home.dart';
import 'package:tiffiny/Screens/phone.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    // if (user != null) {
    //   Timer(
    //       Duration(seconds: 3),
    //       () => Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (context) => MyHome())));
    // } else {
    //   Timer(
    //       Duration(seconds: 3),
    //       () => Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (context) => MyPhone())));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return AnimatedSplashScreen(
      backgroundColor: Colors.amber,
      splash: Center(
        child: Container(
          child: Text(
            "Tiffiny",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      nextScreen: user != null
          ? MyHome(
              phone: '',
            )
          : MyPhone(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      duration: 1500,
    );
  }
}
