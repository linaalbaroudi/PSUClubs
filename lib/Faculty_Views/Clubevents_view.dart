import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Faculty_Views/InternalClubEvent_view.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Faculty_Views/AddClubEvent_view.dart';
import 'package:psu_club/Models/Event.dart'as clubEvent;
import 'package:psu_club/Models/Faculty.dart';

class Clubevents extends StatefulWidget {
  Clubevents({this.exampleClub, this.user});
  final Club exampleClub;
  final Faculty user;
  static const routeName = '/clubevents-view';
  _ClubeventsPageState createState() => _ClubeventsPageState();
}

class _ClubeventsPageState extends State<Clubevents> {
  @override
  void initState() {
    super.initState();
    getArgs(widget.exampleClub, widget.user);
  }

  Club passedClub;
  Faculty passedUser;
  void getArgs(Club att1, Faculty att2) {
    passedUser = att2;
    passedClub = att1;
  }
  final referenceDB = FirebaseDatabase.instance.reference();
  List<clubEvent.Event> currentEvents = new List<clubEvent.Event>();

  void readData() async {
    try{
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
        passedClub.clubEvents=currentEvents;
      });
    }catch(e){
      if(e.contains("NoSuchMethodError"))
        print("No addedClub events");
    }


  }
Container ownerButton(){
  if (passedClub.leaderID.userID != passedUser.userID) {
return Container();}
else return Container(
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
                  builder: (context) => AddClubEvent(
                      exampleClub: passedClub,
                      user: passedUser)));
      },
      child: Text(
        'Add Club event',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ),
  );
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ownerButton(),
                  SizedBox(
                    height: 20,
                  ),
                  for (int i = 0; i < passedClub.clubEvents.length; i++)
                    displayClubEvents(passedClub, i, context, passedUser),
                  if(passedClub.clubEvents.length==0)Padding(
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
        ),
        endDrawer: FacultyDrawer(user: passedUser),
      ),
    );
  }
}

void _showDialog1(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('You must be leader of the club to add events! ')));
}

Container displayClubEvents(
    Club passedClub, int eventNum, BuildContext context, Faculty passedUser) {
  List<clubEvent.Event> loadedEvents= passedClub.clubEvents;
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
                    loadedEvents[eventNum].place +
                    '\n' +
                    loadedEvents[eventNum].time +
                    '\n' +
                    loadedEvents[eventNum].dates[0],
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
                            exampleEvent: loadedEvents[eventNum],
                            user: passedUser)),
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
