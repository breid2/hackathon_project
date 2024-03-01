import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hackathon_project/components/chat_bubble.dart';
import 'package:hackathon_project/components/text_field.dart';
import 'package:hackathon_project/components/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String user;

  final surgeryID;
  const ChatPage({
    super.key,
    required this.user,
    required this.surgeryID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //Check if there is a message to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(_messageController.text, widget.surgeryID);
      //Clear the controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text("Chat Service")),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),

          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder(
        stream: _chatService.getMessages(currentUserID, widget.surgeryID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        },
      ),
    );
  }

  //building message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Timestamp time = data['timestamp'];
    int intTime = int.parse(time.seconds.toString());
    final DateTime messageTime =
        DateTime.fromMillisecondsSinceEpoch(intTime * 1000);

    //align the messages to the right if the sender is the current user, otherwise to the left
    MaterialColor bubbleColor;
    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    if (alignment == Alignment.centerRight) {
      bubbleColor = Colors.blue;
    } else {
      bubbleColor = Colors.grey;
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment:
                (data['senderID'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderID'] == _firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              Text(DateFormat('MMM d, hh:mm').format(messageTime) +
                  " - " +
                  data['senderDisplayName']),
              ChatBubble(
                message: data['message'],
                bubbleColor: bubbleColor,
              )
            ]),
      ),
    );
  }

  //build message item
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
          controller: _messageController,
          hintText: 'Enter Message',
          obscureText: false,
        )),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.send,
            size: 40,
          ),
        )
      ],
    );
  }
}
