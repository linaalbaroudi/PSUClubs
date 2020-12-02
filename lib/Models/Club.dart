import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';

import 'Student.dart';
import 'Workshop.dart';
import 'Event.dart'as ClubEvent;

class Club {
  FirebaseApp app;
  Faculty _leaderID;
  String _title;
  String _logo;
  String _description;
  List <Student> _members = new List();
  List <ClubEvent.Event> _clubEvents = new List();
  List <Workshop> _workshops = new List();
  Club(this._leaderID, this._title, this._logo, this._description);

  List<Student> get members => _members;

  set members(List<Student> value) {
    _members = value;
  }

  List<ClubEvent.Event> get clubEvents => _clubEvents;

  set clubEvents(List<ClubEvent.Event> value) {
    _clubEvents = value;
  }

  void deleteMember(Club passedClub, Student user) async{
    final referenceDB = FirebaseDatabase.instance.reference();
   await  referenceDB.child("Clubs").child(passedClub.title).child("members").child(user.userID).remove();

  }
  void readMembers() async{
   final referenceDB = FirebaseDatabase.instance.reference();
    var members = referenceDB.child("Clubs").child(this.title).child("members");
   await members.once().then((DataSnapshot datasnapshot) {
      this.members.clear();
      var keys = datasnapshot.value.keys;
      var values = datasnapshot.value;
      for (var key in keys) {
        if (key =="000000000")continue;
        //setState((){
          this.members.add(new Student (key,values[key],key+"@psu.edu.sa"));
        //});

      }
    });
  }
  Image getImage(){
     if (this.logo.contains("https")){
        return Image.network(
          this.logo,
          height: 100,
          width: 100,
          fit: BoxFit.fill,
        );
      }
      else{
        return Image.asset(
          "assets/images/Club1.jpg",
          height: 100,
          width: 100,
          fit: BoxFit.fill,
        );
      }

  }

  void writeMembers(Club passedClub, Student user) async {
    final referenceDB = FirebaseDatabase.instance.reference();
   await referenceDB.child("Clubs").child(passedClub.title).child("members").child(user.userID).set(user.name);
  }


  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get logo => _logo;

  set logo(String value) {
    _logo = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  Faculty get leaderID => _leaderID;

  set leaderID(Faculty value) {
    _leaderID = value;
  }

  bool isMember(PSU_User user) {
    bool _exist = false;
    for (int i = 0; i < members.length; i++) {
      if (members[i] == user) {
        print("The user is a club member");
        _exist = true;
      }
    }
    return _exist;
  }

  @override
  String toString() {
    return 'Club{_title: $_title, _logo: $_logo, _description: $_description}';
  }

  save() async{
    print('Club saved'+toString());
    final referenceDb = FirebaseDatabase.instance.reference();
    print("entered");
   // setState((){
      await referenceDb.child("Clubs").child(this.title).set({
        "description": this.description,
        "leader": this.leaderID.userID,
        "logo": this.logo,
        "members":{
            "000000000":"Name"
        }
      });
  //  });
  }
  saveEdited(String oldTitle) async {
    print('Club saved'+toString());
    final referenceDb = FirebaseDatabase.instance.reference();
    print("entered");
    // setState((){
    await referenceDb.child("Clubs").child(oldTitle).remove();
    await referenceDb.child("Clubs").child(this.title).set({
      "description": this.description,
      "leader": this.leaderID.userID,
      "logo": this.logo,
      "members":{
        "000000000":"Name"
      }
    });
    //  });
  }

  List<Workshop> get workshops => _workshops;

  set workshops(List<Workshop> value) {
    _workshops = value;
  }
}
