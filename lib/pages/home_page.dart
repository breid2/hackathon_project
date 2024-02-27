import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //User? currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  //sign out user
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage() {
    //only post if there is something in the text field
    if (textController.text.isNotEmpty) {
      //store in Firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        'Likes': [],
      });
    }

    //clear the textfield
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("ENSF609 Hackathon"),
      ),
      body: Center(
        child: Column(children: [
          //logged in as
          Text(
            "Logged in as: ${currentUser.email!}",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }
}
