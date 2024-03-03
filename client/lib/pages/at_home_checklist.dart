import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}
class _ChecklistPageState extends State<ChecklistPage> {
  final List<String> _checklistItems = [
    "Time Of Surgery",
    "Medication Instructions",
    "Don't drink alcohol 24 hrs before",
    "Shower",
    "Bowel Prep if req'd",
    "Remove jewellery",
    "Packing List",
  ];
  final Set<String> _checkedItems = <String>{};

  final Map<String, List<String>> _subItems = {
    "Packing List": [
      "Photo ID",
      "Alberta Health Care Card",
      "Medications",
      "CPAP Machine (optional)"
    ],
  };

  final Set<String> _expandedItems = <String>{};

  // A map to associate each checklist item with an icon.
  final Map<String, IconData> _itemIcons = {
    "Time Of Surgery": Icons.access_time,
    "Medication Instructions": Icons.medication,
    "Don't drink alcohol 24 hrs before": Icons.no_drinks,
    "Shower": Icons.shower,
    "Bowel Prep if req'd": Icons.wc,
    "Remove jewellery": Icons.noise_control_off,
    "Packing List": Icons.backpack,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('At-Home Checklist'),
      ),
      body: ListView.builder(
        itemCount: _checklistItems.length,
        itemBuilder: (context, index) {
          final item = _checklistItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _subItems.containsKey(item)
                ? _buildExpansionTile(item)
                : _buildChecklistTile(item),
          );
        },

      ),
    );
  }

  Widget _buildChecklistTile(String item) {
    return Card(
      color: Colors.grey.shade200,
      child: CheckboxListTile(
        title: Text(
          item,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        value: _checkedItems.contains(item),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _checkedItems.add(item);
            } else {
              _checkedItems.remove(item);
            }
          });
        },
        secondary: Icon(_itemIcons[item]), // Use the icon from the map
      ),
    );
  }

  Widget _buildExpansionTile(String item) {
    return Card(
      color: Colors.grey.shade200,
      child: ExpansionTile(
        leading: Icon(_itemIcons[item]), // Use the icon from the map
        title: Text(
          item,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: _subItems[item]!
            .map((subItem) => CheckboxListTile(
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
                ))
            .toList(),
        onExpansionChanged: (bool expanded) {
          setState(() {
            if (expanded) {
              _expandedItems.add(item);
            } else {
              _expandedItems.remove(item);
            }
          });
        },
      ),
    );
  }
}
