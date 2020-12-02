import 'package:psu_club/Models/PSU_User.dart';
import 'Club.dart';
import 'Event.dart';
import 'Workshop.dart';

class Faculty extends PSU_User{
//
  List<Club> _createdClubs= new List<Club>();
  List<Event> _createdEvents= new List<Event>();
  List<Workshop> _createdWorkshops= new List<Workshop>();

  Faculty(String FUID,String name, String email):super(FUID,name,email);

  List<Event> get createdEvents => _createdEvents;

  set createdEvents(List<Event> value) {
    _createdEvents = value;
  }

  List<Workshop> get createdWorkshops => _createdWorkshops;

  set createdWorkshops(List<Workshop> value) {
    _createdWorkshops = value;
  }

  List<Club> get createdClubs => _createdClubs;

  set createdClubs(List<Club> value) {
    _createdClubs = value;
  }

  @override
  String toString() {
    return 'Faculty{_createdClubs: $_createdClubs, _createdEvents: $_createdEvents, _createdEvents: $_createdWorkshops}}';
  }
}

