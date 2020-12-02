import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:psu_club/General_Views/InternalClub_view.dart';
import 'package:psu_club/General_Views/clubs_view.dart';
import 'package:psu_club/General_Views/home_view.dart';
import 'package:psu_club/Faculty_Views/FacultyHome_view.dart';
import 'package:psu_club/General_Views/Event_view.dart';
import 'package:psu_club/General_Views/Certificates_view.dart';
import 'package:psu_club/General_Views/Profile_view.dart';
import 'package:psu_club/Student_Views/home_view.dart';
import 'package:psu_club/Student_Views/bottomtab_screen.dart';
import 'General_Views/bottomtab_screen.dart';
import 'Faculty_Views/bottomtab_screen.dart';
import './General_Views/splash_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  runApp(MaterialApp(
    title: 'Flutter Database Example',
    home: MyApp(),
  ));
}
class MyApp extends StatefulWidget {
  // MyApp({this.app});
  // final FirebaseApp app;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PSUClubs',
      theme: ThemeData(
        primaryColor: Color(0xff1A033D),
        accentColor: Colors.white,
        backgroundColor: const Color(0xffe7e6e1),
      ),
      routes: {
        '/': (ctx) => SplashScreen(),
        BottomTabsScreen.routeName: (ctx) => BottomTabsScreen(),
        HomeScreenPage.routeName: (ctx) => HomeScreenPage(),
        ClubsScreen.routeName: (ctx) => ClubsScreen(),
        EventView.routeName: (ctx) => EventView(),
        CertificateView.routeName: (ctx) => CertificateView(),
        ProfileView.routeName: (ctx) => ProfileView(),
        InternalClubsView.routeName: (ctx) => InternalClubsView(),
        FacultyHomeScreenPage.routeName: (ctx) => FacultyHomeScreenPage(),
        BottomTabsScreen2.routeName: (ctx) => BottomTabsScreen2(),
        StudentHomeScreenPage.routeName: (ctx) => StudentHomeScreenPage(),
        BottomTabsScreen3.routeName: (ctx) => BottomTabsScreen3(),
      },
    );
  }
}

