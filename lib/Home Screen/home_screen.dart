import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited/Home%20Screen/components/allocation_tile.dart';
import 'package:locumspherelimited/Models/allocation_model.dart';
import 'package:locumspherelimited/Profile%20Screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allocations"),
        actions: [
          InkWell(
            onTap: () {
              Get.to(ProfileScreen());
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromARGB(255, 236, 236, 236)),
              child: Center(
                  child: Icon(
                Icons.person,
                color: Colors.deepPurple,
              )),
            ),
          ),
          SizedBox(
            width: 14,
          )
        ],
      ),
      body: StreamBuilder(
          stream: userCollection.doc(uid).collection("Allocations").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: AllocationTile(
                    allocation: Allocation(
                        date:
                            DateTime.parse(snapshot.data!.docs[index]['date']),
                        unitName: snapshot.data!.docs[index]['unitname'],
                        unitLocation: snapshot.data!.docs[index]['date']),
                  ),
                );
              },
            );
          }),
    );
  }
}
