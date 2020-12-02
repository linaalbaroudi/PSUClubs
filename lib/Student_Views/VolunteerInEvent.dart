import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Activity.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Event.dart'as uniEvent;
import 'package:psu_club/Models/VolunteeringPosition.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:intl/intl.dart' as intl;
import 'package:psu_club/Student_Views/AboutUs_view.dart';
import 'package:psu_club/Student_Views/Profile_view.dart';
import 'package:psu_club/Student_Views/Student_drawer.dart';

class VolunteerInEvent extends StatefulWidget {
  static const routeName = '/VolunteerInEvent';
  VolunteerInEvent({this.exampleEvent, this.user});
  final uniEvent.Event exampleEvent;
  final Student user;
  @override
  _VolunteerInEventState createState() => _VolunteerInEventState();
}

List<bool> status = new List();
List<bool> vpLengthChecker = new List();
List<bool> isVolunteered = new List();
class _VolunteerInEventState extends State<VolunteerInEvent> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getArgs(widget.exampleEvent, widget.user);
  }

  Student passedStudent;
  uniEvent.Event passedEvent;

  void getArgs(uniEvent.Event att1, Student att2) {
    passedEvent = att1;
    passedStudent = att2;
  }
  void _showDialog(String message, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 1),));
  }
  void readData() async{
    for (int i =0;i<passedEvent.volunteeeringOpportunity.length;i++){
      final referenceDb = FirebaseDatabase.instance.reference();
      var vp = referenceDb.child("UniEvents").child(passedEvent.title).child("volunteeringPositions").child(passedEvent.volunteeeringOpportunity[i].key).child("volunteers");
      await vp.once().then((DataSnapshot datasnapshot){
        passedEvent.volunteeeringOpportunity[i].volunteers.clear();
        var keys = datasnapshot.value.keys;
        var values = datasnapshot.value;
        for (var key in keys ){
          if (key == "000000000") {
            continue;
          }
          if (mounted){
            setState(() {
              passedEvent.volunteeeringOpportunity[i].volunteers.add(new Student (key,values[key],key+"@psu.edu.sa"));
              if(key ==passedStudent.userID){
                if (isVolunteered.isEmpty)
                  isVolunteered.add(true);
                else
                  isVolunteered[i]=true;
              }
              //   print(passedActivity.volunteeeringOpportunity[i].volunteers.length);
            });
          }
        }

          if (vpLengthChecker.isEmpty){
            if(passedEvent.volunteeeringOpportunity[i].volunteers.length==passedEvent.volunteeeringOpportunity[i].numberOfPositions)
              vpLengthChecker.add(true);
            else
              vpLengthChecker.add(false);
          }else {
            if (passedEvent.volunteeeringOpportunity[i].volunteers.length ==
                passedEvent.volunteeeringOpportunity[i].numberOfPositions)
              vpLengthChecker[i] = (true);
            else
              vpLengthChecker[i] = (false);
          }
      }); // ignore: unrelated_type_equality_checks

    }

  }
  Card checkboxFormField(VolunteeringPosition vp,int i, BuildContext coxt) {
    status.add(false);
    if (isVolunteered.isEmpty ||vpLengthChecker.isEmpty){
      isVolunteered.clear();vpLengthChecker.clear();
      isVolunteered.add(false);
      vpLengthChecker.add(false);
      isVolunteered.add(false);
      vpLengthChecker.add(false);
    }
    //  print(vp.volunteers.length);
    // setState(() {
    //    print(vpLengthChecker);
    //    print(isVolunteered);

    //   readData();
    if (vpLengthChecker[i]==true && isVolunteered[i]==false) {
      //readData();
      print("entered");
      return Card(
        child: Row(
        ),
      );
    }
    //});
    // (isVolunteered[i])?status[i]=true:status[i]=status[i];
    //print(vp.volunteers.length);
    return Card(
      child: Row(
        children: [
          Checkbox(      //
            value:(isVolunteered[i]),
            checkColor:Color(0xff1A033D),
            onChanged: (checked) {
              setState(() {
                //  status[i] = checked;
                if (checked==true &&!isVolunteered[i]&&!vpLengthChecker[i]) {
                  vp.writeMembers("UniEvents",null,passedEvent,passedStudent);
                  isVolunteered[i]=true;
                  checked = true;
                  _showDialog('Successfully volunteered',context);
                  if (vp.volunteers.length>=vp.numberOfPositions) vpLengthChecker[i]=true;
                } else {
                  vp.deleteMember("UniEvents",null,passedEvent,passedStudent);
                  isVolunteered[i]=false;
                  checked = false;
                  _showDialog('Successfully cancelled volunteering',context);
                  if (vp.volunteers.length<vp.numberOfPositions) vpLengthChecker[i]=false;
                  //  readData();
                }
              });
            },
          ),
          Expanded(
            child: displayVP(vp),
          ),
        ],
      ),
    );
  }

  final _volunteerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    readData();
    return MaterialApp(
      home: Scaffold(
        key:_scaffoldKey,
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
                Text('Volunteer in an event'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  displayActivity(passedEvent, context),
                  SizedBox(
                    height:20,
                  ),
                  Form(
                    key: _volunteerFormKey,
                    child: Column(
                      children: <Widget>[
                        for (int i = 0;i < passedEvent.volunteeeringOpportunity.length;i++)
                          checkboxFormField(passedEvent.volunteeeringOpportunity[i],i, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        endDrawer: StudentDrawer(user:passedStudent),
      ),
    );
  }
}
Column displayActivity(Activity  activity, BuildContext context) {
  return Column(
    children: <Widget>[
      activity.getImage(),
      SizedBox(
        height: 15,
      ),
      FittedBox(
        child: Text(
          activity.title,
          style: TextStyle(
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        fit: BoxFit.fitHeight,),
    ],
  );
}
// display check boxes on available Volunteering opportunities for the student to choose from
Row displayVP(VolunteeringPosition vp) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(
          'Date: ' + vp.date + '\n Time: ' + vp.time,
        ),
      ),
      Expanded(
        child: Text(vp.description),
      ),
    ],
  );
}
