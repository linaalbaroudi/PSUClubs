import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Guest_Drawer.dart';
import 'package:psu_club/Models/Event.dart' as uniEvent;
import 'package:psu_club/General_Views/InternalEvent_view.dart';
import 'package:psu_club/Models/Faculty.dart';

class EventView extends StatelessWidget {
  static const routeName = '/EventView';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Text(' Events'),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: EventsPage(),
            ),
          ),
        ),
        endDrawer: GuestDrawer(),
      ),
    );
  }
}

class EventsPage extends StatefulWidget {
  EventsPage({this.app});
  final FirebaseApp app;
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final referenceDb = FirebaseDatabase.instance.reference();

  List<uniEvent.Event> currentUniEvents = new List<uniEvent.Event>();

  void readData() async {
    var events = referenceDb.child("UniEvents");
    await events.once().then((DataSnapshot dataSnapshot) async {
      currentUniEvents.clear();
      if (dataSnapshot.value== null)return;
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        String name = "";
        var faculty = referenceDb.child("Faculty").child(values[key]["leader"]);
        await faculty.once().then((DataSnapshot datasnapshot2){
          var values2 = dataSnapshot.value;
          name = values2["name"];
        });
        uniEvent.Event event = new uniEvent.Event(
             new Faculty (values[key]["leader"],name,values[key]["leader"]+"@psu.edu.sa"),
            key,
            values[key]["time"],
            values[key]["place"],
            values[key]["poster"],
            values[key]["description"],
            values[key]["department"],
            values[key]["noOfSeats"],
            null,
            values[key]["registrationStatus"]);
        event.dates.add( values[key]["dates"]);
        if (mounted){
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
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < currentUniEvents.length; i++)
          displayEvents(context, currentUniEvents[i]),
      ],
    );
  }
}

Container displayEvents(BuildContext context, uniEvent.Event _event) {
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
                _event.title + '\n' + _event.dates[0] + ' ' + _event.time,
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
                              exampleEvent: _event,
                            )),
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
