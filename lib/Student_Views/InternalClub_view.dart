import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Student_Views/Clubevents_view.dart';
import 'package:psu_club/Student_Views/Student_drawer.dart';
import 'package:psu_club/Student_Views/Workshops_view.dart';
import 'package:firebase_database/firebase_database.dart';

void _showDialog(String message, BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class InternalClubsView extends StatefulWidget {
  static const routeName = '/Internal-clubs-view';
  InternalClubsView({this.exampleClub, this.user, this.app});
  final Club exampleClub;
  final Student user;
  final FirebaseApp app;
  @override
  _InternalClubPageState createState() => _InternalClubPageState();
}

class _InternalClubPageState extends State<InternalClubsView> {
  void initState() {
    super.initState();
    getClub(widget.exampleClub, widget.user);
  }

  Club passedClub;
  Student passedStudent;
  void getClub(Club att1, Student att2) {
    passedClub = att1;
    passedStudent = att2;
  }
  bool isMemberStatus = false;
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

  RaisedButton btjoin (){
    return RaisedButton(

      shape: RoundedRectangleBorder(
        side: BorderSide.none,

        borderRadius: BorderRadius.circular(10),),
      onPressed: () {
        setState((){
          passedClub.writeMembers(passedClub,passedStudent);
          _showDialog('Successfully joined club!', context);
          isMemberStatus= true;
        });
      },
      child: Text(
        "Join club",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      color: Color(0xff1A033D),
    );
  }
  RaisedButton btleave(){
    return RaisedButton(
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.red,
      onPressed: () {
        setState((){
          passedClub.deleteMember(passedClub,passedStudent);
          _showDialog('Successfully left club!', context);
          isMemberStatus= false;
        });
      },
      child: Text(
        "leave club",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    isMember(passedClub,passedStudent);
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
                Text('InternalClubs'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      passedClub.getImage(),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        passedClub.title + ' Club \n',
                        style: TextStyle(
                          fontSize: 20,
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
                      Container(
                        height: 50,
                        width: 300,
                        child: (!isMemberStatus)?btjoin(): btleave(),
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
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.topLeft,
                          child: Text(
                            passedClub.description,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height:150,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Card(
                        color: Colors.white70,
                        margin: EdgeInsets.zero,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Clubevents(
                                        exampleClub: passedClub,
                                        user: passedStudent,
                                    isMemberStatus: isMemberStatus,
                                      )),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              'Club Events',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white70,
                        margin: EdgeInsets.zero,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkshopsView(
                                        exampleClub: passedClub,
                                        user: passedStudent, isMemberStatus:isMemberStatus
                                      )),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              'Club Workshops',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
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
        endDrawer: StudentDrawer(user: passedStudent),
      ),
    );
  }
}
