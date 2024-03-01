import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddNewSurgeryPage extends StatefulWidget {
  const AddNewSurgeryPage({super.key});

  @override
  _AddNewSurgeryPageState createState() => _AddNewSurgeryPageState();
}

class _AddNewSurgeryPageState extends State<AddNewSurgeryPage> {

  final TextEditingController _dateController = TextEditingController();

  String _dropDownValue1 = 'Surgery 1';

  final _surgeryTypes = [
    'Surgery 1',
    'Surgery 2',
    'Surgery 3',
    'Surgery 4',
    'Surgery 5'
  ];

  String _dropDownValue2 = 'Hospital 1';

  final _hospitals = [
    'Hospital 1',
    'Hospital 2',
    'Hospital 3',
    'Hospital 4',
    'Hospital 5'
  ];

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
              'select hospital:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffEBEDFE),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: DropdownButton(
                  items: _hospitals.map((String item){
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item)
                      );
                  }).toList(),
                  onChanged: (String? newValue){
                    setState((){
                      _dropDownValue2 = newValue!;
                    });
                  },
                  value: _dropDownValue2,
                  underline: Container()
                  )
              ),
            ),


            const SizedBox(height: 75),

            // Surgery Selection Drop Down Widget 
            const Text(
              'select surgery:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xffEBEDFE),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: DropdownButton(
                  items: _surgeryTypes.map((String item){
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item)
                      );
                  }).toList(),
                  onChanged: (String? newValue){
                    setState((){
                      _dropDownValue1 = newValue!;
                    });
                  },
                  value: _dropDownValue1,
                  underline: Container()
                  )
              ),
            ),

            const SizedBox(height: 75),

            // Date Picker Widget
            const Text(
              'select surgery date:',
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
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)
                ),
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
