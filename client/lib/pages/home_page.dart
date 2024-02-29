import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/components/button.dart';
import 'package:hackathon_project/components/drawer.dart';
import 'package:hackathon_project/pages/new_surgery_page.dart';
import 'package:hackathon_project/pages/surgery_home_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //User? currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  //sign out user
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //go to new surgery page
  void goToNewSurgeryPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewSurgeryPage(),
        ));
  }

  //go to surgery page
  void goToSurgeryHomePage(
    String user,
    surgeryName,
    members,
    surgeryID,
    surgeryStart,
  ) async {
    DateTime surgeryDateTime = DateTime.parse(surgeryStart.toDate().toString());
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SurgeryHomePage(
                surgeryStart: surgeryDateTime,
                members: [],
                surgeryName: surgeryName,
                surgeryID: surgeryID,
                user: currentUser.uid,
                time: Timestamp.now().toString(),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("My Discharge"),
      ),
      drawer: MyDrawer(
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(children: [
          //Create new surgery
          MyButton(onTap: goToNewSurgeryPage, text: 'Add Surgery'),

          //Show existing surgeries
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .collection('surgeries')
                  .where('members', arrayContains: currentUser.uid)
                  .orderBy('surgeryStart', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //get the surgery
                      final post = snapshot.data!.docs[index];
                      DateTime surgeryStartDate = post["surgeryStart"].toDate();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(surgeryStartDate);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Set border color here
                            width: 1.0, // Set border width here
                          ),
                          borderRadius: BorderRadius.circular(
                              8.0), // Set border radius here
                        ),
                        child: GestureDetector(
                          onTap: () => goToSurgeryHomePage(
                            currentUser.uid,
                            post["surgeryName"],
                            post["members"],
                            post.id,
                            post["surgeryStart"],
                          ),
                          child: ListTile(
                            title: Text(
                              post["surgeryName"],
                            ),
                            subtitle: Text(formattedDate),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          //logged in as
          Text(
            "Logged in as: ${currentUser.email!}",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }
}
