import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/components/button.dart';
import 'package:hackathon_project/components/drawer.dart';
import 'package:hackathon_project/pages/add_new_surgery_page.dart';
import 'package:hackathon_project/pages/new_surgery_page.dart';
import 'package:hackathon_project/pages/surgery_home_page.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
          builder: (context) => const AddNewSurgeryPage(),
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
                members: const [],
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
        title: const Text("My Discharge"),
      ),
      drawer: MyDrawer(
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(children: [
          //Create new surgery
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: goToNewSurgeryPage, child: Text('Add Surgery')),
          ),

          //Show existing surgeries
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
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
                        height: 120,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: GestureDetector(
                          onTap: () => goToSurgeryHomePage(
                            currentUser.uid,
                            post["surgeryName"],
                            post["members"],
                            post.id,
                            post["surgeryStart"],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      post["surgeryName"],
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6),
                                child: CircularPercentIndicator(
                                  radius: 46,
                                  percent: 0.5,
                                  animation: true,
                                  progressColor:
                                      Theme.of(context).primaryColorDark,
                                  backgroundColor: Theme.of(context).hoverColor,
                                  center: Text(
                                    '50%',
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ),
                              )
                            ],
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
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }
}
