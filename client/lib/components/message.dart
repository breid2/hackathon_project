import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderDisplayName;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderID,
      required this.senderDisplayName,
      required this.message,
      required this.timestamp});

  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderDisplayName': senderDisplayName,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
