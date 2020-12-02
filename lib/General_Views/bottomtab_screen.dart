import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/Certificates_view.dart';
import '../General_Views/clubs_view.dart';
import '../General_Views/home_view.dart';
import '../General_Views/Event_view.dart';
import '../General_Views/Profile_view.dart';

class BottomTabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  BottomTabsScreen({this.index});
  final int index;
  //final FirebaseApp app;
  @override
  _BottomTabsScreenState createState() => _BottomTabsScreenState();
}

class _BottomTabsScreenState extends State<BottomTabsScreen> {
  //FirebaseApp app;
  void initState() {
    super.initState();
    getIndex(widget.index);
   // app=widget.app;
  }
  int pindex;
  void getIndex(int passedInd) {
    pindex = passedInd;
  }

  void _selectPage(int index) {
    if (index ==0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreenPage(
              )));
    }
    setState(() {
      pindex = index;
    });
  }

  final List<Widget> _pages = [
    //pages
    HomeScreenPage(),
    ClubsScreen(),
    EventView(),
    CertificateView()
  ];





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _pages[pindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: pindex,
        backgroundColor: Color(0xff1A033D),
        //type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(

            backgroundColor:Color(0xff1A033D),
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
