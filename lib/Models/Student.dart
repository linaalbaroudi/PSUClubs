import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:psu_club/Models/PSU_User.dart';
import 'package:psu_club/Models/Certificate.dart';
import 'package:psu_club/Models/Club.dart';
import 'package:psu_club/Models/Activity.dart';

// ignore: camel_case_types
class Student extends PSU_User{

  List<Club> _registeredClubs = new List<Club>();
  List<Activity> _registeredActivities=new List<Activity>();
  List<Certificates> _earnedCertificates=new List<Certificates>();

  Student(String SID,String name, String email):super(SID,name,email);

  List<Certificates> get earnedCertificates => _earnedCertificates;

  set earnedCertificates(List<Certificates> value) {
    _earnedCertificates = value;
  }

  List<Object> get registeredActivities => _registeredActivities;

  set registeredActivities(List<Object> value) {
    _registeredActivities = value;
  }

  List<Object> get registeredClubs => _registeredClubs;

  set registeredClubs(List<Object> value) {
    _registeredClubs = value;
  }


  @override
  String toString() {
    return 'Student:name: '+name+'id: '+userID+' email: '+email;
  }
}