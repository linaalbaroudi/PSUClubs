import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Event_view.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Student_Views/AboutUs_view.dart';
import 'package:psu_club/Student_Views/InternalWorkshop_view.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Workshop.dart';
import 'package:psu_club/Student_Views/Profile_view.dart';
import 'package:psu_club/Student_Views/Student_drawer.dart';

class WorkshopsView extends StatefulWidget {
  static const routeName = '/workshops-view';
  WorkshopsView({this.exampleClub, this.user, this.app, this.isMemberStatus});
  final Club exampleClub;
  final Student user;
  final FirebaseApp app;
  final bool isMemberStatus;
  @override
  _WorkshopsViewState createState() => _WorkshopsViewState();
}

Container displayWorkshops(Club passedClub, int workshopNum, BuildContext context,
    Student passedStudent, List<Workshop> loadedWorkshops, bool isMemberStatus) {
  //int imageNum=eventNum+1;
  passedClub.workshops = loadedWorkshops;
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        //top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
        bottom: BorderSide(width: 2, color: Colors.grey.shade100),
      ),),
    padding: EdgeInsets.all(15),
    child: Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/images/workshop.png',
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
                loadedWorkshops[workshopNum].title +
                    '\n' +
                    loadedWorkshops[workshopNum].place +
                    ' ' +
                    loadedWorkshops[workshopNum].time.toString(),
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
                        builder: (context) => InternalWorkshopView(
                          exampleWorkshop: loadedWorkshops[workshopNum],
                          user: passedStudent,isMemberStatus:isMemberStatus
                        )),
                  );
                },
                child: Text('Go to Workshop'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _WorkshopsViewState extends State<WorkshopsView> {
  // void addDate() {
  //   loadedEvents[0].dates.add('2020/10/5');
  // }
  final referenceDb = FirebaseDatabase.instance.reference();
  List<Workshop> currentWorkshops = new List<Workshop>();
  List<String> dates = new List<String>();

  void readData() async {
    var workshops = referenceDb.child("ClubWorkshops").child(passedClub.title);
    await workshops.once().then((DataSnapshot dataSnapshot) {
      currentWorkshops.clear();
      if (dataSnapshot.value== null)return;
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;
      for (var key in keys) {
        Workshop clubWorkshop = new Workshop(
           passedClub.leaderID,
           key,
            values[key]["time"],
            values[key]["place"],
            values[key]["poster"],
            values[key]["description"],
            values[key]["department"],
            values[key]["noOfSeats"],
            passedClub);
        for (int i = 0; i < values[key]["Dates"].length; i++) {
          clubWorkshop.dates.add(values[key]["Dates"][i]);
        }
        // dates = values[key]["dates"];
        // _clubWorkshop.dates = dates;
        if (mounted) {
          setState(() {
            currentWorkshops.add(clubWorkshop);
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
bool isMemberStatus;
  Club passedClub;
  Student passedStudent;
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
                Text(passedClub.title + ' Workshops'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (int i = 0; i < currentWorkshops.length; i++)
                    displayWorkshops(passedClub, i, context, passedStudent,
                        currentWorkshops,isMemberStatus),
                  if(currentWorkshops.length==0)Padding(
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
        endDrawer: StudentDrawer(user: passedStudent),
      ),
    );
  }
}
