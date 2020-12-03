import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Workshop.dart';
import 'package:psu_club/Faculty_Views/ActivityParticipants_view.dart';
import 'package:psu_club/Faculty_Views/Workshops_view.dart';
import 'EditWorkshop.dart';
import 'bottomtab_screen.dart';

class InternalWorkshopView extends StatefulWidget {
  static const routeName = '/Internal-workshop-view';
  InternalWorkshopView({this.exampleWorkshop, this.user, this.app});
  final Workshop exampleWorkshop;
  final Faculty user;
  final FirebaseApp app;
  @override
  _InternalWorkshopPageState createState() => _InternalWorkshopPageState();
}

class _InternalWorkshopPageState extends State<InternalWorkshopView> {
  void initState() {
    super.initState();
    getArgs(widget.exampleWorkshop, widget.user);
  }

  Workshop passedWorkshop;
  Faculty passedUser;
  Club hostingClub;
  void getArgs(Workshop att1, Faculty att2) {
    passedUser = att2;
    passedWorkshop = att1;
    hostingClub=passedWorkshop.hostingClub;
  }

  Row ownerButton() {
    if (passedWorkshop.leader.userID != passedUser.userID) {
      return Row();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Delete Workshop
          Expanded(
            child: Container(
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
                          builder: (context) => EditClubWorkshop(
                              exampleClub: passedWorkshop.hostingClub,
                              passedWorkshop: passedWorkshop,
                              user: passedUser)));
                },
                child: FittedBox(
                  child: Text(
                    'Edit Workshop',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          // View Participants
          Expanded(
            child: Container(
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
                          builder: (context) => ActivityParticipants(
                              exampleActivity: passedWorkshop,
                              user: passedUser,
                              type: "ClubWorkshops")));
                },
                child: FittedBox(
                  child: Text(
                    'View \nParticipants',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          // Delete Workshop
          Expanded(
            child: Container(
              height: 50,
              width: 300,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.red,
                onPressed: () {
                  _confirmDeleteDialog(passedWorkshop, context, passedUser,hostingClub);
                },
                child: FittedBox(
                  child: Text(
                    'Delete \nWorkshop',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75.0),
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
                Text(
                  passedWorkshop.title,
                  style: TextStyle(fontSize: 18),
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
                    height: 60,
                  ),
                  Container(
                    // padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      passedWorkshop.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ownerButton(),
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


Future<void> _confirmDeleteDialog(
    Workshop passedWorkshop, BuildContext ctx, Faculty passedUser,Club hosting) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text('Are you sure ? '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this club event ? '),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () async {
              passedWorkshop.hostingClub.workshops.remove(passedWorkshop);
              final referenceDB = FirebaseDatabase.instance.reference();
              await referenceDB
                  .child("ClubWorkshops")
                  .child(hosting.title)
                  .child(passedWorkshop.title)
                  .remove();
            Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (context) =>
                          BottomTabsScreen2(index: 1, user: passedUser)));
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      );
    },
  );
}

