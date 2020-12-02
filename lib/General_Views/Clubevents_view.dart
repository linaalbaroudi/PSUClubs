import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/Guest_Drawer.dart';
import 'package:psu_club/General_Views/InternalClubEvent_view.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Event.dart' as clubEvent;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Clubevents extends StatefulWidget {
  static const routeName = '/clubevents-view';

  final FirebaseApp app;
  final Club passedClub;
  Clubevents({this.passedClub, this.app});

  @override
  _ClubeventsState createState() => _ClubeventsState();
}

class _ClubeventsState extends State<Clubevents> {
  @override
  void initState() {
    super.initState();
    getClub(widget.passedClub);
  }

  Club passedClub;
  void getClub(Club att2) {
    passedClub = att2;
  }

  final referenceDb = FirebaseDatabase.instance.reference();

  List<clubEvent.Event> currentEvents = new List<clubEvent.Event>();
  void readData() async {
    var events = referenceDb.child("ClubEvents").child(passedClub.title);
    await events.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value== null)return;
      currentEvents.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        clubEvent.Event clubEv = new clubEvent.Event(
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
        clubEv.dates.add(values[key]["dates"]);
        if (mounted){
          setState(() {
            currentEvents.add(clubEv);
          });  }
     //  print(currentEvents[0]);
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
                  displayClubEvents(passedClub, i, context, currentEvents),
                if( currentEvents.length==0)Padding(
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
        endDrawer: GuestDrawer(),
      ),
    );
  }
}

Container displayClubEvents(Club passedClub, int eventNum, BuildContext context,
    List<clubEvent.Event> loadedEvents) {
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
                    ' ' +
                    loadedEvents[eventNum].time,
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              FlatButton(
                color: Color(0xFFF19F42),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InternalClubEventView(
                            exampleEvent: loadedEvents[eventNum])),
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
