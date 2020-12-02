import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/ActivityParticipants_view.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Event.dart' as clubEvent;
import 'package:psu_club/Faculty_Views/Clubevents_view.dart';

import 'EditClubEvent_view.dart';

class InternalClubEventView extends StatefulWidget {
  static const routeName = '/Internal-club-event-view';
  InternalClubEventView({this.exampleEvent, this.user});
  final clubEvent.Event exampleEvent;
  final Faculty user;

  @override
  _InternalClubEventPageState createState() => _InternalClubEventPageState();
}

class _InternalClubEventPageState extends State<InternalClubEventView> {
  void initState() {
    super.initState();
    getArgs(widget.exampleEvent, widget.user);
  }

  clubEvent.Event passedEvent;
  Faculty passedUser;
  void getArgs(clubEvent.Event att1, Faculty att2) {
    passedUser = att2;
    passedEvent = att1;
  }
  Row ownerButtons() {
    if (passedEvent.leader.userID != passedUser.userID)
      return Row();
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // edit event
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
                          builder: (context) => EditClubEvent(
                            user: passedUser,
                            passedEvent: passedEvent,
                          )));
                },
                child: FittedBox(
                                  child: Text(
                    'Edit Club Event',
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
                          builder: (context) => ActivityParticipants(
                              exampleActivity: passedEvent,
                              user: passedUser,
                              type: "ClubEvents")));
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
          // delete
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
                  _confirmDeleteDialog(context, passedEvent, passedUser);
                },
                child: FittedBox(
                                  child: Text(
                    'Delete \nEvent',
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

        ],
      );
  }

  @override
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
                Text(passedEvent.title + ' Event', style: TextStyle(
                    fontSize: 18),),
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
                    Padding(
                      padding: EdgeInsets.only(left: 8),
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
                ownerButtons(),
              ],
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user: passedUser),
      ),
    );
  }
}

void _showDialog3(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Deleting Club Event...'),
    duration: Duration(seconds: 3),
  ));
}

Future<void> _confirmDeleteDialog(BuildContext ctx, clubEvent.Event passedEvent, Faculty passedUser) async {
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
            onPressed: ()async {
              passedEvent.hostingClub.clubEvents.remove(passedEvent);
              final referenceDB = FirebaseDatabase.instance.reference();
             await referenceDB.child("ClubEvents").child(passedEvent.hostingClub.title).child(passedEvent.title).remove();
              _showDialog3(ctx);
              //database issue
              Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (ctx) => Clubevents(
                          exampleClub: passedEvent.hostingClub,
                          user: passedUser)));
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
