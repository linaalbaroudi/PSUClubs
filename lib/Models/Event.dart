import 'package:firebase_database/firebase_database.dart';
import 'package:psu_club/Models/Activity.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';

import 'Student.dart';

class Event extends Activity {
  Event(
      Faculty leader,
      String title,
      String time,
      String place,
      String poster,
      String description,
      String department,
      int noOfSeats,
      Club hostingClub,
      bool registrationStatus)
      : super( leader, title, time, place, poster, description, department,
            noOfSeats,hostingClub, registrationStatus);


  @override
  String toString() {
    return 'Event{' + super.toString() ;  }

  @override
  saveClubEvents() async {
    final referenceDB = FirebaseDatabase.instance.reference();
    var _dbClubEvent =
    referenceDB.child("ClubEvents").child(hostingClub.title).child(this.title);
    await _dbClubEvent.set({
      "dates": this.dates[0],
      "department": this.department,
      "description": this.description,
      "hostingClub": hostingClub.title,
      "leader": this.leader.userID,
      "noOfSeats": this.noOfSeats,
      "place": this.place,
      "poster": this.poster,
      "time":this.time,
      "registrationStatus": this.registrationStatus,
      "registeredMembers": {
        "000000000": "Name"
      },
      "volunteeringPositions": {
        "VP0": {
              "date": super.volunteeeringOpportunity[0].date,
              "description": super.volunteeeringOpportunity[0].description,
              "noOfPositions": super.volunteeeringOpportunity[0].numberOfPositions,
              "time": super.volunteeeringOpportunity[0].time,
              "volunteers": {
                "000000000": "Name"
              }
            }
          }

    });
    var activities = referenceDB.child("whatIsNew");
    activities.once().then((DataSnapshot dataSnapshot) async {
      var keys = dataSnapshot.value.keys;
      for (var key in keys){
        if (key.toString().contains("ClubEvents")) {
           await activities.child(key).remove();
           break;
        }
        }
      await activities.child("ClubEvents_"+hostingClub.title).set(this.title);
    //super.save();
    print("Event saved " + this.toString());});

  }

  saveClubEventsEdited(String oldTitle) async {
    final referenceDB = FirebaseDatabase.instance.reference();
    print(oldTitle);
   await referenceDB.child("ClubEvents").child(hostingClub.title).child(oldTitle).remove();
    var _dbClubEvent =
    referenceDB.child("ClubEvents").child(hostingClub.title).child(this.title);
    await _dbClubEvent.set({
      "dates": this.dates[0],
      "department": this.department,
      "description": this.description,
      "hostingClub": hostingClub.title,
      "leader": this.leader.userID,
      "noOfSeats": this.noOfSeats,
      "place": this.place,
      "poster": this.poster,
      "time":this.time,
      "registrationStatus": this.registrationStatus,
      "registeredMembers": {
        "000000000": "Name"
      },
      "volunteeringPositions": {
        "VP0": {
          "date": super.volunteeeringOpportunity[0].date,
          "description": super.volunteeeringOpportunity[0].description,
          "noOfPositions": super.volunteeeringOpportunity[0].numberOfPositions,
          "time": super.volunteeeringOpportunity[0].time,
          "volunteers": {
            "000000000": "Name"
          }
        }
      }

    });
    var activities = referenceDB.child("whatIsNew");
    activities.once().then((DataSnapshot dataSnapshot) async {
      var keys = dataSnapshot.value.keys;
      for (var key in keys){
        if (key.toString().contains("ClubEvents")) {
         await activities.child(key).remove();
          break;
        }
      }
      await activities.child("ClubEvents_"+hostingClub.title).set(this.title);
      //super.save();
      print("Event saved " + this.toString());});
    //super.save();
    print("Event saved " + this.toString());
  }
  saveUniEventsEdited(String oldTitle) async {
    final referenceDB = FirebaseDatabase.instance.reference();
    await referenceDB.child("UniEvents").child(oldTitle).remove();
    var _dbClubEvent =
    referenceDB.child("UniEvents").child(this.title);
    await _dbClubEvent.set({
      "dates": this.dates[0],
      "department": this.department,
      "description": this.description,
      "leader": this.leader.userID,
      "noOfSeats": this.noOfSeats,
      "place": this.place,
      "poster": this.poster,
      "time":this.time,
      "registrationStatus": this.registrationStatus,
      "registeredMembers": {
        "000000000": "Name"
      },
      "volunteeringPositions": {
        "VP0": {
          "date": super.volunteeeringOpportunity[0].date,
          "description": super.volunteeeringOpportunity[0].description,
          "noOfPositions": super.volunteeeringOpportunity[0].numberOfPositions,
          "time": super.volunteeeringOpportunity[0].time,
          "volunteers": {
            "000000000": "Name"
          }
        }
      }

    });
    var activities = referenceDB.child("whatIsNew");
    activities.once().then((DataSnapshot dataSnapshot) async {
      var keys = dataSnapshot.value.keys;
      for (var key in keys){
        if (key.toString().contains("UniEvents")) {
         await  activities.child(key).remove();
          break;
        }
      }
      await activities.child("UniEvents").set(this.title);
      //super.save();
      print("Event saved " + this.toString());});
    //super.save();
    print("Event saved " + this.toString());
  }
  @override
  saveUniEvents() async {
    final referenceDB = FirebaseDatabase.instance.reference();
    var _dbClubEvent =
    referenceDB.child("UniEvents").child(this.title);
    await _dbClubEvent.set({
      "dates": this.dates[0],
      "department": this.department,
      "description": this.description,
      "leader": this.leader.userID,
      "noOfSeats": this.noOfSeats,
      "place": this.place,
      "poster": this.poster,
      "time":this.time,
      "registrationStatus": this.registrationStatus,
      "registeredMembers": {
        "000000000": "Name"
      },
      "volunteeringPositions": {
        "VP0": {
          "date": super.volunteeeringOpportunity[0].date,
          "description": super.volunteeeringOpportunity[0].description,
          "noOfPositions": super.volunteeeringOpportunity[0].numberOfPositions,
          "time": super.volunteeeringOpportunity[0].time,
          "volunteers": {
            "000000000": "Name"
          }
        }
      }

    });
    var activities = referenceDB.child("whatIsNew");
    activities.once().then((DataSnapshot dataSnapshot) async {
      var keys = dataSnapshot.value.keys;
      for (var key in keys){
        if (key.toString().contains("UniEvents")) {
          await activities.child(key).remove();
          break;
        }
      }
      await activities.child("UniEvents").set(this.title);
      //super.save();
      print("Event saved " + this.toString());});
    //super.save();
    print("Event saved " + this.toString());
  }
  deleteMember(Student passedStudent) async{
    final referenceDB = FirebaseDatabase.instance.reference();
    if (this.hostingClub!=null)
   await referenceDB.child("ClubEvents").child(this.hostingClub.title).child(this.title).child("registeredMembers").child(passedStudent.userID).remove();
    else
      await referenceDB.child("UniEvents").child(this.title).child("registeredMembers").child(passedStudent.userID).remove();
  }
  addMember(Student passedStudent) async{
    final referenceDB = FirebaseDatabase.instance.reference();
    if(this.hostingClub!=null)
   await referenceDB.child("ClubEvents").child(this.hostingClub.title).child(this.title).child("registeredMembers").child(passedStudent.userID).set(passedStudent.name);
    else
     await referenceDB.child("UniEvents").child(this.title).child("registeredMembers").child(passedStudent.userID).set(passedStudent.name);
  }
}
