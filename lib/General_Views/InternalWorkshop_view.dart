import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/AboutUs_view.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Workshop.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/General_Views/Clubevents_view.dart';
import 'package:psu_club/General_Views/Workshops_view.dart';

import 'Guest_Drawer.dart';

class InternalWorkshopView extends StatefulWidget {
  static const routeName = '/Internal-workshop-view';
  InternalWorkshopView({this.exampleWorkshop});
  final Workshop exampleWorkshop;
  _InternalWorkshopPageState createState() => _InternalWorkshopPageState();
}

class _InternalWorkshopPageState extends State<InternalWorkshopView> {
  @override
  void initState() {
    super.initState();
    getWorkshop(widget.exampleWorkshop);
  }
  Workshop passedWorkshop;
  void getWorkshop(Workshop att2){
    passedWorkshop=att2;
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
                Text(passedWorkshop.title,style: TextStyle(
                    fontSize: 18),),

              ],
            ),
          ),),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top:15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left:15),
                    ),
                    passedWorkshop.getImage(),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(

                      child:  Text(
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
                  height:30,
                ),

                SizedBox(
                  height:30,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: Text( passedWorkshop.description,
                      style: TextStyle(
                          fontSize: 18),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height:50,
                      width:350,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color(0xff1A033D),
                        onPressed: (){
                          Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                        },
                        child: Text(
                          'Login to Volunteer or Register!',
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
        endDrawer: GuestDrawer(),
      ),
    );
  }
}
