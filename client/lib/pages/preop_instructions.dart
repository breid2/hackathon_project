import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(
    const MaterialApp(
      home: PreopInstructionPage(),
    ),
  );
}

class PreopInstructionPage extends StatefulWidget {
  const PreopInstructionPage({
    super.key,
  });

  @override
  _PreopInstructionPageState createState() => _PreopInstructionPageState();
}

class _PreopInstructionPageState extends State<PreopInstructionPage> {

  final currentUser = FirebaseAuth.instance.currentUser!;
  
  final Set<String> _checkedItems = <String>{};

  final Map<String, List<String>> _subItems = {
    "Things To Plan": ["Transportation to hospital", "Organize a ride home after surgery", "Emergency contact person", "House sitter", "Child/pet care"],
    "Activities To Do": ["Do not eat or drink after midnight day of your surgery", "Read the educational material doctor has given you", "Only take medications to hospital if your doctor has directed you, do not take home medications unless directed by nursing staff"],
    "Essentials To Pack": ["Phone", "Charger", "Book", "Travel Insurance", "Shoes/slippers", "Clothes", "Toiletries", "List of medications", "Goals of Care", "Personal Directive"],
    "Items To Leave At Home": ["Valuables", "Weapons", "Alcohol/drugs"]
  };
  final Set<String> _expandedItems = <String>{};

  // Add a reference to the surgery collection
  final CollectionReference surgeryCollection = FirebaseFirestore.instance.collection('surgeries');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-operative Instructions'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display surgery data from the database
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('surgeries')
                      .where('owner', isEqualTo: currentUser.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final surgeries = snapshot.data?.docs; // Use safe navigation

                    if (surgeries == null || surgeries.isEmpty) {
                      return const Text('No data available');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: surgeries.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;

                        DateTime surgeryDateTime = data['surgeryDateTime'] != null && data['surgeryDateTime'] is Timestamp
                            ? (data['surgeryDateTime'] as Timestamp).toDate()
                            : DateTime.now();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Scheduled Surgery:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // Choose the border color
                                  width: 1.0, // Choose the border width
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)), // Adjust the border radius
                              ),
                              padding: const EdgeInsets.all(8.0), // Add padding inside the container
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Adjust alignment as needed
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: "Hospital",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.blue, // Choose a color that fits your design
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": ${data['hospital']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue, // Match the color with the bold part
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: "Surgery Start",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": $surgeryDateTime",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: "Surgeon Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": ${data['surgeonName']}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: "Surgery Name",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ": ${data['surgeryName']}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),



                            const SizedBox(height: 8),
                          ],
                        );
                      }).toList(),
                    );
                  },
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
      ],
    );
  }
}
