import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/FacultyHome_view.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Student_Views/home_view.dart';
import '../sign_in.dart';
import 'home_view.dart';
import 'package:string_validator/string_validator.dart';
import 'package:psu_club/Models/PSU_User.dart';

class MainScreen extends StatefulWidget {
  // MainScreen({this.app});
  // final FirebaseApp app;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  // FirebaseApp app;
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   app=widget.app;
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0XFFFFFAF9),
        body: SingleChildScrollView(          
          child: Container(
            alignment: Alignment.center,
            child: Column(

              children: [
                SizedBox(
                  height: 75,
                ),
                Image.asset(
                  'assets/images/PSUClubs.gif',
                  height: 500,
                  width: 400,
                ),

                _signInButton(),

                FlatButton(
                  child: Text('Or Continue as a guest',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff1A033D),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenPage()));
                  },
                )
              ],
            ),
          ),
        ));
  }

Widget _signInButton() {
  return OutlineButton(
    splashColor: Colors.grey,
    onPressed: () {
      signInWithGoogle().then((result) {
        if (result != null) {
          if (isAlpha(result.email[0])){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return FacultyHomeScreenPage(user:result);
                },
              ),
            );
          }
          else{
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StudentHomeScreenPage(user:result);
              },
            ),
          );
        }}else{
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Login failed, please try again later')));
        }
      });
    },
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    ),
  );
}}