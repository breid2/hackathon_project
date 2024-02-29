import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NewSurgeryPage extends StatefulWidget {
  @override
  _NewSurgeryPageState createState() => _NewSurgeryPageState();
}

class _NewSurgeryPageState extends State<NewSurgeryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _surgeryNameController = TextEditingController();
  DateTime? _startDate;

  _selectStartDate(BuildContext context) async {
    DateTime pickedDate = await showDatePicker(
          context: context,
          initialDate: _startDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        ) ??
        DateTime.now();
    setState(() {
      _startDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a New Surgery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _surgeryNameController,
              decoration: InputDecoration(
                labelText: 'Surgery Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _selectStartDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                ),
                child: Text(
                  _startDate == null
                      ? 'Select Date'
                      : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _createSurgery,
              child: Text('Create Surgery'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createSurgery() async {
    if (_surgeryNameController.text.isNotEmpty && _startDate != null) {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser!;
        String ownerDisplayName;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          ownerDisplayName = userData['displayName'];
        } else {
          ownerDisplayName = ('Unknown User');
        }
        Map<String, String> membersInfo = {currentUser.uid: ownerDisplayName};

        CollectionReference surgery = _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('surgeries');
        var result = await surgery.add({
          'surgeryName': _surgeryNameController.text,
          'surgeryStart': Timestamp.fromDate(_startDate!),
          "ownerEmail": currentUser.email,
          "ownerUsername": currentUser.displayName,
          "timeStamp": Timestamp.now(),
          "owner": currentUser.uid,
          "members": [currentUser.uid, 'ity0IuvNBDQTWW6j9oQo73ffgBj2'],
          "memberInfo": membersInfo,
        });

        SnackBar(content: Text(currentUser.toString()));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating surgery: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields!')),
      );
    }
  }
}
