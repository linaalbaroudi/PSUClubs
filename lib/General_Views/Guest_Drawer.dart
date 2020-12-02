import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/General_Views/AboutUs_view.dart';

class GuestDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:250,
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                // color:Color(0xff1A033D),
              ),
              child: Image.asset('assets/images/PSUClubsLogo.jpg'),
            ),
            SizedBox(
              height:30,
            ),
            ListTile(
              title: Text('About us ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              leading:  Icon(
                Icons.help,
                color: Color(0xFFF19F42),
                size:30,
              ),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) =>AboutUsView()));
              },

            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text('login',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              leading: Icon(
                Icons.login,
                color: Color(0xFFF19F42),
                size:30,
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
          ],
        ),
      ),);
  }
}
