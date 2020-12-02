import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Guest_Drawer.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/General_Views/Clubevents_view.dart';
import 'package:psu_club/General_Views/Workshops_view.dart';

class InternalClubsView extends StatefulWidget {
  static const routeName = '/Internal-clubs-view';

  InternalClubsView({this.exampleCl, this.app});
  final Club exampleCl;
  final FirebaseApp app;

  @override
  _InternalClubViewState createState() => _InternalClubViewState();
}

class _InternalClubViewState extends State<InternalClubsView> {
  void initState() {
    super.initState();
    getClub(widget.exampleCl);
  }

  Club passedClub;
  void getClub(Club att2) {
    passedClub = att2;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
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
                Text(passedClub.title + 'Club'),
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
                          passedClub.title + ' Club\n',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 300,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xff1A033D),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          },
                          child: Text(
                            'Login to join!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
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
                      passedClub.description,
                      style: TextStyle(fontSize:18),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        passedClub: passedClub,
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
                                  builder: (context) =>
                                      WorkshopsView(exampleClub: passedClub)),
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
        endDrawer: GuestDrawer(),
      ),
    );
  }
}
