import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final Set<String> _checkedItems = <String>{};

  // Consider adding more categories as per your requirements
  final Map<String, List<String>> _subItems = {
    "Before Surgery": ["Time Of Surgery", "Medication Instructions", "Don't drink alcohol 24 hrs before", "Shower", "Bowel Prep if req'd", "Remove jewellery"],
    "Packing List": ["Photo ID", "Alberta Health Care Card", "Medications", "CPAP Machine (optional)"],
  };

  final Set<String> _expandedItems = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('At-Home Checklist'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _subItems.keys.map((String header) => _buildChecklist(header)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecklist(String header) {
    return Column(
      children: [
        Card(
          child: ExpansionTile(
            title: Text(
              header,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: _subItems[header]!
                .map(
                  (subItem) => CheckboxListTile(
                    title: Text(subItem),
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
                .toList(),
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
      ],
    );
  }
}