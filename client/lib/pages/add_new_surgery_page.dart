import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon_project/components/button.dart';
import 'package:hackathon_project/components/helperFunctions/MoveData.dart';


class AddNewSurgeryPage extends StatefulWidget {
  const AddNewSurgeryPage({super.key});

  @override
  _AddNewSurgeryPageState createState() => _AddNewSurgeryPageState();
}

class _AddNewSurgeryPageState extends State<AddNewSurgeryPage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _dateController = TextEditingController();

  String selectedHospital = "0";
  String selectedSurgery = "0";
  DateTime? surgeryDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Surgery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Hospital Selection Drop Down Widget
             const Text(
              'Hospital:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                .collection('Hospital')
                .snapshots(),
              builder: (context, snapshot){
                List<DropdownMenuItem> hospitalItems = [];
                if (!snapshot.hasData){
                  const CircularProgressIndicator();
                }
                else{
                  final hospitals = snapshot.data?.docs.reversed.toList();
                  hospitalItems.add(
                    const DropdownMenuItem(
                      value: "0",
                      child: Text('Select')));

                  for(var hospital in hospitals!){
                    hospitalItems.add(
                      DropdownMenuItem(
                        value: hospital.id,
                        child: Text(
                          hospital.id)));
                  } 
                }

                return DropdownButton(
                  items: hospitalItems, 
                  onChanged: (hospitalValue){
                    setState((){
                      selectedHospital = hospitalValue;
                    });
                  print(selectedHospital);
                },
                value: selectedHospital,
                isExpanded: false,
              );   
            }
          ),

            const SizedBox(height: 75),

            // Surgery Selection Drop Down Widget 
             const Text(
              'Surgery:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                .collection('Surgery')
                .snapshots(),
              builder: (context, snapshot){
                List<DropdownMenuItem> surgeryItems = [];
                if (!snapshot.hasData){
                  const CircularProgressIndicator();
                }
                else{
                  final surgeries = snapshot.data?.docs.reversed.toList();
                  surgeryItems.add(
                    const DropdownMenuItem(
                      value: "0",
                      child: Text('Select')));

                  for(var surgery in surgeries!){
                    surgeryItems.add(
                      DropdownMenuItem(
                        value: surgery.id,
                        child: Text(
                          surgery.id)));
                  } 
                }

                return DropdownButton(
                  items: surgeryItems, 
                  onChanged: (surgeryValue){
                    setState((){
                      selectedSurgery = surgeryValue;
                    });
                  print(selectedSurgery);
                },
                value: selectedSurgery,
                isExpanded: false,
              );   
            }
          ),

            const SizedBox(height: 75),

            // Date Picker Widget
            const Text(
              'Surgery Date:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: (){
                selectDate();
              }
            ),  

            const SizedBox(height: 25),

            // Create Surgery Button
            MyButton(onTap: createSurgery, text: 'Create Surgery'),        
          ],
        ),
      ),
    );
  }


  // Select Date Method
  Future<void> selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if(selectedDate != null){
      setState(() {
        _dateController.text = selectedDate.toString().split(" ")[0];
        surgeryDate = selectedDate;
      });
    }
  }


  // Create Surgery Method
  Future<void> createSurgery() async { 
    if ((selectedSurgery != "0") && (surgeryDate != null)) {
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
          'surgeryName': selectedSurgery,
          'surgeryStart': Timestamp.fromDate(surgeryDate!),
          "ownerEmail": currentUser.email,
          "ownerUsername": currentUser.displayName,
          "timeStamp": Timestamp.now(),
          "owner": currentUser.uid,
          "members": [currentUser.uid, 'ity0IuvNBDQTWW6j9oQo73ffgBj2'],
          "memberInfo": membersInfo,
        });
        print(result.id);
        MoveData myHomePage = MoveData();
        MoveData.moveSurgeryDataToUserEpisode(result.id);

        SnackBar(content: Text(currentUser.toString()));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating surgery: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields!')),
      );
    }
  }
}
