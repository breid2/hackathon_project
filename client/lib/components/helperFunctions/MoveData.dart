import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoveData extends StatelessWidget {
  static Future<void> moveSurgeryDataToUserEpisode(String episodeId) async {
    try {

      String SurgeyType = 'gallbladder';
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      List<String> stages = ['AfterSurgery', 'BeforeSurgery', 'AtHome'];

      for (String stage in stages) {
        await _moveDataForStage(SurgeyType, userId, episodeId, stage);
      }
    } catch (error) {
      print('Error moving data: $error');
    }
  }

  static Future<void> _moveDataForStage(
    String SurgeyType,
    String? userId,
    String episodeId,
    String stage
    ) async {
      try {
        // Now you can use the customVariable in your function logic.

        // Get surgery data under "Surgery/SurgeyType/{stage}" path
        QuerySnapshot surgerySnapshot = await FirebaseFirestore.instance
            .collection('Surgery')
            .doc(SurgeyType)
            .collection(stage)
            .doc(stage)
            .collection('Activities')
            .get();

        if (surgerySnapshot.size > 0) {
          // Iterate through the documents and print the data
          for (QueryDocumentSnapshot doc in surgerySnapshot.docs) {
            print('Stage: $stage');
            print('Document ID: ${doc.id}');
            print('Data: ${doc.data()}');
          }
        } else {
          print('No documents found in the specified collection for stage: $stage');
        }

        // Iterate through surgery documents and move them to the user's episode collection
        for (QueryDocumentSnapshot surgeryDoc in surgerySnapshot.docs) {
          Map<String, dynamic>? surgeryData =
              surgeryDoc.data() as Map<String, dynamic>?;

          if (surgeryData != null) {
            // Update user's episode collection with surgery data under "SurgeyType" document
            await FirebaseFirestore.instance
                .collection('surgeries')
                .doc(episodeId)
                .collection(stage)
                .doc(stage)
                .collection('Activities')
                .doc() // Create a new document with an auto-generated ID
                .set(surgeryData);

            // Optionally, you may want to delete the original surgery document
            print('Data moved successfully for stage: $stage');
            await FirebaseFirestore.instance
              .collection('surgeries')
              .doc(episodeId)
              .collection(stage)
              .doc(stage)
              .set({
                'Progress': 0,
            });


          }

        }
      } catch (error) {
      print('Error moving data for stage $stage: $error');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
