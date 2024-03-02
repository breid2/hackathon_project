import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/components/message.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Send message
  Future<void> sendMessage(String message, String surgeryID) async {
    //get current user's info
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    String username = "null";
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserID)
        .get();
    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null && userData.containsKey('displayName')) {
        username = userData['displayName'] as String;
      }
    }

    //(_firebaseAuth.currentUser?.displayName).toString();
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderDisplayName: username,
        message: message,
        timestamp: timestamp);

    //add new message to database
    await _firestore
        .collection('surgeries')
        .doc(surgeryID)
        .collection('chats')
        .add(newMessage.toMap());
  }

  //Get messages
  Stream<QuerySnapshot> getMessages(String currentUserID, String surgeryID) {
    return _firestore
        .collection('surgeries')
        .doc(surgeryID)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
