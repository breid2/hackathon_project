import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              stream: FirebaseFirestore.instance.collection('Hospital').snapshots(),
              builder: (context, snapshot){
                List<DropdownMenuItem> hospitalItems = [];

                if (!snapshot.hasData){
                  const CircularProgressIndicator();
                }
                else{
                final hospitals = snapshot.data?.docs.reversed.toList();
                hospitalItems.add(const DropdownMenuItem(
                  value: "0",
                  child: Text('Select')));

                for(var hospital in hospitals!){
                  hospitalItems.add(DropdownMenuItem(
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
                print(hospitalValue);
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
              stream: FirebaseFirestore.instance.collection('Surgery').snapshots(),
              builder: (context, snapshot){
                List<DropdownMenuItem> surgeryItems = [];

                if (!snapshot.hasData){
                  const CircularProgressIndicator();
                }
                else{
                final surgeries = snapshot.data?.docs.reversed.toList();
                surgeryItems.add(const DropdownMenuItem(
                  value: "0",
                  child: Text('Select')));

                for(var surgery in surgeries!){
                  surgeryItems.add(DropdownMenuItem(
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
                print(surgeryValue);
              },
              value: selectedHospital,
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
                //enabledBorder: OutlineInputBorder(
                //  borderSide: BorderSide(color: Colors.black)
                //),
                //focusedBorder: OutlineInputBorder(
                //  borderSide: BorderSide(color: Colors.blue)
                //),
              ),
              readOnly: true,
              onTap: (){
                selectDate();
              }
            ),  

            const SizedBox(height: 75),

            // Create Surgery Button
            ElevatedButton(
              onPressed: (){},
              child: const Text('Create Surgery'),
            ),         
          ],
        ),
      ),
    );
  }

// Select Date Method
  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if(_picked != null){
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }

  } 
}
