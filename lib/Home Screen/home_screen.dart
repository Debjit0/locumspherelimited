import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:locumspherelimited/chat/all_chat.dart';
import 'package:locumspherelimited/chat/chat_screen.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  CollectionReference UserCollection =
      FirebaseFirestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(AllChat());
              },
              icon: Icon(Icons.message_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.person))
        ],
      ),
      body: StreamBuilder(
        stream: UserCollection.doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Allocations")
            .where("date", isEqualTo: date.toString())
            .snapshots(),
        builder: (context, snapshot) {
          //print(date);

          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                print(snapshot.data!.docs.length);
                return GestureDetector(
                  onTap: () {
                    Get.to(HomeScreen(index: index));
                  },
                  child: Container(
                    margin: EdgeInsets.all(14),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.lightGreen),
                    child: Column(
                      children: [
                        Text((index + 1).toString()),
                        Text(snapshot.data!.docs[index]['date']),
                        Text(snapshot.data!.docs[index]['unitname']),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.index});
  int index;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dateRequest = "";
  String unitName = "";
  String unitId = "";
  String allocationId = "";
  bool isLoading = true;
  bool hasWork = false;
  String checkin = "--/--";
  String checkout = "--/--";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodaysStatus().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Today's Status"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : hasWork
                ? Padding(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[50],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              /*Text(
                            DateFormat.yMEd()
                                .format(DateTime.parse(dateRequest)),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),*/
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Check In",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(checkin,
                                          style: TextStyle(
                                            fontSize: 30,
                                          ))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Check Out",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(checkout,
                                          style: TextStyle(
                                            fontSize: 30,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Builder(
                            builder: (context) {
                              final GlobalKey<SlideActionState> key =
                                  GlobalKey();
                              return SlideAction(
                                sliderRotate: false,
                                text: "Slide to Check In / Check Out",
                                textStyle: TextStyle(
                                    fontSize: 17, color: Colors.white),
                                outerColor: Colors.deepPurple[300],
                                key: key,
                                onSubmit: () async {
                                  QuerySnapshot snap = await FirebaseFirestore
                                      .instance
                                      .collection("Users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection("Allocations")
                                      .where("date",
                                          isEqualTo: dateRequest.toString())
                                      .get();

                                  print(snap.docs[widget.index].id);

                                  DocumentSnapshot snap2 =
                                      await FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("Allocations")
                                          .doc(snap.docs[widget.index].id)
                                          .get();

                                  if (snap2['checkin'] != "") {
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection("Allocations")
                                        .doc(snap.docs[widget.index].id)
                                        .update({
                                      'checkout': DateFormat("hh:mm")
                                          .format(DateTime.now())
                                    }).whenComplete(
                                      () {
                                        key.currentState!.reset();
                                        setState(() {
                                          Get.snackbar("Checked Out",
                                              "Successfully Checked Out");
                                          checkin = snap2['checkin'];
                                          checkout = DateFormat("hh:mm")
                                              .format(DateTime.now());
                                        });
                                      },
                                    );

                                    print("check out added");
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection("Allocations")
                                        .doc(snap.docs[widget.index].id)
                                        .update({
                                      'checkin': DateFormat("hh:mm")
                                          .format(DateTime.now())
                                    });
                                    key.currentState!.reset();
                                    setState(() {
                                      Get.snackbar("Checked In",
                                          "Successfully Checked In");
                                      checkin = DateFormat("hh:mm")
                                          .format(DateTime.now());
                                    });

                                    print("check in added");
                                  }

                                  key.currentState!.reset();
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : Center(
                    child: Text("No Allocations"),
                  ));
  }

  Future getTodaysStatus() async {
    try {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Allocations")
          .where("date", isEqualTo: date.toString())
          .get();

      final List<DocumentSnapshot> documents = snapshot.docs;

      dateRequest = documents[widget.index]['date'];
      unitId = documents[widget.index]['unitid'];
      unitName = documents[widget.index]['unitname'];
      allocationId = documents[widget.index].id;

      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Allocations")
          .where("date", isEqualTo: dateRequest.toString())
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Allocations")
          .doc(snap.docs[widget.index].id)
          .get();

      if (snap2['checkin'] != "") {
        checkin = snap2["checkin"];
      }
      if (snap2['checkout'] != "") {
        checkout = snap2['checkout'];
      }
      hasWork = true;
      isLoading = false;
    } catch (e) {
      hasWork = false;
      isLoading = false;
    }
  }
}
