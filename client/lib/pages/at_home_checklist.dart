import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget{
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  //We will add our checklist logic here
  List <String> _checklistItems = ["Time Of Surgery", "Medication Instructions", "Don't drink alcohol 24 hrs before ", 
  "Packing List", "Bowel Prep if req'd", "Remove jewellery", "Shower"];

  Set <String> _checkedItems = Set<String>();

  //Additional state to manage expanded items
  Map<String, List<String>> _subItems = {
    "Packing List": ["Photo ID", "Alberta Health Care Card", "Medications", "CPAP Machine (optional)"],
  };
  Set<String> _expandedItems = Set<String>();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('At-Home Checklist'),
    ),
    body: ListView.builder(
      itemCount: _checklistItems.length,
      itemBuilder: (context, index) {
        final item = _checklistItems[index];
        if (_subItems.containsKey(item)) {
            return ExpansionTile(
              title: Text(item),
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
            );
          } else {
            return CheckboxListTile(
              title: Text(item),
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
            );
          }
        },
      ),
    );
  }
}