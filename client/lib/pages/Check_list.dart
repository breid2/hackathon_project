import 'package:flutter/material.dart';

class ChecklistPageG extends StatefulWidget {
  final String workFlow;

  const ChecklistPageG({Key? key, required this.workFlow}) : super(key: key);

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPageG> {
  //We will add our checklist logic here
  

  List<String> _checklistItems = [
    "Time Of Surgery",
    "Medication Instructions",
    "Don't drink alcohol 24 hrs before ",
    "Shower",
    "Bowel Prep if req'd",
    "Remove jewellery",
    "Packing List"
  ];

  final Set<String> _checkedItems = <String>{};

  //Additional state to manage expanded items
  final Map<String, List<String>> _subItems = {
    "Packing List": [
      "Photo ID",
      "Alberta Health Care Card",
      "Medications",
      "CPAP Machine (optional)"
    ],
  };
  final Set<String> _expandedItems = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workFlow),
      ),
      body: ListView.separated(
        itemCount: _checklistItems.length,
        itemBuilder: (context, index) {
          final item = _checklistItems[index];
          // Apply padding only to the items (not to the dividers)
          return Padding(
            padding:
                const EdgeInsets.all(8.0), // Adjust padding value as needed
            child: item.startsWith("Packing List") &&
                    _subItems.containsKey(item) // Adjust condition as needed
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
        separatorBuilder: (context, index) => Divider(
          color: const Color.fromARGB(
              255, 156, 41, 41), // Customize the color of the divider

          thickness: 5.0, // Customize the thickness of the divider
        ),
      ),
    );
  }
}
