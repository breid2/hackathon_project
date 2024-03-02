import 'package:flutter/material.dart';
import 'package:hackathon_project/pages/chat_page.dart';

class FAQPage extends StatelessWidget {
  final List<Item> _data = generateItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  title: Text(
                    _data[index].headerValue,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(_data[index].expandedValue),
                    ),
                    if (_data[index].resources.isNotEmpty)
                      ListTile(
                        title: Text(
                          'Resources:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _data[index].resources,
                          style: TextStyle(color: Colors.blue), // Change the color here
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Need to talk to a nurse directly?',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                ElevatedButton.icon(
                  icon: Icon(Icons.chat),
                  label: Text('Chat with a Nurse'),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ChatPage(user: 'someUser', surgeryID: 'someSurgeryID')),
                    // );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.resources = '',
  });

  String expandedValue;
  String headerValue;
  String resources;
}

List<Item> generateItems() {
  return <Item>[
    Item(
      headerValue: 'Who is an advocate?',
      expandedValue: 'An advocate can be a spouse, partner, family member, friend, or a member of a care team or a third-party advocacy group member.',
    ),
    Item(
      headerValue: 'What is the role of a Third Party Advocate?',
      expandedValue: 'Advocates assist patients and families with bringing forward their complaint or concern. They can also assist in developing questions that patients would like answered.',
    ),
    Item(
      headerValue: 'How does AHS work with Third Party Advocates?',
      expandedValue: 'AHS engages with third party advocates during the Patient Concerns Resolution Process (PCRP) or through a disclosure process. The patient must sign an Authorization of Health Information Act Representative form or Consent to Disclose form, or other acceptable consent document, to allow AHS staff or physicians to discuss confidential health information of the patient in the presence of the identified third party advocate.',
      resources: 'Patient Relations Department: 1-855-550-2555',
    ),
    Item(
      headerValue: 'What is the Patient Concerns Resolution Process?',
      expandedValue: 'The Patient Concerns Resolution Process (PRCP) is a provincially consistent process used to address patient or family complaints about healthcare services or experiences.',
      resources: 'Patient Relations web page: http://www.albertahealthservices.ca/patientfeedback.asp\nPatient Feedback Intake Line: 1-855-550-2555',
    ),
    Item(
      headerValue: 'Why is addressing patient complaints important?',
      expandedValue: 'Addressing patient concerns allows AHS to build relationships with patients and families. Feedback from patients and families provides learning opportunities and contributes to further improvements in the quality of Alberta’s healthcare system.',
    ),
    Item(
      headerValue: 'Where can I learn more about this policy and concerns management?',
      expandedValue: 'For more information on this policy and the Patient Relations Department',
      resources: 'Website: http://insite.albertahealthservices.ca/1883.asp\nPatient Relations: 1-855-550-2555',
    ),
  ];
}