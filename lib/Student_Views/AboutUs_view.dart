import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Student_Views/Profile_view.dart';

import 'Student_drawer.dart';

class AboutUsView extends StatelessWidget {
  AboutUsView({this.user});
  final Student user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(' About Us'),
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              // heightFactor: 1,
              child: Card(
                elevation: 7,
                //margin: EdgeInsets.all(5.0),
                child: Container(
                  height: 500,
                  width: 310,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'PSUClubs',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Color.fromARGB(255,        240, 130, 0)),
                      ),
                      Text(
                        '\nThis app was developed by:\n\n   - Lina Albaroudi\n   - Halah Murad\n   - Tala Almashat\n   - Ghada Alateeq\nSupervised by: Dr Souad Larabi\n',
                        style: TextStyle(fontSize: 16,),
                      ),
                      Text(
                        'We are Software Engineering senior PSU students who are making this application as a graduation project in SE499 course at Prince Sultan University.',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '\nNote this app is only a demo and all data stored and displayed in this app does not relate to real PSU events',
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                      Text(
                        '\n\n\n\u00a9 2020 Prince Sultan University, All Rights Preserved ',
                        style: TextStyle(fontSize: 10, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        endDrawer: StudentDrawer(user:this.user),
        ),
      );
  }
}
