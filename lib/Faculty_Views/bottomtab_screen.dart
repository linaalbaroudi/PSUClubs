import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Certificates_view.dart';
import 'package:psu_club/Models/Faculty.dart';
import '../Faculty_Views/clubs_view.dart';
import '../Faculty_Views/FacultyHome_view.dart';
import '../Faculty_Views/Event_view.dart';
import '../Faculty_Views/Profile_view.dart';

class BottomTabsScreen2 extends StatefulWidget {
  static const routeName = '/tabs-screen2';
  BottomTabsScreen2({this.index,this.user});
  final int index;
  final Faculty user;
  @override
  _BottomTabsScreenState2 createState() => _BottomTabsScreenState2();

}

class _BottomTabsScreenState2 extends State<BottomTabsScreen2> {

  void initState() {
    super.initState();
    getArgs(widget.index,widget.user);
  }
  int pindex;
  Faculty passedUser;
  void getArgs(int att1, Faculty att2) {
    pindex = att1;
    passedUser = att2;
  }

  void _selectPage(int index) {
    if (index ==0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FacultyHomeScreenPage(
                user:passedUser
              )));
    }
    setState(() {
      pindex = index;

    });

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      FacultyHomeScreenPage(user:passedUser),
      ClubsScreen(user:passedUser),
      EventView(user:passedUser),
      CertificateView(user:passedUser)
    ];
    return Scaffold(
      body: _pages[pindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: pindex,

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
            backgroundColor:Color(0xff1A033D),
            icon: Icon(Icons.supervisor_account),
            title: Text('Clubs'),
          ),
          BottomNavigationBarItem(
              backgroundColor: Color(0xff1A033D),
              icon: Icon(Icons.event_note),
              title: Text('Events')),
          BottomNavigationBarItem(
              backgroundColor:Color(0xff1A033D),
              icon: Icon(Icons.local_play),
              title: Text('Certificates')),

        ],
      ),
    );
  }
}
