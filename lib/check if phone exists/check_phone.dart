import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited/Home%20Screen/home.dart';
import 'package:locumspherelimited/Signup%20Screen/signup.dart';
import 'package:locumspherelimited/View%20Models/auth_provider.dart';
import 'package:locumspherelimited/check%20verification/check_verification.dart';

class CheckPhone extends StatefulWidget {
  CheckPhone({super.key, required String this.phone});
  String phone;
  @override
  State<CheckPhone> createState() => _CheckPhoneState();
}

class _CheckPhoneState extends State<CheckPhone> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfPhoneExists().then((value) {
      if (value == true) {
        
        Get.to(CheckVerify());
      } else {
        Get.snackbar("Redirecting to Signup Screen",
            "The phonenumber is not present in the database.");
        Get.to(SignupScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future checkIfPhoneExists() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Users')
        .where('phonenumber', isEqualTo: widget.phone)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length > 0) {
      print("true");
      return true;
    } else {
      print(widget.phone);
      print("false");
      return false;
    }
  }
}
