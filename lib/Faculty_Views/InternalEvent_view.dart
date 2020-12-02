import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Event.dart' as UniEvent;
import 'package:psu_club/Faculty_Views/ActivityParticipants_view.dart';
import 'EditUniEvent.dart';
import 'bottomtab_screen.dart';

Future<void> _confirmDeleteDialog(
    UniEvent.Event passedEvent, BuildContext ctx, Faculty passedUser) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text('Are you sure ? '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this event ? '),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                final referenceDB = FirebaseDatabase.instance.reference();
               await referenceDB
                    .child("UniEvents")
                    .child(passedEvent.title)
                    .remove();
                Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (context) =>
                            BottomTabsScreen2(index: 2, user: passedUser)));
              }),
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

class InternalEventView extends StatefulWidget {
  static const routeName = '/Internal-event-view';
  InternalEventView({this.exampleEvent, this.user});
  final UniEvent.Event exampleEvent;
  final Faculty user;
  @override
  _InternalEventViewState createState() => _InternalEventViewState();
}

class _InternalEventViewState extends State<InternalEventView> {
  void initState() {
    super.initState();
    getArgs(widget.exampleEvent, widget.user);
  }

  UniEvent.Event passedEvent;
  Faculty passedUser;
  void getArgs(UniEvent.Event att1, Faculty att2) {
    passedUser = att2;
    passedEvent = att1;
  }

  Row ownerButton() {
    if (passedEvent.leader.userID != passedUser.userID) {
      return Row();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //edit unievent
          Expanded(
            child: Container(
              height: 40,
              width: 290,
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
                          builder: (context) => EditUniEvent(
                              user: passedUser, passedEvent: passedEvent)));
                },
                child: FittedBox(
                                  child: Text(
                    'Edit Event',
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
          // view Participants
          Expanded(
            child: Container(
              height: 40,
              width: 290,
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
                              type: "UniEvents")));
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

          // delete unievent
          Expanded(
            child: Container(
              height: 40,
              width: 290,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.red,
                onPressed: () {
                  _confirmDeleteDialog(passedEvent, context, passedUser);
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
                Text(
                  passedEvent.title + ' Event',
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
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          passedEvent.description,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
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
