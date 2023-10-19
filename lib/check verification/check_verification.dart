import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited/Navbar/navbar.dart';
import 'package:locumspherelimited/LoginScreen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckVerify extends StatefulWidget {
  const CheckVerify({super.key});

  @override
  State<CheckVerify> createState() => _CheckVerifyState();
}

class _CheckVerifyState extends State<CheckVerify> {
  bool conditions = false;
  bool isVerified = false;
  String accounttype = "";
  String firstname = "";
  void initState() {
    // TODO: implement initState
    //super.initState();
    getNameStatus().then(
      (value) => value = firstname,
    );
    getVerificationStatus().then((value) => setState(
          () {},
        ));

    super.initState();
    //getVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return conditions == false
        ? Scaffold(
            body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .signOut()
                            .whenComplete(() => Get.offAll(LoginScreen()));
                      },
                      child: Text("Logout")),
                  ElevatedButton(
                      onPressed: () {
                        getNameStatus().then(
                          (value) {
                            firstname = value;
                          },
                        );
                        getVerificationStatus().then((value) => setState(
                              () {},
                            ));
                      },
                      child: Text("Refresh")),
                ],
              ),
            ),
          ))
        : NavBar();
  }

  Future<bool> getVerificationStatus() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    isVerified = document['isverified'];
    accounttype = document["accounttype"];
    if (isVerified == true && accounttype == "employee" && firstname != "") {
      conditions = true;
      return true;
    } else {
      conditions = false;
      return false;
    }
  }

  Future<String> getNameStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("firstname").toString();
  }
}
