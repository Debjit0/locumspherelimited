import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:locumspherelimited/Allocation%20Screen/components/allocation_tile.dart';
import 'package:locumspherelimited/Models/allocation_model.dart';
import 'package:locumspherelimited/Profile%20Screen/profile_screen.dart';
import 'package:locumspherelimited/SplashScreen/splash.dart';

class AllocationsSccreen extends StatefulWidget {
  const AllocationsSccreen({super.key});

  @override
  State<AllocationsSccreen> createState() => _AllocationsSccreenState();
}

class _AllocationsSccreenState extends State<AllocationsSccreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allocations"),
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

            if (snapshot.data!.docs.length != 0) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/not_found.svg",
                      height: 200,
                    ),
                    Text(
                      "No Tasks Allocated Today",
                    )
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: AllocationTile(
                      allocation: Allocation(
                          date: DateTime.parse(
                              snapshot.data!.docs[index]['date']),
                          unitName: snapshot.data!.docs[index]['unitname'],
                          unitLocation: snapshot.data!.docs[index]['date']),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
