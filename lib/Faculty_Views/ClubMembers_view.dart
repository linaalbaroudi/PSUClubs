import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Faculty_Views/Faculty_Drawer.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Student.dart';

class clubMembers extends StatefulWidget {
clubMembers({this.user,this.exampleClub});
final Club exampleClub;
final Faculty user;
@override
_ClubMembersPageState createState() => _ClubMembersPageState();
}

class _ClubMembersPageState extends State<clubMembers> {
  @override
  void initState() {
    super.initState();
    getClub(widget.exampleClub,widget.user);
  }
  Club passedClub;
  Faculty passedUser;
  void getClub(Club att1, Faculty att2){
    passedClub=att1;
    passedUser=att2;
  }
  void readData()async {
    final referenceDB = FirebaseDatabase.instance.reference();
    var members = referenceDB.child("Clubs").child(passedClub.title).child("members");
    await members.once().then((DataSnapshot datasnapshot) {
      passedClub.members.clear();
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;
      for (var key in keys) {
        if (key =="000000000")continue;
        //setState((){
        if(mounted){
          setState(() {
            passedClub.members.add(new Student (key,values[key],key+"@psu.edu.sa"));
          });
        }
        //});

      }
    });

  }
  bool entered = false;
  @override
  Widget build(BuildContext context) {
    if (! entered){
      entered = true;
      readData();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:  Size.fromHeight(60.0),
          child:AppBar(
            backgroundColor: Color(0xff1A033D),
            title:  Row(
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
                Text(passedClub.title+' Club Members'),
              ],


            ),

          ),),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top:8),
              child: Center(
                child: Column(
                  children: <Widget>[

                    Icon(
                      Icons.people,
                      size: 150,
                      color:  Color(0xff1A033D),
                    ),

                    displayMembers(passedClub),
                  ],
                ),
              )
              ,
            ),
          ),
        ),
        endDrawer: FacultyDrawer(user:passedUser),

      ),

    );
  }
}

Container displayMembers(Club club){
  List <PSU_User> members = club.members;
  if (members.length ==0){
    return Container (
      child: Text(
        'No Members to show !',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
  else{
    String membersList ="Members are: \n";
    for (int i =0;i<members.length;i++){
      int ordinal =i+1;
      membersList+=ordinal.toString()+'- '+members[i].name+'\n';
    }
    return Container(
      child: Text(
        membersList,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}

