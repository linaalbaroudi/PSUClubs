import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/AboutUs_view.dart';
import 'package:psu_club/General_Views/Guest_Drawer.dart';
import 'package:psu_club/General_Views/Profile_view.dart';
import 'package:psu_club/General_Views/bottomtab_screen.dart';
import 'package:psu_club/Models/Event.dart' as psuEvent;
import 'package:psu_club/Models/Activity.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/Workshop.dart';

import 'InternalClubEvent_view.dart';
import 'InternalEvent_view.dart';
import 'InternalWorkshop_view.dart';

class HomeScreenPage extends StatelessWidget {
  static const routeName = '/home-screens';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Color(0xff1A033D),
          title: Text('PSUClubs'),
        ),
      ),
      body: SingleChildScrollView(
        child: HomeScreen(),
      ),
      endDrawer: GuestDrawer(),
    ));
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({this.app});
  final FirebaseApp app;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _controller =
      PageController(initialPage: 0, viewportFraction: 0.8);
  List<Activity> latest = new List();
  final textFieldController = TextEditingController(text: 'Search');
  void readData() async {
    if(latest.length<3){
      var referenceDb =  FirebaseDatabase.instance.reference();
      var activities = referenceDb.child("whatIsNew");
      await activities.once().then((DataSnapshot dataSnapshot) async {
        var keys = dataSnapshot.value.keys;
        var values = dataSnapshot.value;
        for (var key in keys){
          if (key.toString().contains("ClubWorkshops")){
            String clubTitle= key.toString().substring("ClubWorkshops".length+1);
            var recentWorkshop = referenceDb.child("ClubWorkshops").child(clubTitle).child(values[key]);
           await recentWorkshop.once().then((DataSnapshot dataSnapshot1) {
              if (dataSnapshot1.value!=null){
                var values1 = dataSnapshot1.value;
                Workshop currentW = new Workshop(new Faculty(values1["leader"],"",""),values[key],values1["time"],values1["place"],values1["poster"],values1["description"],values1["department"],values1["noOfSeats"],new Club(new Faculty(values1["leader"],"",""),values1["hostingClub"],"",""));
                for (int i = 0; i < values1["Dates"].length; i++) {
                  currentW.dates.add(values1["Dates"][i]);
                }
                if (mounted)
                  setState(() {
                    latest.add(currentW);

                  });
              }


            });
          }else if (key.toString().contains("ClubEvents")){
            String clubTitle= key.toString().substring("clubEvents".length+1);
            var recentClubEvent = referenceDb.child("ClubEvents").child(clubTitle).child(values[key]);
            await recentClubEvent.once().then((DataSnapshot dataSnapshot2) {
              if (dataSnapshot2.value!= null){
                var values1 = dataSnapshot2.value;
                psuEvent.Event currentEv = new psuEvent.Event(new Faculty(values1["leader"],"",""),values[key],values1["time"],values1["place"],values1["poster"],values1["description"],values1["department"],values1["noOfSeats"],new Club(new Faculty(values1["leader"],"",""),values1["hostingClub"],"",""),values1["registrationStatus"]);
                currentEv.dates.add(values1["dates"]);
                if (mounted)
                  setState(() {
                    latest.add(currentEv);
                  });
              }
            });
          }else{
            var recentUniEvent = referenceDb.child("UniEvents").child(values[key]);
            await recentUniEvent.once().then((DataSnapshot dataSnapshot3) {
              if (dataSnapshot3.value!=null){
                var values1 = dataSnapshot3.value;
                psuEvent.Event currentEv =new psuEvent.Event(new Faculty(values1["leader"],"",""),values[key],values1["time"],values1["place"],values1["poster"],values1["description"],values1["department"],values1["noOfSeats"],null,values1["registrationStatus"]);
                currentEv.dates.add(values1["dates"]);
                if (mounted)
                  setState(() {
                    latest.add(currentEv); });   }


            });
          }
        }
      });}
  }
  GestureDetector displayLatest(List<Activity> latest, int i ){
    if (latest.isEmpty)return GestureDetector();
    Activity activity = latest[i];
    if (activity.poster.contains("https")){
      return GestureDetector(
        onTap:(){
          if (activity is psuEvent.Event && activity.hostingClub==null)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalEventView(
                      exampleEvent: activity)),
            );
          else if (activity is psuEvent.Event )
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalClubEventView(
                      exampleEvent: activity)),
            );
          else
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalWorkshopView(
                      exampleWorkshop: activity)),
            );
        },
        child: Image.network(
          activity.poster,
          height: 150,
          width: 150,
          fit: BoxFit.fill,

        ),
      );
    }
    else{
      return GestureDetector(
        onTap:(){
          if (activity is psuEvent.Event && activity.hostingClub==null)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalEventView(
                      exampleEvent: activity)),
            );
          else if (activity is psuEvent.Event )
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalClubEventView(
                      exampleEvent: activity)),
            );
          else
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InternalWorkshopView(
                      exampleWorkshop: activity)),
            );
        },
        child: Image.asset(
          "assets/images/Club1.jpg",
          height: 150,
          width: 150,
          fit: BoxFit.fill,
        ),
      );
    }

  }
  Widget textFieldSearch() {
    return Container(
      child: TextField(
        controller: textFieldController,
        decoration: InputDecoration(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
            hintText: 'Search'),
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildContainer(Widget childButton) {
    return Container(
      padding: EdgeInsets.all(20),
      child: CircleAvatar(
        backgroundColor: Color(0xff1A033D),
        child: childButton,
      ),
    );
  }

  Widget buildGridView() {
    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: 2,
      ),
      children: <Widget>[
        _buildContainer(
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomTabsScreen(
                            index: 1,
                          )));
            },
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.supervisor_account,
                  color: Colors.white,
                  size: 45,
                ),
                Text(
                  'Clubs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildContainer(FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomTabsScreen(
                          index: 2,
                        )));
          },
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Icon(
                Icons.event_note,
                color: Colors.white,
                size: 45,
              ),
              Text(
                'Events',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        )),
        _buildContainer(
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomTabsScreen(
                            index: 3,
                          )));
            },
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.local_play,
                  color: Colors.white,
                  size: 45,
                ),
                Text(
                  'Certificates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildContainer(
          FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileView()));
            },
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.account_box,
                  color: Colors.white,
                  size: 45,
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool entered =false;
  @override
  Widget build(BuildContext context) {
    if (!entered){
      entered = true;
      readData();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldSearch(),
        Divider(
          thickness: 2,
        ),
        Text(
          'What is new?',
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 400,
                child: PageView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    for(int i=0;i<latest.length;i++)
                      displayLatest(latest, i),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(40),
          child: buildGridView(),
        )
      ],
    );
  }
}
