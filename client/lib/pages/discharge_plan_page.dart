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
    {"Name": "Abel Tesfaye", "Role": "Caregiver / Family Contact"},
    {"Name": "Homey McHomerson", "Role": "Caregiver / Family Contact"},
    {"Name": "Andre Young", "Role": "Doctor"},
    {"Name": "Florence Nightingale", "Role": "Nurse"},
    {"Name": "Joy", "Role": "HCA"},
  ];

  // @TODO:
  // create variables that pull from firebase
  // patient name

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Discharge Plan"),
        ),
        body: SingleChildScrollView( // Allows for scrolling when content doesn't fit on the screen
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
                )
              ),
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     'Task List',
              //     style: Theme.of(context).textTheme.headlineMedium,
              //   ),
              // ),
              // Other widgets go here
            ],
          ),
        ),
      );
    }
}