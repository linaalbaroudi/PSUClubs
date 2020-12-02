import 'dart:io' as io;
import 'package:firebase_database/firebase_database.dart';
import 'package:psu_club/Models/Faculty.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Certificates {
  String _generator;
  io.File _file;
  String _url;
  String _studentID;
  String _date;
  String _title;

  Certificates(
      this._generator, this._url, this._studentID, this._date, this._title);

  String get generator => _generator;

  set generator(String value) {
    _generator = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get studentID => _studentID;

  set studentID(String value) {
    _studentID = value;
  }

  io.File get file => _file;

  set file(io.File value) {
    _file = value;
  }

  String get getURL => _url;

  set setURL (String value) {
    _url = value;
  }


  @override
  String toString() {
    return 'Certificates{ _studentID: $_studentID, _date: $_date, _title: $_title, _url: $_url, _file: $_file}';
  }

  io.File getFile() {
    // if (this._file.contains("https")) {
    return this._file;
    //  } else {}
  }

  save() async {
    print('Certificate saved' + toString());
    final referenceDb = FirebaseDatabase.instance.reference();
    await referenceDb
        .child("Certificates")
        .child(this._studentID + "_" + this._title)
        .set({
      "title": this._title,
      "studentID": this._studentID,
      "date": this._date,
      "generator": this._generator,
      "pdf": getURL
    });
  }
}
