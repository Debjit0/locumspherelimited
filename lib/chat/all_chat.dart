import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:locumspherelimited/chat/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllChat extends StatefulWidget {
  const AllChat({super.key});

  @override
  State<AllChat> createState() => _AllChatState();
}

class _AllChatState extends State<AllChat> {
  CollectionReference ChatCollection =
      FirebaseFirestore.instance.collection('Chats');
  CollectionReference unitCollection =
      FirebaseFirestore.instance.collection('Units');
  String firstname = "";
  String name = "";
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    getNameStatus().then((value) {
      
      setState(() {
        firstname = value;
      });
    });
    print("${firstname}_$uid");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Chats"),
      ),
      body: StreamBuilder(
        stream: ChatCollection.where("participants",
                arrayContains: "${firstname}_$uid")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          if (snapshot.data!.docs.length == 0) {
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
                      "No Allocations Found",
                    )
                  ],
                ),
              );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List participants =
                      snapshot.data!.docs[index]["participants"];
                  for (int i = 0; i < 2; i++) {
                    if (participants[i] != "${firstname}_$uid") {
                      name = participants[i];
                    }
                  }
              return GestureDetector(
                onTap: () async {
                  
                  //final splitted = 
                  Get.to(ChatScreen(name: name, senderName: firstname,));
                },
                child: ListTile(
                  leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  name.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                ),
                 title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Chat with $name as ${firstname}",
            style: const TextStyle(fontSize: 13),
          ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Admin"),
                      onTap: () {
                        Get.to(ChatScreen(
                          name: "Admin",
                          senderName: firstname,
                        ));
                      },
                    ),
                    StreamBuilder(
                        stream: unitCollection.snapshots(),
                        builder: (context, snapshot) {
                          //List<DropdownMenuItem> unitItems = [];
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.work),
                                  title: Text(
                                      snapshot.data!.docs[index]['unitname']),
                                  onTap: () {
                                    print(
                                        snapshot.data!.docs[index]['unitname']);
                                    Get.to(ChatScreen(
                                      name: snapshot.data!.docs[index]
                                          ['unitname'],
                                          senderName: firstname,
                                    ));
                                  },
                                );
                              });
                        }),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }

  Future<String> getNameStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("firstname").toString();
  }
}
