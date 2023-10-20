import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future addInitialDetails(String firstname, String lastname, String email,
      String gender, String shiftPreference, String phoneNumber) async {
    final data = {
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'gender': gender,
      'shiftpreference': shiftPreference,
      'phonenumber': phoneNumber,
      'isverified': false,
      'accounttype': 'employee',
      'assigneddates': []
    };
    CollectionReference userCollection = _firestore.collection("Users");

    try {
      await userCollection.doc(uid).set(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future sendMessage(Map<String, dynamic> chatMessageData, String name, String senderName) async {
    /*await FirebaseFirestore.instance
        .collection("Chats")
        .doc("Admin_${FirebaseAuth.instance.currentUser!.uid}")
        .update({
      "participants": [uid, "Admin"]
    });*/
    String firstname = "";
    getNameStatus().then((value) => firstname = value);

    await FirebaseFirestore.instance
        .collection("Chats")
        .doc("${name}_${FirebaseAuth.instance.currentUser!.uid}")
        .collection("Messages")
        .add(chatMessageData);
    await FirebaseFirestore.instance
        .collection("Chats")
        .doc("Admin_${FirebaseAuth.instance.currentUser!.uid}")
        .set({
      "recentmessage": chatMessageData['message'],
      "recentmessagesender": "${firstname}_${chatMessageData['sender']}",
      "recentmessagetime": chatMessageData['time'].toString(),
      "participants": [name, "${firstname}_$uid"]
    });
  }

  Future<String> getNameStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("firstname").toString();
  }
}
