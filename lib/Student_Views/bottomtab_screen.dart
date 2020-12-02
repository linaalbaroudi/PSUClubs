import 'package:flutter/material.dart';
//import 'package:psu_club/Faculty_Views/Profile_view.dart';
import 'package:psu_club/Student_Views/Certificates_view.dart';
import 'package:psu_club/Models/Student.dart';
import '../Student_Views/clubs_view.dart';
import '../Student_Views/home_view.dart';
import '../Student_Views/Event_view.dart';
import '../Student_Views/Profile_view.dart';

class BottomTabsScreen3 extends StatefulWidget {
  static const routeName = '/tabs3-screen';

  BottomTabsScreen3({this.index, this.user});
  final int index;
  final Student user;
  @override
  _BottomTabsScreenState createState() => _BottomTabsScreenState();
}

class _BottomTabsScreenState extends State<BottomTabsScreen3> {
  @override
  void initState() {
    super.initState();
    getArgs(widget.index, widget.user);
  }

  int passedIndex;
  Student passedUser;
  void getArgs(int att1, Student att2) {
    passedIndex = att1;
    passedUser = att2;
  }

  void _selectPage(int index) {
    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentHomeScreenPage(user: passedUser)));
    }
    setState(() {
      passedIndex = index;
    });
  }

  List<Widget> _pages = new List();
  // void _selectPage(int index) {
  //   setState(() {
  //     passedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _pages = [
      //pages
      StudentHomeScreenPage(
        user: passedUser,
      ),
      ClubsScreen(
        user: passedUser,
      ),
      EventView(user: passedUser),
      CertificateView(user: passedUser)
    ];
    return Scaffold(
      body: _pages[passedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: passedIndex,

        //type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xff1A033D),
            icon: Icon(
              Icons.home,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xff1A033D),
            icon: Icon(Icons.supervisor_account),
            title: Text('Clubs'),
          ),
          BottomNavigationBarItem(
              backgroundColor: Color(0xff1A033D),
              icon: Icon(Icons.event_note),
              title: Text('Events')),
          BottomNavigationBarItem(
              backgroundColor: Color(0xff1A033D),
              icon: Icon(Icons.local_play),
              title: Text('Certificates')),
        ],
      ),
    );
  }
}
