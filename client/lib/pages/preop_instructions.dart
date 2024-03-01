import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    const MaterialApp(
      home: PreopInstructionPage(),
    ),
  );
}

class PreopInstructionPage extends StatefulWidget {
  const PreopInstructionPage({
    Key? key,
  }) : super(key: key);

  @override
  _PreopInstructionPageState createState() => _PreopInstructionPageState();
}

class _PreopInstructionPageState extends State<PreopInstructionPage> {
  final TextEditingController _hospitalController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _surgeonNameController = TextEditingController();
  final TextEditingController _surgeryController = TextEditingController();

  final List<String> _checklistItems = [
    "Things To Plan",
    "Activities To Do",
    "Essentials To Pack",
    "Items To Leave At Home",
  ];

  final Set<String> _checkedItems = <String>{};

  final Map<String, List<String>> _subItems = {
    "Things To Plan": ["Transportation to hospital", "Organize a ride home after surgery", "Emergency contact person", "House sitter", "Child/pet care"],
    "Activities To Do": ["Do not eat or drink after midnight day of your surgery", "Read the educational material doctor has given you", "Only take medications to hospital if your doctor has directed you, do not take home medications unless directed by nursing staff"],
    "Essentials To Pack": ["Phone", "Charger", "Book", "Travel Insurance", "Shoes/slippers", "Clothes", "Toiletries", "List of medications", "Goals of Care", "Personal Directive"],
    "Items To Leave At Home": ["Valuables", "Weapons", "Alcohol/drugs"]
  };
  final Set<String> _expandedItems = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-operative Instructions'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true, // Always show the scrollbar
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          controller: _hospitalController,
                          decoration: const InputDecoration(
                            labelText: 'Hospital',
                            hintText: 'Fill in surgery location',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DateTimeField(
                        style: const TextStyle(fontSize: 14),
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
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          controller: _surgeonNameController,
                          decoration: const InputDecoration(
                            labelText: "Surgeon's Name",
                            hintText: "Fill in surgeon's name",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14),
                          controller: _surgeryController,
                          decoration: const InputDecoration(
                            labelText: "Surgery",
                            hintText: "Fill in name of surgery",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print('Hospital: ${_hospitalController.text}');
                          print('Surgery Date: $_selectedDate');
                          print("Surgeon's Name: ${_surgeonNameController.text}");
                          print("Surgery: ${_surgeryController.text}");
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                _buildChecklist("Things To Plan", Colors.cyan.shade100),
                _buildChecklist("Activities To Do", Colors.indigo.shade100),
                _buildChecklist("Essentials To Pack", Colors.green.shade100),
                _buildChecklist("Items To Leave At Home", Colors.deepOrange.shade100),
                const SizedBox(height: 8),
                // Text display area at the bottom with header and bullets
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "What's Next?",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        color: Colors.grey[200],
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Stay calm', style: TextStyle(fontSize: 14)),
                            Text('• Review hospital admission and discharge information', style: TextStyle(fontSize: 14)),
                            Text('• Make a list of questions for surgeon/nurse regarding your surgery/hospitalization if you have any', style: TextStyle(fontSize: 14)),
                            // Add more bullet points as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklist(String header, Color color) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            color: color,
            child: ExpansionTile(
              title: Text(
                header,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              children: _subItems.containsKey(header)
                  ? _subItems[header]!
                      .map(
                        (subItem) => CheckboxListTile(
                          title: Text(
                            subItem,
                            style: const TextStyle(fontSize: 14),
                          ),
                          value: _checkedItems.contains(subItem),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _checkedItems.add(subItem);
                              } else {
                                _checkedItems.remove(subItem);
                              }
                            });
                          },
                        ),
                      )
                      .toList()
                  : [],
              onExpansionChanged: (bool expanded) {
                setState(() {
                  if (expanded) {
                    _expandedItems.add(header);
                  } else {
                    _expandedItems.remove(header);
                  }
                });
              },
            ),
          ),
        ),
        // const Divider(
        //   color: Colors.grey,
        //   thickness: 0.5,
        // ),
      ],
    );
  }
}
