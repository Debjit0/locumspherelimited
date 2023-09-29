import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:locumspherelimited/Home%20Screen/home.dart';
import 'package:locumspherelimited/LoginScreen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //show screen for 2 secs
    Future.delayed(const Duration(seconds: 2), () {
      if (auth.currentUser == null) {
        Get.offAll(LoginScreen());
      } else {
        Get.offAll(HomeScreen());
      }
    });

    return Scaffold(
      body: Center(
          child: FlutterLogo(
        size: 100,
      )),
    );
  }
}
