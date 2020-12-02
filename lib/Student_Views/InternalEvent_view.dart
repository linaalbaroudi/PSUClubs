import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Event.dart'as uniEvent;
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';
import 'package:psu_club/Student_Views/AboutUs_view.dart';
import 'package:psu_club/Student_Views/Profile_view.dart';
import 'package:psu_club/Student_Views/Student_drawer.dart';
import 'package:psu_club/Student_Views/VolunteerInEvent.dart';


class InternalEventView extends StatefulWidget {
  static const routeName = '/Internal-event-view';
  InternalEventView({this.exampleEvent, this.user});
  final uniEvent.Event exampleEvent;
  final Student user;
  @override
  _InternalEventViewState createState() => _InternalEventViewState();
}

class _InternalEventViewState extends State<InternalEventView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showDialog(String message, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 1)));
  }
  void initState() {
    super.initState();
    getArgs(widget.exampleEvent, widget.user);
  }

  uniEvent.Event passedEvent;
  Student passedStudent;
  void getArgs(uniEvent.Event att1, Student att2) {
    passedStudent = att2;
    passedEvent = att1;
  }
bool isRegistered = false;
  void readData() async{
    final referenceDb = FirebaseDatabase.instance.reference();
    var vp = referenceDb.child("UniEvents").child(passedEvent.title).child("volunteeringPositions");
   await vp.once().then((DataSnapshot datasnapshot){
      passedEvent.volunteeeringOpportunity.clear();
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;
      for (var key2 in keys ){
        if (mounted){
          setState(() {
            passedEvent.volunteeeringOpportunity.add(new VolunteeringPosition(key2,values[key2]["date"],values[key2]["time"],values[key2]["description"],values[key2]["noOfPositions"]));

          });
        }
      }
    });
    if (passedEvent.registrationStatus==true){
      var rm = referenceDb.child("UniEvents").child(passedEvent.title).child("registeredMembers");
     await rm.once().then((DataSnapshot datasnapshot2){
        passedEvent.registeredMembers.clear();
        var keys2 = datasnapshot2.value.keys;
        var values2 = datasnapshot2.value;
        for (var key2 in keys2 ){
          if (key2=="000000000")continue;
          if (mounted){
            setState(() {
              passedEvent.registeredMembers.add(new Student(key2,values2[key2],values2[key2]+"@psu.edu.sa"));
              if (key2 ==passedStudent.userID) isRegistered=true;
            });
          }
        }
      });
    }
  }
  Container rgButton(){
    if (passedEvent.registrationStatus==false)
      return Container();
    else
      return Container(
        height: 50,
        width: 150,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            //for now keep like this

            if (passedEvent.noOfSeats <=
                passedEvent.registeredMembers.length) {
              _showDialog(
                  'Registration Seats are full! ', context);
            } else if (isRegistered) {
              _showDialog('Cancelled Successfully', context);
              setState(() {
                passedEvent.registeredMembers.remove(passedStudent);
                passedEvent.deleteMember(passedStudent);
                isRegistered = !isRegistered;
              });
            } else {
              _showDialog('Successfully Registered! ', context);
              setState(() {
                passedEvent.registeredMembers.add(passedStudent);
                passedEvent.addMember(passedStudent);
                isRegistered = !isRegistered;
              });
            }
          },
          child: isRegistered
              ? Text(
            "Cancel Registration",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )
              : Text(
            "Register",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          color: !isRegistered ? Color(0xff1A033D) : Colors.red,
        ), //registration
      );
  }
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
                Text(passedEvent.title + ' Event',
                style: TextStyle(
                  fontSize: 18
                ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      passedEvent.getImage(),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          passedEvent.title +
                              '\n' +
                              passedEvent.dates[0] +
                              '\n' +
                              passedEvent.time +
                              '\n' +
                              passedEvent.place,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                         // textAlign:TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                      //    padding: EdgeInsets.all(15),
                          alignment: Alignment.topLeft,
                          child: Text(
                            passedEvent.description,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              //textAlign:TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      rgButton(),
                      (passedEvent.registrationStatus==false)?SizedBox():SizedBox(
                        width:30,
                      ),
                      Container(
                        height: 50,
                        width: (passedEvent.registrationStatus==false)?300:150,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xff1A033D),
                          onPressed: () {
                          if (passedEvent.volunteeeringOpportunity.isEmpty) {
                          _showDialog('No Volunteering Position', context);}
                          else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VolunteerInEvent(
                                          exampleEvent: passedEvent,
                                          user: passedStudent,
                                        )));
                          }  },
                          child: Text(
                            'Volunteer',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
