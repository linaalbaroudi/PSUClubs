import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Activity.dart';
import 'package:psu_club/Models/Event.dart' as psuEvent;
import 'package:psu_club/Models/Student.dart';
import 'package:flutter/cupertino.dart';
import 'package:psu_club/Models/Workshop.dart';
import 'package:psu_club/Student_Views/AboutUs_view.dart';
import 'package:psu_club/Student_Views/Student_drawer.dart';

List<Club> registeredClubs = new List();
List<Activity> registeredActivities = new List();
//display joined clubs
PageController _controller =
PageController(initialPage: 0, viewportFraction: 0.8);

InkWell _enrolledClubs(Club club) {
  return InkWell(
    onTap: () => null,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color(0xFFF19F42),
      margin: EdgeInsets.all(14),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                club.title + ' Club',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.network(
                    club.logo,
                    height: 92,
                    width: 50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


InkWell _joinedActivities(Activity act) {
  return InkWell(
    onTap: () => null,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color(0xFFF19F42),
      margin: EdgeInsets.all(14),
      elevation: 4,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${act.title}\n${act.dates[0]} ${act.time}',
                //  textAlign:TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.asset(
                  (act is psuEvent.Event)?'assets/images/event.png':'assets/images/workshop.png',
                    height: 92,
                    //
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class ProfileView extends StatefulWidget {
  static const routeName = '/ProfileView';
  ProfileView({this.user});
  final Student user;
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    getUser(widget.user);
  }

  Student passedStudent;
  void getUser(Student att2) {
    passedStudent = att2;
  }

  void readRegisteredClub() async {
    final referenceDB = FirebaseDatabase.instance.reference();
    var clubs =  referenceDB.child("Clubs");
     await clubs.once().then((DataSnapshot datasnapshot) async  {
        var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;
      for (var key1 in keys) {
        var members = referenceDB.child("Clubs").child(key1).child("members");
        await members.once().then((DataSnapshot datasnapshot2) {
          var keys = datasnapshot2.value.keys;
          for (var key in keys) {
            if (key == passedStudent.userID) {
              if (mounted){
                setState((){
                  registeredClubs.add(new Club (null,key1,values[key1]["logo"],values[key1]["description"]));

                });
              }
              break;
            }}});
      }

  });}

  void readRegisteredClubActivity() async{

    final referenceDB = FirebaseDatabase.instance.reference();
    //list all existing clubs titles
    var clubs = referenceDB.child("Clubs");
    List<String> clubNames = new List();
    await clubs.once().then((DataSnapshot d0){
      var k0 = d0.value.keys;
      for (var k in k0){
        if (mounted)
        setState(() {
          clubNames.add(k);
        });

      }
    });
    for (int i = 0; i < clubNames.length; i++) {
      //registered Club Workshops
      var clubActivities = referenceDB.child("ClubWorkshops").child(clubNames[i]);
      await clubActivities.once().then((DataSnapshot datasnapshot) async {
       if (datasnapshot.value!=null){
          var keys = datasnapshot.value.keys;
          var values = datasnapshot.value;
          for (var key in keys) {
            var current = clubActivities.child(key).child("registeredMembers");
            await current.once().then((DataSnapshot d2){
              var keys2= d2.value.keys;
              if (keys2.toString().contains(passedStudent.userID)){
                if (mounted)
                  setState(() {
                Workshop currentW = new Workshop(
                    null, key, values[key]["time"],
                    values[key]["place"],
                    values[key]["poster"],
                    values[key]["description"],
                    values[key]["department"],
                    values[key]["noOfSeats"],
                   null);
                for (int i = 0; i < values[key]["Dates"].length; i++) {
                  currentW.dates.add(values[key]["Dates"][i]);
                }

                registeredActivities.add(currentW);
                  });
              }
            });
          }}});
      clubActivities = referenceDB.child("ClubEvents").child(clubNames[i]);
      await clubActivities.once().then((DataSnapshot datasnapshot2) async {
        if (datasnapshot2.value!= null) {
          var keys = datasnapshot2.value.keys;
          var values = datasnapshot2.value;
          for (var key in keys) {
            if (values[key]["registrationStatus"]==true){
              var current = clubActivities.child(key).child("registeredMembers");
              await  current.once().then((DataSnapshot d2){
                  var keys2 = d2.value.keys;
                    if (keys2.toString().contains(passedStudent.userID))
                      if (mounted){
                        setState(() {
                          psuEvent.Event currentEv = new psuEvent.Event(
                              null,
                              key,
                              values[key]["time"],
                              values[key]["place"],
                              values[key]["poster"],
                              values[key]["description"],
                              values[key]["department"],
                              values[key]["noOfSeats"],
                              null,
                              values[key]["registrationStatus"]);
                          currentEv.dates.add( values[key]["dates"]);
                          registeredActivities.add(currentEv);
                        });
                      }

                });
            }

          }
        }
      });
    } var clubActivityRegistrants = referenceDB.child("UniEvents");
    await clubActivityRegistrants.once().then((DataSnapshot datasnapshot) async{
        var keys = datasnapshot.value.keys;
        var values = datasnapshot.value;
        for (var key in keys) {
          if (values[key]["registrationStatus"]==true){
            await clubActivityRegistrants.child(key).child("registeredMembers").once().then((DataSnapshot datasnapshot2){
              if (datasnapshot2.value!=null){
                var keys2 = datasnapshot2.value.keys;
                 if (keys2.contains(passedStudent.userID)){
                   if (mounted) {
                     setState(() {
                       psuEvent.Event currentEv = new psuEvent.Event(
                           null,
                           key,
                           values[key]["time"],
                           values[key]["place"],
                           values[key]["poster"],
                           values[key]["description"],
                           values[key]["department"],
                           values[key]["noOfSeats"],
                           null,
                           values[key]["registrationStatus"]);
                       currentEv.dates.add( values[key]["dates"]);
                       registeredActivities.add(currentEv);
                     });
                   }
                  }   }});
          }

      }});
  }

  Row displayClubs(){
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200,
            child: PageView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0;
                i <registeredClubs.length;
                i++)
                  _enrolledClubs(registeredClubs[i]),
              ],
            ),
          ),
        ),
      ],);
  }
  Row displayRegisteredAct() {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200,
            child: PageView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0;
                i <registeredActivities.length;
                i++)
                  _joinedActivities(registeredActivities[i]),
              ],
            ),
          ),
        ),
      ],);
  }
bool done = false;
  @override
  Widget build(BuildContext context) {
  if (done ==false){
    done = true;
    registeredClubs.clear();
    registeredActivities.clear();
    readRegisteredClub();
    readRegisteredClubActivity();


  }


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
                  passedStudent.name + ' Profile ',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: ListView(
              children: [
                Container(
                  color: Color(0xff1A033D),
                  height: 300,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/images/avatarIcon.jpg'),
                          radius: 50,
                        ),
                        SizedBox(height: 8),
                        Card(
                          elevation: 7,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'Name: ${passedStudent.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.person, //assignment_ind_rounded,
                                  color: Color(0xFFF19F42),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Email: ${passedStudent.email}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.email,
                                  color: Color(0xFFF19F42),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'PSU ID: ${passedStudent.userID}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.calendar_today, //wysiwyg_outlined,
                                  color: Color(0xFFF19F42),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'Joined Clubs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                displayClubs(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'Joined Activities',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                displayRegisteredAct(),
              ],
            ),
          ),
        ),
        endDrawer: StudentDrawer(user: passedStudent),
      ),
    );
  }
}
