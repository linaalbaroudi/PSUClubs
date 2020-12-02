import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Event.dart' as uniEvent;
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Student_Views/InternalEvent_view.dart';
import 'Student_drawer.dart';

//make stateful
class EventView extends StatelessWidget {
  static const routeName = '/EventView';
  EventView({this.user});
  final Student user;
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
              padding: const EdgeInsets.all(20.0),
              child: EventsPage(
                user: this.user,
              ),
            ),
          ),
        ),
        endDrawer: StudentDrawer(user: this.user),
      ),
    );
  }
}

class EventsPage extends StatefulWidget {
  EventsPage({this.user, this.app});
  final Student user;
  final FirebaseApp app;
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  void initState() {
    super.initState();
    getUser(widget.user);
  }

  Student passedStudent;
  void getUser(Student att2) {
    passedStudent = att2;
  }

  List<uniEvent.Event> currentUniEvents = new List<uniEvent.Event>();
  final referenceDB = FirebaseDatabase.instance.reference();
  readData() async {
    var uniEvents = referenceDB.child("UniEvents");
    await uniEvents.once().then((DataSnapshot dataSnapshot) async  {
      currentUniEvents.clear();
      if (dataSnapshot.value== null)return;
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        String name = "";
        var faculty = referenceDB.child("Faculty").child(values[key]["leader"]);
        await faculty.once().then((DataSnapshot datasnapshot2){
          var values2 = datasnapshot2.value;
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
      // crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>[
        // SizedBox(
        //   height:15,
        // ),
        for (int i = 0; i < currentUniEvents.length; i++)
          displayEvents(currentUniEvents[i], context, passedStudent),
      ],
    );
  }
}

Container displayEvents(
    uniEvent.Event loadedEvents, BuildContext context, Student passedStudent) {
  //int imageNum=eventNum+1;
  // void addDate() {
  //   loadedEvents[0].dates.add('2020/10/5');
  //   loadedEvents[1].dates.add('2020/10/6');
  //   loadedEvents[2].dates.add('2020/10/7');
  // }

  //addDate();
  return Container(
    //alignment: Alignment.center,
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
                loadedEvents.title +
                    '\n' +
                    loadedEvents.dates[0] +
                    ' at ' +
                    loadedEvents.time,
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
                        builder: (context) => InternalEventView(
                              exampleEvent: loadedEvents,
                              user: passedStudent,
                            )),
                  );
                },
                child: Text('Go to Event'),
              ),
              SizedBox(
                height:15,
              ),


            ],
          ),
        ),

      ],
    ),
  );
}
