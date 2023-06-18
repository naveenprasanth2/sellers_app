import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authScreens/auth_screen.dart';
import '../helper/sizebox_helper.dart';
import '../brandsScreens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  splashScreenTimer() {
    Timer(const Duration(seconds: 1), () async {
      //if user already logged in
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));

      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.topRight)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/splash.png"),
              SizedBoxHelper.sizeBox20,
              const Text(
                "iShop Sellers",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
