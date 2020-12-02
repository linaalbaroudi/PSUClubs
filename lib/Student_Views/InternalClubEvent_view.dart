import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';
import 'package:psu_club/Models/Event.dart'as clubEvent;
import 'package:psu_club/Student_Views/Student_drawer.dart';
import 'package:psu_club/Student_Views/VolunteerInActivity_view.dart';

class InternalClubEventView extends StatefulWidget {
  static const routeName = '/Internal-club-event-view';
  InternalClubEventView({this.exampleEvent, this.user, this.app,this.isMemberStaus});
  final clubEvent.Event exampleEvent;
  final Student user;
  final FirebaseApp app;
  final bool isMemberStaus;
  @override
  _InternalClubEventPageState createState() => _InternalClubEventPageState();
}

class _InternalClubEventPageState extends State<InternalClubEventView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showDialog(String message, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 1)));
  }
  @override
  void initState() {
    super.initState();
    getArgs(widget.exampleEvent, widget.user,widget.isMemberStaus);
  }

  clubEvent.Event passedEvent;
  Student passedStudent;
  bool isMemberStatus;
  getArgs(clubEvent.Event att1, Student att2, bool att3) {
    passedEvent = att1;
    passedStudent = att2;
    isMemberStatus=att3;
  }void isMember(Club passedClub, Student user) async {
    final referenceDB = FirebaseDatabase.instance.reference();
    var members = referenceDB.child("Clubs").child(passedClub.title).child("members");
    await members.once().then((DataSnapshot datasnapshot) {
      var keys = datasnapshot.value.keys;
      for (var key in keys) {
        if (key == user.userID) {
          if (mounted){
            setState((){
              isMemberStatus= true;
            });
          }
          break;
        }
        else {
          isMemberStatus=false;
        }
      }});

  }
bool isRegistered= false;
  void readData() async{
    isMember(passedEvent.hostingClub,passedStudent);
    final referenceDb = FirebaseDatabase.instance.reference();
    var vp = referenceDb.child("ClubEvents").child(passedEvent.hostingClub.title).child(passedEvent.title).child("volunteeringPositions");
   await  vp.once().then((DataSnapshot datasnapshot){
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
      var rm = referenceDb.child("ClubEvents").child(passedEvent.hostingClub.title).child(passedEvent.title).child("registeredMembers");
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
          textAlign: TextAlign.center,
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
                Text(passedEvent.title + ' Event', style: TextStyle(
                  fontSize: 18,
                )),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
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
                            passedEvent.time+
                            '\n' +
                            passedEvent.place,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      passedEvent.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
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
                          if (!isMemberStatus) {
                            _showDialog('Must be member of club', context);
                          } else if (passedEvent.volunteeeringOpportunity.isEmpty) {
                            _showDialog('No Volunteering Position', context);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VolunteerInActivity(
                                          exampleClub: passedEvent.hostingClub,
                                          exampleActivity: passedEvent,
                                          user: passedStudent,type:"ClubEvents"
                                        )));
                          }
                        },
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
        endDrawer: StudentDrawer(user: passedStudent),
      ),
    );
  }
}
