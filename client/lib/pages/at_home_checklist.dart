import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget{
  const ChecklistPage({super.key});

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  //We will add our checklist logic here
  final List <String> _checklistItems = ["Time Of Surgery", "Medication Instructions", "Don't drink alcohol 24 hrs before ", 
  "Packing List", "Bowel Prep if req'd", "Remove jewellery", "Shower"];

  final Set <String> _checkedItems = <String>{};

  //Additional state to manage expanded items
  final Map<String, List<String>> _subItems = {
    "Packing List": ["Photo ID", "Alberta Health Care Card", "Medications", "CPAP Machine (optional)"],
  };
  final Set<String> _expandedItems = <String>{};

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('At-Home Checklist'),
    ),
    body: ListView.separated(
      itemCount: _checklistItems.length,
      itemBuilder: (context, index) {
        final item = _checklistItems[index];
        // Apply padding only to the items (not to the dividers)
        return Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding value as needed
          child: item.startsWith("Packing List") && _subItems.containsKey(item) // Adjust condition as needed
              ? ExpansionTile(
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
                )
              : CheckboxListTile(
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
                ),
        );
      },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey, // Customize the color of the divider
          thickness: 5.0, // Customize the thickness of the divider
        ),
      ),
    );
}
}