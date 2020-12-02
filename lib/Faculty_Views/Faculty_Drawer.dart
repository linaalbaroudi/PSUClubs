import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Faculty_Views/Profile_view.dart';
import 'package:psu_club/Faculty_Views/AboutUs_view.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/sign_in.dart';

class FacultyDrawer extends StatelessWidget {
  FacultyDrawer({this.user});
  final Faculty user;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
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
            ListTile(
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              leading: Icon(
                Icons.account_box,
                color: Color(0xFFF19F42),
                size: 30,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileView(
                          user: this.user,
                        )));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text(
                'About us ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              leading: Icon(
                Icons.help,
                color: Color(0xFFF19F42),
                size: 30,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutUsView(
                          user: this.user,
                        )));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              leading: Icon(
                Icons.logout,
                color: Color(0xFFF19F42),
                size: 30,
              ),
              onTap: () {
                signOutGoogle();
                Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
