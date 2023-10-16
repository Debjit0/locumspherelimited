import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

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

  Future sendMessage(Map<String, dynamic> chatMessageData, String name) async {
    /*await FirebaseFirestore.instance
        .collection("Chats")
        .doc("Admin_${FirebaseAuth.instance.currentUser!.uid}")
        .update({
      "participants": [uid, "Admin"]
    });*/
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
      "recentmessagesender": chatMessageData['sender'],
      "recentmessagetime": chatMessageData['time'].toString(),
      "participants": [name, uid]
    });
  }
}
