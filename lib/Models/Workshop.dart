import 'package:firebase_database/firebase_database.dart';
import 'package:psu_club/Models/Activity.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Faculty.dart';
import 'package:psu_club/Models/Student.dart';
import 'package:psu_club/Models/VolunteeringPosition.dart';

class Workshop extends Activity {

  Workshop(
      Faculty leader,
      String title,
      String time,
      String place,
      String poster,
      String description,
      String department,
      int noOfSeats,
      Club hostingClub)
      : super( leader, title, time, place, poster, description, department,
            noOfSeats, hostingClub,true);


  @override
  String toString() {
    return 'Workshop{' + super.toString();
  }
  saveEditedWorkshop(String oldTitle,List<String> collectedDates, List<VolunteeringPosition> collectedVP) async{

    this.dates=collectedDates;
    this.volunteeeringOpportunity=collectedVP;
    final referenceDB = FirebaseDatabase.instance.reference();
    await referenceDB.child("ClubWorkshops").child(hostingClub.title).child(oldTitle).remove();
    var _dbClubEvent =
    referenceDB.child("ClubWorkshops").child(hostingClub.title).child(this.title);
    await _dbClubEvent.set({
      "Dates": this.dates,
      "department": this.department,
      "description": this.description,
      "hostingClub": hostingClub.title,
      "leader": this.leader.userID,
      "noOfSeats": this.noOfSeats,
      "place": this.place,
      "time":this.time,
      "poster": this.poster,
      "registeredMembers": {
        "000000000": "Name"
      },});
    for (int i =0;i<volunteeeringOpportunity.length;i++){
      var vp = _dbClubEvent.child("volunteeringPositions").child("VP$i");
      await vp.set({
        "date" : volunteeeringOpportunity[i].date,
        "description" : volunteeeringOpportunity[i].description,
        "noOfPositions" : volunteeeringOpportunity[i].numberOfPositions,
        "time" : volunteeeringOpportunity[i].time,
        "volunteers" : {
          "000000000" : "Name"
        }
      });
    }
    var activities = referenceDB.child("whatIsNew");
    activities.once().then((DataSnapshot dataSnapshot) async {
      var keys = dataSnapshot.value.keys;
      for (var key in keys){
        if (key.toString().contains("ClubWorkshops")) {
         await activities.child(key).remove();
          break;
        }
      }
      await activities.child("ClubWorkshops_"+hostingClub.title).set(this.title);
      //super.save();
    });
    print("Workshop saved " + this.toString());
  }
  save(List<String> collectedDates, List<VolunteeringPosition> collectedVP) async {
    this.dates=collectedDates;
    this.volunteeeringOpportunity=collectedVP;
        final referenceDB = FirebaseDatabase.instance.reference();
        var _dbClubEvent =
        referenceDB.child("ClubWorkshops").child(hostingClub.title).child(this.title);
        await _dbClubEvent.set({
        "Dates": this.dates,
        "department": this.department,
        "description": this.description,
        "hostingClub": hostingClub.title,
        "leader": this.leader.userID,
        "noOfSeats": this.noOfSeats,
        "place": this.place,
        "time":this.time,
        "poster": this.poster,
        "registeredMembers": {
        "000000000": "Name"
        },});
        for (int i =0;i<volunteeeringOpportunity.length;i++){
          var vp = _dbClubEvent.child("volunteeringPositions").child("VP$i");
          await vp.set({
            "date" : volunteeeringOpportunity[i].date,
            "description" : volunteeeringOpportunity[i].description,
            "noOfPositions" : volunteeeringOpportunity[i].numberOfPositions,
            "time" : volunteeeringOpportunity[i].time,
            "volunteers" : {
              "000000000" : "Name"
            }
          });
        }
    var activities = referenceDB.child("whatIsNew");
    activities.once().then((DataSnapshot dataSnapshot) async {
      var keys = dataSnapshot.value.keys;
      for (var key in keys){
        if (key.toString().contains("ClubWorkshops")) {
         await activities.child(key).remove();
          break;
        }
      }
      await activities.child("ClubWorkshops_"+hostingClub.title).set(this.title);
      //super.save();
      });

        print("Workshop saved " + this.toString());
}
  deleteMember(Student passedStudent)async{
    final referenceDB = FirebaseDatabase.instance.reference();
    await referenceDB.child("ClubWorkshops").child(this.hostingClub.title).child(this.title).child("registeredMembers").child(passedStudent.userID).remove();
  }
  addMember(Student passedStudent)async{
    final referenceDB = FirebaseDatabase.instance.reference();
   await referenceDB.child("ClubWorkshops").child(this.hostingClub.title).child(this.title).child("registeredMembers").child(passedStudent.userID).set(passedStudent.name);
  }
}
