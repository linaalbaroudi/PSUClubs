import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Faculty_Views/Clubevents_view.dart';
import 'package:psu_club/Faculty_Views/Workshops_view.dart';
import 'package:psu_club/Faculty_Views/ClubMembers_view.dart';
import 'EditClub_view.dart';
import 'bottomtab_screen.dart';

class InternalClubsView extends StatefulWidget {
  static const routeName = '/Internal-clubs-view';
  InternalClubsView({this.user, this.exampleClub});
  final Club exampleClub;
  final Faculty user;
  @override
  _InternalClubPageState createState() => _InternalClubPageState();
}

class _InternalClubPageState extends State<InternalClubsView> {
  @override
  void initState() {
    super.initState();
    getClub(widget.user, widget.exampleClub);
  }

  Club passedClub;
  Faculty passedUser;
  void getClub(Faculty att1, Club att2) {
    passedClub = att2;
    passedUser = att1;
  }

  Row ownerButtons() {
    if (passedClub.leaderID.userID != passedUser.userID)
      return Row();
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // edit
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
                          builder: (context) => EditClub_View(
                                user: passedUser,
                                passedClub: passedClub,
                              )));
                },
                child: FittedBox(
                  child: Text(
                    'Edit Club',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            width: 10,
          ),
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
                          builder: (context) => clubMembers(
                                user: passedUser,
                                exampleClub: passedClub,
                              )));
                },
                child: FittedBox(
                                  child: Text(
                      'View \nMembers',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
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
                  _confirmDeleteDialog(context, passedUser, passedClub);
                },
                child: FittedBox(
                                  child: Text(
                    'Delete Club',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
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
                Text(passedClub.title + ' page'),
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
                      Expanded(
                        child: Text(
                          passedClub.title + '\n',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ownerButtons(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.topLeft,
                    child: Text(
                      passedClub.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 120),
                  Column(
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
                                      user: passedUser)),
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
                                      user: passedUser)),
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
                  )
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
    BuildContext ctx, Faculty passedUser, Club passedClub) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text('Are you sure ? '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this club ? '),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () async {
              final referenceDB = FirebaseDatabase.instance.reference();
              await referenceDB.child("Clubs").child(passedClub.title).remove();
              await referenceDB
                  .child("ClubEvents")
                  .child(passedClub.title)
                  .remove();
              await referenceDB
                  .child("ClubWorkshops")
                  .child(passedClub.title)
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
