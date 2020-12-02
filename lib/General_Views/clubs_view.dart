import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:psu_club/General_Views/Guest_Drawer.dart';
import 'package:psu_club/General_Views/InternalClub_view.dart';
import 'package:psu_club/Models/Faculty.dart';

class ClubsScreen extends StatelessWidget {
  static const routeName = '/clubs-view';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Text('Clubs'),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ClubPage(),
            ),
          ),
        ),
        endDrawer: GuestDrawer(),
      ),
    );
  }
}

class ClubPage extends StatefulWidget {
  ClubPage({this.app});
  final FirebaseApp app;
  @override
  _ClubPageState createState() => _ClubPageState();
}

Container displayClubs(int clubNum, List<Club> loadedClubs, BuildContext context) {
  //int imageNum=clubNum+1;
   return Container(
     decoration: BoxDecoration(
       color: Colors.white,
       border: Border(
         //top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
         bottom: BorderSide(width: 2, color: Colors.grey.shade100),
       ),),
     padding: EdgeInsets.all(10),
     child: Row(
      children: <Widget>[
        loadedClubs[clubNum].getImage(),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                loadedClubs[clubNum].title,
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              FlatButton(
                color: Color(0xFFF19F42),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InternalClubsView(
                              exampleCl: loadedClubs[clubNum],
                            )),
                  );
                },
                child: Text('Go to Club'),
              ),
            ],
          ),
        ),
      ],
  ),
   );
}

class _ClubPageState extends State<ClubPage> {

  List<Club> currentClubs = new List<Club>();
  void initState() {
    super.initState();

  }
  void readData()async {
    final referenceDb = FirebaseDatabase.instance.reference();
    var clubs = referenceDb.child("Clubs");
    await clubs.once().then((DataSnapshot dataSnapshot)async  {
      currentClubs.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        String name = "";
        var faculty = referenceDb.child("Faculty").child(values[key]["leader"]);
       await faculty.once().then((DataSnapshot datasnapshot2){
         name = datasnapshot2.value["name"];
        });
        Club club = new Club(
          new Faculty (values[key]["leader"],name,values[key]["leader"]+"@psu.edu.sa"), key,
            values[key]["logo"], values[key]["description"]);
        if (mounted){
            setState(() {
            currentClubs.add(club);
          });
        }
      }
    });

  }
  bool entered = false;
  @override
  Widget build(BuildContext context) {
    if(!entered){
      entered= true;
      readData();
    }
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < currentClubs.length; i++)
           displayClubs(i, currentClubs, context),
      ],
    );
  }
}
