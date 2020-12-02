import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/AboutUs_view.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Activity.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Event.dart'as PSUevent;
import 'package:psu_club/Models/Workshop.dart';


class ProfileView extends StatefulWidget {
  static const routeName = '/ProfileView';
  ProfileView({this.user});
  final Faculty user;
  _profileState createState() => _profileState();

}

class _profileState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    getUser(widget.user);
  }
  Faculty passedUser;
  void getUser(Faculty att2){
    passedUser=att2;
  }

  void readData() async{

    final referencedb = FirebaseDatabase.instance.reference();
    final referencedb0 = FirebaseDatabase.instance.reference();
    var clubTitle = referencedb0.child("Clubs");
    await clubTitle.once().then((DataSnapshot datasnapshot) {
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;
      for (var key in keys) {
        if (passedUser.userID == values[key]["leader"]) {
          Club club = new Club(
              passedUser, key, values[key]["logo"], values[key]["description"]);
          if (mounted)
            setState(() {
              passedUser.createdClubs.add(club);
            });
        }

      }
    });
    List<Club> currentClub = passedUser.createdClubs;
    for (int i = 0; i < currentClub.length; i++) {
      var activity = referencedb.child("ClubWorkshops").child(currentClub[i].title);
     await activity.once().then((DataSnapshot datasnapshot) {
        if (datasnapshot.value!=null){
          var keys = datasnapshot.value.keys;
          var values = datasnapshot.value;
          for (var key in keys) {
            Activity ws = new Workshop( passedUser,
                key,
                values[key]["time"],
                values[key]["place"],
                values[key]["poster"],
                values[key]["description"],
                values[key]["department"],
                values[key]["noOfSeats"],
                currentClub[i]);
            for (int i = 0; i < values[key]["Dates"].length; i++) {
              ws.dates.add(values[key]["Dates"][i]);
            }
            if (passedUser.userID == values[key]["leader"]) {
              if (mounted)
                setState(() {
                  passedUser.createdWorkshops.add(ws);
                });
            }
          }
        }

      });
      activity = referencedb.child("ClubEvents").child(currentClub[i].title);
      await activity.once().then((DataSnapshot datasnapshot) {
        if (datasnapshot.value!=null){
          var keys = datasnapshot.value.keys;
          var values = datasnapshot.value;
          for (var key in keys) {
          if (passedUser.userID == values[key]["leader"]) {
            Activity clubEvent = new PSUevent.Event(
                passedUser,
                key,
                values[key]["time"],
                values[key]["place"],
                values[key]["poster"],
                values[key]["description"],
                values[key]["department"],
                values[key]["noOfSeats"],
                currentClub[i],
                values[key]["registrationStatus"]);
            clubEvent.dates.add( values[key]["dates"]);
            if (mounted)
              setState(() {
                passedUser.createdEvents.add(clubEvent);
              });
          }
        }}

      });
    }
    var uniActivity = referencedb.child("UniEvents");
    await uniActivity.once().then((DataSnapshot datasnapshot) {
      if (datasnapshot.value!=null){
        var keys = datasnapshot.value.keys;
        var values = datasnapshot.value;
        for (var key in keys) {
          if (passedUser.userID == values[key]["leader"]) {
            Activity unievent = new PSUevent.Event(
                passedUser,
                key,
                values[key]["time"],
                values[key]["place"],
                values[key]["poster"],
                values[key]["description"],
                values[key]["department"],
                values[key]["noOfSeats"],
                null,
                values[key]["registrationStatus"]);
            unievent.dates.add( values[key]["dates"]);
            if (mounted)
              setState(() {
                passedUser.createdEvents.add(unievent);
              });

          }
        }
      }

    });
  }
  bool entered = false;
  @override
  Widget build(BuildContext context) {

    if (!entered){
      passedUser.createdClubs.clear();
      passedUser.createdEvents.clear();
      passedUser.createdWorkshops.clear();
      entered= true;
      readData();
    }

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
                Text(passedUser.name+' Profile '),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                color :Color(0xff1A033D),
                height:300,
                child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatarIcon.jpg'),
                        radius:50,
                      ),
                      SizedBox(height: 8),
                      Card(
                        elevation: 7,
                        child: Column(
                          children:[
                            ListTile(
                              title:Text('Name: ${passedUser.name}',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),),
                              leading: Icon(
                                Icons.assignment_ind_rounded,
                                color: Color(0xFFF19F42),
                              ),),
                            ListTile(
                              title:Text('Email: ${passedUser.email}',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),),
                              leading: Icon(
                                Icons.email,
                                color: Color(0xFFF19F42),
                              ),),
                            ListTile(
                              title:Text('PSU ID: ${passedUser.userID}',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),),
                              leading: Icon(
                                Icons.wysiwyg_outlined,
                                color: Color(0xFFF19F42),
                              ),),

                          ],
                        ),


                      ),

                    ]),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  'Hosted Clubs',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: PageView(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (int i = 0;
                          i < passedUser.createdClubs.length;
                          i++)
                            _enrolledClubs(passedUser.createdClubs[i]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  'Hosted Events',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: PageView(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (int i = 0;
                          i < passedUser.createdEvents.length;
                          i++)
                            _joinedActivities(
                                passedUser.createdEvents[i]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  'Hosted Workshops',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: PageView(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (int i = 0;
                          i < passedUser.createdWorkshops.length;
                          i++)
                            _joinedActivities(
                                passedUser.createdWorkshops[i])
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        endDrawer: FacultyDrawer(user:passedUser),
      ),
    );
  }
}


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
            alignment:Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                club.title.contains('club')?club.title+'club':club.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                child:Container(
                  width: double.infinity,
                  color:Colors.white,
                  child: Image.network(
                    club.logo,
                    height: 92,
                    //fit: BoxFit.fill,
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
                '${act.title}\n${act.dates[0]}  ${act.time}\n',
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
                  color:Colors.white,
                  child:Image.asset(
                    (act is Workshop)?'assets/images/workshop.png':'assets/images/event.png',
                    height: 92,
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