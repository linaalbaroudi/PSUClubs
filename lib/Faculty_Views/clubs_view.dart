import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/AddClub_view.dart';
import 'package:psu_club/Faculty_Views/InternalClub_view.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Faculty_Drawer.dart';

class ClubsScreen extends StatelessWidget {
  static const routeName = '/clubs-view';
  ClubsScreen({this.user, this.app});
  final Faculty user;
  final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    //addDate();
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:  Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Text('Clubs'),
          ),
        ),
        body: ClubPage(user: this.user),
        endDrawer: FacultyDrawer(user: this.user),
      ),
    );
  }
}

class ClubPage extends StatefulWidget {
  ClubPage({this.user});
  final Faculty user;
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  @override
  void initState() {
    super.initState();
    getUser(widget.user);
  }

  Faculty passedUser;
  void getUser(Faculty att1) {
    passedUser = att1;
  }

  List<Club> currentClubs = new List();
  void readData() async{
    final referenceDb = FirebaseDatabase.instance.reference();
    var clubs = referenceDb.child("Clubs");
    await clubs.once().then((DataSnapshot dataSnapshot) async {
      currentClubs.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        String name = "";
        var faculty = referenceDb.child("Faculty").child(values[key]["leader"]);
       await faculty.once().then((DataSnapshot datasnapshot2){
          name= datasnapshot2.value["name"];
        });
        Faculty owner;
        if (name==passedUser.name){
          owner = passedUser;
        }else {
          owner = new Faculty (values[key]["leader"], name,
              values[key]["leader"] + "@psu.edu.sa");
        }

        Club club = new Club( owner, key,
            values[key]["logo"], values[key]["description"]);
       // print(club);
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

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                width: 300,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color(0xff1A033D),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddClub(user: passedUser)),
                    );
                  },
                  child: Text(
                    'Add Club',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              for (int i = 0; i < currentClubs.length; i++)
                displayClubs(passedUser, i, context,currentClubs),
            ],
          ),
        ),
      ),
    );
  }
}

Container displayClubs(Faculty passedUser, int clubNum, BuildContext context, List<Club> loadedClubs) {

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
              ),
              FlatButton(
                color: Color(0xFFF19F42),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InternalClubsView(
                            user: passedUser, exampleClub: loadedClubs[clubNum])),
                  );
                },
                child: Text('Go to Club!'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}