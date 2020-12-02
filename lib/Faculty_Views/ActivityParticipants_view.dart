import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/AboutUs_view.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Faculty_Views/Profile_view.dart';
import 'package:psu_club/General_Views/main_screen.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Activity.dart';
import 'package:psu_club/Models/Student.dart';

class ActivityParticipants extends StatefulWidget {
  @override
  ActivityParticipants({this.exampleActivity, this.user, this.type});
  final Activity exampleActivity;
  final Faculty user;
  final String type;
  _ActivityParticipantsState createState() => _ActivityParticipantsState();
}

class _ActivityParticipantsState extends State<ActivityParticipants> {
  @override
  void initState() {
    super.initState();
    getArgs(widget.exampleActivity,widget.user,widget.type);

  }
  Activity passedActivity;
  Faculty passedUser;
  String type;

  void getArgs(Activity att1, Faculty att2, String att3){
    passedUser = att2;
    passedActivity= att1;
    type=att3;
  }

  void readData()async{
    final referenceDB = FirebaseDatabase.instance.reference();
    if (passedActivity.hostingClub!=null){
      var clubActivityVolun = referenceDB.child(type).child(passedActivity.hostingClub.title).child(passedActivity.title).child("volunteeringPositions");
      await clubActivityVolun.once().then((DataSnapshot datasnapshot)async {
        passedActivity.volunteers.clear();
        var keys = datasnapshot.value.keys;
        for (var key in keys) {
          var volunPositions = clubActivityVolun.child(key).child("volunteers");
          await volunPositions.once().then((DataSnapshot datasnapshot2){
            var keys2 = datasnapshot2.value.keys;
            var values2 = datasnapshot2.value;
            for (var key2 in keys2){
              if (key2 =="000000000")continue;
              if(mounted){
                setState(() {
                  passedActivity.volunteers.add(new Student (key2,values2[key2],key2+"@psu.edu.sa"));
                });
              }
            }
          }); }
      });
      if (passedActivity.registrationStatus!=false){
        var clubActivityRegistrants=referenceDB.child(type).child(passedActivity.hostingClub.title).child(passedActivity.title).child("registeredMembers");
        await clubActivityRegistrants.once().then((DataSnapshot datasnapshot){
          passedActivity.registeredMembers.clear();
          var keys = datasnapshot.value.keys;
          var values = datasnapshot.value;
          for (var key in keys){
            if (key =="000000000")continue;
            if(mounted){
              setState(() {
                passedActivity.registeredMembers.add(new Student (key,values[key],key+"@psu.edu.sa"));
              });
            }
          }
        });
      }
    }
    else{
      var uniEventVolun = referenceDB.child(type).child(passedActivity.title).child("volunteeringPositions");
      await uniEventVolun.once().then((DataSnapshot datasnapshot) async {
        passedActivity.volunteers.clear();
        var keys = datasnapshot.value.keys;
        for (var key in keys) {
          var volunPositions = uniEventVolun.child(key).child("volunteers");
         await volunPositions.once().then((DataSnapshot datasnapshot2){
            var keys2 = datasnapshot2.value.keys;
            var values2 = datasnapshot2.value;
            for (var key2 in keys2){
              if (key2 =="000000000")continue;
              if(mounted){
                setState(() {
                  passedActivity.volunteers.add(new Student (key2,values2[key2],key2+"@psu.edu.sa"));
                });
              }
            }
          }); }
      });
      if (passedActivity.registrationStatus!=false){
        var clubActivityRegistrants=referenceDB.child(type).child(passedActivity.title).child("registeredMembers");
        await clubActivityRegistrants.once().then((DataSnapshot datasnapshot){
          passedActivity.registeredMembers.clear();
          var keys = datasnapshot.value.keys;
          var values = datasnapshot.value;
          for (var key in keys){
            if (key =="000000000")continue;
            if(mounted){
              setState(() {
                passedActivity.registeredMembers.add(new Student (key,values[key],key+"@psu.edu.sa"));
              });
            }
          }
        });
      }
    }
read = false;
  }
  bool read = false;
  Widget build(BuildContext context) {
    if (!read){
      read = true;
      readData();
    }

    return  MaterialApp(
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
                Text(passedActivity.title+'  Participants',
                style: TextStyle(
                  fontSize: 14,
                ),
                ),
              ],
          ),),),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top:8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Icon(
                        Icons.people,
                        size: 150,
                        color:  Color(0xff1A033D),
                      ),

                      displayVolunteers(passedActivity),

                      SizedBox(
                        height:20,
                        child: Divider(
                          color: Color(0xff1A033D),

                        ),
                        width: 200,
                      ),
                      if(passedActivity.registrationStatus == true)
                        displayRegisteredMembers(passedActivity),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user:passedUser),
      ),

    );
  }
}

Container displayVolunteers(Activity passedEvent){
  List <PSU_User> volunteers = passedEvent.volunteers;
  if (volunteers.length ==0){
    return Container (
      child: Text(
        'No Volunteers to show !',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
  else{
    String membersList ="Volunteers are: \n";
    List<String> passedV = new List();
    for (int i =0;i<volunteers.length;i++){
      if(passedV.contains(volunteers[i].name))continue;
      passedV.add(volunteers[i].name);
      int ordinal =passedV.indexOf(volunteers[i].name)+1;
      membersList+=ordinal.toString()+'- '+volunteers[i].name+'\n';
    }
    return Container(
      child: Text(
        membersList,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
Container displayRegisteredMembers(Activity passedActivity){
  List <PSU_User> RMembers = passedActivity.registeredMembers;
  if (RMembers.length ==0){
    return Container (
      child: Text(
        'No Registered Members to show !',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
  else{
    String membersList ="Registered Members are: \n";
    for (int i =0;i<RMembers.length;i++){
      int ordinal =i+1;
      membersList+=ordinal.toString()+'- '+RMembers[i].name+'\n';
    }
    return Container(
      child: Text(
        membersList,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
