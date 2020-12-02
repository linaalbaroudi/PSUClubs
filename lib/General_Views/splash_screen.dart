import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import '../widget/splash_widget.dart';
import '../General_Views/main_screen.dart';

class SplashScreen extends StatefulWidget {
  // SplashScreen({this.app});
  // final FirebaseApp app;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  // FirebaseApp app;
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   app=widget.app;
  // }
  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
      context: context,
      gotoWidget: MainScreen(),
      splashscreenWidget: SplashScreenWidget(),
      timerInSeconds: 3,
    );
  }
}