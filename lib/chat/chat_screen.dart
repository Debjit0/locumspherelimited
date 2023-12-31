import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locumspherelimited/Firebase%20Services/services.dart';
import 'package:locumspherelimited/chat/components/message_tile.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.name, required this.senderName});
  String name;
  String senderName;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  Stream<QuerySnapshot>? chats;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String senderName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChat();
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      Services().sendMessage(
        chatMessageMap,
        widget.name,
        widget.senderName,
      );
      setState(() {
        messageController.clear();
      });
    }
  }

  getChat() {
    chats = FirebaseFirestore.instance
        .collection("Chats")
        .doc("${widget.name}_${uid}")
        .collection("Messages")
        .orderBy('time')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Stack(children: [
        chatMessages(),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  //sendMessage() {}
  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.data.docs.length == 0) {
          return Text("Start a Chat");
        }

        return snapshot.hasData
            ? ListView.builder(
                //reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: 'You',
                      sentByMe: FirebaseAuth.instance.currentUser!.uid ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container(child: Text("No"));
      },
    );
  }
}
