import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';
import 'package:psu_club/Models/Workshop.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Student_Views/AboutUs_view.dart';
import 'package:psu_club/Student_Views/Profile_view.dart';
import 'package:psu_club/Student_Views/VolunteerInActivity_view.dart';
import 'package:psu_club/Student_Views/Workshops_view.dart';

import 'Student_drawer.dart';

PSU_User anees = new Faculty('AAra', 'Anees Ara', 'aara@psu.edu.sa');
PSU_User std = new Student('123456789', 'Tala AM', '123456789@psu.edu.sa');


class InternalWorkshopView extends StatefulWidget {
  static const routeName = '/Internal-workshop-view';
  InternalWorkshopView({this.exampleWorkshop, this.user, this.isMemberStatus});

  final Workshop exampleWorkshop;
  final Student user;
  final bool isMemberStatus;
  @override
  _InternalWorkshopViewState createState() => _InternalWorkshopViewState();
}


class _InternalWorkshopViewState extends State<InternalWorkshopView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getArgs(widget.exampleWorkshop, widget.user,widget.isMemberStatus);
  }

  Workshop passedWorkshop;
  Student passedStudent;
  bool isMemberStatus;
  void getArgs(Workshop att1, Student att2,bool att3) {
    passedStudent = att2;
    passedWorkshop = att1;
    isMemberStatus= att3;
  }
  void _showDialog(String message, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 1)));
  }
  void isMember(Club passedClub, Student user) async {
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
  bool isRegistered = false;
void readData() async{
  isMember(passedWorkshop.hostingClub,passedStudent);
  final referenceDb = FirebaseDatabase.instance.reference();
  var vp = referenceDb.child("ClubWorkshops").child(passedWorkshop.hostingClub.title).child(passedWorkshop.title).child("volunteeringPositions");
  await vp.once().then((DataSnapshot datasnapshot){
    passedWorkshop.volunteeeringOpportunity.clear();
    var keys = datasnapshot.value.keys;
    var values = datasnapshot.value;
    for (var key1 in keys ){
      if (mounted){
        setState(() {
          passedWorkshop.volunteeeringOpportunity.add(new VolunteeringPosition(key1,values[key1]["date"],values[key1]["time"],values[key1]["description"],values[key1]["noOfPositions"]));

        });
      }
    }
  });
  var rm = referenceDb.child("ClubWorkshops").child(passedWorkshop.hostingClub.title).child(passedWorkshop.title).child("registeredMembers");
  await rm.once().then((DataSnapshot datasnapshot2){
    passedWorkshop.registeredMembers.clear();
    var keys2 = datasnapshot2.value.keys;
    var values2 = datasnapshot2.value;
    for (var key2 in keys2 ){
      if (key2=="000000000")continue;
      if (mounted){
        setState(() {
          passedWorkshop.registeredMembers.add(new Student(key2,values2[key2],values2[key2]+"@psu.edu.sa"));
          if (key2 ==passedStudent.userID) isRegistered=true;
        });
      }
    }
  });
}

  //bool isVolunteer = false;
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
                Text(passedWorkshop.title , style: TextStyle (fontSize: 18)),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      passedWorkshop.getImage(),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          passedWorkshop.title +
                              '\n Dates are: \n' +
                              passedWorkshop.dates.toString() +
                              '\n' +
                              passedWorkshop.time.toString() +
                              '\n' +
                              passedWorkshop.place,
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
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.topLeft,
                    child: Text(
                      passedWorkshop.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height:20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 150,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            //for now keep like this

                            if (passedWorkshop.noOfSeats <=
                                passedWorkshop.registeredMembers.length&&!isRegistered) {
                              _showDialog(
                                  'Registration Seats are full! ', context);
                            } else if (isRegistered) {
                              _showDialog('Cancelled Successfully', context);
                              setState(() {
                                passedWorkshop.registeredMembers.remove(passedStudent);
                                passedWorkshop.deleteMember(passedStudent);
                                isRegistered = !isRegistered;
                              });
                            } else {
                              _showDialog('Successfully Registered! ', context);
                              setState(() {
                                passedWorkshop.registeredMembers.add(passedStudent);
                                passedWorkshop.addMember(passedStudent);
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
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        height: 50,
                        width: 150,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xff1A033D),
                          onPressed: () {
                            //for now keep like this
                            if (!isMemberStatus) {
                              _showDialog('Must be member of club', context);
                            } else if (passedWorkshop.volunteeeringOpportunity.isEmpty) {
                              _showDialog('No Volunteering Position', context);}
                            else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VolunteerInActivity(
                                    exampleClub: passedWorkshop.hostingClub,
                                    exampleActivity: passedWorkshop,
                                    user: passedStudent,type:"ClubWorkshops"
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Volunteer',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ), //Volunteer
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
