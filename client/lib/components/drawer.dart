import 'package:flutter/material.dart';
import 'package:hackathon_project/components/my_list_tile.dart';
import 'package:hackathon_project/pages/chat_page.dart';
import 'package:hackathon_project/pages/at_home_checklist.dart';

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

            //chat list tile
            MyListTile(
              icon: Icons.chat,
              text: 'Chat',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          user: '',
                        )),
              ),
            ),

            //at home check list tile
            MyListTile(
              icon: Icons.list, 
              text: 'At-Home Checklist',
              // onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChecklistPage())),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChecklistPage()),
                );
              },
            ),

          ],
        ),

        //logout list tile
        MyListTile(icon: Icons.logout, text: 'Logout', onTap: onSignOut),
      ]),
    );
  }
}
