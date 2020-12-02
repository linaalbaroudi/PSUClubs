import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/AboutUs_view.dart';
import 'package:psu_club/Faculty_Views/AddUniEvent.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Faculty_Views/Profile_view.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Event.dart' as uniEvent;
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Faculty_Views/InternalEvent_view.dart';
import 'package:psu_club/Faculty_Views/AddClubEvent_view.dart';

PSU_User anees = new Faculty('AAra', 'Anees Ara', 'aara@psu.edu.sa');

class EventView extends StatelessWidget {
  static const routeName = '/EventView';
  EventView({this.user});
  final Faculty user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:  Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Text(' Events'),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: EventsPage(user: this.user),
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user: this.user),
      ),
    );
  }
}

class EventsPage extends StatefulWidget {
  EventsPage({this.user});
  final Faculty user;
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  void initState() {
    super.initState();
    getUser(widget.user);
  }

  Faculty passedUser;
  void getUser(Faculty att2) {
    passedUser = att2;
  }

  List<uniEvent.Event> currentUniEvents = new List<uniEvent.Event>();
  final referenceDB = FirebaseDatabase.instance.reference();
  readData() async{
    var uniEvents = referenceDB.child("UniEvents");
    await uniEvents.once().then((DataSnapshot dataSnapshot)async {
      currentUniEvents.clear();
      if (dataSnapshot.value== null)return;
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        String name = "";
        var faculty = referenceDB.child("Faculty").child(values[key]["leader"]);
        await faculty.once().then((DataSnapshot datasnapshot2) {
          var values2 = datasnapshot2.value;
          name = values2["name"];
        });
        uniEvent.Event event = new uniEvent.Event(
            new Faculty(values[key]["leader"], name,
                values[key]["leader"] + "@psu.edu.sa"),
            key,
            values[key]["time"],
            values[key]["place"],
            values[key]["poster"],
            values[key]["description"],
            values[key]["department"],
            values[key]["noOfSeats"],
            null,
            values[key]["registrationStatus"]);
        event.dates.add(values[key]["dates"]);
        if (mounted) {
          setState(() {
            currentUniEvents.add(event);
          });
        }

        // print(currentUniEvents[0]);
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
                    builder: (context) => AddUniEvent(user: passedUser)),
              );
            },
            child: Text(
              'Add Event',
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
        for (int i = 0; i < currentUniEvents.length; i++)
          displayEvents(i, context, passedUser, currentUniEvents),
      ],
    );
  }
}

Container displayEvents(int eventNum, BuildContext context, Faculty passedUser,
    List<uniEvent.Event> loadedEvents) {

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
                loadedEvents[eventNum].title + '\n' + loadedEvents[eventNum].dates[0] + ' ' + loadedEvents[eventNum].time,
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
                        builder: (context) => InternalEventView(
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
