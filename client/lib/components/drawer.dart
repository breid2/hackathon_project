import 'package:flutter/material.dart';
import 'package:hackathon_project/components/my_list_tile.dart';
import 'package:hackathon_project/pages/chat_page.dart';
import 'package:hackathon_project/pages/discharge_progress_page.dart';
import 'package:hackathon_project/pages/at_home_checklist.dart';
import 'package:hackathon_project/pages/date_of_discharge_page.dart';
import 'package:hackathon_project/pages/Stepper.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  const MyDrawer({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            //header
            const DrawerHeader(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              ),
            ),

            //home list tile
            MyListTile(
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.pop(context),
            ),

            MyListTile(
              icon: Icons.wheelchair_pickup,
              text: 'Discharge Progress',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DischargeProgressPage(
                          user: '',
                        )),
              ),
            ),

            MyListTile(
              icon: Icons.calendar_today,
              text: 'Expected Date of Discharge',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DateOfDischargePage()),
              ),
            ),

            //at home check list tile
            MyListTile(
              icon: Icons.home_work,
              text: 'At-Home Checklist',
              // onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChecklistPage())),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChecklistPage()),
                );
              },
            ),

             MyListTile(
              icon: Icons.checklist,
              text: 'Discharge Checklist',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StepperScreen(
                  ))
              )
            )

          ],
        ),

        //logout list tile
        MyListTile(icon: Icons.logout, text: 'Logout', onTap: onSignOut),
      ]),
    );
  }
}
