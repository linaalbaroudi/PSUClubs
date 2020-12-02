import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/AboutUs_view.dart';
import 'package:psu_club/General_Views/Guest_Drawer.dart';
import 'package:psu_club/General_Views/main_screen.dart';
class ProfileView extends StatelessWidget {
  static const routeName = '/ProfileView';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xff1A033D),
            title: Text(' Profile'),
            ),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Icon(
                Icons.dangerous,
                size: 200,
                color: Colors.red,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xff1A033D),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                },
                child: Text(
                  'Login to View Profile!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),

                ),
              ),
            ],
          ),
        ),
        endDrawer: GuestDrawer(),
      ),
    );
  }
}
