import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/pages/chat_page.dart';

class SurgeryHomePage extends StatefulWidget {
  final String surgeryName;
  final String user;
  final String surgeryID;
  final List<String> members;
  final String time;
  final DateTime surgeryStart;

  const SurgeryHomePage({
    super.key,
    required this.user,
    required this.surgeryName,
    required this.members,
    required this.surgeryID,
    required this.time,
    required this.surgeryStart,
  });

  @override
  State<SurgeryHomePage> createState() => _SurgeryHomePageState();
}

class _SurgeryHomePageState extends State<SurgeryHomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controller = TextEditingController();

  void _addSurgeryMember() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add person to surgery'),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Enter member ID'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  _sendSurgeryAddRequest(_controller.text);
                  print('Entered value: ${_controller.text}');
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _removeSurgeryMember() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Remove person from surgery'),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Enter member ID'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  _sendSurgeryRemoveRequest(_controller.text);
                  print('Entered value: ${_controller.text}');
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showDeleteSurgeryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Surgery'),
          content: const Text('Are you sure you want to delete this surgery?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Call your function to delete the surgery here
                _deleteSurgery(widget.surgeryID);

                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(widget.surgeryName),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.menu),
              onSelected: (result) {
                if (result == 0) {
                  _addSurgeryMember();
                }
                if (result == 1) {
                  _removeSurgeryMember();
                }
                if (result == 2) {
                  _showDeleteSurgeryDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.person_add,
                    ),
                    title: Text('Add Member'),
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(
                      Icons.person_remove,
                    ),
                    title: Text('Remove Member'),
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Icon(
                      Icons.date_range,
                    ),
                    title: Text('Change Dates'),
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                    ),
                    title: Text('Delete Surgery'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                      user: currentUser.uid,
                                    )));
                      },
                    ),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Text("List to fill");
                },
              ),
            ),
          ],
        ));
  }

  Future<void> _sendSurgeryAddRequest(memberID) async {
    CollectionReference surgery = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('surgeries');
    String memberDisplayName;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(memberID)
        .get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      memberDisplayName = userData['displayName'];
    } else {
      memberDisplayName = ('Unknown User');
    }
    Map<String, String> membersInfo = {memberID: memberDisplayName};
    await surgery.doc(widget.surgeryID).update({
      "members": FieldValue.arrayUnion([memberID]),
      "memberInfo.$memberID": memberDisplayName,
    });
  }

  Future<void> _sendSurgeryRemoveRequest(memberID) async {
    CollectionReference surgery = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('surgeries');
    await surgery.doc(widget.surgeryID).update({
      "members": FieldValue.arrayRemove([memberID]),
    });
  }

  Future<void> _deleteSurgery(memberID) async {
    CollectionReference surgery = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('surgeries');
    await surgery.doc(widget.surgeryID).delete();
  }
}
