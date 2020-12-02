import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Event_view.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Student_Views/AboutUs_view.dart';
import 'package:psu_club/Student_Views/InternalClubEvent_view.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Student_Views/Profile_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:psu_club/Models/Event.dart' as clubEvent;

import 'Student_drawer.dart';

class Clubevents extends StatefulWidget {
  static const routeName = '/clubevents-view';
  Clubevents({this.exampleClub, this.user, this.app,this.isMemberStatus});
  final Club exampleClub;
  final Student user;
  final FirebaseApp app;
  final bool isMemberStatus;
  @override
  _ClubeventsPageState createState() => _ClubeventsPageState();
}

Container displayClubEvents(Club passedClub, int eventNum, BuildContext context,
    Student passedUser, List<clubEvent.Event> loadedEvents,bool isMemberStatus) {
  //int imageNum=eventNum+1;
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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/images/event.png',
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                loadedEvents[eventNum].title +
                    '\n' +
                    loadedEvents[eventNum].dates[0] +
                    ' \n' +
                    loadedEvents[eventNum].time,
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              FlatButton(
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InternalClubEventView(
                          exampleEvent: loadedEvents[eventNum], user: passedUser, isMemberStaus: isMemberStatus),
                    ),
                  );
                },
                child: Text('Go to Event'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ClubeventsPageState extends State<Clubevents> {
  // void addDate() {
  //   loadedEvents[0].dates.add('2020/10/5');
  // }
  final referenceDB = FirebaseDatabase.instance.reference();
  List<clubEvent.Event> currentEvents = new List<clubEvent.Event>();

  void readData() async {
    var events = referenceDB.child("ClubEvents").child(passedClub.title);
    await events.once().then((DataSnapshot dataSnapshot) {
      currentEvents.clear();
      if (dataSnapshot.value== null)return;
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        clubEvent.Event event = new clubEvent.Event(
             passedClub.leaderID,
            key,
            values[key]["time"],
            values[key]["place"],
            values[key]["poster"],
            values[key]["description"],
            values[key]["department"],
            values[key]["noOfSeats"],
            passedClub,
            values[key]["registrationStatus"]);
        event.dates.add( values[key]["dates"]);
        if (mounted) {
          setState(() {
            currentEvents.add(event);
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getArgs(widget.exampleClub, widget.user,widget.isMemberStatus);
  }

  Club passedClub;
  Student passedStudent;
  bool isMemberStatus;
  void getArgs(Club att1, Student att2,bool att3) {
    passedStudent = att2;
    passedClub = att1;
    isMemberStatus=att3;
  }

  bool entered = false;
  @override
  Widget build(BuildContext context) {
    if(!entered){
      entered= true;
      readData();
    }
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
                Text(passedClub.title + ' Club events'),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < currentEvents.length; i++)
                  displayClubEvents(
                      passedClub, i, context, passedStudent, currentEvents, isMemberStatus),
                if(currentEvents.length==0)Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children:<Widget>[
                      Image.asset(
                          'assets/images/NoAddedActivities.gif',
                          height: 350,
                          width:350,
                          fit: BoxFit.fill
                      ),
                      Text(
                        "Excuse me! There is nothing to show\nI live here",
                        style:TextStyle(
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        endDrawer: StudentDrawer(user: passedStudent),
      ),
    );
  }
  //addDate();

}
