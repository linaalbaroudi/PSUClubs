import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';
import 'package:photo_view/photo_view.dart';

class Activity {
  Faculty _leader;
  String _title;
  String _time;
  String _place;
  String _poster;
  String _description;
  String _department;
  int _noOfSeats;
  Club _hostingClub;
  bool _registrationStatus;
  List<String> _dates = new List();

  List<VolunteeringPosition> _volunteeeringOpportunity = new List();

  Club get hostingClub => _hostingClub;

  set hostingClub(Club value) {
    _hostingClub = value;
  }

  List<String> get dates => _dates;

  set dates(List<String> value) {
    _dates = value;
  }
  void readVP(String type) async{
    final referenceDB = FirebaseDatabase.instance.reference();
    if (type =="UniEvents"){
      var vp = referenceDB.child(type).child(this._title).child("volunteeringPositions");
      await vp.once().then((DataSnapshot datasnapshot) {
        this._volunteeeringOpportunity.clear();
        var keys = datasnapshot.value.keys;
        var values = datasnapshot.value;
        for (var key in keys) {
          this._volunteeeringOpportunity.add(new VolunteeringPosition(key,values[key]["time"],values[key]["date"],values[key]["description"],values[key]["noOfPositions"]));
        }});}
         else{
      var vp = referenceDB.child(type).child(this.hostingClub.title).child(this._title).child("volunteeringPositions");
      await  vp.once().then((DataSnapshot datasnapshot) {
        this._volunteeeringOpportunity.clear();
        var keys = datasnapshot.value.keys;
        var values = datasnapshot.value;
        for (var key in keys) {
          this._volunteeeringOpportunity.add(new VolunteeringPosition(key,values[key]["time"],values[key]["date"],values[key]["description"],values[key]["noOfPositions"]));
        }
      });
    }

  }
  Container getImage(){
    if (this.poster.contains("https")){
      return Container(
        height:297,
        width:210,
        child: ClipRect(
          child: PhotoView(
            imageProvider: NetworkImage(
              this.poster,
            ),
            maxScale: PhotoViewComputedScale.covered * 2.0,
            minScale: PhotoViewComputedScale.contained * 0.8,
            initialScale: PhotoViewComputedScale.covered,
          ),
        ),
      );
    }
    else{
      return Container(
        height:297,
        width:210,
        child: ClipRect(
          child: PhotoView(
            imageProvider: AssetImage(
              "assets/images/poster0.jpg",
            ),
            maxScale: PhotoViewComputedScale.covered * 2.0,
            minScale: PhotoViewComputedScale.contained * 0.8,
            initialScale: PhotoViewComputedScale.covered,
          ),
        ),
      );
    }

  }
  List<PSU_User> _volunteers = new List();
  List<PSU_User> _registeredMembers = new List();

  Activity( this._leader,
      this._title,
      this._time,
      this._place,
      this._poster,
      this._description,
      this._department,
      this._noOfSeats,
      this._hostingClub,
      this._registrationStatus);

  List<PSU_User> get registeredMembers => _registeredMembers;

  set registeredMembers(List<PSU_User> value) {
    _registeredMembers = value;
  }

  bool get registrationStatus => _registrationStatus;

  set registrationStatus(bool value) {
    _registrationStatus = value;
  }

  List<PSU_User> get volunteers => _volunteers;

  set volunteers(List<PSU_User> value) {
    _volunteers = value;
  }

  List<VolunteeringPosition> get volunteeeringOpportunity =>
      _volunteeeringOpportunity;

  set volunteeeringOpportunity(List<VolunteeringPosition> value) {
    _volunteeeringOpportunity = value;
  }

  int get noOfSeats => _noOfSeats;

  set noOfSeats(int value) {
    _noOfSeats = value;
  }

  String get department => _department;

  set department(String value) {
    _department = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get poster => _poster;

  set poster(String value) {
    _poster = value;
  }

  String get place => _place;

  set place(String value) {
    _place = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  Faculty get leader => _leader;

  set leader(Faculty value) {
    _leader = value;
  }


  @override
  String toString() {
    return '_leader: $_leader, _title: $_title,_time: $_time, _place: $_place, _poster: $_poster, _description: $_description, _department: $_department, _noOfSeats: $_noOfSeats, _volunteeeringOpportunity: $_volunteeeringOpportunity,  _volunteers: $_volunteers}';
  }

  bool isVolunteer(Student x) {
    for (int i = 0; i < volunteers.length; i++) {
      if (volunteers[i].userID == x.userID) return true;
    }
    return false;
  }

  bool isRegistered(Student x) {
    for (int i = 0; i < registeredMembers.length; i++) {
      if (registeredMembers[i].userID == x.userID) return true;
    }
    return false;
  }
  Future<List<Object>> readActivity(String type) async {
    List<String> currentActivity = new List();
    final referenceDB = FirebaseDatabase.instance.reference();
    var activity =
    referenceDB.child(type).child(this.hostingClub.title).child(this.title);
    await activity.once().then((DataSnapshot datasnapshot) {
      var keys = datasnapshot.value.keys;
      var value = datasnapshot.value;
      for (var key in keys) {
        Activity act = new Activity(
            key,
            null,
            key,
            value[key]["time"],
            value[key]["place"],
            value[key]["poster"],
            value[key]["description"],
            value[key]["department"],
            value[key]["noOfSeats"],
            true);
        for (int i = 0; i < value[key]["Dates"].length; i++) {
          this.dates.add(value[key]["Dates"][i]);
        }
        currentActivity.add(act.title);
      }
    });

    return currentActivity;
  }

  Future<List<Object>> readUniActivity() async {
    List<String> currentActivity = new List();
    final referenceDB = FirebaseDatabase.instance.reference();
    var activity = referenceDB
        .child("UniEvents")
        .child(this.hostingClub.title)
        .child(this.title);
    await activity.once().then((DataSnapshot datasnapshot) {
      var keys = datasnapshot.value.keys;
      var value = datasnapshot.value;
      for (var key in keys) {
        Activity act = new Activity(
            key,
            null,
            key,
            value[key]["time"],
            value[key]["place"],
            value[key]["poster"],
            value[key]["description"],
            value[key]["department"],
            value[key]["noOfSeats"],
            true);
        for (int i = 0; i < value[key]["Dates"].length; i++) {
          this.dates.add(value[key]["Dates"][i]);
        }
        currentActivity.add(act.title);
      }
    });

    return currentActivity;
  }

  Future<List<Object>> readRegistered(Student passedStudent, String type) async {
    List<String> currentRegistered = new List();
    final referenceDB = FirebaseDatabase.instance.reference();
    var activity = referenceDB
        .child(type)
        .child(this.hostingClub.title)
        .child(this.title)
        .child("registeredMembers");
    await activity.once().then((DataSnapshot datasnapshot) {
      var keys = datasnapshot.value.keys;
      var value = datasnapshot.value;
      for (var key in keys) {
        if (key == "000000000") continue;
        currentRegistered.add(key);
      }
    });
    return currentRegistered;
  }


}
