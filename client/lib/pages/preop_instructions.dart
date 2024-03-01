
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PreopInstructionPage extends StatefulWidget {
  const PreopInstructionPage({
    super.key,
  });

  @override
  _PreopInstructionPageState createState() => _PreopInstructionPageState();
}

class _PreopInstructionPageState extends State<PreopInstructionPage> {
  // Controller for the text field
  final TextEditingController _textFieldController = TextEditingController();

  // List to store checklist items
  final List<bool> _checklistItems = [false, false, false, false];
  // final List<bool> _checklistItems = List.generate(4, (index) => false);

  // Variable to store the selected date
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-operative Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form at the top
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text field for entering data
                  TextFormField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital',
                      hintText: 'Fill in surgery location', // Placeholder text
                      labelStyle: TextStyle(
                        color: Colors.blue, // You can set the color you prefer
                      ),
                    ),
                  ),
                  // Date input field
                  DateTimeField(
                    decoration: const InputDecoration(
                      labelText: 'Select Date',
                      hintText: 'Select surgery date',
                    ),
                    format: DateFormat("yyyy-MM-dd"),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                        context: context,
                        initialDate: currentValue ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                    },
                    onChanged: (selectedDate) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(
                      labelText: "Surgeon's Name",
                      hintText: "Fill in surgeon's name", // Placeholder text
                      labelStyle: TextStyle(
                        color: Colors.blue, // You can set the color you prefer
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(
                      labelText: "Surgery",
                      hintText: "Fill in name of surgery", // Placeholder text
                      labelStyle: TextStyle(
                        color: Colors.blue, // You can set the color you prefer
                      ),
                    ),
                  ),
                  // Button to submit form
                  ElevatedButton(
                    onPressed: () {
                      // Handle form submission here
                      print('Hospital: ${_textFieldController.text}');
                      print('Surgery Date: $_selectedDate');
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Spacer

            // Checklist in the middle
            // const Text(
            //   'Things To Plan:',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // GridView.builder(
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 1, // Change this to 4 for four columns
            //     crossAxisSpacing: 8.0,
            //     mainAxisSpacing: 8.0,
            //   ),
            //   itemCount: _checklistItems.length,
            //   shrinkWrap: true,
            //   itemBuilder: (context, index) {
            //     return CheckboxListTile(
            //       title: const Row(
            //         children: [
            //           SizedBox(width: 8.0), // Add spacing between text and checkbox
            //           Text(
            //             'Transportation to hospital',
            //             style: TextStyle(
            //               color: Colors.black, // Set the color you prefer
            //               fontSize: 14.0, // Adjust the font size
            //             ),
            //           ),
            //         ],
            //       ),
            //       value: _checklistItems[index],
            //       onChanged: (value) {
            //         setState(() {
            //           _checklistItems[index] = value!;
            //         });
            //       },
            //     );
            //   },
            // ),

            const Text(
              'Things To Plan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              dense: true,
              title: const Text('Transportation to hospital'),
              value: _checklistItems[0],
              onChanged: (value) {
                setState(() {
                  _checklistItems[0] = value!;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              title: const Text('Organize a ride home after surgery'),
              value: _checklistItems[1],
              onChanged: (value) {
                setState(() {
                  _checklistItems[1] = value!;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              title: const Text('Emergency contact person'),
              value: _checklistItems[2],
              onChanged: (value) {
                setState(() {
                  _checklistItems[2] = value!;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              title: const Text('House sitter'),
              value: _checklistItems[2],
              onChanged: (value) {
                setState(() {
                  _checklistItems[2] = value!;
                });
              },
            ),
            CheckboxListTile(
              dense: true,
              title: const Text('Child care/Pet care'),
              value: _checklistItems[2],
              onChanged: (value) {
                setState(() {
                  _checklistItems[2] = value!;
                });
              },
            ),
            const SizedBox(height: 16), // Spacer

            // Text at the bottom
            const Text(
              'This is the text at the bottom of the page.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
