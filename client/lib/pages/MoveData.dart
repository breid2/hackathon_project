import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MoveData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<void> moveSurgeryDataToUserEpisode(String episodeId) async {
    try {
      
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      
      // Get surgery data under "Surgery/Gallbladder/After" path
      QuerySnapshot surgerySnapshot = await FirebaseFirestore.instance
          .collection('Surgery')
          .doc('gallbladder') // Replace with the actual document ID if 'Gallbladder' is a document
          .collection('AfterSurgery') // Replace with the actual subcollection name
          .doc('AfterSurgery')
          .collection('Activities')
          .get();
      if (surgerySnapshot.size > 0) {
        // Iterate through the documents and print the data
        for (QueryDocumentSnapshot doc in surgerySnapshot.docs) {
          print('Document ID: ${doc.id}');
          print('Data: ${doc.data()}');
        }
      } else {
        print('No documents found in the specified collection.');
      }

      // Iterate through surgery documents and move them to the user's episode collection
      for (QueryDocumentSnapshot surgeryDoc in surgerySnapshot.docs) {
    
        Map<String, dynamic>? surgeryData = surgeryDoc.data() as Map<String, dynamic>?;

        if (surgeryData != null) {
          // Update user's episode collection with surgery data under "gallbladder" document
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('surgeries')
              .doc(episodeId)
              .collection('gallbladder')
              .doc('AfterSurgery')
              .collection('Activites')
              .doc() // Create a new document with an auto-generated ID
              .set(surgeryData);

          // Optionally, you may want to delete the original surgery document
          print('Data moved successfully');
        }
      }
      ////////////////////////////////////////////////////////////////////////////////////
      // Get surgery data under "Surgery/Gallbladder/Before" path
      QuerySnapshot surgerySnapshot2 = await FirebaseFirestore.instance
          .collection('Surgery')
          .doc('gallbladder') // Replace with the actual document ID if 'Gallbladder' is a document
          .collection('BeforeSurgery') // Replace with the actual subcollection name
          .doc('BeforeSurgery')
          .collection('Activities')
          .get();
      if (surgerySnapshot2.size > 0) {
        // Iterate through the documents and print the data
        for (QueryDocumentSnapshot doc in surgerySnapshot2.docs) {
          print('Document ID: ${doc.id}');
          print('Data: ${doc.data()}');
        }
      } else {
        print('No documents found in the specified collection.');
      }

      // Iterate through surgery documents and move them to the user's episode collection
      for (QueryDocumentSnapshot surgeryDoc in surgerySnapshot2.docs) {
    
        Map<String, dynamic>? surgeryData = surgeryDoc.data() as Map<String, dynamic>?;

        if (surgeryData != null) {
          // Update user's episode collection with surgery data under "gallbladder" document
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('surgeries')
              .doc(episodeId)
              .collection('gallbladder')
              .doc('BeforeSurgery')
              .collection('Activites')
              .doc() // Create a new document with an auto-generated ID
              .set(surgeryData);

          // Optionally, you may want to delete the original surgery document
          print('Data moved successfully');
        }
      }
      ////////////////////////////////////////////////////////////////////////////////////
      // Get surgery data under "Surgery/Gallbladder/Before" path
      QuerySnapshot surgerySnapshot3 = await FirebaseFirestore.instance
          .collection('Surgery')
          .doc('gallbladder') // Replace with the actual document ID if 'Gallbladder' is a document
          .collection('AtHome') // Replace with the actual subcollection name
          .doc('AtHome')
          .collection('Activities')
          .get();
      if (surgerySnapshot3.size > 0) {
        // Iterate through the documents and print the data
        for (QueryDocumentSnapshot doc in surgerySnapshot3.docs) {
          print('Document ID: ${doc.id}');
          print('Data: ${doc.data()}');
        }
      } else {
        print('No documents found in the specified collection.');
      }

      // Iterate through surgery documents and move them to the user's episode collection
      for (QueryDocumentSnapshot surgeryDoc in surgerySnapshot3.docs) {
    
        Map<String, dynamic>? surgeryData = surgeryDoc.data() as Map<String, dynamic>?;

        if (surgeryData != null) {
          // Update user's episode collection with surgery data under "gallbladder" document
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('surgeries')
              .doc(episodeId)
              .collection('gallbladder')
              .doc('AtHome')
              .collection('Activites')
              .doc() // Create a new document with an auto-generated ID
              .set(surgeryData);

          // Optionally, you may want to delete the original surgery document
          print('Data moved successfully');
        }
      }


    } catch (error) {
      print('Error moving data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data Move App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String episodeId = 'gallbladder';
            await moveSurgeryDataToUserEpisode(episodeId);
          },
          child: Text('Move Surgery Data'),
        ),
      ),
    );
  }
}