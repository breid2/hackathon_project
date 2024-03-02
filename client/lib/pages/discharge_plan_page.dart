import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DischargePlanPage extends StatefulWidget {
  const DischargePlanPage({super.key});

  @override
  State<DischargePlanPage> createState() => _DischargePlanPageState();
}

class _DischargePlanPageState extends State<DischargePlanPage> {
  final dateOfDischarge = DateTime.parse('2024-07-20 20:18:04Z'); // reference

  final patientName = "John Smith"; // Placeholder for patient name variable

  // Sample data for the table
  final List<Map<String, String>> namesAndRoles = [
    { "Name": "Abel Tesfaye", 
      "Role": "Caregiver / Family Contact"},
    { "Name": "Homey McHomerson", 
      "Role": "Caregiver / Family Contact"},
    { "Name": "Andre Young", 
      "Role": "Doctor"},
    { "Name": "Florence Nightingale", 
      "Role": "Nurse"},
    { "Name": "Joy", 
      "Role": "HCA"},
  ];

  final List<String> _checklistItems = [
    "Wound Care",
    "Medically Stable",
    "Mobilize",
    "Pain",
    "Trasportation",
    "Medication",
    "Physiotherapy",
    "Supplies",
    "Feelings about discharge",
    "Bladder",
    "Bowels",
  ];

  // final Set<String> _checkedItems = <String>{};
  // A map to hold the selected value for each group.
  final Map<String, String> _selectedItems = <String, String>{};

  final Map<String, String> _itemsDecriptions = {
    "Wound Care": "Received directions how to care for wound(s) and/or seen by transition services and home care arranged (if needed).",
    "Medically Stable": "Cleared by all medical teams involved in my care (Surgeon, Internal Medicine, Cardiology, etc.)",
    "Mobilize": "Mobilizing at least 3 times per day (or as recommended by physiotherapy). Up in chair for all meals.",
    "Pain": "Pain controlled",
    "Trasportation": "Ride home",
    "Medication": "Medication(s) have been reviewed by MD and/or Pharmacist, discussed with patient",
    "Physiotherapy": "At baseline mobility level (prior to hospital admission) or new mobility level, passed by physiotherapy",
    "Supplies": "Oxygen, equipment dressing supplies organized and at home.",
    "Feelings about discharge": "How are you/your caregiver going to manage at home?",
    "Bladder": "Is your bladder functioning in its pre surgery state?",
    "Bowels": "Have you had a bowel movement? or are you having diarrhea and unable to control your bowels",
  };

  final Map<String, List<String>> _subItems = {
    "Wound Care": ["Yes", "Ongoing", "Paused", "N/A"],
    "Medically Stable": ["Yes", "Ongoing", "Paused"],
    "Mobilize": ["Yes", "No"],
    "Pain": ["Yes", "No"],
    "Trasportation": ["Yes", "No"],
    "Medication": ["Yes", "No", "N/A"],
    "Physiotherapy": ["Yes", "Ongoing", "Paused", "N/A"],
    "Supplies": ["Done", "Ongoing concern", "Paused", "N/A"],
    "Feelings about discharge": ["Concerns addressed", "Ongoing concerns", "No concerns"],
    "Bladder": ["Yes", "No", "Ongoing concern"],
    "Bowels": ["Yes", "Ongoing concern"],
  };
  final Set<String> _expandedItems = <String>{};


  // @TODO:
  // create variables that pull from firebase
  // patient name

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Discharge Plan"),
        ),
        body: Container( // Container added here
        padding: EdgeInsets.all(8.0), // Optional: Add padding if needed
        child:
          SingleChildScrollView( // Allows for scrolling when content doesn't fit on the screen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.info_rounded), // Example icon
                      subtitle: Text('Lay out the specifics of the discharge plan to make sure that everyone is on the same page.'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Patient Name')),
                      DataColumn(label: Text('Expected Discharge Date')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text(patientName)),
                          DataCell(Text(DateFormat('MMMM d, yyyy').format(dateOfDischarge))),
                        ],
                      ),
                    ],
                  ),
                ),
                // Names and Roles table
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Role')),
                    ],
                    rows: namesAndRoles.map((role) => DataRow(
                        cells: [
                          DataCell(Text(role["Name"]!)),
                          DataCell(Text(role["Role"]!)),
                        ],
                      )).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'The Primary Objective',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                // Objective and Success Metrics table
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true, // Set to true if you want the scrollbar to always be visible
                    thickness: 6.0, // Can be adjusted for the scrollbar thickness
                    radius: Radius.circular(5.0), // Can be adjusted for the scrollbar radius
                    scrollbarOrientation: ScrollbarOrientation.bottom, // Positions scrollbar at the bottom
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Objective'), numeric: false),
                          DataColumn(label: Text('Success Metrics'), numeric: false),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text('To go home and recover from surgery and pain is managed.')),
                              DataCell(Text('Medically stable')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('')), // Empty cell for alignment
                              DataCell(Text('Pain under control')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('')), // Empty cell for alignment
                              DataCell(Text('Wound not draining')),
                            ],
                          ),
                        ], 
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Task List',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 4),
                _buildChecklist(CupertinoIcons.bandage, "Wound Care", _itemsDecriptions["Wound Care"]!, Colors.red.shade100),
                _buildChecklist(CupertinoIcons.heart_circle, "Medically Stable", _itemsDecriptions["Medically Stable"]!, Colors.red.shade100),
                _buildChecklist(Icons.run_circle_outlined, "Mobilize", _itemsDecriptions["Mobilize"]!, Colors.red.shade100),
                _buildChecklist(Icons.adjust, "Pain", _itemsDecriptions["Pain"]!, Colors.red.shade100),
                _buildChecklist(IconData(0xe1d7, fontFamily: 'MaterialIcons'), "Trasportation", _itemsDecriptions["Trasportation"]!, Colors.teal.shade100),
                _buildChecklist(Icons.medication_rounded, "Medication", _itemsDecriptions["Medication"]!, Colors.teal.shade100),
                _buildChecklist(Icons.back_hand_outlined, "Physiotherapy", _itemsDecriptions["Physiotherapy"]!, Colors.teal.shade100),
                _buildChecklist(Icons.widgets_rounded, "Supplies", _itemsDecriptions["Supplies"]!, Colors.teal.shade100),
                _buildChecklist(Icons.emoji_emotions, "Feelings about discharge", _itemsDecriptions["Feelings about discharge"]!, Colors.deepPurple.shade100),
                _buildChecklist(Icons.wc, "Bladder", _itemsDecriptions["Bladder"]!, Colors.grey.shade100),
                _buildChecklist(Icons.wc, "Bowels", _itemsDecriptions["Bowels"]!, Colors.brown.shade100),
                const SizedBox(height: 8),
                // Other widgets go here
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildChecklist(IconData listIcon, String header, String itemText, Color color) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            color: color,
            child: ExpansionTile(
              leading: Icon(listIcon),
              title: Text(
                header,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              children: _subItems.containsKey(header)
                  ? <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                          child: Text(
                            itemText, // Text to display above the radio buttons
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      ..._subItems[header]!
                          .map(
                            (subItem) => RadioListTile<String>(
                              title: Text(
                                subItem,
                                style: const TextStyle(fontSize: 14),
                              ),
                              value: subItem,
                              groupValue: _selectedItems[header],
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedItems[header] = value!;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ]
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