import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/AboutUs_view.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Event.dart';
import 'package:psu_club/General_Views/main_screen.dart';

import 'Guest_Drawer.dart';

class InternalEventView extends StatefulWidget {
  static const routeName = '/Internal-event-view';
InternalEventView({this.exampleEvent});
final Event exampleEvent;
  @override

  _InternalEventPageState createState() => _InternalEventPageState();
  }

  class _InternalEventPageState extends State<InternalEventView> {
  @override
  Event passedEvent;
  void initState() {
    // TODO: implement initState
    super.initState();
    getEvent(widget.exampleEvent);
  }
  void getEvent(Event att2){
    passedEvent=att2;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child:AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Row(
              children:<Widget>[
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
                  ),),
              ],
            ), ),),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:15),
                      ),
                      passedEvent.getImage(),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child:  Text(
                          passedEvent.title+'\n'+passedEvent.dates[0]+'\n'+passedEvent.time+'\n'+passedEvent.place,
                          style: TextStyle(
                            fontSize:20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height:30,
                  ),
                  Row(
                    children:<Widget>[
                      Expanded(
                        child: Container(
                          // padding: EdgeInsets.all(10),
                          alignment: Alignment.topLeft,
                          child: Text( passedEvent.description,
                            style: TextStyle(
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height:30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[
                      Container(
                        height:50,
                        width:300,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xff1A033D),
                          onPressed: (){
                            Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                          },
                          child: Text(
                            'Login to Volunteer!',
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
        endDrawer: GuestDrawer(),
      ),
    );
  }
}
