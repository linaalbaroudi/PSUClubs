import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/InternalWorkshop_view.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Workshop.dart';
import 'package:psu_club/Faculty_Views/AddWorkshop_view.dart';

import 'Faculty_Drawer.dart';

class WorkshopsView extends StatefulWidget {
  static const routeName = '/workshops-view';
  WorkshopsView({this.exampleClub, this.user, this.app});
  final Club exampleClub;
  final Faculty user;
  final FirebaseApp app;
  @override
  _WorkshopsViewState createState() => _WorkshopsViewState();
}

class _WorkshopsViewState extends State<WorkshopsView> {
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
  List<Workshop> currentWorkshops = new List<Workshop>();
  void readData()async{
    var workshops = referenceDB.child("ClubWorkshops").child(passedClub.title);
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

  Container ownerButton() {
    if (passedClub.leaderID.userID != passedUser.userID) {
      return Container();
    } else {
      return Container(
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
                    builder: (context) => AddClubWorkshop(
                        exampleClub: passedClub, user: passedUser)));
          },
          child: Text(
            'Add Club Workshop',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
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
          preferredSize:  Size.fromHeight(60.0),
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
                Text(passedClub.title + ' workshops'),
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
                  for (int i = 0; i < currentWorkshops.length; i++)
                    displayWorkshops(
                        passedClub, i, context, passedUser, currentWorkshops),
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
        endDrawer: FacultyDrawer(user: passedUser),
      ),
    );
  }
}

void _showDialog1(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('You must be leader of the club to add workshops! ')));
}

Container displayWorkshops(Club passedClub, int workshopNum, BuildContext context,
    Faculty passedUser, List<Workshop> loadedWorkshops) {
  passedClub.workshops=loadedWorkshops;
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
                    '\n Starting from: ' +
                    loadedWorkshops[workshopNum].dates[0] +
                    '\n at ' +
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
                            user: passedUser)),
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
