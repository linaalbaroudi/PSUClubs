import 'package:firebase_database/firebase_database.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:string_validator/string_validator.dart';

import 'Activity.dart';
import 'Club.dart';
import 'Student.dart';

class VolunteeringPosition{
  String key;
 String _time;
  String _date;
  String _description;
  int _numberOfPositions;
  List<Student> _volunteers =new List();

  VolunteeringPosition(this.key,this._time, this._date, this._description,
      this._numberOfPositions);

  List<Student> get volunteers => _volunteers;

  set volunteers(List<Student> value) {
    _volunteers = value;
  }




  int get numberOfPositions => _numberOfPositions;

  set numberOfPositions(int value) {
    _numberOfPositions = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

 String get time => _time;

  set time(String value) {
    _time = value;
  }
bool isVolunteer(Student student){
    for(int i = 0;i<volunteers.length;i++){
        if(volunteers[i].key==(student.key)) {
          return true;
        }
        }
    return false;
}
 void deleteMember(String type,Club hostingClub,Activity activity, Student user)async {
   this.volunteers.remove(user);
   final referenceDB = FirebaseDatabase.instance.reference();
   if (hostingClub!= null)
    await referenceDB.child(type).child(hostingClub.title).child(activity.title).child("volunteeringPositions").child(key).child("volunteers").child(user.userID).remove();
   else
    await referenceDB.child(type).child(activity.title).child("volunteeringPositions").child(key).child("volunteers").child(user.userID).remove();
 }

 void writeMembers(String type,Club hostingClub,Activity activity, Student user) async{
    volunteers.add(user);
   final referenceDB = FirebaseDatabase.instance.reference();
   if (hostingClub!= null)
     await referenceDB.child(type).child(hostingClub.title).child(activity.title).child("volunteeringPositions").child(key).child("volunteers").child(user.userID).set(user.name);
   else
     await referenceDB.child(type).child(activity.title).child("volunteeringPositions").child(key).child("volunteers").child(user.userID).set(user.name);
 }
  @override
  String toString() {
    return 'VolunteeringPosition{_time: $_time, _date: $_date, _description: $_description, _numberOfPositions: $_numberOfPositions,  _volunteers: $_volunteers}';
  }
}